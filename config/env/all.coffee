path = require("path")
rootPath = path.normalize(__dirname + "/../..")
module.exports =
  root: rootPath
  port: if process.env.NODE_ENV is 'production' then 80 else 3000
  db: process.env.MONGOHQ_URL
