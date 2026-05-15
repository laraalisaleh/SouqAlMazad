


-- 

USE souqalmazad;
-- =========================================================
-- 1) LOGIN SCREEN
-- Purpose: Find user by email during login
-- =========================================================
SELECT *
FROM `user`
WHERE email = 'khaled@email.com';

-- Purpose: Get buyer subtype after login
SELECT buyer_id
FROM buyer
WHERE user_id = 1;

-- Purpose: Get seller subtype after login
SELECT seller_id
FROM seller
WHERE user_id = 1;

-- Purpose: Get admin subtype after login
SELECT admin_id
FROM `admin`
WHERE user_id = 1;


-- =========================================================
-- 2) REGISTER SCREEN
-- Purpose: Insert a new user
-- =========================================================
INSERT INTO `user`
(first_name, last_name, email, password_hash, phone, user_type, is_active)
VALUES
('Test', 'Buyer', 'testbuyer@email.com', 'hash123', '0599000000', 'buyer', TRUE);

-- Purpose: Create buyer subtype for the new user
INSERT INTO buyer (user_id, loyalty_points)
VALUES (LAST_INSERT_ID(), 0);

-- Purpose: Insert a new seller
INSERT INTO `user`
(first_name, last_name, email, password_hash, phone, user_type, is_active)
VALUES
('Test', 'Seller', 'testseller@email.com', 'hash123', '0599111111', 'seller', TRUE);

-- Purpose: Create seller subtype for the new seller
INSERT INTO seller (user_id, business_name, is_verified)
VALUES (LAST_INSERT_ID(), 'Test Store Owner', TRUE);


-- =========================================================
-- 3) ADMIN DASHBOARD
-- Purpose: Count all users
-- =========================================================
SELECT COUNT(*) AS users
FROM `user`;

-- Purpose: Count active products
SELECT COUNT(*) AS products
FROM product
WHERE is_active = TRUE;

-- Purpose: Count all orders
SELECT COUNT(*) AS orders
FROM `order`;

-- Purpose: Count active auctions
SELECT COUNT(*) AS active_auctions
FROM auction
WHERE status = 'active';

-- Purpose: Calculate total revenue from valid orders
SELECT COALESCE(SUM(final_amount), 0) AS revenue
FROM `order`
WHERE status IN ('confirmed', 'processing', 'shipped', 'delivered');


-- =========================================================
-- 4) ADMIN USERS SCREEN
-- Purpose: Show all users with their roles
-- =========================================================
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone,
    u.user_type,
    u.is_active
FROM `user` u
ORDER BY u.user_id DESC;

-- Purpose: Delete or deactivate user safely
UPDATE `user`
SET is_active = FALSE
WHERE user_id = 1;


-- =========================================================
-- 5) STORES SCREEN
-- Purpose: Show all stores with seller names
-- =========================================================
SELECT
    st.store_id,
    st.store_name,
    st.store_description,
    st.rating_avg,
    st.is_active,
    u.first_name,
    u.last_name
FROM store st
JOIN seller s ON st.seller_id = s.seller_id
JOIN `user` u ON s.user_id = u.user_id
ORDER BY st.store_id DESC;

-- Purpose: Add store for seller
INSERT INTO store
(seller_id, store_name, store_description, is_active)
VALUES
(1, 'Lara Tech Store', 'Electronics and smart devices', TRUE);


-- =========================================================
-- 6) CATEGORIES SCREEN
-- Purpose: Show all categories
-- =========================================================
SELECT *
FROM category
ORDER BY category_id;

-- Purpose: Add new category
INSERT INTO category
(category_name, description)
VALUES
('Electronics', 'Phones, laptops, and smart devices');


-- =========================================================
-- 7) PRODUCTS SCREEN / BUYER BROWSE PRODUCTS
-- Purpose: Show all active products with store and category
-- =========================================================
SELECT
    p.product_id,
    p.title,
    p.description,
    p.price,
    p.stock_quantity,
    p.sale_type,
    p.item_condition,
    p.is_active,
    st.store_name,
    c.category_name AS category
FROM product p
JOIN store st ON p.store_id = st.store_id
JOIN category c ON p.category_id = c.category_id
WHERE p.is_active = TRUE
ORDER BY p.product_id DESC;

-- Purpose: Add direct product
INSERT INTO product
(store_id, category_id, title, description, price, stock_quantity, sale_type, item_condition, is_active)
VALUES
(1, 1, 'iPhone 15 Pro', 'Apple phone', 850, 5, 'direct', 'new', TRUE);

-- Purpose: Update product
UPDATE product
SET
    title = 'Updated Product',
    description = 'Updated description',
    price = 900,
    stock_quantity = 8,
    sale_type = 'both',
    item_condition = 'new'
