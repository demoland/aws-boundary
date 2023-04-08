# Disable memory lock: https://www.man7.org/linux/man-pages/man2/mlock.2.html
disable_mlock = true

# Controller configuration block
controller {
  # This name attr must be unique!
  name = "demo-controller-${count}"
  # Description of this controller
  description = "A controller for a demo!"
}

# API listener configuration block
listener "tcp" {
  # Should be the address of the NIC that the controller server will be reached on
  address = "${private_ip}:9200"
  # The purpose of this listener block
    purpose = "api"
  # Should be enabled for production installs
    tls_disable = true
  # Enable CORS for the Admin UI
    cors_enabled = true
    cors_allowed_origins = ["*"]
}

# Data-plane listener configuration block (used for worker coordination)
listener "tcp" {
  # Should be the IP of the NIC that the worker will connect on
  address = "${private_ip}:9201"
  # The purpose of this listener
    purpose = "cluster"
  # Should be enabled for production installs
    tls_disable = true
}

# Root KMS configuration block: this is the root key for Boundary
# Use a production KMS such as AWS KMS in production installs
// kms "aead" {
//     purpose = "root"
//     aead_type = "aes-gcm"
//     key = "sP1fnF5Xz85RrXyELHFeZg9Ad2qt4Z4bgNHVGtD6ung="
//     key_id = "global_root"
// }

# Worker authorization KMS
# Use a production KMS such as AWS KMS for production installs
# This key is the same key used in the worker configuration
// kms "aead" {
//     purpose = "worker-auth"
//     aead_type = "aes-gcm"
//     key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
//     key_id = "global_worker-auth"
// }

# Recovery KMS block: configures the recovery key for Boundary
# Use a production KMS such as AWS KMS for production installs
// kms "aead" {
//     purpose = "recovery"
//     aead_type = "aes-gcm"
//     key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
//     key_id = "global_recovery"
// }

# Database URL for postgres. This can be a direct "postgres://"
# URL, or it can be "file://" to read the contents of a file to
# supply the url, or "env://" to name an environment variable
# that contains the URL.
// database {
//   url = "postgresql://boundary:boundarydemo@${aws_db_instance.boundary.endpoint}/boundary"
// }
