touch certindex
echo "000a" > serialfile
CA_SUBJ="/C=US/ST=Maryland/L=Baltimore/O=T.Rowe Price Associates, Inc./OU=Investment Technologies/CN=My Development CA"
openssl req -newkey rsa:2048 -days 3650 -x509 -nodes -subj "${CA_SUBJ}" -out root.cer
SUBJ="/C=US/ST=Maryland/L=Baltimore/O=T.Rowe Price Associates, Inc./OU=Investment Technologies/CN=*.troweprice.com"
openssl req -newkey rsa:2048 -nodes -subj  "${SUBJ}"  -out hashicorp.csr -keyout hashicorp.key
openssl ca -batch -config hashicorp_ca.conf -notext -in hashicorp.csr -out hashicorp.cer
