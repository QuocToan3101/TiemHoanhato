-- Migration: Rename ghn_fee column to ghtk_fee in delivery_history
-- This migration updates the database to use GHTK exclusively

-- Step 1: Add the new ghtk_fee column if it doesn't exist
ALTER TABLE delivery_history 
ADD COLUMN IF NOT EXISTS ghtk_fee_temp DECIMAL(10,2) NULL AFTER fee;

-- Step 2: Copy data from old column to new column (if old column exists)
-- This uses a stored procedure approach to handle if ghn_fee exists
SET @old_column_exists := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'delivery_history' AND COLUMN_NAME = 'ghn_fee' AND TABLE_SCHEMA = DATABASE());

-- If old column exists, copy its data
SET @sql = IF(@old_column_exists > 0, 
    'UPDATE delivery_history SET ghtk_fee_temp = ghn_fee WHERE ghn_fee IS NOT NULL', 
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Step 3: Drop the old ghn_fee column if it exists
SET @sql = IF(@old_column_exists > 0, 
    'ALTER TABLE delivery_history DROP COLUMN ghn_fee', 
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Step 4: Rename the temp column to ghtk_fee
ALTER TABLE delivery_history 
CHANGE COLUMN ghtk_fee_temp ghtk_fee DECIMAL(10,2) NULL;

-- Verify the migration
SELECT 'Migration completed successfully. Column renamed to ghtk_fee.' as status;
