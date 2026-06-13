-- ============================================================
-- TASK 2: DATA ANALYSIS WITH COMPLEX QUERIES
-- ============================================================

USE placement_db;

-- ============================================================
-- SECTION A: SUBQUERIES
-- ============================================================

-- ------------------------------------------------------------
-- A.1 Students with CGPA above the average CGPA
-- Subquery calculates the average; outer query filters students.
-- ------------------------------------------------------------
SELECT
    Student_ID,
    Name,
    Branch,
    CGPA
FROM Students
WHERE CGPA > (SELECT AVG(CGPA) FROM Students)
ORDER BY CGPA DESC;

-- ------------------------------------------------------------
-- A.2 Students who have been placed (using EXISTS subquery)
-- ------------------------------------------------------------
SELECT
    s.Student_ID,
    s.Name,
    s.Branch,
    s.CGPA
FROM Students s
WHERE EXISTS (
    SELECT 1
    FROM Placements p
    WHERE p.Student_ID = s.Student_ID
)
ORDER BY s.CGPA DESC;

-- ------------------------------------------------------------
-- A.3 Company with the highest salary offer (correlated subquery)
-- ------------------------------------------------------------
SELECT
    c.Company_Name,
    p.Salary_Package,
    s.Name AS Student_Name
FROM Placements p
JOIN Companies c  ON p.Company_ID = c.Company_ID
JOIN Students  s  ON p.Student_ID = s.Student_ID
WHERE p.Salary_Package = (SELECT MAX(Salary_Package) FROM Placements);


-- ============================================================
-- SECTION B: WINDOW FUNCTIONS
-- ============================================================

-- ------------------------------------------------------------
-- B.1 Rank students by CGPA within each branch
-- RANK() assigns the same rank for ties; gaps appear after ties.
-- ------------------------------------------------------------
SELECT
    Student_ID,
    Name,
    Branch,
    CGPA,
    RANK() OVER (PARTITION BY Branch ORDER BY CGPA DESC) AS BranchRank,
    DENSE_RANK() OVER (PARTITION BY Branch ORDER BY CGPA DESC) AS DenseRank,
    ROW_NUMBER() OVER (PARTITION BY Branch ORDER BY CGPA DESC) AS RowNum
FROM Students
ORDER BY Branch, BranchRank;

-- ------------------------------------------------------------
-- B.2 Running total of applications over time
-- SUM() OVER with ORDER BY creates a running cumulative total.
-- ------------------------------------------------------------
SELECT
    Application_ID,
    Student_ID,
    Application_Date,
    Status,
    COUNT(*)  OVER (ORDER BY Application_Date
                   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
              AS Running_Total_Applications
FROM Applications
ORDER BY Application_Date;

-- ------------------------------------------------------------
-- B.3 Salary comparison: each student vs company average
-- LAG/LEAD shows previous and next salary for comparison.
-- ------------------------------------------------------------
SELECT
    s.Name             AS Student_Name,
    c.Company_Name,
    p.Salary_Package,
    AVG(p.Salary_Package) OVER (PARTITION BY p.Company_ID)
                           AS Avg_Company_Package,
    p.Salary_Package - AVG(p.Salary_Package) OVER (PARTITION BY p.Company_ID)
                           AS Difference_From_Avg
FROM Placements p
JOIN Students  s ON p.Student_ID  = s.Student_ID
JOIN Companies c ON p.Company_ID  = c.Company_ID;

-- ============================================================
-- SECTION C: COMMON TABLE EXPRESSIONS (CTEs)
-- ============================================================

-- ------------------------------------------------------------
-- C.1 Branch-wise placement rate using CTE
-- ------------------------------------------------------------
WITH BranchTotal AS (
    -- Total students per branch
    SELECT Branch, COUNT(*) AS Total_Students
    FROM Students
    GROUP BY Branch
),
BranchPlaced AS (
    -- Placed students per branch
    SELECT s.Branch, COUNT(DISTINCT p.Student_ID) AS Placed_Students
    FROM Students s
    JOIN Placements p ON s.Student_ID = p.Student_ID
    GROUP BY s.Branch
)
SELECT
    bt.Branch,
    bt.Total_Students,
    COALESCE(bp.Placed_Students, 0)           AS Placed_Students,
    ROUND(
        COALESCE(bp.Placed_Students, 0) * 100.0 / bt.Total_Students,
        2
    )                                           AS Placement_Rate_Pct
FROM BranchTotal bt
LEFT JOIN BranchPlaced bp ON bt.Branch = bp.Branch
ORDER BY Placement_Rate_Pct DESC;

-- ------------------------------------------------------------
-- C.2 Top applicant per company using CTE + Window Function
-- ------------------------------------------------------------
WITH ApplicationCounts AS (
    SELECT
        s.Student_ID,
        s.Name           AS Student_Name,
        c.Company_Name,
        COUNT(a.Application_ID) AS App_Count,
        RANK() OVER (
            PARTITION BY c.Company_Name
            ORDER BY COUNT(a.Application_ID) DESC
        ) AS Company_Rank
    FROM Applications a
    JOIN Job_Postings j ON a.Job_ID    = j.Job_ID
    JOIN Companies c    ON j.Company_ID = c.Company_ID
    JOIN Students  s    ON a.Student_ID = s.Student_ID
    GROUP BY s.Student_ID, s.Name, c.Company_Name
)
SELECT Student_Name, Company_Name, App_Count
FROM ApplicationCounts
WHERE Company_Rank = 1
ORDER BY Company_Name;


-- ------------------------------------------------------------
-- C.3 Multi-step CTE: Application funnel analysis
-- Shows how many applications at each stage of hiring
-- ------------------------------------------------------------
WITH StatusSummary AS (
    SELECT
        Status,
        COUNT(*) AS Total
    FROM Applications
    GROUP BY Status
),
FunnelRanked AS (
    SELECT
        Status,
        Total,
        ROUND(Total * 100.0 / SUM(Total) OVER (), 2) AS Percentage
    FROM StatusSummary
)
SELECT
    Status,
    Total,
    Percentage,
    RPAD('█', CAST(Percentage / 5 AS UNSIGNED), '█') AS Bar_Chart
FROM FunnelRanked
ORDER BY Total DESC;

-- ============================================================
-- REPORT SUMMARY
-- ============================================================
/*
PLACEMENT ANALYTICS REPORT — 2024 COHORT
==========================================
1. Total Students:        6
2. Total Applications:    6
3. Total Placements:      2
4. Overall Placement %:   33.33%
5. Highest CGPA:          9.50 (Fiona Green, CS)
6. Highest Package:       ₹12,00,000 (Alice Johnson at Google)
7. Top Branch:            Computer Science (66.67% placement rate)
8. Application Trend:     Steady — 1 per day (Jan 10-15, 2024)
9. Top Hiring Company:    Google (2 hires)
10. Students Not Applied: Evan Rogers (Civil Engineering)

KEY PATTERNS IDENTIFIED:
- All placements are from Computer Science branch
- Higher CGPA students (>8.5) got hired; lower CGPA students were rejected/pending
- Google is the most active hiring company this cycle
*/
