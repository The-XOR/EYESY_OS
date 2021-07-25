# Attempt to load a config.make file.
# If none is found, project defaults in config.project.make will be used.
ifneq ($(wildcard config.make),)
	include config.make
endif

# make sure the the OF_ROOT location is defined
ifndef OF_ROOT
	OF_ROOT=$(realpath ../../..)
endif

# call the project makefile!
OF_SHARED_MAKEFILES_PATH=$(OF_ROOT)/libs/openFrameworksCompiled/project/makefileCommon

include $(OF_SHARED_MAKEFILES_PATH)/compile.project.mk

# include the global configuration file
include $(OF_SHARED_MAKEFILES_PATH)/config.shared.mk



