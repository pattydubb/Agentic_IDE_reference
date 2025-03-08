# Workflow Instructions

This document provides step-by-step guides for common multi-part tasks in the Agentic IDE.

## Database Schema Update Workflow

This workflow describes how to update the database schema, generate migrations, and update corresponding code.

### Step 1: Update Database Schema Definition

1. Open the database schema file:
   ```
   open_file("Database/Database.md")
   ```

2. Add or modify the table definition:
   ```sql
   CREATE TABLE new_table (
     id SERIAL PRIMARY KEY,
     name VARCHAR(100) NOT NULL,
     description TEXT,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   ```

3. Update relationship documentation:
   ```
   open_file("Database/DBcontext.md")
   ```
   Add information about the new table and its relationships.

### Step 2: Create Database Migration

1. Create a new migration file:
   ```
   create_file("Database/Migrations/YYYYMMDD_add_new_table.sql", "-- Migration to add new_table\n\n-- Up\nCREATE TABLE new_table (...);\n\n-- Down\nDROP TABLE IF EXISTS new_table;")
   ```

2. Document the migration in the schema history:
   ```
   update_file("Database/Database.md", "/* Migration History\n...\nYYYYMMDD - Added new_table\n*/", "append")
   ```

### Step 3: Update Backend Models

1. Create a model for the new table:
   ```
   create_file("Backend/Models/NewTableModel.md", "# New Table Model\n\n## Schema Definition\n\n```javascript\nconst newTableSchema = new Schema({\n  name: { type: String, required: true },\n  description: String,\n  createdAt: { type: Date, default: Date.now }\n});\n```")
   ```

2. Create or update controllers for the new resource:
   ```
   create_file("Backend/Controllers/NewTableController.md", "# New Table Controller\n\n## Endpoints\n\n- GET /api/new-table\n- POST /api/new-table\n- GET /api/new-table/:id\n- PUT /api/new-table/:id\n- DELETE /api/new-table/:id")
   ```

### Step 4: Update API Endpoints Documentation

1. Update the API endpoints documentation:
   ```
   open_file("Backend/Endpoints.md")
   ```
   Add the new endpoints for the new table.

### Step 5: Run Migrations

1. Connect to the database and run the migration:
   ```
   run_command("cd Database && migrate up")
   ```

2. Verify migration success:
   ```
   db_query("SELECT * FROM new_table LIMIT 0")
   ```

### Step 6: Update Frontend Components (if necessary)

1. Create or update components to interact with the new resource.
2. Update state management to include the new resource.

## Feature Implementation Workflow

This workflow describes how to implement a new feature across the stack.

### Step 1: Define Requirements

1. Document the feature requirements:
   ```
   create_file("Workflows/FeatureName.md", "# Feature Name\n\n## Requirements\n\n- Requirement 1\n- Requirement 2\n\n## Acceptance Criteria\n\n- Criteria 1\n- Criteria 2")
   ```

### Step 2: Design Backend Changes

1. Create or update API endpoints:
   ```
   open_file("Backend/Endpoints.md")
   ```
   Add necessary endpoints for the feature.

2. Implement controllers and services:
   ```
   create_file("Backend/Controllers/FeatureController.md", "# Feature Controller\n\n...")
   ```

### Step 3: Implement Frontend Changes

1. Create UI components:
   ```
   create_file("Frontend/Components/FeatureComponent.md", "# Feature Component\n\n...")
   ```

2. Update state management:
   ```
   open_file("Frontend/StateManagement.md")
   ```
   Add state management for the new feature.

3. Add routing if needed:
   ```
   open_file("Frontend/Routes&Navigation.md")
   ```
   Add new routes for the feature.

### Step 4: Implement Tests

1. Create backend tests.
2. Create frontend tests.

### Step 5: Document the Feature

1. Update documentation:
   ```
   update_file("README.md", "## Features\n\n- Existing Features\n- New Feature Name", "replace")
   ```

## Authentication Implementation Workflow

This workflow describes how to implement authentication in the application.

### Step 1: Set Up Authentication Service

1. Configure authentication provider:
   ```
   open_file("Services/Authentication.md")
   ```
   Update configuration settings.

