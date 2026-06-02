const express = require("express");
const router = express.Router();
const orderController = require("../controllers/orderController");

router.post("/place", orderController.placeOrder);
router.post("/my-orders", orderController.getUserOrders);
router.post("/update-status", orderController.updateStatus);

// NEW: Endpoint for Admin View
router.get("/admin-all", orderController.getAllAdminOrders);

module.exports = router;