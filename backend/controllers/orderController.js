const Order = require("../models/orderModel");
const db = require("../Config/db");

exports.placeOrder = (req, res) => {
    const { userId, items, total_price } = req.body;
    if (!userId || !items || items.length === 0 || !total_price) {
        return res.status(400).json({ success: false, message: "Missing order fields" });
    }

    Order.createOrder(userId, total_price, (err, result) => {
        if (err) return res.status(500).json({ success: false, message: "Order creation database failure" });
        const orderId = result.insertId;
        let completed = 0;
        let failureFlag = false;

        items.forEach((item) => {
            if (failureFlag) return;
            Order.insertOrderItem(orderId, item.id, item.price, item.quantity || 1, (iErr) => {
                if (iErr && !failureFlag) {
                    failureFlag = true;
                    return res.status(500).json({ success: false, message: "Item insertion failed" });
                }
                completed++;
                if (completed === items.length && !failureFlag) {
                    db.query("SELECT id FROM carts WHERE user_id = ?", [userId], (cErr, cRes) => {
                        if (cErr || cRes.length === 0) return res.status(201).json({ success: true, orderId });
                        db.query("DELETE FROM cart_items WHERE cart_id = ?", [cRes[0].id], () => {
                            res.status(201).json({ success: true, message: "Order placed, cart cleared", orderId });
                        });
                    });
                }
            });
        });
    });
};

exports.getUserOrders = (req, res) => {
    const { userId } = req.body;
    if (!userId) return res.status(400).json({ success: false, message: "User ID required" });

    Order.getUserOrders(userId, (err, orders) => {
        if (err) return res.status(500).json({ success: false });
        if (orders.length === 0) return res.status(200).json({ success: true, orders: [] });

        const packedOrders = [];
        let completed = 0;

        orders.forEach((order) => {
            Order.getItemsByOrderId(order.id, (iErr, items) => {
                if (iErr) return res.status(500).json({ success: false });
                packedOrders.push({
                    id: order.id,
                    status: order.status,
                    total_price: order.total_price,
                    created_at: order.created_at,
                    items
                });
                completed++;
                if (completed === orders.length) {
                    packedOrders.sort((a, b) => b.created_at - a.created_at);
                    res.status(200).json({ success: true, orders: packedOrders });
                }
            });
        });
    });
};

exports.updateStatus = (req, res) => {
    const { orderId, status } = req.body;
    Order.updateStatus(orderId, status, (err) => {
        if (err) return res.status(500).json({ success: false });
        res.status(200).json({ success: true, orderId, status });
    });
};