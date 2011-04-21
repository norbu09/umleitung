all:
	(cd deps/mochiweb; $(MAKE))
	(cd deps/erlang_couchdb; $(MAKE))
	(cd src; $(MAKE))

clean:
	(cd deps/mochiweb; $(MAKE) clean)
	(cd deps/erlang_couchdb; $(MAKE) clean)
	(cd src; $(MAKE) clean)
