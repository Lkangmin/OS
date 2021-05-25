#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
    
    int child=fork();
    
 
    if(child == 0){
        printf(1,"My pid is  %d\n",getpid());
    }    
    else{
        wait();
        printf(1,"My pid is  %d\n",getppid());
    }
  exit();
}
