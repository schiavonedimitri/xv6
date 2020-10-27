
_init:     formato del file elf32-i386


Disassemblamento della sezione .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 ae 08 00 00       	push   $0x8ae
  1b:	e8 78 03 00 00       	call   398 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 ae 08 00 00       	push   $0x8ae
  33:	e8 68 03 00 00       	call   3a0 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 ae 08 00 00       	push   $0x8ae
  45:	e8 4e 03 00 00       	call   398 <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 79 03 00 00       	call   3d0 <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 6c 03 00 00       	call   3d0 <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 b6 08 00 00       	push   $0x8b6
  6f:	6a 01                	push   $0x1
  71:	e8 7e 04 00 00       	call   4f4 <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 d2 02 00 00       	call   350 <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 c9 08 00 00       	push   $0x8c9
  8f:	6a 01                	push   $0x1
  91:	e8 5e 04 00 00       	call   4f4 <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 ba 02 00 00       	call   358 <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 48 0b 00 00       	push   $0xb48
  ac:	68 ab 08 00 00       	push   $0x8ab
  b1:	e8 da 02 00 00       	call   390 <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 dc 08 00 00       	push   $0x8dc
  c1:	6a 01                	push   $0x1
  c3:	e8 2c 04 00 00       	call   4f4 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 88 02 00 00       	call   358 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 f2 08 00 00       	push   $0x8f2
  d8:	6a 01                	push   $0x1
  da:	e8 15 04 00 00       	call   4f4 <printf>
  df:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
  e2:	e8 79 02 00 00       	call   360 <wait>
  e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  ee:	0f 88 73 ff ff ff    	js     67 <main+0x67>
  f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  fa:	75 d4                	jne    d0 <main+0xd0>
    printf(1, "init: starting sh\n");
  fc:	e9 66 ff ff ff       	jmp    67 <main+0x67>

00000101 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	57                   	push   %edi
 105:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 55 10             	mov    0x10(%ebp),%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	89 cb                	mov    %ecx,%ebx
 111:	89 df                	mov    %ebx,%edi
 113:	89 d1                	mov    %edx,%ecx
 115:	fc                   	cld    
 116:	f3 aa                	rep stos %al,%es:(%edi)
 118:	89 ca                	mov    %ecx,%edx
 11a:	89 fb                	mov    %edi,%ebx
 11c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 122:	90                   	nop
 123:	5b                   	pop    %ebx
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    

00000127 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 133:	90                   	nop
 134:	8b 55 0c             	mov    0xc(%ebp),%edx
 137:	8d 42 01             	lea    0x1(%edx),%eax
 13a:	89 45 0c             	mov    %eax,0xc(%ebp)
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	8d 48 01             	lea    0x1(%eax),%ecx
 143:	89 4d 08             	mov    %ecx,0x8(%ebp)
 146:	0f b6 12             	movzbl (%edx),%edx
 149:	88 10                	mov    %dl,(%eax)
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	84 c0                	test   %al,%al
 150:	75 e2                	jne    134 <strcpy+0xd>
    ;
  return os;
 152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 155:	c9                   	leave  
 156:	c3                   	ret    

00000157 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 15a:	eb 08                	jmp    164 <strcmp+0xd>
    p++, q++;
 15c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 160:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	84 c0                	test   %al,%al
 16c:	74 10                	je     17e <strcmp+0x27>
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 10             	movzbl (%eax),%edx
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	38 c2                	cmp    %al,%dl
 17c:	74 de                	je     15c <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	0f b6 d0             	movzbl %al,%edx
 187:	8b 45 0c             	mov    0xc(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	0f b6 c8             	movzbl %al,%ecx
 190:	89 d0                	mov    %edx,%eax
 192:	29 c8                	sub    %ecx,%eax
}
 194:	5d                   	pop    %ebp
 195:	c3                   	ret    

00000196 <strlen>:

