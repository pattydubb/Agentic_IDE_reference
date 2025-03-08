# Authentication Service

This document provides documentation for the authentication service, which handles user authentication, authorization, and session management.

## Service Overview

The authentication service is responsible for:
- User registration and login
- Password management (reset, change)
- JWT token generation and validation
- Session management
- Role-based access control

## Implementation Details

### Authentication Provider

This application uses [Provider Name, e.g., Supabase Auth, Auth0, Firebase Authentication] for authentication services.

### Configuration

```javascript
// Configuration settings for authentication service
const authConfig = {
  jwtSecret: process.env.JWT_SECRET,
  jwtExpiresIn: '1d',
  refreshTokenExpiresIn: '7d',
  passwordResetTokenExpiresIn: '1h',
  bcryptSaltRounds: 10
};
```

## Authentication Flows

### Registration Flow

1. User submits registration form with email, password, and other required fields
2. Backend validates input data (email format, password strength, etc.)
3. Checks if email is already registered
4. Creates a new user record with hashed password
5. Sends verification email (optional)
6. Returns success response with user data (excluding sensitive information)

### Login Flow

1. User submits login form with email and password
2. Backend validates credentials against the database
3. If valid, generates JWT access token and refresh token
4. Updates last login timestamp
5. Returns tokens and user data to the client

### Password Reset Flow

1. User requests password reset by providing email
2. System generates a password reset token and stores its hash
3. Sends password reset link with token to user's email
4. User clicks link and enters new password
5. System validates token and updates password
6. All active sessions are invalidated (optional)

## JWT Token Structure

```javascript
// Access token payload
{
  "sub": "user_id",
  "email": "user@example.com",
  "name": "User Name",
  "role": "user",
  "iat": 1615482124,
  "exp": 1615568524
}

// Refresh token payload
{
  "sub": "user_id",
  "type": "refresh",
  "iat": 1615482124,
  "exp": 1616086924
}
```

## Security Measures

- **Password Hashing**: Passwords are hashed using bcrypt with a salt
- **Token Expiration**: Short-lived access tokens with refresh capability
- **HTTPS Only**: All authentication requests must use HTTPS
- **Rate Limiting**: Protection against brute force attacks
- **CSRF Protection**: Implementation of CSRF tokens for form submissions
- **Session Invalidation**: Ability to revoke all active sessions
- **2FA Support**: Two-factor authentication for additional security (optional)

## Integration with Frontend

### Login Example

```javascript
// Frontend login request
const login = async (email, password) => {
  try {
    const response = await api.post('/auth/login', { email, password });
    
    const { accessToken, refreshToken, user } = response.data;
    
    // Store tokens in secure storage
    localStorage.setItem('accessToken', accessToken);
    localStorage.setItem('refreshToken', refreshToken);
    
    // Store user data in application state
    store.dispatch(setUser(user));
    
    return user;
  } catch (error) {
    console.error('Login failed:', error);
    throw error;
  }
};
```

### Authentication Middleware

```javascript
// Backend authentication middleware
const authenticate = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'Authentication required' });
    }
    
    const token = authHeader.split(' ')[1];
    
    const decoded = jwt.verify(token, authConfig.jwtSecret);
    
    const user = await User.findById(decoded.sub);
    
    if (!user || !user.isActive) {
      return res.status(401).json({ message: 'User not found or inactive' });
    }
    
    req.user = user;
    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ message: 'Token expired' });
    }
    
    return res.status(401).json({ message: 'Invalid token' });
  }
};
```

## Third-Party OAuth Integration

The authentication service supports the following OAuth providers:
- Google
- Facebook
- GitHub
- Apple

### OAuth Flow

1. User clicks OAuth provider button
2. User is redirected to provider's authentication page
3. User grants permissions
4. Provider redirects back to application with authorization code
5. Backend exchanges code for tokens with provider's API
6. User is authenticated or registered based on the provided email 