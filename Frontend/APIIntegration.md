# Frontend API Integration

This document describes how the frontend application communicates with backend APIs, including request handling, response processing, error management, and authentication.

## Overview

The frontend application interacts with the backend through a RESTful API architecture. This document outlines the patterns, libraries, and best practices used for API integration in the frontend codebase.

## API Client Configuration

### Base Setup

```javascript
// src/api/client.js
import axios from 'axios';

const apiClient = axios.create({
  baseURL: process.env.REACT_APP_API_URL || 'http://localhost:8000/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
});

export default apiClient;
```

### Authentication Interceptor

```javascript
// src/api/interceptors.js
import apiClient from './client';
import { getToken, refreshToken } from '../services/auth';

// Request interceptor for API calls
apiClient.interceptors.request.use(
  async config => {
    const token = getToken();
    if (token) {
      config.headers = {
        ...config.headers,
        Authorization: `Bearer ${token}`
      };
    }
    return config;
  },
  error => {
    Promise.reject(error);
  }
);

// Response interceptor for API calls
apiClient.interceptors.response.use(
  response => response,
  async error => {
    const originalRequest = error.config;
    
    if (error.response.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;
      const newToken = await refreshToken();
      
      if (newToken) {
        originalRequest.headers.Authorization = `Bearer ${newToken}`;
        return apiClient(originalRequest);
      }
    }
    
    return Promise.reject(error);
  }
);
```

## API Service Structure

API services are organized by resource type and follow a consistent pattern:

```javascript
// src/api/services/userService.js
import apiClient from '../client';

export const userService = {
  getUsers: async (params = {}) => {
    try {
      const response = await apiClient.get('/users', { params });
      return response.data;
    } catch (error) {
      throw error;
    }
  },
  
  getUserById: async (id) => {
    try {
      const response = await apiClient.get(`/users/${id}`);
      return response.data;
    } catch (error) {
      throw error;
    }
  },
  
  createUser: async (userData) => {
    try {
      const response = await apiClient.post('/users', userData);
      return response.data;
    } catch (error) {
      throw error;
    }
  },
  
  updateUser: async (id, userData) => {
    try {
      const response = await apiClient.put(`/users/${id}`, userData);
      return response.data;
    } catch (error) {
      throw error;
    }
  },
  
  deleteUser: async (id) => {
    try {
      const response = await apiClient.delete(`/users/${id}`);
      return response.data;
    } catch (error) {
      throw error;
    }
  }
};
```

## Error Handling

The application implements a centralized error handling mechanism that:

1. Captures API errors
2. Formats them for display
3. Logs them for monitoring
4. Provides appropriate user feedback

```javascript
// src/utils/errorHandler.js
import { toast } from 'react-toastify';
import logger from './logger';

export const handleApiError = (error, defaultMessage = 'An error occurred') => {
  // Extract error message from response
  const errorMessage = error.response?.data?.message || 
                       error.message || 
                       defaultMessage;
  
  // Log error
  logger.error('API Error:', {
    message: errorMessage,
    status: error.response?.status,
    path: error.config?.url,
    method: error.config?.method?.toUpperCase(),
  });
  
  // Show toast notification to user
  toast.error(errorMessage);
  
  // Return formatted error for component use
  return {
    message: errorMessage,
    status: error.response?.status || 500,
    isApiError: true
  };
};
```

## Data Transformation

API responses often need transformation before they can be used effectively in the frontend application. The following patterns are used for data transformation:

```javascript
// src/utils/transformers.js
export const normalizeUser = (user) => ({
  id: user.id,
  name: user.name,
  email: user.email,
  role: user.role,
  isActive: user.is_active,  // Convert snake_case to camelCase
  created: new Date(user.created_at),
  profileUrl: user.profile_picture ? `/images/profiles/${user.profile_picture}` : null
});

export const normalizeUsers = (users) => users.map(normalizeUser);

export const denormalizeUser = (user) => ({
  name: user.name,
  email: user.email,
  role: user.role,
  is_active: user.isActive,  // Convert camelCase to snake_case
  profile_picture: user.profileUrl ? user.profileUrl.split('/').pop() : null
});
```

## Integration with State Management

API services are integrated with Redux through action creators and thunks:

