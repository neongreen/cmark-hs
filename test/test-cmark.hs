{-# LANGUAGE OverloadedStrings #-}

import CMark
import Test.HUnit
import System.Exit
import Data.Text ()

main :: IO ()
main = do
  counts' <- runTestTT tests
  case (errors counts' + failures counts') of
       0 -> exitWith ExitSuccess
       n -> exitWith (ExitFailure n)

-- The C library has its own extensive tests.
-- Here we just make sure it's basically working.
tests :: Test
tests = TestList [
    "<h1>Hi</h1>\n" ~=? commonmarkToHtml [] "# Hi"
  , "<p>dog’s</p>\n" ~=? commonmarkToHtml [optSmart] "dog's"
  , "<p><a href=\"\">trick</a></p>\n" ~=? commonmarkToHtml [optSafe] "[trick](javascript:alert('hi'))"
  , ".RS\n.PP\nquote\n.RE\n" ~=? commonmarkToMan [] Nothing "> quote"
  , (Node (Just (PosInfo {startLine = 1, startColumn = 1, endLine = 1, endColumn = 13})) DOCUMENT [Node (Just (PosInfo {startLine = 1, startColumn = 1, endLine = 1, endColumn = 13})) PARAGRAPH [Node Nothing (TEXT "Hello ") [],Node Nothing EMPH [Node Nothing (TEXT "world") []]]]) ~=? commonmarkToNode [] "Hello *world*"
  , "> Hello\n> *world*\n" ~=? nodeToCommonmark [] (Just 12) (Node Nothing DOCUMENT [Node Nothing BLOCK_QUOTE [Node Nothing PARAGRAPH [Node Nothing (TEXT "Hello ") [],Node Nothing EMPH [Node Nothing (TEXT "world") []]]]])
  ]

