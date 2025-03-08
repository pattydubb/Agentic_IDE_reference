-- Migration: 20250310_add_subscription_tables
-- Description: Adding subscription functionality to the application

-- Up Migration (Apply Changes)
-- =================================

-- Create subscription_plans table
CREATE TABLE subscription_plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  description TEXT NULL,
  price_monthly DECIMAL(10, 2) NOT NULL,
  price_annually DECIMAL(10, 2) NOT NULL,
  features JSONB NOT NULL DEFAULT '{}',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  trial_days INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create subscriptions table
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  plan_id UUID NOT NULL REFERENCES subscription_plans(id),
  status VARCHAR(50) NOT NULL DEFAULT 'active', -- active, canceled, expired, past_due
  current_period_start TIMESTAMP NOT NULL,
  current_period_end TIMESTAMP NOT NULL,
  cancel_at_period_end BOOLEAN NOT NULL DEFAULT FALSE,
  canceled_at TIMESTAMP NULL,
  trial_start TIMESTAMP NULL,
  trial_end TIMESTAMP NULL,
  payment_method_id VARCHAR(100) NULL,
  external_subscription_id VARCHAR(100) NULL, -- ID from external payment processor
  metadata JSONB NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create subscription_invoices table
CREATE TABLE subscription_invoices (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  subscription_id UUID NOT NULL REFERENCES subscriptions(id) ON DELETE CASCADE,
  amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) NOT NULL, -- paid, unpaid, void, draft
  due_date TIMESTAMP NOT NULL,
  paid_at TIMESTAMP NULL,
  external_invoice_id VARCHAR(100) NULL, -- ID from external payment processor
  invoice_pdf_url VARCHAR(255) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create subscription_features table for tracking feature access
CREATE TABLE subscription_features (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create subscription_plan_features join table
CREATE TABLE subscription_plan_features (
  plan_id UUID NOT NULL REFERENCES subscription_plans(id) ON DELETE CASCADE,
  feature_id UUID NOT NULL REFERENCES subscription_features(id) ON DELETE CASCADE,
  limits JSONB NULL, -- Optional limits specific to this plan-feature combo
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (plan_id, feature_id)
);

-- Add subscription related fields to users table
ALTER TABLE users 
ADD COLUMN subscription_id UUID NULL REFERENCES subscriptions(id),
ADD COLUMN subscription_status VARCHAR(50) NULL;

-- Create indexes
CREATE INDEX idx_subscription_plans_active ON subscription_plans(is_active);
CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_plan_id ON subscriptions(plan_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscription_invoices_subscription_id ON subscription_invoices(subscription_id);
CREATE INDEX idx_subscription_invoices_status ON subscription_invoices(status);
CREATE INDEX idx_subscription_features_active ON subscription_features(is_active);
CREATE INDEX idx_users_subscription_id ON users(subscription_id);
CREATE INDEX idx_users_subscription_status ON users(subscription_status);

-- Down Migration (Rollback Changes)
-- =================================

-- Drop indexes
DROP INDEX IF EXISTS idx_users_subscription_status;
DROP INDEX IF EXISTS idx_users_subscription_id;
DROP INDEX IF EXISTS idx_subscription_features_active;
DROP INDEX IF EXISTS idx_subscription_invoices_status;
DROP INDEX IF EXISTS idx_subscription_invoices_subscription_id;
DROP INDEX IF EXISTS idx_subscriptions_status;
DROP INDEX IF EXISTS idx_subscriptions_plan_id;
DROP INDEX IF EXISTS idx_subscriptions_user_id;
DROP INDEX IF EXISTS idx_subscription_plans_active;

-- Remove subscription columns from users table
ALTER TABLE users 
DROP COLUMN IF EXISTS subscription_status,
DROP COLUMN IF EXISTS subscription_id;

-- Drop tables
DROP TABLE IF EXISTS subscription_plan_features;
DROP TABLE IF EXISTS subscription_features;
DROP TABLE IF EXISTS subscription_invoices;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS subscription_plans; 