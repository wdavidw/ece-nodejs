
# Node.js WebApp

## Functionnalities

*   signin form: accept username/email
*   signup form: username, email, password, re-password, firstname, lastname,
    server+client? validation
*   import/export csv + json
*   user log/history visualisation

## Layout

/.git
/.gitignore
/.npmignore
/bin/start
/bin/import
/bin/export
/db/.gitgignore
/lib/app.coffee
/lib/db.coffee, import.coffee, export.coffee
/package.json (name, version, dependencies, ...)
/public
/LICENSE
/README.md
/tests/db.coffee
/tests/app.coffee
/views

## Web

/ GET               return the html webpage
/user GET           JSON object representing the user
                    or null of not logged in
/user/signin POST   send username, password
                    return user ojbect or validation object
/user/signup POST   send user properties
                    return user ojbect or validation object

## Signin/Signup form

Ajax request to communicate with the server, only one url for all the screens.

If user is already loged in, he must arrive on its homepage (not on signin or signup screen).

## LevelDB schema

User namespace
key: "users:#{username}:#{property}:"
properties: "lastname", "firstname", "email" and "password"


## Import/export scripts

Create 2 commands `./bin/import` and `./bin/export`. Each commands take 2 options "--help" and "--format".

For a simple argument parse, you may use [minimist]. For a more complex parser, you may use [parameters].

```
./bin/import --help
import [--help] [--format {name}] input
Introduction message
--help           Print this message
--format {name}  One of csv(default) or json
input            Imported file
```

```
./bin/export --help
export [--help] [--format {name}] output
Introduction message
--help           Print this message
--format {name}  One of csv(default) or json
output           Exported file
```

### Import & Export modules

Import must implement the "stream.Writable" class inside a module './lib/import'. Here's an example on how to use the import module:

```
import = require './lib/import'
db = require './lib/db'
client = db './db'
fs
.createReadStream('./sample.csv')
.pipe import client, format: 'csv'

```

Export must implement the "stream.Readable" class inside a module './lib/export'. Here's an example on how to use the export module:

```
export = require './lib/export'
db = require './lib/db'
client = db './db'
export(client, format: 'csv')
.pipe fs.createReadStream('./sample.csv')
```

### User log/history visualisation

The leveldb database should store all the navigation history of a user. Every time a user
visit a page, a new log entry should be inserted inside the database. The user shall be able to consult his activity inside his protected area on the website.

Extra bonus points if socket-io comes into the dance to publish logs in realtime.







[minimist]: https://github.com/substack/minimist
[parameters]: https://github.com/wdavidw/node-parameters

