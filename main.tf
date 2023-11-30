variable "cluster" {
  description = "The ECS cluster that the service is deployed to."
  type        = string
}

variable "service" {
  description = "The name of the ECS service."
  type        = string
}

variable "taskdef" {
  description = "The task definition ARN that the service is being updated to."
  type        = string
}

variable "is_test" {
  description = "For testing only. Stops the call to AWS for sts"
  default     = false
}

variable "timeout" {
  description = "The timeout for the monitor to wait for the service to be stable."
  default     = 600
}

data "aws_region" "current" {
}}

data "aws_caller_identity" "current" {
  count = var.is_test ? 0 : 1
}

resource "null_resource" "ecs_update_monitor" {
  count = var.is_test ? 0 : 1

  triggers = {
    cluster    = var.cluster
    service    = var.service
    taskdef    = var.taskdef
    caller_arn = data.aws_caller_identity.current[0].arn
    region     = data.aws_region.current.name
    timeout    = var.timeout
  }

  provisioner "local-exec" {
    command = "${path.module}/provision.sh '${path.module}' '${var.cluster}' '${var.service}' '${var.taskdef}' '${data.aws_region.current.name}' '${data.aws_caller_identity.current[0].arn}' '${var.timeout}'"
  }
}

