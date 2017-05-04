#!/bin/bash
ip=$1
# parentCertFolder
parentCertFolder=$2
uuid=$3
cer_dir=${parentCertFolder}"/"${ip}
mkdir -p "$cer_dir"

# for the ca command, we need to choose a directory to store all keys and certificates
# and we also need to create the directory structure. 
# the index.txt and serial files act as a flat file database to keep track of signed certificates.
cadir=${parentCertFolder}"/ca"
if [ ! -d "$cadir" ]; then 
mkdir "$cadir" 
mkdir -p "$cadir"/certs "$cadir"/crl "$cadir"/newcerts "$cadir"/private
cd "$cadir" && touch index.txt && touch serial && echo 1000 > serial
fi 


# get rid of output
blackhole="/dev/null"

root_ca_key_path=${cadir}"/private/my-root-ca.key"
if [ ! -f "$root_ca_key_path" ]; then 
# Create your very own Root Certificate Authority
openssl genrsa \
  -out "$cadir"/private/my-root-ca.key \
  2048 \
  2> $blackhole

# Self-sign your Root Certificate Authority
# Since this is private, the details can be as bogus as you like
openssl req \
  -x509 \
  -new \
  -nodes \
  -key "$cadir"/private/my-root-ca.key \
  -days 1024 \
  -sha256 \
  -out "$cadir"/certs/my-root-ca.cer \
  -subj "/C=CN/ST=Beijing/L=Beijing/O=PLAYAPPSTORE Certificate Authority Inc/CN=playappstore" \
  2> $blackhole

fi 



# Create a Device Certificate for each domain,
# such as example.com, *.example.com, awesome.example.com
# NOTE: You MUST match CN to the domain name or ip address you want to use
openssl genrsa \
  -out "$cer_dir"/private.key \
  2048 \
  2> $blackhole

# generate a new config file that mask req_extensions = v3_req
# and also append subjectAltName in it.
echo "[req]
default_bits = 2048
default_md = sha256
req_extensions = v3_req
distinguished_name = dn
[ dn ]
countryName     = Country Name (2 letter code)
countryName_default   = AU
stateOrProvinceName   = State or Province Name (full name)
stateOrProvinceName_default = Some-State
localityName      = Locality Name (eg, city)
0.organizationName    = Organization Name (eg, company)
0.organizationName_default  = Internet Widgits Pty Ltd
organizationalUnitName    = Organizational Unit Name (eg, section)
organizationalUnitName_default = Internet Widgits Pty Ltd
commonName      = Common Name (e.g. server FQDN or YOUR name)
emailAddress      = Email Address
[ v3_req ]
basicConstraints = CA:FALSE
subjectAltName = @alt_names
[alt_names]
DNS = localhost
IP.1 = 127.0.0.1
IP.2 = ${ip}" > "$cer_dir"/v3_req.cnf 

# Create a request from your Device, which your Root CA will sign
openssl req \
  -new \
  -nodes \
  -key "$cer_dir"/private.key \
  -out "$cer_dir"/csr.req \
  -subj "/C=CN/ST=Beijing/L=Beijing/O=PLAYAPPSTORE Tech Inc ${uuid}/CN=${ip}" \
  -config "$cer_dir"/v3_req.cnf \
  2> $blackhole


# generate a new config file that mask copy_extensions = copy
echo "[ ca ]
default_ca      = CA_default
[ CA_default ]
dir            = ${cadir}
database       = \$dir/index.txt
serial         = \$dir/serial
RANDFILE       = \$dir/private/.rand
new_certs_dir  = \$dir/newcerts
copy_extensions = copy
policy         = policy_any
x509_extensions = usr_cert
[ policy_any ]
countryName            = supplied
stateOrProvinceName    = optional
organizationName       = optional
organizationalUnitName = optional
commonName             = supplied
emailAddress           = optional
[ usr_cert ]
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment\n" > "$cer_dir"/ca.cnf



openssl ca \
-config "$cer_dir"/ca.cnf \
-keyfile "$cadir"/private/my-root-ca.key \
-cert "$cadir"/certs/my-root-ca.cer \
-days 375  \
-md sha256 \
-in "$cer_dir"/csr.req \
-out "$cer_dir"/cert.cer \
-batch 