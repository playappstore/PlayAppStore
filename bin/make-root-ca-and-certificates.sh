#!/bin/bash
ip=$1
cer_dir=$2
mkdir -p "$cer_dir"

# get rid of output
blackhole="/dev/null"

# Create your very own Root Certificate Authority
openssl genrsa \
  -out "$cer_dir"my-root-ca.key \
  2048 \
  2> $blackhole

# Self-sign your Root Certificate Authority
# Since this is private, the details can be as bogus as you like
openssl req \
  -x509 \
  -new \
  -nodes \
  -key "$cer_dir"my-root-ca.key \
  -days 1024 \
  -sha256 \
  -out "$cer_dir"my-root-ca.cer \
  -subj "/C=US/ST=Utah/L=Provo/O=PLAYAPPSTORE Certificate Authority Inc/CN=playappstore" \
  2> $blackhole

# Create a Device Certificate for each domain,
# such as example.com, *.example.com, awesome.example.com
# NOTE: You MUST match CN to the domain name or ip address you want to use
openssl genrsa \
  -out "$cer_dir"private.key \
  2048 \
  2> $blackhole

# Create a request from your Device, which your Root CA will sign
openssl req -new \
  -key "$cer_dir"private.key \
  -out "$cer_dir"csr.req \
  -subj "/C=US/ST=Utah/L=Provo/O=PLAYAPPSTORE Tech Inc/CN=${ip}" \
  2> $blackhole



# Sign the request from Device with your Root CA
# -CAserial certs/ca/my-root-ca.srl
openssl x509 \
  -req -in "$cer_dir"csr.req \
  -CA "$cer_dir"my-root-ca.cer \
  -CAkey "$cer_dir"my-root-ca.key \
  -CAcreateserial \
  -sha256 \
  -out "$cer_dir"cert.cer \
  -days 500



