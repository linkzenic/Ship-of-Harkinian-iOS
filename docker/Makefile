SHELL = /bin/bash
SCRIPTS="./scripts"

.PHONY: all help setup build build_release create_container

### Main Targets ###

help:
	@ echo ""
	@ echo "Usage:"
	@ echo "  make setup - Install container environment"
	@ echo "  make build - Build project through the container"
	@ echo "  make build_release - Build project release through the container"
	@ echo "  make create_container - Local build the container"
	@ echo ""

setup: scripts_exec_permission
	@ $(SCRIPTS)/install_container_image.sh

build: scripts_exec_permission
	@ $(SCRIPTS)/build_android_project.sh

build_release: scripts_exec_permission
	@ $(SCRIPTS)/build_android_project.sh --release

create_container: scripts_exec_permission
	@ $(SCRIPTS)/build_container_image.sh

### Auxiliary Targets ###

scripts_exec_permission:
	@ chmod +x $(SCRIPTS)/*.sh
