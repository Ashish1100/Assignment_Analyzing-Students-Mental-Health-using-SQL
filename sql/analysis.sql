-- Student Mental Health Analysis
-- International Students Mental Health Diagnostic Scores by Length of Stay
-- SQL Query for PostgreSQL-compatible Databases

-- OVERVIEW
-- This query analyzes three mental health diagnostic scores (depression, social connectedness, 
-- acculturative stress) for international students grouped by their length of stay at the institution.
-- It filters for international students only, aggregates mental health metrics by tenure duration,
-- and returns results ordered by stay duration.

-- QUERY START
SELECT 
    stay AS stay,
    COUNT(*) AS count_int,
    ROUND(AVG(todep), 2) AS average_phq,
    ROUND(AVG(tosc), 2) AS average_scs,
    ROUND(AVG(toas), 2) AS average_as
FROM students
WHERE inter_dom = 'Inter'
GROUP BY stay
ORDER BY stay DESC
LIMIT 9;
-- QUERY END

-- COLUMN DEFINITIONS
-- stay:           Length of stay in years (1-10)
-- count_int:      Number of international students in each stay group
-- average_phq:    Average PHQ-9 depression score (0-27 scale; higher = more severe)
-- average_scs:    Average Social Connectedness Scale score (20-80 scale; higher = more connected)
-- average_as:     Average Acculturative Stress score (24-120 scale; higher = more stressed)

-- EXECUTION ORDER (Important for query logic understanding)
-- 1. FROM students       - Load all student records
-- 2. WHERE inter_dom='Inter'  - Filter to international students only
-- 3. GROUP BY stay      - Partition data into 9 groups by tenure duration
-- 4. SELECT             - Compute aggregations (COUNT, AVG) within each group
-- 5. ORDER BY stay DESC - Sort results by longest stay first
-- 6. LIMIT 9           - Return maximum 9 rows

-- ALTERNATIVE: Using CTE for clarity (Common Table Expression)
-- WITH international_students AS (
--     SELECT *
--     FROM students
--     WHERE inter_dom = 'Inter'
-- )
-- SELECT 
--     stay,
--     COUNT(*) AS count_int,
--     ROUND(AVG(todep), 2) AS average_phq,
--     ROUND(AVG(tosc), 2) AS average_scs,
--     ROUND(AVG(toas), 2) AS average_as
-- FROM international_students
-- GROUP BY stay
-- ORDER BY stay DESC
-- LIMIT 9;

-- EXTENSIONS FOR FURTHER ANALYSIS

-- Extension 1: Include sample size and statistical measures
-- SELECT 
--     stay,
--     COUNT(*) AS count_int,
--     ROUND(AVG(todep), 2) AS avg_phq,
--     ROUND(STDDEV(todep), 2) AS stddev_phq,
--     MIN(todep) AS min_phq,
--     MAX(todep) AS max_phq,
--     ROUND(AVG(tosc), 2) AS avg_scs,
--     ROUND(AVG(toas), 2) AS avg_as
-- FROM students
-- WHERE inter_dom = 'Inter'
-- GROUP BY stay
-- ORDER BY stay DESC;

-- Extension 2: Compare international vs. domestic students
-- SELECT 
--     inter_dom,
--     stay,
--     COUNT(*) AS student_count,
--     ROUND(AVG(todep), 2) AS average_phq,
--     ROUND(AVG(tosc), 2) AS average_scs,
--     ROUND(AVG(toas), 2) AS average_as
-- FROM students
-- WHERE stay IS NOT NULL
-- GROUP BY inter_dom, stay
-- ORDER BY inter_dom, stay DESC;

-- Extension 3: Analyze by academic level within international students
-- SELECT 
--     stay,
--     academic,
--     COUNT(*) AS count_students,
--     ROUND(AVG(todep), 2) AS average_phq,
--     ROUND(AVG(tosc), 2) AS average_scs,
--     ROUND(AVG(toas), 2) AS average_as
-- FROM students
-- WHERE inter_dom = 'Inter'
-- GROUP BY stay, academic
-- ORDER BY stay DESC, academic;

-- Extension 4: Identify high-risk cohorts (above-average depression, below-average social connectedness)
-- SELECT 
--     stay,
--     COUNT(*) AS count_int,
--     ROUND(AVG(todep), 2) AS average_phq,
--     ROUND(AVG(tosc), 2) AS average_scs,
--     ROUND(AVG(toas), 2) AS average_as,
--     CASE 
--         WHEN ROUND(AVG(todep), 2) > 7 AND ROUND(AVG(tosc), 2) < 40 THEN 'High Risk'
--         WHEN ROUND(AVG(todep), 2) > 7 THEN 'Elevated Depression'
--         WHEN ROUND(AVG(tosc), 2) < 40 THEN 'Low Social Connection'
--         ELSE 'Standard'
--     END AS risk_profile
-- FROM students
-- WHERE inter_dom = 'Inter'
-- GROUP BY stay
-- ORDER BY stay DESC;

-- DATA QUALITY CHECKS
-- Use these queries to validate data integrity before analysis

-- Check for null values in key columns
-- SELECT 
--     SUM(CASE WHEN stay IS NULL THEN 1 ELSE 0 END) AS null_stay,
--     SUM(CASE WHEN todep IS NULL THEN 1 ELSE 0 END) AS null_todep,
--     SUM(CASE WHEN tosc IS NULL THEN 1 ELSE 0 END) AS null_tosc,
--     SUM(CASE WHEN toas IS NULL THEN 1 ELSE 0 END) AS null_toas
-- FROM students
-- WHERE inter_dom = 'Inter';

-- Verify value ranges for mental health scores
-- SELECT 
--     'PHQ-9 (todep)' AS metric,
--     MIN(todep) AS min_value,
--     MAX(todep) AS max_value,
--     COUNT(*) AS n_records
-- FROM students
-- WHERE inter_dom = 'Inter'
-- UNION ALL
-- SELECT 
--     'SCS (tosc)' AS metric,
--     MIN(tosc) AS min_value,
--     MAX(tosc) AS max_value,
--     COUNT(*) AS n_records
-- FROM students
-- WHERE inter_dom = 'Inter'
-- UNION ALL
-- SELECT 
--     'ASISS (toas)' AS metric,
--     MIN(toas) AS min_value,
--     MAX(toas) AS max_value,
--     COUNT(*) AS n_records
-- FROM students
-- WHERE inter_dom = 'Inter';

-- PERFORMANCE OPTIMIZATION
-- For large datasets, consider these optimizations:
-- 1. Create indexes on frequently filtered columns
--    CREATE INDEX idx_inter_dom ON students(inter_dom);
--    CREATE INDEX idx_stay ON students(stay);

-- 2. Partition data by inter_dom if dataset grows significantly
--    This improves WHERE clause performance for large tables

-- 3. Use materialized views for frequently run aggregations
--    CREATE MATERIALIZED VIEW international_student_health_summary AS
--    SELECT ... [main query];

-- NOTES FOR REPRODUCIBILITY
-- - Query assumes PostgreSQL or PostgreSQL-compatible database (e.g., Amazon RDS)
-- - ROUND function behavior: ROUND(x, 2) rounds to 2 decimal places
-- - COUNT(*) includes all rows; use COUNT(column_name) only if you need non-null counts
-- - DESC sorts from highest to lowest (10 years down to 1 year)
-- - LIMIT 9 may exclude groups with stay > 10 years; verify data range if unexpected
-- - All aliases (AS) are required for clarity and downstream compatibility

-- RELATED DOCUMENTATION
-- See README.md for:
--   - Complete methodology and research questions
--   - Data dictionary and instrument descriptions
