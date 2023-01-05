#using make to quickly and dirty configure all dependencies
#HOW TO
# 1: Create new section of commands
# 2: Add the section name in the "all" directive separated by a space
# 3: Add the section name in  the ".PHONY" directive separated by a space
WHOAMI = "blackops"
USER_HOME = "/home/blackops"

PIP3_HOME = "/home/blackops/.local/bin"
GOROOT= "/usr/lib/go"

SHELL_ENV_FILE = ".bashrc"


BLACKOPS_ENV_VAR_NAME = "BLACKOPS_HOMEDIR"
BLACKOPS_ENV_VAR_VALUE = "/opt/blackops"
BLACKOPS_DATA_FOLDER = "data"
BLACKOPS_ETC_FOLDER = "etc"

BLACKOPS_PAYLOADS_FOLDER = "payloads"
BLACKOPS_PAYL_CMDINJECTION_FOLDER = "cmd_injection"
BLACKOPS_PAYL_DIRTRAVERSAL_FOLDER = "dir_traversal"
BLACKOPS_PAYL_FILEINCLUSION_FOLDER = "file_inclusion"
BLACKOPS_PAYL_INSERCUREMGMTIFACE_FOLDER = "insecure_mgmt_interface"
BLACKOPS_PAYL_LDAPINJECTION_FOLDER = "ldap_injection"
BLACKOPS_PAYL_NOSQLINJECTION_FOLDER = "nosql_injection"
BLACKOPS_PAYL_OPENREDIRECT_FOLDER = "open_redirect"
BLACKOPS_PAYL_SQLINJECTION_FOLDER = "sql_injection"
BLACKOPS_PAYL_SSTI_FOLDER = "ssti"
BLACKOPS_PAYL_XSS_FOLDER = "xss"
BLACKOPS_PAYL_XXE_FOLDER = "xxe"
PAYLOADS_TMP_ZIP = "/tmp/payltmp.zip"

WPSCAN_API_TOKEN_VAR_NAME = "WPSCAN_API_TOKEN"

#A phony target is one that is not really the name of a file; rather it is just a name for a recipe to be executed
.PHONY: all dont-run-as-root env get-payloads recon-ng-setup censys-setup shodan-setup gobuster-setup whatweb-setup wpscan-setup droopescan-setup cloud_enum-setup nuclei-setup gospider-setup xspear-setup dalfox-setup nmap-setup wapiti-setup sqlmap-setup paramspider-setup oralyzer-setup corsy-setup xsstrike-setup crlfsuite-setup
#quiet make
.SILENT:

#Run all directives (except env which should run separately)
all: get-payloads recon-ng-setup censys-setup shodan-setup gobuster-setup whatweb-setup wpscan-setup droopescan-setup cloud_enum-setup nuclei-setup gospider-setup xspear-setup dalfox-setup nmap-setup wapiti-setup sqlmap-setup paramspider-setup oralyzer-setup corsy-setup xsstrike-setup crlfsuite-setup

dont-run-as-root:
	if id -u | egrep -q "^0$$"; then\
                echo "It's not supposed to run this as root. root pwd will be required when needed. Exiting";\
                exit 1;\
        fi

