# B2B-Frieght_Procurement_Analysis

## Overview
This project models a relational database for an enterprise B2B Transportation Management System (TMS). It analyzes critical supply chain metrics including procurement cycle times, carrier dropouts post-award, and financial penalty risks associated with incomplete GPS tracking.

## Relational Schema
The database contains four core tables tracking the full freight lifecycle:
- **`indents`**: Tracks shipper freight requests, origin-destination lanes, and required dates.
- **`bids`**: Logs reverse-auction bids placed by logistics service providers.
- **`trips`**: Records dispatch execution, delivery completion, and GPS tracking percentages.
- **`freight_invoices`**: Details base freight costs, fuel surcharges, penalties, and payment statuses.

## Analytical Scope & Business Insights

### 1. Transporter Dropout Rate Analysis
- **Business Goal**: Identify carriers that submit competitive quotes to win indents but subsequently cancel trip assignments.
- **Technical Approach**: Applied Common Table Expressions (CTEs), conditional aggregation (`CASE` statements), and `LEFT JOIN` operations across bidding and execution tables.

### 2. Month-over-Month (MoM) Indent Cycle Time Trends
- **Business Goal**: Evaluate turnaround efficiency from indent creation to carrier award per enterprise customer.
- **Technical Approach**: Used SQLite date/time functions (`julianday`) and SQL Window Functions (`LAG() OVER (PARTITION BY ... ORDER BY ...)`) to track MoM changes in average cycle hours.

### 3. GPS Compliance vs. Financial Risk
- **Business Goal**: Assess whether incomplete trip tracking (< 80% coverage) correlates with invoice disputes and penalty deductions.
- **Technical Approach**: Applied conditional grouping to measure total dispute frequency and penalty amounts across tracking threshold buckets.

## Repository Contents
- `schema.sql`: Database definition language (DDL) scripts for table creation and foreign key relations.
- `queries.sql`: Production SQL queries covering CTEs, window functions, and multi-table joins.