uint
strlen(char *s)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 19c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a3:	eb 04                	jmp    1a9 <strlen+0x13>
 1a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 d0                	add    %edx,%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	84 c0                	test   %al,%al
 1b6:	75 ed                	jne    1a5 <strlen+0xf>
    ;
  return n;
 1b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c0:	8b 45 10             	mov    0x10(%ebp),%eax
 1c3:	50                   	push   %eax
 1c4:	ff 75 0c             	pushl  0xc(%ebp)
 1c7:	ff 75 08             	pushl  0x8(%ebp)
 1ca:	e8 32 ff ff ff       	call   101 <stosb>
 1cf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d5:	c9                   	leave  
 1d6:	c3                   	ret    

000001d7 <strchr>:

char*
strchr(const char *s, char c)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e3:	eb 14                	jmp    1f9 <strchr+0x22>
    if(*s == c)
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 00             	movzbl (%eax),%eax
 1eb:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1ee:	75 05                	jne    1f5 <strchr+0x1e>
      return (char*)s;
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	eb 13                	jmp    208 <strchr+0x31>
  for(; *s; s++)
 1f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strchr+0xe>
  return 0;
 203:	b8 00 00 00 00       	mov    $0x0,%eax
}
 208:	c9                   	leave  
 209:	c3                   	ret    

0000020a <gets>:

char*
gets(char *buf, int max)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 217:	eb 42                	jmp    25b <gets+0x51>
    cc = read(0, &c, 1);
 219:	83 ec 04             	sub    $0x4,%esp
 21c:	6a 01                	push   $0x1
 21e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 221:	50                   	push   %eax
 222:	6a 00                	push   $0x0
 224:	e8 47 01 00 00       	call   370 <read>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 233:	7e 33                	jle    268 <gets+0x5e>
      break;
    buf[i++] = c;
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	8d 50 01             	lea    0x1(%eax),%edx
 23b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23e:	89 c2                	mov    %eax,%edx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	01 c2                	add    %eax,%edx
 245:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 249:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24f:	3c 0a                	cmp    $0xa,%al
 251:	74 16                	je     269 <gets+0x5f>
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	3c 0d                	cmp    $0xd,%al
 259:	74 0e                	je     269 <gets+0x5f>
  for(i=0; i+1 < max; ){
 25b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25e:	83 c0 01             	add    $0x1,%eax
 261:	39 45 0c             	cmp    %eax,0xc(%ebp)
 264:	7f b3                	jg     219 <gets+0xf>
 266:	eb 01                	jmp    269 <gets+0x5f>
      break;
 268:	90                   	nop
      break;
  }
  buf[i] = '\0';
 269:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	01 d0                	add    %edx,%eax
 271:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <stat>:

int
stat(char *n, struct stat *st)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	6a 00                	push   $0x0
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 0c 01 00 00       	call   398 <open>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 292:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 296:	79 07                	jns    29f <stat+0x26>
    return -1;
 298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29d:	eb 25                	jmp    2c4 <stat+0x4b>
  r = fstat(fd, st);
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	ff 75 0c             	pushl  0xc(%ebp)
 2a5:	ff 75 f4             	pushl  -0xc(%ebp)
 2a8:	e8 03 01 00 00       	call   3b0 <fstat>
 2ad:	83 c4 10             	add    $0x10,%esp
 2b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b3:	83 ec 0c             	sub    $0xc,%esp
 2b6:	ff 75 f4             	pushl  -0xc(%ebp)
 2b9:	e8 c2 00 00 00       	call   380 <close>
 2be:	83 c4 10             	add    $0x10,%esp
  return r;
 2c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <atoi>:

int
atoi(const char *s)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2d3:	eb 25                	jmp    2fa <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d8:	89 d0                	mov    %edx,%eax
 2da:	c1 e0 02             	shl    $0x2,%eax
 2dd:	01 d0                	add    %edx,%eax
 2df:	01 c0                	add    %eax,%eax
 2e1:	89 c1                	mov    %eax,%ecx
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	8d 50 01             	lea    0x1(%eax),%edx
 2e9:	89 55 08             	mov    %edx,0x8(%ebp)
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	0f be c0             	movsbl %al,%eax
 2f2:	01 c8                	add    %ecx,%eax
 2f4:	83 e8 30             	sub    $0x30,%eax
 2f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	3c 2f                	cmp    $0x2f,%al
 302:	7e 0a                	jle    30e <atoi+0x48>
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	0f b6 00             	movzbl (%eax),%eax
 30a:	3c 39                	cmp    $0x39,%al
 30c:	7e c7                	jle    2d5 <atoi+0xf>
  return n;
 30e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 311:	c9                   	leave  
 312:	c3                   	ret    

