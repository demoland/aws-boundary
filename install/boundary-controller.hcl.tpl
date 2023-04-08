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
