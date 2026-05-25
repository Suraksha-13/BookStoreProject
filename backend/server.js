const app = require('./app');
require("dotenv").config();

const PORT = process.env.PORT;

app.listen(PORT, '0.0.0.0', () => {

  console.log(`Server running on http://localhost:${PORT}`);
  console.log(`Emulator access: http://10.0.2.2:${PORT}/api`);
});