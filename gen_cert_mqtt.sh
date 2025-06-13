#!/bin/bash

# Generate the set of encryption files for MQTT Brocker
openssl genpkey -algorithm RSA -out mqtt.key -pkeyopt rsa_keygen_bits:2048
openssl req -new -key mqtt.key -out mqtt.csr -subj "/CN=ESP32Node1"
openssl x509 -req -in mqtt.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out mqtt.crt -days 365
