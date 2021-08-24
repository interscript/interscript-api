#curl -g \
#  -X POST \
#  -H 'Accept: application/json, text/plain, */*' \
#  -H 'Content-Type: application/json' \
#  -H 'Origin: http://localhost:3000' \
#  -d '{"query":"query{info}"}' \
#  "http://localhost:9000/2015-03-31/functions/function/invocations"

curl -g \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"query":"query{info}"}' \
  http://localhost:9000/2015-03-31/functions/function/invocations
