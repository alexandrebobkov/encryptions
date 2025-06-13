#!/bin/bash

# Generate the set of encryption files for ESP32
openssl genpkey -algorithm RSA -out esp32.key -pkeyopt rsa_keygen_bits:2048
openssl req -new -key esp32.key -out esp32.csr -subj "/CN=ESP32Node1"
openssl x509 -req -in esp32.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out esp32.crt -days 365
