#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_getppid(void)
{
    return myproc()->parent->pid;
}


int
sys_getadmin(void)
{
    char * pwd;
    if(argstr(0,&pwd)<0)
      return -1;

    if(strncmp(pwd,"2016025678",10)==0){
      myproc()->mode=1;
      return 0;
    }
    else 
      return -1;
}

int 
sys_setmemorylimit(void)
{
    int pid, limit;
    if(argint(0,&pid)<0 || argint(1,&limit)<0)
      return -1;
    if(limit<0)
      return -1;
    else
      return setmemorylimit(pid,limit);
}

int 
sys_proclist(void)
{
  proclist();
  return 0;
}

char*
sys_getshmem(void)
{
  int pid;
  if(argint(0,&pid)<0)
    return "shmem failed!\n";
  else
    return getshmem(pid);
}  
