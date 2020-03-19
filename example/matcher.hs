{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeApplications #-}

import           Control.Egison


main :: IO ()
main = print $ take 10 results
 where
  results = matchAll @BFS [1 ..] @(Set (M Int)) [q|
      $x : $y : _ -> (x, y)
    |]
