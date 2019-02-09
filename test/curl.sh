# https://jwt.io/#debugger-io

export token_anonym=""
export token_user="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJyb2xlIjoiYXBwX3VzZXIifQ.2JfXAe_vzlWtuP38Zvp1WBr7biNBKVUXzhTjr8xkhGk"
export token_admin="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJyb2xlIjoiYXBwX2FkbWluIn0.dnsjvP4XXaB0XgWkEhhEubfWmSLvm262H-YFUbG8KoQ"

token=$token_user

echo "GET";

# curl http://localhost:9001/api/posts -H "Authorization: Bearer $token";echo
