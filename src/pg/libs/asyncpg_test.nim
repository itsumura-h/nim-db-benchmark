import os, strutils, strformat, asyncdispatch
import ../../pkg/asyncpg/asyncpg
import ../../base

const
  HOST = getEnv("DB_CONNECTION").string.split(":")[0]
  PORT = getEnv("DB_CONNECTION").string.split(":")[1]
  DBNAME = getEnv("DB_DATABASE").string
  USER = getEnv("DB_USER").string
  PASSWORD = getEnv("DB_PASSWORD").string

let connStr = &"host={HOST} port={PORT} dbname={DBNAME} user={USER} password={PASSWORD}"

proc asyncpgTest*() =
  let db = waitFor connect(connStr)
  defer: db.close()
  for _ in 0..LENGTH:
    let rows = waitFor all(exec(db, "SELECT * FROM world"))
    discard rows[0][0].getAllRows()
