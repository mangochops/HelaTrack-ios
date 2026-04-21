-- 1. Drop the existing table to start fresh without the user_id requirement
DROP TABLE IF EXISTS businesses;

-- 2. Create the table for anonymous local development
CREATE TABLE businesses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_name TEXT NOT NULL,
  provider_type TEXT,
  identifier_hash TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Disable Row Level Security (RLS) for now
ALTER TABLE businesses DISABLE ROW LEVEL SECURITY;