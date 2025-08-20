# API Endpoint Fixes for MusicBud Flutter App

## Overview

This document outlines the fixes applied to resolve 404 Dio exceptions in the MusicBud Flutter app by aligning the API endpoints with the backend repository structure.

## Backend Repository Reference

- **Repository**: [musicbud/backend](https://github.com/musicbud/backend)
- **Base URL**: `http://84.235.170.234`
- **API Version**: `v1`

## Issues Identified and Fixed

### 1. Incorrect Base URL Configuration
- **Before**: `http://84.235.170.234/v1`
- **After**: `http://84.235.170.234`
- **Reason**: Backend doesn't use `/v1` in the base URL

### 2. Mismatched API Endpoints
Several endpoints were using incorrect paths that didn't match the backend structure:

#### Authentication Endpoints
- ✅ `/login/` (was `/auth/login`)
- ✅ `/register/` (was `/auth/register`)
- ✅ `/chat/refresh-token/` (was `/auth/refresh`)

#### Profile Endpoints
- ✅ `/me/profile` (was `/users/profile`)
- ✅ `/bud/profile` (was `/buds/profile`)
- ✅ `/me/profile/set` (was `/profile/update`)

#### Chat Endpoints
- ✅ `/chat/login/` (was `/chat/auth`)
- ✅ `/chat/get_channels/` (was `/channels`)
- ✅ `/chat/create_channel/` (was `/channels/create`)

#### Service Connection Endpoints
- ✅ `/service/spotify/auth` (was `/spotify/auth`)
- ✅ `/service/spotify/connect` (was `/spotify/connect`)
- ✅ `/service/spotify/disconnect` (was `/spotify/disconnect`)

### 3. Enhanced Error Handling
- Added comprehensive Dio exception handling
- Implemented specific 404 error detection and logging
- Added user-friendly error messages
- Enhanced debugging information for API calls

## Files Modified

### 1. `lib/config/api_config.dart`
- Centralized all API endpoint constants
- Added comprehensive endpoint definitions
- Organized endpoints by category (auth, profile, chat, services)

### 2. `lib/utils/http_utils.dart`
- Enhanced error handling utilities
- Added specific error type detection (404, 401, 500, etc.)
- Implemented user-friendly error messages
- Added comprehensive logging for debugging

### 3. `lib/data/network/dio_client.dart`
- Enhanced Dio wrapper with better error handling
- Added request/response logging
- Implemented specific 404 error detection
- Added helpful debugging information

### 4. `lib/utils/api_endpoint_validator.dart`
- Created endpoint validation utility
- Added endpoint similarity suggestions
- Implemented startup validation
- Provides debugging information for mismatched endpoints

### 5. Data Source Files
- Updated all remote data sources to use correct endpoints
- Fixed authentication, profile, chat, and user data sources
- Ensured consistent endpoint usage across the app

## How to Handle Future 404 Errors

### 1. Automatic Detection
The app now automatically detects 404 errors and provides helpful information:
```
🚨 404 Error detected for GET http://84.235.170.234/invalid/endpoint
💡 This endpoint may not exist in the backend API
📚 Check the backend repository for correct endpoints: https://github.com/musicbud/backend
🔧 Consider updating the API configuration if endpoints have changed
```

### 2. Endpoint Validation
On app startup, the app validates all endpoints and reports any issues:
```
🔍 Validating API endpoints...
✅ /login/
❌ /invalid/endpoint (INVALID)
📊 Endpoint Validation Results:
✅ Valid endpoints: 15
❌ Invalid endpoints: 1
```

### 3. Similar Endpoint Suggestions
When a 404 occurs, use the validator to get suggestions:
```dart
final suggestions = ApiEndpointValidator.getSimilarEndpoints('/invalid/endpoint');
// Returns: ['/valid/endpoint', '/similar/endpoint']
```

### 4. Debugging Steps
1. **Check the console logs** for detailed error information
2. **Verify the backend repository** for correct endpoints
3. **Use the endpoint validator** to check endpoint validity
4. **Update ApiConfig.dart** with correct endpoints
5. **Test the endpoint** with a tool like Postman

## Best Practices for API Endpoints

### 1. Always Use Constants
```dart
// ✅ Good
final response = await dioClient.get(ApiConfig.myProfile);

// ❌ Bad
final response = await dioClient.get('/me/profile');
```

### 2. Centralize Endpoint Definitions
All endpoints should be defined in `ApiConfig.dart` to ensure consistency and easy maintenance.

### 3. Validate Endpoints
Use the `ApiEndpointValidator` to check endpoint validity before making API calls.

### 4. Handle Errors Gracefully
Always catch Dio exceptions and provide meaningful error messages to users.

### 5. Log API Calls
Enable detailed logging in debug mode to track API requests and responses.

## Testing API Endpoints

### 1. Use Postman Collection
The backend repository includes a Postman collection for testing endpoints:
- Download from: [Postman Collection](https://github.com/musicbud/backend/tree/main/postman_collection)

### 2. Test with Backend Running
Ensure the backend server is running and accessible before testing:
```bash
# Check if backend is accessible
curl http://84.235.170.234/health
```

### 3. Verify Authentication
Most endpoints require authentication. Ensure you have a valid token:
```dart
// Get token from login
final loginResponse = await authRepository.login(username, password);
final token = loginResponse['access_token'];
```

## Common Issues and Solutions

### 1. 404 Errors
- **Cause**: Endpoint doesn't exist or has been moved
- **Solution**: Check backend repository and update ApiConfig.dart

### 2. 401 Unauthorized
- **Cause**: Invalid or expired authentication token
- **Solution**: Refresh token or re-authenticate user

### 3. 500 Server Errors
- **Cause**: Backend server issues
- **Solution**: Check backend logs and server status

### 4. Connection Timeouts
- **Cause**: Network issues or server unresponsive
- **Solution**: Check internet connection and server availability

## Monitoring and Maintenance

### 1. Regular Endpoint Validation
The app automatically validates endpoints on startup. Monitor the console for any validation failures.

### 2. Backend Repository Updates
Regularly check the backend repository for endpoint changes or updates.

### 3. Error Logging
Monitor error logs to identify patterns in API failures.

### 4. User Feedback
Collect user feedback about API errors to identify potential endpoint issues.

## Conclusion

These fixes ensure that the MusicBud Flutter app correctly communicates with the backend API. The enhanced error handling and validation utilities will help identify and resolve future API endpoint issues quickly.

For additional support or questions about the backend API, refer to the [musicbud/backend](https://github.com/musicbud/backend) repository documentation.