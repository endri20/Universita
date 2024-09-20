#******************************************************************************#
#* MYSH	                                                                     *#
#******************************************************************************#
PACKAGE = mysh
VERSION = 0.1
RELEASE = 1


CC            = g++
CXX           = g++
CPPFLAGS        = -Wall 
RM            = rm -fr

all: mysh dist doc

#regole predefinite (vedi make -p):
#LINK.c   = $(CC)  $(CFLAGS)   $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH)
#LINK.cc  = $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH)
#LINK.cpp = $(LINK.cc)
#%: %.c   ; $(LINK.c)   $^ $(LOADLIBES) $(LDLIBS) -o $@
#%: %.cpp ; $(LINK.cpp) $^ $(LOADLIBES) $(LDLIBS) -o $@

clean: ; $(RM)  mysh  doc/

dist:  ; cd .. ; tar czvf \
	$(PACKAGE)-$(VERSION)/$(PACKAGE)-$(VERSION).tar.gz \
	$(PACKAGE)-$(VERSION)/mysh.cpp \
	$(PACKAGE)-$(VERSION)/Makefile \
	$(PACKAGE)-$(VERSION)/Doxyfile 

doc:   apidoc
apidoc: Doxyfile ; mkdir -p Doxygen;  doxygen

