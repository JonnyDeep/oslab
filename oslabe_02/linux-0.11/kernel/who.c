#include<asm/segment.h>
#include<errno.h>
#include<linux/kernel.h>

#define SIZE 23

char sys_name[SIZE+1];
static int NAME_LEN = 0;

int sys_iam(const char * name)
{
    printk("hello my first sys call\n"); 
    int i = 0;
    while(get_fs_byte(name+i)!='\0')
    {
        i++;
    }

    if(i>SIZE){
        printk("this name is longer than kernel max size: %d\n",SIZE);
        return -(EINVAL);
    }else {
        NAME_LEN = i;
        i = 0;

        for(i=0;i<NAME_LEN;i++){
            sys_name[i] = get_fs_byte(name+i);
        }

        sys_name[i] = '\n';
        printk("my name is %s\n",sys_name);

    }

    return NAME_LEN;
}

int sys_whoami(char * name,unsigned int size)
{
    if(NAME_LEN == 0){
        printk("no kernel name\n");
        return -(EINVAL);
    }
    printk("sys call whoami\n");
    if(size>SIZE){
        printk("name length max size: %d\n",SIZE);
        return -(EINVAL);
    }

    int i=0;
    for(i=0;i<size;i++){
        put_fs_byte(sys_name[i],name+i);
    }
    put_fs_byte('\0',name+i);
    return NAME_LEN;
}
