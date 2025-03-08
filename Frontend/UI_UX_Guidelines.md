# UI/UX Guidelines

This document outlines the design system, user experience principles, and styling guidelines for the frontend application.

## Design Principles

The application follows these core design principles:

1. **Clarity**: UI should be intuitive and self-explanatory, minimizing cognitive load.
2. **Consistency**: Patterns, interactions, and visual elements should be consistent throughout the application.
3. **Feedback**: Users should receive clear feedback for all actions and state changes.
4. **Efficiency**: Minimize the steps required to complete common tasks.
5. **Accessibility**: Design for all users regardless of abilities or disabilities.
6. **Responsiveness**: Application should adapt gracefully to different screen sizes and devices.

## Design System

### Color Palette

```css
:root {
  /* Primary Colors */
  --primary-50: #e6f7ff;
  --primary-100: #bae7ff;
  --primary-200: #91d5ff;
  --primary-300: #69c0ff;
  --primary-400: #40a9ff;
  --primary-500: #1890ff; /* Primary Brand Color */
  --primary-600: #096dd9;
  --primary-700: #0050b3;
  --primary-800: #003a8c;
  --primary-900: #002766;
  
  /* Neutral Colors */
  --neutral-50: #fafafa;
  --neutral-100: #f5f5f5;
  --neutral-200: #e5e5e5;
  --neutral-300: #d4d4d4;
  --neutral-400: #a3a3a3;
  --neutral-500: #737373;
  --neutral-600: #525252;
  --neutral-700: #404040;
  --neutral-800: #262626;
  --neutral-900: #171717;
  
  /* Success Colors */
  --success-50: #ecfdf5;
  --success-500: #10b981;
  --success-700: #047857;
  
  /* Warning Colors */
  --warning-50: #fffbeb;
  --warning-500: #f59e0b;
  --warning-700: #b45309;
  
  /* Error Colors */
  --error-50: #fef2f2;
  --error-500: #ef4444;
  --error-700: #b91c1c;
  
  /* Info Colors */
  --info-50: #eff6ff;
  --info-500: #3b82f6;
  --info-700: #1d4ed8;
}
```

### Typography

```css
:root {
  /* Font Families */
  --font-primary: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  --font-monospace: 'JetBrains Mono', 'SF Mono', 'Fira Code', Consolas, Monaco, 'Andale Mono', monospace;
  
  /* Font Sizes */
  --font-size-xs: 0.75rem;   /* 12px */
  --font-size-sm: 0.875rem;  /* 14px */
  --font-size-md: 1rem;      /* 16px - Base size */
  --font-size-lg: 1.125rem;  /* 18px */
  --font-size-xl: 1.25rem;   /* 20px */
  --font-size-2xl: 1.5rem;   /* 24px */
  --font-size-3xl: 1.875rem; /* 30px */
  --font-size-4xl: 2.25rem;  /* 36px */
  --font-size-5xl: 3rem;     /* 48px */
  
  /* Line Heights */
  --line-height-tight: 1.25;
  --line-height-normal: 1.5;
  --line-height-relaxed: 1.75;
  
  /* Font Weights */
  --font-weight-regular: 400;
  --font-weight-medium: 500;
  --font-weight-semibold: 600;
  --font-weight-bold: 700;
}
```

### Spacing

```css
:root {
  /* Spacing Scale (in pixels) */
  --space-0: 0;
  --space-1: 0.25rem;  /* 4px */
  --space-2: 0.5rem;   /* 8px */
  --space-3: 0.75rem;  /* 12px */
  --space-4: 1rem;     /* 16px */
  --space-5: 1.25rem;  /* 20px */
  --space-6: 1.5rem;   /* 24px */
  --space-8: 2rem;     /* 32px */
  --space-10: 2.5rem;  /* 40px */
  --space-12: 3rem;    /* 48px */
  --space-16: 4rem;    /* 64px */
  --space-20: 5rem;    /* 80px */
  --space-24: 6rem;    /* 96px */
}
```

### Border Radius

```css
:root {
  --radius-none: 0;
  --radius-sm: 0.125rem;  /* 2px */
  --radius-md: 0.25rem;   /* 4px */
  --radius-lg: 0.5rem;    /* 8px */
  --radius-xl: 0.75rem;   /* 12px */
  --radius-2xl: 1rem;     /* 16px */
  --radius-3xl: 1.5rem;   /* 24px */
  --radius-full: 9999px;
}
```

### Shadows

```css
:root {
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  --shadow-2xl: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
  --shadow-inner: inset 0 2px 4px 0 rgba(0, 0, 0, 0.06);
}
```

## Component Style Guide

### Buttons

Buttons follow a consistent style with variants for different purposes:

