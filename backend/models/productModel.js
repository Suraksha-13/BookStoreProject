const db = require("../Config/db");

const Shop = {
    getAllProducts: (callback) => {
        db.query('SELECT id, title, image_url, price, stock FROM products', callback);
    },
    getCartByUserId: (userId, callback) => {
        db.query(
            `SELECT p.id, p.title, p.image_url, p.price, ci.quantity
             FROM carts c
             JOIN cart_items ci ON c.id = ci.cart_id
             JOIN products p ON ci.product_id = p.id
             WHERE c.user_id = ?`,
            [userId],
            callback
        );
    }
};

module.exports = Shop;