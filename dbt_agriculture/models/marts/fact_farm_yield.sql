-- fact_farm_yield.sql
-- Materialized as a TABLE in the [mart] schema

WITH stg AS (
    SELECT * FROM {{ ref('stg_farm_yield') }}
),

dim_farm AS (
    SELECT * FROM {{ ref('dim_farm') }}
),

dim_crop AS (
    SELECT * FROM {{ ref('dim_crop') }}
),

dim_region AS (
    SELECT * FROM {{ ref('dim_region') }}
),

dim_soil AS (
    SELECT * FROM {{ ref('dim_soil') }}
),

dim_irrigation AS (
    SELECT * FROM {{ ref('dim_irrigation') }}
),

final AS (
    SELECT
        f.farm_key,
        c.crop_key,
        r.region_key,
        s.soil_key,
        i.irrigation_key,
        stg.fertilizer_used_kg,
        stg.pesticide_used_kg,
        stg.water_usage_m3,
        stg.rainfall_mm,
        stg.temperature_c,
        stg.yield_tons
    FROM stg
    JOIN dim_farm f ON stg.farm_id = f.farm_id
    JOIN dim_crop c ON stg.crop_type = c.crop_type AND stg.harvest_season = c.harvest_season
    JOIN dim_region r ON stg.region_name = r.region_name
    JOIN dim_soil s ON stg.soil_type = s.soil_type
    JOIN dim_irrigation i ON stg.irrigation_type = i.irrigation_type
)

SELECT * FROM final
