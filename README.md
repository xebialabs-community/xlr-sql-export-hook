
This export hook exports release data into sql database. It also exports phases, tasks, teams, permissions and team members of the release.

Tested with MySQL 5.6

# Prerequisites

1. Install MySQL 5
2. Create new database which name will be used in JDBC URL
3. Download [the latest version of MySQL connector/J](http://dev.mysql.com/downloads/connector/j/) and put into `<XLRELEASE_SERVER_HOME>/plugins`.

## Setup

1. Set up database schema with `mysql -u<user> -p<password> -D <database> < ./tables.sql`
2. clone repository and launch gradle build that assebles the jar: `./gradlew clean build`
3. copy newly build jar file: `cp ./build/libs/xlr-sql-export-hook-1.0.0.jar <XLRELEASE_SERVER_HOME>/plugins`
4. restart XL Release server
5. in XL Release go to `Setting -> Configuration -> Add Sql export hook`. Fill in your username, password, JDBC url(should be in the `jdbc:mysql://<host>/<database>` format) and Jdbc driver(for MySQL it's `com.mysql.jdbc.Driver`) save it.
6. Check that archiving is enabled.
