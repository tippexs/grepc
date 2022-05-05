MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKEFLAGS += --no-print-directory
MAKEFLAGS += --warn-undefined-variables


package := grepc


srcdir      := .
DESTDIR     :=
prefix      := /usr/local
exec_prefix := $(prefix)


BINDIR       := $(srcdir)/bin

bindir       := $(exec_prefix)/bin

_prefix      := $(DESTDIR)$(prefix)
_exec_prefix := $(DESTDIR)$(exec_prefix)
_bindir      := $(DESTDIR)$(bindir)

_bindirs     := $(_bindir)

_dirs        := $(_bindirs)


BIN     := $(sort $(shell find $(BINDIR) -type f))

_bin    := $(patsubst $(BINDIR)/%,$(_bindir)/%,$(BIN))

_bin_rm := $(addsuffix -rm,$(wildcard $(_bin)))


INSTALL         := install
INSTALL_DIR     := $(INSTALL) -d
INSTALL_PROGRAM := $(INSTALL)
RM              := rm


modules     := bin
install     := $(foreach x,$(modules),install-$(x))
installdirs := $(foreach x,$(modules),installdirs-$(x))
uninstall   := $(addprefix un,$(install))


.PHONY: all
all:
	@:


.PHONY: install     $(install)
.PHONY: installdirs $(installdirs)
.PHONY: uninstall   $(uninstall)


.SECONDEXPANSION:

install:        $(install)
$(install):     install-%:     $$(_%)
installdirs:    $(installdirs)
$(installdirs): installdirs-%: $$(_%dirs)
uninstall:      $(uninstall)
$(uninstall):   uninstall-%:   $$(_%_rm)


$(_bin): $(_bindir)/%: $(BINDIR)/% Makefile | $$(@D)
	$(info INSTALL	$@)
	$(INSTALL_PROGRAM) -T $< $@

$(_dirs): | $$(@D)
	$(info INSTALL	$@/)
	$(INSTALL_DIR) $@

$(sort $(_prefix) $(_exec_prefix)):
	$(info INSTALL	$@/)
	$(INSTALL_DIR) $@

%-rm:
	$(info RM	$*)
	$(RM) $*


V :=
$(V).SILENT:
