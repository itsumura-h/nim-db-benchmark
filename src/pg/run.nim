import ../base
import libs/std as std_pg
import libs/allographer as allographer_pg
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

bench("pg asyncpg plain"):
  asyncpgPlainTest()

# impossible to run
# bench("pg postgres"):
#   postgresTest()

# Too slow
# bench("pg pdba"):
#   pdba()
