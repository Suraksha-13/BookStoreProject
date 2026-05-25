const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();

app.use(cors());
app.use(express.json());

//routes here

app.use("/api/auth", require ("./routes/authRoutes"));


//
app.use((req, res) => {

console.log(`404 error ${req.method} ${req.url}`);
res.status(404).json({success: false, message: "Route not found"});

});

module.exports = app;