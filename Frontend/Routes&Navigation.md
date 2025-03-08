# Frontend Routes & Navigation

This document outlines the routing structure of the frontend application, including route paths, associated components, access control, and navigation patterns.

## Routing Library

The application uses React Router v6 for client-side routing. This provides declarative routing with support for nested routes, route parameters, query parameters, and navigation guards.

## Route Structure

```
/                           - HomePage
├── auth/
│   ├── login               - LoginPage
│   ├── register            - RegisterPage
│   ├── forgot-password     - ForgotPasswordPage
│   └── reset-password      - ResetPasswordPage
│
├── products/
│   ├── :categoryId?        - ProductsPage (optional category filter)
│   └── :productId          - ProductDetailPage
│
├── cart                    - CartPage
│
├── checkout/
│   ├── information         - CheckoutInformationPage
│   ├── shipping            - CheckoutShippingPage
│   ├── payment             - CheckoutPaymentPage
│   └── confirmation        - CheckoutConfirmationPage
│
├── orders/
│   ├── /                   - OrdersPage
│   └── :orderId            - OrderDetailPage
│
├── account/
│   ├── profile             - ProfilePage
│   ├── addresses           - AddressesPage
│   ├── orders              - UserOrdersPage
│   ├── wishlist            - WishlistPage
│   └── settings            - SettingsPage
│
├── admin/                  - Protected admin routes
│   ├── dashboard           - AdminDashboardPage
│   ├── products            - AdminProductsPage
│   ├── orders              - AdminOrdersPage
│   └── users               - AdminUsersPage
│
└── *                       - NotFoundPage
```

## Route Configuration

The routes are defined in a centralized router configuration:

```jsx
// src/router/index.jsx
import { createBrowserRouter } from 'react-router-dom';
import Layout from '../components/Layout';
import HomePage from '../pages/HomePage';
import ProductsPage from '../pages/ProductsPage';
import ProductDetailPage from '../pages/ProductDetailPage';
import CartPage from '../pages/CartPage';
import LoginPage from '../pages/auth/LoginPage';
import RegisterPage from '../pages/auth/RegisterPage';
import NotFoundPage from '../pages/NotFoundPage';
import ProtectedRoute from './ProtectedRoute';
import AdminRoute from './AdminRoute';
// ... other imports

const router = createBrowserRouter([
  {
    path: '/',
    element: <Layout />,
    children: [
      { index: true, element: <HomePage /> },
      { path: 'products', element: <ProductsPage /> },
      { path: 'products/:productId', element: <ProductDetailPage /> },
      { path: 'cart', element: <CartPage /> },
      { 
        path: 'checkout',
        element: <ProtectedRoute><CheckoutLayout /></ProtectedRoute>,
        children: [
          { path: 'information', element: <CheckoutInformationPage /> },
          { path: 'shipping', element: <CheckoutShippingPage /> },
          { path: 'payment', element: <CheckoutPaymentPage /> },
          { path: 'confirmation', element: <CheckoutConfirmationPage /> },
        ]
      },
      {
        path: 'account',
        element: <ProtectedRoute><AccountLayout /></ProtectedRoute>,
        children: [
          { path: 'profile', element: <ProfilePage /> },
          { path: 'addresses', element: <AddressesPage /> },
          { path: 'orders', element: <UserOrdersPage /> },
          { path: 'wishlist', element: <WishlistPage /> },
          { path: 'settings', element: <SettingsPage /> },
        ]
      },
      {
        path: 'admin',
        element: <AdminRoute><AdminLayout /></AdminRoute>,
        children: [
          { path: 'dashboard', element: <AdminDashboardPage /> },
          { path: 'products', element: <AdminProductsPage /> },
          { path: 'orders', element: <AdminOrdersPage /> },
          { path: 'users', element: <AdminUsersPage /> },
        ]
      },
      { path: 'auth/login', element: <LoginPage /> },
      { path: 'auth/register', element: <RegisterPage /> },
      { path: 'auth/forgot-password', element: <ForgotPasswordPage /> },
      { path: 'auth/reset-password', element: <ResetPasswordPage /> },
      { path: '*', element: <NotFoundPage /> },
    ],
  },
]);

export default router;
```

## Access Control

Routes are protected using wrapper components that check authentication status and user roles:

### Protected Route (requires authentication)

```jsx
// src/router/ProtectedRoute.jsx
import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';

const ProtectedRoute = ({ children }) => {
  const { isAuthenticated } = useAuth();
  const location = useLocation();

  if (!isAuthenticated) {
    // Redirect to login page with return URL
    return <Navigate to="/auth/login" state={{ from: location }} replace />;
  }

  return children;
};

export default ProtectedRoute;
```

### Admin Route (requires admin role)

```jsx
// src/router/AdminRoute.jsx
import { Navigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';

const AdminRoute = ({ children }) => {
  const { user, isAuthenticated } = useAuth();

  if (!isAuthenticated || user?.role !== 'admin') {
    // Redirect unauthorized users to home page
    return <Navigate to="/" replace />;
  }

  return children;
};

export default AdminRoute;
```