WHERE product_id = 1;

-- Purpose: Soft delete product
UPDATE product
SET is_active = FALSE
WHERE product_id = 1;


-- =========================================================
-- 8) PRODUCT IMAGES
-- Purpose: Show product images
-- =========================================================
SELECT
    pi.image_id,
    pi.product_id,
    p.title,
    pi.image_url,
    pi.is_primary
FROM product_image pi
JOIN product p ON pi.product_id = p.product_id;

-- Purpose: Add image path for product
INSERT INTO product_image
(product_id, image_url, is_primary)
VALUES
(1, 'product_images/1.png', TRUE);


-- =========================================================
-- 9) SELLER ADD PRODUCT + AUCTION
-- Purpose: Add auction/both product
-- =========================================================
INSERT INTO product
(store_id, category_id, title, description, price, stock_quantity, sale_type, item_condition, is_active)
VALUES
(1, 1, 'MacBook Air M3', 'Auction product', 1000, 1, 'auction', 'new', TRUE);

-- Purpose: Create auction for the product
INSERT INTO auction
(product_id, starting_price, reserve_price, current_highest, start_time, end_time, status)
VALUES
(LAST_INSERT_ID(), 700, 900, 0, '2026-05-10 22:39:00', '2026-05-10 22:41:00', 'active');


-- =========================================================
-- 10) AUCTIONS SCREEN
-- Purpose: Show all auctions with product, store, and winner
-- =========================================================
SELECT
    a.auction_id,
    a.product_id,
    p.title AS product_title,
    st.store_name,
    a.starting_price,
    a.reserve_price,
    a.current_highest,
    a.start_time,
    a.end_time,
    a.status,
    a.winner_buyer_id,
    CONCAT(wu.first_name, ' ', wu.last_name) AS winner_name,
    COUNT(b.bid_id) AS bid_count
FROM auction a
JOIN product p ON a.product_id = p.product_id
JOIN store st ON p.store_id = st.store_id
LEFT JOIN buyer wb ON a.winner_buyer_id = wb.buyer_id
LEFT JOIN `user` wu ON wb.user_id = wu.user_id
LEFT JOIN bid b ON a.auction_id = b.auction_id
GROUP BY
    a.auction_id,
    a.product_id,
    p.title,
    st.store_name,
    a.starting_price,
    a.reserve_price,
    a.current_highest,
    a.start_time,
    a.end_time,
    a.status,
    a.winner_buyer_id,
    wu.first_name,
    wu.last_name
ORDER BY
    CASE a.status
        WHEN 'active' THEN 1
        WHEN 'upcoming' THEN 2
        WHEN 'ended' THEN 3
        ELSE 4
    END,
    a.end_time ASC;

-- Purpose: Convert upcoming auctions to active
UPDATE auction
SET status = 'active'
WHERE status = 'upcoming'
  AND start_time <= NOW()
  AND end_time > NOW();

-- Purpose: Convert expired auctions to ended
UPDATE auction
SET status = 'ended'
WHERE status IN ('upcoming', 'active')
  AND end_time <= NOW();


-- =========================================================
-- 11) PLACE BID
-- Purpose: Insert a new bid
-- =========================================================
INSERT INTO bid
(auction_id, buyer_id, bid_amount, is_winning)
VALUES
(1, 1, 950, TRUE);

-- Purpose: Mark old bids as not winning
UPDATE bid
SET is_winning = FALSE
WHERE auction_id = 1;

-- Purpose: Update auction highest bid and temporary winner
UPDATE auction
SET current_highest = 950,
    winner_buyer_id = 1
WHERE auction_id = 1;


-- =========================================================
-- 12) AUCTION WINNER DETECTION
-- Purpose: Get highest bidder for ended auction
-- =========================================================
SELECT
    b.bid_id,
    b.auction_id,
    b.buyer_id,
    b.bid_amount,
    u.first_name,
    u.last_name
FROM bid b
JOIN buyer byy ON b.buyer_id = byy.buyer_id
JOIN `user` u ON byy.user_id = u.user_id
WHERE b.auction_id = 1
ORDER BY b.bid_amount DESC, b.bid_time ASC
LIMIT 1;

-- Purpose: Save winner in auction
UPDATE auction
SET winner_buyer_id = 1
WHERE auction_id = 1;


-- =========================================================
-- 13) CREATE AUCTION ORDER FOR WINNER
-- Purpose: Create order after auction ends
-- =========================================================
INSERT INTO `order`
(buyer_id, order_type, shipping_address, total_amount, discount_amount, final_amount, status)
VALUES
(1, 'auction', 'To be confirmed by winner', 950, 0, 950, 'pending');

