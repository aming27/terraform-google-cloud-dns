/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

###############################################################################
#                                zone variables                               #
###############################################################################

variable "domain" {
  description = "Zone domain, must end with a period."
  type        = string
}

variable "name" {
  description = "Zone name, must be unique within the project."
  type        = string
}

variable "private_visibility_config_networks" {
  description = "List of VPC self links that can see this zone."
  default     = []
  type        = list(string)
}

variable "project_id" {
  description = "Project id for the zone."
  type        = string
}

variable "target_name_server_addresses" {
  description = "List of target name servers for forwarding zone."
  default     = []
  type        = list(map(any))
}

variable "target_network" {
  description = "Peering network."
  default     = ""
  type        = string
}

variable "description" {
  description = "zone description (shown in console)"
  default     = "Managed by Terraform"
  type        = string
}

variable "type" {
  description = "Type of zone to create, valid values are 'public', 'private', 'forwarding', 'peering', 'reverse_lookup' and 'service_directory'."
  default     = "private"
  type        = string
}

variable "dnssec_config" {
  description = "Object containing : kind, non_existence, state. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "labels" {
  type        = map(any)
  description = "A set of key/value label pairs to assign to this ManagedZone"
  default     = {}
}

variable "default_key_specs_key" {
  description = "Object containing default key signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "default_key_specs_zone" {
  description = "Object containing default zone signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "force_destroy" {
  description = "Set this true to delete all records in the zone."
  default     = false
  type        = bool
}
variable "service_namespace_url" {
  type        = string
  default     = ""
  description = "The fully qualified or partial URL of the service directory namespace that should be associated with the zone. This should be formatted like https://servicedirectory.googleapis.com/v1/projects/{project}/locations/{location}/namespaces/{namespace_id} or simply projects/{project}/locations/{location}/namespaces/{namespace_id}."
}

###############################################################################
#                               record variables                              #
###############################################################################

variable "recordsets" {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = optional(list(string), null)

    routing_policy = optional(object({
      health_check  = optional(string)
      wrr = optional(list(object({
        weight  = number
        records = list(string)
        health_checked_targets = optional(object({
          internal_load_balancers = optional(list(object({
            ip_address    = string
            port         = number
            project      = string
            region       = optional(string)
            network_url  = optional(string)
          })), [])
          external_endpoints = optional(list(string), [])
        }))
      })), [])
      
      geo = optional(list(object({
        location = string
        records  = list(string)
      })), [])
    }))
  }))
  description = "List of DNS record objects to manage, in the standard terraform dns structure."
  default     = []
}

variable "enable_logging" {
  description = "Enable query logging for this ManagedZone"
  default     = false
  type        = bool
}