```javascript
// src/store/users/actions.js
import { userService } from '../../api/services/userService';
import { handleApiError } from '../../utils/errorHandler';
import { normalizeUsers, normalizeUser } from '../../utils/transformers';

// Action types
export const USER_ACTIONS = {
  FETCH_USERS_REQUEST: 'FETCH_USERS_REQUEST',
  FETCH_USERS_SUCCESS: 'FETCH_USERS_SUCCESS',
  FETCH_USERS_FAILURE: 'FETCH_USERS_FAILURE',
  // Additional action types...
};

// Action creators
export const fetchUsers = () => async (dispatch) => {
  dispatch({ type: USER_ACTIONS.FETCH_USERS_REQUEST });
  
  try {
    const users = await userService.getUsers();
    dispatch({ 
      type: USER_ACTIONS.FETCH_USERS_SUCCESS, 
      payload: normalizeUsers(users)
    });
  } catch (error) {
    const formattedError = handleApiError(error, 'Failed to fetch users');
    dispatch({ 
      type: USER_ACTIONS.FETCH_USERS_FAILURE, 
      payload: formattedError
    });
  }
};

// Additional action creators for CRUD operations...
```

## API Hooks (React Query)

For components that need direct API access, custom hooks using React Query are provided:

```javascript
// src/hooks/useUsers.js
import { useQuery, useMutation, useQueryClient } from 'react-query';
import { userService } from '../api/services/userService';
import { normalizeUsers, normalizeUser, denormalizeUser } from '../utils/transformers';
import { handleApiError } from '../utils/errorHandler';

export const useUsers = (params = {}) => {
  return useQuery(
    ['users', params],
    async () => {
      const data = await userService.getUsers(params);
      return normalizeUsers(data);
    },
    {
      onError: (error) => handleApiError(error, 'Failed to fetch users')
    }
  );
};

export const useUser = (id) => {
  return useQuery(
    ['user', id],
    async () => {
      const data = await userService.getUserById(id);
      return normalizeUser(data);
    },
    {
      enabled: !!id,
      onError: (error) => handleApiError(error, `Failed to fetch user ${id}`)
    }
  );
};

export const useCreateUser = () => {
  const queryClient = useQueryClient();
  
  return useMutation(
    async (userData) => {
      const normalized = denormalizeUser(userData);
      const response = await userService.createUser(normalized);
      return normalizeUser(response);
    },
    {
      onSuccess: () => {
        queryClient.invalidateQueries('users');
      },
      onError: (error) => handleApiError(error, 'Failed to create user')
    }
  );
};

// Additional hooks for update and delete operations...
```

## Mock API for Development

During development, a mock API using MSW (Mock Service Worker) is used to simulate backend responses:

```javascript
// src/mocks/handlers.js
import { rest } from 'msw';

const BASE_URL = 'http://localhost:8000/api';

export const handlers = [
  rest.get(`${BASE_URL}/users`, (req, res, ctx) => {
    return res(
      ctx.status(200),
      ctx.json([
        {
          id: '1',
          name: 'John Doe',
          email: 'john@example.com',
          role: 'admin',
          is_active: true,
          created_at: '2023-01-15T08:30:00Z',
          profile_picture: null
        },
        // Additional mock users...
      ])
    );
  }),
  
  rest.get(`${BASE_URL}/users/:id`, (req, res, ctx) => {
    const { id } = req.params;
    
    // Mock logic to return a specific user or 404
    // ...
    
    return res(
      ctx.status(200),
      ctx.json({
        id,
        name: 'John Doe',
        email: 'john@example.com',
        role: 'admin',
        is_active: true,
        created_at: '2023-01-15T08:30:00Z',
        profile_picture: null
      })
    );
  }),
  
  // Additional handlers for other endpoints...
];
```

## API Documentation

For a complete list of available API endpoints, request formats, and response structures, refer to the [Backend Endpoints Documentation](../Backend/Endpoints.md).

## Best Practices

1. **Error Handling**: Always handle potential API errors and provide appropriate user feedback.
2. **Loading States**: Show loading indicators during API requests to improve user experience.
3. **Data Transformation**: Transform API data into frontend-friendly formats.
4. **Caching**: Implement appropriate caching strategies using React Query or Redux.
5. **Authentication**: Always include authentication headers for protected endpoints.
6. **Pagination**: Implement pagination for endpoints that return large datasets.
7. **Retry Logic**: Add retry logic for transient network errors.
8. **Cancellation**: Cancel pending requests when components unmount.
9. **Throttling/Debouncing**: Implement throttling or debouncing for search endpoints.
10. **Request Batching**: Batch related requests to reduce network overhead. 