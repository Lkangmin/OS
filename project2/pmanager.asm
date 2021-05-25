
_pmanager:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	8d 5d ac             	lea    -0x54(%ebp),%ebx
	int count=0;
  14:	31 f6                	xor    %esi,%esi
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
  16:	81 ec c4 00 00 00    	sub    $0xc4,%esp
	int count=0;

	getadmin("2016025678");
  1c:	68 30 0a 00 00       	push   $0xa30
  21:	e8 1c 06 00 00       	call   642 <getadmin>
	printf(1,"[Process Manager]\n");
  26:	58                   	pop    %eax
  27:	5a                   	pop    %edx
  28:	68 3b 0a 00 00       	push   $0xa3b
  2d:	6a 01                	push   $0x1
  2f:	e8 dc 06 00 00       	call   710 <printf>
  34:	83 c4 10             	add    $0x10,%esp
  37:	89 f6                	mov    %esi,%esi
  39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	for (;;)
	{
		char word[60],path[50];
		int pid=-1,limit=0,size=0;

		printf(1,"\n> ");
  40:	83 ec 08             	sub    $0x8,%esp
  43:	68 4e 0a 00 00       	push   $0xa4e
  48:	6a 01                	push   $0x1
  4a:	e8 c1 06 00 00       	call   710 <printf>
		gets(word,60);
  4f:	5f                   	pop    %edi
  50:	58                   	pop    %eax
  51:	6a 3c                	push   $0x3c
  53:	53                   	push   %ebx
  54:	e8 07 04 00 00       	call   460 <gets>
		word[strlen(word)-1]=0;
  59:	89 1c 24             	mov    %ebx,(%esp)
  5c:	e8 6f 03 00 00       	call   3d0 <strlen>
  61:	c6 44 05 ab 00       	movb   $0x0,-0x55(%ebp,%eax,1)
		if(word[0]=='e' && word[1]=='x' && word[2]=='e' && word[3] == 'c' && word[4]=='u' && word[5]== 't' && word[6]=='e')
  66:	0f b6 45 ac          	movzbl -0x54(%ebp),%eax
  6a:	83 c4 10             	add    $0x10,%esp
  6d:	3c 65                	cmp    $0x65,%al
  6f:	0f 84 33 01 00 00    	je     1a8 <main+0x1a8>
			}
			count++;
			continue;
		}
	
		else if(word[0]=='m' && word[1]=='e' && word[2]=='m' && word[3] == 'l' && word[4]=='i' && word[5]== 'm')
  75:	3c 6d                	cmp    $0x6d,%al
  77:	0f 84 93 00 00 00    	je     110 <main+0x110>
				printf(1,"setmemorylimit success!\n");
			else
				printf(1,"setmemorylimit failed!\n");
		}

		else if(word[0]=='k' && word[1]=='i' && word[2]=='l' && word[3]=='l')
  7d:	3c 6b                	cmp    $0x6b,%al
  7f:	75 0a                	jne    8b <main+0x8b>
  81:	80 7d ad 69          	cmpb   $0x69,-0x53(%ebp)
  85:	0f 84 05 02 00 00    	je     290 <main+0x290>
				printf(1,"kill success!!\n");
			else
				printf(1,"kill failed!\n");
		}

		else if(strcmp(word,"list")==0)
  8b:	83 ec 08             	sub    $0x8,%esp
  8e:	68 b2 0a 00 00       	push   $0xab2
  93:	53                   	push   %ebx
  94:	e8 e7 02 00 00       	call   380 <strcmp>
  99:	83 c4 10             	add    $0x10,%esp
  9c:	85 c0                	test   %eax,%eax
  9e:	75 20                	jne    c0 <main+0xc0>
		{
			printf(1,"NAME\t\t\t/ PID /  TIME (ms)  /  MEMORY (bytes)  /  MEMLIM (bytes)\n");
  a0:	83 ec 08             	sub    $0x8,%esp
  a3:	68 c4 0a 00 00       	push   $0xac4
  a8:	6a 01                	push   $0x1
  aa:	e8 61 06 00 00       	call   710 <printf>
			proclist();
  af:	e8 a6 05 00 00       	call   65a <proclist>
  b4:	83 c4 10             	add    $0x10,%esp
  b7:	eb 87                	jmp    40 <main+0x40>
  b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		}

		else if(strcmp(word,"exit")==0)
  c0:	83 ec 08             	sub    $0x8,%esp
  c3:	68 b7 0a 00 00       	push   $0xab7
  c8:	53                   	push   %ebx
  c9:	e8 b2 02 00 00       	call   380 <strcmp>
  ce:	83 c4 10             	add    $0x10,%esp
  d1:	85 c0                	test   %eax,%eax
  d3:	0f 85 67 ff ff ff    	jne    40 <main+0x40>
			break;
	}		
	printf(1,"Bye!\n");	
  d9:	83 ec 08             	sub    $0x8,%esp
  dc:	68 bc 0a 00 00       	push   $0xabc
  e1:	6a 01                	push   $0x1
  e3:	e8 28 06 00 00       	call   710 <printf>
	for(int i=0;i<count;i++)
  e8:	83 c4 10             	add    $0x10,%esp
  eb:	85 f6                	test   %esi,%esi
  ed:	74 15                	je     104 <main+0x104>
  ef:	31 db                	xor    %ebx,%ebx
  f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  f8:	83 c3 01             	add    $0x1,%ebx
		wait();
  fb:	e8 9a 04 00 00       	call   59a <wait>

		else if(strcmp(word,"exit")==0)
			break;
	}		
	printf(1,"Bye!\n");	
	for(int i=0;i<count;i++)
 100:	39 de                	cmp    %ebx,%esi
 102:	75 f4                	jne    f8 <main+0xf8>
			size=atoi(word+8+strlen(path)+1);		
			char *argv2[10]={path,0};
			if(fork() == 0){
				if(exec2(path,argv2,size)==-1)
					printf(1,"execute failed!\n");
				exit();
 104:	e8 89 04 00 00       	call   592 <exit>
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			}
			count++;
			continue;
		}
	
		else if(word[0]=='m' && word[1]=='e' && word[2]=='m' && word[3] == 'l' && word[4]=='i' && word[5]== 'm')
 110:	80 7d ad 65          	cmpb   $0x65,-0x53(%ebp)
 114:	0f 85 71 ff ff ff    	jne    8b <main+0x8b>
 11a:	80 7d ae 6d          	cmpb   $0x6d,-0x52(%ebp)
 11e:	0f 85 67 ff ff ff    	jne    8b <main+0x8b>
 124:	80 7d af 6c          	cmpb   $0x6c,-0x51(%ebp)
 128:	0f 85 5d ff ff ff    	jne    8b <main+0x8b>
 12e:	80 7d b0 69          	cmpb   $0x69,-0x50(%ebp)
 132:	0f 85 53 ff ff ff    	jne    8b <main+0x8b>
 138:	80 7d b1 6d          	cmpb   $0x6d,-0x4f(%ebp)
 13c:	0f 85 49 ff ff ff    	jne    8b <main+0x8b>
		{
			pid=atoi(word+7);
 142:	8d 45 b3             	lea    -0x4d(%ebp),%eax
 145:	83 ec 0c             	sub    $0xc,%esp
 148:	50                   	push   %eax
 149:	e8 d2 03 00 00       	call   520 <atoi>
 14e:	83 c4 10             	add    $0x10,%esp
 151:	89 c7                	mov    %eax,%edi
			for(int i=0;i<53;i++)
 153:	31 c0                	xor    %eax,%eax
 155:	eb 0c                	jmp    163 <main+0x163>
 157:	83 c0 01             	add    $0x1,%eax
 15a:	83 f8 35             	cmp    $0x35,%eax
 15d:	0f 84 8e 01 00 00    	je     2f1 <main+0x2f1>
			{
				if((word+7)[i]==32){
 163:	80 7c 05 b3 20       	cmpb   $0x20,-0x4d(%ebp,%eax,1)
 168:	75 ed                	jne    157 <main+0x157>
					limit=atoi(word+7+i+1);
 16a:	8d 44 03 08          	lea    0x8(%ebx,%eax,1),%eax
 16e:	83 ec 0c             	sub    $0xc,%esp
 171:	50                   	push   %eax
 172:	e8 a9 03 00 00       	call   520 <atoi>
					break;
 177:	83 c4 10             	add    $0x10,%esp
				}
			}
			if(setmemorylimit(pid,limit)==0)
 17a:	52                   	push   %edx
 17b:	52                   	push   %edx
 17c:	50                   	push   %eax
 17d:	57                   	push   %edi
 17e:	e8 cf 04 00 00       	call   652 <setmemorylimit>
 183:	83 c4 10             	add    $0x10,%esp
 186:	85 c0                	test   %eax,%eax
 188:	0f 85 6a 01 00 00    	jne    2f8 <main+0x2f8>
				printf(1,"setmemorylimit success!\n");
 18e:	57                   	push   %edi
 18f:	57                   	push   %edi
 190:	68 63 0a 00 00       	push   $0xa63
 195:	6a 01                	push   $0x1
 197:	e8 74 05 00 00       	call   710 <printf>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	e9 9c fe ff ff       	jmp    40 <main+0x40>
 1a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		int pid=-1,limit=0,size=0;

		printf(1,"\n> ");
		gets(word,60);
		word[strlen(word)-1]=0;
		if(word[0]=='e' && word[1]=='x' && word[2]=='e' && word[3] == 'c' && word[4]=='u' && word[5]== 't' && word[6]=='e')
 1a8:	80 7d ad 78          	cmpb   $0x78,-0x53(%ebp)
 1ac:	0f 85 d9 fe ff ff    	jne    8b <main+0x8b>
 1b2:	80 7d ae 65          	cmpb   $0x65,-0x52(%ebp)
 1b6:	0f 85 cf fe ff ff    	jne    8b <main+0x8b>
 1bc:	80 7d af 63          	cmpb   $0x63,-0x51(%ebp)
 1c0:	0f 85 c5 fe ff ff    	jne    8b <main+0x8b>
 1c6:	80 7d b0 75          	cmpb   $0x75,-0x50(%ebp)
 1ca:	0f 85 bb fe ff ff    	jne    8b <main+0x8b>
 1d0:	80 7d b1 74          	cmpb   $0x74,-0x4f(%ebp)
 1d4:	0f 85 b1 fe ff ff    	jne    8b <main+0x8b>
 1da:	80 7d b2 65          	cmpb   $0x65,-0x4e(%ebp)
 1de:	0f 85 a7 fe ff ff    	jne    8b <main+0x8b>
 1e4:	8d 95 7a ff ff ff    	lea    -0x86(%ebp),%edx
 1ea:	31 c0                	xor    %eax,%eax
		{
			for(int i=0;i<50;i++)
				path[i]=0;
 1ec:	c6 04 02 00          	movb   $0x0,(%edx,%eax,1)
		printf(1,"\n> ");
		gets(word,60);
		word[strlen(word)-1]=0;
		if(word[0]=='e' && word[1]=='x' && word[2]=='e' && word[3] == 'c' && word[4]=='u' && word[5]== 't' && word[6]=='e')
		{
			for(int i=0;i<50;i++)
 1f0:	83 c0 01             	add    $0x1,%eax
 1f3:	83 f8 32             	cmp    $0x32,%eax
 1f6:	75 f4                	jne    1ec <main+0x1ec>
 1f8:	31 c0                	xor    %eax,%eax
 1fa:	eb 0b                	jmp    207 <main+0x207>
				path[i]=0;
			for(int i=0;i<50;i++)
			{
				if((word+8)[i]==32)  break;
				path[i]=(word+8)[i];
 1fc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
		word[strlen(word)-1]=0;
		if(word[0]=='e' && word[1]=='x' && word[2]=='e' && word[3] == 'c' && word[4]=='u' && word[5]== 't' && word[6]=='e')
		{
			for(int i=0;i<50;i++)
				path[i]=0;
			for(int i=0;i<50;i++)
 1ff:	83 c0 01             	add    $0x1,%eax
 202:	83 f8 32             	cmp    $0x32,%eax
 205:	74 0a                	je     211 <main+0x211>
			{
				if((word+8)[i]==32)  break;
 207:	0f b6 4c 05 b4       	movzbl -0x4c(%ebp,%eax,1),%ecx
 20c:	80 f9 20             	cmp    $0x20,%cl
 20f:	75 eb                	jne    1fc <main+0x1fc>
				path[i]=(word+8)[i];
			}
			path[strlen(path)]=0;
 211:	83 ec 0c             	sub    $0xc,%esp
 214:	89 95 44 ff ff ff    	mov    %edx,-0xbc(%ebp)
			size=atoi(word+8+strlen(path)+1);		
			char *argv2[10]={path,0};
 21a:	8d bd 50 ff ff ff    	lea    -0xb0(%ebp),%edi
			for(int i=0;i<50;i++)
			{
				if((word+8)[i]==32)  break;
				path[i]=(word+8)[i];
			}
			path[strlen(path)]=0;
 220:	52                   	push   %edx
 221:	e8 aa 01 00 00       	call   3d0 <strlen>
			size=atoi(word+8+strlen(path)+1);		
 226:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
			for(int i=0;i<50;i++)
			{
				if((word+8)[i]==32)  break;
				path[i]=(word+8)[i];
			}
			path[strlen(path)]=0;
 22c:	c6 84 05 7a ff ff ff 	movb   $0x0,-0x86(%ebp,%eax,1)
 233:	00 
			size=atoi(word+8+strlen(path)+1);		
 234:	89 14 24             	mov    %edx,(%esp)
 237:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
 23d:	e8 8e 01 00 00       	call   3d0 <strlen>
 242:	8d 44 03 09          	lea    0x9(%ebx,%eax,1),%eax
 246:	89 04 24             	mov    %eax,(%esp)
 249:	e8 d2 02 00 00       	call   520 <atoi>
			char *argv2[10]={path,0};
 24e:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
			{
				if((word+8)[i]==32)  break;
				path[i]=(word+8)[i];
			}
			path[strlen(path)]=0;
			size=atoi(word+8+strlen(path)+1);		
 254:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			char *argv2[10]={path,0};
 25a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 25f:	31 c0                	xor    %eax,%eax
 261:	f3 ab                	rep stos %eax,%es:(%edi)
 263:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
			if(fork() == 0){
 269:	e8 1c 03 00 00       	call   58a <fork>
 26e:	83 c4 10             	add    $0x10,%esp
 271:	85 c0                	test   %eax,%eax
 273:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
 279:	0f 84 8f 00 00 00    	je     30e <main+0x30e>
				if(exec2(path,argv2,size)==-1)
					printf(1,"execute failed!\n");
				exit();
			}
			count++;
 27f:	83 c6 01             	add    $0x1,%esi
 282:	e9 b9 fd ff ff       	jmp    40 <main+0x40>
 287:	89 f6                	mov    %esi,%esi
 289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
				printf(1,"setmemorylimit success!\n");
			else
				printf(1,"setmemorylimit failed!\n");
		}

		else if(word[0]=='k' && word[1]=='i' && word[2]=='l' && word[3]=='l')
 290:	80 7d ae 6c          	cmpb   $0x6c,-0x52(%ebp)
 294:	0f 85 f1 fd ff ff    	jne    8b <main+0x8b>
 29a:	80 7d af 6c          	cmpb   $0x6c,-0x51(%ebp)
 29e:	0f 85 e7 fd ff ff    	jne    8b <main+0x8b>
		{
			pid=atoi(word+5);
 2a4:	8d 45 b1             	lea    -0x4f(%ebp),%eax
 2a7:	83 ec 0c             	sub    $0xc,%esp
 2aa:	50                   	push   %eax
 2ab:	e8 70 02 00 00       	call   520 <atoi>
 2b0:	89 c7                	mov    %eax,%edi
			if(kill(pid)==0 && pid!=0)
 2b2:	89 04 24             	mov    %eax,(%esp)
 2b5:	e8 08 03 00 00       	call   5c2 <kill>
 2ba:	83 c4 10             	add    $0x10,%esp
 2bd:	85 ff                	test   %edi,%edi
 2bf:	74 04                	je     2c5 <main+0x2c5>
 2c1:	85 c0                	test   %eax,%eax
 2c3:	74 16                	je     2db <main+0x2db>
				printf(1,"kill success!!\n");
			else
				printf(1,"kill failed!\n");
 2c5:	50                   	push   %eax
 2c6:	50                   	push   %eax
 2c7:	68 a4 0a 00 00       	push   $0xaa4
 2cc:	6a 01                	push   $0x1
 2ce:	e8 3d 04 00 00       	call   710 <printf>
 2d3:	83 c4 10             	add    $0x10,%esp
 2d6:	e9 65 fd ff ff       	jmp    40 <main+0x40>

		else if(word[0]=='k' && word[1]=='i' && word[2]=='l' && word[3]=='l')
		{
			pid=atoi(word+5);
			if(kill(pid)==0 && pid!=0)
				printf(1,"kill success!!\n");
 2db:	52                   	push   %edx
 2dc:	52                   	push   %edx
 2dd:	68 94 0a 00 00       	push   $0xa94
 2e2:	6a 01                	push   $0x1
 2e4:	e8 27 04 00 00       	call   710 <printf>
 2e9:	83 c4 10             	add    $0x10,%esp
 2ec:	e9 4f fd ff ff       	jmp    40 <main+0x40>
	getadmin("2016025678");
	printf(1,"[Process Manager]\n");
	for (;;)
	{
		char word[60],path[50];
		int pid=-1,limit=0,size=0;
 2f1:	31 c0                	xor    %eax,%eax
 2f3:	e9 82 fe ff ff       	jmp    17a <main+0x17a>
				}
			}
			if(setmemorylimit(pid,limit)==0)
				printf(1,"setmemorylimit success!\n");
			else
				printf(1,"setmemorylimit failed!\n");
 2f8:	51                   	push   %ecx
 2f9:	51                   	push   %ecx
 2fa:	68 7c 0a 00 00       	push   $0xa7c
 2ff:	6a 01                	push   $0x1
 301:	e8 0a 04 00 00       	call   710 <printf>
 306:	83 c4 10             	add    $0x10,%esp
 309:	e9 32 fd ff ff       	jmp    40 <main+0x40>
			}
			path[strlen(path)]=0;
			size=atoi(word+8+strlen(path)+1);		
			char *argv2[10]={path,0};
			if(fork() == 0){
				if(exec2(path,argv2,size)==-1)
 30e:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
 314:	53                   	push   %ebx
 315:	ff b5 44 ff ff ff    	pushl  -0xbc(%ebp)
 31b:	50                   	push   %eax
 31c:	52                   	push   %edx
 31d:	e8 28 03 00 00       	call   64a <exec2>
 322:	83 c4 10             	add    $0x10,%esp
 325:	83 c0 01             	add    $0x1,%eax
 328:	0f 85 d6 fd ff ff    	jne    104 <main+0x104>
					printf(1,"execute failed!\n");
 32e:	51                   	push   %ecx
 32f:	51                   	push   %ecx
 330:	68 52 0a 00 00       	push   $0xa52
 335:	6a 01                	push   $0x1
 337:	e8 d4 03 00 00       	call   710 <printf>
 33c:	83 c4 10             	add    $0x10,%esp
 33f:	e9 c0 fd ff ff       	jmp    104 <main+0x104>
 344:	66 90                	xchg   %ax,%ax
 346:	66 90                	xchg   %ax,%ax
 348:	66 90                	xchg   %ax,%ax
 34a:	66 90                	xchg   %ax,%ax
 34c:	66 90                	xchg   %ax,%ax
 34e:	66 90                	xchg   %ax,%ax

00000350 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	53                   	push   %ebx
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 35a:	89 c2                	mov    %eax,%edx
 35c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 360:	83 c1 01             	add    $0x1,%ecx
 363:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 367:	83 c2 01             	add    $0x1,%edx
 36a:	84 db                	test   %bl,%bl
 36c:	88 5a ff             	mov    %bl,-0x1(%edx)
 36f:	75 ef                	jne    360 <strcpy+0x10>
    ;
  return os;
}
 371:	5b                   	pop    %ebx
 372:	5d                   	pop    %ebp
 373:	c3                   	ret    
 374:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 37a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000380 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	56                   	push   %esi
 384:	53                   	push   %ebx
 385:	8b 55 08             	mov    0x8(%ebp),%edx
 388:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 38b:	0f b6 02             	movzbl (%edx),%eax
 38e:	0f b6 19             	movzbl (%ecx),%ebx
 391:	84 c0                	test   %al,%al
 393:	75 1e                	jne    3b3 <strcmp+0x33>
 395:	eb 29                	jmp    3c0 <strcmp+0x40>
 397:	89 f6                	mov    %esi,%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 3a0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3a3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 3a6:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3a9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 3ad:	84 c0                	test   %al,%al
 3af:	74 0f                	je     3c0 <strcmp+0x40>
 3b1:	89 f1                	mov    %esi,%ecx
 3b3:	38 d8                	cmp    %bl,%al
 3b5:	74 e9                	je     3a0 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3b7:	29 d8                	sub    %ebx,%eax
}
 3b9:	5b                   	pop    %ebx
 3ba:	5e                   	pop    %esi
 3bb:	5d                   	pop    %ebp
 3bc:	c3                   	ret    
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3c0:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3c2:	29 d8                	sub    %ebx,%eax
}
 3c4:	5b                   	pop    %ebx
 3c5:	5e                   	pop    %esi
 3c6:	5d                   	pop    %ebp
 3c7:	c3                   	ret    
 3c8:	90                   	nop
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003d0 <strlen>:

uint
strlen(const char *s)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3d6:	80 39 00             	cmpb   $0x0,(%ecx)
 3d9:	74 12                	je     3ed <strlen+0x1d>
 3db:	31 d2                	xor    %edx,%edx
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
 3e0:	83 c2 01             	add    $0x1,%edx
 3e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3e7:	89 d0                	mov    %edx,%eax
 3e9:	75 f5                	jne    3e0 <strlen+0x10>
    ;
  return n;
}
 3eb:	5d                   	pop    %ebp
 3ec:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 3ed:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 3ef:	5d                   	pop    %ebp
 3f0:	c3                   	ret    
 3f1:	eb 0d                	jmp    400 <memset>
 3f3:	90                   	nop
 3f4:	90                   	nop
 3f5:	90                   	nop
 3f6:	90                   	nop
 3f7:	90                   	nop
 3f8:	90                   	nop
 3f9:	90                   	nop
 3fa:	90                   	nop
 3fb:	90                   	nop
 3fc:	90                   	nop
 3fd:	90                   	nop
 3fe:	90                   	nop
 3ff:	90                   	nop

00000400 <memset>:

void*
memset(void *dst, int c, uint n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 407:	8b 4d 10             	mov    0x10(%ebp),%ecx
 40a:	8b 45 0c             	mov    0xc(%ebp),%eax
 40d:	89 d7                	mov    %edx,%edi
 40f:	fc                   	cld    
 410:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 412:	89 d0                	mov    %edx,%eax
 414:	5f                   	pop    %edi
 415:	5d                   	pop    %ebp
 416:	c3                   	ret    
 417:	89 f6                	mov    %esi,%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000420 <strchr>:

char*
strchr(const char *s, char c)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	53                   	push   %ebx
 424:	8b 45 08             	mov    0x8(%ebp),%eax
 427:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 42a:	0f b6 10             	movzbl (%eax),%edx
 42d:	84 d2                	test   %dl,%dl
 42f:	74 1d                	je     44e <strchr+0x2e>
    if(*s == c)
 431:	38 d3                	cmp    %dl,%bl
 433:	89 d9                	mov    %ebx,%ecx
 435:	75 0d                	jne    444 <strchr+0x24>
 437:	eb 17                	jmp    450 <strchr+0x30>
 439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 440:	38 ca                	cmp    %cl,%dl
 442:	74 0c                	je     450 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 444:	83 c0 01             	add    $0x1,%eax
 447:	0f b6 10             	movzbl (%eax),%edx
 44a:	84 d2                	test   %dl,%dl
 44c:	75 f2                	jne    440 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 44e:	31 c0                	xor    %eax,%eax
}
 450:	5b                   	pop    %ebx
 451:	5d                   	pop    %ebp
 452:	c3                   	ret    
 453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000460 <gets>:

char*
gets(char *buf, int max)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 466:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 468:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 46b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 46e:	eb 29                	jmp    499 <gets+0x39>
    cc = read(0, &c, 1);
 470:	83 ec 04             	sub    $0x4,%esp
 473:	6a 01                	push   $0x1
 475:	57                   	push   %edi
 476:	6a 00                	push   $0x0
 478:	e8 2d 01 00 00       	call   5aa <read>
    if(cc < 1)
 47d:	83 c4 10             	add    $0x10,%esp
 480:	85 c0                	test   %eax,%eax
 482:	7e 1d                	jle    4a1 <gets+0x41>
      break;
    buf[i++] = c;
 484:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 488:	8b 55 08             	mov    0x8(%ebp),%edx
 48b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 48d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 48f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 493:	74 1b                	je     4b0 <gets+0x50>
 495:	3c 0d                	cmp    $0xd,%al
 497:	74 17                	je     4b0 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 499:	8d 5e 01             	lea    0x1(%esi),%ebx
 49c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 49f:	7c cf                	jl     470 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 4a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ab:	5b                   	pop    %ebx
 4ac:	5e                   	pop    %esi
 4ad:	5f                   	pop    %edi
 4ae:	5d                   	pop    %ebp
 4af:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4b3:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4b5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 4b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4bc:	5b                   	pop    %ebx
 4bd:	5e                   	pop    %esi
 4be:	5f                   	pop    %edi
 4bf:	5d                   	pop    %ebp
 4c0:	c3                   	ret    
 4c1:	eb 0d                	jmp    4d0 <stat>
 4c3:	90                   	nop
 4c4:	90                   	nop
 4c5:	90                   	nop
 4c6:	90                   	nop
 4c7:	90                   	nop
 4c8:	90                   	nop
 4c9:	90                   	nop
 4ca:	90                   	nop
 4cb:	90                   	nop
 4cc:	90                   	nop
 4cd:	90                   	nop
 4ce:	90                   	nop
 4cf:	90                   	nop

000004d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	56                   	push   %esi
 4d4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d5:	83 ec 08             	sub    $0x8,%esp
 4d8:	6a 00                	push   $0x0
 4da:	ff 75 08             	pushl  0x8(%ebp)
 4dd:	e8 f0 00 00 00       	call   5d2 <open>
  if(fd < 0)
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	85 c0                	test   %eax,%eax
 4e7:	78 27                	js     510 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4e9:	83 ec 08             	sub    $0x8,%esp
 4ec:	ff 75 0c             	pushl  0xc(%ebp)
 4ef:	89 c3                	mov    %eax,%ebx
 4f1:	50                   	push   %eax
 4f2:	e8 f3 00 00 00       	call   5ea <fstat>
 4f7:	89 c6                	mov    %eax,%esi
  close(fd);
 4f9:	89 1c 24             	mov    %ebx,(%esp)
 4fc:	e8 b9 00 00 00       	call   5ba <close>
  return r;
 501:	83 c4 10             	add    $0x10,%esp
 504:	89 f0                	mov    %esi,%eax
}
 506:	8d 65 f8             	lea    -0x8(%ebp),%esp
 509:	5b                   	pop    %ebx
 50a:	5e                   	pop    %esi
 50b:	5d                   	pop    %ebp
 50c:	c3                   	ret    
 50d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 515:	eb ef                	jmp    506 <stat+0x36>
 517:	89 f6                	mov    %esi,%esi
 519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000520 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	53                   	push   %ebx
 524:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 527:	0f be 11             	movsbl (%ecx),%edx
 52a:	8d 42 d0             	lea    -0x30(%edx),%eax
 52d:	3c 09                	cmp    $0x9,%al
 52f:	b8 00 00 00 00       	mov    $0x0,%eax
 534:	77 1f                	ja     555 <atoi+0x35>
 536:	8d 76 00             	lea    0x0(%esi),%esi
 539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 540:	8d 04 80             	lea    (%eax,%eax,4),%eax
 543:	83 c1 01             	add    $0x1,%ecx
 546:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 54a:	0f be 11             	movsbl (%ecx),%edx
 54d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 550:	80 fb 09             	cmp    $0x9,%bl
 553:	76 eb                	jbe    540 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 555:	5b                   	pop    %ebx
 556:	5d                   	pop    %ebp
 557:	c3                   	ret    
 558:	90                   	nop
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000560 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	56                   	push   %esi
 564:	53                   	push   %ebx
 565:	8b 5d 10             	mov    0x10(%ebp),%ebx
 568:	8b 45 08             	mov    0x8(%ebp),%eax
 56b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 56e:	85 db                	test   %ebx,%ebx
 570:	7e 14                	jle    586 <memmove+0x26>
 572:	31 d2                	xor    %edx,%edx
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 578:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 57c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 57f:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 582:	39 da                	cmp    %ebx,%edx
 584:	75 f2                	jne    578 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 586:	5b                   	pop    %ebx
 587:	5e                   	pop    %esi
 588:	5d                   	pop    %ebp
 589:	c3                   	ret    

