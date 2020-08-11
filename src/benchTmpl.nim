import times

template bench*(msg, body) =
  block:
    echo "=== " & msg
    let start = cpuTime()
    body
    echo cpuTime() - start

const LENGTH* = 10
