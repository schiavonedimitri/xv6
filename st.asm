
_st:     formato del file elf32-i386


Disassemblamento della sezione .text:

00000000 <semaphore_test>:
char buf[8192];
char name[3];
int stdout = 1;

void
semaphore_test(void) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int pid;
  int sem;

  sem = sem_alloc();
   6:	e8 ba 03 00 00       	call   3c5 <sem_alloc>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sem_init(sem, 0);
   e:	83 ec 08             	sub    $0x8,%esp
  11:	6a 00                	push   $0x0
  13:	ff 75 f4             	pushl  -0xc(%ebp)
  16:	e8 ba 03 00 00       	call   3d5 <sem_init>
  1b:	83 c4 10             	add    $0x10,%esp
  
  printf(stdout, "A\n");
  1e:	a1 e8 0a 00 00       	mov    0xae8,%eax
  23:	83 ec 08             	sub    $0x8,%esp
  26:	68 78 08 00 00       	push   $0x878
  2b:	50                   	push   %eax
  2c:	e8 90 04 00 00       	call   4c1 <printf>
  31:	83 c4 10             	add    $0x10,%esp
  pid = fork();
  34:	e8 e4 02 00 00       	call   31d <fork>
  39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (pid) {
  3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  40:	74 2b                	je     6d <semaphore_test+0x6d>
//	  sleep(5);
   sem_wait(sem);
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	ff 75 f4             	pushl  -0xc(%ebp)
  48:	e8 98 03 00 00       	call   3e5 <sem_wait>
  4d:	83 c4 10             	add    $0x10,%esp
   printf(stdout, "C\n");
  50:	a1 e8 0a 00 00       	mov    0xae8,%eax
  55:	83 ec 08             	sub    $0x8,%esp
  58:	68 7b 08 00 00       	push   $0x87b
  5d:	50                   	push   %eax
  5e:	e8 5e 04 00 00       	call   4c1 <printf>
  63:	83 c4 10             	add    $0x10,%esp
   wait();
  66:	e8 c2 02 00 00       	call   32d <wait>
   return;
  6b:	eb 4f                	jmp    bc <semaphore_test+0xbc>
//   sem_destroy(sem);
  }
  else {
    sleep(500);
  6d:	83 ec 0c             	sub    $0xc,%esp
  70:	68 f4 01 00 00       	push   $0x1f4
  75:	e8 3b 03 00 00       	call   3b5 <sleep>
  7a:	83 c4 10             	add    $0x10,%esp
    printf (stdout,  "B\n");
  7d:	a1 e8 0a 00 00       	mov    0xae8,%eax
  82:	83 ec 08             	sub    $0x8,%esp
  85:	68 7e 08 00 00       	push   $0x87e
  8a:	50                   	push   %eax
  8b:	e8 31 04 00 00       	call   4c1 <printf>
  90:	83 c4 10             	add    $0x10,%esp
    sem_post(sem);
  93:	83 ec 0c             	sub    $0xc,%esp
  96:	ff 75 f4             	pushl  -0xc(%ebp)
  99:	e8 3f 03 00 00       	call   3dd <sem_post>
  9e:	83 c4 10             	add    $0x10,%esp
    printf (stdout, "D\n");
  a1:	a1 e8 0a 00 00       	mov    0xae8,%eax
  a6:	83 ec 08             	sub    $0x8,%esp
  a9:	68 81 08 00 00       	push   $0x881
  ae:	50                   	push   %eax
  af:	e8 0d 04 00 00       	call   4c1 <printf>
  b4:	83 c4 10             	add    $0x10,%esp
    exit();
  b7:	e8 69 02 00 00       	call   325 <exit>
  }
}
  bc:	c9                   	leave  
  bd:	c3                   	ret    

000000be <main>:


