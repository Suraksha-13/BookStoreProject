const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

// --- ROUTES IMPLEMENTATION ---
app.use("/api/auth", require("./routes/authRoutes"));
app.use("/api/shop", require("./routes/shopRoutes"));
app.use("/api/orders", require("./routes/orderRoutes"));

// Catch-All 404 Route Fallback
app.use((req, res) => {
    console.log(`404 error ${req.method} ${req.url}`);
    res.status(404).json({ success: false, message: "Route not found" });
});

module.exports = app;