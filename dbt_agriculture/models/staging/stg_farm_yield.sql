-- stg_farm_yield.sql
-- Materialized as a VIEW in the [stg] schema

WITH source AS (
    SELECT * FROM {{ source('raw', 'farm_yield') }}
),

renamed AS (
    SELECT
        CAST(Farm_ID AS INT)                     AS farm_id,
        UPPER(TRIM(Crop_Type))                   AS crop_type,
        UPPER(TRIM(Region))                      AS region_name,
        UPPER(TRIM(Soil_Type))                   AS soil_type,
        UPPER(TRIM(Irrigation_Type))             AS irrigation_type,
        CAST(Fertilizer_Used AS DECIMAL(10,2))   AS fertilizer_used_kg,
        CAST(Pesticide_Used AS DECIMAL(10,2))    AS pesticide_used_kg,
        CAST(Water_Usage AS DECIMAL(10,2))       AS water_usage_m3,
        CAST(Rainfall AS DECIMAL(10,2))          AS rainfall_mm,
        CAST(Temperature AS DECIMAL(5,2))        AS temperature_c,
        UPPER(TRIM(Harvest_Season))              AS harvest_season,
        CAST(Yield AS DECIMAL(10,2))             AS yield_tons,
        _loaded_at                               AS raw_loaded_at
    FROM source
    WHERE Farm_ID IS NOT NULL
)

SELECT * FROM renamed
