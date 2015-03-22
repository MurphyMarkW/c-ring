# System-specific parameters
# --------------- ----------
  # Automatic platform identification.
  PLATFORM := $(shell uname)

  # C and C++ compilers, respectively.
  GCC := gcc
  CXX := g++

  # Extra compiler flags to use.
  GCCEXTRA := -O3
  CXXEXTRA := -O3 -funroll-loops

  # Library directors and libraries to use.
  LIBDIRS := $(CURDIR)/lib

  # Source directors to use.
  INCDIRS := $(CURDIR)/include

  # Clean-up command.
  RM := rm -f
  CP := cp -f
  MK := mkdir -p


# Targets
# -------
  # C targets:
  CHEADERS := # C header files. *.h
  CSOURCES := src/ring.c # C source files. *.c
  COBJECTS := $(patsubst %.c,%.o,$(CSOURCES)) $(patsubst %.h,%.o,$(CHEADERS))

  # C++ targets:
  CPPHEADERS := # C++ header files. *.hpp
  CPPSOURCES := # C++ source files. *.cpp
  CPPOBJECTS := $(patsubst %.cpp,%.o,$(CPPSOURCES)) $(patsubst %.hpp,%.o,$(CPPHEADERS))

  OBJECTS := $(COBJECTS) $(CPPOBJECTS)

  # Libraries:
  LIBS := pthread

  # Outputs.
  ONAME := libring.so
  LIBDIR := $(CURDIR)/lib

  # Install directory.
  INSTALL := /usr/lib/

  # Various options.
  OPENMP := False # Open MP flag. True/False
  SHARED := True # Shared object flag. True/False


# Compiler / linker / loader flags
# -------- - ------ - ------ -----
LDFLAGS := $(patsubst %,-L%,$(LIBDIRS)) $(patsubst %,-l%,$(LIBS))
INCLUDE := $(patsubst %,-I%,$(INCDIRS))


ifeq ($(strip $(PLATFORM)),Linux) # Linux system specific options.
  GCCFLAGS := $(INCLUDE)
  CXXFLAGS := $(INCLUDE)

  ifeq ($(strip $(OPENMP)),True) # Open MP flags.
    GCCFLAGS += -fopenmp
    CXXFLAGS += -fopenmp
    SYSFLAGS += -fopenmp
  endif

  ifeq ($(strip $(SHARED)),True) # Shared object flags.
    # Flag for compiling with position-independent-code.
    GCCFLAGS += -fPIC
    CXXFLAGS += -fPIC
    # Flag for compiling as a shared object.
    SYSFLAGS += -shared
  endif
endif

ifeq ($(strip $(PLATFORM)),Darwin) # OS X system specific options.
  # Turn all warnings on.
  GCCFLAGS := $(INCLUDE)
  CXXFLAGS := $(INCLUDE)

  ifeq ($(strip $(OPENMP)),True) # Open MP flags.
    GCCFLAGS += -fopenmp
    CXXFLAGS += -fopenmp
    SYSFLAGS += -fopenmp
  endif

  ifeq ($(strip $(SHARED)),True) # Shared object flags.
    # Flag for compiling with position-independent-code.
    GCCFLAGS += -fPIC
    CXXFLAGS += -fPIC
    # Flag for compiling as a dynamic library.
    SYSFLAGS += -dynamiclib -Wl,-undefined,dynamic_lookup
  endif
endif

  

# Make Commands
# ---- --------
all: $(ONAME)

$(ONAME): $(OBJECTS)
	$(MK) $(LIBDIR)
	$(GCC) $(OBJECTS) $(SYSFLAGS) $(LDFLAGS) -o $(LIBDIR)/$(ONAME)

%.o: %.c
	$(GCC) $(GCCFLAGS) $(GCCEXTRA) -g -c $< -o $@

#%.o: %.h
#	$(GCC) $(GCCFLAGS) $(GCCEXTRA) -g -c $< -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(CXXEXTRA) -g -c $< -o $@

#%.o: %.hpp
#	$(CXX) $(CXXFLAGS) $(CXXEXTRA) -g -c $< -o $@

clean:
	$(RM) $(OBJECTS) $(LIBDIR)/$(ONAME)

install:
	$(CP) $(ONAME) $(INSTALL)
