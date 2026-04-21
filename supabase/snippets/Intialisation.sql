-- 1. Create the businesses table
CREATE TABLE IF NOT EXISTS businesses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  business_name TEXT NOT NULL,
  provider_type TEXT CHECK (provider_type IN ('M-PESA', 'Bank', 'Other')),
  paybill_number TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable Row Level Security (RLS)
ALTER TABLE businesses ENABLE ROW LEVEL SECURITY;

-- 3. Create Policy: Users can only see their own business data
CREATE POLICY "Users can view their own businesses" 
ON businesses FOR SELECT 
USING (auth.uid() = user_id);

-- 4. Create Policy: Users can only insert their own business data
CREATE POLICY "Users can insert their own businesses" 
ON businesses FOR INSERT 
WITH CHECK (auth.uid() = user_id);