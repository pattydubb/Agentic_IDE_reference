# API Endpoints

This document provides a comprehensive list of all API endpoints in the application, including their methods, required inputs, and expected outputs.

## Endpoint Structure

| Endpoint | Method | Description | Input | Output |
|----------|--------|-------------|-------|--------|
| `/api/endpoint` | `GET/POST/PUT/DELETE` | Description of endpoint | JSON schema | JSON response |

## Authentication Endpoints

### `/api/auth/login`
- **Method**: POST
- **Description**: Authenticates a user and returns a JWT token
- **Input**: 
  ```json
  {
    "email": "user@example.com",
    "password": "securepassword"
  }
  ```
- **Output**:
  ```json
  {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "123",
      "email": "user@example.com",
      "name": "User Name"
    }
  }
  ```

## User Endpoints

### `/api/users`
- **Method**: GET
- **Description**: Retrieves a list of users
- **Authentication**: Required (Admin)
- **Output**: Array of user objects

### `/api/users/:id`
- **Method**: GET
- **Description**: Retrieves a specific user by ID
- **Authentication**: Required
- **Output**: User object

## [Resource] Endpoints

_Add sections for each major resource in your API (Products, Orders, etc.)_

## Webhook Endpoints

### `/api/webhooks/[service]`
- **Method**: POST
- **Description**: Receives webhook notifications from third-party services
- **Authentication**: API key in header
- **Input**: Varies by service
- **Output**: Acknowledgment response 