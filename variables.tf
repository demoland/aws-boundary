# variable "users" {
#   type    = set(string)
#   default = [
#     "Jim",
#     "Mike",
#     "Todd",
#     "Jeff",
#     "Randy",
#     "Susmitha"
#   ]
# }

# variable "readonly_users" {
#   type    = set(string)
#   default = [
#     "Chris",
#     "Pete",
#     "Justin"
#   ]
# }

# variable "backend_server_ips" {
#   type    = set(string)
#   default = [
#     "10.1.0.1",
#     "10.1.0.2",
#   ]
# }

variable "my-ip" {
  description = "The IP address of your connection to the internet"
  default     = "xxx.xxx.xx.xxx/32"
}
