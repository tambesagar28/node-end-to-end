const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => res.send('Hello from Node API!'));

app.listen(port, () => {
  console.log(`Node API listening on ${port}`);
});
