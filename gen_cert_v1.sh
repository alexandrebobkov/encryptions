#!/bin/bash
# By: Alexander Bobkov
# Date: June 13, 2025
# This script automatically creates SSL keys and certificates.

# Key variables
broker_domain_name="techquadbit.net"
esp_nodes_qty=3

# Text formatting
regular='\033[0;37m'
message='\033[0;32m'		# green
message_bold='\033[1;32m'	# green & bold
warning='\033[1;31m'		# bold and red


read -p "Specify MQTT Broker domain name: " broker_domain_name
read -p "Specify the number of cleints that require encryption: " esp_nodes_qty

# === Step 1. =========================================
echo -e "${message}Generating Certificate Authority (CA)${regular}"
# Generating CA
openssl req -x509 -new -days 365 -extensions v3_ca -nodes -keyout ca.key -out ca.crt -passout pass:1234 -subj "/CN=${broker_domain_name}"
# techquadbit.net'
echo -e "${message_bold}DONE${regular}"
echo ''

# === Step 2. =========================================
echo -e "${message}Generating encryption files for MQTT Broker${regular}"
# Generating the set of encryption files for MQTT Broker
openssl genrsa -out broker.key 2048
openssl req -out broker.csr -key broker.key -new -subj '/CN=${broker_doman_name}'
#localhost'
openssl x509 -req -in broker.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out broker.crt -passin pass:1234 -days 365
echo -e "${message_bold}DONE${regular}"
echo ''

# === Step 3. ==========================================
echo -e "${message}Generating ${esp_nodes_qty} encryption files for MQTT Clients${regular}"
# Generating the set of encryption files for MQTT Client(s)
openssl genrsa -out esp32.key 2048
openssl req -out esp32.csr -key esp32.key -new -subj '/CN=localhost'
openssl x509 -req -in esp32.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out esp32.crt -days 365 -passin pass:1234

# A loop for generating encryption files for clients
#for i in  {1..3}
for i in $(seq $esp_nodes_qty)
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
echo ''
echo -e "${message_bold}The certificates will expire on: "$(date -d "+ 365 days")