00000313 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 313:	55                   	push   %ebp
 314:	89 e5                	mov    %esp,%ebp
 316:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31f:	8b 45 0c             	mov    0xc(%ebp),%eax
 322:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 325:	eb 17                	jmp    33e <memmove+0x2b>
    *dst++ = *src++;
 327:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32a:	8d 42 01             	lea    0x1(%edx),%eax
 32d:	89 45 f8             	mov    %eax,-0x8(%ebp)
 330:	8b 45 fc             	mov    -0x4(%ebp),%eax
 333:	8d 48 01             	lea    0x1(%eax),%ecx
 336:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 339:	0f b6 12             	movzbl (%edx),%edx
 33c:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 33e:	8b 45 10             	mov    0x10(%ebp),%eax
 341:	8d 50 ff             	lea    -0x1(%eax),%edx
 344:	89 55 10             	mov    %edx,0x10(%ebp)
 347:	85 c0                	test   %eax,%eax
 349:	7f dc                	jg     327 <memmove+0x14>
  return vdst;
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34e:	c9                   	leave  
 34f:	c3                   	ret    

00000350 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 350:	b8 01 00 00 00       	mov    $0x1,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <exit>:
SYSCALL(exit)
 358:	b8 02 00 00 00       	mov    $0x2,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <wait>:
SYSCALL(wait)
 360:	b8 03 00 00 00       	mov    $0x3,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <pipe>:
SYSCALL(pipe)
 368:	b8 04 00 00 00       	mov    $0x4,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <read>:
SYSCALL(read)
 370:	b8 05 00 00 00       	mov    $0x5,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <write>:
SYSCALL(write)
 378:	b8 15 00 00 00       	mov    $0x15,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <close>:
SYSCALL(close)
 380:	b8 1a 00 00 00       	mov    $0x1a,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <kill>:
SYSCALL(kill)
 388:	b8 06 00 00 00       	mov    $0x6,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <exec>:
SYSCALL(exec)
 390:	b8 07 00 00 00       	mov    $0x7,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <open>:
SYSCALL(open)
 398:	b8 14 00 00 00       	mov    $0x14,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <mknod>:
SYSCALL(mknod)
 3a0:	b8 16 00 00 00       	mov    $0x16,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <unlink>:
SYSCALL(unlink)
 3a8:	b8 17 00 00 00       	mov    $0x17,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <fstat>:
SYSCALL(fstat)
 3b0:	b8 08 00 00 00       	mov    $0x8,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <link>:
SYSCALL(link)
 3b8:	b8 18 00 00 00       	mov    $0x18,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <mkdir>:
SYSCALL(mkdir)
 3c0:	b8 19 00 00 00       	mov    $0x19,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <chdir>:
SYSCALL(chdir)
 3c8:	b8 09 00 00 00       	mov    $0x9,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <dup>:
SYSCALL(dup)
 3d0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <getpid>:
SYSCALL(getpid)
 3d8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <sbrk>:
SYSCALL(sbrk)
 3e0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <sleep>:
SYSCALL(sleep)
 3e8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <uptime>:
SYSCALL(uptime)
 3f0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <sem_alloc>:
SYSCALL(sem_alloc)
 3f8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <sem_destroy>:
SYSCALL(sem_destroy)
 400:	b8 10 00 00 00       	mov    $0x10,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <sem_init>:
SYSCALL(sem_init)
 408:	b8 11 00 00 00       	mov    $0x11,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <sem_post>:
SYSCALL(sem_post)
 410:	b8 12 00 00 00       	mov    $0x12,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <sem_wait>:
