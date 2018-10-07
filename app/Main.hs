module Main where

import Control.Monad
import Data.Char (toLower)
import Happstack.Server (
        Conf(port),
        FromReqURI(..),
        Method(GET, POST),
        nullConf,
        simpleHTTP,
        ok,
        dir,
        dirs,
        method,
        path
    )

data Subject = World | Haskell

sayHello :: Subject -> String
sayHello World   = "Hello, World!"
sayHello Haskell = "Greetings, Haskell!"

instance FromReqURI Subject where
    fromReqURI sub =
        case map toLower sub of
            "haskell" -> Just Haskell
            "world"   -> Just World
            _         -> Nothing

main :: IO ()
main = do
    putStrLn "Starting server..."
    simpleHTTP nullConf{port=9000} $ msum [
            dir "hello"    $ ok "Hello, World!",
            dir "hello" $ dir "moon" $ ok "Hello, Moon!", -- Will never be called since above succeeds
            dir "goodbye" $ dir "moon" $ ok "Goodbye, Moon!",
            dir "goodbye"  $ ok "Goodbye, World!",
            dirs "something/else" $ ok "Uses dirs function",
            dir "matchrest" $ path $ \s -> ok $ "Hello, " ++ s, -- path matches up to next /
            dir "fromrequri_instance" $ path $ \subject -> ok $ (sayHello subject),
            do
                method GET
                ok $ "You did a GET request.\n",
            do
                method POST
                ok $ "You did a POST request.\n"
        ]
