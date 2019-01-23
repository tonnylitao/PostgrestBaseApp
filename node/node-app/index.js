const app = require("express")();

const server = require("http").Server(app);

const port = 4000;
server.listen(port, () => {
  console.log(`Example app listening on port ${port}!`);
});

app.get("/", (req, res) => res.send("Hello, NodeJS"));

const io = require("socket.io")(server);
io.on("connection", function(socket) {
  console.log("a user connected");
});

module.exports.io = io;

require("./src/db_listener.js");