-- Purpose: Add auction product to order items
INSERT INTO order_item
(order_id, product_id, store_id, quantity, unit_price, subtotal)
VALUES
(LAST_INSERT_ID(), 1, 1, 1, 950, 950);

-- Purpose: Create payment for auction order
INSERT INTO payment
(order_id, amount, payment_method, status)
VALUES
(LAST_INSERT_ID(), 950, 'cash_on_delivery', 'pending');

-- Purpose: Create shipment for auction order
INSERT INTO shipment
(order_id, status)
VALUES
(LAST_INSERT_ID(), 'preparing');


-- =========================================================
-- 14) BUYER DIRECT ORDER
-- Purpose: Create direct order
-- =========================================================
INSERT INTO `order`
(buyer_id, order_type, shipping_address, total_amount, discount_amount, final_amount, status)
VALUES
(1, 'direct', 'Nablus, Palestine', 850, 0, 850, 'pending');

-- Purpose: Add direct product to order
INSERT INTO order_item
(order_id, product_id, store_id, quantity, unit_price, subtotal)
VALUES
(LAST_INSERT_ID(), 1, 1, 1, 850, 850);

-- Purpose: Create payment
INSERT INTO payment
(order_id, amount, payment_method, status)
VALUES
(LAST_INSERT_ID(), 850, 'cash_on_delivery', 'pending');

-- Purpose: Create shipment
INSERT INTO shipment
(order_id, status)
VALUES
(LAST_INSERT_ID(), 'preparing');

-- Purpose: Decrease stock after purchase
UPDATE product
SET stock_quantity = stock_quantity - 1
WHERE product_id = 1
  AND stock_quantity > 0;


-- =========================================================
-- 15) BUYER ORDERS SCREEN
-- Purpose: Show buyer orders with payment and shipment
-- =========================================================
SELECT
    o.order_id,
    o.order_type,
    o.total_amount,
    o.final_amount,
    o.status AS order_status,
    p.status AS payment_status,
    sh.status AS shipment_status,
    o.created_at
FROM `order` o
LEFT JOIN payment p ON o.order_id = p.order_id
LEFT JOIN shipment sh ON o.order_id = sh.order_id
WHERE o.buyer_id = 1
ORDER BY o.order_id DESC;


-- =========================================================
-- 16) SELLER ORDERS SCREEN
-- Purpose: Show orders that contain seller products
-- =========================================================
SELECT DISTINCT
    o.order_id,
    u.first_name,
    u.last_name,
    st.store_name,
    o.final_amount,
    o.status,
    o.created_at
FROM `order` o
JOIN buyer b ON o.buyer_id = b.buyer_id
JOIN `user` u ON b.user_id = u.user_id
JOIN order_item oi ON o.order_id = oi.order_id
JOIN store st ON oi.store_id = st.store_id
WHERE st.seller_id = 1
ORDER BY o.order_id DESC;


-- =========================================================
-- 17) ADMIN ORDERS SCREEN
-- Purpose: Show all orders with order/payment/shipment statuses
-- =========================================================
SELECT
    o.order_id,
    CONCAT(u.first_name, ' ', u.last_name) AS buyer_name,
    o.order_type,
    o.total_amount,
    o.final_amount,
    o.status AS order_status,
    p.status AS payment_status,
    sh.status AS shipment_status,
    o.created_at
FROM `order` o
JOIN buyer b ON o.buyer_id = b.buyer_id
JOIN `user` u ON b.user_id = u.user_id
LEFT JOIN payment p ON o.order_id = p.order_id
LEFT JOIN shipment sh ON o.order_id = sh.order_id
ORDER BY o.order_id DESC;

-- Purpose: Update order status
UPDATE `order`
SET status = 'confirmed'
WHERE order_id = 1;

-- Purpose: Update payment status
UPDATE payment
SET status = 'completed'
WHERE order_id = 1;

-- Purpose: Update shipment status
UPDATE shipment
SET status = 'shipped'
WHERE order_id = 1;


-- =========================================================
-- 18) WISHLIST SCREEN
-- Purpose: Add product to buyer wishlist
-- =========================================================
INSERT INTO wishlist
(buyer_id, product_id)
VALUES
(1, 1);

-- Purpose: Show buyer wishlist
SELECT
    w.wishlist_id,
    w.buyer_id,
    w.product_id,
    p.title AS product_title,
    p.price,
    p.stock_quantity,
    p.sale_type,
    w.added_at
FROM wishlist w
JOIN product p ON w.product_id = p.product_id
WHERE w.buyer_id = 1
ORDER BY w.added_at DESC;

-- Purpose: Remove wishlist item
DELETE FROM wishlist
WHERE wishlist_id = 1;


