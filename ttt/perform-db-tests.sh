#!/bin/sh

. ./test-db-config.sh
. ./test-db-funcs.sh


FIND=/usr/bin/find
PERL=/usr/bin/perl

echo "Creating test environment for LittleORM"

admin_dbcommand "CREATE USER ${TESTDBUSER}"
assert $?

admin_dbcommand "ALTER USER ${TESTDBUSER} WITH PASSWORD '${TESTDBPASS}'"
assert $?


admin_dbcommand "CREATE DATABASE ${TESTDBNAME} OWNER=${TESTDBUSER}"
assert $?

# db created, fill it

user_dbcommand "\i ./test-db-fill.sql"
assert $?

# db created and filled

cd scripts/run/
assert $?

for ORM_TEST_SCRIPT in $( $FIND . -type f -name '*.pl' ) ; do

echo ${ORM_TEST_SCRIPT}
$PERL ${ORM_TEST_SCRIPT}

done

# outta here

admin_dbcommand "DROP DATABASE ${TESTDBNAME}"
assert $?

admin_dbcommand "DROP USER ${TESTDBUSER}"
assert $?

echo "Normal exit"
