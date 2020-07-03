{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}

import           Control.Egison

import           Data.List                      ( nub
                                                , delete
                                                )


data Literal = Literal
instance Eq a => Matcher Literal a
instance Eq a => ValuePattern Literal a

deleteLiteral l cnf = map
  (\c -> matchAll dfs c (Multiset Literal) [[mc| (!#l & $m) : _ -> m |]])
  cnf

deleteClausesWith l cnf = matchAll dfs
                                   cnf
                                   (Multiset (Multiset Literal))
                                   [[mc| (!(#l : _) & $c) : _ -> c |]]

assignTrue l cnf = deleteLiteral (negate l) (deleteClausesWith l cnf)

tautology c = match
  dfs
  c
  (Multiset Literal)
  [[mc| $l : #(negate l) : _ -> True |], [mc| _ -> False |]]

resolveOn v cnf = filter
  (not . tautology)
  (matchAll dfs
            cnf
            (Multiset (Multiset Literal))
            [[mc| (#v : $xs) : (#(negate v) : $ys) : _ -> nub (xs ++ ys) |]]
  )

dp :: [Integer] -> [[Integer]] -> Bool
dp vars cnf = match
  dfs
  (vars, cnf)
  (Pair (Multiset Literal) (Multiset (Multiset Literal)))
    -- satisfiable
  [ [mc| (_, []) -> True |]
    -- unsatisfiable
  , [mc| (_, [] : _) -> False |]
    -- 1-literal rule
  , [mc| (_, ($l : []) : _) ->
            dp (delete (abs l) vars) (assignTrue l cnf) |]
    -- pure literal rule (positive)
  , [mc| ($v : $vs, !((#v : _) : _)) ->
            dp vs (assignTrue v cnf) |]
    -- pure literal rule (negative)
  , [mc| ($v : $vs, !((#(negate v) : _) : _)) ->
            dp vs (assignTrue (negate v) cnf) |]
    -- otherwise
  , [mc| ($v : $vs, _) ->
            dp vs (resolveOn v cnf ++
                   deleteClausesWith v (deleteClausesWith (negate v) cnf)) |]
  ]

main :: IO ()
main = do
  print $ dp [] []
  print $ dp [] [[]]
  print $ dp [1] [[1]]
  print $ dp [1, 2] [[1], [1, 2]]
  print $ dp [1 .. 50] problem

problem :: [[Integer]]
problem =
  [ [18, -8, 29]
  , [-16, 3, 18]
  , [-36, -11, -30]
  , [-50, 20, 32]
  , [-6, 9, 35]
  , [42, -38, 29]
  , [43, -15, 10]
  , [-48, -47, 1]
  , [-45, -16, 33]
  , [38, 42, 22]
  , [-49, 41, -34]
  , [12, 17, 35]
  , [22, -49, 7]
  , [-10, -11, -39]
  , [-28, -36, -37]
  , [-13, -46, -41]
  , [21, -4, 9]
  , [12, 48, 10]
  , [24, 23, 15]
  , [-8, -41, -43]
  , [-44, -2, -35]
  , [-27, 18, 31]
  , [47, 35, 6]
  , [-11, -27, 41]
  , [-33, -47, -45]
  , [-16, 36, -37]
  , [27, -46, 2]
  , [15, -28, 10]
  , [-38, 46, -39]
  , [-33, -4, 24]
  , [-12, -45, 50]
  , [-32, -21, -15]
  , [8, 42, 24]
  , [30, -49, 4]
  , [45, -9, 28]
  , [-33, -47, -1]
  , [1, 27, -16]
  , [-11, -17, -35]
  , [-42, -15, 45]
  , [-19, -27, 30]
  , [3, 28, 12]
  , [48, -11, -33]
  , [-6, 37, -9]
  , [-37, 13, -7]
  , [-2, 26, 16]
  , [46, -24, -38]
  , [-13, -24, -8]
  , [-36, -42, -21]
  , [-37, -19, 3]
  , [-31, -50, 35]
  , [-7, -26, 29]
  , [-42, -45, 29]
  , [33, 25, -6]
  , [-45, -5, 7]
  , [-7, 28, -6]
  , [-48, 31, -11]
  , [32, 16, -37]
  , [-24, 48, 1]
  , [18, -46, 23]
  , [-30, -50, 48]
  , [-21, 39, -2]
  , [24, 47, 42]
  , [-36, 30, 4]
  , [-5, 28, -1]
  , [-47, 32, -42]
  , [16, 37, -22]
  , [-43, 42, -34]
  , [-40, 39, -20]
  , [-49, 29, 6]
  , [-41, -3, 39]
  , [-16, -12, 43]
  , [24, 22, 3]
  , [47, -45, 43]
  , [45, -37, 46]
  , [-9, 26, 5]
  , [-3, 23, -13]
  , [5, -34, 13]
  , [12, 39, 13]
  , [22, 50, 37]
  , [19, 9, 46]
  , [-24, 8, -27]
  , [-28, 7, 21]
  , [8, -25, 50]
  , [20, 50, 4]
  , [27, 36, 13]
  , [26, 31, -25]
  , [39, -44, -32]
  , [-20, 41, -10]
  , [49, -28, 35]
  , [1, 44, 34]
  , [39, 35, -11]
  , [-50, -42, -7]
  , [-24, 7, 47]
  , [-13, 5, -48]
  , [-9, -20, -23]
  , [2, 17, -19]
  , [11, 23, 21]
  , [-45, 30, 15]
  , [11, 26, -24]
  , [38, 33, -13]
  , [44, -27, -7]
  , [41, 49, 2]
  , [-18, 12, -37]
  , [-2, 12, -26]
  , [-19, 7, 32]
  , [-22, 11, 33]
  , [8, 12, -20]
  , [16, 40, -48]
  , [-2, -24, -11]
  , [26, -17, 37]
  , [-14, -19, 46]
  , [5, 47, 36]
  , [-29, -9, 19]
  , [32, 4, 28]
  , [-34, 20, -46]
  , [-4, -36, -13]
  , [-15, -37, 45]
  , [-21, 29, 23]
  , [-6, -40, 7]
  , [-42, 31, -29]
  , [-36, 24, 31]
  , [-45, -37, -1]
  , [3, -6, -29]
  , [-28, -50, 27]
  , [44, 26, 5]
  , [-17, -48, 49]
  , [12, -40, -7]
  , [-12, 31, -48]
  , [27, 32, -42]
  , [-27, -10, 1]
  , [6, -49, 10]
  , [-24, 8, 43]
  , [23, 31, 1]
  , [11, -47, 38]
  , [-28, 26, -13]
  , [-40, 12, -42]
  , [-3, 39, 46]
  , [17, 41, 46]
  , [23, 21, 13]
  , [-14, -1, -38]
  , [20, 18, 6]
  , [-50, 20, -9]
  , [10, -32, -18]
  , [-21, 49, -34]
  , [44, 23, -35]
  , [40, -19, 34]
  , [-1, 6, -12]
  , [6, -2, -7]
  , [32, -20, 34]
  , [-12, 43, -29]
  , [24, 2, -49]
  , [10, -4, 40]
  , [11, 5, 12]
  , [-3, 47, -31]
  , [43, -23, 21]
  , [-41, -36, -50]
  , [-8, -42, -24]
  , [39, 45, 7]
  , [7, 37, -45]
  , [41, 40, 8]
  , [-50, -10, -8]
  , [-5, -39, -14]
  , [-22, -24, -43]
  , [-36, 40, 35]
  , [17, 49, 41]
  , [-32, 7, 24]
  , [-30, -8, -9]
  , [-41, -13, -10]
  , [31, 26, -33]
  , [17, -22, -39]
  , [-21, 28, 3]
  , [-14, 46, 23]
  , [29, 16, 19]
  , [42, -32, -44]
  , [-24, 10, 23]
  , [-1, -32, -21]
  , [-8, -44, -39]
  , [39, 11, 9]
  , [19, 14, -46]
  , [46, 44, -42]
  , [37, 23, -29]
  , [32, 25, 20]
  , [14, -43, -12]
  , [-36, -18, 46]
  , [14, -26, -10]
  , [-2, -30, 5]
  , [6, -18, 46]
  , [-26, 2, -44]
  , [20, -8, -11]
  , [-31, 3, 16]
  , [-22, -9, 39]
  , [-49, 44, -42]
  , [-45, -44, 31]
  , [-31, 50, -11]
  , [-32, -46, 2]
  , [-6, -7, 17]
  , [19, -32, 48]
  , [39, 20, -10]
  , [-22, -37, 38]
  , [-31, 9, -48]
  , [40, 12, 7]
  , [-24, -4, 9]
  , [-22, 49, 33]
  , [-12, 43, 10]
  , [25, -30, -10]
  , [46, 47, 31]
  , [13, 27, -7]
  , [-45, 32, -35]
  , [-50, 34, 9]
  , [2, 34, 30]
  , [3, 16, 2]
  , [-18, 45, -12]
  , [33, 37, 10]
  , [43, 7, -18]
  , [-22, 44, -19]
  , [-31, -27, -42]
  , [-3, -40, 8]
  , [-23, -31, 38]
  ]