-- =========================================================
-- 19) REVIEWS SCREEN
-- Purpose: Add product review
-- =========================================================
INSERT INTO review
(buyer_id, product_id, rating, comment)
VALUES
(1, 1, 5, 'Excellent product');

-- Purpose: Show product reviews
SELECT
    r.review_id,
    r.product_id,
    p.title,
    CONCAT(u.first_name, ' ', u.last_name) AS buyer_name,
    r.rating,
    r.comment,
    r.created_at
FROM review r
JOIN product p ON r.product_id = p.product_id
JOIN buyer b ON r.buyer_id = b.buyer_id
JOIN `user` u ON b.user_id = u.user_id
ORDER BY r.created_at DESC;


-- =========================================================
-- 20) NOTIFICATIONS SCREEN
-- Purpose: Add notification
-- =========================================================
INSERT INTO notification
(user_id, type, title, content, is_read)
VALUES
(1, 'order_update', 'Order Updated', 'Your order status has changed.', FALSE);

-- Purpose: Show notifications for user
SELECT
    notification_id,
    user_id,
    type,
    title,
    content,
    is_read,
    created_at
FROM notification
WHERE user_id = 1
ORDER BY created_at DESC;

-- Purpose: Mark selected notification as read
UPDATE notification
SET is_read = TRUE
WHERE notification_id = 1;

-- Purpose: Mark selected notification as unread
UPDATE notification
SET is_read = FALSE
WHERE notification_id = 1;

-- Purpose: Mark all notifications as read
UPDATE notification
SET is_read = TRUE
WHERE user_id = 1;

-- Purpose: Mark all notifications as unread
UPDATE notification
SET is_read = FALSE
WHERE user_id = 1;

-- Purpose: Delete selected notification
DELETE FROM notification
WHERE notification_id = 1;


-- =========================================================
-- 21) AUCTION NOTIFICATIONS
-- Purpose: Notify auction winner
-- =========================================================
INSERT INTO notification
(user_id, type, title, content)
VALUES
(1, 'auction_won', 'You won an auction!', 'Congratulations! You won iPhone 15 Pro.');

-- Purpose: Notify seller that auction ended
INSERT INTO notification
(user_id, type, title, content)
VALUES
(2, 'auction_won', 'Auction ended', 'Sara won your product with the highest bid.');

-- Purpose: Notify losing bidder
INSERT INTO notification
(user_id, type, title, content)
VALUES
(3, 'system', 'Auction ended', 'Another buyer won this auction.');


-- =========================================================
-- 22) REPORTS SCREEN
-- Purpose: Add report
-- =========================================================
INSERT INTO report
(reporter_user_id, reported_type, reported_id, reason, status)
VALUES
(1, 'product', 1, 'Fake product information', 'pending');

-- Purpose: Show all reports
SELECT
    r.report_id,
    CONCAT(u.first_name, ' ', u.last_name) AS reporter_name,
    r.reported_type,
    r.reported_id,
    r.reason,
    r.status,
    r.created_at
FROM report r
JOIN `user` u ON r.reporter_user_id = u.user_id
ORDER BY r.created_at DESC;

-- Purpose: Update report status
UPDATE report
SET status = 'resolved'
WHERE report_id = 1;


-- =========================================================
-- 23) DATA INTEGRITY CHECKS
-- Purpose: Find users without subtype
-- =========================================================
SELECT u.*
FROM `user` u
LEFT JOIN buyer b ON u.user_id = b.user_id AND u.user_type = 'buyer'
LEFT JOIN seller s ON u.user_id = s.user_id AND u.user_type = 'seller'
LEFT JOIN `admin` a ON u.user_id = a.user_id AND u.user_type = 'admin'
WHERE
    (u.user_type = 'buyer' AND b.buyer_id IS NULL)
 OR (u.user_type = 'seller' AND s.seller_id IS NULL)
 OR (u.user_type = 'admin' AND a.admin_id IS NULL);

-- Purpose: Find auction products without auction record
SELECT p.*
FROM product p
LEFT JOIN auction a ON p.product_id = a.product_id
WHERE p.sale_type IN ('auction', 'both')
  AND a.auction_id IS NULL;

-- Purpose: Find orders without payment
SELECT o.*
FROM `order` o
LEFT JOIN payment p ON o.order_id = p.order_id
WHERE p.payment_id IS NULL;

-- Purpose: Find orders without shipment
SELECT o.*
FROM `order` o
LEFT JOIN shipment s ON o.order_id = s.order_id
WHERE s.shipment_id IS NULL;

-- Purpose: Find negative stock problems
SELECT *
FROM product
WHERE stock_quantity < 0;




