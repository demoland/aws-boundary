[Unit]
Description=${name} ${type}

[Service]
ExecStart=/usr/local/bin/${name} ${type} -config /etc/${name}-${type}.hcl
User=${name}
Group=${name}
LimitMEMLOCK=infinity
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK

[Install]
WantedBy=multi-user.target
