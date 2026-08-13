-- Transporter Rejection & Dropout Rate Analysis
WITH WinningBids AS (
    SELECT 
        b.transporter_name,
        b.indent_id,
        b.quote_amount,
        t.status AS trip_status
    FROM bids b
    LEFT JOIN trips t ON b.indent_id = t.indent_id 
                     AND b.transporter_name = t.transporter_name
    WHERE b.bid_status = 'Accepted'
)
SELECT 
    transporter_name,
    COUNT(indent_id) AS total_awarded_indents,
    COUNT(CASE WHEN trip_status = 'Cancelled' THEN 1 END) AS total_cancellations,
    ROUND(
        (COUNT(CASE WHEN trip_status = 'Cancelled' THEN 1 END) * 100.0) / COUNT(indent_id), 
        2
    ) AS dropout_rate_pct
FROM WinningBids
GROUP BY transporter_name
ORDER BY dropout_rate_pct DESC;


-- Indent-to-Award Cycle Time Analysis (MoM Trend using Window Functions)
WITH CycleTimes AS (
    SELECT 
        i.customer_name,
        strftime('%Y-%m', i.created_at) AS indent_month,
        ROUND(AVG((julianday(b.bid_time) - julianday(i.created_at)) * 24), 2) AS avg_turnaround_hours
    FROM indents i
    JOIN bids b ON i.indent_id = b.indent_id
    WHERE b.bid_status = 'Accepted'
    GROUP BY i.customer_name, strftime('%Y-%m', i.created_at)
)
SELECT 
    customer_name,
    indent_month,
    avg_turnaround_hours,
    LAG(avg_turnaround_hours) OVER (
        PARTITION BY customer_name 
        ORDER BY indent_month
    ) AS previous_month_hours
FROM CycleTimes;


-- GPS Compliance vs. Invoice Dispute Rate
SELECT 
    CASE 
        WHEN t.gps_coverage_pct >= 80 THEN 'High Coverage (>=80%)'
        ELSE 'Low Coverage (<80%)'
    END AS tracking_compliance,
    COUNT(t.trip_id) AS total_trips,
    SUM(f.penalty_amount) AS total_penalties_incurred,
    COUNT(CASE WHEN f.payment_status = 'Disputed' THEN 1 END) AS disputed_invoices
FROM trips t
JOIN freight_invoices f ON t.trip_id = f.trip_id
WHERE t.status = 'Completed'
GROUP BY tracking_compliance;