int
main(int argc, char *argv[])
{
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	83 e4 f0             	and    $0xfffffff0,%esp
  semaphore_test();
  c4:	e8 37 ff ff ff       	call   0 <semaphore_test>
  exit();
  c9:	e8 57 02 00 00       	call   325 <exit>

000000ce <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	57                   	push   %edi
  d2:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  d6:	8b 55 10             	mov    0x10(%ebp),%edx
  d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  dc:	89 cb                	mov    %ecx,%ebx
  de:	89 df                	mov    %ebx,%edi
  e0:	89 d1                	mov    %edx,%ecx
  e2:	fc                   	cld    
  e3:	f3 aa                	rep stos %al,%es:(%edi)
  e5:	89 ca                	mov    %ecx,%edx
  e7:	89 fb                	mov    %edi,%ebx
  e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ec:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  ef:	90                   	nop
  f0:	5b                   	pop    %ebx
  f1:	5f                   	pop    %edi
  f2:	5d                   	pop    %ebp
  f3:	c3                   	ret    

000000f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  fa:	8b 45 08             	mov    0x8(%ebp),%eax
  fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 100:	90                   	nop
 101:	8b 55 0c             	mov    0xc(%ebp),%edx
 104:	8d 42 01             	lea    0x1(%edx),%eax
 107:	89 45 0c             	mov    %eax,0xc(%ebp)
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
 10d:	8d 48 01             	lea    0x1(%eax),%ecx
 110:	89 4d 08             	mov    %ecx,0x8(%ebp)
 113:	0f b6 12             	movzbl (%edx),%edx
 116:	88 10                	mov    %dl,(%eax)
 118:	0f b6 00             	movzbl (%eax),%eax
 11b:	84 c0                	test   %al,%al
 11d:	75 e2                	jne    101 <strcpy+0xd>
    ;
  return os;
 11f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 122:	c9                   	leave  
 123:	c3                   	ret    

00000124 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 127:	eb 08                	jmp    131 <strcmp+0xd>
    p++, q++;
 129:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	0f b6 00             	movzbl (%eax),%eax
 137:	84 c0                	test   %al,%al
 139:	74 10                	je     14b <strcmp+0x27>
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	0f b6 10             	movzbl (%eax),%edx
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	0f b6 00             	movzbl (%eax),%eax
 147:	38 c2                	cmp    %al,%dl
 149:	74 de                	je     129 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	0f b6 00             	movzbl (%eax),%eax
 151:	0f b6 d0             	movzbl %al,%edx
 154:	8b 45 0c             	mov    0xc(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	0f b6 c8             	movzbl %al,%ecx
 15d:	89 d0                	mov    %edx,%eax
 15f:	29 c8                	sub    %ecx,%eax
}
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    

00000163 <strlen>:

uint
strlen(char *s)
{
 163:	55                   	push   %ebp
 164:	89 e5                	mov    %esp,%ebp
 166:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 169:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 170:	eb 04                	jmp    176 <strlen+0x13>
 172:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 176:	8b 55 fc             	mov    -0x4(%ebp),%edx
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	01 d0                	add    %edx,%eax
 17e:	0f b6 00             	movzbl (%eax),%eax
 181:	84 c0                	test   %al,%al
 183:	75 ed                	jne    172 <strlen+0xf>
    ;
  return n;
 185:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 188:	c9                   	leave  
 189:	c3                   	ret    

0000018a <memset>:

void*
memset(void *dst, int c, uint n)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 18d:	8b 45 10             	mov    0x10(%ebp),%eax
 190:	50                   	push   %eax
 191:	ff 75 0c             	pushl  0xc(%ebp)
 194:	ff 75 08             	pushl  0x8(%ebp)
 197:	e8 32 ff ff ff       	call   ce <stosb>
 19c:	83 c4 0c             	add    $0xc,%esp
  return dst;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 04             	sub    $0x4,%esp
 1aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ad:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b0:	eb 14                	jmp    1c6 <strchr+0x22>
    if(*s == c)
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	0f b6 00             	movzbl (%eax),%eax
 1b8:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1bb:	75 05                	jne    1c2 <strchr+0x1e>
      return (char*)s;
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
 1c0:	eb 13                	jmp    1d5 <strchr+0x31>
  for(; *s; s++)
 1c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c6:	8b 45 08             	mov    0x8(%ebp),%eax
 1c9:	0f b6 00             	movzbl (%eax),%eax
 1cc:	84 c0                	test   %al,%al
 1ce:	75 e2                	jne    1b2 <strchr+0xe>
  return 0;
 1d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1d5:	c9                   	leave  
 1d6:	c3                   	ret    

000001d7 <gets>:

char*
gets(char *buf, int max)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e4:	eb 42                	jmp    228 <gets+0x51>
    cc = read(0, &c, 1);
 1e6:	83 ec 04             	sub    $0x4,%esp
 1e9:	6a 01                	push   $0x1
 1eb:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ee:	50                   	push   %eax
 1ef:	6a 00                	push   $0x0
 1f1:	e8 47 01 00 00       	call   33d <read>
 1f6:	83 c4 10             	add    $0x10,%esp
 1f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 200:	7e 33                	jle    235 <gets+0x5e>
      break;
    buf[i++] = c;
 202:	8b 45 f4             	mov    -0xc(%ebp),%eax
 205:	8d 50 01             	lea    0x1(%eax),%edx
 208:	89 55 f4             	mov    %edx,-0xc(%ebp)
 20b:	89 c2                	mov    %eax,%edx
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
 210:	01 c2                	add    %eax,%edx
 212:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 216:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 218:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21c:	3c 0a                	cmp    $0xa,%al
 21e:	74 16                	je     236 <gets+0x5f>
 220:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 224:	3c 0d                	cmp    $0xd,%al
 226:	74 0e                	je     236 <gets+0x5f>
  for(i=0; i+1 < max; ){
 228:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22b:	83 c0 01             	add    $0x1,%eax
 22e:	39 45 0c             	cmp    %eax,0xc(%ebp)
 231:	7f b3                	jg     1e6 <gets+0xf>
 233:	eb 01                	jmp    236 <gets+0x5f>
      break;
 235:	90                   	nop
      break;
  }
  buf[i] = '\0';
 236:	8b 55 f4             	mov    -0xc(%ebp),%edx
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	01 d0                	add    %edx,%eax
 23e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 241:	8b 45 08             	mov    0x8(%ebp),%eax
}
 244:	c9                   	leave  
 245:	c3                   	ret    

00000246 <stat>:

int
stat(char *n, struct stat *st)
{
 246:	55                   	push   %ebp
 247:	89 e5                	mov    %esp,%ebp
 249:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24c:	83 ec 08             	sub    $0x8,%esp
 24f:	6a 00                	push   $0x0
 251:	ff 75 08             	pushl  0x8(%ebp)
 254:	e8 0c 01 00 00       	call   365 <open>
 259:	83 c4 10             	add    $0x10,%esp
 25c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 25f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 263:	79 07                	jns    26c <stat+0x26>
    return -1;
 265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 26a:	eb 25                	jmp    291 <stat+0x4b>
  r = fstat(fd, st);
 26c:	83 ec 08             	sub    $0x8,%esp
 26f:	ff 75 0c             	pushl  0xc(%ebp)
 272:	ff 75 f4             	pushl  -0xc(%ebp)
 275:	e8 03 01 00 00       	call   37d <fstat>
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 280:	83 ec 0c             	sub    $0xc,%esp
 283:	ff 75 f4             	pushl  -0xc(%ebp)
 286:	e8 c2 00 00 00       	call   34d <close>
 28b:	83 c4 10             	add    $0x10,%esp
  return r;
 28e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <atoi>:

int
atoi(const char *s)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 299:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2a0:	eb 25                	jmp    2c7 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2a5:	89 d0                	mov    %edx,%eax
 2a7:	c1 e0 02             	shl    $0x2,%eax
 2aa:	01 d0                	add    %edx,%eax
 2ac:	01 c0                	add    %eax,%eax
 2ae:	89 c1                	mov    %eax,%ecx
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	8d 50 01             	lea    0x1(%eax),%edx
 2b6:	89 55 08             	mov    %edx,0x8(%ebp)
 2b9:	0f b6 00             	movzbl (%eax),%eax
 2bc:	0f be c0             	movsbl %al,%eax
 2bf:	01 c8                	add    %ecx,%eax
 2c1:	83 e8 30             	sub    $0x30,%eax
 2c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	0f b6 00             	movzbl (%eax),%eax
 2cd:	3c 2f                	cmp    $0x2f,%al
 2cf:	7e 0a                	jle    2db <atoi+0x48>
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	0f b6 00             	movzbl (%eax),%eax
 2d7:	3c 39                	cmp    $0x39,%al
 2d9:	7e c7                	jle    2a2 <atoi+0xf>
  return n;
 2db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2de:	c9                   	leave  
 2df:	c3                   	ret    

000002e0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2f2:	eb 17                	jmp    30b <memmove+0x2b>
    *dst++ = *src++;
 2f4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2f7:	8d 42 01             	lea    0x1(%edx),%eax
 2fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 300:	8d 48 01             	lea    0x1(%eax),%ecx
 303:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 306:	0f b6 12             	movzbl (%edx),%edx
 309:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 30b:	8b 45 10             	mov    0x10(%ebp),%eax
 30e:	8d 50 ff             	lea    -0x1(%eax),%edx
 311:	89 55 10             	mov    %edx,0x10(%ebp)
 314:	85 c0                	test   %eax,%eax
 316:	7f dc                	jg     2f4 <memmove+0x14>
  return vdst;
 318:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31b:	c9                   	leave  
 31c:	c3                   	ret    

0000031d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 31d:	b8 01 00 00 00       	mov    $0x1,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <exit>:
SYSCALL(exit)
 325:	b8 02 00 00 00       	mov    $0x2,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <wait>:
SYSCALL(wait)
 32d:	b8 03 00 00 00       	mov    $0x3,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <pipe>:
SYSCALL(pipe)
 335:	b8 04 00 00 00       	mov    $0x4,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <read>:
SYSCALL(read)
 33d:	b8 05 00 00 00       	mov    $0x5,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <write>:
SYSCALL(write)
 345:	b8 15 00 00 00       	mov    $0x15,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <close>:
SYSCALL(close)
 34d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <kill>:
SYSCALL(kill)
 355:	b8 06 00 00 00       	mov    $0x6,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <exec>:
SYSCALL(exec)
 35d:	b8 07 00 00 00       	mov    $0x7,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <open>:
SYSCALL(open)
 365:	b8 14 00 00 00       	mov    $0x14,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <mknod>:
SYSCALL(mknod)
 36d:	b8 16 00 00 00       	mov    $0x16,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <unlink>:
SYSCALL(unlink)
 375:	b8 17 00 00 00       	mov    $0x17,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <fstat>:
SYSCALL(fstat)
 37d:	b8 08 00 00 00       	mov    $0x8,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <link>:
SYSCALL(link)
 385:	b8 18 00 00 00       	mov    $0x18,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <mkdir>:
SYSCALL(mkdir)
 38d:	b8 19 00 00 00       	mov    $0x19,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <chdir>:
SYSCALL(chdir)
 395:	b8 09 00 00 00       	mov    $0x9,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <dup>:
SYSCALL(dup)
 39d:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <getpid>:
SYSCALL(getpid)
 3a5:	b8 0b 00 00 00       	mov    $0xb,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <sbrk>:
SYSCALL(sbrk)
 3ad:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <sleep>:
SYSCALL(sleep)
 3b5:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <uptime>:
SYSCALL(uptime)
 3bd:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <sem_alloc>:
SYSCALL(sem_alloc)
 3c5:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <sem_destroy>:
SYSCALL(sem_destroy)
 3cd:	b8 10 00 00 00       	mov    $0x10,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <sem_init>:
SYSCALL(sem_init)
 3d5:	b8 11 00 00 00       	mov    $0x11,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <sem_post>:
SYSCALL(sem_post)
 3dd:	b8 12 00 00 00       	mov    $0x12,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <sem_wait>:
SYSCALL(sem_wait)
 3e5:	b8 13 00 00 00       	mov    $0x13,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3ed:	55                   	push   %ebp
 3ee:	89 e5                	mov    %esp,%ebp
 3f0:	83 ec 18             	sub    $0x18,%esp
 3f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3f9:	83 ec 04             	sub    $0x4,%esp
 3fc:	6a 01                	push   $0x1
 3fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
 401:	50                   	push   %eax
 402:	ff 75 08             	pushl  0x8(%ebp)
 405:	e8 3b ff ff ff       	call   345 <write>
 40a:	83 c4 10             	add    $0x10,%esp
}
 40d:	90                   	nop
 40e:	c9                   	leave  
 40f:	c3                   	ret    

00000410 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 416:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 41d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 421:	74 17                	je     43a <printint+0x2a>
 423:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 427:	79 11                	jns    43a <printint+0x2a>
    neg = 1;
 429:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 430:	8b 45 0c             	mov    0xc(%ebp),%eax
 433:	f7 d8                	neg    %eax
 435:	89 45 ec             	mov    %eax,-0x14(%ebp)
 438:	eb 06                	jmp    440 <printint+0x30>
  } else {
    x = xx;
 43a:	8b 45 0c             	mov    0xc(%ebp),%eax
 43d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 440:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 447:	8b 4d 10             	mov    0x10(%ebp),%ecx
 44a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 44d:	ba 00 00 00 00       	mov    $0x0,%edx
 452:	f7 f1                	div    %ecx
 454:	89 d1                	mov    %edx,%ecx
 456:	8b 45 f4             	mov    -0xc(%ebp),%eax
 459:	8d 50 01             	lea    0x1(%eax),%edx
 45c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45f:	0f b6 91 ec 0a 00 00 	movzbl 0xaec(%ecx),%edx
 466:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 46a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 46d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 470:	ba 00 00 00 00       	mov    $0x0,%edx
 475:	f7 f1                	div    %ecx
 477:	89 45 ec             	mov    %eax,-0x14(%ebp)
 47a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47e:	75 c7                	jne    447 <printint+0x37>
  if(neg)
 480:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 484:	74 2d                	je     4b3 <printint+0xa3>
    buf[i++] = '-';
 486:	8b 45 f4             	mov    -0xc(%ebp),%eax
 489:	8d 50 01             	lea    0x1(%eax),%edx
 48c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 48f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 494:	eb 1d                	jmp    4b3 <printint+0xa3>
    putc(fd, buf[i]);
 496:	8d 55 dc             	lea    -0x24(%ebp),%edx
 499:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49c:	01 d0                	add    %edx,%eax
 49e:	0f b6 00             	movzbl (%eax),%eax
 4a1:	0f be c0             	movsbl %al,%eax
 4a4:	83 ec 08             	sub    $0x8,%esp
 4a7:	50                   	push   %eax
 4a8:	ff 75 08             	pushl  0x8(%ebp)
 4ab:	e8 3d ff ff ff       	call   3ed <putc>
 4b0:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4bb:	79 d9                	jns    496 <printint+0x86>
}
 4bd:	90                   	nop
 4be:	90                   	nop
 4bf:	c9                   	leave  
 4c0:	c3                   	ret    

