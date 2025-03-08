# Frontend State Management

This document outlines how state is managed in the frontend application, including the state management library used, store structure, and data flow patterns.

## State Management Overview

The application uses Redux for global state management, with Redux Toolkit to simplify store setup and reduce boilerplate code. Local component state is managed using React's useState and useReducer hooks where appropriate.

## Store Structure

The Redux store is organized into slices, each responsible for a specific domain of the application:

```
Store
├── auth
│   ├── user
│   ├── isAuthenticated
│   ├── loading
│   └── error
│
├── products
│   ├── items
│   ├── selectedProduct
│   ├── loading
│   ├── error
│   └── filters
│
├── cart
│   ├── items
│   ├── totalAmount
│   ├── totalItems
│   └── loading
│
├── orders
│   ├── items
│   ├── selectedOrder
│   ├── loading
│   └── error
│
└── ui
    ├── notifications
    ├── modal
    ├── theme
    └── sidebar
```

## State Management Patterns

### Authentication Flow

1. User submits login credentials
2. `auth/login` action is dispatched
3. Auth slice reducer updates loading state to true
4. API call is made to authenticate the user
5. On success:
   - `auth/loginSuccess` action is dispatched
   - User data and token are stored in state and localStorage
   - Loading state is set to false
   - isAuthenticated is set to true
6. On failure:
   - `auth/loginFailure` action is dispatched
   - Error message is stored in state
   - Loading state is set to false

### Data Fetching Pattern

For each data type (products, orders, etc.), the following pattern is used:

1. Component mounts or user action triggers data fetch
2. `{slice}/fetch{Entity}` action is dispatched
3. Slice reducer updates loading state to true
4. API call is made to fetch data
5. On success:
   - `{slice}/fetch{Entity}Success` action is dispatched
   - Data is stored in state
   - Loading state is set to false
6. On failure:
   - `{slice}/fetch{Entity}Failure` action is dispatched
   - Error message is stored in state
   - Loading state is set to false

### Form Submission Pattern

1. User submits a form
2. Form data is validated client-side
3. If validation passes:
   - `{slice}/submit{Form}` action is dispatched
   - Slice reducer updates loading state to true
   - API call is made to submit data
   - On success:
     - `{slice}/submit{Form}Success` action is dispatched
     - Success notification is shown
     - Form is reset or user is redirected
   - On failure:
     - `{slice}/submit{Form}Failure` action is dispatched
     - Error message is displayed to user
4. If validation fails:
   - Error messages are displayed inline
   - No action is dispatched

## Redux Middleware

The application uses several Redux middleware:

1. **Redux Thunk**: For handling asynchronous actions
2. **Redux Logger**: For logging actions and state changes in development
3. **Redux Persist**: For persisting specific slices of state to localStorage

## Custom Hooks

Several custom hooks are used to interact with the Redux store:

1. **useAuth**: Provides auth state and authentication methods
   ```javascript
   const { user, isAuthenticated, login, logout, register } = useAuth();
   ```

2. **useProducts**: Provides product state and methods
   ```javascript
   const { products, loading, error, fetchProducts, searchProducts } = useProducts();
   ```

3. **useCart**: Provides cart state and methods
   ```javascript
   const { items, totalAmount, addToCart, removeFromCart, clearCart } = useCart();
   ```

4. **useOrders**: Provides order state and methods
   ```javascript
   const { orders, selectedOrder, fetchOrders, getOrderDetails } = useOrders();
   ```

## Local State Management

For component-specific state that doesn't need to be shared globally, React's built-in state management is used:

1. **useState**: For simple state values
   ```javascript
   const [isOpen, setIsOpen] = useState(false);
   ```

2. **useReducer**: For more complex state logic
   ```javascript
   const [formState, dispatch] = useReducer(formReducer, initialState);
   ```

3. **useContext**: For sharing state between related components without prop drilling
   ```javascript
   const ThemeContext = createContext();
   // In parent component
   <ThemeContext.Provider value={theme}>
     <ChildComponent />
   </ThemeContext.Provider>
   // In child component
   const theme = useContext(ThemeContext);
   ```

## State Persistence

Certain parts of the state are persisted to localStorage using Redux Persist:

1. **auth**: To maintain user sessions across page refreshes
2. **cart**: To preserve cart items even if the user leaves the site
3. **ui.theme**: To remember user theme preferences

## Performance Considerations

1. **Selectors**: Memoized selectors (using Reselect) are used to efficiently derive data from the state
2. **Normalized State**: Complex entities are stored in a normalized format to avoid duplication
3. **Immutability**: All state updates follow immutability principles using Redux Toolkit's createSlice

## Example Redux Slice

```javascript
// authSlice.js
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import authService from '../services/authService';

export const login = createAsyncThunk(
  'auth/login',
  async ({ email, password }, { rejectWithValue }) => {
    try {
      return await authService.login(email, password);
    } catch (error) {
      return rejectWithValue(error.response.data);
    }
  }
);

const authSlice = createSlice({
  name: 'auth',
  initialState: {
    user: null,
    isAuthenticated: false,
    loading: false,
    error: null
  },
  reducers: {
    logout: (state) => {
      state.user = null;
      state.isAuthenticated = false;
      state.error = null;
    },
    clearError: (state) => {
      state.error = null;
    }
  },
  extraReducers: (builder) => {
    builder
      .addCase(login.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(login.fulfilled, (state, action) => {
        state.loading = false;
        state.user = action.payload.user;
        state.isAuthenticated = true;
      })
      .addCase(login.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      });
  }
});

export const { logout, clearError } = authSlice.actions;
export default authSlice.reducer;
```
