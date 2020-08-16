import ../base
import libs/std
import libs/allographer
import libs/asyncmysql_test
# import libs/mysqlparser_test

bench("my std"):
  std()

bench("my allographer"):
  allographer()

bench("my allographer plain"):
  allographerPlain()

bench("my asyncmysql"):
  asyncmysqlTest()

# bench("my mysqlparser"):
#   mysqlparserTest()
