-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

-- Insert customers
INSERT INTO customers (first_name, last_name, email, phone, registration_date, city, state, country) VALUES
('John', 'Smith', 'john.smith@email.com', '555-0101', '2023-01-15', 'New York', 'NY', 'USA'),
('Emma', 'Johnson', 'emma.j@email.com', '555-0102', '2023-02-20', 'Los Angeles', 'CA', 'USA'),
('Michael', 'Brown', 'michael.b@email.com', '555-0103', '2023-03-10', 'Chicago', 'IL', 'USA'),
('Sarah', 'Davis', 'sarah.d@email.com', '555-0104', '2023-04-05', 'Houston', 'TX', 'USA'),
('David', 'Wilson', 'david.w@email.com', '555-0105', '2023-05-12', 'Phoenix', 'AZ', 'USA'),
('Lisa', 'Martinez', 'lisa.m@email.com', '555-0106', '2023-06-18', 'Philadelphia', 'PA', 'USA'),
('James', 'Anderson', 'james.a@email.com', '555-0107', '2023-07-22', 'San Antonio', 'TX', 'USA'),
('Emily', 'Taylor', 'emily.t@email.com', '555-0108', '2023-08-30', 'San Diego', 'CA', 'USA');

-- Insert categories
INSERT INTO categories (category_name, parent_category_id) VALUES
('Electronics', NULL),
('Clothing', NULL),
('Home & Garden', NULL),
('Laptops', 1),
('Smartphones', 1),
('Men''s Clothing', 2),
('Women''s Clothing', 2),
('Furniture', 3);

-- Insert products
INSERT INTO products (product_name, category_id, price, stock_quantity, created_date) VALUES
('MacBook Pro 16"', 4, 2499.99, 50, '2023-01-01'),
('Dell XPS 15', 4, 1899.99, 75, '2023-01-15'),
('iPhone 15 Pro', 5, 999.99, 200, '2023-02-01'),
('Samsung Galaxy S24', 5, 899.99, 150, '2023-02-15'),
('Men''s Leather Jacket', 6, 199.99, 100, '2023-03-01'),
('Women''s Summer Dress', 7, 79.99, 200, '2023-03-15'),
('Ergonomic Office Chair', 8, 299.99, 80, '2023-04-01'),
('Standing Desk', 8, 499.99, 60, '2023-04-15'),
('Wireless Earbuds', 1, 149.99, 300, '2023-05-01'),
('Smart Watch', 1, 399.99, 120, '2023-05-15');

-- Insert orders
INSERT INTO orders (customer_id, order_date, total_amount, status, shipping_address) VALUES
(1, '2024-01-10 10:30:00', 2499.99, 'delivered', '123 Main St, New York, NY'),
(2, '2024-01-15 14:20:00', 1079.98, 'delivered', '456 Oak Ave, Los Angeles, CA'),
(3, '2024-02-01 09:15:00', 999.99, 'delivered', '789 Pine Rd, Chicago, IL'),
(4, '2024-02-10 16:45:00', 1199.98, 'shipped', '321 Elm St, Houston, TX'),
(1, '2024-02-20 11:30:00', 449.98, 'delivered', '123 Main St, New York, NY'),
(5, '2024-03-01 13:20:00', 899.99, 'delivered', '654 Maple Dr, Phoenix, AZ'),
(6, '2024-03-15 15:10:00', 579.98, 'processing', '987 Cedar Ln, Philadelphia, PA'),
(7, '2024-03-20 10:00:00', 299.99, 'pending', '147 Birch St, San Antonio, TX'),
(8, '2024-03-25 12:30:00', 1899.99, 'delivered', '258 Walnut Ave, San Diego, CA'),
(2, '2024-04-01 14:15:00', 699.98, 'delivered', '456 Oak Ave, Los Angeles, CA');

-- Insert order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_percent) VALUES
(1, 1, 1, 2499.99, 0),
(2, 3, 1, 999.99, 0),
(2, 6, 1, 79.99, 0),
(3, 3, 1, 999.99, 0),
(4, 4, 1, 899.99, 10),
(4, 7, 1, 299.99, 0),
(5, 9, 2, 149.99, 10),
(5, 6, 2, 79.99, 0),
(6, 4, 1, 899.99, 0),
(7, 10, 1, 399.99, 5),
(7, 5, 1, 199.99, 10),
(8, 7, 1, 299.99, 0),
(9, 2, 1, 1899.99, 0),
(10, 10, 1, 399.99, 0),
(10, 9, 2, 149.99, 0);

-- Insert reviews
INSERT INTO reviews (product_id, customer_id, rating, review_text, review_date) VALUES
(1, 1, 5, 'Excellent laptop! Fast and reliable.', '2024-01-20 10:00:00'),
(3, 2, 4, 'Great phone but battery could be better.', '2024-01-25 14:30:00'),
(3, 3, 5, 'Best phone I''ve ever owned!', '2024-02-15 09:45:00'),
(4, 5, 4, 'Very good value for money.', '2024-03-10 16:20:00'),
(2, 8, 5, 'Perfect for work and gaming!', '2024-04-05 11:15:00');

-- Insert payments
INSERT INTO payments (order_id, payment_date, payment_method, amount, status) VALUES
(1, '2024-01-10 10:35:00', 'credit_card', 2499.99, 'completed'),
(2, '2024-01-15 14:25:00', 'paypal', 1079.98, 'completed'),
(3, '2024-02-01 09:20:00', 'credit_card', 999.99, 'completed'),
(4, '2024-02-10 16:50:00', 'debit_card', 1199.98, 'completed'),
(5, '2024-02-20 11:35:00', 'credit_card', 449.98, 'completed'),
(6, '2024-03-01 13:25:00', 'credit_card', 899.99, 'completed'),
(7, '2024-03-15 15:15:00', 'paypal', 579.98, 'pending'),
(8, '2024-03-20 10:05:00', 'bank_transfer', 299.99, 'pending'),
(9, '2024-03-25 12:35:00', 'credit_card', 1899.99, 'completed'),
(10, '2024-04-01 14:20:00', 'debit_card', 699.98, 'completed');
