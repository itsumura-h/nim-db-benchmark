import allographer/query_builder
import ../../benchTmpl

proc allographer*() =
  let db = db()
  defer:db.close()
  for _ in 0..LENGTH:
    discard RDB(db:db).table("world").get()

proc allographerPlain*() =
  let db = db()
  defer:db.close()
  for _ in 0..LENGTH:
    discard RDB(db:db).table("world").getPlain()