000004c1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4c1:	55                   	push   %ebp
 4c2:	89 e5                	mov    %esp,%ebp
 4c4:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ce:	8d 45 0c             	lea    0xc(%ebp),%eax
 4d1:	83 c0 04             	add    $0x4,%eax
 4d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4de:	e9 59 01 00 00       	jmp    63c <printf+0x17b>
    c = fmt[i] & 0xff;
 4e3:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e9:	01 d0                	add    %edx,%eax
 4eb:	0f b6 00             	movzbl (%eax),%eax
 4ee:	0f be c0             	movsbl %al,%eax
 4f1:	25 ff 00 00 00       	and    $0xff,%eax
 4f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4fd:	75 2c                	jne    52b <printf+0x6a>
      if(c == '%'){
 4ff:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 503:	75 0c                	jne    511 <printf+0x50>
        state = '%';
 505:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 50c:	e9 27 01 00 00       	jmp    638 <printf+0x177>
      } else {
        putc(fd, c);
 511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 514:	0f be c0             	movsbl %al,%eax
 517:	83 ec 08             	sub    $0x8,%esp
 51a:	50                   	push   %eax
 51b:	ff 75 08             	pushl  0x8(%ebp)
 51e:	e8 ca fe ff ff       	call   3ed <putc>
 523:	83 c4 10             	add    $0x10,%esp
 526:	e9 0d 01 00 00       	jmp    638 <printf+0x177>
      }
    } else if(state == '%'){
 52b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 52f:	0f 85 03 01 00 00    	jne    638 <printf+0x177>
      if(c == 'd'){
 535:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 539:	75 1e                	jne    559 <printf+0x98>
        printint(fd, *ap, 10, 1);
 53b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53e:	8b 00                	mov    (%eax),%eax
 540:	6a 01                	push   $0x1
 542:	6a 0a                	push   $0xa
 544:	50                   	push   %eax
 545:	ff 75 08             	pushl  0x8(%ebp)
 548:	e8 c3 fe ff ff       	call   410 <printint>
 54d:	83 c4 10             	add    $0x10,%esp
        ap++;
 550:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 554:	e9 d8 00 00 00       	jmp    631 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 559:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 55d:	74 06                	je     565 <printf+0xa4>
 55f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 563:	75 1e                	jne    583 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 565:	8b 45 e8             	mov    -0x18(%ebp),%eax
 568:	8b 00                	mov    (%eax),%eax
 56a:	6a 00                	push   $0x0
 56c:	6a 10                	push   $0x10
 56e:	50                   	push   %eax
 56f:	ff 75 08             	pushl  0x8(%ebp)
 572:	e8 99 fe ff ff       	call   410 <printint>
 577:	83 c4 10             	add    $0x10,%esp
        ap++;
 57a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57e:	e9 ae 00 00 00       	jmp    631 <printf+0x170>
      } else if(c == 's'){
 583:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 587:	75 43                	jne    5cc <printf+0x10b>
        s = (char*)*ap;
 589:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58c:	8b 00                	mov    (%eax),%eax
 58e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 591:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 595:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 599:	75 25                	jne    5c0 <printf+0xff>
          s = "(null)";
 59b:	c7 45 f4 84 08 00 00 	movl   $0x884,-0xc(%ebp)
        while(*s != 0){
 5a2:	eb 1c                	jmp    5c0 <printf+0xff>
          putc(fd, *s);
 5a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a7:	0f b6 00             	movzbl (%eax),%eax
 5aa:	0f be c0             	movsbl %al,%eax
 5ad:	83 ec 08             	sub    $0x8,%esp
 5b0:	50                   	push   %eax
 5b1:	ff 75 08             	pushl  0x8(%ebp)
 5b4:	e8 34 fe ff ff       	call   3ed <putc>
 5b9:	83 c4 10             	add    $0x10,%esp
          s++;
 5bc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c3:	0f b6 00             	movzbl (%eax),%eax
 5c6:	84 c0                	test   %al,%al
 5c8:	75 da                	jne    5a4 <printf+0xe3>
 5ca:	eb 65                	jmp    631 <printf+0x170>
        }
      } else if(c == 'c'){
 5cc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d0:	75 1d                	jne    5ef <printf+0x12e>
        putc(fd, *ap);
 5d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d5:	8b 00                	mov    (%eax),%eax
 5d7:	0f be c0             	movsbl %al,%eax
 5da:	83 ec 08             	sub    $0x8,%esp
 5dd:	50                   	push   %eax
 5de:	ff 75 08             	pushl  0x8(%ebp)
 5e1:	e8 07 fe ff ff       	call   3ed <putc>
 5e6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ed:	eb 42                	jmp    631 <printf+0x170>
      } else if(c == '%'){
 5ef:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f3:	75 17                	jne    60c <printf+0x14b>
        putc(fd, c);
 5f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f8:	0f be c0             	movsbl %al,%eax
 5fb:	83 ec 08             	sub    $0x8,%esp
 5fe:	50                   	push   %eax
 5ff:	ff 75 08             	pushl  0x8(%ebp)
 602:	e8 e6 fd ff ff       	call   3ed <putc>
 607:	83 c4 10             	add    $0x10,%esp
 60a:	eb 25                	jmp    631 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 60c:	83 ec 08             	sub    $0x8,%esp
 60f:	6a 25                	push   $0x25
 611:	ff 75 08             	pushl  0x8(%ebp)
 614:	e8 d4 fd ff ff       	call   3ed <putc>
 619:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 61c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61f:	0f be c0             	movsbl %al,%eax
 622:	83 ec 08             	sub    $0x8,%esp
 625:	50                   	push   %eax
 626:	ff 75 08             	pushl  0x8(%ebp)
 629:	e8 bf fd ff ff       	call   3ed <putc>
 62e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 631:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 638:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 63c:	8b 55 0c             	mov    0xc(%ebp),%edx
 63f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 642:	01 d0                	add    %edx,%eax
 644:	0f b6 00             	movzbl (%eax),%eax
 647:	84 c0                	test   %al,%al
 649:	0f 85 94 fe ff ff    	jne    4e3 <printf+0x22>
    }
  }
}
 64f:	90                   	nop
 650:	90                   	nop
 651:	c9                   	leave  
 652:	c3                   	ret    

