import allographer/query_builder
import ../../base

proc allographer*() =
  for _ in 0..LENGTH:
    discard rdb().table("world").get()

proc allographerPlain*() =
  for _ in 0..LENGTH:
    discard rdb().table("world").getPlain()
