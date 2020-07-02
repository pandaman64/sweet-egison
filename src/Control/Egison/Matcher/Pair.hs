-- |
--
-- Module:      Control.Egison.Matcher.Pair
-- Description: Matchers for pairs
-- Stability:   experimental

module Control.Egison.Matcher.Pair
  ( Pair(..)
  , tuple2
  )
where

import           Control.Monad                  ( MonadPlus(..) )
import           Control.Monad.Search
import           Control.Egison.Match
import           Control.Egison.Matcher
import           Control.Egison.QQ

data Pair m1 m2 = Pair m1 m2

instance (Matcher m1 t1, Matcher m2 t2) => Matcher (Pair m1 m2) (t1, t2)

tuple2 :: Pattern (Pair m1 m2) (t1, t2) (m1, m2) (t1, t2)
tuple2 (Pair m1 m2) (t1, t2) = pure ((m1, m2), (t1, t2))
