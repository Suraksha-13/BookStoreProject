const Shop = require("../models/productModel");
const db = require("../Config/db");

exports.getProducts = (req, res) => {
    Shop.getAllProducts((err, products) => {
        if (err) return res.status(500).json({ success: false, message: "Database error fetching products" });
        res.status(200).json({ success: true, products });
    });
};

exports.getCart = (req, res) => {
    const { userId } = req.body;
    if (!userId) return res.status(400).json({ success: false, message: "User ID context is required" });

    Shop.getCartByUserId(userId, (err, items) => {
        if (err) return res.status(500).json({ success: false, message: "Database error fetching cart records" });
        res.status(200).json({ success: true, cart: items });
    });
};

exports.addToCart = (req, res) => {
    const { userId, product_id } = req.body;
    if (!userId || !product_id) return res.status(400).json({ success: false, message: "Missing params" });

    db.query('SELECT id FROM carts WHERE user_id = ?', [userId], (cartErr, cartResult) => {
        if (cartErr) return res.status(500).json({ success: false, message: "Cart workspace lookup error" });

        const processItem = (cartId) => {
            db.query('SELECT id, quantity FROM cart_items WHERE cart_id = ? AND product_id = ?', [cartId, product_id], (itemErr, itemResult) => {
                if (itemErr) return res.status(500).json({ success: false, message: "Item check error" });

                if (itemResult.length > 0) {
                    db.query('UPDATE cart_items SET quantity = quantity + 1 WHERE id = ?', [itemResult[0].id], (uErr) => {
                        if (uErr) return res.status(500).json({ success: false, message: "Update failed" });
                        res.status(200).json({ success: true, message: "Quantity incremented" });
                    });
                } else {
                    db.query('INSERT INTO cart_items (cart_id, product_id, quantity) VALUES (?, ?, 1)', [cartId, product_id], (iErr) => {
                        if (iErr) return res.status(500).json({ success: false, message: "Insertion failed" });
                        res.status(200).json({ success: true, message: "Added fresh product row" });
                    });
                }
            });
        };

        if (cartResult.length === 0) {
            db.query('INSERT INTO carts (user_id) VALUES (?)', [userId], (cErr, cResult) => {
                if (cErr) return res.status(500).json({ success: false, message: "Cart allocation error" });
                processItem(cResult.insertId);
            });
        } else {
            processItem(cartResult[0].id);
        }
    });
};

exports.removeFromCart = (req, res) => {
    const { userId, product_id } = req.body;
    if (!userId || !product_id) return res.status(400).json({ success: false, message: "Missing details" });

    db.query('SELECT id FROM carts WHERE user_id = ?', [userId], (err, result) => {
        if (err || result.length === 0) return res.status(404).json({ success: false, message: "Cart empty" });
        const cartId = result[0].id;

        db.query('SELECT id, quantity FROM cart_items WHERE cart_id = ? AND product_id = ?', [cartId, product_id], (iErr, iResult) => {
            if (iErr || iResult.length === 0) return res.status(404).json({ success: false, message: "Target missing" });

            if (iResult[0].quantity > 1) {
                db.query('UPDATE cart_items SET quantity = quantity - 1 WHERE id = ?', [iResult[0].id], (e) => {
                    if (e) return res.status(500).json({ success: false });
                    res.status(200).json({ success: true });
                });
            } else {
                db.query('DELETE FROM cart_items WHERE id = ?', [iResult[0].id], (e) => {
                    if (e) return res.status(500).json({ success: false });
                    res.status(200).json({ success: true });
                });
            }
        });
    });
};

exports.clearCart = (req, res) => {
    const { userId } = req.body;
    db.query('SELECT id FROM carts WHERE user_id = ?', [userId], (err, result) => {
        if (err || result.length === 0) return res.status(200).json({ success: true });
        db.query('DELETE FROM cart_items WHERE cart_id = ?', [result[0].id], (dErr) => {
            if (dErr) return res.status(500).json({ success: false });
            res.status(200).json({ success: true, message: "Purged cart completely" });
        });
    });
};