00000653 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 653:	55                   	push   %ebp
 654:	89 e5                	mov    %esp,%ebp
 656:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 659:	8b 45 08             	mov    0x8(%ebp),%eax
 65c:	83 e8 08             	sub    $0x8,%eax
 65f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 662:	a1 0c 2b 00 00       	mov    0x2b0c,%eax
 667:	89 45 fc             	mov    %eax,-0x4(%ebp)
 66a:	eb 24                	jmp    690 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	8b 00                	mov    (%eax),%eax
 671:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 674:	72 12                	jb     688 <free+0x35>
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67c:	77 24                	ja     6a2 <free+0x4f>
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 686:	72 1a                	jb     6a2 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 690:	8b 45 f8             	mov    -0x8(%ebp),%eax
 693:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 696:	76 d4                	jbe    66c <free+0x19>
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 00                	mov    (%eax),%eax
 69d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6a0:	73 ca                	jae    66c <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a5:	8b 40 04             	mov    0x4(%eax),%eax
 6a8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b2:	01 c2                	add    %eax,%edx
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	8b 00                	mov    (%eax),%eax
 6b9:	39 c2                	cmp    %eax,%edx
 6bb:	75 24                	jne    6e1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c0:	8b 50 04             	mov    0x4(%eax),%edx
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	8b 00                	mov    (%eax),%eax
 6c8:	8b 40 04             	mov    0x4(%eax),%eax
 6cb:	01 c2                	add    %eax,%edx
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 00                	mov    (%eax),%eax
 6d8:	8b 10                	mov    (%eax),%edx
 6da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dd:	89 10                	mov    %edx,(%eax)
 6df:	eb 0a                	jmp    6eb <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 10                	mov    (%eax),%edx
 6e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	8b 40 04             	mov    0x4(%eax),%eax
 6f1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	01 d0                	add    %edx,%eax
 6fd:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 700:	75 20                	jne    722 <free+0xcf>
    p->s.size += bp->s.size;
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 50 04             	mov    0x4(%eax),%edx
 708:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70b:	8b 40 04             	mov    0x4(%eax),%eax
 70e:	01 c2                	add    %eax,%edx
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 716:	8b 45 f8             	mov    -0x8(%ebp),%eax
 719:	8b 10                	mov    (%eax),%edx
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	89 10                	mov    %edx,(%eax)
 720:	eb 08                	jmp    72a <free+0xd7>
  } else
    p->s.ptr = bp;
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	8b 55 f8             	mov    -0x8(%ebp),%edx
 728:	89 10                	mov    %edx,(%eax)
  freep = p;
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	a3 0c 2b 00 00       	mov    %eax,0x2b0c
}
 732:	90                   	nop
 733:	c9                   	leave  
 734:	c3                   	ret    

