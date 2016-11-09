touch certindex
echo "000a" > serialfile
CA_SUBJ="/C=US/ST=Maryland/L=Baltimore/O=Immutability, LLC/OU=Infrastructure Automation/CN=My Development CA"
openssl req -newkey rsa:2048 -days 3650 -x509 -nodes -subj "${CA_SUBJ}" -out root.cer
SUBJ="/C=US/ST=Maryland/L=Baltimore/O=Immutability, LLC/OU=Infrastructure Automation/CN=*.immutability.io"
openssl req -newkey rsa:2048 -nodes -subj  "${SUBJ}"  -out hashicorp.csr -keyout hashicorp.key
openssl ca -batch -config hashicorp_ca.conf -notext -in hashicorp.csr -out hashicorp.cer