SYSCALL(sem_wait)
 418:	b8 13 00 00 00       	mov    $0x13,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	83 ec 18             	sub    $0x18,%esp
 426:	8b 45 0c             	mov    0xc(%ebp),%eax
 429:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 42c:	83 ec 04             	sub    $0x4,%esp
 42f:	6a 01                	push   $0x1
 431:	8d 45 f4             	lea    -0xc(%ebp),%eax
 434:	50                   	push   %eax
 435:	ff 75 08             	pushl  0x8(%ebp)
 438:	e8 3b ff ff ff       	call   378 <write>
 43d:	83 c4 10             	add    $0x10,%esp
}
 440:	90                   	nop
 441:	c9                   	leave  
 442:	c3                   	ret    

00000443 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 443:	55                   	push   %ebp
 444:	89 e5                	mov    %esp,%ebp
 446:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 449:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 450:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 454:	74 17                	je     46d <printint+0x2a>
 456:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 45a:	79 11                	jns    46d <printint+0x2a>
    neg = 1;
 45c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 463:	8b 45 0c             	mov    0xc(%ebp),%eax
 466:	f7 d8                	neg    %eax
 468:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46b:	eb 06                	jmp    473 <printint+0x30>
  } else {
    x = xx;
 46d:	8b 45 0c             	mov    0xc(%ebp),%eax
 470:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 473:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 47a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 47d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 480:	ba 00 00 00 00       	mov    $0x0,%edx
 485:	f7 f1                	div    %ecx
 487:	89 d1                	mov    %edx,%ecx
 489:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48c:	8d 50 01             	lea    0x1(%eax),%edx
 48f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 492:	0f b6 91 50 0b 00 00 	movzbl 0xb50(%ecx),%edx
 499:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 49d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a3:	ba 00 00 00 00       	mov    $0x0,%edx
 4a8:	f7 f1                	div    %ecx
 4aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b1:	75 c7                	jne    47a <printint+0x37>
  if(neg)
 4b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b7:	74 2d                	je     4e6 <printint+0xa3>
    buf[i++] = '-';
 4b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bc:	8d 50 01             	lea    0x1(%eax),%edx
 4bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4c7:	eb 1d                	jmp    4e6 <printint+0xa3>
    putc(fd, buf[i]);
 4c9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cf:	01 d0                	add    %edx,%eax
 4d1:	0f b6 00             	movzbl (%eax),%eax
 4d4:	0f be c0             	movsbl %al,%eax
 4d7:	83 ec 08             	sub    $0x8,%esp
 4da:	50                   	push   %eax
 4db:	ff 75 08             	pushl  0x8(%ebp)
 4de:	e8 3d ff ff ff       	call   420 <putc>
 4e3:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4e6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ee:	79 d9                	jns    4c9 <printint+0x86>
}
 4f0:	90                   	nop
 4f1:	90                   	nop
 4f2:	c9                   	leave  
 4f3:	c3                   	ret    

