WITH staging AS (
    SELECT DISTINCT irrigation_type FROM {{ ref('stg_farm_yield') }}
)
SELECT
    ROW_NUMBER() OVER (ORDER BY irrigation_type) AS irrigation_key,
    irrigation_type
FROM staging
