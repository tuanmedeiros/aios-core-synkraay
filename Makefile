SYNC_SCRIPT := python3 squads/squad-creator-v2/scripts/sync-ide-skills.py
SQUADS := aiox-sop brand claude-code-mastery data db-sage design etl-ops hormozi spy storytelling squad-creator-v2 squad-creator-pro

# ──────────────────────────────────────────────
# Sync individual squad
#   make sync SQUAD=hormozi
#   make sync SQUAD=hormozi FORCE=1
#   make sync SQUAD=hormozi DRY=1
# ──────────────────────────────────────────────
SQUAD ?= squad-creator-v2
FLAGS  :=
ifdef DRY
  FLAGS += --dry-run
endif
ifdef FORCE
  FLAGS += --force
endif
ifdef VERBOSE
  FLAGS += --verbose
endif
ifdef IDE
  FLAGS += --ide $(IDE)
endif

.PHONY: sync sync-all sync-dry $(addprefix sync-,$(SQUADS)) help

sync:
	$(SYNC_SCRIPT) squad $(SQUAD) $(FLAGS)

sync-dry:
	$(SYNC_SCRIPT) squad $(SQUAD) --dry-run $(FLAGS)

# ──────────────────────────────────────────────
# Sync all squads
#   make sync-all
#   make sync-all FORCE=1
# ──────────────────────────────────────────────
sync-all:
	@for squad in $(SQUADS); do \
		echo ""; \
		$(SYNC_SCRIPT) squad $$squad $(FLAGS); \
	done

# ──────────────────────────────────────────────
# Sync squad by name shorthand
#   make sync-hormozi
#   make sync-hormozi FORCE=1
# ──────────────────────────────────────────────
$(addprefix sync-,$(SQUADS)):
	$(SYNC_SCRIPT) squad $(@:sync-%=%) $(FLAGS)

# ──────────────────────────────────────────────
# Sync single agent
#   make sync-agent AGENT=brand-chief SQUAD=brand
# ──────────────────────────────────────────────
AGENT ?=
sync-agent:
	$(SYNC_SCRIPT) agent $(AGENT) --squad $(SQUAD) $(FLAGS)

help:
	@echo ""
	@echo "Usage:"
	@echo "  make sync              SQUAD=<name>           Sync one squad (default: squad-creator-v2)"
	@echo "  make sync-dry          SQUAD=<name>           Dry-run (preview only)"
	@echo "  make sync-all                                 Sync all squads"
	@echo "  make sync-<name>                              Shorthand: make sync-hormozi"
	@echo "  make sync-agent        AGENT=<agent> SQUAD=<squad>  Sync one agent"
	@echo ""
	@echo "Flags (append to any target):"
	@echo "  FORCE=1                Overwrite existing files"
	@echo "  DRY=1                  Preview without writing"
	@echo "  VERBOSE=1              Show detailed output"
	@echo "  IDE=claude             Target specific IDE"
	@echo ""
	@echo "Available squads:"
	@echo "  $(SQUADS)" | tr ' ' '\n' | sed 's/^/    /'
	@echo ""
