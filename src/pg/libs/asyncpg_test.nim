import os, strutils, strformat, asyncdispatch, json
import ../../pkg/asyncpg/asyncpg
import ../../base

const
  HOST = getEnv("DB_CONNECTION").string.split(":")[0]
  PORT = getEnv("DB_CONNECTION").string.split(":")[1]
  DBNAME = getEnv("DB_DATABASE").string
  USER = getEnv("DB_USER").string
  PASSWORD = getEnv("DB_PASSWORD").string

let connStr = &"host={HOST} port={PORT} dbname={DBNAME} user={USER} password={PASSWORD}"

proc getColumns(db_columns:DbColumns):seq[array[3, string]] =
  var columns = newSeq[array[3, string]](db_columns.len)
  for i, row in db_columns:
    columns[i] = [row.name, $row.typ.kind, $row.typ.size]
  return columns

proc toJson(results:openArray[seq[string]], columns:openArray[array[3, string]]):seq[JsonNode] =
  var response_table = newSeq[JsonNode](results.len)
  const DRIVER = "postgres"
  for index, rows in results.pairs:
    var response_row = newJObject()
    for i, row in rows:
      let key = columns[i][0]
      let typ = columns[i][1]
      let size = columns[i][2]

      case DRIVER:
      of "sqlite":
        if row == "":
          response_row[key] = newJNull()
        elif ["INTEGER", "INT", "SMALLINT", "MEDIUMINT", "BIGINT"].contains(typ):
          response_row[key] = newJInt(row.parseInt)
        elif ["NUMERIC", "DECIMAL", "DOUBLE"].contains(typ):
          response_row[key] = newJFloat(row.parseFloat)
        elif ["TINYINT", "BOOLEAN"].contains(typ):
          response_row[key] = newJBool(row.parseBool)
        else:
          response_row[key] = newJString(row)
      of "mysql":
        if row == "":
          response_row[key] = newJNull()
        elif [$dbInt, $dbUInt].contains(typ) and size == "1":
          if row == "0":
            response_row[key] = newJBool(false)
          elif row == "1":
            response_row[key] = newJBool(true)
        elif [$dbInt, $dbUInt].contains(typ):
          response_row[key] = newJInt(row.parseInt)
        elif [$dbDecimal, $dbFloat].contains(typ):
          response_row[key] = newJFloat(row.parseFloat)
        elif [$dbJson].contains(typ):
          response_row[key] = row.parseJson
        else:
          response_row[key] = newJString(row)
      of "postgres":
        if row == "":
          response_row[key] = newJNull()
        elif [$dbInt, $dbUInt].contains(typ):
          response_row[key] = newJInt(row.parseInt)
        elif [$dbDecimal, $dbFloat].contains(typ):
          response_row[key] = newJFloat(row.parseFloat)
        elif [$dbBool].contains(typ):
          if row == "f":
            response_row[key] = newJBool(false)
          elif row == "t":
            response_row[key] = newJBool(true)
        elif [$dbJson].contains(typ):
          response_row[key] = row.parseJson
        else:
          response_row[key] = newJString(row)

    response_table[index] = response_row
  return response_table

proc asyncpgTest*() =
  let db = waitFor connect(connStr)
  for _ in 0..LENGTH:
    var rows = newSeq[seq[string]]()
    let db_rows = waitFor all(exec(db, QUERY))
    var db_columns: DbColumns
    for row in db_rows[0][0].instantRows(db_columns):
      var columns = newSeq[string](row.len)
      for i in 0..row.len()-1:
        columns[i] = row[i]
      rows.add(columns)
    # echo rows
    let columns = getColumns(db_columns)
    discard toJson(rows, columns) # seq[JsonNode]

proc asyncpgPlainTest*() =
  let db = waitFor connect(connStr)
  for _ in 0..LENGTH:
    var rows = newSeq[seq[string]]()
    let db_rows = waitFor all(exec(db, QUERY))
    var db_columns: DbColumns
    for row in db_rows[0][0].instantRows(db_columns):
      var columns = newSeq[string](row.len)
      for i in 0..row.len()-1:
        columns[i] = row[i]
      rows.add(columns)
    discard rows