STDLIB ?= ../src
MOC ?= $(shell vessel bin)/moc
WASMTIME_OPTIONS = --disable-cache

OUTDIR=_out

TESTS = $(wildcard *Test.mo) $(wildcard **/*Test.mo)

TEST_TARGETS = $(patsubst %.mo,_out/%.checked,$(TESTS))

all: $(TEST_TARGETS) 

STDLIB_FILES= $(wildcard $(STDLIB)/**/*.mo)

VESSEL_PKGS= $(shell vessel sources)

$(OUTDIR):
		@mkdir $@

$(OUTDIR)/%.wasm: %.mo | $(OUTDIR)
		@ mkdir -p $(@D)
		$(MOC) $(VESSEL_PKGS) -wasi-system-api -o $@ $<

$(OUTDIR)/%.checked: $(OUTDIR)/%.wasm
		wasmtime run $(WASMTIME_OPTIONS) $<
			touch $@
clean:
		rm -rf $(OUTDIR)

.PRECIOUS: $(OUTDIR)/%.wasm