000004f4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f4:	55                   	push   %ebp
 4f5:	89 e5                	mov    %esp,%ebp
 4f7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 501:	8d 45 0c             	lea    0xc(%ebp),%eax
 504:	83 c0 04             	add    $0x4,%eax
 507:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 50a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 511:	e9 59 01 00 00       	jmp    66f <printf+0x17b>
    c = fmt[i] & 0xff;
 516:	8b 55 0c             	mov    0xc(%ebp),%edx
 519:	8b 45 f0             	mov    -0x10(%ebp),%eax
 51c:	01 d0                	add    %edx,%eax
 51e:	0f b6 00             	movzbl (%eax),%eax
 521:	0f be c0             	movsbl %al,%eax
 524:	25 ff 00 00 00       	and    $0xff,%eax
 529:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 52c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 530:	75 2c                	jne    55e <printf+0x6a>
      if(c == '%'){
 532:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 536:	75 0c                	jne    544 <printf+0x50>
        state = '%';
 538:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 53f:	e9 27 01 00 00       	jmp    66b <printf+0x177>
      } else {
        putc(fd, c);
 544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 547:	0f be c0             	movsbl %al,%eax
 54a:	83 ec 08             	sub    $0x8,%esp
 54d:	50                   	push   %eax
 54e:	ff 75 08             	pushl  0x8(%ebp)
 551:	e8 ca fe ff ff       	call   420 <putc>
 556:	83 c4 10             	add    $0x10,%esp
 559:	e9 0d 01 00 00       	jmp    66b <printf+0x177>
      }
    } else if(state == '%'){
 55e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 562:	0f 85 03 01 00 00    	jne    66b <printf+0x177>
      if(c == 'd'){
 568:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 56c:	75 1e                	jne    58c <printf+0x98>
        printint(fd, *ap, 10, 1);
 56e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 571:	8b 00                	mov    (%eax),%eax
 573:	6a 01                	push   $0x1
 575:	6a 0a                	push   $0xa
 577:	50                   	push   %eax
 578:	ff 75 08             	pushl  0x8(%ebp)
 57b:	e8 c3 fe ff ff       	call   443 <printint>
 580:	83 c4 10             	add    $0x10,%esp
        ap++;
 583:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 587:	e9 d8 00 00 00       	jmp    664 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 58c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 590:	74 06                	je     598 <printf+0xa4>
 592:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 596:	75 1e                	jne    5b6 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 598:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59b:	8b 00                	mov    (%eax),%eax
 59d:	6a 00                	push   $0x0
 59f:	6a 10                	push   $0x10
 5a1:	50                   	push   %eax
 5a2:	ff 75 08             	pushl  0x8(%ebp)
 5a5:	e8 99 fe ff ff       	call   443 <printint>
 5aa:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b1:	e9 ae 00 00 00       	jmp    664 <printf+0x170>
      } else if(c == 's'){
 5b6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ba:	75 43                	jne    5ff <printf+0x10b>
        s = (char*)*ap;
 5bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bf:	8b 00                	mov    (%eax),%eax
 5c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5cc:	75 25                	jne    5f3 <printf+0xff>
          s = "(null)";
 5ce:	c7 45 f4 fb 08 00 00 	movl   $0x8fb,-0xc(%ebp)
        while(*s != 0){
 5d5:	eb 1c                	jmp    5f3 <printf+0xff>
          putc(fd, *s);
 5d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5da:	0f b6 00             	movzbl (%eax),%eax
 5dd:	0f be c0             	movsbl %al,%eax
 5e0:	83 ec 08             	sub    $0x8,%esp
 5e3:	50                   	push   %eax
 5e4:	ff 75 08             	pushl  0x8(%ebp)
 5e7:	e8 34 fe ff ff       	call   420 <putc>
 5ec:	83 c4 10             	add    $0x10,%esp
          s++;
 5ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f6:	0f b6 00             	movzbl (%eax),%eax
 5f9:	84 c0                	test   %al,%al
 5fb:	75 da                	jne    5d7 <printf+0xe3>
 5fd:	eb 65                	jmp    664 <printf+0x170>
        }
      } else if(c == 'c'){
 5ff:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 603:	75 1d                	jne    622 <printf+0x12e>
        putc(fd, *ap);
 605:	8b 45 e8             	mov    -0x18(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	0f be c0             	movsbl %al,%eax
 60d:	83 ec 08             	sub    $0x8,%esp
 610:	50                   	push   %eax
 611:	ff 75 08             	pushl  0x8(%ebp)
 614:	e8 07 fe ff ff       	call   420 <putc>
 619:	83 c4 10             	add    $0x10,%esp
        ap++;
 61c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 620:	eb 42                	jmp    664 <printf+0x170>
      } else if(c == '%'){
 622:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 626:	75 17                	jne    63f <printf+0x14b>
        putc(fd, c);
 628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62b:	0f be c0             	movsbl %al,%eax
 62e:	83 ec 08             	sub    $0x8,%esp
 631:	50                   	push   %eax
 632:	ff 75 08             	pushl  0x8(%ebp)
 635:	e8 e6 fd ff ff       	call   420 <putc>
 63a:	83 c4 10             	add    $0x10,%esp
 63d:	eb 25                	jmp    664 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63f:	83 ec 08             	sub    $0x8,%esp
 642:	6a 25                	push   $0x25
 644:	ff 75 08             	pushl  0x8(%ebp)
 647:	e8 d4 fd ff ff       	call   420 <putc>
 64c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 64f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 652:	0f be c0             	movsbl %al,%eax
 655:	83 ec 08             	sub    $0x8,%esp
 658:	50                   	push   %eax
 659:	ff 75 08             	pushl  0x8(%ebp)
 65c:	e8 bf fd ff ff       	call   420 <putc>
 661:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 664:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 66b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 66f:	8b 55 0c             	mov    0xc(%ebp),%edx
 672:	8b 45 f0             	mov    -0x10(%ebp),%eax
 675:	01 d0                	add    %edx,%eax
 677:	0f b6 00             	movzbl (%eax),%eax
 67a:	84 c0                	test   %al,%al
 67c:	0f 85 94 fe ff ff    	jne    516 <printf+0x22>
    }
  }
}
 682:	90                   	nop
 683:	90                   	nop
 684:	c9                   	leave  
 685:	c3                   	ret    

00000686 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 686:	55                   	push   %ebp
 687:	89 e5                	mov    %esp,%ebp
 689:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68c:	8b 45 08             	mov    0x8(%ebp),%eax
 68f:	83 e8 08             	sub    $0x8,%eax
 692:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 695:	a1 6c 0b 00 00       	mov    0xb6c,%eax
 69a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69d:	eb 24                	jmp    6c3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6a7:	72 12                	jb     6bb <free+0x35>
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6af:	77 24                	ja     6d5 <free+0x4f>
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 00                	mov    (%eax),%eax
 6b6:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6b9:	72 1a                	jb     6d5 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 00                	mov    (%eax),%eax
 6c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c9:	76 d4                	jbe    69f <free+0x19>
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 00                	mov    (%eax),%eax
 6d0:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6d3:	73 ca                	jae    69f <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	8b 40 04             	mov    0x4(%eax),%eax
 6db:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e5:	01 c2                	add    %eax,%edx
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 00                	mov    (%eax),%eax
 6ec:	39 c2                	cmp    %eax,%edx
 6ee:	75 24                	jne    714 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f3:	8b 50 04             	mov    0x4(%eax),%edx
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 00                	mov    (%eax),%eax
 6fb:	8b 40 04             	mov    0x4(%eax),%eax
 6fe:	01 c2                	add    %eax,%edx
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 706:	8b 45 fc             	mov    -0x4(%ebp),%eax
 709:	8b 00                	mov    (%eax),%eax
 70b:	8b 10                	mov    (%eax),%edx
 70d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 710:	89 10                	mov    %edx,(%eax)
 712:	eb 0a                	jmp    71e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	8b 10                	mov    (%eax),%edx
 719:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 40 04             	mov    0x4(%eax),%eax
 724:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	01 d0                	add    %edx,%eax
 730:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 733:	75 20                	jne    755 <free+0xcf>
    p->s.size += bp->s.size;
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	8b 50 04             	mov    0x4(%eax),%edx
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	8b 40 04             	mov    0x4(%eax),%eax
 741:	01 c2                	add    %eax,%edx
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 749:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74c:	8b 10                	mov    (%eax),%edx
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	89 10                	mov    %edx,(%eax)
 753:	eb 08                	jmp    75d <free+0xd7>
  } else
    p->s.ptr = bp;
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	8b 55 f8             	mov    -0x8(%ebp),%edx
 75b:	89 10                	mov    %edx,(%eax)
  freep = p;
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	a3 6c 0b 00 00       	mov    %eax,0xb6c
}
 765:	90                   	nop
 766:	c9                   	leave  
 767:	c3                   	ret    

00000768 <morecore>:

