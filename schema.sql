CREATE TABLE indents (
    indent_id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    origin_city TEXT NOT NULL,
    destination_city TEXT NOT NULL,
    created_at DATETIME NOT NULL,
    required_date DATE NOT NULL
);

CREATE TABLE bids (
    bid_id INTEGER PRIMARY KEY,
    indent_id INTEGER,
    transporter_name TEXT NOT NULL,
    quote_amount DECIMAL(10,2) NOT NULL,
    bid_status TEXT CHECK(bid_status IN ('Accepted', 'Rejected')),
    bid_time DATETIME NOT NULL,
    FOREIGN KEY (indent_id) REFERENCES indents(indent_id)
);

CREATE TABLE trips (
    trip_id INTEGER PRIMARY KEY,
    indent_id INTEGER,
    transporter_name TEXT NOT NULL,
    dispatch_time DATETIME,
    delivery_time DATETIME,
    gps_coverage_pct INTEGER,
    status TEXT CHECK(status IN ('Completed', 'Cancelled', 'In Transit')),
    FOREIGN KEY (indent_id) REFERENCES indents(indent_id)
);

CREATE TABLE freight_invoices (
    invoice_id INTEGER PRIMARY KEY,
    trip_id INTEGER,
    base_freight DECIMAL(10,2) NOT NULL,
    fuel_surcharge DECIMAL(10,2) DEFAULT 0,
    penalty_amount DECIMAL(10,2) DEFAULT 0,
    final_invoiced_amount DECIMAL(10,2) NOT NULL,
    payment_status TEXT CHECK(payment_status IN ('Paid', 'Pending', 'Disputed')),
    FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
);
