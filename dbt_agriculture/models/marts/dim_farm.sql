WITH staging AS (
    SELECT DISTINCT farm_id FROM {{ ref('stg_farm_yield') }}
)
SELECT
    ROW_NUMBER() OVER (ORDER BY farm_id) AS farm_key,
    farm_id
FROM staging