00000735 <morecore>:

static Header*
morecore(uint nu)
{
 735:	55                   	push   %ebp
 736:	89 e5                	mov    %esp,%ebp
 738:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 73b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 742:	77 07                	ja     74b <morecore+0x16>
    nu = 4096;
 744:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 74b:	8b 45 08             	mov    0x8(%ebp),%eax
 74e:	c1 e0 03             	shl    $0x3,%eax
 751:	83 ec 0c             	sub    $0xc,%esp
 754:	50                   	push   %eax
 755:	e8 53 fc ff ff       	call   3ad <sbrk>
 75a:	83 c4 10             	add    $0x10,%esp
 75d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 760:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 764:	75 07                	jne    76d <morecore+0x38>
    return 0;
 766:	b8 00 00 00 00       	mov    $0x0,%eax
 76b:	eb 26                	jmp    793 <morecore+0x5e>
  hp = (Header*)p;
 76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 770:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 773:	8b 45 f0             	mov    -0x10(%ebp),%eax
 776:	8b 55 08             	mov    0x8(%ebp),%edx
 779:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 77c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77f:	83 c0 08             	add    $0x8,%eax
 782:	83 ec 0c             	sub    $0xc,%esp
 785:	50                   	push   %eax
 786:	e8 c8 fe ff ff       	call   653 <free>
 78b:	83 c4 10             	add    $0x10,%esp
  return freep;
 78e:	a1 0c 2b 00 00       	mov    0x2b0c,%eax
}
 793:	c9                   	leave  
 794:	c3                   	ret    

