module Control.Egison.Matcher.Set
  ( Set(..)
  )
where

import           Data.View                      ( View(..) )
import           Control.Monad                  ( MonadPlus(..) )

import           Control.Egison.Pattern         ( CollectionPattern(..) )


newtype Set a = Set [a]

instance View a => View (Set a) where
  type Target (Set a) = [Target a]
  type Projection (Set a) = Set (Projection a)

instance CollectionPattern (Set a) where
  type Element (Set a) = a
  cons (Set xs) = foldr go mzero xs
    where go x acc = pure (x, Set xs) `mplus` acc
-- TODO: Implement
  tails = undefined
