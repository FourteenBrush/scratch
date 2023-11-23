.PHONY: release debug run

release: scratch
release: CFLAGS += -o:speed

debug: scratch
debug: CLAGS += -debug

run: scratch
	@./scratch

COLLECTIONS = reader=dependencies/Classreader/src

scratch:
	@odin build src -out:scratch -collection=$(COLLECTIONS) $(CFLAGS)
