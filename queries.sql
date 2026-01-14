-- =====================================================
-- ADVANCED SQL FEATURES
-- =====================================================

-- Create a trigger to update order total when items are added
DELIMITER //
CREATE TRIGGER update_order_total
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET total_amount = (
        SELECT SUM(quantity * unit_price * (1 - discount_percent/100))
        FROM order_items
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END//
DELIMITER ;

-- Create a stored procedure for customer lifetime value
DELIMITER //
CREATE PROCEDURE calculate_customer_ltv(IN cust_id INT)
BEGIN
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(o.total_amount) AS lifetime_value,
        AVG(o.total_amount) AS avg_order_value,
        MIN(o.order_date) AS first_order_date,
        MAX(o.order_date) AS last_order_date
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    WHERE c.customer_id = cust_id
    GROUP BY c.customer_id, c.first_name, c.last_name;
END//
DELIMITER ;

-- Create a function to calculate discount amount
DELIMITER //
CREATE FUNCTION calculate_discount(
    price DECIMAL(10,2),
    discount_pct DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN price * (discount_pct / 100);
END//
DELIMITER ;

-- =====================================================
-- BUSINESS ANALYTICS QUERIES
-- =====================================================

-- Query 1: Monthly Revenue Analysis
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(total_amount) AS revenue,
    AVG(total_amount) AS avg_order_value,
    SUM(CASE WHEN status = 'delivered' THEN total_amount ELSE 0 END) AS delivered_revenue
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- Query 2: Top Performing Products with Rankings
WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        c.category_name,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_percent/100)) AS revenue,
        AVG(r.rating) AS avg_rating,
        COUNT(DISTINCT r.review_id) AS review_count
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    LEFT JOIN categories c ON p.category_id = c.category_id
    LEFT JOIN reviews r ON p.product_id = r.product_id
    GROUP BY p.product_id, p.product_name, c.category_name
)
SELECT 
    *,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank,
    DENSE_RANK() OVER (ORDER BY units_sold DESC) AS sales_rank
FROM product_sales
ORDER BY revenue DESC;

-- Query 3: Customer Segmentation (RFM Analysis)
WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(CURDATE(), MAX(o.order_date)) AS recency_days,
        COUNT(DISTINCT o.order_id) AS frequency,
        COALESCE(SUM(o.total_amount), 0) AS monetary
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
rfm_scores AS (
    SELECT 
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency) AS f_score,
        NTILE(5) OVER (ORDER BY monetary) AS m_score
    FROM customer_metrics
)
SELECT 
    *,
    CONCAT(r_score, f_score, m_score) AS rfm_segment,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'Potential Loyalists'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost'
        ELSE 'Regular'
    END AS customer_segment
FROM rfm_scores
ORDER BY monetary DESC;

-- Query 4: Product Recommendation (Frequently Bought Together)
SELECT 
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    COUNT(*) AS times_bought_together,
    AVG(o.total_amount) AS avg_order_value
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
JOIN orders o ON oi1.order_id = o.order_id
GROUP BY p1.product_id, p2.product_id, p1.product_name, p2.product_name
HAVING times_bought_together >= 2
ORDER BY times_bought_together DESC;

-- Query 5: Customer Cohort Analysis
WITH cohorts AS (
    SELECT 
        customer_id,
        DATE_FORMAT(MIN(order_date), '%Y-%m') AS cohort_month,
        order_date
    FROM orders
    GROUP BY customer_id, order_date
)
SELECT 
    cohort_month,
    COUNT(DISTINCT CASE WHEN TIMESTAMPDIFF(MONTH, STR_TO_DATE(CONCAT(cohort_month, '-01'), '%Y-%m-%d'), order_date) = 0 THEN customer_id END) AS month_0,
    COUNT(DISTINCT CASE WHEN TIMESTAMPDIFF(MONTH, STR_TO_DATE(CONCAT(cohort_month, '-01'), '%Y-%m-%d'), order_date) = 1 THEN customer_id END) AS month_1,
    COUNT(DISTINCT CASE WHEN TIMESTAMPDIFF(MONTH, STR_TO_DATE(CONCAT(cohort_month, '-01'), '%Y-%m-%d'), order_date) = 2 THEN customer_id END) AS month_2,
    COUNT(DISTINCT CASE WHEN TIMESTAMPDIFF(MONTH, STR_TO_DATE(CONCAT(cohort_month, '-01'), '%Y-%m-%d'), order_date) = 3 THEN customer_id END) AS month_3
FROM cohorts
GROUP BY cohort_month
ORDER BY cohort_month;

-- Query 6: Inventory Management - Low Stock Alert
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    p.stock_quantity,
    COALESCE(SUM(oi.quantity), 0) AS total_sold,
    COALESCE(AVG(oi.quantity), 0) AS avg_order_quantity,
    p.stock_quantity / NULLIF(AVG(oi.quantity), 0) AS days_of_inventory
FROM products p
JOIN categories c ON p.category_id = c.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE p.is_active = TRUE
GROUP BY p.product_id, p.product_name, c.category_name, p.stock_quantity
HAVING p.stock_quantity < 100 OR days_of_inventory < 30
ORDER BY days_of_inventory;

-- =====================================================
-- PERFORMANCE VIEWS FOR DASHBOARD
-- =====================================================

CREATE VIEW daily_sales_summary AS
SELECT 
    DATE(order_date) AS sale_date,
    COUNT(DISTINCT order_id) AS orders_count,
    COUNT(DISTINCT customer_id) AS customers_count,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS avg_order_value
FROM orders
WHERE status != 'cancelled'
GROUP BY DATE(order_date);

CREATE VIEW top_customers AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    MAX(o.order_date) AS last_order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY total_spent DESC
LIMIT 10;

-- =====================================================
-- TEST THE STORED PROCEDURE
-- =====================================================
CALL calculate_customer_ltv(1);