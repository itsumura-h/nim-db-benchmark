import asyncdispatch, asyncnet, net, strutils, os
import ../../pkg/asyncmysql/asyncmysql
import ../../base

const
  HOST = getEnv("DB_CONNECTION").string.split(":")[0]
  PORT = Port(getEnv("DB_CONNECTION").string.split(":")[1].parseInt)
  DBNAME = getEnv("DB_DATABASE").string
  USER = getEnv("DB_USER").string
  PASSWORD = getEnv("DB_PASSWORD").string

type Replies = seq[tuple[packet: ResultPacket, rows: seq[string]]]

proc execMyQuery(pool: AsyncMysqlPool, q: SqlQuery): Future[Replies] =
  var retFuture = newFuture[Replies]("execMyQuery")
  result = retFuture

  proc finishCb(err: ref Exception, replies: Replies) {.async.} =
    if err == nil:
      complete(retFuture, replies)
    else:
      fail(retFuture, err)

  execQuery(pool, q, finishCb)

proc asyncmysqlTest*() =
  let db = waitFor openMysqlPool(
    domain=AF_INET,
    port=PORT,
    host=HOST,
    user=USER,
    password=PASSWORD,
    database=DBNAME
  )
  for _ in 0..LENGTH:
    let query = sql(QUERY)
    let rows = waitFor db.execMyQuery(query)
    discard rows[0].rows
