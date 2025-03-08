# Common Database Queries

This document contains frequently used SQL queries for the application. These queries can be used for reference when implementing backend functionality or troubleshooting database issues.

## User Management

### Get User with Profile
```sql
SELECT 
  u.id, 
  u.email, 
  u.created_at,
  p.username, 
  p.avatar_url, 
  p.bio, 
  p.website
FROM users u
LEFT JOIN profiles p ON u.id = p.id
WHERE u.id = 'user-uuid-here';
```

### Search Users by Username
```sql
SELECT 
  p.id, 
  p.username, 
  p.avatar_url
FROM profiles p
WHERE p.username ILIKE '%search-term%'
ORDER BY p.username
LIMIT 10;
```

## Product Management

### Get Products with Category and Seller
```sql
SELECT 
  p.id, 
  p.name, 
  p.description, 
  p.price, 
  p.stock,
  c.id AS category_id, 
  c.name AS category_name,
  u.id AS seller_id, 
  pr.username AS seller_username
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
LEFT JOIN users u ON p.user_id = u.id
LEFT JOIN profiles pr ON u.id = pr.id
ORDER BY p.created_at DESC
LIMIT 20 OFFSET 0;
```

### Get Product with Images
```sql
SELECT 
  p.id, 
  p.name, 
  p.description, 
  p.price, 
  p.stock,
  c.name AS category_name,
  json_agg(
    json_build_object(
      'id', pi.id,
      'url', pi.image_url,
      'is_primary', pi.is_primary
    )
  ) AS images
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
LEFT JOIN product_images pi ON p.id = pi.product_id
WHERE p.id = 'product-uuid-here'
GROUP BY p.id, c.name;
```

### Search Products
```sql
SELECT 
  p.id, 
  p.name, 
  p.description, 
  p.price,
  c.name AS category_name,
  (
    SELECT pi.image_url 
    FROM product_images pi 
    WHERE pi.product_id = p.id AND pi.is_primary = true 
    LIMIT 1
  ) AS primary_image
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
WHERE 
  p.name ILIKE '%search-term%' OR 
  p.description ILIKE '%search-term%'
ORDER BY p.created_at DESC
LIMIT 20 OFFSET 0;
```

### Get Products by Category
```sql
SELECT 
  p.id, 
  p.name, 
  p.description, 
  p.price,
  (
    SELECT pi.image_url 
    FROM product_images pi 
    WHERE pi.product_id = p.id AND pi.is_primary = true 
    LIMIT 1
  ) AS primary_image
FROM products p
WHERE p.category_id = 'category-uuid-here'
ORDER BY p.created_at DESC
LIMIT 20 OFFSET 0;
```

## Order Management

### Get User Orders with Items
```sql
SELECT 
  o.id, 
  o.status, 
  o.total_amount, 
  o.created_at,
  json_agg(
    json_build_object(
      'id', oi.id,
      'product_id', oi.product_id,
      'product_name', p.name,
      'quantity', oi.quantity,
      'unit_price', oi.unit_price
    )
  ) AS items
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id
WHERE o.user_id = 'user-uuid-here'
GROUP BY o.id
ORDER BY o.created_at DESC;
```

### Get Order Details
```sql
SELECT 
  o.id, 
  o.status, 
  o.total_amount, 
  o.shipping_address, 
  o.billing_address,
  o.created_at,
  u.email AS user_email,
  pr.username AS username,
  json_agg(
    json_build_object(
      'id', oi.id,
      'product_id', oi.product_id,
      'product_name', p.name,
      'quantity', oi.quantity,
      'unit_price', oi.unit_price,
      'subtotal', (oi.quantity * oi.unit_price)
    )
  ) AS items
FROM orders o
LEFT JOIN users u ON o.user_id = u.id
LEFT JOIN profiles pr ON u.id = pr.id
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id
WHERE o.id = 'order-uuid-here'
GROUP BY o.id, u.email, pr.username;
```

## Review Management

### Get Product Reviews with User Info
```sql
SELECT 
  r.id, 
  r.rating, 
  r.comment, 
  r.created_at,
  u.id AS user_id,
  p.username,
  p.avatar_url
FROM reviews r
LEFT JOIN users u ON r.user_id = u.id
LEFT JOIN profiles p ON u.id = p.id
WHERE r.product_id = 'product-uuid-here'
ORDER BY r.created_at DESC;
```

