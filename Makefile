.PHONY: release debug run %.odin

CFLAGS += -strict-style -vet-unused

release: scratch
release: CFLAGS += -o:speed

debug: scratch
debug: CFLAGS += -debug

# if the first argument is "run"...
ifeq (run, $(firstword $(MAKECMDGOALS)))
	# use the rest as arguments for "run"
	RUN_ARGS := $(wordlist 2, $(words, $(MAKECMDGOALS)), $(MAKECMDGOALS))
	# and turn them into do-nothing targets
    $(eval $(RUN_ARGS):;@:)
endif

run: scratch
	@echo $(RUN_ARGS)
	@./scratch $(RUN_ARGS)

COLLECTION_SOURCES := reader=dependencies/Classreader/src,cli=dependencies/cli
COLLECTIONS = @exec sed 's/[,;]/ -collection ' <<< $(COLLECTION_SOURCES)

scratch:
	odin build src -out:scratch -collection:$(COLLECTIONS) $(CFLAGS)
