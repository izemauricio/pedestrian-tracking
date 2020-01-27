# dir path
SRCDIR			= src
INCDIR			= include
LIBDIR			= lib
OBJDIR			= build
BINDIR			= bin

# binary target
TARGET			= $(BINDIR)/tracker

# where to search separeted by colon
VPATH 		= ./:$(SRCDIR)

# files finder
CPPFILESPATH	= $(wildcard $(SRCDIR)/*.cc)
CPPFILES    	= $(subst $(SRCDIR)/,,$(CPPFILESPATH))
OBJFILES 		= $(patsubst %.cc, %.o, $(CPPFILES))
OBJFILESPATH	= $(subst $(SRCDIR)/,$(OBJDIR)/,$(patsubst %.cc, %.o,$(CPPFILESPATH)))

# c++ compiler
CXX 			= g++

# c++ compiler flags
# -Wall -Wextra -Werror -O2 -g -I./include/ -stdlib=libc++ -std=c++11 -std=c++98 `pkg-config --cflags opencv347`
CXXFLAGS 		+= -std=c++11 -O0 -g -Wall
CXXFLAGS 		+= -I$(INCDIR)
CXXFLAGS 		+= -I/opt/intel/openvino/opencv/include
CXXFLAGS 		+= -I/usr/local/cuda/include

# linker
LD = g++

# linker flags
# -lstdc++
# -L/usr/local/opencv346/lib
# -L/usr/local/opt/opencv@3/lib
# -L$(LIBDIR) -ldarknet
# `pkg-config --libs opencv347`
# `pkg-config --libs opencv347` 
LDFLAGS += -L/usr/local/cuda/lib64 -lcuda -lcudart -lcublas -lcurand
LDFLAGS += -lcudnn
LDFLAGS += -L/opt/intel/openvino/opencv/lib -DOPENCV -lopencv_stitching -lopencv_superres -lopencv_videostab -lopencv_aruco -lopencv_bgsegm -lopencv_bioinspired -lopencv_ccalib -lopencv_dnn_objdetect -lopencv_dpm -lopencv_face -lopencv_freetype -lopencv_fuzzy -lopencv_hfs -lopencv_img_hash -lopencv_line_descriptor -lopencv_optflow -lopencv_reg -lopencv_rgbd -lopencv_saliency -lopencv_stereo -lopencv_structured_light -lopencv_phase_unwrapping -lopencv_surface_matching -lopencv_tracking -lopencv_datasets -lopencv_text -lopencv_highgui -lopencv_videoio -lopencv_dnn -lopencv_plot -lopencv_xfeatures2d -lopencv_shape -lopencv_video -lopencv_ml -lopencv_ximgproc -lopencv_xobjdetect -lopencv_objdetect -lopencv_calib3d -lopencv_imgcodecs -lopencv_features2d -lopencv_flann -lopencv_xphoto -lopencv_photo -lopencv_imgproc -lopencv_core
LDFLAGS += -pthread -lm # keep at end

.PHONY: all clean debug

all: debug $(TARGET)

clean:
	rm -r -f $(OBJDIR) $(OBJDIR)
	rm -f *~ *.bak *.o *.d

debug:
	@echo "======================="
	@echo SRCDIR = $(SRCDIR)
	@echo OBJDIR = $(OBJDIR)
	@echo CPPFILESPATH = $(CPPFILESPATH)
	@echo OBJFILESPATH = $(OBJFILESPATH)
	@echo CPPFILES = $(CPPFILES)
	@echo OBJFILES = $(OBJFILES)
	@echo TARGET = $(TARGET)
	@echo VPATH = $(VPATH)
	@echo LDFLAGS = $(LDFLAGS)
	@echo "======================="

$(TARGET) : $(OBJFILESPATH)
	mkdir -p $(@D)
	$(LD) $^ -o $(TARGET) $(LDFLAGS)

$(OBJDIR)/%.o : $(SRCDIR)/%.cc
	mkdir -p $(@D)
	$(CXX) -c $< -o $@ $(CXXFLAGS)
