{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module SExpr_Unittests (
  sexpTestTree
  )where

import Test.Tasty
import Test.Tasty.HUnit
import Data.SExpresso.SExpr

type Sexp a = SExpr () a

sexpTestTree :: TestTree
sexpTestTree = testGroup "Sexpr.hs unit tests"

  [testGroup "isList" [
      testCase "Empty SList" $ isList (SList () [] :: Sexp Int) @?= True,
      testCase "SList" $ isList (SList () [SAtom 1, SAtom 2] :: Sexp Int) @?= True,
      testCase "SAtom" $ isList (SAtom 1 :: Sexp Int) @?= False],

   testGroup "sList" [
      testCase "Empty SList" $ sList (SList () [] :: Sexp Int) @?= Just [],
      testCase "SList" $ sList (SList () [SAtom 1, SAtom 2] :: Sexp Int) @?= Just [SAtom 1, SAtom 2],
      testCase "SAtom" $ sList (SAtom 1 :: Sexp Int) @?= Nothing],
    
   testGroup "isAtom" [
      testCase "Empty SList" $ isAtom (SList () [] :: Sexp Int) @?= False,
      testCase "SList" $ isAtom (SList () [SAtom 1, SAtom 2] :: Sexp Int) @?= False,
      testCase "SAtom" $ isAtom (SAtom 1 :: Sexp Int) @?= True],

   testGroup "sAtom" [
      testCase "Empty SList" $ sAtom (SList () [] :: Sexp Int) @?= Nothing,
      testCase "SList" $ sAtom (SList () [SAtom 1, SAtom 2] :: Sexp Int) @?= Nothing,
      testCase "SAtom" $ sAtom (SAtom 1 :: Sexp Int) @?= Just 1],

   testGroup "Pattern synonyms" [
      testCase "L - empty list (1/2)" $
        (case (SList () []) of
           L [] -> True
           _ -> False) @?= True,
      testCase "L - empty list (2/2)" $
        (case (SList () [SAtom 1 :: Sexp Int]) of
           L [] -> True
           _ -> False) @?= False,
      testCase "L - singleton list (1/2)" $
        (case (SList () [SAtom 1 :: Sexp Int]) of
           L [_] -> True
           _ -> False) @?= True,
      testCase "L - singleton list (2/2)" $
        (case (SList () [SAtom 1 :: Sexp Int]) of
           L [] -> True
           _ -> False) @?= False,
      testCase "L - atom" $
        (case (SAtom 1 :: Sexp Int) of
           L _ -> True
           _ -> False) @?= False,
      testCase "A - atom (1/2)" $
        (case (SAtom 1 :: Sexp Int) of
           A 1 -> True
           _ -> False) @?= True,
      testCase "A - atom (2/2)" $
        (case (A 1 :: Sexp Int) of
           SAtom 1 -> True
           _ -> False) @?= True,
      testCase "A - singleton list" $
        (case (SList () [SAtom 1 :: Sexp Int]) of
           A 1 -> True
           _ -> False) @?= False,
      testCase "Nil - empty SList" $
        (case (SList () []) of
           Nil -> True
           _ -> False) @?= True,
      testCase "Nil - singleton SList" $
        (case (SList () [SAtom 1 :: Sexp Int]) of
           Nil -> True
           _ -> False) @?= False,
      testCase "::: and Nil (1/4)" $
        (case (SList () [SAtom 1 :: Sexp Int]) of
           A 1 ::: Nil -> True
           _ -> False) @?= True,
      testCase "::: and Nil (2/4)" $
        (case (SList () [SAtom 42 :: Sexp Int, SList () [SAtom 0, SList () []]]) of
           A a' ::: L b' ::: Nil -> 42 == a' && [SAtom 0, SList () []] == b'
           _ -> False) @?= True,
      testCase "::: and Nil (3/4)" $
        (case (SList () [SAtom 1 :: Sexp Int, SAtom 2, SAtom 3, SAtom 4, SAtom 5]) of
           A 1 ::: A 2 ::: A 3 ::: A 4 ::: A 5 ::: Nil -> True
           _ -> False) @?= True,
      testCase "::: and Nil (4/4)" $
        (case (SList () [SAtom 1 :: Sexp Int, SAtom 2, SAtom 3, SAtom 4, SAtom 5]) of
           A 1 ::: A 2 ::: A 3 ::: A 4 ::: x -> x == SList () [SAtom 5]
           _ -> False) @?= True],

    testGroup "Functor" [
      testCase "Empty SList" $ fmap (\x -> x + 1) (SList () [] :: Sexp Int) @?= (SList () []),
      testCase "Singleton SList" $ fmap (\x -> x + 1) (SList () [SAtom 5] :: Sexp Int) @?= (SList () [SAtom 6])]
  ]
