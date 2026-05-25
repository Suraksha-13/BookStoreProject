const db = require('../Config/db');

const User = {

    findByEmail: (email, cb) => {

    db.query("Select * From users WHERE email = ?",
    [email],

    (err, result) => {
      if(err) return cb(err);
      cb(null,result);
    }

    );

    },

    create: (data, cb) => {

    db.query("Insert into users (username, email, password, role) values (? ,? ,?, ?)",
    [
    data.username,
    data.email,
    data.password,
    data.role || "user"
    ],
    cb

    );


    }

};


module.exports = User;