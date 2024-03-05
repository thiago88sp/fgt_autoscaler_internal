resource "azurerm_resource_group" "res-0" {
  location = var.location
  name     = var.resource_group_name
  tags = {
    Source     = "terraform"
    #Created_on = formatdate("YYYY-MM-DDTHH:MM:SSZ", timestamp())
  }
}
resource "azurerm_linux_virtual_machine_scale_set" "res-1" {
  admin_password                  = var.admin_password
  admin_username                  = "azureadmin"
  disable_password_authentication = false
  location                        = var.location
  name                            = "${var.prefix_name}-vmss-byol001"
  overprovision                   = false
  resource_group_name             = var.resource_group_name
  single_placement_group          = false
  sku                             = "Standard_F4"
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.res-29.primary_blob_endpoint
  }
  data_disk {
    caching              = "None"
    disk_size_gb         = 30
    lun                  = 1
    storage_account_type = "Standard_LRS"
  }
  network_interface {
    enable_ip_forwarding = true
    name                 = "nic-config-subnet1"
    primary              = true
    ip_configuration {
      name      = "ip-config-subnet1"
      subnet_id = azurerm_subnet.res-26.id
    }
  }
  network_interface {
    enable_ip_forwarding = true
    name                 = "nic-config-subnet2"
    ip_configuration {
      name      = "ip-config-subnet2"
      subnet_id = azurerm_subnet.res-28.id
    }
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  plan {
    name      = "fortinet_fg-vm"
    product   = "fortinet_fortigate-vm_v5"
    publisher = "fortinet"
  }
  source_image_reference {
    offer     = "fortinet_fortigate-vm_v5"
    publisher = "fortinet"
    sku       = "fortinet_fg-vm"
    version   = "7.2.6"
  }
  depends_on = [
    azurerm_subnet.res-28,
    # One of azurerm_subnet.res-26,azurerm_subnet_network_security_group_association.res-27 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_linux_virtual_machine_scale_set" "res-2" {
  admin_password                  = var.admin_password
  admin_username                  = "azureadmin"
  disable_password_authentication = false
  location                        = var.location
  name                            = "${var.prefix_name}-vmss-payg001"
  overprovision                   = false
  resource_group_name             = var.resource_group_name
  single_placement_group          = false
  sku                             = "Standard_F4"
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.res-29.primary_blob_endpoint
  }
  data_disk {
    caching              = "None"
    disk_size_gb         = 30
    lun                  = 1
    storage_account_type = "Standard_LRS"
  }
  network_interface {
    enable_ip_forwarding = true
    name                 = "nic-config-subnet1"
    primary              = true
    ip_configuration {
      name      = "ip-config-subnet1"
      subnet_id = azurerm_subnet.res-26.id
    }
  }
  network_interface {
    enable_ip_forwarding = true
    name                 = "nic-config-subnet2"
    ip_configuration {
      name      = "ip-config-subnet2"
      subnet_id = azurerm_subnet.res-28.id
    }
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  plan {
    name      = "fortinet_fg-vm_payg_2023"
    product   = "fortinet_fortigate-vm_v5"
    publisher = "fortinet"
  }
  source_image_reference {
    offer     = "fortinet_fortigate-vm_v5"
    publisher = "fortinet"
    sku       = "fortinet_fg-vm_payg_2023"
    version   = "7.2.6"
  }
  depends_on = [
    azurerm_subnet.res-28,
    # One of azurerm_subnet.res-26,azurerm_subnet_network_security_group_association.res-27 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_cosmosdb_account" "res-3" {
  ip_range_filter                   = join(",", var.ip_range_filter_values)
  is_virtual_network_filter_enabled = true
  location                          = var.location
  name                              = "${var.prefix_name}-dba001"
  offer_type                        = "Standard"
  resource_group_name               = var.resource_group_name
  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    failover_priority = 0
    location          = var.location
  }
  virtual_network_rule {
    id = azurerm_subnet.res-26.id
  }
}
resource "azurerm_cosmosdb_sql_database" "res-4" {
  account_name        = "${var.prefix_name}-dba001"
  name                = "FortiGateAutoscale"
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_cosmosdb_account.res-3,
  ]
}
resource "azurerm_cosmosdb_sql_container" "res-5" {
  account_name        = "${var.prefix_name}-dba001"
  database_name       = "FortiGateAutoscale"
  name                = "ApiRequestCache"
  partition_key_path  = "/id"
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_cosmosdb_sql_database.res-4,
  ]
}
resource "azurerm_cosmosdb_sql_container" "res-6" {
  account_name        = "${var.prefix_name}-dba001"
  database_name       = "FortiGateAutoscale"
  name                = "Autoscale"
  partition_key_path  = "/vmId"
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_cosmosdb_sql_database.res-4,
  ]
}
resource "azurerm_cosmosdb_sql_container" "res-7" {
  account_name        = "${var.prefix_name}-dba001"
  database_name       = "FortiGateAutoscale"
  name                = "CustomLog"
  partition_key_path  = "/id"
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_cosmosdb_sql_database.res-4,
  ]
}
resource "azurerm_cosmosdb_sql_container" "res-8" {
  account_name        = "${var.prefix_name}-dba001"
  database_name       = "FortiGateAutoscale"
  name                = "LicenseStock"
  partition_key_path  = "/checksum"
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_cosmosdb_sql_database.res-4,
  ]
}
resource "azurerm_cosmosdb_sql_container" "res-9" {
  account_name        = "${var.prefix_name}-dba001"
  database_name       = "FortiGateAutoscale"
  name                = "LicenseUsage"
  partition_key_path  = "/id"
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_cosmosdb_sql_database.res-4,
  ]
}
resource "azurerm_cosmosdb_sql_container" "res-10" {
  account_name        = "${var.prefix_name}-dba001"
  database_name       = "FortiGateAutoscale"
  name                = "PrimaryElection"
  partition_key_path  = "/id"
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_cosmosdb_sql_database.res-4,
  ]
}
resource "azurerm_cosmosdb_sql_container" "res-11" {
  account_name        = "${var.prefix_name}-dba001"
  database_name       = "FortiGateAutoscale"
  name                = "Settings"
  partition_key_path  = "/settingKey"
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_cosmosdb_sql_database.res-4,
  ]
}
resource "azurerm_cosmosdb_sql_role_definition" "res-13" {
  account_name        = "${var.prefix_name}-dba001"
  assignable_scopes   = [azurerm_cosmosdb_account.res-3.id]
  name                = "Custom Cosmos DB Built-in Data Reader"
  resource_group_name = var.resource_group_name
  type                = "BuiltInRole"
  permissions {
    data_actions = ["Microsoft.DocumentDB/databaseAccounts/readMetadata", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed"]
  }
  depends_on = [
    azurerm_cosmosdb_account.res-3,
  ]
}
resource "azurerm_cosmosdb_sql_role_definition" "res-14" {
  account_name        = "${var.prefix_name}-dba001"
  assignable_scopes   = [azurerm_cosmosdb_account.res-3.id]
  name                = "Custom Cosmos DB Built-in Data Contributor"
  resource_group_name = var.resource_group_name
  type                = "BuiltInRole"
  permissions {
    data_actions = ["Microsoft.DocumentDB/databaseAccounts/readMetadata", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*"]
  }
  depends_on = [
    azurerm_cosmosdb_account.res-3,
  ]
}
resource "azurerm_monitor_autoscale_setting" "res-15" {
  enabled             = false
  location            = var.location
  name                = "pontes-autoscalesettings-${var.prefix_name}-vmss-byol001"
  resource_group_name = var.resource_group_name
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.res-1.id
  profile {
    name = "${var.prefix_name}-deployed-profile"
    capacity {
      default = 0
      maximum = 2
      minimum = 0
    }
  }
  depends_on = [
    azurerm_linux_virtual_machine_scale_set.res-1,
  ]
}
resource "azurerm_monitor_autoscale_setting" "res-16" {
  enabled             = false
  location            = var.location
  name                = "pontes-autoscalesettings-${var.prefix_name}-vmss-payg001"
  resource_group_name = var.resource_group_name
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.res-2.id
  profile {
    name = "${var.prefix_name}-deployed-profile"
    capacity {
      default = 0
      maximum = 6
      minimum = 0
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.res-2.id
        operator           = "GreaterThan"
        statistic          = "Average"
        threshold          = 60
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        time_window        = "PT5M"
      }
      scale_action {
        cooldown  = "PT1M"
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
      }
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.res-2.id
        operator           = "LessThan"
        statistic          = "Average"
        threshold          = 40
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        time_window        = "PT5M"
      }
      scale_action {
        cooldown  = "PT1M"
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
      }
    }
  }
  depends_on = [
    azurerm_linux_virtual_machine_scale_set.res-2,
  ]
}
resource "azurerm_application_insights" "res-17" {
  application_type    = "web"
  location            = var.location
  name                = "${var.prefix_name}-appins001"
  resource_group_name = var.resource_group_name
  sampling_percentage = 0
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_key_vault" "res-18" {
  enabled_for_template_deployment = true
  location                        = var.location
  name                            = "${var.prefix_name}-kv0001"
  resource_group_name             = var.resource_group_name
  sku_name                        = "standard"
  tenant_id                       = var.tenant_id
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}

