
# https://jwt.io/#debugger-io

export token_anonym=""
export token_user="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYXBwX3VzZXIifQ.Z78RWbvnLm9D-EKLMQk1C0PBm79NWEyAUkR9_IukDhg"
export token_user_company1="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYXBwX3VzZXIiLCJjb21wYW55X2lkIjoxfQ.utDs-LJvyQS2_kJkB1s7KePzqlL1YwaXFVSaOw2FvGo"
export token_admin="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYXBwX2FkbWluIn0.OmQ2j4fCJWUzyKI6mZSUGDKlivrZJfdzKmXx3f9jT4Y"
export token_admin_company2="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYXBwX2FkbWluIiwiY29tcGFueV9pZCI6Mn0.8OHwKG4axXQRy9RjRT4E6Yd9zhTggoAASL1EZlML7yI"

token=$token_user

echo "GET";

# curl http://localhost:3000/companies -H "Authorization: Bearer $token";echo
#
# curl http://localhost:3000/users -H "Authorization: Bearer $token";echo

# curl http://localhost:3000/users_only_get -H "Authorization: Bearer $token";echo
# curl http://localhost:3000/users_only_admin_get -H "Authorization: Bearer $token";echo
#
curl http://localhost:3000/posts?select=users\(password\) -H "Authorization: Bearer $token";echo

echo "POST";

# curl http://localhost:3000/companies -H "Authorization: Bearer $token" -X POST -H "Content-Type: application/json"  \
# -d '{"name":"nam2"}';echo
#
# curl http://localhost:3000/users -H "Authorization: Bearer $token" -X POST -H "Content-Type: application/json"  \
# -d '{"name": "hah", "email":"1@21.co2m", "password": "asd", "company_id": 21}';echo
#
# curl http://localhost:3000/posts -H "Authorization: Bearer $token" -X POST -H "Content-Type: application/json"  \
# -d '{"title":"title0"}';echo
