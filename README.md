# 🛍️ E-Commerce Analytics Platform

A comprehensive SQL project demonstrating advanced database design, complex queries, and business intelligence capabilities for e-commerce analytics.

![SQL](https://img.shields.io/badge/SQL-MySQL-blue)
![Database](https://img.shields.io/badge/Database-Design-green)
![Analytics](https://img.shields.io/badge/Analytics-Business_Intelligence-orange)

## 📋 Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Database Schema](#database-schema)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Advanced SQL Features](#advanced-sql-features)
- [Business Analytics Queries](#business-analytics-queries)
- [Performance Optimization](#performance-optimization)
- [Project Structure](#project-structure)
- [Future Enhancements](#future-enhancements)

## 🎯 Overview

This project showcases a production-ready e-commerce analytics database system that implements industry best practices for data modeling, query optimization, and business intelligence. It's designed to demonstrate proficiency in advanced SQL concepts and real-world database application development.

### Key Highlights
- **Normalized Database Design** (3NF) with 7 interconnected tables
- **Advanced SQL Features**: Triggers, Stored Procedures, User-Defined Functions
- **Complex Analytics**: Window Functions, CTEs, Cohort Analysis, RFM Segmentation
- **Performance Optimized**: Strategic indexing and query optimization
- **Business Intelligence**: Ready-to-use dashboard views and analytical queries

## ✨ Features

### 🗄️ Database Architecture
- **7 Normalized Tables**: Customers, Products, Categories, Orders, Order Items, Reviews, Payments
- **Referential Integrity**: Comprehensive foreign key constraints
- **Data Validation**: CHECK constraints and ENUM types for data quality
- **Cascading Operations**: Proper handling of delete operations
- **Strategic Indexing**: Performance-optimized queries

### 🚀 Advanced SQL Capabilities
- **Triggers**: Automatic order total calculation on item insertion
- **Stored Procedures**: Customer Lifetime Value (LTV) analysis
- **User-Defined Functions**: Dynamic discount calculations
- **Views**: Pre-built analytics dashboards
- **Window Functions**: Rankings, percentiles, running totals
- **CTEs**: Complex multi-step analytical queries

### 📊 Business Analytics
- Monthly revenue trends and growth analysis
- Product performance rankings and recommendations
- Customer segmentation using RFM analysis
- Cohort analysis for retention metrics
- Inventory management and low-stock alerts
- Cross-sell product recommendations

## 🗂️ Database Schema

### Entity Relationship Overview

```
customers (1) ──→ (M) orders (1) ──→ (M) order_items (M) ──→ (1) products
    │                   │                                          │
    └──→ (M) reviews ←──┘                                          │
                                                                   │
                                    categories (1) ────────────────┘
                                        │
                                        └──→ (self-referencing for hierarchy)
                    
                    orders (1) ──→ (M) payments
```

### Tables

#### 1. **customers**
- Primary customer information
- Contact details and registration data
- Indexed on email and registration_date

#### 2. **categories**
- Product categorization
- Self-referencing for category hierarchy
- Supports parent-child relationships

#### 3. **products**
- Product catalog with pricing
- Stock management
- Links to categories
- Active/inactive status tracking

#### 4. **orders**
- Order header information
- Customer relationship
- Order status tracking (pending → processing → shipped → delivered)
- Timestamp and shipping details

#### 5. **order_items**
- Order line items
- Product quantities and pricing
- Discount tracking
- Cascading delete on order removal

#### 6. **reviews**
- Customer product reviews
- 1-5 star rating system
- Review text and timestamps

#### 7. **payments**
- Payment transaction records
- Multiple payment methods
- Payment status tracking
- Transaction history

## 🛠️ Technologies Used

- **Database Management System**: MySQL 8.0+
- **SQL Features**: DDL, DML, DCL, TCL
- **Advanced Concepts**: 
  - Triggers
  - Stored Procedures
  - User-Defined Functions
  - Views
  - Window Functions
  - Common Table Expressions (CTEs)
  - Subqueries
  - Joins (INNER, LEFT, CROSS)

## 💻 Installation

### Prerequisites
- MySQL 8.0 or higher
- MySQL client or MySQL Workbench
- Sufficient permissions to create databases

### Setup Steps

1. **Clone or download this repository**
   ```bash
   git clone https://github.com/yourusername/E-Commerce-Analytics-Platform.git
   cd E-Commerce-Analytics-Platform
   ```

2. **Connect to MySQL**
   ```bash
   mysql -u your_username -p
   ```

3. **Execute the SQL files in order**
   ```sql
   -- Step 1: Create database and tables
   SOURCE tables.sql;
   
   -- Step 2: Insert sample data
   SOURCE data.sql;
   
   -- Step 3: Create triggers, procedures, and run analytics
   SOURCE queries.sql;
   ```

   **Or execute from command line:**
   ```bash
   mysql -u your_username -p < tables.sql
   mysql -u your_username -p < data.sql
   mysql -u your_username -p < queries.sql
   ```

4. **Verify installation**
   ```sql
   USE ecommerce_analytics;
   SHOW TABLES;
   SELECT COUNT(*) FROM customers;
   ```

## 📖 Usage

### Accessing the Database
```sql
USE ecommerce_analytics;
```

### Running Business Analytics Queries

#### Check Monthly Revenue
```sql
SELECT * FROM daily_sales_summary;
```

#### View Top Customers
```sql
SELECT * FROM top_customers;
```

#### Calculate Customer Lifetime Value
```sql
CALL calculate_customer_ltv(1);  -- Replace 1 with any customer_id
```

#### Get Product Performance Rankings
```sql
-- See top performing products by revenue
SELECT product_name, revenue, revenue_rank 
FROM (
    SELECT p.product_name,
           SUM(oi.quantity * oi.unit_price * (1 - oi.discount_percent/100)) AS revenue,
           RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price * (1 - oi.discount_percent/100)) DESC) AS revenue_rank
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name
) ranked
LIMIT 10;
```

#### Customer Segmentation
```sql
-- View RFM customer segments
-- (Run the RFM Analysis query from queries.sql)
```

## 🔧 Advanced SQL Features

### 1. Triggers
**Auto-Update Order Total**
- Automatically recalculates order total when items are added
- Ensures data consistency
- Eliminates manual total updates

```sql
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
```

### 2. Stored Procedures
**Customer Lifetime Value Calculation**
- Analyzes customer purchase history
- Calculates total spend and order metrics
- Provides date range analysis

```sql
CALL calculate_customer_ltv(customer_id);
```

### 3. User-Defined Functions
**Dynamic Discount Calculator**
- Reusable discount calculation logic
- Ensures consistency across queries

```sql
SELECT calculate_discount(100.00, 15.00);  -- Returns 15.00
```

### 4. Views
- **daily_sales_summary**: Daily revenue and order metrics
- **top_customers**: Top 10 customers by total spend

## 📊 Business Analytics Queries

### 1. Monthly Revenue Analysis
Tracks monthly performance with key metrics:
- Total orders
- Unique customers
- Total revenue
- Average order value
- Delivered revenue (completed transactions)

### 2. Product Performance Rankings
Identifies top-performing products using:
- Window functions (RANK, DENSE_RANK)
- Sales volume analysis
- Revenue contribution
- Customer ratings integration

### 3. RFM Customer Segmentation
Segments customers based on:
- **Recency**: Days since last purchase
- **Frequency**: Number of orders
- **Monetary**: Total spend
- Quintile scoring (1-5 for each dimension)
- Automatic customer labels (Champions, At Risk, Lost, etc.)

### 4. Product Recommendation Engine
- Identifies frequently bought together items
- Cross-sell opportunities
- Average order value for bundles

### 5. Cohort Analysis
- Customer retention tracking by acquisition month
- Month-over-month retention rates
- Cohort performance comparison

### 6. Inventory Management
- Low stock alerts
- Days of inventory calculation
- Average order quantity analysis
- Reorder recommendations

## ⚡ Performance Optimization

### Indexing Strategy
- **Primary Keys**: All tables have AUTO_INCREMENT primary keys
- **Foreign Keys**: Indexed for JOIN performance
- **Selective Indexes**: 
  - `customers.email` (frequent lookups)
  - `orders.order_date` (date range queries)
  - `products.category_id` (category filtering)
  - `products.price` (price range queries)

### Query Optimization Techniques
- Use of CTEs for readable complex queries
- Window functions to avoid self-joins
- Proper JOIN ordering
- WHERE clause optimization
- LIMIT clauses for large result sets

## 📁 Project Structure

```
E-Commerce-Analytics-Platform/
│
├── README.md              # Project documentation (this file)
├── tables.sql             # Database schema and table definitions
├── data.sql              # Sample data insertion
└── queries.sql           # Triggers, procedures, functions, and analytics queries
```

### File Descriptions

- **tables.sql**: Contains DDL statements for database creation, table structure, constraints, and indexes
- **data.sql**: INSERT statements with realistic sample data for testing and demonstration
- **queries.sql**: Advanced SQL features including triggers, stored procedures, functions, views, and complex analytical queries

## 🚀 Future Enhancements

Potential areas for expansion:

- [ ] **Additional Analytics**
  - Customer churn prediction
  - Market basket analysis (association rules)
  - Time-series forecasting
  
- [ ] **Advanced Features**
  - Full-text search for product descriptions
  - Geospatial analysis for shipping optimization
  - Real-time inventory tracking triggers
  
- [ ] **Data Warehouse Integration**
  - ETL processes for data warehousing
  - OLAP cube design
  - Star schema transformation
  
- [ ] **Reporting Layer**
  - Automated email reports
  - Dashboard integration (Tableau/Power BI)
  - API endpoints for data access

- [ ] **Enhanced Security**
  - Row-level security
  - Audit logging triggers
  - Encryption for sensitive data

## 📈 Sample Insights

This database enables answering critical business questions such as:

✅ Which products generate the most revenue?  
✅ Who are our most valuable customers?  
✅ What is our monthly growth rate?  
✅ Which customers are at risk of churning?  
✅ What products are frequently bought together?  
✅ Which items need restocking?  
✅ What is our customer retention rate?  

## 🤝 Contributing

This is a portfolio project, but suggestions and feedback are welcome! Feel free to:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## 📝 License

This project is open source and available for educational and portfolio purposes.

## 👤 Author

**Your Name**
- Portfolio: [Your Portfolio URL]
- LinkedIn: [Your LinkedIn]
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

---

## 🎓 Skills Demonstrated

This project showcases proficiency in:

- ✅ Database Design & Normalization
- ✅ Complex SQL Query Development
- ✅ Stored Procedures & Functions
- ✅ Trigger Development
- ✅ Window Functions & CTEs
- ✅ Business Intelligence & Analytics
- ✅ Performance Optimization
- ✅ Data Modeling
- ✅ E-Commerce Domain Knowledge

---

**⭐ If you find this project useful, please consider giving it a star!**

*Last Updated: January 2026*
