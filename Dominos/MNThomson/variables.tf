variable "first_name" {
  description = "Client's first name"
  type        = string
  default     = "My"
}

variable "last_name" {
  description = "Client's last name"
  type        = string
  default     = "Name"
}

variable "email_address" {
  description = "Client's email address"
  type        = string
  default     = "my@name.com"
  sensitive   = true
}

variable "phone_number" {
  description = "Client's phone number"
  type        = string
  default     = "15555555555"
  sensitive   = true
}

# Credit Card Information
variable "credit_card_number" {
  description = "Credit card number"
  type        = number
  default     = 123456789101112
  sensitive   = true
}

variable "credit_card_cvv" {
  description = "Credit card CVV"
  type        = number
  default     = 1314
  sensitive   = true
}

variable "credit_card_date" {
  description = "Credit card expiration date"
  type        = string
  default     = "15/16"
  sensitive   = true
}

variable "credit_card_postal_code" {
  description = "Credit card postal code"
  type        = string
  default     = "18192"
  sensitive   = true
}

# Domino's Address Information
variable "address_street" {
  description = "Street address for delivery"
  type        = string
  default     = "123 Main St"
}

variable "address_city" {
  description = "City for delivery"
  type        = string
  default     = "Anytown"
}

variable "address_region" {
  description = "Region for delivery"
  type        = string
  default     = "WA"
}

variable "address_postal_code" {
  description = "Postal code for delivery"
  type        = string
  default     = "02122"
}

variable "dominos_menu_item" {
  description = "Postal code for delivery"
  type        = list(string)
  default     = ["philly", "medium"]
}
