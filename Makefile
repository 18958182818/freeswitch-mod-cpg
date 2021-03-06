INSTALL_PREFIX?=

CORODIR = $(INSTALL_PREFIX)/etc/corosync
INSTDIR = $(INSTALL_PREFIX)/opt/freeswitch
MODDIR = $(INSTDIR)/mod
BINDIR = $(INSTDIR)/bin
CONFDIR = $(INSTDIR)/conf/autoload_configs
CC=gcc
INCLUDE= -lcpg -lnl -I$(INSTDIR)/include
CFLAGS= -fPIC -Werror -fvisibility=hidden -DSWITCH_API_VISIBILITY=1 -DHAVE_VISIBILITY=1 -g -ggdb -g -O2 -Wall -std=c99 -pedantic -Wdeclaration-after-statement -D_GNU_SOURCE -DHAVE_CONFIG_H
LDFLAGS=
SOURCES= mod_cpg.c arpator.c node.c cpg_utils.c cpg_virtual_ip.c cpg_config.c fsm.c fsm_input.c
OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=mod_cpg.so

all: $(SOURCES) $(EXECUTABLE)
	
$(EXECUTABLE): $(OBJECTS) 
	$(CC) $(INCLUDE) $(CFLAGS) $(LDFLAGS) -lm -module -avoid-version -o mod_cpg.so -shared -Xlinker -x mod_cpg.o arpator.o node.o cpg_utils.o cpg_virtual_ip.o cpg_config.o fsm.o fsm_input.o 

.c.o:
	$(CC) $(INCLUDE) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o; \
	rm -f *.lo; \
	rm -f *.so; \
	rm -rf .libs;

install: all conf-install 
	mkdir -p $(MODDIR); \
	install *.so $(MODDIR);
	mkdir -p $(BINDIR); \
	install arbiter.sh $(BINDIR);

conf-install:
	mkdir -p $(CONFDIR); \
	if [ ! -f $(CONFDIR)/cpg.conf.xml ]; \
	then \
		echo "installing conf file"; \
		install cpg.conf.xml $(CONFDIR); \
	fi 
	mkdir -p $(CORODIR);	
	install corosync.conf $(CORODIR); 
	if [ ! -f $(CORODIR)/uidgid.d/freeswitch.corosync ]; \
	then \
		echo "installing corosync uidgig conf file"; \
		mkdir -p $(CORODIR)/uidgid.d; \
		install freeswitch.corosync $(CORODIR)/uidgid.d; \
	fi


uninstall:
	rm -f $(MODDIR)/mod_cpg.so