```jsx
// Primary Button
<button className="btn btn-primary">Primary Action</button>

// Secondary Button
<button className="btn btn-secondary">Secondary Action</button>

// Tertiary/Text Button
<button className="btn btn-tertiary">Tertiary Action</button>

// Danger Button
<button className="btn btn-danger">Destructive Action</button>

// Ghost Button
<button className="btn btn-ghost">Ghost Action</button>

// Icon Button
<button className="btn-icon" aria-label="Add item">
  <PlusIcon />
</button>
```

CSS implementation:

```css
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-weight: var(--font-weight-medium);
  font-size: var(--font-size-sm);
  padding: var(--space-2) var(--space-4);
  border-radius: var(--radius-md);
  transition: all 150ms ease-in-out;
  cursor: pointer;
}

.btn-primary {
  background-color: var(--primary-500);
  color: white;
  border: 1px solid var(--primary-500);
}

.btn-primary:hover {
  background-color: var(--primary-600);
  border-color: var(--primary-600);
}

/* Additional button styles... */
```

### Form Controls

Form controls should maintain consistent styling and behavior:

```jsx
// Text Input
<div className="form-control">
  <label htmlFor="username">Username</label>
  <input 
    id="username" 
    type="text" 
    className="input" 
    placeholder="Enter username" 
  />
  <span className="form-hint">Must be at least 4 characters</span>
</div>

// Checkbox
<div className="form-control-checkbox">
  <input id="remember" type="checkbox" className="checkbox" />
  <label htmlFor="remember">Remember me</label>
</div>

// Radio Group
<div className="form-control">
  <label className="form-label">Notification Preference</label>
  <div className="radio-group">
    <div className="radio-option">
      <input id="email" type="radio" name="notification" value="email" className="radio" />
      <label htmlFor="email">Email</label>
    </div>
    <div className="radio-option">
      <input id="sms" type="radio" name="notification" value="sms" className="radio" />
      <label htmlFor="sms">SMS</label>
    </div>
  </div>
</div>
```

CSS implementation:

```css
.form-control {
  display: flex;
  flex-direction: column;
  margin-bottom: var(--space-4);
}

.form-label {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  margin-bottom: var(--space-1);
  color: var(--neutral-700);
}

.input {
  padding: var(--space-2) var(--space-3);
  font-size: var(--font-size-md);
  border: 1px solid var(--neutral-300);
  border-radius: var(--radius-md);
  transition: border-color 150ms ease-in-out;
}

.input:focus {
  outline: none;
  border-color: var(--primary-400);
  box-shadow: 0 0 0 3px var(--primary-100);
}

.form-hint {
  font-size: var(--font-size-xs);
  color: var(--neutral-500);
  margin-top: var(--space-1);
}

/* Additional form styles... */
```

### Cards

Cards are used for grouping related content:

```jsx
<div className="card">
  <div className="card-header">
    <h3 className="card-title">Card Title</h3>
    <button className="btn-icon" aria-label="More options">...</button>
  </div>
  <div className="card-body">
    <p>Card content goes here.</p>
  </div>
  <div className="card-footer">
    <button className="btn btn-secondary">Cancel</button>
    <button className="btn btn-primary">Submit</button>
  </div>
</div>
```

CSS implementation:

```css
.card {
  background-color: white;
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  overflow: hidden;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--space-4);
  border-bottom: 1px solid var(--neutral-200);
}

.card-title {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  margin: 0;
}

.card-body {
  padding: var(--space-4);
}

.card-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: var(--space-2);
  padding: var(--space-4);
  border-top: 1px solid var(--neutral-200);
}
```

### Tables

Tables for displaying tabular data:

```jsx
<table className="table">
  <thead>
    <tr>
      <th>Name</th>
      <th>Email</th>
      <th>Role</th>
      <th>Status</th>
      <th>Actions</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>John Doe</td>
      <td>john@example.com</td>
      <td>Admin</td>
      <td><span className="badge badge-success">Active</span></td>
      <td>
        <div className="action-buttons">
          <button className="btn-icon" aria-label="Edit">
            <EditIcon />
          </button>
          <button className="btn-icon" aria-label="Delete">
            <TrashIcon />
          </button>
        </div>
      </td>
    </tr>
    <!-- Additional rows... -->
  </tbody>
</table>
```

CSS implementation:

```css
.table {
  width: 100%;
  border-collapse: collapse;
}

.table th,
.table td {
  padding: var(--space-3) var(--space-4);
  text-align: left;
}

.table th {
  font-weight: var(--font-weight-semibold);
  color: var(--neutral-700);
  border-bottom: 2px solid var(--neutral-200);
}

.table td {
  border-bottom: 1px solid var(--neutral-200);
}

.table tr:hover {
  background-color: var(--neutral-50);
}

.action-buttons {
  display: flex;
  gap: var(--space-2);
}
```

