-- ==========================================================
-- Initialize Schemas and Raw Tables for AgricultureDWH
-- ==========================================================

USE AgricultureDWH;
GO

-- 1. Create Schemas if they don't exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'raw')
    EXEC('CREATE SCHEMA raw');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'stg')
    EXEC('CREATE SCHEMA stg');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'mart')
    EXEC('CREATE SCHEMA mart');
GO

-- 2. Create Raw Table for Farm Yield (CSV source)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'farm_yield' AND schema_id = SCHEMA_ID('raw'))
BEGIN
    CREATE TABLE raw.farm_yield (
        Farm_ID             INT,
        Crop_Type           NVARCHAR(100),
        Region              NVARCHAR(100),
        Soil_Type           NVARCHAR(100),
        Irrigation_Type     NVARCHAR(100),
        Fertilizer_Used     FLOAT,
        Pesticide_Used      FLOAT,
        Water_Usage         FLOAT,
        Rainfall            FLOAT,
        Temperature         FLOAT,
        Harvest_Season      NVARCHAR(50),
        Yield               FLOAT,
        _loaded_at          DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Table [raw.farm_yield] created.';
END
ELSE
BEGIN
    PRINT 'Table [raw.farm_yield] already exists.';
END
GO

-- 3. Create Raw Table for Sensor Readings (IoT source)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'sensor_readings' AND schema_id = SCHEMA_ID('raw'))
BEGIN
    CREATE TABLE raw.sensor_readings (
        Farm_ID             INT,
        Sensor_Time         DATETIME2,
        Moisture_Level      FLOAT,
        Ambient_Temp        FLOAT,
        _loaded_at          DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Table [raw.sensor_readings] created.';
END
ELSE
BEGIN
    PRINT 'Table [raw.sensor_readings] already exists.';
END
GO