## Navigation Components

### Main Navigation

The main navigation is rendered in the Header component:

```jsx
// src/components/Layout/Header/Navigation.jsx
import { NavLink } from 'react-router-dom';

const Navigation = () => {
  return (
    <nav className="main-nav">
      <ul>
        <li>
          <NavLink to="/" end>Home</NavLink>
        </li>
        <li>
          <NavLink to="/products">Products</NavLink>
        </li>
        {/* More navigation links */}
      </ul>
    </nav>
  );
};

export default Navigation;
```

### User Menu

The user menu changes based on authentication status:

```jsx
// src/components/Layout/Header/UserMenu.jsx
import { Link } from 'react-router-dom';
import { useAuth } from '../../../hooks/useAuth';

const UserMenu = () => {
  const { user, isAuthenticated, logout } = useAuth();

  if (!isAuthenticated) {
    return (
      <div className="user-menu">
        <Link to="/auth/login" className="btn btn-outline">Login</Link>
        <Link to="/auth/register" className="btn btn-primary">Register</Link>
      </div>
    );
  }

  return (
    <div className="user-menu dropdown">
      <button className="dropdown-toggle">
        {user.name || 'My Account'}
      </button>
      <div className="dropdown-menu">
        <Link to="/account/profile">Profile</Link>
        <Link to="/account/orders">Orders</Link>
        <Link to="/account/wishlist">Wishlist</Link>
        <Link to="/account/settings">Settings</Link>
        {user.role === 'admin' && (
          <Link to="/admin/dashboard">Admin Dashboard</Link>
        )}
        <button onClick={logout}>Logout</button>
      </div>
    </div>
  );
};

export default UserMenu;
```

### Breadcrumbs

Breadcrumbs are used to show the current location in the application hierarchy:

```jsx
// src/components/UI/Breadcrumbs.jsx
import { Link, useLocation } from 'react-router-dom';

const Breadcrumbs = () => {
  const location = useLocation();
  const pathnames = location.pathname.split('/').filter(x => x);

  return (
    <nav aria-label="breadcrumb">
      <ol className="breadcrumb">
        <li className="breadcrumb-item">
          <Link to="/">Home</Link>
        </li>
        {pathnames.map((value, index) => {
          const isLast = index === pathnames.length - 1;
          const to = `/${pathnames.slice(0, index + 1).join('/')}`;
          
          // Format the breadcrumb text (capitalize, replace hyphens, etc.)
          const formattedValue = value
            .replace(/-/g, ' ')
            .replace(/\b\w/g, l => l.toUpperCase());
          
          return (
            <li 
              key={to} 
              className={`breadcrumb-item ${isLast ? 'active' : ''}`}
              aria-current={isLast ? 'page' : undefined}
            >
              {isLast ? formattedValue : <Link to={to}>{formattedValue}</Link>}
            </li>
          );
        })}
      </ol>
    </nav>
  );
};

export default Breadcrumbs;
```

## Programmatic Navigation

For programmatic navigation (e.g., after form submission or based on user actions), the `useNavigate` hook is used:

```jsx
// Example of programmatic navigation
import { useNavigate } from 'react-router-dom';

const CheckoutButton = ({ cartItems }) => {
  const navigate = useNavigate();
  const { isAuthenticated } = useAuth();

  const handleCheckout = () => {
    if (cartItems.length === 0) {
      // Show error message
      return;
    }

    if (!isAuthenticated) {
      // Redirect to login with return URL
      navigate('/auth/login', { state: { from: '/checkout/information' } });
    } else {
      // Proceed to checkout
      navigate('/checkout/information');
    }
  };

  return (
    <button onClick={handleCheckout} className="btn btn-primary">
      Proceed to Checkout
    </button>
  );
};
```

## Route Parameters and Query Parameters

### Route Parameters

Route parameters are used for dynamic routes:

```jsx
// src/pages/ProductDetailPage.jsx
import { useParams } from 'react-router-dom';
import { useEffect } from 'react';
import { useProducts } from '../hooks/useProducts';

const ProductDetailPage = () => {
  const { productId } = useParams();
  const { selectedProduct, loading, error, fetchProductById } = useProducts();

  useEffect(() => {
    fetchProductById(productId);
  }, [productId, fetchProductById]);

  // Render product details
};
```

### Query Parameters

Query parameters are used for filtering, sorting, and pagination:

```jsx
// src/pages/ProductsPage.jsx
import { useSearchParams } from 'react-router-dom';
import { useEffect } from 'react';
import { useProducts } from '../hooks/useProducts';

const ProductsPage = () => {
  const [searchParams, setSearchParams] = useSearchParams();
  const { products, loading, error, fetchProducts } = useProducts();

  // Extract query parameters
  const category = searchParams.get('category');
  const page = parseInt(searchParams.get('page') || '1', 10);
  const sort = searchParams.get('sort') || 'newest';
  
  useEffect(() => {
    fetchProducts({ category, page, sort });
  }, [category, page, sort, fetchProducts]);

  // Handle filter changes
  const handleFilterChange = (filterName, value) => {
    setSearchParams(prev => {
      // Create a new URLSearchParams object
      const newParams = new URLSearchParams(prev);
      
      if (value) {
        newParams.set(filterName, value);
      } else {
        newParams.delete(filterName);
      }
      
      // Reset page when filters change
      if (filterName !== 'page') {
        newParams.set('page', '1');
      }
      
      return newParams;
    });
  };

  // Render products with filters and pagination
};
```

## Nested Routes

Nested routes are used for layouts with multiple sub-views:

```jsx
// src/pages/account/AccountLayout.jsx
import { Outlet } from 'react-router-dom';
import AccountSidebar from '../../components/Account/AccountSidebar';

const AccountLayout = () => {
  return (
    <div className="account-layout">
      <AccountSidebar />
      <main className="account-content">
        <Outlet />
      </main>
    </div>
  );
};

export default AccountLayout;
```

## Lazy Loading Routes

For better performance, routes are lazy-loaded using React.lazy and Suspense:

```jsx
// src/router/index.jsx
import { lazy, Suspense } from 'react';
import { createBrowserRouter } from 'react-router-dom';
import LoadingSpinner from '../components/UI/LoadingSpinner';

// Lazy load pages
const HomePage = lazy(() => import('../pages/HomePage'));
const ProductsPage = lazy(() => import('../pages/ProductsPage'));
const ProductDetailPage = lazy(() => import('../pages/ProductDetailPage'));
// ... other lazy imports

// Wrap lazy components with Suspense
const withSuspense = (Component) => (
  <Suspense fallback={<LoadingSpinner />}>
    <Component />
  </Suspense>
);

const router = createBrowserRouter([
  {
    path: '/',
    element: <Layout />,
    children: [
      { index: true, element: withSuspense(HomePage) },
      { path: 'products', element: withSuspense(ProductsPage) },
      { path: 'products/:productId', element: withSuspense(ProductDetailPage) },
      // ... other routes
    ],
  },
]);

export default router;
```

## Navigation Guards

Navigation guards are used to prevent users from navigating away from forms with unsaved changes:

```jsx
// src/hooks/useNavigationPrompt.js
import { useCallback, useEffect } from 'react';
import { useBlocker } from 'react-router-dom';

export const useNavigationPrompt = (
  shouldBlock,
  message = 'You have unsaved changes. Are you sure you want to leave?'
) => {
  const blocker = useBlocker(shouldBlock);

  const handleBeforeUnload = useCallback(
    (event) => {
      if (shouldBlock) {
        event.preventDefault();
        event.returnValue = message;
        return message;
      }
    },
    [shouldBlock, message]
  );

  useEffect(() => {
    if (shouldBlock) {
      window.addEventListener('beforeunload', handleBeforeUnload);
      return () => {
        window.removeEventListener('beforeunload', handleBeforeUnload);
      };
    }
  }, [shouldBlock, handleBeforeUnload]);

  return blocker;
};

// Usage in a form component
const CheckoutForm = () => {
  const [formData, setFormData] = useState({});
  const [isDirty, setIsDirty] = useState(false);
  
  const blocker = useNavigationPrompt(isDirty);
  
  if (blocker.state === 'blocked') {
    return (
      <Modal isOpen={true} onClose={() => blocker.reset()}>
        <h2>Unsaved Changes</h2>
        <p>You have unsaved changes. Are you sure you want to leave?</p>
        <div className="modal-actions">
          <button onClick={() => blocker.reset()}>Stay</button>
          <button onClick={() => blocker.proceed()}>Leave</button>
        </div>
      </Modal>
    );
  }
  
  // Form implementation
};
```

## URL Synchronization with State

The application keeps the URL synchronized with the application state for shareable links and browser history:

```jsx
// Example of synchronizing filters with URL
const ProductFilters = () => {
  const [searchParams, setSearchParams] = useSearchParams();
  
  // Initialize state from URL
  const [filters, setFilters] = useState({
    category: searchParams.get('category') || '',
    minPrice: searchParams.get('minPrice') || '',
    maxPrice: searchParams.get('maxPrice') || '',
    // ... other filters
  });
  
  // Update URL when filters change
  const handleFilterChange = (name, value) => {
    const newFilters = { ...filters, [name]: value };
    setFilters(newFilters);
    
    // Update URL search params
    setSearchParams(prev => {
      const newParams = new URLSearchParams(prev);
      
      Object.entries(newFilters).forEach(([key, val]) => {
        if (val) {
          newParams.set(key, val);
        } else {
          newParams.delete(key);
        }
      });
      
      // Reset page when filters change
      newParams.set('page', '1');
      
      return newParams;
    });
  };
  
  // Filter UI implementation
};
```
