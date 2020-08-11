import os, strutils
import pdba
import ../../../benchTmpl

const
  HOST = getEnv("DB_CONNECTION").string.split(":")[0]
  PORT = getEnv("DB_CONNECTION").string.split(":")[1]
  DBNAME = getEnv("DB_DATABASE").string
  USER = getEnv("DB_USER").string
  PASSWORD = getEnv("DB_PASSWORD").string

var db = initQDB(host=HOST, port=PORT, dbname=DBNAME, user=USER, pass=PASSWORD)
db.loadDBYaml("./pg/libs/pdba/schema.yaml")

proc pdba*() =
  let conn = db.connect()
  let world = db.tbl["world"]
  for _ in 0..LENGTH:
    var rows = conn.getAllRows world.query
    for row in rows:
      discard row.fields