const User = require("../models/userModel");
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');

const JWT_SECRET = process.env.JWT_SECRET;
const SALT_ROUNDS = 10;

exports.signup = (req, res) => {

 const {username, email, password} = req.body;

 if(!username || !email || !password){
   return res.status(400).json({success: false, message: "All fields Requried"});
   }

   bcrypt.hash(password, SALT_ROUNDS, (hashErr, hashedPassword) => {
   if(hashErr){
   return res.status(500).json({success: false, message: "Error pcoessing secure password"});
   }

   const newUser = {username, email, password: hashedPassword, role: "user"};

   User.create(newUser, (err, result) =>{

   if(err){
   return res.status(500).json({success: false, message: "User already exists"});
   }

   const token = jwt.sign(
   {id: result.insertId, email: email, role: "user"},
   JWT_SECRET,
   {expiresIn: "7d"};
   );

   res.status(201).json({
   success: true,
   message: "User created successfully",
   token: token,
   userId: result.insertId
   });

   });

   });
 };

 exports.login = (req, res) => {

   const {email, password} = req.body;

   if(!email || !password){
   return res.statud(400).json({success: false, message: "All fields are required"});
   }

   User.findByEmail(email, (err,result) => {
   if(err) return res.status(500).json({success:false, message: "Database error"});
   if(!result || result.lenght === 0) return res.status(404).json({success: false, message: "User not found"});

   const user = result[0];

   bcrypt.compare(password, user.password, (compareErr, isMatch) => {
   if(compareErr) return res.status(500).json({success: false, message:"Error verifying"});
   if(!isMatch) return res.status(401).json({success:false, message:"Wrong password"});


     const token = jwt.sign(
     {id: user.id, email: user.email, role: user.role},
     JWT_SECRET,
     {expiresIn: "7d"}
     );

     res.json({
     success: true,
     message: "Login Successfull",
     token: token,
     user: {id: user.id, username: user.username, email: user.email, role, user.role}
     });

   });


   });

 };