### Get Average Rating for Product
```sql
SELECT 
  AVG(r.rating) AS average_rating,
  COUNT(r.id) AS review_count
FROM reviews r
WHERE r.product_id = 'product-uuid-here';
```

## Dashboard and Analytics

### Get Sales by Category
```sql
SELECT 
  c.name AS category_name,
  COUNT(DISTINCT o.id) AS order_count,
  SUM(oi.quantity * oi.unit_price) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.id
JOIN categories c ON p.category_id = c.id
JOIN orders o ON oi.order_id = o.id
WHERE o.status = 'completed'
GROUP BY c.name
ORDER BY total_sales DESC;
```

### Get Monthly Sales
```sql
SELECT 
  DATE_TRUNC('month', o.created_at) AS month,
  COUNT(DISTINCT o.id) AS order_count,
  SUM(o.total_amount) AS total_sales
FROM orders o
WHERE o.status = 'completed'
GROUP BY DATE_TRUNC('month', o.created_at)
ORDER BY month DESC
LIMIT 12;
```

### Get Top Selling Products
```sql
SELECT 
  p.id,
  p.name,
  SUM(oi.quantity) AS units_sold,
  SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.id
JOIN orders o ON oi.order_id = o.id
WHERE o.status = 'completed'
GROUP BY p.id, p.name
ORDER BY units_sold DESC
LIMIT 10;
```

## Inventory Management

### Get Low Stock Products
```sql
SELECT 
  p.id, 
  p.name, 
  p.stock,
  c.name AS category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
WHERE p.stock < 10
ORDER BY p.stock ASC;
```

### Update Product Stock
```sql
UPDATE products
SET stock = stock - (
  SELECT SUM(oi.quantity)
  FROM order_items oi
  WHERE oi.product_id = products.id
  AND oi.order_id = 'order-uuid-here'
)
WHERE id IN (
  SELECT oi.product_id
  FROM order_items oi
  WHERE oi.order_id = 'order-uuid-here'
);
```

## User Activity

### Get Recent User Activity
```sql
SELECT 
  'order' AS activity_type,
  o.id AS reference_id,
  o.created_at AS activity_date,
  'Placed an order' AS description
FROM orders o
WHERE o.user_id = 'user-uuid-here'

UNION ALL

SELECT 
  'review' AS activity_type,
  r.id AS reference_id,
  r.created_at AS activity_date,
  'Wrote a review' AS description
FROM reviews r
WHERE r.user_id = 'user-uuid-here'

UNION ALL

SELECT 
  'product' AS activity_type,
  p.id AS reference_id,
  p.created_at AS activity_date,
  'Listed a product' AS description
FROM products p
WHERE p.user_id = 'user-uuid-here'

ORDER BY activity_date DESC
LIMIT 20;
```

## Performance Optimization

### Create Materialized View for Product Search
```sql
CREATE MATERIALIZED VIEW product_search AS
SELECT 
  p.id, 
  p.name, 
  p.description, 
  p.price,
  c.name AS category_name,
  u.id AS seller_id,
  pr.username AS seller_name,
  (
    SELECT pi.image_url 
    FROM product_images pi 
    WHERE pi.product_id = p.id AND pi.is_primary = true 
    LIMIT 1
  ) AS primary_image,
  setweight(to_tsvector('english', p.name), 'A') ||
  setweight(to_tsvector('english', COALESCE(p.description, '')), 'B') ||
  setweight(to_tsvector('english', c.name), 'C') AS search_vector
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
LEFT JOIN users u ON p.user_id = u.id
LEFT JOIN profiles pr ON u.id = pr.id;

CREATE INDEX idx_product_search ON product_search USING GIN(search_vector);

-- Refresh the materialized view
REFRESH MATERIALIZED VIEW product_search;

-- Search using the materialized view
SELECT 
  id, 
  name, 
  price, 
  primary_image
FROM product_search
WHERE search_vector @@ plainto_tsquery('english', 'search term here')
ORDER BY ts_rank(search_vector, plainto_tsquery('english', 'search term here')) DESC
LIMIT 20;
```
