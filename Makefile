CXX=g++
CXXFLAGS=-O2 -std=c++11 -fopenmp -Iinclude
NVCC=/usr/local/cuda/bin/nvcc
NVCCFLAGS=-gencode=arch=compute_70,code=sm_70 -gencode=arch=compute_60,code=sm_60 -O2 -std=c++11 -Iinclude

all : tric_gpu

tric_gpu : main.o tricount_gpu.o log.o gpu.o
	$(CXX) $(CXXFLAGS) -o tric_gpu main.o tricount_gpu.o log.o gpu.o -L /usr/local/cuda/lib64 -lcudart

main.o : src/main.cpp
	$(CXX) $(CXXFLAGS) -c src/main.cpp -o main.o

tricount_gpu.o : src/tricount_gpu.cu
	$(NVCC) $(NVCCFLAGS) -dc src/tricount_gpu.cu -o tricount_gpu.o

gpu.o : tricount_gpu.o
	$(NVCC) $(NVCCFLAGS) -dlink tricount_gpu.o -o gpu.o

log.o : src/log.cpp
	$(CXX) $(CXXFLAGS) -c src/log.cpp -o log.o

.PHONY : clean
clean :
	rm tric_gpu *.o

