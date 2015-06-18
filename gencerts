#/bin/bash

#This script creates root CA and server certificates to be used by the client and the server.
# rootCA.crt needs to be copied to the client to replace the system-wide root CA set
# example.keystore needs to be referenced by keyStorePath in the server's config file

# Create private key for root CA certificate
openssl genrsa -out rootCA.key 4096

# Create a self-signed root CA certificate
openssl req -x509 -new -nodes  -days 3650 -out rootCA.crt -key rootCA.key

# Create server certificate key
openssl genrsa -out whisper.key 4096

# Create Certificate Signing Request
openssl req -new -key whisper.key -out whisper.csr

# Sign the certificate with the root CA
openssl x509 -req -in whisper.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -days 3650 -out whisper.crt -extensions extensions -extfile <(cat <<-EOF
[ extensions ]
basicConstraints=CA:FALSE
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
subjectAltName=$ALTNAME
EOF
)

# Export to host key and certificate to PKCS12 format which is recognized by Java keytool
openssl pkcs12 -export -password pass:example -in whisper.crt -inkey whisper.key -out keystore.p12 -name example -CAfile rootCA.crt

# Import the host key and certificate to Java keystore format, so it can be used by dropwizard
keytool -importkeystore -srcstoretype PKCS12 -srckeystore keystore.p12 -srcstorepass example -destkeystore example.keystore -deststorepass example
