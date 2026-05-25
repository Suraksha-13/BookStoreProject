const express = require('express');
const router = express.Router();
const shop = require('../controllers/shopController');

router.get("/products", shop.getProducts);
router.post("/cart", shop.getCart);
router.post("/cart/add", shop.addToCart);
router.post("/cart/remove", shop.removeFromCart);
router.post("/cart/clear", shop.clearCart);

module.exports = router;