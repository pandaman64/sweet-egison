-- |
--
-- Module:      Control.Egison.Matcher
-- Description: Matcher class and basic matchers
-- Stability:   experimental
--
-- This module defines a class for matchers and some basic matchers.

module Control.Egison.Matcher
  ( Pattern
  , Matcher
  , Something(..)
  , ValuePattern(..)
  , Eql(..)
  )
where

import           Control.Monad                  ( MonadPlus(..) )

-- | Type synonym for patterns.
type Pattern ps im it ot = ps -> im -> it -> [ot]

-- | Class for matchers. @'Matcher' m tgt@ denotes that @m@ is a matcher for @tgt@.
class Matcher m tgt

-- | Matcher that handles pattern variables and wildcards for arbitrary types.
data Something = Something

instance Matcher Something a

class Eq t => ValuePattern m t where
  value :: t -> Pattern () m t ()
  default value :: Eq t => t -> Pattern () m t ()
  value e () _ v = if e == v then pure () else mzero
  valueM :: m -> t -> ()
  default valueM :: m -> t -> ()
  valueM _ _ = ()

-- | Matcher that can handle value patterns of 'Eq' types.
data Eql = Eql

instance Eq a => Matcher Eql a
instance Eq a => ValuePattern Eql a