2. Implement authentication endpoints:
   ```
   open_file("Backend/Endpoints.md")
   ```
   Add authentication endpoints (register, login, refresh, etc.).

### Step 2: Implement Backend Authentication

1. Create authentication middleware:
   ```
   create_file("Backend/Middleware/Auth.md", "# Authentication Middleware\n\n...")
   ```

2. Apply middleware to protected routes:
   ```
   open_file("Backend/Endpoints.md")
   ```
   Update endpoints to indicate authentication requirements.

### Step 3: Implement Frontend Authentication

1. Create authentication service:
   ```
   create_file("Frontend/Services/AuthService.md", "# Authentication Service\n\n...")
   ```

2. Implement login/register components:
   ```
   create_file("Frontend/Components/Auth/LoginForm.md", "# Login Form Component\n\n...")
   create_file("Frontend/Components/Auth/RegisterForm.md", "# Register Form Component\n\n...")
   ```

3. Add authentication state management:
   ```
   open_file("Frontend/StateManagement.md")
   ```
   Add authentication state management.

4. Implement protected routes:
   ```
   open_file("Frontend/Routes&Navigation.md")
   ```
   Update routing to include route protection.

### Step 4: Test Authentication Flow

1. Test registration flow.
2. Test login flow.
3. Test token refresh.
4. Test access to protected resources.
5. Test logout.

## Deployment Workflow

This workflow describes how to prepare and deploy the application.

### Step 1: Prepare for Deployment

1. Update environment configuration:
   ```
   create_file(".env.production", "NODE_ENV=production\nAPI_URL=https://api.example.com\n...")
   ```

2. Build the application:
   ```
   run_command("npm run build")
   ```

### Step 2: Run Pre-Deployment Checks

1. Run tests:
   ```
   run_command("npm test")
   ```

2. Check for security vulnerabilities:
   ```
   run_command("npm audit")
   ```

3. Run linting:
   ```
   run_command("npm run lint")
   ```

### Step 3: Deploy Backend

1. Set up database in production:
   ```
   run_command("NODE_ENV=production npm run migrate")
   ```

2. Deploy backend code:
   ```
   run_command("deploy-backend")
   ```

### Step 4: Deploy Frontend

1. Deploy frontend assets:
   ```
   run_command("deploy-frontend")
   ```

### Step 5: Verify Deployment

1. Run smoke tests against production environment.
2. Monitor for any issues.

## API Integration Workflow

This workflow describes how to integrate with a third-party API.

### Step 1: Set Up API Integration

1. Configure API credentials:
   ```
   create_file("Services/ExternalAPI.md", "# External API Integration\n\n...")
   ```

2. Implement API client:
   ```
   create_file("Backend/Services/ExternalAPIClient.md", "# External API Client\n\n...")
   ```

### Step 2: Create API Endpoints

1. Implement proxy endpoints:
   ```
   open_file("Backend/Endpoints.md")
   ```
   Add endpoints that interact with the external API.

2. Implement controllers:
   ```
   create_file("Backend/Controllers/ExternalAPIController.md", "# External API Controller\n\n...")
   ```

### Step 3: Implement Frontend Integration

1. Create services to interact with the API:
   ```
   create_file("Frontend/Services/ExternalAPIService.md", "# External API Service\n\n...")
   ```

2. Implement UI components:
   ```
   create_file("Frontend/Components/ExternalAPIComponents.md", "# External API Components\n\n...")
   ```

### Step 4: Test Integration

1. Test API connectivity.
2. Test data transformation.
3. Test error handling.
4. Test rate limiting and quota management.

## Best Practices for Workflows

When following these workflows, keep these best practices in mind:

1. **Incremental Development**:
   - Work in small, manageable chunks
   - Commit frequently
   - Test each step before proceeding

2. **Documentation**:
   - Document changes as you go
   - Update relevant documentation
   - Add comments for complex logic

3. **Error Handling**:
   - Implement robust error handling at each step
   - Add appropriate logging
   - Plan for failure scenarios

4. **Testing**:
   - Write tests for each component
   - Test integrations thoroughly
   - Include edge cases in tests

5. **Security**:
   - Validate all inputs
   - Use proper authentication and authorization
   - Follow security best practices 