#Create the necessary environment variables and necessary folders (if they don't exist already)
env: dont-run-as-root
	echo "Creating environment..."
	#creating BLACKOPS main env var
	if test -f "$(USER_HOME)/$(SHELL_ENV_FILE)"; then\
		echo "$(USER_HOME)/$(SHELL_ENV_FILE) file already exists";\
	else\
		echo "Creating $(USER_HOME)/$(SHELL_ENV_FILE) file";\
		touch "$(USER_HOME)/$(SHELL_ENV_FILE)";\
	fi
	if grep "export $(BLACKOPS_ENV_VAR_NAME)=" "$(USER_HOME)/$(SHELL_ENV_FILE)"; then\
		echo "$(BLACKOPS_ENV_VAR_NAME) already set";\
	else\
		echo "export $(BLACKOPS_ENV_VAR_NAME)=$(BLACKOPS_ENV_VAR_VALUE)" >> "$(USER_HOME)/$(SHELL_ENV_FILE)";\
		echo "$(BLACKOPS_ENV_VAR_NAME) was set";\
	fi
	
	#adding some paths to $PATH
	echo "export PATH=$(PIP3_HOME):$(USER_HOME)/go/bin:$(GOROOT)/bin:$$PATH" >> "$(USER_HOME)/$(SHELL_ENV_FILE)";\
	echo "additional paths were added to PATH";\
	
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
	#Creating payloads folder
	if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER); then\
		echo "$(BLACKOPS_PAYLOADS_FOLDER) folder already exists";\
	else\
		echo "Creating $(BLACKOPS_PAYLOADS_FOLDER)";\
		mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER);\
	fi

