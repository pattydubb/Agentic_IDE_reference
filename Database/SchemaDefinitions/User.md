# User Schema Definition

This document provides a detailed definition of the `users` table, including column specifications, indexes, relationships, and common queries.

## Table Definition

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(100) NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'user',
  profile_picture VARCHAR(255) NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  last_login TIMESTAMP NULL,
  password_reset_token VARCHAR(100) NULL,
  password_reset_expires TIMESTAMP NULL,
  subscription_id UUID NULL REFERENCES subscriptions(id),
  subscription_status VARCHAR(50) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

## Column Descriptions

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| `id` | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | Unique identifier for the user |
| `email` | VARCHAR(255) | NOT NULL, UNIQUE | User's email address, used for login |
| `password` | VARCHAR(255) | NOT NULL | Hashed password |
| `name` | VARCHAR(100) | NOT NULL | User's full name |
| `role` | VARCHAR(20) | NOT NULL, DEFAULT 'user' | User's role (e.g., 'user', 'admin', 'moderator') |
| `profile_picture` | VARCHAR(255) | NULL | Path or URL to user's profile picture |
| `is_active` | BOOLEAN | NOT NULL, DEFAULT TRUE | Flag indicating if the user account is active |
| `last_login` | TIMESTAMP | NULL | Timestamp of the user's last login |
| `password_reset_token` | VARCHAR(100) | NULL | Token for password reset functionality |
| `password_reset_expires` | TIMESTAMP | NULL | Expiration timestamp for password reset token |
| `subscription_id` | UUID | NULL, REFERENCES subscriptions(id) | Foreign key to user's subscription |
| `subscription_status` | VARCHAR(50) | NULL | Status of user's subscription |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Timestamp when the user was created |
| `updated_at` | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Timestamp when the user was last updated |

## Indexes

```sql
-- For efficient email lookups during login
CREATE INDEX idx_users_email ON users(email);

-- For filtering users by role and activity status
CREATE INDEX idx_users_role_active ON users(role, is_active);

-- For subscription-related queries
CREATE INDEX idx_users_subscription_id ON users(subscription_id);
CREATE INDEX idx_users_subscription_status ON users(subscription_status);
```

## Relationships

### One-to-Many Relationships (User is the "One")

- **Addresses**: A user can have multiple addresses (shipping, billing, etc.)
  ```sql
  CREATE TABLE addresses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    -- Other address fields...
  );
  ```

- **Orders**: A user can place multiple orders
  ```sql
  CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    -- Other order fields...
  );
  ```

- **Subscriptions**: A user can have subscription history
  ```sql
  CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    -- Other subscription fields...
  );
  ```

### Many-to-Many Relationships

- **Groups/Roles**: Users can belong to multiple groups or have multiple roles
  ```sql
  CREATE TABLE user_groups (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, group_id)
  );
  ```

## Constraints

- Email must be unique
- Role must be one of the predefined values
- Password reset token must be unique when not null

## Common Queries

### Retrieve User with Profile Information

```sql
SELECT 
  u.id,
  u.email,
  u.name,
  u.role,
  u.profile_picture,
  u.is_active,
  u.last_login,
  u.created_at,
  a.street_address,
  a.city,
  a.state,
  a.postal_code,
  a.country
FROM 
  users u
LEFT JOIN 
  addresses a ON u.id = a.user_id AND a.is_default = TRUE
WHERE 
  u.id = :user_id;
```

### Find Users by Role

```sql
SELECT 
  id, 
  email, 
  name, 
  created_at
FROM 
  users
WHERE 
  role = :role
  AND is_active = TRUE
ORDER BY 
  created_at DESC;
```

### Search Users

```sql
SELECT 
  id, 
  email, 
  name, 
  role
FROM 
  users
WHERE 
  (email ILIKE :search_term OR name ILIKE :search_term)
  AND is_active = TRUE
ORDER BY 
  name ASC
LIMIT :limit OFFSET :offset;
```

### Count Users by Role

```sql
SELECT 
  role, 
  COUNT(*) as count
FROM 
  users
WHERE 
  is_active = TRUE
GROUP BY 
  role
ORDER BY 
  count DESC;
```

### Get Recent Users

```sql
SELECT 
  id, 
  email, 
  name, 
  created_at
FROM 
  users
ORDER BY 
  created_at DESC
LIMIT 10;
```

## Triggers

### Update Timestamp Trigger

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
```

## Notes and Best Practices

1. **Password Storage**: Always store hashed passwords, never plain text. The application should use a strong hashing algorithm like bcrypt.

2. **Personal Information**: Email and name fields contain personal information and should be handled according to privacy regulations (GDPR, CCPA, etc.).

3. **Role Management**: The `role` field uses a simple approach. For more complex permissions, consider a dedicated roles and permissions system.

4. **Authentication**: Use the `is_active` field to control login ability. Inactive users should not be able to log in.

5. **Profile Pictures**: The `profile_picture` field stores a path or URL. Consider using a dedicated media storage service for the actual files.

6. **Subscription Integration**: The `subscription_id` and `subscription_status` fields were added after the initial schema to support the subscription feature.

7. **Email Verification**: The schema doesn't explicitly include an email verification field. Consider adding one if email verification is required. 