module Main where

import Control.Monad
import Happstack.Server (Conf(port), nullConf, simpleHTTP, ok, dir)

main :: IO ()
main = simpleHTTP nullConf{port=9000} $ msum [
        dir "hello"    $ ok "Hello, World!",
        dir "hello" $ dir "moon" $ ok "Hello, Moon!", -- Will never be called since above succeeds
        dir "goodbye" $ dir "moon" $ ok "Goodbye, Moon!",
        dir "goodbye"  $ ok "Goodbye, World!"
    ]
