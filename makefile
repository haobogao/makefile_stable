#这是一个项目根目录的makefile 

#目标
DEST_BIN=sunway_host.bin
ELF=sunway_host.elf
cross_tool= arm-none-eabi-
cc = $(cross_tool)gcc
ld = $(cross_tool)ld
ldflags= 

dir_root=$(shell pwd)
sub_dir =$(shell ls -l | grep ^d |awk '{ if( $$9 != "doc" && $$9 != "include" )  print $$9}' )
inc_dir =$(dir_root)/include
#依赖的子目录目标集合
sub_depend:= $(foreach N,$(sub_dir),$(N)/$(N))

INCLUDE=-I $(inc_dir)/app	\
		-I $(inc_dir)/bll	\
		-I $(inc_dir)/drv	\
		-I $(inc_dir)/finsh	\
		-I $(inc_dir)/std_drv	\
		-I $(inc_dir)			\
		-I /home/haobo/tools/arm-none-eabi/arm-none-eabi/include	\
		-I /home/haobo/tools/arm-none-eabi/arm-none-eabi/include/sys

cflags=	$(INCLUDE) -mthumb -mcpu=cortex-m3 -mthumb-interwork -Wall -O2  -mfloat-abi=soft \
		-ffunction-sections -fdata-sections 
		
link_gcc_lib= -static -L/home/haobo/tools/arm-none-eabi/lib/gcc/arm-none-eabi/7.2.1  -lgcc\
			  -L/home/haobo/tools/arm-none-eabi/arm-none-eabi/lib -lc -lnosys -nostartfiles

export cc ld  cflags ldflags link_gcc_lib
$(DEST_BIN):$(sub_depend)
	$(cc)  $(sub_depend) -Tldscript $(link_gcc_lib) -o $(ELF)
	$(cross_tool)objcopy  -O binary -S $(ELF) $(DEST_BIN)
	$(cross_tool)objdump -S -D -m arm $(ELF)>DUMP_INFO

$(sub_depend):
	$(foreach N, $(sub_dir),make -C $(N);)
	
load2board:
	./jlink_loader.sh
clean:
	rm -f  $(DEST_BIN) $(ELF)
	$(foreach N, $(sub_dir),make clean -C $(N);)