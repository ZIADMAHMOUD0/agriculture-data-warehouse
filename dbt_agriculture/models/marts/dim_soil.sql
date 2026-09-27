WITH staging AS (
    SELECT DISTINCT soil_type FROM {{ ref('stg_farm_yield') }}
)
SELECT
    ROW_NUMBER() OVER (ORDER BY soil_type) AS soil_key,
    soil_type
FROM staging
