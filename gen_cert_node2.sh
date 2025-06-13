#!/bin/bash

# Generate the set of encryption files for ESP32 Node 2
openssl genpkey -algorithm RSA -out esp32-node2.key -pkeyopt rsa_keygen_bits:2048
openssl req -new -key esp32-node2.key -out esp32-node2.csr -subj "/CN=ESP32Node2"
openssl x509 -req -in esp32-node2.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out esp32-node2.crt -days 365
