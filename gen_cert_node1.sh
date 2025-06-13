#!/bin/bash

# Generate the set of encryption files for ESP32 Node 1
openssl genpkey -algorithm RSA -out esp32-node1.key -pkeyopt rsa_keygen_bits:2048
openssl req -new -key esp32-node1.key -out esp32-node1.csr -subj "/CN=ESP32Node1"
openssl x509 -req -in esp32-node1.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out esp32-node1.crt -days 365
