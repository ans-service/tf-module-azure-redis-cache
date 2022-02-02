# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "instance" {
  name                          = var.redis_instance_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  capacity                      = var.capacity
  family                        = var.family
  sku_name                      = var.sku
  enable_non_ssl_port           = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  redis_configuration {
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "instance_pe" {
  name                = "${var.redis_instance_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.redis_instance_name}-psc"
    private_connection_resource_id = azurerm_redis_cache.instance.id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }

  tags = var.tags

  depends_on = [azurerm_redis_cache.instance]
}

resource "azurerm_private_dns_zone" "instance_pdz" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_a_record" "instance_pdar" {
  name                = var.redis_instance_name
  zone_name           = azurerm_private_dns_zone.instance_pdz.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.instance_pe.private_service_connection[0].private_ip_address]

  tags = var.tags

  depends_on = [azurerm_private_endpoint.instance_pe]
}

resource "azurerm_private_dns_zone_virtual_network_link" "instance_private_dzvnl" {
  name                  = "${var.redis_instance_name}-pdzvnl"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.instance_pdz.name
  virtual_network_id    = var.vnet_id

  depends_on = [azurerm_private_dns_zone.instance_pdz]
}