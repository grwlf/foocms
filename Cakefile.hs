-- | Makefile source. To be compiled with cake3
-- https://github.com/grwlf/cake3

{-# OPTIONS_GHC -F -pgmF MonadLoc #-}
{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Cakefile where

import Control.Applicative
import Control.Monad.Loc
import Development.Cake3
import System.FilePath.Glob

import Cakefile_P (file, cakefiles)

tcflag = ""

src = "src"
tst = "tst"

urflags = makevar "URFLAGS" tcflag

dbflags = "-dbms sqlite" :: String

pname = "FooCMS"

project = file (pname ++ ".urp")

expand :: [FilePath] -> [String] -> IO [File]
expand dirs pats = map file <$> concat <$> forM dirs (\ dir -> concat <$> forM pats (glob . (dir </>)))

indir :: FilePath -> [FilePath] -> [File]
indir d fs = map file $ map (d </>) fs

libs = ["lib/uwprocess", "lib/jqmenu" ]

srcs :: IO [File]
srcs = expand (["." , "src"] ++ libs) p where
  p = words "*.urp *.urs *.ur"

css = file ("src" </> "Style.css")
article_md = file ("content" </> "article.markdown")
js = file "lib/jqmenu/JQM.js"

article_html = rule [article_md .= "html"] $ do
  shell [cmd| pandoc -f markdown -t html $(article_md) > $dst |]

autogen = rule [file (jqm </> "lib.urp") ] $ do
  shell [cmd| mkdir -pv $jqm |]
  shell [cmd| ./mkres.sh $jqm $css $(article_html) $js |] where
    jqm = "lib/static"

site@[sql, exe] = rule [project .= "sql", project .= "exe"] $ do
  depend srcs
  depend autogen
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

