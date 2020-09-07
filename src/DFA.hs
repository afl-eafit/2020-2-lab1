{- | Serves as way to represent deterministic finite automata. -}
module DFA where

import Data.Map as Map (Map, empty, insertWith, singleton, union)
import Data.Set as Set (Set, empty, insert)

-- | Represents a DFA with states of type @s@ and input symbols of type @c@
data DFA s c = MkDFA
  { -- | A unique initial state
    start         :: s
  , {- | The transition function.
         The outer map stores all transitions available from a state,
         inner maps stores the endpoint of a transition using a given symbol -}
    delta         :: Map s (Map c s)
  , -- | A set of final/accepting states
    accepting     :: Set s
  } deriving Show

-- | Creates a new DFA with a starting state @q0@
initDFA :: s -> DFA s a
initDFA q0 = MkDFA q0 Map.empty Set.empty

-- | Adds a new transition from state @q@ to @q'@ with a symbol @c@ to a DFA
trans :: (Ord s, Ord c) => (s, s, c) -> DFA s c -> DFA s c
trans (q, q', c) (MkDFA q0 ts f) = MkDFA q0 ts' f
  where ts' = Map.insertWith Map.union q (Map.singleton c q') ts

-- | Adds a new accepting state @q@ to a DFA
accept :: (Ord a, Ord s) => s -> DFA s a -> DFA s a
accept q (MkDFA q0 ts fs) = MkDFA q0 ts (Set.insert q fs)

-- | Example of a DFA
example0 :: DFA Int Int
example0 = initDFA 1

example1 :: DFA Int Int
example1 = accept 1 $ initDFA 1

example2 :: DFA Int Char
example2 = trans (1, 3, 'c') $
  trans (1, 2, 'a') $
  trans (1, 2, 'b') $
  trans (2, 3, 'b') $
  trans (3, 2, 'a') $
  accept 3 $ initDFA 1

example3 :: DFA Int Int
example3 = trans (1, 2, 1) $
  trans (2, 1, 0) $
  accept 1 $
  accept 2 $
  initDFA 1

example4 :: DFA Int String
example4 = trans (1, 1, "(^o^)/") $
  trans (1, 2, "(-_-)") $
  accept 2 $ initDFA 1