## Layout Guidelines

### Grid System

The application uses a 12-column grid system for layouts:

```jsx
<div className="container">
  <div className="row">
    <div className="col-12 col-md-6 col-lg-4">
      {/* Content */}
    </div>
    <div className="col-12 col-md-6 col-lg-4">
      {/* Content */}
    </div>
    <div className="col-12 col-md-12 col-lg-4">
      {/* Content */}
    </div>
  </div>
</div>
```

CSS implementation:

```css
.container {
  width: 100%;
  padding-right: var(--space-4);
  padding-left: var(--space-4);
  margin-right: auto;
  margin-left: auto;
}

@media (min-width: 640px) {
  .container {
    max-width: 640px;
  }
}

@media (min-width: 768px) {
  .container {
    max-width: 768px;
  }
}

@media (min-width: 1024px) {
  .container {
    max-width: 1024px;
  }
}

@media (min-width: 1280px) {
  .container {
    max-width: 1280px;
  }
}

.row {
  display: flex;
  flex-wrap: wrap;
  margin-right: -var(--space-2);
  margin-left: -var(--space-2);
}

/* Column classes for different breakpoints... */
```

### Page Layout

Standard page layout structure:

```jsx
<div className="layout">
  <header className="header">
    {/* Navigation, logo, user profile */}
  </header>
  
  <div className="layout-content">
    <aside className="sidebar">
      {/* Sidebar navigation */}
    </aside>
    
    <main className="main-content">
      <div className="page-header">
        <h1 className="page-title">Page Title</h1>
        <div className="page-actions">
          {/* Page-level actions */}
        </div>
      </div>
      
      <div className="page-content">
        {/* Page content */}
      </div>
    </main>
  </div>
  
  <footer className="footer">
    {/* Footer content */}
  </footer>
</div>
```

## Accessibility Guidelines

### WCAG Compliance

All components should meet WCAG 2.1 AA standards:

1. **Perceivable**:
   - Provide text alternatives for non-text content
   - Provide captions and alternatives for multimedia
   - Create content that can be presented in different ways
   - Make it easy for users to see and hear content

2. **Operable**:
   - Make all functionality available from a keyboard
   - Give users enough time to read and use content
   - Do not use content that causes seizures or physical reactions
   - Help users navigate and find content

3. **Understandable**:
   - Make text readable and understandable
   - Make content appear and operate in predictable ways
   - Help users avoid and correct mistakes

4. **Robust**:
   - Maximize compatibility with current and future tools

### Focus Management

- Ensure logical tab order matches visual layout
- Provide visible focus indicators
- Trap focus in modals and dialogs
- Return focus appropriately after actions

### Aria Attributes

Use appropriate ARIA attributes to enhance accessibility:

```jsx
// Example of using ARIA with a simple dropdown
<div className="dropdown">
  <button 
    id="dropdownButton"
    aria-haspopup="true" 
    aria-expanded={isOpen} 
    aria-controls="dropdownMenu"
    onClick={toggleDropdown}
  >
    Options
  </button>
  
  <ul 
    id="dropdownMenu"
    role="menu" 
    aria-labelledby="dropdownButton"
    className={`dropdown-menu ${isOpen ? 'show' : ''}`}
  >
    <li role="menuitem">
      <button onClick={handleOption1}>Option 1</button>
    </li>
    <li role="menuitem">
      <button onClick={handleOption2}>Option 2</button>
    </li>
  </ul>
</div>
```

## Loading States & Empty States

### Loading States

```jsx
// Skeleton Loader for Cards
<div className="card card-skeleton">
  <div className="skeleton-header"></div>
  <div className="skeleton-body">
    <div className="skeleton-line"></div>
    <div className="skeleton-line"></div>
    <div className="skeleton-line skeleton-line-short"></div>
  </div>
</div>

// Loading Spinner
<div className="loading-spinner-container">
  <div className="loading-spinner" aria-label="Loading content"></div>
  <span className="loading-text">Loading...</span>
</div>
```

### Empty States

```jsx
<div className="empty-state">
  <div className="empty-state-icon">
    <DocumentIcon />
  </div>
  <h3 className="empty-state-title">No documents found</h3>
  <p className="empty-state-description">
    Create your first document to get started.
  </p>
  <button className="btn btn-primary">
    Create Document
  </button>
</div>
```

## Animation & Transitions

Use consistent animations and transitions throughout the application:

