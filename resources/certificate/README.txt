# https://chat.openai.com/share/4c492b9e-12aa-4a0c-b68d-a0a3f93ab6e9


openssl genpkey -algorithm RSA -out private-key.pem

openssl req -new -x509 -key private-key.pem -out certificate.pem -days 365
openssl pkcs12 -export -out certificate.p12 -inkey private-key.pem -in certificate.pem
base64 certificate.p12 > certificate.base64

Password: NoPassword2023
