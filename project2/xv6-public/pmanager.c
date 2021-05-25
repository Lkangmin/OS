#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
	int count=0;

	getadmin("2016025678");
	printf(1,"[Process Manager]\n");
	for (;;)
	{
		char word[60],path[50];
		int pid=-1,limit=0,size=0;

		printf(1,"\n> ");
		gets(word,60);
		word[strlen(word)-1]=0;
		if(word[0]=='e' && word[1]=='x' && word[2]=='e' && word[3] == 'c' && word[4]=='u' && word[5]== 't' && word[6]=='e')
		{
			for(int i=0;i<50;i++)
				path[i]=0;
			for(int i=0;i<50;i++)
			{
				if((word+8)[i]==32)  break;
				path[i]=(word+8)[i];
			}
			path[strlen(path)]=0;
			size=atoi(word+8+strlen(path)+1);		
			char *argv2[10]={path,0};
			if(fork() == 0){
				if(exec2(path,argv2,size)==-1)
					printf(1,"execute failed!\n");
				exit();
			}
			count++;
			continue;
		}
	
		else if(word[0]=='m' && word[1]=='e' && word[2]=='m' && word[3] == 'l' && word[4]=='i' && word[5]== 'm')
		{
			pid=atoi(word+7);
			for(int i=0;i<53;i++)
			{
				if((word+7)[i]==32){
					limit=atoi(word+7+i+1);
					break;
				}
			}
			if(setmemorylimit(pid,limit)==0)
				printf(1,"setmemorylimit success!\n");
			else
				printf(1,"setmemorylimit failed!\n");
		}

		else if(word[0]=='k' && word[1]=='i' && word[2]=='l' && word[3]=='l')
		{
			pid=atoi(word+5);
			if(kill(pid)==0 && pid!=0)
				printf(1,"kill success!!\n");
			else
				printf(1,"kill failed!\n");
		}

		else if(strcmp(word,"list")==0)
		{
			printf(1,"NAME\t\t\t/ PID /  TIME (ms)  /  MEMORY (bytes)  /  MEMLIM (bytes)\n");
			proclist();
		}

		else if(strcmp(word,"exit")==0)
			break;
	}		
	printf(1,"Bye!\n");	
	for(int i=0;i<count;i++)
		wait();
	exit();
	return 0;
}