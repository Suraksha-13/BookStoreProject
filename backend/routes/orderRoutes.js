const express = require('express');
const router = express.Router();
const orders = require('../controllers/orderController');

router.post("/my-orders", orders.getUserOrders);
router.post("/place", orders.placeOrder);
router.post("/update-status", orders.updateStatus);

module.exports = router;