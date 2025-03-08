# Database Context

This document provides a comprehensive overview of the database structure, relationships, data models, and data flows. It serves as a guide for understanding how the database is organized and how different entities relate to each other.

## Database Overview

The database is built on Supabase (PostgreSQL) and follows a relational model. It is designed to support an e-commerce application with users, products, orders, and reviews. The database uses UUID as primary keys for all tables to ensure uniqueness across the system.

## Entity Relationships

### Core Entities

1. **Users**
   - Central entity representing application users
   - One-to-one relationship with Profiles
   - One-to-many relationship with Products (as sellers)
   - One-to-many relationship with Orders (as buyers)
   - One-to-many relationship with Reviews (as reviewers)

2. **Products**
   - Represents items for sale in the system
   - Many-to-one relationship with Categories
   - Many-to-one relationship with Users (sellers)
   - One-to-many relationship with Product Images
   - One-to-many relationship with Order Items
   - One-to-many relationship with Reviews

3. **Orders**
   - Represents purchases made by users
   - Many-to-one relationship with Users (buyers)
   - One-to-many relationship with Order Items

4. **Categories**
   - Organizes products into logical groups
   - One-to-many relationship with Products

### Supporting Entities

1. **Profiles**
   - Extends User information
   - One-to-one relationship with Users

2. **Product Images**
   - Stores images associated with products
   - Many-to-one relationship with Products

3. **Order Items**
   - Junction table linking Orders and Products
   - Many-to-one relationship with Orders
   - Many-to-one relationship with Products

4. **Reviews**
   - Stores user reviews for products
   - Many-to-one relationship with Users
   - Many-to-one relationship with Products

## Entity-Relationship Diagram (ERD)

```
Users 1──1 Profiles
  │
  │
  ├──n Products n──1 Categories
  │     │
  │     │
  │     1
  │     │
  │     n
  │  Product Images
  │
  │
  ├──n Orders
  │     │
  │     │
  │     1
  │     │
  │     n
  │  Order Items n──1 Products
  │
  │
  └──n Reviews n──1 Products
```

## Data Flow

### User Registration and Profile Creation
1. User registers with email and password
2. Users table record is created
3. Profiles table record is automatically created with the same ID

### Product Listing
1. User (seller) creates a product
2. Product is associated with a category
3. User uploads images for the product
4. Product becomes available for purchase

### Order Processing
1. User (buyer) creates an order
2. Order items are created, linking products to the order
3. Payment is processed (via payment intent)
4. Order status is updated
5. Product stock is reduced

### Review System
1. User purchases a product
2. After receiving the product, user can leave a review
3. Review is associated with both the user and the product

## Row Level Security (RLS)

The database implements Row Level Security to ensure data privacy and security:

- Users can only view and modify their own data
- Profiles are viewable by everyone but can only be modified by the owner
- Categories are viewable by everyone but can only be modified by admins
- Products are viewable by everyone but can only be modified by the seller
- Orders and order items are only viewable and modifiable by the associated buyer
- Reviews are viewable by everyone but can only be modified by the reviewer

## Data Validation and Constraints

- Email addresses must be unique
- Usernames must be unique
- Product prices must be positive
- Order quantities must be positive
- Review ratings must be between 1 and 5
- A user can only review a product once

## Timestamps and Auditing

All tables include:
- `created_at` - Automatically set when a record is created
- `updated_at` - Automatically updated when a record is modified

This provides a basic audit trail for all data changes.

## Indexing Strategy

Indexes are created on:
- Foreign keys to improve join performance
- Frequently queried fields to improve search performance

## Database Triggers

Triggers are used to:
- Automatically update the `updated_at` timestamp when records are modified
- Ensure data consistency across related tables
