# discover if this is a 32 or 64 bit machine
ARCH := $(shell getconf LONG_BIT)

CC = g++
ODIR = build/obj$(ARCH)
INC = -I../../common/include -I../../common -I../../interpreter -I../../bullet -I../../bullet/BulletCollision/CollisionShapes -I../../renderer
SUB_INC = INC = -I../../common/include -I../../common -I../../interpreter -I../../bullet -I../../bullet/BulletCollision/CollisionShapes -I../../renderer
CFLAGS = -O2
LDFLAGS32 = -L../../platform/linux/Lib/Release32
LDFLAGS64 = -L../../platform/linux/Lib/Release64
LDFLAGS = $(LDFLAGS$(ARCH)) -static-libstdc++ -static-libgcc

# list of object files to compile, they will be placed in the $(ODIR) folder
# matching .cpp files will be searched for below
_OBJS = Core_linux.o \
	AGKInput/InputDevice.o \
	AGKInput/Input.o \
	AGKInput/Binding.o \
	AGKInput/BindingMetadata.o \
	AGKInput/InputScheme.o \
	AGKInput/InputManager.o \
	AGKMenus/MenuItem.o \
	AGKMenus/MenuText.o \
	AGKMenus/GameMenu.o \
	AGKMenus/Color.o \
	AGKMenus/Point.o \
	AGKMenus/Shape.o \
	AGKMenus/Line.o \
	AGKMenus/Rectangle.o \
	Game/WorldView.o \
	Game/Game.o \
	template.o
OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))

# entry point, create folders, compile source files, and link the executable
all: setup $(OBJS) copy_images Executable

# make sure the build folders exist
setup:
	mkdir -p build/obj$(ARCH)/AGKInput
	mkdir -p build/obj$(ARCH)/AGKMenus
	mkdir -p build/obj$(ARCH)/Game
	mkdir -p build/img

# compile a source file, first search path is the template folder
#$(ODIR)/Submodule/%.o: core/Submodule/src/%.cpp
#	$(CC) -DIDE_LINUX -static -c $(INC) -o $@ $< $(CFLAGS)
	
$(ODIR)/AGKInput/%.o: core/AGKInput/src/%.cpp
	$(CC) -DIDE_LINUX -static -c $(INC) -o $@ $< $(CFLAGS)
	
$(ODIR)/AGKMenus/%.o: core/AGKMenus/src/%.cpp
	$(CC) -DIDE_LINUX -static -c $(INC) -o $@ $< $(CFLAGS)
	
# compile a source file, first search path is the template folder
$(ODIR)/%.o: core/src/%.cpp
	$(CC) -DIDE_LINUX -static -c $(INC) -o $@ $< $(CFLAGS)

copy_images:
	cp -r core/ build/

# link the .o files
Executable: | $(OBJS)
	$(CC) $(OBJS) -o build/AGKTier2Scene$(ARCH) $(LDFLAGS) -Wl,-Bstatic -lAGKLinux -lglfw3 -Wl,-Bdynamic -lGL -lXt -lX11 -lXxf86vm -lXrandr -lpthread -lXi -lXinerama -lXcursor -lopenal -ludev -ldl -no-pie

# delete compiled files
clean:
	rm -rf build/obj$(ARCH)/*
	rm -f build/AGKTier2Scene$(ARCH)
