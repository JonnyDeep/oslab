#define __LIBRARY__
#include<unistd.h>
#include<stdio.h>

_syscall2(int,whoami,char*, name,unsigned int,size);

int main(int argc,char *argv[]){
    char name[23];
    whoami(name,23);
    printf("%s\n",name); 
    return 0;
}
