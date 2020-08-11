import times

template bench*(msg, body) =
  block:
    echo "=== " & msg
    let start = cpuTime()
    body
    let time = cpuTime() - start
    echo time

const LENGTH* = 10
const QUERY* = "SELECT * FROM world"
