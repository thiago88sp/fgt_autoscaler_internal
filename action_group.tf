resource "azurerm_resource_group" "action_group_rsg" {
  location = "francecentral"
  name     = "tpontes-DemoSDN"
  tags = {
    "Cost Center" = "6650"
    Name          = "Thiago Pontes"
    Username      = "tpontes@fortinet.com"
    VMState       = "ShutdownAtNight\u00a0"
  }
}
resource "azurerm_monitor_action_group" "action_group_resource" {
  name                = "Application Insights Smart Detection"
  resource_group_name = "tpontes-DemoSDN"
  short_name          = "SmartDetect"
  arm_role_receiver {
    name                    = "Monitoring Contributor"
    role_id                 = "749f88d5-cbae-40b8-bcfc-e573ddc772fa"
    use_common_alert_schema = true
  }
  arm_role_receiver {
    name                    = "Monitoring Reader"
    role_id                 = "43d0d8ad-25c7-4714-9337-8ba259a9fe05"
    use_common_alert_schema = true
  }

  depends_on = [
    azurerm_resource_group.action_group_rsg,
  ]
}
