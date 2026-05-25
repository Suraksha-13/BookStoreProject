const express = require("express");
const router = express.Router();
const auth = require("../controllers/authController");


console.log("Auth Controller loaded:", auth);

router.post("/login", auth.login);
router.post("/signup", auth.signup);

module.exports = router;