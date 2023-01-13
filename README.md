# utl_interval
UTL_INTERVAL - provides interval functionality that is currently missing from the database as of 19c
*) sum_interval - a standalone aggregate function for summing INTERVAL datatypes
*) typ_interval - a TYPE that implements the sum_interval function
*) pkg_interval - a PACKAGE that provides functionality used in typ_interval. Functions include: to_seconds, divide, add
