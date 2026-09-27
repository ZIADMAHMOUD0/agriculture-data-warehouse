-- ==========================================================
-- Create dwh_admin Login and User for AgricultureDWH
-- ==========================================================

USE master;
GO

-- Create Login if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'dwh_admin')
BEGIN
    -- Replace <CHANGE_ME> with a strong password and use the same value for DBT_PASSWORD
    CREATE LOGIN dwh_admin WITH PASSWORD = '<CHANGE_ME>';
    PRINT 'Login [dwh_admin] created successfully.';
END
ELSE
BEGIN
    PRINT 'Login [dwh_admin] already exists.';
END
GO

-- Connect to the Target Database
USE AgricultureDWH;
GO

-- Create User in the Database
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'dwh_admin')
BEGIN
    CREATE USER dwh_admin FOR LOGIN dwh_admin;
    PRINT 'User [dwh_admin] created in AgricultureDWH database.';
END
ELSE
BEGIN
    PRINT 'User [dwh_admin] already exists in AgricultureDWH database.';
END
GO

-- Grant Permissions
ALTER ROLE db_owner ADD MEMBER dwh_admin;
PRINT 'Granted db_owner role to [dwh_admin].';
GO
