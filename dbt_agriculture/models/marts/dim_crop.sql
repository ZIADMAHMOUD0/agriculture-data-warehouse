-- dim_crop.sql
-- Materialized as a TABLE in the [mart] schema

WITH staging AS (
    SELECT DISTINCT
        crop_type,
        harvest_season
    FROM {{ ref('stg_farm_yield') }}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY crop_type, harvest_season) AS crop_key,
    crop_type,
    harvest_season
FROM staging
