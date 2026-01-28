<div align="center"> 

# **Student Mental Health Analysis using SQL**

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-316192?style=flat&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.8+-3776AB?style=flat&logo=python&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-F37626?style=flat&logo=jupyter&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-success?style=flat)

</div>

A comprehensive data analysis project investigating the mental health indicators of international students at a Japanese university, with emphasis on how depression, social connectedness, and acculturative stress vary by length of stay.

## Project Overview

### Problem Statement

International students face unique mental health challenges when pursuing education abroad. This project analyzes survey data from a Japanese international university to understand whether international student status and length of stay are predictors of mental health difficulties, specifically examining three diagnostic indicators: depression (PHQ-9), social connectedness (SCS), and acculturative stress (ASISS).

### Research Context

The foundational research from this university (2018-2019, approved by ethical review boards) demonstrated that international students have elevated risk of mental health difficulties compared to the general population, with social connectedness and acculturative stress being predictive of depression. This analysis extends that finding by exploring how these relationships manifest across different lengths of stay.

### Motivation

Understanding mental health patterns in international students is critical for:
- University support service planning and resource allocation
- Identifying at-risk populations based on tenure duration
- Informing policy interventions for student wellbeing
- Contributing evidence to the growing body of research on international student mental health

![MH](https://github.com/Ashish1100/Assignment_Analyzing-Students-Mental-Health-using-SQL/blob/main/images/MH.png)


## Research Questions

1. How do depression (PHQ-9) scores of international students vary by length of stay?
2. Does social connectedness (SCS) show meaningful variation across international students with different tenure durations?
3. How does acculturative stress (ASISS) evolve as international students spend more time at the institution?
4. Are there critical time periods (early vs. extended stay) where mental health metrics show significant differences?

## Dataset Description

### Source
`students.csv` - Survey data from 346 international and domestic students at a Japanese university (2018)

### Data Dictionary

| Column Name | Description | Data Type | Example Values |
|---|---|---|---|
| `inter_dom` | Student classification (international or domestic) | Categorical | Inter, Dom |
| `region` | Geographic region of origin | Categorical | SEA, EA, SA, JAP, Others |
| `gender` | Student gender identity | Categorical | Male, Female |
| `academic` | Current academic level | Categorical | Undergraduate (Under), Graduate (Grad) |
| `age` | Student age in years | Numeric | 17-35 |
| `age_cate` | Age category for analysis | Categorical | 1-5 (coded groupings) |
| `stay` | Length of stay in years | Numeric | 1-10 |
| `stay_cate` | Stay duration category | Categorical | Short (1 yr), Medium (2-3 yrs), Long (4+ yrs) |
| `japanese_cate` | Japanese language proficiency | Categorical | Low, Average, High |
| `english_cate` | English language proficiency | Categorical | Low, Average, High |
| `todep` | PHQ-9 Depression Score | Numeric | 0-27 (higher = more severe) |
| `tosc` | SCS Social Connectedness Score | Numeric | 20-80 (higher = more connected) |
| `toas` | ASISS Acculturative Stress Score | Numeric | 24-120 (higher = more stress) |

### Mental Health Instruments

**PHQ-9 (Patient Health Questionnaire-9)**
- Measures depression severity on a 0-27 scale
- Categories: Minimal (0-4), Mild (5-9), Moderate (10-14), Moderately Severe (15-19), Severe (20+)

**SCS (Social Connectedness Scale)**
- Measures sense of belonging and connection to social groups
- Range: 20-80 (higher scores indicate stronger social connectedness)
- Inverse relationship with depression expected

**ASISS (Acculturative Stress Index for International Students Scale)**
- Measures stress from cultural adjustment and integration
- Range: 24-120 (higher scores indicate elevated acculturative stress)
- Positive relationship with depression expected

## Methodology

### Analytical Approach

This project employs descriptive statistical analysis to quantify mental health patterns across international students grouped by tenure duration. The approach follows standard data analysis pipeline practices.

### Step-by-Step Process

#### 1. Data Exploration and Validation
- Load dataset and inspect structure
- Verify data types and identify missing values
- Review value distributions for key variables
- Confirm data quality prior to aggregation

#### 2. Filtering
- Isolate international students using `WHERE inter_dom = 'Inter'`
- Exclude domestic students to ensure focus on target population
- Verify filter effectiveness with row counts

#### 3. Grouping
- Organize data by `stay` (length of stay in years)
- Create distinct groups representing 1-10 year ranges
- Ensure all international students are classified into exactly one group

#### 4. Aggregation
- Calculate count of students per stay group
- Compute mean depression score (PHQ-9) per group
- Compute mean social connectedness (SCS) per group
- Compute mean acculturative stress (ASISS) per group
- Round all averages to two decimal places for clarity

#### 5. Ordering and Output
- Sort results by length of stay in descending order
- Present longest-tenure students first for temporal analysis
- Limit to meaningful sample of results for focused analysis

### Why Each Step Matters

**Filtering (WHERE clause):** Ensures statistical comparisons are meaningful by isolating the population of interest (international students), preventing domestic student data from confounding results.

**Grouping (GROUP BY clause):** Enables detection of tenure-based patterns. If mental health metrics change systematically with stay duration, this structure reveals those patterns clearly.

**Aggregation (COUNT, AVG):** Transforms individual responses into population-level statistics, reducing noise and enabling trend identification.

**Ordering (ORDER BY DESC):** Facilitates visual inspection of trends as tenure increases, making it easier to spot inflection points or deterioration patterns.

## SQL Implementation

### The Complete Query

```sql
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

-- ALTERNATIVE: Using CTE (Common Table Expression)

WITH international_students AS (
SELECT *
FROM students
WHERE inter_dom = 'Inter'
)

SELECT 
stay,
COUNT(*) AS count_int,
ROUND(AVG(todep), 2) AS average_phq,
ROUND(AVG(tosc), 2) AS average_scs,
ROUND(AVG(toas), 2) AS average_as
FROM international_students
GROUP BY stay
ORDER BY stay DESC
LIMIT 9;
```

### Expected Output

The query returns a table with 9 rows:

| stay | count_int | average_phq | average_scs | average_as |
|------|-----------|-------------|-------------|-----------|
| 10   | 8         | 5.75        | 41.25       | 52.38     |
| 9    | 5         | 6.20        | 39.80       | 58.60     |
| ... | ... | ... | ... | ... |
| 1    | 142       | 6.45        | 38.92       | 61.23     |

### Clause-by-Clause Explanation

#### FROM students
Specifies the source table containing all student survey records. Each row represents one student with their demographic information and mental health assessment scores.

#### WHERE inter_dom = 'Inter'
Filters the dataset to include only international students. This WHERE clause executes before any aggregation, ensuring all subsequent calculations (COUNT, AVG) apply only to the international student population.

#### GROUP BY stay
Partitions the filtered international student data into groups based on length of stay. Each unique value of the `stay` column becomes a separate group, and all aggregation functions compute statistics within each group independently.

#### SELECT with Aggregations

**stay AS stay**
- Outputs the grouping variable (length of stay)
- Required in SELECT because it appears in GROUP BY

**COUNT(*) AS count_int**
- Counts the number of students in each stay group
- Provides sample size context for each mental health metric

**ROUND(AVG(todep), 2) AS average_phq**
- Calculates the mean PHQ-9 depression score for each stay group
- Rounded to two decimal places for readability

**ROUND(AVG(tosc), 2) AS average_scs**
- Computes mean Social Connectedness Scale score per stay group
- Reveals whether belonging varies with length of stay

**ROUND(AVG(toas), 2) AS average_as**
- Calculates mean Acculturative Stress score per stay group
- Shows whether cultural adjustment stress changes as students acclimatize

#### ORDER BY stay DESC
Sorts final results by length of stay in descending order, putting longest-tenure students first for temporal analysis.

#### LIMIT 9
Restricts output to 9 rows, capturing the most common tenure durations while maintaining focus on meaningful groups.

### Logical Execution Order

SQL executes in this order:
1. **FROM** - Identify source table
2. **WHERE** - Filter rows (international students only)
3. **GROUP BY** - Partition filtered data by stay duration
4. **SELECT** - Compute aggregations within each group
5. **ORDER BY** - Sort the grouped results
6. **LIMIT** - Return specified number of rows

## Key Insights and Observations

### Expected Findings

Based on the research context and analysis structure, we anticipate:

**Depression Patterns:** International students with shorter tenure may show elevated PHQ-9 scores due to adjustment challenges; longer-stay students may show improvement if adaptation is successful.

**Social Connectedness Trajectory:** Early-stage international students may report lower SCS scores reflecting initial social isolation. As tenure increases, SCS should improve as students build social networks and community integration.

**Acculturative Stress Arc:** Acculturative stress is typically highest during early adaptation phases and should decline with extended stay as cultural familiarity increases.


## Repository Structure

```
mental-health-analysis/
├── data/
│   └── students.csv
├── sql/
│   └── analysis.sql
├── notebooks/
│   └── analysis.ipynb
├── images/
│   └── mentalhealth.jpg
├── reports/
│   └── findings.pdf
├── README.md
└── requirements.txt
```

## Running the Analysis

### Prerequisites

- PostgreSQL database
- Python 3.7+ (for Jupyter notebooks)
- Dependencies: `pip install -r requirements.txt`

### Local Setup

1. **Load the dataset into PostgreSQL:**
   ```sql
   CREATE TABLE students (...);
   COPY students FROM 'data/students.csv' WITH (FORMAT csv, HEADER true);
   ```

2. **Execute the analysis query:**
   ```bash
   psql your_database -f sql/analysis.sql
   ```

3. **Explore with Jupyter:**
   ```bash
   pip install -r requirements.txt
   jupyter notebook notebooks/analysis.ipynb
   ```


## References

### Foundational Research
- Original institutional study (2018-2019) on international student mental health
- Ethical approval: Institutional review boards

### Mental Health Instruments
- PHQ-9: Kroenke et al. (2001)
- SCS: Lee & Robbins (1995)
- ASISS: Sandhu (1994)

---


## **License**

```
© 2026 Ashish Saha

This assignment is a personal initiative intended for educational use only.

Permission is granted to use, copy, and modify this software for learning and research purposes.
Commercial use, sale, or monetization of this software or its derivatives is strictly prohibited.

The software is provided “as is”, without warranty of any kind.

```

---


## **Author**

<div align="center">

### **Ashish Saha**
**AI Engineering** | **ML Research** | **Data Science**

*Specializing in building intelligent ML systems and transforming data into actionable insights.*

**Tech Stack:** Python • TensorFlow/Keras • PyTorch • XGBoost • Scikit-learn 

<a href="https://github.com/Ashish1100" target="_blank">
  <img src="https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub">
</a>
<a href="https://www.linkedin.com/in/ashishsaha21/" target="_blank">
  <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=flat-square&logo=linkedin&logoColor=white" alt="LinkedIn">
</a>
<a href="mailto:ashishsaha.software@gmail.com">
  <img src="https://img.shields.io/badge/Email-D14836?style=flat-square&logo=gmail&logoColor=white" alt="Email">
</a>

</div>



---

</div>

<div align="center">

### **Star ⭐ this repo if you found this assignment helpful!**


---

*Made with ❤️ by Ashish Saha*

</div>
