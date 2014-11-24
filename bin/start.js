
require('coffee-script/register')

var app = require('../lib/app');
app.listen(1337);

console.log('Server running at http://127.0.0.1:1337/');