#Download payloads
get-payloads: dont-run-as-root
	echo "Downloading payloads..."
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/*
	#Create required folders to drop payloads
	#cmd injection payloads folder
	if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_CMDINJECTION_FOLDER); then\
		echo "$(BLACKOPS_PAYL_CMDINJECTION_FOLDER) folder already exists";\
	else\
		echo "Creating $(BLACKOPS_PAYL_CMDINJECTION_FOLDER)";\
		mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_CMDINJECTION_FOLDER);\
	fi
	#directory traversal payloads folder
	if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_DIRTRAVERSAL_FOLDER); then\
		echo "$(BLACKOPS_PAYL_DIRTRAVERSAL_FOLDER) folder already exists";\
	else\
		echo "Creating $(BLACKOPS_PAYL_DIRTRAVERSAL_FOLDER)";\
		mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_DIRTRAVERSAL_FOLDER);\
	fi
	#file inclusion payloads folder
	if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_FILEINCLUSION_FOLDER); then\
		echo "$(BLACKOPS_PAYL_FILEINCLUSION_FOLDER) folder already exists";\
	else\
		echo "Creating $(BLACKOPS_PAYL_FILEINCLUSION_FOLDER)";\
		mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_FILEINCLUSION_FOLDER);\
	fi
	#insecure management interface folder
	if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_INSERCUREMGMTIFACE_FOLDER); then\
		echo "$(BLACKOPS_PAYL_INSERCUREMGMTIFACE_FOLDER) folder already exists";\
	else\
		echo "Creating $(BLACKOPS_PAYL_INSERCUREMGMTIFACE_FOLDER)";\
		mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_INSERCUREMGMTIFACE_FOLDER);\
	fi
	#ldap injection payloads folder
	if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_LDAPINJECTION_FOLDER); then\
		echo "$(BLACKOPS_PAYL_LDAPINJECTION_FOLDER) folder already exists";\
	else\
		echo "Creating $(BLACKOPS_PAYL_LDAPINJECTION_FOLDER)";\
		mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_LDAPINJECTION_FOLDER);\
	fi
	#nosql injection payloads folder
	if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_NOSQLINJECTION_FOLDER); then\
		echo "$(BLACKOPS_PAYL_NOSQLINJECTION_FOLDER) folder already exists";\
	else\
		echo "Creating $(BLACKOPS_PAYL_NOSQLINJECTION_FOLDER)";\
		mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_NOSQLINJECTION_FOLDER);\
	fi
	#open redirect payloads folder
	if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_OPENREDIRECT_FOLDER); then\
		echo "$(BLACKOPS_PAYL_OPENREDIRECT_FOLDER) folder already exists";\
	else\
		echo "Creating $(BLACKOPS_PAYL_OPENREDIRECT_FOLDER)";\
		mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_OPENREDIRECT_FOLDER);\
	fi
	#sql injection payloads folder
	if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_SQLINJECTION_FOLDER); then\
		echo "$(BLACKOPS_PAYL_SQLINJECTION_FOLDER) folder already exists";\
	else\
		echo "Creating $(BLACKOPS_PAYL_SQLINJECTION_FOLDER)";\
		mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_SQLINJECTION_FOLDER);\
	fi
	#ssti payloads folder
	if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_SSTI_FOLDER); then\
		echo "$(BLACKOPS_PAYL_SSTI_FOLDER) folder already exists";\
	else\
		echo "Creating $(BLACKOPS_PAYL_SSTI_FOLDER)";\
		mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_SSTI_FOLDER);\
	fi
	#xss payloads folder
	if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_XSS_FOLDER); then\
		echo "$(BLACKOPS_PAYL_XSS_FOLDER) folder already exists";\
	else\
		echo "Creating $(BLACKOPS_PAYL_XSS_FOLDER)";\
		mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_XSS_FOLDER);\
	fi
	#xxe payloads folder
	if test -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_XXE_FOLDER); then\
		echo "$(BLACKOPS_PAYL_XXE_FOLDER) folder already exists";\
	else\
		echo "Creating $(BLACKOPS_PAYL_XXE_FOLDER)";\
		mkdir $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_XXE_FOLDER);\
	fi
	
	### get payloads from github.com/swisskyrepo/PayloadsAllTheThings ###
	wget -O $(PAYLOADS_TMP_ZIP) https://github.com/swisskyrepo/PayloadsAllTheThings/archive/refs/heads/master.zip
	unzip -oj $(PAYLOADS_TMP_ZIP) "PayloadsAllTheThings-master/Command Injection/Intruder/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_CMDINJECTION_FOLDER)
	unzip -oj $(PAYLOADS_TMP_ZIP) "PayloadsAllTheThings-master/Directory Traversal/Intruder/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_DIRTRAVERSAL_FOLDER)
	unzip -oj $(PAYLOADS_TMP_ZIP) "PayloadsAllTheThings-master/File Inclusion/Intruders/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_FILEINCLUSION_FOLDER)
	unzip -oj $(PAYLOADS_TMP_ZIP) "PayloadsAllTheThings-master/Insecure Management Interface/Intruder/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_INSERCUREMGMTIFACE_FOLDER)
	unzip -oj $(PAYLOADS_TMP_ZIP) "PayloadsAllTheThings-master/LDAP Injection/Intruder/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_LDAPINJECTION_FOLDER)
	unzip -oj $(PAYLOADS_TMP_ZIP) "PayloadsAllTheThings-master/NoSQL Injection/Intruder/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_NOSQLINJECTION_FOLDER)
	unzip -oj $(PAYLOADS_TMP_ZIP) "PayloadsAllTheThings-master/Open Redirect/Intruder/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_OPENREDIRECT_FOLDER)
	unzip -oj $(PAYLOADS_TMP_ZIP) "PayloadsAllTheThings-master/SQL Injection/Intruder/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_SQLINJECTION_FOLDER)
	unzip -oj $(PAYLOADS_TMP_ZIP) "PayloadsAllTheThings-master/Server Side Template Injection/Intruder/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_SSTI_FOLDER)
	unzip -oj $(PAYLOADS_TMP_ZIP) "PayloadsAllTheThings-master/XSS Injection/Intruders/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_XSS_FOLDER)
	unzip -oj $(PAYLOADS_TMP_ZIP) "PayloadsAllTheThings-master/XXE Injection/Intruders/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_XXE_FOLDER)
	rm -f $(PAYLOADS_TMP_ZIP)
	
	###get seclists###
	sudo apt -y install seclists
	ln -s /usr/share/seclists/ $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)
	
	###get payloads from github.com/orgs/payloadbox
	wget -O $(PAYLOADS_TMP_ZIP) https://github.com/payloadbox/ssti-payloads/archive/refs/heads/master.zip
	unzip -oj $(PAYLOADS_TMP_ZIP) "ssti-payloads-master/Intruder/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_SSTI_FOLDER)
	rm -f $(PAYLOADS_TMP_ZIP)
	wget -O $(PAYLOADS_TMP_ZIP) https://github.com/payloadbox/xss-payload-list/archive/refs/heads/master.zip
	unzip -oj $(PAYLOADS_TMP_ZIP) "xss-payload-list-master/Intruder/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_XSS_FOLDER)
	rm -f $(PAYLOADS_TMP_ZIP)
	wget -O $(PAYLOADS_TMP_ZIP) https://github.com/payloadbox/sql-injection-payload-list/archive/refs/heads/master.zip
	unzip -oj $(PAYLOADS_TMP_ZIP) "sql-injection-payload-list-master/Intruder/detect/*" -d $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_PAYLOADS_FOLDER)/$(BLACKOPS_PAYL_SQLINJECTION_FOLDER)
	rm -f $(PAYLOADS_TMP_ZIP)

#Configure recon-ng
recon-ng-setup: dont-run-as-root
	echo "Configuring recon-ng..."
	sudo apt -y install recon-ng
	echo "marketplace install recon/domains-hosts/hackertarget" > /tmp/recon-ng.setup
	echo "marketplace install recon/domains-hosts/certificate_transparency" >> /tmp/recon-ng.setup
	echo "marketplace install recon/domains-hosts/mx_spf_ip" >> /tmp/recon-ng.setup
	echo "marketplace install recon/domains-hosts/bing_domain_web" >> /tmp/recon-ng.setup
	echo "marketplace install reporting/json" >> /tmp/recon-ng.setup
	echo "exit" >> /tmp/recon-ng.setup
	recon-ng -r /tmp/recon-ng.setup
	rm -f /tmp/recon-ng.setup
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/recon-ng
	cp -R etc/recon-ng $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/recon-ng/*.sh

#Configure censys
censys-setup: dont-run-as-root
	echo "Configuring censys..."
	pip3 install censys
	censys config
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/censys
	cp -R etc/censys $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/censys/*.sh

#Configure shodan
shodan-setup: dont-run-as-root
	echo "Configuring shodan..."
	pip3 install shodan
	@read -p "Shodan API key: " shodan_api_key;\
	shodan init $$shodan_api_key
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/shodan
	cp -R etc/shodan $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/shodan/*.sh

#Configure gobuster
gobuster-setup: dont-run-as-root
	echo "Configuring gobuster..."
	sudo apt -y install gobuster
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/gobuster
	cp -R etc/gobuster $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/gobuster/*.sh

#Configure whatweb
whatweb-setup: dont-run-as-root
	echo "Configuring whatweb..."
	sudo apt -y install whatweb
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/whatweb
	cp -R etc/whatweb $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/whatweb/*.sh

#Configure wpscan
wpscan-setup: dont-run-as-root
	echo "Configuring wpscan..."
	sudo apt -y install wpscan
	@read -p "WPScan API token: " wpscan_api_token;\
	echo "export $(WPSCAN_API_TOKEN_VAR_NAME)=$$wpscan_api_token" >> "$(USER_HOME)/$(SHELL_ENV_FILE)"
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/wpscan
	cp -R etc/wpscan $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/wpscan/*.sh

#Configure droopescan
droopescan-setup: dont-run-as-root
	echo "Configuring droopescan..."
	pip3 install droopescan
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/droopescan
	cp -R etc/droopescan $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/droopescan/*.sh

#Configure cloud_enum
cloud_enum-setup: dont-run-as-root
	echo "Configuring cloud_enum..."
	rm -rf etc/cloud_enum/bin
	git clone https://github.com/initstring/cloud_enum.git etc/cloud_enum/bin
	cd etc/cloud_enum/bin;\
	pip3 install -r requirements.txt
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/cloud_enum
	cp -R etc/cloud_enum $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/cloud_enum/*.sh

#Configure nuclei
nuclei-setup: dont-run-as-root
	echo "Configuring nuclei..."
	sudo apt -y install nuclei
	nuclei -ut
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/nuclei
	cp -R etc/nuclei $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/nuclei/*.sh

#Configure gospider (with urless for de-cluttering duplicate URLs)
gospider-setup: dont-run-as-root
	echo "Configuring gospider..."
	go install github.com/jaeles-project/gospider@latest
	rm -rf etc/gospider/urless
	git clone https://github.com/xnl-h4ck3r/urless.git etc/gospider/urless
	pip3 install urlparse3
	pip3 install termcolor
	pip3 install pyyaml
	pip3 install argparse
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/gospider
	cp -R etc/gospider $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/gospider/*.sh

#Configure XSpear
xspear-setup: dont-run-as-root
	echo "Configuring XSpear..."
	sudo gem install XSpear
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/XSpear
	cp -R etc/XSpear $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/XSpear/*.sh

#Configure dalfox
dalfox-setup: dont-run-as-root
	echo "Configuring dalfox..."
	go install github.com/hahwul/dalfox/v2@latest
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/dalfox
	cp -R etc/dalfox $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/dalfox/*.sh
	
#Configure nmap
nmap-setup: dont-run-as-root
	echo "Configuring nmap..."
	sudo apt -y install nmap
	sudo gem install nmap2json
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/nmap
	cp -R etc/nmap $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/nmap/*.sh
	
#Configure wapiti
wapiti-setup: dont-run-as-root
	echo "Configuring wapiti..."
	sudo apt -y install wapiti
	wapiti --update
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/wapiti
	cp -R etc/wapiti $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/wapiti/*.sh

#Configure sqlmap
sqlmap-setup: dont-run-as-root
	echo "Configuring sqlmap..."
	sudo apt -y install sqlmap
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/sqlmap
	cp -R etc/sqlmap $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/sqlmap/*.sh

#Configure paramspider
paramspider-setup: dont-run-as-root
	echo "Configuring ParamSpider..."
	rm -rf etc/ParamSpider/bin
	git clone https://github.com/devanshbatham/ParamSpider.git etc/ParamSpider/bin
	cd etc/ParamSpider/bin;\
	pip3 install -r requirements.txt
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/ParamSpider
	cp -R etc/ParamSpider $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/ParamSpider/*.sh

#Configure oralyzer
oralyzer-setup: dont-run-as-root
	echo "Configuring Oralyzer..."
	rm -rf etc/Oralyzer/bin
	git clone https://github.com/r0075h3ll/Oralyzer.git etc/Oralyzer/bin
	cd etc/Oralyzer/bin;\
	pip3 install -r requirements.txt
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/Oralyzer
	cp -R etc/Oralyzer $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/Oralyzer/*.sh

#Configure Corsy
corsy-setup: dont-run-as-root
	echo "Configuring Corsy..."
	rm -rf etc/Corsy/bin
	git clone https://github.com/s0md3v/Corsy.git etc/Corsy/bin
	cd etc/Corsy/bin;\
	pip3 install -r requirements.txt
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/Corsy
	cp -R etc/Corsy $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/Corsy/*.sh

#Configure XSStrike
xsstrike-setup: dont-run-as-root
	echo "Configuring XSStrike..."
	rm -rf etc/XSStrike/bin
	git clone https://github.com/s0md3v/XSStrike.git etc/XSStrike/bin
	cd etc/XSStrike/bin;\
	pip3 install -r requirements.txt
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/XSStrike
	cp -R etc/XSStrike $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/XSStrike/*.sh

#Configure CRLFsuite
crlfsuite-setup: dont-run-as-root
	echo "Configuring CRLFsuite..."
	pip3 install crlfsuite
	rm -rf $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/CRLFsuite
	cp -R etc/CRLFsuite $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)
	chmod +x $(BLACKOPS_ENV_VAR_VALUE)/$(BLACKOPS_ETC_FOLDER)/CRLFsuite/*.sh
