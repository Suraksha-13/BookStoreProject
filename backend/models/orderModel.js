const db = require("../Config/db");

const Order = {
    createOrder: (userId, totalPrice, callback) => {
        db.query("INSERT INTO orders (user_id, status, total_price) VALUES (?, 'pending', ?)", [userId, totalPrice], callback);
    },
    insertOrderItem: (orderId, productId, price, quantity, callback) => {
        db.query("INSERT INTO order_items (order_id, product_id, price_at_purchase, quantity) VALUES (?, ?, ?, ?)", [orderId, productId, price, quantity], callback);
    },
    getUserOrders: (userId, callback) => {
        db.query("SELECT id, status, total_price, created_at FROM orders WHERE user_id = ? ORDER BY created_at DESC", [userId], callback);
    },
    getItemsByOrderId: (orderId, callback) => {
        db.query(
            `SELECT p.id, p.title, COALESCE(p.image_url, '') AS image_url, p.price, oi.quantity
             FROM order_items oi
             LEFT JOIN products p ON oi.product_id = p.id
             WHERE oi.order_id = ?`,
            [orderId],
            callback
        );
    },
    updateStatus: (orderId, status, callback) => {
        db.query("UPDATE orders SET status = ? WHERE id = ?", [status, orderId], callback);
    }
};

module.exports = Order;