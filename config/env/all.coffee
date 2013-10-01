path = require("path")
rootPath = path.normalize(__dirname + "/../..")
module.exports =
  root: rootPath
  port: process.env.PORT or 80
  db: process.env.MONGOHQ_URL
