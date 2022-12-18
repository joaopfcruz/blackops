#using make to quickly and dirty configure all dependencies
#HOW TO
# 1: Create new section of commands
# 2: Add the section name in the "all" directive separated by a space
# 3: Add the section name in  the ".PHONY" directive separated by a space
BLACKOPS_ENV_VAR_NAME = "BLACKOPS_HOMEDIR"
BLACKOPS_ENV_VAR_VALUE = "/opt/blackops"
BLACKOPS_DATA_FOLDER = "data"
BLACKOPS_ETC_FOLDER = "etc"
WHOAMI = "$$(whoami)"

#A phony target is one that is not really the name of a file; rather it is just a name for a recipe to be executed
.PHONY: all dont-run-as-root env recon-ng-setup
#quiet make
.SILENT:

#Run all directives
all: env recon-ng-setup

dont-run-as-root:
        if id -u | egrep -q "^0$$"; then\
                echo "It's not supposed to run this as root. root pwd will be required when needed. Exiting";\
                exit 1;\
        fi

#Create the necessary environment variables and necessary folders (if they don't exist already)
env: dont-run-as-root
        #creating BLACKOPS main env var
        if test -f ~/.profile; then\
                echo ".profile file already exists";\
        else\
                echo "Creating .profile file";\
                touch ~/.profile;\
        fi
        if grep "export $(BLACKOPS_ENV_VAR_NAME)=" ~/.profile; then\
                echo "$(BLACKOPS_ENV_VAR_NAME) already set";\
        else\
                echo "export $(BLACKOPS_ENV_VAR_NAME)=$(BLACKOPS_ENV_VAR_VALUE)" >> ~/.profile;\
                echo "$(BLACKOPS_ENV_VAR_NAME) was set";\
        fi
        #Creating main folder of BlackOps project
        if test -d $(BLACKOPS_ENV_VAR_VALUE); then\
                echo "$(BLACKOPS_ENV_VAR_NAME) folder already exists";\
        else\
                echo "Creating $(BLACKOPS_ENV_VAR_NAME) ($(BLACKOPS_ENV_VAR_VALUE))";\
                sudo mkdir $(BLACKOPS_ENV_VAR_VALUE);\
                echo "Making $(WHOAMI) owner of $(BLACKOPS_ENV_VAR_VALUE)";\
                sudo chown -R $(WHOAMI):$(WHOAMI) $(BLACKOPS_ENV_VAR_VALUE);\
        fi
        #Creating data folder
        if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_DATA_FOLDER); then\
                echo "$(BLACKOPS_DATA_FOLDER) folder already exists";\
        else\
                echo "Creating $(BLACKOPS_DATA_FOLDER)";\
                mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_DATA_FOLDER);\
        fi
        #Creating etc folder
        if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER); then\
                echo "$(BLACKOPS_ETC_FOLDER) folder already exists";\
        else\
                echo "Creating $(BLACKOPS_ETC_FOLDER)";\
                mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER);\
        fi

#Install dependencies of recon-ng
recon-ng-setup: dont-run-as-root
        echo "marketplace install recon/domains-hosts/hackertarget" > /tmp/recon-ng.setup
        echo "marketplace install recon/domains-hosts/certificate_transparency" >> /tmp/recon-ng.setup
        echo "marketplace install recon/domains-hosts/mx_spf_ip" >> /tmp/recon-ng.setup
        echo "marketplace install reporting/json" >> /tmp/recon-ng.setup
        echo "exit" >> /tmp/recon-ng.setup
        recon-ng -r /tmp/recon-ng.setup
        rm /tmp/recon-ng.setup
        cp -R etc/recon-ng $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
