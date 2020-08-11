import ../base
import libs/std
import libs/allographer
import libs/asyncmysql_test

bench("my std"):
  std()

bench("my allographer"):
  allographer()

bench("my allographer plain"):
  allographerPlain()

bench("my asyncmysql"):
  asyncmysqlTest()