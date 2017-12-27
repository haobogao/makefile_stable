#这是一个含有子目录的makefile 

#目标
DEST_OBJ=CMSIS


sub_dir = $(shell ls -l | grep ^d |awk '{ print $$9}' )

#依赖的子目录目标集合
sub_depend:= $(foreach N,$(sub_dir),$(N)/$(N))


#针对C文件 对应的 .o
CUR_SRC_C = ${wildcard *.c}
CUR_OBJ_C = $(patsubst %.c,%.o,$(CUR_SRC_C))
#针对汇编文件 对应的.o
CUR_SRC_S = ${wildcard *.s}
CUR_OBJ_S = $(patsubst %.s,%.o,$(CUR_SRC_S))
#当前目录下的所有.o
CUROBJ = $(CUR_OBJ_S) $(CUR_OBJ_C)



$(DEST_OBJ):$(CUROBJ) $(sub_depend)
	$(ld) $(ldflags) -r -o $(DEST_OBJ)  $(CUROBJ) $(sub_depend)

	
#依赖生成方式	
$(CUR_OBJ_C): %.o:%.c
	$(cc) -c $(cflags) $^ -o $@
#依赖生成方式
$(CUR_OBJ_S): %.o:%.s
	$(cc) -c $(cflags) $^ -o $@	

$(sub_depend):
	$(foreach N, $(sub_dir),make -C $(N);)
	
clean:
	rm -f $(CUROBJ) $(DEST_OBJ)
	$(foreach N, $(sub_dir),make clean -C $(N);)