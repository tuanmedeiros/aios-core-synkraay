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


# ──────────────────────────────────────────────
# Command Sync
# ──────────────────────────────────────────────
COMMAND_SYNC_SCRIPT := python3 squads/squad-creator-v1/scripts/sync-ide-command.py

# Sync Commands from a squad
#   make sync-commands SQUAD=squad-creator-pro IDE=gemini
sync-commands:
	@echo "--- Syncing commands for $(SQUAD) ---"
	$(COMMAND_SYNC_SCRIPT) squad $(SQUAD) $(FLAGS)

# Sync Commands from all squads
#   make sync-commands-all IDE=gemini
sync-commands-all:
	@for squad in $(SQUADS); do \
		echo ""; \
		echo "--- Syncing commands for $$squad ---"; \
		$(COMMAND_SYNC_SCRIPT) squad $$squad $(FLAGS); \
	done

help:
	@echo ""
	@echo "Usage:"
	@echo "  --- Agent Skills ---"
	@echo "  make sync              SQUAD=<name>           Sync agent skill for one squad"
	@echo "  make sync-all                                 Sync agent skills for all squads"
	@echo "  make sync-agent        AGENT=<agent> SQUAD=<squad>  Sync a single agent skill"
	@echo ""
	@echo "  --- Global Commands ---"
	@echo "  make sync-commands     SQUAD=<name>           Sync tasks/workflows from one squad"
	@echo "  make sync-commands-all                        Sync tasks/workflows from all squads"
	@echo ""
	@echo "  --- Utilities ---"
	@echo "  make sync-dry          SQUAD=<name>           Dry-run any sync (preview only)"
	@echo "  make sync-<name>                              Shorthand: make sync SQUAD=<name>"
	@echo ""
	@echo "Flags (append to any target):"
	@echo "  FORCE=1                Overwrite existing files"
	@echo "  DRY=1                  Preview without writing"
	@echo "  VERBOSE=1              Show detailed output"
	@echo "  IDE=gemini             Target specific IDE (claude, cursor, gemini, etc.)"
	@echo ""
	@echo "Available squads:"
	@echo "  $(SQUADS)" | tr ' ' '\n' | sed 's/^/    /'
	@echo ""