00000795 <malloc>:

void*
malloc(uint nbytes)
{
 795:	55                   	push   %ebp
 796:	89 e5                	mov    %esp,%ebp
 798:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 79b:	8b 45 08             	mov    0x8(%ebp),%eax
 79e:	83 c0 07             	add    $0x7,%eax
 7a1:	c1 e8 03             	shr    $0x3,%eax
 7a4:	83 c0 01             	add    $0x1,%eax
 7a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7aa:	a1 0c 2b 00 00       	mov    0x2b0c,%eax
 7af:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b6:	75 23                	jne    7db <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7b8:	c7 45 f0 04 2b 00 00 	movl   $0x2b04,-0x10(%ebp)
 7bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c2:	a3 0c 2b 00 00       	mov    %eax,0x2b0c
 7c7:	a1 0c 2b 00 00       	mov    0x2b0c,%eax
 7cc:	a3 04 2b 00 00       	mov    %eax,0x2b04
    base.s.size = 0;
 7d1:	c7 05 08 2b 00 00 00 	movl   $0x0,0x2b08
 7d8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7de:	8b 00                	mov    (%eax),%eax
 7e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	8b 40 04             	mov    0x4(%eax),%eax
 7e9:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7ec:	77 4d                	ja     83b <malloc+0xa6>
      if(p->s.size == nunits)
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	8b 40 04             	mov    0x4(%eax),%eax
 7f4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7f7:	75 0c                	jne    805 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	8b 10                	mov    (%eax),%edx
 7fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 801:	89 10                	mov    %edx,(%eax)
 803:	eb 26                	jmp    82b <malloc+0x96>
      else {
        p->s.size -= nunits;
 805:	8b 45 f4             	mov    -0xc(%ebp),%eax
 808:	8b 40 04             	mov    0x4(%eax),%eax
 80b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 80e:	89 c2                	mov    %eax,%edx
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	8b 40 04             	mov    0x4(%eax),%eax
 81c:	c1 e0 03             	shl    $0x3,%eax
 81f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	8b 55 ec             	mov    -0x14(%ebp),%edx
 828:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 82b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82e:	a3 0c 2b 00 00       	mov    %eax,0x2b0c
      return (void*)(p + 1);
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	83 c0 08             	add    $0x8,%eax
 839:	eb 3b                	jmp    876 <malloc+0xe1>
    }
    if(p == freep)
 83b:	a1 0c 2b 00 00       	mov    0x2b0c,%eax
 840:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 843:	75 1e                	jne    863 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 845:	83 ec 0c             	sub    $0xc,%esp
 848:	ff 75 ec             	pushl  -0x14(%ebp)
 84b:	e8 e5 fe ff ff       	call   735 <morecore>
 850:	83 c4 10             	add    $0x10,%esp
 853:	89 45 f4             	mov    %eax,-0xc(%ebp)
 856:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 85a:	75 07                	jne    863 <malloc+0xce>
        return 0;
 85c:	b8 00 00 00 00       	mov    $0x0,%eax
 861:	eb 13                	jmp    876 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	89 45 f0             	mov    %eax,-0x10(%ebp)
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8b 00                	mov    (%eax),%eax
 86e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 871:	e9 6d ff ff ff       	jmp    7e3 <malloc+0x4e>
  }
}
 876:	c9                   	leave  
 877:	c3                   	ret    
