# https://chat.openai.com/share/4c492b9e-12aa-4a0c-b68d-a0a3f93ab6e9

Passwords:
 - Certificate: fake-cert-pwd
 - KeyChain: fake-keychain-pwd

openssl genrsa -out privatekey.pem 2048

openssl req -new -key privatekey.pem -out certrequest.csr

openssl x509 -req -days 36500 -in certrequest.csr -signkey privatekey.pem -out certificate.pem

# Questo comando genera un file .p12 utilizzando il certificato e la chiave privata. L’opzione -legacy viene utilizzata per garantire la compatibilità con macOS.
openssl pkcs12 -export -legacy -out certificate.p12 -inkey privatekey.pem -in certificate.pem

base64 certificate.p12 > certificate.base64

