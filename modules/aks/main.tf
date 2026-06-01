# Log Analytics Workspace for Container Insights# ------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "law" {
  name                = var.law_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# ------------------------------------------------------------
# Azure Monitor Workspace for Managed Prometheus
# ------------------------------------------------------------
resource "azurerm_monitor_workspace" "amw" {
  name                = var.amw_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

# ------------------------------------------------------------
# Azure Managed Grafana
# ------------------------------------------------------------
resource "azurerm_dashboard_grafana" "grafana" {
  name                              = var.grafana_name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  grafana_major_version = "12"
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = false
  public_network_access_enabled     = true

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.amw.id
  }
}

# Allow Grafana to read Azure Monitor Workspace metrics
resource "azurerm_role_assignment" "grafana_monitoring_reader" {
  scope                = azurerm_monitor_workspace.amw.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.grafana.identity[0].principal_id
}

# ------------------------------------------------------------
# Azure Container Registry
# ------------------------------------------------------------
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = false
}

# ------------------------------------------------------------
# AKS Cluster
# ------------------------------------------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "sample-aks-demo"

  kubernetes_version = var.kubernetes_version
  sku_tier           = "Standard"

  # Network configuration
  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  # Default/System node pool
  default_node_pool {
    name                 = "systemnp"
    vm_size              = var.vm_size
    zones                = var.zones

    # Automatic scaling
    auto_scaling_enabled = true
    min_count            = var.min_count
    max_count            = var.max_count

    # Public IP per node enabled
    node_public_ip_enabled = true

    os_disk_size_gb = var.os_disk_size
    type            = "VirtualMachineScaleSets"
  }

  # System-assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  # Container Insights
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }

  # Managed Prometheus metrics addon
  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = null
  }

  # Image Cleaner
  image_cleaner_enabled        = true
  image_cleaner_interval_hours = var.image_cleaner_interval

  role_based_access_control_enabled = true

  depends_on = [
    azurerm_monitor_workspace.amw,
    azurerm_log_analytics_workspace.law
  ]
}

# ------------------------------------------------------------
# Grant AKS permission to pull images from ACR
# ------------------------------------------------------------
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
