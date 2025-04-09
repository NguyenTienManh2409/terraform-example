variable "project" {
  description = "Tên dự án để gán tag cho các resource"
  type        = string
  default     = "my-project"
}

variable "key_name" {
  description = "Tên SSH key để connect vào EC2"
  type        = string
}

variable "region" {
  description = "AWS region để deploy"
  type        = string
  default     = "us-east-1"
}
