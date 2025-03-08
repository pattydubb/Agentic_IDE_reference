# Glossary

This document provides definitions for key terms, acronyms, and domain-specific jargon used in the project.

## A

### API (Application Programming Interface)
A set of rules and protocols that allows different software applications to communicate with each other. In this project, APIs typically refer to endpoints that the frontend uses to request data from the backend.

### Authentication
The process of verifying the identity of a user, system, or entity. This project uses JWT-based authentication for user login and API access.

### Authorization
The process of determining what permissions an authenticated user has. In this project, role-based authorization controls access to protected resources.

## B

### Backend
The server-side of the application that handles business logic, database operations, and API requests. In this project, the backend is built with [backend framework/language].

### Build
The process of converting source code into executable software. The build process in this project includes transpilation, bundling, minification, and other optimizations.

## C

### CRUD (Create, Read, Update, Delete)
The four basic operations of persistent storage. Most resources in this application follow CRUD patterns for data management.

### Component
A reusable, self-contained piece of UI that can be composed with other components to build complex interfaces. In this project, components are organized in a hierarchical structure.

### Continuous Integration/Continuous Deployment (CI/CD)
Practices that involve automatically testing and deploying code changes. This project uses [CI/CD tool] for automated testing and deployment.

## D

### Database
A structured collection of data. This project uses Supabase, a Postgres-based database service, for data storage.

### Dependency
A software library or package that the project relies on. Dependencies are managed using [package manager].

### DTO (Data Transfer Object)
An object that carries data between processes. In this project, DTOs define the structure of data sent between frontend and backend.

## E

### Environment Variable
A variable whose value is set outside the program, typically through the operating system or container. This project uses environment variables for configuration.

### Endpoint
A specific URL where an API can be accessed. This project's API endpoints are documented in `Backend/Endpoints.md`.

## F

### Frontend
The client-side of the application that users interact with. In this project, the frontend is built with [frontend framework/library].

## I

### IDE (Integrated Development Environment)
A software application that provides comprehensive facilities for software development. This project uses the Agentic IDE for development.

### Immutable
Something that cannot be changed after creation. In this project, immutable data patterns are used in state management.

## J

### JWT (JSON Web Token)
A compact, URL-safe means of representing claims between two parties. This project uses JWTs for authentication and session management.

## M

### Middleware
Software that acts as a bridge between different application components or services. In this project, middleware is used for request processing in the backend.

### Migration
A way to update database schema from one version to another. This project uses migrations to track and apply database changes.

### Model
A representation of data structure. In this project, models define the structure of database entities.

## O

### ORM (Object-Relational Mapping)
A technique for converting data between incompatible type systems in object-oriented programming languages. This project uses [ORM tool] for database interactions.

## P

### Payload
The data portion of a message or request. In this project, API payloads are typically JSON-formatted data.

### Prop (Property)
Data passed from a parent component to a child component. In this project's frontend, props are used for component communication.

## R

### REST (Representational State Transfer)
An architectural style for designing networked applications. This project follows RESTful patterns for API design.

### Repository
A design pattern that mediates between the domain and data mapping layers. In this project, repositories handle data access operations.

### Route
A path or URL pattern that the application responds to. This project's routing structure is documented in `Frontend/Routes&Navigation.md`.

## S

### Schema
A blueprint for how data should be structured. In this project, database schemas are defined in `Database/Database.md`.

### Service
A class or function that encapsulates business logic or external API interactions. In this project, services handle complex operations and third-party integrations.

### State Management
The handling of an application's data state and UI state. This project uses [state management library/approach] as documented in `Frontend/StateManagement.md`.

### Supabase
An open-source Firebase alternative that provides a Postgres database, authentication, instant APIs, and real-time subscriptions. This project uses Supabase as its database provider.

## T

### Token
A piece of data that represents authentication credentials. This project uses JWT tokens for authentication.

### Transaction
A sequence of operations performed as a single logical unit of work. In this project, database transactions ensure data integrity.

## U

### UI (User Interface)
The visual elements that users interact with. This project's UI components are documented in `Frontend/Components/`.

### UUID (Universally Unique Identifier)
A 128-bit label used for information in computer systems. This project uses UUIDs for certain resource identifiers.

## V

### Validation
The process of checking if data meets certain criteria. This project implements validation on both frontend and backend.

## W

### Webhook
An HTTP callback that occurs when something happens. This project uses webhooks for integrating with third-party services.

### Workflow
A sequence of steps to accomplish a specific task. This project's workflows are documented in `AgentCommands/WorkflowInstructions.md` and the `Workflows/` directory. 