
console.log 'ok'

fs = require 'fs'
parse = require 'csv-parse'
stringify = require 'csv-stringify'

source = fs.createReadStream './resources/users.txt'
parser = parse
  delimiter: ','
stringifier = stringify
  delimiter: ';'

source
.pipe(parser)
.pipe(stringifier)
.pipe(process.stdout)


