# IT Services Business Performance & Client Analytics

A portfolio Data Analytics project built around a realistic **synthetic IT services business dataset**.

The project follows an end-to-end workflow:

**CSV / Excel → Data Cleaning → MySQL SQL Analysis → Power BI Data Model & DAX → Dashboard → AI-assisted Reporting & Business Insights**

> **Important:** This is synthetic portfolio data. It is not Axivonix's confidential or internal business data.

## Project objective

The goal was to understand an IT services business from multiple angles:

- Client and project portfolio
- Project value, cost and profitability
- Project delivery performance
- IT support ticket volume and SLA performance
- Employee workload and performance
- Management-level recommendations

## Tools & technologies

- **Microsoft Excel** — initial data review and cleaning
- **MySQL** — relational database, joins, KPI calculations and business analysis
- **Power BI** — data model, relationships, DAX measures and interactive dashboards
- **DAX** — KPIs such as Total Profit, Profit Margin %, Late Projects, SLA Breach %, Average Resolution Hours and Average Delivery Variance
- **AI-assisted reporting** — used AI to help structure business reporting, summarize findings and turn analytical outputs into clear management-oriented explanations

## Data model

The project contains 5 related tables:

1. `clients` — client master data
2. `employees` — employee master data
3. `projects` — project, financial and delivery data
4. `support_tickets` — support activity and SLA data
5. `project_employee_performance` — project allocation, workload and performance data

### Main relationships

- Client → Projects
- Client → Support Tickets
- Employee → Support Tickets
- Project → Project Employee Performance
- Employee → Project Employee Performance
- Employee → Projects through Project Manager ID (kept inactive in Power BI to avoid an ambiguous filter path)

## Power BI dashboard pages

### 1. Executive Overview
High-level KPIs covering clients, projects, project value, cost, profit, margin and SLA performance.

### 2. Project Analytics
Project status, service profitability, top clients, late-project analysis and delivery performance.

### 3. IT Support Analytics
Ticket volume, ticket status, SLA breaches, resolution time, customer ratings and employee ticket handling.

### 4. Employee Analytics
Performance ranking, hours allocated vs worked, task completion, department performance and workload analysis.

### 5. Management Insights & Recommendations
Management-focused KPIs, profitability, delivery, SLA performance, top clients and action-oriented recommendations.

## Selected results from the supplied data

| Metric | Result |
|---|---:|
| Clients | 180 unique IDs |
| Raw client rows | 182 |
| Employees | 150 |
| Projects | 350 |
| Support tickets | 1,800 |
| Performance records | 1,203 |
| Total project value | 232,442,000.00 |
| Total project cost | 156,552,000.00 |
| Total profit | 75,890,000.00 |
| Profit margin | 32.65% |
| Late completed projects | 52 |
| SLA breach rate | 35.89% |
| Avg. resolution hours | 14.80 |
| Avg. customer rating | 4.08 |
| Avg. delivery variance | 16.08 days |

## Data-quality handling

The source data contains some intentional / realistic data-quality situations.

- Four client Industry values were blank and were treated as **Unknown** rather than guessing the industry.
- Two client records were exact duplicates in the raw client file.
- Blank `Actual_End_Date` values for unfinished projects were treated as valid because those projects were still ongoing.
- Blank support-ticket `Resolved_Date`, `Resolution_Hours` and `Customer_Rating` values were preserved as missing/NULL where appropriate rather than replacing them with artificial values.
- Project dates required date-format handling before SQL analysis.

## Key analytical logic

### Late Projects

A project is considered late when:

`Actual_End_Date > Planned_End_Date`

Ongoing projects with no Actual End Date are not counted as late.

### Average Delivery Variance

For completed projects:

`DATEDIFF(Actual_End_Date, Planned_End_Date)`

- Positive = late
- Negative = early
- Zero = on time

### Profit

`Project Value - Project Cost`

### SLA Breach %

`SLA Breached Tickets / Total Tickets`

## Repository structure

```text
IT-Services-Business-Analytics/
│
├── README.md
├── data/
│   ├── 01_Clients.csv
│   ├── 02_Employees.csv
│   ├── 03_Projects.csv
│   ├── 04_Support_Tickets.csv
│   └── 05_Project_Employee_Performance.csv
│
├── sql/
│   └── IT_Services_Analytics_SQL_Analysis.sql
│
├── powerbi/
│   └── IT_Services_Analytics.pbix
│
└── docs/
    └── LINKEDIN_POST.md
```

## What I learned

This project helped me practice more than dashboard creation. I worked through the complete analytics process: understanding the business problem, checking data quality, building relationships, writing SQL analysis, creating DAX measures, designing dashboards and finally converting analytical findings into management-oriented recommendations.

## Note on AI usage

AI was used as an **assistive reporting and reasoning tool**, not as a replacement for the underlying analysis. The data preparation, SQL analysis, Power BI model, DAX measures and dashboard design were part of the project workflow. AI helped with structuring explanations, reporting language and turning analytical findings into concise business recommendations.
