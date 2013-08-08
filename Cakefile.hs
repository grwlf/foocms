-- | Makefile source. To be compiled with cake3
-- https://github.com/grwlf/cake3

{-# OPTIONS_GHC -F -pgmF MonadLoc #-}
{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Cakefile where

import Control.Monad.Loc
import Development.Cake3
import System.FilePath.Glob

import Cakefile_P (file, cakefiles)

tcflag = "-dumpTypes"

pname = "urcms" :: String

src = "src"
tst = "tst"

urflags = makevar "URFLAGS" tcflag

dbflags = "-dbms sqlite" :: String

files = do
  fs <- forM [tst,src] $ \ d -> glob $ d </> "*.ur"
  return $ map file $ concat fs ++ ["urcms.urp"]

dbfile = rule [file "urcms.db"] $ do
  [shell| touch $dst |]

site@[sqlscript, exe] = rule [file "urcms.sql", file "urcms.exe"] $ do
  depend files
  [shell| urweb $urflags $dbflags $pname |]

resetdb = phony "resetdb" $ do
  [shell| -rm -rf $dbfile |]
  [shell| sqlite3 $dbfile < $sqlscript |]

all = do
  phony "all" $ do
    depend exe
    depend resetdb

-- Typecheck
tc = phony "tc" $ do
  [shell| urweb $tcflag $pname |]

-- Self-update rules
cakegen = rule [file "Cakegen" ] $ do
  depend cakefiles
  [shell| cake3 |]

selfupdate = rule [file "Makefile"] $ do
  [shell| $cakegen > $dst |]

main = do
  runMake [Cakefile.all, site, resetdb, selfupdate, tc] >>= putStrLn . toMake

