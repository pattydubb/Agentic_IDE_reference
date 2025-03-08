# User Controller

This document provides documentation for the User Controller, which handles all user-related HTTP requests and responses.

## Controller Methods

### `getUsers()`
- **Endpoint**: GET `/api/users`
- **Description**: Retrieves a paginated list of users
- **Authentication**: Required (Admin)
- **Query Parameters**:
  - `page`: Page number (default: 1)
  - `limit`: Number of records per page (default: 10)
  - `sort`: Field to sort by (default: 'createdAt')
  - `order`: Sort order ('asc' or 'desc', default: 'desc')
  - `filter`: JSON object for filtering results
- **Implementation**:
  ```javascript
  const getUsers = async (req, res, next) => {
    try {
      const { page = 1, limit = 10, sort = 'createdAt', order = 'desc', filter = '{}' } = req.query;
      
      // Parse filter if provided
      const filterObj = JSON.parse(filter);
      
      // Query database with pagination and filters
      const users = await userService.findAll({
        page,
        limit,
        sort,
        order,
        filter: filterObj
      });
      
      return res.status(200).json(users);
    } catch (error) {
      next(error);
    }
  };
  ```

### `getUserById()`
- **Endpoint**: GET `/api/users/:id`
- **Description**: Retrieves a specific user by ID
- **Authentication**: Required (Admin or User themselves)
- **URL Parameters**:
  - `id`: User ID
- **Implementation**:
  ```javascript
  const getUserById = async (req, res, next) => {
    try {
      const { id } = req.params;
      
      // Check authorization
      if (!req.user.isAdmin && req.user.id !== id) {
        return res.status(403).json({ message: 'Unauthorized access' });
      }
      
      const user = await userService.findById(id);
      
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }
      
      return res.status(200).json(user);
    } catch (error) {
      next(error);
    }
  };
  ```

### `createUser()`
- **Endpoint**: POST `/api/users`
- **Description**: Creates a new user
- **Authentication**: Required (Admin)
- **Request Body**:
  ```json
  {
    "email": "user@example.com",
    "password": "securepassword",
    "name": "User Name",
    "role": "user"
  }
  ```
- **Implementation**:
  ```javascript
  const createUser = async (req, res, next) => {
    try {
      const { email, password, name, role } = req.body;
      
      // Validate input
      if (!email || !password || !name) {
        return res.status(400).json({ message: 'Missing required fields' });
      }
      
      // Check if user already exists
      const existingUser = await userService.findByEmail(email);
      if (existingUser) {
        return res.status(409).json({ message: 'User with this email already exists' });
      }
      
      // Create new user
      const newUser = await userService.create({
        email,
        password, // Service will hash this
        name,
        role: role || 'user'
      });
      
      return res.status(201).json(newUser);
    } catch (error) {
      next(error);
    }
  };
  ```

### `updateUser()`
- **Endpoint**: PUT `/api/users/:id`
- **Description**: Updates an existing user
- **Authentication**: Required (Admin or User themselves)
- **URL Parameters**:
  - `id`: User ID
- **Request Body**: Fields to update
- **Implementation**:
  ```javascript
  const updateUser = async (req, res, next) => {
    try {
      const { id } = req.params;
      const updateData = req.body;
      
      // Check authorization
      if (!req.user.isAdmin && req.user.id !== id) {
        return res.status(403).json({ message: 'Unauthorized access' });
      }
      
      // Prevent role change by non-admin
      if (!req.user.isAdmin && updateData.role) {
        delete updateData.role;
      }
      
      const updatedUser = await userService.update(id, updateData);
      
      if (!updatedUser) {
        return res.status(404).json({ message: 'User not found' });
      }
      
      return res.status(200).json(updatedUser);
    } catch (error) {
      next(error);
    }
  };
  ```

### `deleteUser()`
- **Endpoint**: DELETE `/api/users/:id`
- **Description**: Deletes a user
- **Authentication**: Required (Admin)
- **URL Parameters**:
  - `id`: User ID
- **Implementation**:
  ```javascript
  const deleteUser = async (req, res, next) => {
    try {
      const { id } = req.params;
      
      const result = await userService.delete(id);
      
      if (!result) {
        return res.status(404).json({ message: 'User not found' });
      }
      
      return res.status(204).send();
    } catch (error) {
      next(error);
    }
  };
  ```

## Error Handling

The User Controller delegates error handling to the global error middleware, passing any caught exceptions to `next(error)`. This ensures consistent error responses across the API. 