CC = g++-7
CPPFLAGS = -Wall -O3 -std=c++17
LDFLAGS =

CPX_BASE    = /opt/ibm/ILOG/CPLEX_Studio128
CPX_INCDIR  = $(CPX_BASE)/cplex/include
CPX_LIBDIR  = $(CPX_BASE)/cplex/lib/x86-64_linux/static_pic
CPX_LDFLAGS = -lcplex -lm -pthread -ldl -lstdc++fs
PY_CFLAGS  	= $(shell python-config --cflags)
PY_LDFLAGS	= $(shell python-config --ldflags)
ODIR = build
SRCDIR = src
BIN = bin

OBJ = $(ODIR)/main.o $(ODIR)/CPLEX.o $(ODIR)/TSPsolution.o $(ODIR)/TSPinstance.o \
	$(ODIR)/Tour.o $(ODIR)/LK.o $(ODIR)/IteratedLK.o $(ODIR)/Pair.o

$(ODIR)/%.o: $(SRCDIR)/%.cpp
		$(CC) $(CPPFLAGS) -I$(CPX_INCDIR) -c $^ -o $@

main: $(OBJ)
		$(CC) $(PY_CFLAGS) $(CPPFLAGS) $(OBJ) -o $(BIN)/main -L$(CPX_LIBDIR) $(CPX_LDFLAGS) $(PY_LDFLAGS)

CAL = $(ODIR)/calibrate.o $(ODIR)/CPLEX.o $(ODIR)/TSPsolution.o $(ODIR)/TSPinstance.o \
	$(ODIR)/Tour.o $(ODIR)/LK.o $(ODIR)/IteratedLK.o $(ODIR)/Pair.o

calibrate: $(CAL)
		$(CC) $(CPPFLAGS) $(CAL) -o $(BIN)/calibrate -L$(CPX_LIBDIR) $(CPX_LDFLAGS)

clean:
		rm -rf $(OBJ) $(CAL) $(BIN)/main $(BIN)/calibrate $(SRCDIR)/*.pyc $(SRCDIR)/__pycache__

.PHONY: clean

$(shell mkdir -p $(ODIR) $(SRCDIR))
