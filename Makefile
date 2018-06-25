#PI_VERSION=v2.19.1-1
PI_VERSION=${VERSION}
VENV=~/venv

phony:
	@echo Build Jessie package for privacyIDEA
	@echo 
	@echo make clean
	@echo make init
	@echo make build


clean:
	rm -fr ~/src/privacyidea
	rm -fr  ${VENV}
init:
	make clean
	mkdir -p ~/OUT
	# checkout branch
	(cd ~/src; git clone --recursive https://github.com/privacyidea/privacyidea.git)
	(cd ~/src/privacyidea; git checkout ${PI_VERSION})
	# Install virtualenv
	@echo You now have to source ${VENV}
	virtualenv ${VENV}
	(. ${VENV}/bin/activate; pip install --upgrade setuptools pip)
	(. ${VENV}/bin/activate; pip install -r ~/src/privacyidea/requirements.txt)
	(. ${VENV}/bin/activate; pip install MySQL-python)

build:
	mkdir -p ~/src/privacyidea/DEBUILD
	# build package
	(. ${VENV}; cd ~/src/privacyidea; make venvdeb)
	cp ~/src/privacyidea/DEBUILD/*.deb  ~/OUT

ifndef VERSION
        $(error VERSION not set. Set VERSION to build like VERSION=v2.19.1)
endif
