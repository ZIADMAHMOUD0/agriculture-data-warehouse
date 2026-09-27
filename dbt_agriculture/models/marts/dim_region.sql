WITH staging AS (
    SELECT DISTINCT region_name FROM {{ ref('stg_farm_yield') }}
)
SELECT
    ROW_NUMBER() OVER (ORDER BY region_name) AS region_key,
    region_name
FROM staging