resource "azurerm_key_vault_access_policy" "azure_cli" {
  key_vault_id = azurerm_key_vault.res-18.id

  tenant_id = var.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
}

resource "azurerm_key_vault_access_policy" "access_policy" {
  key_vault_id = azurerm_key_vault.res-18.id
  tenant_id    = var.tenant_id
  object_id    = "9e6f32ed-a86c-4346-8d25-03a09521a6bc"

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]

  key_permissions = [
    "Create", "Get", "List", "Encrypt", "Decrypt"
  ]
}


resource "azurerm_key_vault_secret" "res-19" {
  key_vault_id = azurerm_key_vault.res-18.id
  name         = "faz-autoscale-admin-password"
  value        = "fortigate"
  depends_on = [
    azurerm_key_vault.res-18,
    azurerm_key_vault_access_policy.access_policy,
    azurerm_key_vault_access_policy.azure_cli,
  ]
}
resource "azurerm_key_vault_secret" "res-20" {
  key_vault_id = azurerm_key_vault.res-18.id
  name         = "faz-autoscale-admin-username"
  value        = "admin"
  depends_on = [
    azurerm_key_vault.res-18,
    azurerm_key_vault_access_policy.access_policy,
    azurerm_key_vault_access_policy.azure_cli,
  ]
}
resource "azurerm_network_security_group" "res-21" {
  location            = var.location
  name                = "nsg-external-nsg001"
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_network_security_rule" "res-22" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_ranges     = ["443"]
  direction                   = "Inbound"
  name                        = "allow-https-inbound"
  network_security_group_name = azurerm_network_security_group.res-21.name
  priority                    = 1002
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-21,
  ]
}
resource "azurerm_network_security_rule" "res-23" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_ranges     = ["22", "8443"]
  direction                   = "Inbound"
  name                        = "inbound-nat-pool"
  network_security_group_name = azurerm_network_security_group.res-21.name
  priority                    = 1000
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-21,
  ]
}
resource "azurerm_network_security_rule" "res-24" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Outbound"
  name                        = "outbound-all"
  network_security_group_name = azurerm_network_security_group.res-21.name
  priority                    = 1000
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-21,
  ]
}
resource "azurerm_virtual_network" "res-25" {
  address_space       = ["10.233.192.0/23"]
  location            = var.location
  name                = "HUB-VNET"
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_subnet" "res-26" {
  address_prefixes     = ["10.233.192.144/28"]
  name                 = "snetfwexternal"
  resource_group_name  = var.resource_group_name
  service_endpoints    = ["Microsoft.AzureCosmosDB", "Microsoft.Web"]
  virtual_network_name = "HUB-VNET"
  depends_on = [
    azurerm_virtual_network.res-25,
  ]
}
resource "azurerm_subnet_network_security_group_association" "res-27" {
  network_security_group_id = azurerm_network_security_group.res-21.id
  subnet_id                 = azurerm_subnet.res-26.id
  depends_on = [
    azurerm_network_security_group.res-21,
    azurerm_subnet.res-26,
  ]
}
resource "azurerm_subnet" "res-28" {
  address_prefixes     = ["10.233.192.160/28"]
  name                 = "swfwinternal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = "HUB-VNET"
  depends_on = [
    azurerm_virtual_network.res-25,
  ]
}
resource "azurerm_storage_account" "res-29" {
  account_kind                     = "Storage"
  account_replication_type         = "LRS"
  account_tier                     = "Standard"
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  location                         = var.location
  min_tls_version                  = "TLS1_0"
  name                             = "${var.prefix_name}sta001"
  resource_group_name              = var.resource_group_name
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_storage_container" "res-31" {
  name                 = "azure-webjobs-hosts"
  storage_account_name = azurerm_storage_account.res-29.name
}
resource "azurerm_storage_container" "res-32" {
  name                 = "azure-webjobs-secrets"
  storage_account_name = azurerm_storage_account.res-29.name
}
resource "azurerm_storage_container" "res-33" {
  name                 = "fortigate-autoscale"
  storage_account_name = azurerm_storage_account.res-29.name
}
resource "azurerm_storage_share" "res-35" {
  name                 = "${var.prefix_name}-funcapp001"
  quota                = 5120
  storage_account_name = azurerm_storage_account.res-29.name
}
resource "azurerm_service_plan" "res-38" {
  location            = var.location
  name                = "${var.prefix_name}-appserplan001"
  os_type             = "Windows"
  resource_group_name = var.resource_group_name
  sku_name            = "P1v2"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_windows_function_app" "res-39" {
  app_settings = {
    AUTOSCALE_DB_ACCOUNT                     = azurerm_cosmosdb_account.res-3.name
    AUTOSCALE_DB_NAME                        = azurerm_cosmosdb_sql_database.res-4.name
    AUTOSCALE_DB_PRIMARY_KEY                 = azurerm_cosmosdb_account.res-3.primary_key
    AUTOSCALE_KEY_VAULT_NAME                 = "${var.prefix_name}-kv001"
    AZURE_STORAGE_ACCESS_KEY                 = azurerm_storage_account.res-29.primary_access_key
    AZURE_STORAGE_ACCOUNT                    = azurerm_storage_account.res-29.name
    AzureWebJobsSecretStorageType            = "Blob"
    CLIENT_ID                                = var.client_id
    CLIENT_SECRET                            = var.client_secret
    DEBUG_LOGGER_OUTPUT_QUEUE_ENABLED        = "true"
    DEBUG_LOGGER_TIMEZONE_OFFSET             = "0"
    DEBUG_SAVE_CUSTOM_LOG                    = "true"
    FORTIANALYZER_HANDLER_ACCESS_KEY         = ""
    RESOURCE_GROUP                           = var.resource_group_name
    SUBSCRIPTION_ID                          = "cf72478e-c3b0-4072-8f60-41d037c1d9e9"
    TENANT_ID                                = "942b80cd-1b14-42a1-8dcf-4b21dece61ba"
    WEBSITE_RUN_FROM_PACKAGE                 = "https://github.com/fortinet/fortigate-autoscale-azure/releases/download/3.6.0-dev/fortigate-autoscale-azure-funcapp.zip"
    additional-configset-name-list           = ""
    asset-storage-key-prefix                 = "assets"
    asset-storage-name                       = "fortigate-autoscale"
    autoscale-function-extend-execution      = "true"
    autoscale-function-max-execution-time    = "600"
    autoscale-handler-url                    = "https://${var.prefix_name}-funcapp001.azurewebsites.net/api/fgt-as-handler?code=8L5UbSWTy-cI8xyR4fTkMjYn8eWRVr2E2Aq5-Rk3nkWpAzFuz9vn-A=="
    byol-scaling-group-desired-capacity      = "0"
    byol-scaling-group-max-size              = "2"
    byol-scaling-group-min-size              = "0"
    byol-scaling-group-name                  = "${var.prefix_name}-vmss-byol001"
    custom-asset-container                   = "n/a"
    custom-asset-directory                   = "n/a"
    egress-traffic-route-table               = "n/a"
    enable-external-elb                      = "true"
    enable-fortianalyzer-integration         = "false"
    enable-hybrid-licensing                  = "true"
    enable-internal-elb                      = "false"
    enable-second-nic                        = "true"
    enable-vm-info-cache                     = "n/a"
    faz-handler-name                         = "https://${var.prefix_name}-funcapp001.azurewebsites.net/api/faz-auth-handler?code="
    faz-ip                                   = "n/a"
    fortigate-admin-port                     = "8443"
    fortigate-autoscale-setting-saved        = "n/a"
    fortigate-autoscale-subnet-id-list       = "n/a"
    fortigate-autoscale-subnet-pairs         = "n/a"
    fortigate-autoscale-virtual-network-cidr = "10.233.192.0/23"
    fortigate-autoscale-virtual-network-id   = "HUB-VNET"
    fortigate-external-elb-dns               = "n/a"
    fortigate-internal-elb-dns               = "n/a"
    fortigate-psk-secret                     = "fortigate"
    fortigate-sync-interface                 = "port1"
    fortigate-traffic-port                   = "443"
    fortigate-traffic-protocol               = "n/a"
    heartbeat-delay-allowance                = "30"
    heartbeat-interval                       = "60"
    heartbeat-loss-count                     = "10"
    license-file-directory                   = "license-files"
    payg-scaling-group-name                  = "${var.prefix_name}-vmss-payg001"
    primary-election-timeout                 = "600"
    primary-scaling-group-name               = "${var.prefix_name}-vmss-payg001"
    resource-tag-prefix                      = "${var.prefix_name}"
    scaling-group-desired-capacity           = "0"
    scaling-group-max-size                   = "6"
    scaling-group-min-size                   = "0"
    sync-recovery-count                      = "3"
    terminate-unhealthy-vm                   = "false"
    vm-info-cache-time                       = "n/a"
    vpn-bgp-asn                              = "n/a"
  }
  builtin_logging_enabled    = false
  client_certificate_mode    = "Required"
  location                   = var.location
  name                       = "${var.prefix_name}-funcapp001"
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.res-38.id
  storage_account_access_key = azurerm_storage_account.res-29.primary_access_key
  storage_account_name       = azurerm_storage_account.res-29.name
  site_config {
    application_insights_key = "7486bac2-0e15-4f7b-987e-b8466c636713"
    ftps_state               = "FtpsOnly"
    ip_restriction {
      priority                  = 101
      virtual_network_subnet_id = azurerm_subnet.res-26.id
    }
    ip_restriction {
      ip_address = "0.0.0.0/0"
      priority   = 201
    }
    ip_restriction {
      priority    = 301
      service_tag = "AzureCloud"
    }
  }
  depends_on = [
    azurerm_service_plan.res-38,
    # One of azurerm_subnet.res-26,azurerm_subnet_network_security_group_association.res-27 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_function_app_function" "res-43" {
  config_json = jsonencode({
    bindings = [{
      authLevel = "function"
      direction = "in"
      methods   = ["get", "post"]
      name      = "req"
      type      = "httpTrigger"
      }, {
      direction = "out"
      name      = "res"
      type      = "http"
    }]
    entryPoint = "licenseHandler"
    scriptFile = "../dist/index.js"
  })
  function_app_id = azurerm_windows_function_app.res-39.id
  name            = "byol-license"
  depends_on = [
    azurerm_windows_function_app.res-39,
  ]
}
resource "azurerm_function_app_function" "res-44" {
  config_json = jsonencode({
    bindings = [{
      authLevel = "function"
      direction = "in"
      methods   = ["post"]
      name      = "req"
      type      = "httpTrigger"
      }, {
      direction = "out"
      name      = "res"
      type      = "http"
    }]
    entryPoint = "fazAuthHandler"
    scriptFile = "../dist/index.js"
  })
  function_app_id = azurerm_windows_function_app.res-39.id
  name            = "faz-auth-handler"
  depends_on = [
    azurerm_windows_function_app.res-39,
  ]
}
resource "azurerm_function_app_function" "res-45" {
  config_json = jsonencode({
    bindings = [{
      direction = "in"
      name      = "req"
      schedule  = "0 */12 * * * *"
      type      = "timerTrigger"
    }]
    entryPoint = "fazAuthScheduler"
    scriptFile = "../dist/index.js"
  })
  function_app_id = azurerm_windows_function_app.res-39.id
  name            = "faz-auth-scheduler"
  depends_on = [
    azurerm_windows_function_app.res-39,
  ]
}
resource "azurerm_function_app_function" "res-46" {
  config_json = jsonencode({
    bindings = [{
      authLevel = "function"
      direction = "in"
      methods   = ["get", "post"]
      name      = "req"
      type      = "httpTrigger"
      }, {
      direction = "out"
      name      = "res"
      type      = "http"
    }]
    entryPoint = "autoscaleHandler"
    scriptFile = "../dist/index.js"
  })
  function_app_id = azurerm_windows_function_app.res-39.id
  name            = "fgt-as-handler"
  depends_on = [
    azurerm_windows_function_app.res-39,
  ]
}
resource "azurerm_app_service_custom_hostname_binding" "res-47" {
  app_service_name    = "${var.prefix_name}-funcapp001"
  hostname            = "${var.prefix_name}-funcapp001.azurewebsites.net"
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_windows_function_app.res-39,
  ]
}
resource "azurerm_monitor_smart_detector_alert_rule" "res-48" {
  description         = "Failure Anomalies notifies you of an unusual rise in the rate of failed HTTP requests or dependency calls."
  detector_type       = "FailureAnomaliesDetector"
  frequency           = "PT1M"
  name                = "Failure Anomalies - ${var.prefix_name}-appins001"
  resource_group_name = var.resource_group_name
  scope_resource_ids  = [azurerm_application_insights.res-17.id]
  severity            = "Sev3"
  action_group {
    ids = [azurerm_monitor_action_group.action_group_resource.id]
    #ids = ["/subscriptions/cf72478e-c3b0-4072-8f60-41d037c1d9e9/resourcegroups/cprevot-demosdn/providers/microsoft.insights/actionGroups/application insights smart detection"]
  }
}