```css
:root {
  /* Transition Durations */
  --transition-fast: 100ms;
  --transition-normal: 200ms;
  --transition-slow: 300ms;
  
  /* Transition Timing Functions */
  --ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-in: cubic-bezier(0.4, 0, 1, 1);
  --ease-out: cubic-bezier(0, 0, 0.2, 1);
}

/* Standard transition for interactive elements */
.btn, .input, .link {
  transition: all var(--transition-normal) var(--ease-in-out);
}

/* Page transitions */
.page-enter {
  opacity: 0;
  transform: translateY(10px);
}

.page-enter-active {
  opacity: 1;
  transform: translateY(0);
  transition: opacity var(--transition-normal) var(--ease-out),
              transform var(--transition-normal) var(--ease-out);
}

.page-exit {
  opacity: 1;
  transform: translateY(0);
}

.page-exit-active {
  opacity: 0;
  transform: translateY(-10px);
  transition: opacity var(--transition-normal) var(--ease-in),
              transform var(--transition-normal) var(--ease-in);
}
```

## Responsive Design Guidelines

### Breakpoints

```css
:root {
  --breakpoint-sm: 640px;   /* Small devices (phones) */
  --breakpoint-md: 768px;   /* Medium devices (tablets) */
  --breakpoint-lg: 1024px;  /* Large devices (laptops) */
  --breakpoint-xl: 1280px;  /* Extra large devices (desktops) */
  --breakpoint-2xl: 1536px; /* Extra extra large devices (large desktops) */
}
```

### Media Queries

```css
/* Mobile-first approach */
.card {
  padding: var(--space-2);
}

@media (min-width: 640px) {
  .card {
    padding: var(--space-4);
  }
}

@media (min-width: 1024px) {
  .card {
    padding: var(--space-6);
  }
}
```

### Responsive Typography

```css
:root {
  --font-size-base: 16px;
}

@media (min-width: 640px) {
  :root {
    --font-size-base: 16px;
  }
}

@media (min-width: 1024px) {
  :root {
    --font-size-base: 18px;
  }
}

.title {
  font-size: calc(var(--font-size-base) * 1.5);
}

.subtitle {
  font-size: calc(var(--font-size-base) * 1.25);
}
```

## Icon System

The application uses a consistent set of SVG icons:

```jsx
const Icon = ({ name, size = 24, color = 'currentColor', ...props }) => {
  // Map of icon names to SVG paths
  const icons = {
    home: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6',
    user: 'M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z',
    // Other icons...
  };

  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke={color}
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      {...props}
    >
      <path d={icons[name]} />
    </svg>
  );
};
```

## Component Usage Examples

### Dashboard Layout Example

```jsx
<div className="layout">
  <header className="header">
    <div className="header-logo">
      <Logo />
      <span>Application Name</span>
    </div>
    <nav className="main-nav">
      {/* Navigation items */}
    </nav>
    <div className="header-actions">
      <NotificationsDropdown />
      <UserMenu />
    </div>
  </header>
  
  <div className="layout-content">
    <aside className="sidebar">
      <nav className="sidebar-nav">
        <NavItem icon="home" href="/dashboard" label="Dashboard" />
        <NavItem icon="users" href="/users" label="Users" />
        <NavItem icon="settings" href="/settings" label="Settings" />
        {/* Additional navigation items */}
      </nav>
    </aside>
    
    <main className="main-content">
      <div className="page-header">
        <h1 className="page-title">Dashboard</h1>
        <div className="page-actions">
          <button className="btn btn-primary">Create New</button>
        </div>
      </div>
      
      <div className="stats-grid">
        <StatCard title="Total Users" value="1,234" trend="+12%" />
        <StatCard title="Active Projects" value="42" trend="+5%" />
        <StatCard title="Completion Rate" value="85%" trend="+3%" />
        <StatCard title="Revenue" value="$12,345" trend="+8%" />
      </div>
      
      <div className="row">
        <div className="col-12 col-lg-8">
          <RecentActivityCard />
        </div>
        <div className="col-12 col-lg-4">
          <UpcomingEvents />
        </div>
      </div>
    </main>
  </div>
</div>
```

## Best Practices

1. **Mobile-First Development**: Design and develop for mobile devices first, then progressively enhance for larger screens.
2. **Performance**: Optimize images, minimize bundle size, and use lazy loading for off-screen content.
3. **Progressive Enhancement**: Ensure core functionality works without JavaScript, then enhance with JS features.
4. **Accessibility**: Design and develop with accessibility in mind from the start, not as an afterthought.
5. **Component Composition**: Build complex components by composing simpler ones.
6. **Design Tokens**: Use design tokens (CSS variables) for all design values to ensure consistency.
7. **Responsive Testing**: Test on various devices and screen sizes regularly during development.
8. **Documentation**: Document component APIs, variations, and usage examples.
9. **Usability Testing**: Conduct usability testing with real users to validate UX decisions.
10. **Cross-Browser Compatibility**: Ensure the application works on all supported browsers. 