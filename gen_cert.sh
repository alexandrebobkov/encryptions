#!/bin/bash
# By: Alexander Bobkov
# Date: June 13, 2025
# This script automatically creates SSL keys and certificates.


# Color formatting
regular='\033[0;37m'
message='\033[0;32m'		# green
message_bold='\033[1;32m'	# green & bold
warning='\033[1;31m'		# bold and red

# === Step 1. =========================================
echo -e "${message}Generating Certificate Authority (CA)${regular}"
# Generating CA
openssl req -x509 -new -days 365 -extensions v3_ca -nodes -keyout ca.key -out ca.crt -passout pass:1234 -subj '/CN=techquadbit.net'
echo -e "${message_bold}DONE${regular}"

# === Step 2. =========================================
echo -e "${message}Generating encryption files for MQTT Broker${regular}"
# Generating the set of encryption files for MQTT Broker
openssl genrsa -out broker.key 2048
openssl req -out broker.csr -key mosquitto.key -new -subj '/CN=localhost'
openssl x509 -req -in broker.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out mosquitto.crt -passin pass:1234 -days 365
echo -e "${message_bold}DONE${regular}"

# === Step 3. ==========================================
echo 'Generating encryption files for MQTT Clients'
# Generating the set of encryption files for MQTT Client(s)
openssl genrsa -out esp32.key 2048
# openssl genpkey -slgorithm RSA -out esp32.key -pkeyout rsa_keygen_bits:2048

openssl req -out esp32.csr -key esp32.key -new -subj '/CN=localhost'
# openssl req -new -key esp32.key -out esp32.csr -subj '/CN=esp32'

openssl x509 -req -in esp32.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out esp32.crt -days 365 -passin pass:1234
# openssl x509 -req -in esp32.csr -CA ca.crt -CAkey -CAcreateserial -out esp32.crt -days 365

# A loop for generating encryption files for clients
for i in  {1..3}
do
   echo -e "${message}"
   echo -e "Encryption files for client "$i "${regular}"
   echo 'esp32-node'$i'.key'
   openssl genrsa -out esp32-node$i.key 2048
   echo 'esp32-node'$i'.csr'
   openssl req -out esp32-node$i.csr -key esp32-node$i.key -new -subj '/CN=localhost'
   echo 'esp32-node'$i'.crt'
   openssl x509 -req -in esp32-node$i.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out esp32-node$i.crt -days 365 -passin pass:1234
   echo -e "${message_bold}DONE${regular}"
done

echo ''
echo '=============================='
echo -e "${message}Use generated files as follows:"
echo -e "${regular}For MQTT Broker, use the files: ca.crt, broker.crt and broker.key"
echo 'For MQTT Explorer, use the files: broker.crt, esp.crt and esp.key'
echo 'For MQTT Clients, use the files: broker.crt, esp32-node#.crt and esp32-node#.key'
