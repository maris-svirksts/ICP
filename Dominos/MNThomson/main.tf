terraform {
  required_providers {
    dominos = {
      source = "MNThomson/dominos"
      version = "0.2.1"
    }
  }
}

provider "dominos" {
  first_name    = var.first_name
  last_name     = var.last_name
  email_address = var.email_address
  phone_number  = var.phone_number

  credit_card = {
    number      = var.credit_card_number
    cvv         = var.credit_card_cvv
    date        = var.credit_card_date
    postal_code = var.credit_card_postal_code
  }
}

data "dominos_address" "addr" {
  street      = var.address_street
  city        = var.address_city
  region      = var.address_region
  postal_code = var.address_postal_code
}

data "dominos_store" "store" {
  address_url_object = data.dominos_address.addr.url_object
}

data "dominos_menu_item" "item" {
  store_id     = data.dominos_store.store.store_id
  query_string = var.dominos_menu_item
}

output "OrderOutput" {
  value = data.dominos_menu_item.item.matches[*]
}

/*
resource "dominos_order" "order" {
  api_object = data.dominos_address.addr.api_object
  item_codes = data.dominos_menu_item.item.matches[*].code
  store_id   = data.dominos_store.store.store_id
}
*/