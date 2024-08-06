variable "aws_region" {
  description = "Value of the Region of AWS"
  type        = string
  default     = "us-east-1"
}

variable "aws_region_2" {
  description = "Value of the Region of AWS"
  type        = string
  default     = "us-east-2"
}

variable "image_id" {
  default = "ami-0870650fde0fef2d4"
  type        = string
  description = "The id of the machine image (AMI) to use for the server."

  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}
