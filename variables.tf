variable "subscription_id" {
  type    = string
  #default = "cf72478e-c3b0-4072-8f60-41d037c1d9e9"
  default = "b851d0d9-9a10-4098-9269-35e85eb3a698"
}

variable "tenant_id" {
  type    = string
  default = "942b80cd-1b14-42a1-8dcf-4b21dece61ba"
}

variable "client_id" { # Recomendamos a utilização do export client_id="seu_client_id_aqui"
  type = string
  default = "e83678e4-c831-44c5-b803-7359bf665b7d"

}
variable "client_secret" { # Recomendamos a utilização do export client_secret="seu_client_secret_aqui"
  type = string
  default = "SFw8Q~5Nt0Xc.DGDHcbFAKoVHXR-olznw4BUlcdp"
}

variable "admin_password" { # Recomendamos a utilização do export admin_password="seu_client_secret_aqui"
  type = string
  default = "Nov4Senha@"
}

variable "resource_group_name" {
  type        = string
  description = "Nome do Grupo de Recursos"
  default     = "rsg-thiagopontes"
}

variable "location" {
  type        = string
  description = "Location"
  default     = "eastus"
}

variable "prefix_name" {
  type        = string
  description = "Prefixo a ser utilziado pelos recursos"
  default     = "tspontes"
}


variable "ip_range_filter_values" {
  type        = list(string)
  description = "Lista de endereços IP no formato CIDR para filtragem de intervalo de IP"
  default = [
    "52.226.143.156",
    "52.226.138.178",
    "52.226.143.193",
    "52.226.143.225",
    "52.226.143.246",
    "52.255.216.13",
    "52.255.217.112",
    "52.255.217.114",
    "52.255.217.127",
    "52.255.217.145",
    "52.255.217.147",
    "52.255.217.155",
    "52.255.217.158",
    "52.255.217.195",
    "52.255.217.199",
    "52.255.217.201",
    "52.255.217.242",
    "52.255.217.248",
    "52.255.216.22",
    "52.226.139.43",
    "52.255.216.62",
    "52.255.216.127",
    "52.255.216.188",
    "52.255.216.231",
    "52.255.216.242",
    "52.255.216.249",
    "52.255.216.252",
    "52.255.217.28",
    "52.255.217.68",
    "52.255.217.75",
    "52.226.141.13",
    "52.255.217.81",
    "52.255.217.82",
    "52.255.217.87",
    "52.226.139.26",
    "52.255.217.105",
    "52.255.217.112",
    "52.255.217.114",
    "52.255.217.127",
    "52.255.217.145",
    "52.255.217.147",
    "52.255.217.155",
    "52.255.217.158",
    "52.255.217.195",
    "52.255.217.199",
    "52.255.217.201",
    "52.255.217.242",
    "52.255.217.248",
    "52.255.217.253",
    "52.226.141.73",
    "52.255.218.4",
    "52.255.218.8",
    "52.255.218.11",
    "52.255.218.12",
    "20.119.8.57"
  ]
}
