#!/bin/bash
# Script to test all API endpoints

BASE_URL="http://localhost:8000/v1"

echo "🧪 Testing MusicBud API Endpoints"
echo "=================================="
echo ""

# Test login
echo "1. Testing Login..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/login/" \
  -H "Content-Type: application/json" \
  -d '{"username":"mahmwood","password":"password"}')

if echo "$LOGIN_RESPONSE" | grep -q "access_token"; then
    echo "✅ Login: SUCCESS"
    TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
else
    echo "❌ Login: FAILED"
    echo "$LOGIN_RESPONSE"
    exit 1
fi

echo ""

# Test profile endpoint
echo "2. Testing Profile Endpoint..."
PROFILE_RESPONSE=$(curl -s -X POST "$BASE_URL/me/profile/" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")

if [ ! -z "$PROFILE_RESPONSE" ]; then
    echo "✅ Profile: SUCCESS (got response)"
else
    echo "❌ Profile: FAILED (no response)"
fi

echo ""

# Test top artists
echo "3. Testing Top Artists..."
TOP_ARTISTS=$(curl -s -X POST "$BASE_URL/me/top/artists/" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")

if [ ! -z "$TOP_ARTISTS" ]; then
    echo "✅ Top Artists: SUCCESS (got response)"
else
    echo "❌ Top Artists: FAILED (no response)"
fi

echo ""

# Test top tracks
echo "4. Testing Top Tracks..."
TOP_TRACKS=$(curl -s -X POST "$BASE_URL/me/top/tracks/" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")

if [ ! -z "$TOP_TRACKS" ]; then
    echo "✅ Top Tracks: SUCCESS (got response)"
else
    echo "❌ Top Tracks: FAILED (no response)"
fi

echo ""

# Test chat endpoints
echo "5. Testing Chat Channels..."
CHAT_CHANNELS=$(curl -s -X GET "$BASE_URL/chat/channels/" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")

if [ ! -z "$CHAT_CHANNELS" ]; then
    echo "✅ Chat Channels: SUCCESS (got response)"
else
    echo "❌ Chat Channels: FAILED (no response)"
fi

echo ""
echo "=================================="
echo "✅ API Testing Complete"
echo ""
