
# Node.js WebApp

## Functionnalities

*   signin form: accept username/email
*   signup form: username, email, password, re-password, firstname, lastname, server+client? validation
*   import/export csv + json

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












[minimist]: https://github.com/substack/minimist
[parameters]: https://github.com/wdavidw/node-parameters

