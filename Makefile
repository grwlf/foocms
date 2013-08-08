# This Makefile was generated by the ThirdCake
# https://github.com/grwlf/cake3

GUARD = .GUARD_$(1)_$(shell echo $($(1)) | md5sum | cut -d ' ' -f 1)
URFLAGS = -dumpTypes
.PHONY: all
all : resetdb urcms.exe
.PHONY: resetdb
resetdb : urcms.sql urcms.db urcms.db
	-rm -rf urcms.db
	sqlite3 urcms.db < urcms.sql
.INTERMEDIATE:stamp1
stamp1 : urcms.urp src/Tmpl.ur src/Main.ur src/Auth.ur tst/ref.ur tst/refFun.ur tst/link.ur $(call GUARD,URFLAGS)
	urweb $(URFLAGS) -dbms sqlite urcms
urcms.sql urcms.exe : stamp1
urcms.db : 
	touch urcms.db
Makefile : Cakegen
	Cakegen > Makefile
Cakegen : ./Cakefile.hs
	cake3
.PHONY: tc
tc : 
	urweb -dumpTypes urcms
$(call GUARD,URFLAGS) :
	rm -f .GUARD_URFLAGS_*
	touch $@

