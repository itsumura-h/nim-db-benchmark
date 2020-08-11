import ../benchTmpl
import libs/std
import libs/allographer
import libs/asyncpg_test
# import libs/postgres_test
import libs/pdba/pdba_test

bench("pg std"):
  std()

bench("pg allographer"):
  allographer()

bench("pg allographer plain"):
  allographerPlain()

bench("pg asyncpg"):
  asyncpgTest()

# impossible to run
# bench("pg postgres"):
#   postgresTest()

# Too slow
# bench("pdba"):
#   pdba()