static Header*
morecore(uint nu)
{
 768:	55                   	push   %ebp
 769:	89 e5                	mov    %esp,%ebp
 76b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 76e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 775:	77 07                	ja     77e <morecore+0x16>
    nu = 4096;
 777:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 77e:	8b 45 08             	mov    0x8(%ebp),%eax
 781:	c1 e0 03             	shl    $0x3,%eax
 784:	83 ec 0c             	sub    $0xc,%esp
 787:	50                   	push   %eax
 788:	e8 53 fc ff ff       	call   3e0 <sbrk>
 78d:	83 c4 10             	add    $0x10,%esp
 790:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 793:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 797:	75 07                	jne    7a0 <morecore+0x38>
    return 0;
 799:	b8 00 00 00 00       	mov    $0x0,%eax
 79e:	eb 26                	jmp    7c6 <morecore+0x5e>
  hp = (Header*)p;
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a9:	8b 55 08             	mov    0x8(%ebp),%edx
 7ac:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b2:	83 c0 08             	add    $0x8,%eax
 7b5:	83 ec 0c             	sub    $0xc,%esp
 7b8:	50                   	push   %eax
 7b9:	e8 c8 fe ff ff       	call   686 <free>
 7be:	83 c4 10             	add    $0x10,%esp
  return freep;
 7c1:	a1 6c 0b 00 00       	mov    0xb6c,%eax
}
 7c6:	c9                   	leave  
 7c7:	c3                   	ret    

000007c8 <malloc>:

void*
malloc(uint nbytes)
{
 7c8:	55                   	push   %ebp
 7c9:	89 e5                	mov    %esp,%ebp
 7cb:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ce:	8b 45 08             	mov    0x8(%ebp),%eax
 7d1:	83 c0 07             	add    $0x7,%eax
 7d4:	c1 e8 03             	shr    $0x3,%eax
 7d7:	83 c0 01             	add    $0x1,%eax
 7da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7dd:	a1 6c 0b 00 00       	mov    0xb6c,%eax
 7e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e9:	75 23                	jne    80e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7eb:	c7 45 f0 64 0b 00 00 	movl   $0xb64,-0x10(%ebp)
 7f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f5:	a3 6c 0b 00 00       	mov    %eax,0xb6c
 7fa:	a1 6c 0b 00 00       	mov    0xb6c,%eax
 7ff:	a3 64 0b 00 00       	mov    %eax,0xb64
    base.s.size = 0;
 804:	c7 05 68 0b 00 00 00 	movl   $0x0,0xb68
 80b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 811:	8b 00                	mov    (%eax),%eax
 813:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	8b 40 04             	mov    0x4(%eax),%eax
 81c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 81f:	77 4d                	ja     86e <malloc+0xa6>
      if(p->s.size == nunits)
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	8b 40 04             	mov    0x4(%eax),%eax
 827:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 82a:	75 0c                	jne    838 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	8b 10                	mov    (%eax),%edx
 831:	8b 45 f0             	mov    -0x10(%ebp),%eax
 834:	89 10                	mov    %edx,(%eax)
 836:	eb 26                	jmp    85e <malloc+0x96>
      else {
        p->s.size -= nunits;
 838:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83b:	8b 40 04             	mov    0x4(%eax),%eax
 83e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 841:	89 c2                	mov    %eax,%edx
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	8b 40 04             	mov    0x4(%eax),%eax
 84f:	c1 e0 03             	shl    $0x3,%eax
 852:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	8b 55 ec             	mov    -0x14(%ebp),%edx
 85b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 85e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 861:	a3 6c 0b 00 00       	mov    %eax,0xb6c
      return (void*)(p + 1);
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	83 c0 08             	add    $0x8,%eax
 86c:	eb 3b                	jmp    8a9 <malloc+0xe1>
    }
    if(p == freep)
 86e:	a1 6c 0b 00 00       	mov    0xb6c,%eax
 873:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 876:	75 1e                	jne    896 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 878:	83 ec 0c             	sub    $0xc,%esp
 87b:	ff 75 ec             	pushl  -0x14(%ebp)
 87e:	e8 e5 fe ff ff       	call   768 <morecore>
 883:	83 c4 10             	add    $0x10,%esp
 886:	89 45 f4             	mov    %eax,-0xc(%ebp)
 889:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 88d:	75 07                	jne    896 <malloc+0xce>
        return 0;
 88f:	b8 00 00 00 00       	mov    $0x0,%eax
 894:	eb 13                	jmp    8a9 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	89 45 f0             	mov    %eax,-0x10(%ebp)
 89c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89f:	8b 00                	mov    (%eax),%eax
 8a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a4:	e9 6d ff ff ff       	jmp    816 <malloc+0x4e>
  }
}
 8a9:	c9                   	leave  
 8aa:	c3                   	ret    
