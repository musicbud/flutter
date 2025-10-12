#!/bin/bash

# Test script to verify authentication API endpoint

echo "Testing authentication endpoint..."

# Test login API call
response=$(curl -s -w "%{http_code}" -X POST \
  "http://84.235.170.234/login/" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "testpassword"
  }')

http_code="${response: -3}"
response_body="${response%???}"

echo "HTTP Status Code: $http_code"
echo "Response Body: $response_body"

if [ "$http_code" -eq 200 ]; then
    echo "✅ Authentication endpoint is working!"
else
    echo "❌ Authentication endpoint returned error status"
fi