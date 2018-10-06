module Main where

import Happstack.Server (Conf(port), nullConf, simpleHTTP, toResponse, ok)

main :: IO ()
main = simpleHTTP nullConf{port=9000} $ ok (toResponse "Hello, World!")
