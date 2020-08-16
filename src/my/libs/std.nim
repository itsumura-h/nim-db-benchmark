import os, db_mysql
import ../../base

let db = open(
  getEnv("DB_CONNECTION").string,
  getEnv("DB_USER").string,
  getEnv("DB_PASSWORD").string,
  getEnv("DB_DATABASE").string
)

proc std*() =
  let db = db
  defer: db.close()
  for _ in 0..LENGTH:
    discard db.getAllRows(sql QUERY)
