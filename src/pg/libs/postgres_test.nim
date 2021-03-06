import os, asyncdispatch, strutils, net
import ../../pkg/postgres/src/postgres
import ../../base

const
  HOST = getEnv("DB_CONNECTION").string.split(":")[0]
  PORT = Port(getEnv("DB_CONNECTION").string.split(":")[1].parseInt)
  DBNAME = getEnv("DB_DATABASE").string
  USER = getEnv("DB_USER").string
  PASSWORD = getEnv("DB_PASSWORD").string

proc postgresTest*() =
  let db = waitFor openAsync(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
  let reader = waitFor db.query(QUERY)
  defer: waitFor reader.close()
  while waitFor reader.read():
    discard reader[0].repr
