-- IT Services Business Performance & Client Analytics
-- MySQL 8+
-- Portfolio project: synthetic IT services data
-- Purpose: demonstrate data cleaning, relational analysis and business reporting.

CREATE DATABASE IF NOT EXISTS it_services_analytics;
USE it_services_analytics;

-- =========================================================
-- 1. CORE BUSINESS ANALYSIS
-- =========================================================

-- Overall project / financial KPIs
SELECT
    COUNT(DISTINCT Project_ID) AS total_projects,
    SUM(Project_Value) AS total_project_value,
    SUM(Project_Cost) AS total_project_cost,
    SUM(Project_Value - Project_Cost) AS total_profit,
    ROUND(
        SUM(Project_Value - Project_Cost) / NULLIF(SUM(Project_Value), 0) * 100,
        2
    ) AS profit_margin_pct
FROM projects;

-- Project status distribution
SELECT Project_Status, COUNT(*) AS project_count
FROM projects
GROUP BY Project_Status
ORDER BY project_count DESC;

-- Service-level profitability
SELECT
    Service_Type,
    COUNT(DISTINCT Project_ID) AS projects,
    SUM(Project_Value) AS project_value,
    SUM(Project_Cost) AS project_cost,
    SUM(Project_Value - Project_Cost) AS profit,
    ROUND(
        SUM(Project_Value - Project_Cost) / NULLIF(SUM(Project_Value), 0) * 100,
        2
    ) AS margin_pct
FROM projects
GROUP BY Service_Type
ORDER BY profit DESC;

-- Top 10 clients by project value
SELECT
    c.Client_ID,
    c.Client_Name,
    SUM(p.Project_Value) AS total_project_value
FROM clients c
JOIN projects p ON c.Client_ID = p.Client_ID
GROUP BY c.Client_ID, c.Client_Name
ORDER BY total_project_value DESC
LIMIT 10;

-- =========================================================
-- 2. DELIVERY PERFORMANCE
-- =========================================================

-- Late completed projects
SELECT
    COUNT(DISTINCT Project_ID) AS late_projects
FROM projects
WHERE Actual_End_Date IS NOT NULL
  AND Actual_End_Date > Planned_End_Date;

-- Average delivery variance in days
-- Positive = late, negative = early, zero = on time
SELECT
    ROUND(
        AVG(DATEDIFF(Actual_End_Date, Planned_End_Date)),
        2
    ) AS avg_delivery_variance_days
FROM projects
WHERE Actual_End_Date IS NOT NULL;

-- Late projects by service
SELECT
    Service_Type,
    COUNT(DISTINCT Project_ID) AS late_projects
FROM projects
WHERE Actual_End_Date IS NOT NULL
  AND Actual_End_Date > Planned_End_Date
GROUP BY Service_Type
ORDER BY late_projects DESC;

-- =========================================================
-- 3. SUPPORT / SLA ANALYSIS
-- =========================================================

-- Ticket volume by issue type
SELECT Issue_Type, COUNT(*) AS ticket_count
FROM support_tickets
GROUP BY Issue_Type
ORDER BY ticket_count DESC;

-- Ticket status distribution
SELECT Ticket_Status, COUNT(*) AS ticket_count
FROM support_tickets
GROUP BY Ticket_Status
ORDER BY ticket_count DESC;

-- SLA breach KPI
SELECT
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN SLA_Status = 'Breached' THEN 1 ELSE 0 END) AS sla_breached,
    ROUND(
        SUM(CASE WHEN SLA_Status = 'Breached' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS sla_breach_pct
FROM support_tickets;

-- SLA breaches by priority
SELECT
    Priority,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN SLA_Status = 'Breached' THEN 1 ELSE 0 END) AS sla_breaches
FROM support_tickets
GROUP BY Priority
ORDER BY sla_breaches DESC;

-- Average resolution time and rating by issue type
SELECT
    Issue_Type,
    ROUND(AVG(Resolution_Hours), 2) AS avg_resolution_hours,
    ROUND(AVG(Customer_Rating), 2) AS avg_customer_rating
FROM support_tickets
GROUP BY Issue_Type
ORDER BY avg_resolution_hours DESC;

-- =========================================================
-- 4. EMPLOYEE / WORKFORCE ANALYSIS
-- =========================================================

-- Employee workload and performance
SELECT
    e.Employee_ID,
    e.Employee_Name,
    e.Department,
    SUM(pe.Hours_Allocated) AS hours_allocated,
    SUM(pe.Hours_Worked) AS hours_worked,
    SUM(pe.Tasks_Completed) AS tasks_completed,
    ROUND(AVG(pe.Quality_Score), 2) AS avg_quality_score,
    ROUND(AVG(pe.Performance_Rating), 2) AS avg_performance_rating
FROM employees e
JOIN project_employee_performance pe
    ON e.Employee_ID = pe.Employee_ID
GROUP BY e.Employee_ID, e.Employee_Name, e.Department
ORDER BY avg_performance_rating DESC;

-- Employees whose worked hours exceed allocated hours
SELECT
    e.Employee_ID,
    e.Employee_Name,
    SUM(pe.Hours_Allocated) AS hours_allocated,
    SUM(pe.Hours_Worked) AS hours_worked,
    SUM(pe.Hours_Worked - pe.Hours_Allocated) AS hours_over_allocation
FROM employees e
JOIN project_employee_performance pe
    ON e.Employee_ID = pe.Employee_ID
GROUP BY e.Employee_ID, e.Employee_Name
HAVING SUM(pe.Hours_Worked) > SUM(pe.Hours_Allocated)
ORDER BY hours_over_allocation DESC;

-- Top 10 employees by performance rating
SELECT
    e.Employee_Name,
    e.Department,
    ROUND(AVG(pe.Performance_Rating), 2) AS avg_performance_rating
FROM employees e
JOIN project_employee_performance pe
    ON e.Employee_ID = pe.Employee_ID
GROUP BY e.Employee_ID, e.Employee_Name, e.Department
ORDER BY avg_performance_rating DESC
LIMIT 10;

-- =========================================================
-- 5. DATA QUALITY CHECKS
-- =========================================================

-- Duplicate client records
SELECT Client_ID, Client_Name, COUNT(*) AS record_count
FROM clients
GROUP BY Client_ID, Client_Name
HAVING COUNT(*) > 1;

-- Missing client industry
SELECT *
FROM clients
WHERE Industry IS NULL OR TRIM(Industry) = '';

-- Support tickets with valid unresolved blanks
-- NULL resolution fields can be expected for unresolved/pending tickets.
SELECT
    Ticket_Status,
    COUNT(*) AS tickets,
    SUM(CASE WHEN Resolved_Date IS NULL THEN 1 ELSE 0 END) AS unresolved_date_missing
FROM support_tickets
GROUP BY Ticket_Status;

-- =========================================================
-- 6. REFERENCE RESULTS FROM THE SUPPLIED PORTFOLIO DATA
-- =========================================================
-- These values are included as documentation, not hard-coded into the analysis.
-- Projects: 350
-- Clients: 180 unique IDs; raw rows = 182
-- Employees: 150
-- Support tickets: 1,800
-- Performance records: 1,203
-- Total project value: 232,442,000.00
-- Total project cost: 156,552,000.00
-- Total profit: 75,890,000.00
-- Profit margin: 32.65%
-- Late completed projects: 52
-- SLA breaches: 646 (35.89%)
-- Average resolution hours: 14.80
-- Average customer rating: 4.08
-- Average delivery variance: 16.08 days