0000058a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 58a:	b8 01 00 00 00       	mov    $0x1,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <exit>:
SYSCALL(exit)
 592:	b8 02 00 00 00       	mov    $0x2,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <wait>:
SYSCALL(wait)
 59a:	b8 03 00 00 00       	mov    $0x3,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <pipe>:
SYSCALL(pipe)
 5a2:	b8 04 00 00 00       	mov    $0x4,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <read>:
SYSCALL(read)
 5aa:	b8 05 00 00 00       	mov    $0x5,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <write>:
SYSCALL(write)
 5b2:	b8 10 00 00 00       	mov    $0x10,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <close>:
SYSCALL(close)
 5ba:	b8 15 00 00 00       	mov    $0x15,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <kill>:
SYSCALL(kill)
 5c2:	b8 06 00 00 00       	mov    $0x6,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <exec>:
SYSCALL(exec)
 5ca:	b8 07 00 00 00       	mov    $0x7,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <open>:
SYSCALL(open)
 5d2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <mknod>:
SYSCALL(mknod)
 5da:	b8 11 00 00 00       	mov    $0x11,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <unlink>:
SYSCALL(unlink)
 5e2:	b8 12 00 00 00       	mov    $0x12,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <fstat>:
SYSCALL(fstat)
 5ea:	b8 08 00 00 00       	mov    $0x8,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <link>:
SYSCALL(link)
 5f2:	b8 13 00 00 00       	mov    $0x13,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <mkdir>:
SYSCALL(mkdir)
 5fa:	b8 14 00 00 00       	mov    $0x14,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <chdir>:
SYSCALL(chdir)
 602:	b8 09 00 00 00       	mov    $0x9,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <dup>:
SYSCALL(dup)
 60a:	b8 0a 00 00 00       	mov    $0xa,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <getpid>:
SYSCALL(getpid)
 612:	b8 0b 00 00 00       	mov    $0xb,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <sbrk>:
SYSCALL(sbrk)
 61a:	b8 0c 00 00 00       	mov    $0xc,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <sleep>:
SYSCALL(sleep)
 622:	b8 0d 00 00 00       	mov    $0xd,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <uptime>:
SYSCALL(uptime)
 62a:	b8 0e 00 00 00       	mov    $0xe,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <myfunction>:
SYSCALL(myfunction)
 632:	b8 16 00 00 00       	mov    $0x16,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <getppid>:
SYSCALL(getppid)
 63a:	b8 17 00 00 00       	mov    $0x17,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <getadmin>:
SYSCALL(getadmin)
 642:	b8 18 00 00 00       	mov    $0x18,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <exec2>:
SYSCALL(exec2)
 64a:	b8 19 00 00 00       	mov    $0x19,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <setmemorylimit>:
SYSCALL(setmemorylimit)
 652:	b8 1a 00 00 00       	mov    $0x1a,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <proclist>:
SYSCALL(proclist)
 65a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <getshmem>:
 662:	b8 1c 00 00 00       	mov    $0x1c,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    
 66a:	66 90                	xchg   %ax,%ax
 66c:	66 90                	xchg   %ax,%ax
 66e:	66 90                	xchg   %ax,%ax

00000670 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	89 c6                	mov    %eax,%esi
 678:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 67b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 67e:	85 db                	test   %ebx,%ebx
 680:	74 7e                	je     700 <printint+0x90>
 682:	89 d0                	mov    %edx,%eax
 684:	c1 e8 1f             	shr    $0x1f,%eax
 687:	84 c0                	test   %al,%al
 689:	74 75                	je     700 <printint+0x90>
    neg = 1;
    x = -xx;
 68b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 68d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 694:	f7 d8                	neg    %eax
 696:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 699:	31 ff                	xor    %edi,%edi
 69b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 69e:	89 ce                	mov    %ecx,%esi
 6a0:	eb 08                	jmp    6aa <printint+0x3a>
 6a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6a8:	89 cf                	mov    %ecx,%edi
 6aa:	31 d2                	xor    %edx,%edx
 6ac:	8d 4f 01             	lea    0x1(%edi),%ecx
 6af:	f7 f6                	div    %esi
 6b1:	0f b6 92 10 0b 00 00 	movzbl 0xb10(%edx),%edx
  }while((x /= base) != 0);
 6b8:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 6ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 6bd:	75 e9                	jne    6a8 <printint+0x38>
  if(neg)
 6bf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6c2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 6c5:	85 c0                	test   %eax,%eax
 6c7:	74 08                	je     6d1 <printint+0x61>
    buf[i++] = '-';
 6c9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 6ce:	8d 4f 02             	lea    0x2(%edi),%ecx
 6d1:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 6d5:	8d 76 00             	lea    0x0(%esi),%esi
 6d8:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6db:	83 ec 04             	sub    $0x4,%esp
 6de:	83 ef 01             	sub    $0x1,%edi
 6e1:	6a 01                	push   $0x1
 6e3:	53                   	push   %ebx
 6e4:	56                   	push   %esi
 6e5:	88 45 d7             	mov    %al,-0x29(%ebp)
 6e8:	e8 c5 fe ff ff       	call   5b2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6ed:	83 c4 10             	add    $0x10,%esp
 6f0:	39 df                	cmp    %ebx,%edi
 6f2:	75 e4                	jne    6d8 <printint+0x68>
    putc(fd, buf[i]);
}
 6f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f7:	5b                   	pop    %ebx
 6f8:	5e                   	pop    %esi
 6f9:	5f                   	pop    %edi
 6fa:	5d                   	pop    %ebp
 6fb:	c3                   	ret    
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 700:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 702:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 709:	eb 8b                	jmp    696 <printint+0x26>
 70b:	90                   	nop
 70c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000710 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 716:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 719:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 71c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 71f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 722:	89 45 d0             	mov    %eax,-0x30(%ebp)
 725:	0f b6 1e             	movzbl (%esi),%ebx
 728:	83 c6 01             	add    $0x1,%esi
 72b:	84 db                	test   %bl,%bl
 72d:	0f 84 b0 00 00 00    	je     7e3 <printf+0xd3>
 733:	31 d2                	xor    %edx,%edx
 735:	eb 39                	jmp    770 <printf+0x60>
 737:	89 f6                	mov    %esi,%esi
 739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 740:	83 f8 25             	cmp    $0x25,%eax
 743:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 746:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 74b:	74 18                	je     765 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 74d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 750:	83 ec 04             	sub    $0x4,%esp
 753:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 756:	6a 01                	push   $0x1
 758:	50                   	push   %eax
 759:	57                   	push   %edi
 75a:	e8 53 fe ff ff       	call   5b2 <write>
 75f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 762:	83 c4 10             	add    $0x10,%esp
 765:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 768:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 76c:	84 db                	test   %bl,%bl
 76e:	74 73                	je     7e3 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 770:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 772:	0f be cb             	movsbl %bl,%ecx
 775:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 778:	74 c6                	je     740 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 77a:	83 fa 25             	cmp    $0x25,%edx
 77d:	75 e6                	jne    765 <printf+0x55>
      if(c == 'd'){
 77f:	83 f8 64             	cmp    $0x64,%eax
 782:	0f 84 f8 00 00 00    	je     880 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 788:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 78e:	83 f9 70             	cmp    $0x70,%ecx
 791:	74 5d                	je     7f0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 793:	83 f8 73             	cmp    $0x73,%eax
 796:	0f 84 84 00 00 00    	je     820 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 79c:	83 f8 63             	cmp    $0x63,%eax
 79f:	0f 84 ea 00 00 00    	je     88f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7a5:	83 f8 25             	cmp    $0x25,%eax
 7a8:	0f 84 c2 00 00 00    	je     870 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7ae:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7b1:	83 ec 04             	sub    $0x4,%esp
 7b4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7b8:	6a 01                	push   $0x1
 7ba:	50                   	push   %eax
 7bb:	57                   	push   %edi
 7bc:	e8 f1 fd ff ff       	call   5b2 <write>
 7c1:	83 c4 0c             	add    $0xc,%esp
 7c4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7c7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 7ca:	6a 01                	push   $0x1
 7cc:	50                   	push   %eax
 7cd:	57                   	push   %edi
 7ce:	83 c6 01             	add    $0x1,%esi
 7d1:	e8 dc fd ff ff       	call   5b2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7d6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7da:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7dd:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7df:	84 db                	test   %bl,%bl
 7e1:	75 8d                	jne    770 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7e6:	5b                   	pop    %ebx
 7e7:	5e                   	pop    %esi
 7e8:	5f                   	pop    %edi
 7e9:	5d                   	pop    %ebp
 7ea:	c3                   	ret    
 7eb:	90                   	nop
 7ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7f0:	83 ec 0c             	sub    $0xc,%esp
 7f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 7f8:	6a 00                	push   $0x0
 7fa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7fd:	89 f8                	mov    %edi,%eax
 7ff:	8b 13                	mov    (%ebx),%edx
 801:	e8 6a fe ff ff       	call   670 <printint>
        ap++;
 806:	89 d8                	mov    %ebx,%eax
 808:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 80b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 80d:	83 c0 04             	add    $0x4,%eax
 810:	89 45 d0             	mov    %eax,-0x30(%ebp)
 813:	e9 4d ff ff ff       	jmp    765 <printf+0x55>
 818:	90                   	nop
 819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 820:	8b 45 d0             	mov    -0x30(%ebp),%eax
 823:	8b 18                	mov    (%eax),%ebx
        ap++;
 825:	83 c0 04             	add    $0x4,%eax
 828:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 82b:	b8 08 0b 00 00       	mov    $0xb08,%eax
 830:	85 db                	test   %ebx,%ebx
 832:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 835:	0f b6 03             	movzbl (%ebx),%eax
 838:	84 c0                	test   %al,%al
 83a:	74 23                	je     85f <printf+0x14f>
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 840:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 843:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 846:	83 ec 04             	sub    $0x4,%esp
 849:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 84b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 84e:	50                   	push   %eax
 84f:	57                   	push   %edi
 850:	e8 5d fd ff ff       	call   5b2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 855:	0f b6 03             	movzbl (%ebx),%eax
 858:	83 c4 10             	add    $0x10,%esp
 85b:	84 c0                	test   %al,%al
 85d:	75 e1                	jne    840 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 85f:	31 d2                	xor    %edx,%edx
 861:	e9 ff fe ff ff       	jmp    765 <printf+0x55>
 866:	8d 76 00             	lea    0x0(%esi),%esi
 869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 870:	83 ec 04             	sub    $0x4,%esp
 873:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 876:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 879:	6a 01                	push   $0x1
 87b:	e9 4c ff ff ff       	jmp    7cc <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 880:	83 ec 0c             	sub    $0xc,%esp
 883:	b9 0a 00 00 00       	mov    $0xa,%ecx
 888:	6a 01                	push   $0x1
 88a:	e9 6b ff ff ff       	jmp    7fa <printf+0xea>
 88f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 892:	83 ec 04             	sub    $0x4,%esp
 895:	8b 03                	mov    (%ebx),%eax
 897:	6a 01                	push   $0x1
 899:	88 45 e4             	mov    %al,-0x1c(%ebp)
 89c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 89f:	50                   	push   %eax
 8a0:	57                   	push   %edi
 8a1:	e8 0c fd ff ff       	call   5b2 <write>
 8a6:	e9 5b ff ff ff       	jmp    806 <printf+0xf6>
 8ab:	66 90                	xchg   %ax,%ax
 8ad:	66 90                	xchg   %ax,%ax
 8af:	90                   	nop

000008b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b1:	a1 b4 0d 00 00       	mov    0xdb4,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b6:	89 e5                	mov    %esp,%ebp
 8b8:	57                   	push   %edi
 8b9:	56                   	push   %esi
 8ba:	53                   	push   %ebx
 8bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8be:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c3:	39 c8                	cmp    %ecx,%eax
 8c5:	73 19                	jae    8e0 <free+0x30>
 8c7:	89 f6                	mov    %esi,%esi
 8c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 8d0:	39 d1                	cmp    %edx,%ecx
 8d2:	72 1c                	jb     8f0 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d4:	39 d0                	cmp    %edx,%eax
 8d6:	73 18                	jae    8f0 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d8:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8da:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8dc:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8de:	72 f0                	jb     8d0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	39 d0                	cmp    %edx,%eax
 8e2:	72 f4                	jb     8d8 <free+0x28>
 8e4:	39 d1                	cmp    %edx,%ecx
 8e6:	73 f0                	jae    8d8 <free+0x28>
 8e8:	90                   	nop
 8e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8f3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8f6:	39 d7                	cmp    %edx,%edi
 8f8:	74 19                	je     913 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8fd:	8b 50 04             	mov    0x4(%eax),%edx
 900:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 903:	39 f1                	cmp    %esi,%ecx
 905:	74 23                	je     92a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 907:	89 08                	mov    %ecx,(%eax)
  freep = p;
 909:	a3 b4 0d 00 00       	mov    %eax,0xdb4
}
 90e:	5b                   	pop    %ebx
 90f:	5e                   	pop    %esi
 910:	5f                   	pop    %edi
 911:	5d                   	pop    %ebp
 912:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 913:	03 72 04             	add    0x4(%edx),%esi
 916:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 919:	8b 10                	mov    (%eax),%edx
 91b:	8b 12                	mov    (%edx),%edx
 91d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 920:	8b 50 04             	mov    0x4(%eax),%edx
 923:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 926:	39 f1                	cmp    %esi,%ecx
 928:	75 dd                	jne    907 <free+0x57>
    p->s.size += bp->s.size;
 92a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 92d:	a3 b4 0d 00 00       	mov    %eax,0xdb4
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 932:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 935:	8b 53 f8             	mov    -0x8(%ebx),%edx
 938:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 93a:	5b                   	pop    %ebx
 93b:	5e                   	pop    %esi
 93c:	5f                   	pop    %edi
 93d:	5d                   	pop    %ebp
 93e:	c3                   	ret    
 93f:	90                   	nop

