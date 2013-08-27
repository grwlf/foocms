-- | Makefile source. To be compiled with cake3
-- https://github.com/grwlf/cake3

{-# OPTIONS_GHC -F -pgmF MonadLoc #-}
{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Cakefile where

import Control.Applicative
import Control.Monad.Loc
import Data.Char
import Development.Cake3
import System.FilePath.Glob
import System.FilePath

import Cakefile_P (file, cakefiles)

tcflag = ""

tst = "tst"

urflags = makevar "URFLAGS" tcflag

dbflags = "-dbms sqlite" :: String

pname = "FooCMS"

project = file (pname ++ ".urp")

expand :: [FilePath] -> [String] -> IO [File]
expand dirs pats = map file <$> concat <$> forM dirs (\ dir -> concat <$> forM pats (glob . (dir </>)))

srcs :: IO [File]
srcs = expand (["." , "src"] ++ libs) p where
  p = words "*.urp *.urs *.ur"
  libs = ["src/uwprocess", "src/jqmenu" ]

article_html = rule [a .= "html"] $ do
  shell [cmd| pandoc -f markdown -t html $(a) > $dst |] where
  a = file "content/article.markdown"

blob :: FilePath -> Rule
blob b = rule [ file urp ] $ do
  shell [cmd| mkdir -pv $(static_dir) |]
  shell [cmd| urembed -o $(takeDirectory urp) $(file b) |] where
    static_dir = "src/static"
    urp = static_dir </> ((upperFst $ map undot (takeFileName b)) ++ ".urp") where
      upperFst x = toUpper (head x) : (tail x)
      undot '.' = '_'
      undot '-' = '_'
      undot x = x

site@[sql, exe] = rule [project .= "sql", project .= "exe"] $ do
  depend srcs
  depend (blob "src/Style.css")
  depend (blob "content/article.html")
  depend (blob "src/JQM.js")
  shell [cmd| urweb $urflags $dbflags $pname |]
  shell [cmd| touch $dst |]

db = rule [ project .= "db" ] $ do
  depend exe
  shell [cmd| -rm -rf $dst |]
  shell [cmd| sqlite3 $dst < $sql |]

all = phony "all" $ depend db >> depend exe

selfupdate = rule [makefile] $ do
  depend cakefiles
  shell [cmd| cake3 |]

main = do
  runMake [Cakefile.all, site, db, selfupdate] >>= putStrLn . toMake

