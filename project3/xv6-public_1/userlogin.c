#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"


int main(void)
{	
	char  userlist[10][16];
	char  passlist[10][16];


	for(;;)
	{
		int check=0;
		char  userid[16];
		char  userpass[16];
		int fp;

		if((fp=open("Accountlist",O_RDWR))<0)
		{
			close(fp);
			fp=open("Accountlist",O_CREATE|O_RDWR);
			strcpy(userlist[0],"root");
			strcpy(passlist[0],"1234");
			write(fp,userlist[0],16);
			write(fp,passlist[0],16);
		}
		else
		{
			for(int i=0;i<10;i++)
			{
				if(read(fp,userlist[i],16)<0) break;
				if(read(fp,passlist[i],16)<0) break;
			}
		}
		close(fp);


		printf(1,"Username: ");
		gets(userid,16);
		userid[strlen(userid)-1]=0;
		printf(1,"Password: ");
		gets(userpass,16);
		userpass[strlen(userpass)-1]=0;

		for(int i=0;i<10;i++)
		{
			if(strcmp(userid,userlist[i])==0 && strcmp(userpass,passlist[i])==0)
				check=1;
		}

		
		if(check)
		{
			int pid= fork();
			if(pid<0){
				printf(1,"fork fail!!\n");
				exit();
			}
			if(pid==0){
				char *input[]={0};
				strcpy(input[0],userid);
				exec("sh",input);
				printf(1, "init: sh failed\n");
	      		exit();
			}
			else
				wait();
		}
		else
			printf(1,"Wrong login information\n");
	}
	return 0;
}