00000940 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 940:	55                   	push   %ebp
 941:	89 e5                	mov    %esp,%ebp
 943:	57                   	push   %edi
 944:	56                   	push   %esi
 945:	53                   	push   %ebx
 946:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 949:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 94c:	8b 15 b4 0d 00 00    	mov    0xdb4,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 952:	8d 78 07             	lea    0x7(%eax),%edi
 955:	c1 ef 03             	shr    $0x3,%edi
 958:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 95b:	85 d2                	test   %edx,%edx
 95d:	0f 84 a3 00 00 00    	je     a06 <malloc+0xc6>
 963:	8b 02                	mov    (%edx),%eax
 965:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 968:	39 cf                	cmp    %ecx,%edi
 96a:	76 74                	jbe    9e0 <malloc+0xa0>
 96c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 972:	be 00 10 00 00       	mov    $0x1000,%esi
 977:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 97e:	0f 43 f7             	cmovae %edi,%esi
 981:	ba 00 80 00 00       	mov    $0x8000,%edx
 986:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 98c:	0f 46 da             	cmovbe %edx,%ebx
 98f:	eb 10                	jmp    9a1 <malloc+0x61>
 991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 998:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 99a:	8b 48 04             	mov    0x4(%eax),%ecx
 99d:	39 cf                	cmp    %ecx,%edi
 99f:	76 3f                	jbe    9e0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a1:	39 05 b4 0d 00 00    	cmp    %eax,0xdb4
 9a7:	89 c2                	mov    %eax,%edx
 9a9:	75 ed                	jne    998 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 9ab:	83 ec 0c             	sub    $0xc,%esp
 9ae:	53                   	push   %ebx
 9af:	e8 66 fc ff ff       	call   61a <sbrk>
  if(p == (char*)-1)
 9b4:	83 c4 10             	add    $0x10,%esp
 9b7:	83 f8 ff             	cmp    $0xffffffff,%eax
 9ba:	74 1c                	je     9d8 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 9bc:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 9bf:	83 ec 0c             	sub    $0xc,%esp
 9c2:	83 c0 08             	add    $0x8,%eax
 9c5:	50                   	push   %eax
 9c6:	e8 e5 fe ff ff       	call   8b0 <free>
  return freep;
 9cb:	8b 15 b4 0d 00 00    	mov    0xdb4,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 9d1:	83 c4 10             	add    $0x10,%esp
 9d4:	85 d2                	test   %edx,%edx
 9d6:	75 c0                	jne    998 <malloc+0x58>
        return 0;
 9d8:	31 c0                	xor    %eax,%eax
 9da:	eb 1c                	jmp    9f8 <malloc+0xb8>
 9dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 9e0:	39 cf                	cmp    %ecx,%edi
 9e2:	74 1c                	je     a00 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 9e4:	29 f9                	sub    %edi,%ecx
 9e6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9e9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9ec:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 9ef:	89 15 b4 0d 00 00    	mov    %edx,0xdb4
      return (void*)(p + 1);
 9f5:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9fb:	5b                   	pop    %ebx
 9fc:	5e                   	pop    %esi
 9fd:	5f                   	pop    %edi
 9fe:	5d                   	pop    %ebp
 9ff:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 a00:	8b 08                	mov    (%eax),%ecx
 a02:	89 0a                	mov    %ecx,(%edx)
 a04:	eb e9                	jmp    9ef <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a06:	c7 05 b4 0d 00 00 b8 	movl   $0xdb8,0xdb4
 a0d:	0d 00 00 
 a10:	c7 05 b8 0d 00 00 b8 	movl   $0xdb8,0xdb8
 a17:	0d 00 00 
    base.s.size = 0;
 a1a:	b8 b8 0d 00 00       	mov    $0xdb8,%eax
 a1f:	c7 05 bc 0d 00 00 00 	movl   $0x0,0xdbc
 a26:	00 00 00 
 a29:	e9 3e ff ff ff       	jmp    96c <malloc+0x2c>
