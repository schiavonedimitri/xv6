
_cat:     formato del file elf32-i386


Disassemblamento della sezione .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	pushl  -0xc(%ebp)
   e:	68 80 0b 00 00       	push   $0xb80
  13:	6a 01                	push   $0x1
  15:	e8 6c 03 00 00       	call   386 <write>
  1a:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 80 0b 00 00       	push   $0xb80
  2a:	ff 75 08             	pushl  0x8(%ebp)
  2d:	e8 4c 03 00 00       	call   37e <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 b9 08 00 00       	push   $0x8b9
  4c:	6a 01                	push   $0x1
  4e:	e8 af 04 00 00       	call   502 <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 0b 03 00 00       	call   366 <exit>
  }
}
  5b:	90                   	nop
  5c:	c9                   	leave  
  5d:	c3                   	ret    

0000005e <main>:

int
main(int argc, char *argv[])
{
  5e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  62:	83 e4 f0             	and    $0xfffffff0,%esp
  65:	ff 71 fc             	pushl  -0x4(%ecx)
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	53                   	push   %ebx
  6c:	51                   	push   %ecx
  6d:	83 ec 10             	sub    $0x10,%esp
  70:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  72:	83 3b 01             	cmpl   $0x1,(%ebx)
  75:	7f 12                	jg     89 <main+0x2b>
    cat(0);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	6a 00                	push   $0x0
  7c:	e8 7f ff ff ff       	call   0 <cat>
  81:	83 c4 10             	add    $0x10,%esp
    exit();
  84:	e8 dd 02 00 00       	call   366 <exit>
  }

  for(i = 1; i < argc; i++){
  89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  90:	eb 71                	jmp    103 <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9c:	8b 43 04             	mov    0x4(%ebx),%eax
  9f:	01 d0                	add    %edx,%eax
  a1:	8b 00                	mov    (%eax),%eax
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	6a 00                	push   $0x0
  a8:	50                   	push   %eax
  a9:	e8 f8 02 00 00       	call   3a6 <open>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b8:	79 29                	jns    e3 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c4:	8b 43 04             	mov    0x4(%ebx),%eax
  c7:	01 d0                	add    %edx,%eax
  c9:	8b 00                	mov    (%eax),%eax
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	50                   	push   %eax
  cf:	68 ca 08 00 00       	push   $0x8ca
  d4:	6a 01                	push   $0x1
  d6:	e8 27 04 00 00       	call   502 <printf>
  db:	83 c4 10             	add    $0x10,%esp
      exit();
  de:	e8 83 02 00 00       	call   366 <exit>
    }
    cat(fd);
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	ff 75 f0             	pushl  -0x10(%ebp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
  ee:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	ff 75 f0             	pushl  -0x10(%ebp)
  f7:	e8 92 02 00 00       	call   38e <close>
  fc:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
  ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 103:	8b 45 f4             	mov    -0xc(%ebp),%eax
 106:	3b 03                	cmp    (%ebx),%eax
 108:	7c 88                	jl     92 <main+0x34>
  }
  exit();
 10a:	e8 57 02 00 00       	call   366 <exit>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	90                   	nop
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 55 0c             	mov    0xc(%ebp),%edx
 145:	8d 42 01             	lea    0x1(%edx),%eax
 148:	89 45 0c             	mov    %eax,0xc(%ebp)
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	8d 48 01             	lea    0x1(%eax),%ecx
 151:	89 4d 08             	mov    %ecx,0x8(%ebp)
 154:	0f b6 12             	movzbl (%edx),%edx
 157:	88 10                	mov    %dl,(%eax)
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c8             	movzbl %al,%ecx
 19e:	89 d0                	mov    %edx,%eax
 1a0:	29 c8                	sub    %ecx,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    

000001a4 <strlen>:

uint
strlen(char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b1:	eb 04                	jmp    1b7 <strlen+0x13>
 1b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 d0                	add    %edx,%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ed                	jne    1b3 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ce:	8b 45 10             	mov    0x10(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	ff 75 0c             	pushl  0xc(%ebp)
 1d5:	ff 75 08             	pushl  0x8(%ebp)
 1d8:	e8 32 ff ff ff       	call   10f <stosb>
 1dd:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <strchr>:

char*
strchr(const char *s, char c)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 04             	sub    $0x4,%esp
 1eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ee:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f1:	eb 14                	jmp    207 <strchr+0x22>
    if(*s == c)
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1fc:	75 05                	jne    203 <strchr+0x1e>
      return (char*)s;
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	eb 13                	jmp    216 <strchr+0x31>
  for(; *s; s++)
 203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 e2                	jne    1f3 <strchr+0xe>
  return 0;
 211:	b8 00 00 00 00       	mov    $0x0,%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 225:	eb 42                	jmp    269 <gets+0x51>
    cc = read(0, &c, 1);
 227:	83 ec 04             	sub    $0x4,%esp
 22a:	6a 01                	push   $0x1
 22c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 22f:	50                   	push   %eax
 230:	6a 00                	push   $0x0
 232:	e8 47 01 00 00       	call   37e <read>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 241:	7e 33                	jle    276 <gets+0x5e>
      break;
    buf[i++] = c;
 243:	8b 45 f4             	mov    -0xc(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 f4             	mov    %edx,-0xc(%ebp)
 24c:	89 c2                	mov    %eax,%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	01 c2                	add    %eax,%edx
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25d:	3c 0a                	cmp    $0xa,%al
 25f:	74 16                	je     277 <gets+0x5f>
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	3c 0d                	cmp    $0xd,%al
 267:	74 0e                	je     277 <gets+0x5f>
  for(i=0; i+1 < max; ){
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	83 c0 01             	add    $0x1,%eax
 26f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 272:	7f b3                	jg     227 <gets+0xf>
 274:	eb 01                	jmp    277 <gets+0x5f>
      break;
 276:	90                   	nop
      break;
  }
  buf[i] = '\0';
 277:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 282:	8b 45 08             	mov    0x8(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <stat>:

int
stat(char *n, struct stat *st)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	6a 00                	push   $0x0
 292:	ff 75 08             	pushl  0x8(%ebp)
 295:	e8 0c 01 00 00       	call   3a6 <open>
 29a:	83 c4 10             	add    $0x10,%esp
 29d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a4:	79 07                	jns    2ad <stat+0x26>
    return -1;
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 25                	jmp    2d2 <stat+0x4b>
  r = fstat(fd, st);
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	ff 75 0c             	pushl  0xc(%ebp)
 2b3:	ff 75 f4             	pushl  -0xc(%ebp)
 2b6:	e8 03 01 00 00       	call   3be <fstat>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	ff 75 f4             	pushl  -0xc(%ebp)
 2c7:	e8 c2 00 00 00       	call   38e <close>
 2cc:	83 c4 10             	add    $0x10,%esp
  return r;
 2cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e1:	eb 25                	jmp    308 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	c1 e0 02             	shl    $0x2,%eax
 2eb:	01 d0                	add    %edx,%eax
 2ed:	01 c0                	add    %eax,%eax
 2ef:	89 c1                	mov    %eax,%ecx
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 08             	mov    %edx,0x8(%ebp)
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	0f be c0             	movsbl %al,%eax
 300:	01 c8                	add    %ecx,%eax
 302:	83 e8 30             	sub    $0x30,%eax
 305:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	3c 2f                	cmp    $0x2f,%al
 310:	7e 0a                	jle    31c <atoi+0x48>
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	3c 39                	cmp    $0x39,%al
 31a:	7e c7                	jle    2e3 <atoi+0xf>
  return n;
 31c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32d:	8b 45 0c             	mov    0xc(%ebp),%eax
 330:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 333:	eb 17                	jmp    34c <memmove+0x2b>
    *dst++ = *src++;
 335:	8b 55 f8             	mov    -0x8(%ebp),%edx
 338:	8d 42 01             	lea    0x1(%edx),%eax
 33b:	89 45 f8             	mov    %eax,-0x8(%ebp)
 33e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 341:	8d 48 01             	lea    0x1(%eax),%ecx
 344:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 347:	0f b6 12             	movzbl (%edx),%edx
 34a:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 34c:	8b 45 10             	mov    0x10(%ebp),%eax
 34f:	8d 50 ff             	lea    -0x1(%eax),%edx
 352:	89 55 10             	mov    %edx,0x10(%ebp)
 355:	85 c0                	test   %eax,%eax
 357:	7f dc                	jg     335 <memmove+0x14>
  return vdst;
 359:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35e:	b8 01 00 00 00       	mov    $0x1,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <exit>:
SYSCALL(exit)
 366:	b8 02 00 00 00       	mov    $0x2,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <wait>:
SYSCALL(wait)
 36e:	b8 03 00 00 00       	mov    $0x3,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <pipe>:
SYSCALL(pipe)
 376:	b8 04 00 00 00       	mov    $0x4,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <read>:
SYSCALL(read)
 37e:	b8 05 00 00 00       	mov    $0x5,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <write>:
SYSCALL(write)
 386:	b8 15 00 00 00       	mov    $0x15,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <close>:
SYSCALL(close)
 38e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <kill>:
SYSCALL(kill)
 396:	b8 06 00 00 00       	mov    $0x6,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <exec>:
SYSCALL(exec)
 39e:	b8 07 00 00 00       	mov    $0x7,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <open>:
SYSCALL(open)
 3a6:	b8 14 00 00 00       	mov    $0x14,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <mknod>:
SYSCALL(mknod)
 3ae:	b8 16 00 00 00       	mov    $0x16,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <unlink>:
SYSCALL(unlink)
 3b6:	b8 17 00 00 00       	mov    $0x17,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <fstat>:
SYSCALL(fstat)
 3be:	b8 08 00 00 00       	mov    $0x8,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <link>:
SYSCALL(link)
 3c6:	b8 18 00 00 00       	mov    $0x18,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <mkdir>:
SYSCALL(mkdir)
 3ce:	b8 19 00 00 00       	mov    $0x19,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <chdir>:
SYSCALL(chdir)
 3d6:	b8 09 00 00 00       	mov    $0x9,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <dup>:
SYSCALL(dup)
 3de:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <getpid>:
SYSCALL(getpid)
 3e6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <sbrk>:
SYSCALL(sbrk)
 3ee:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <sleep>:
SYSCALL(sleep)
 3f6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <uptime>:
SYSCALL(uptime)
 3fe:	b8 0e 00 00 00       	mov    $0xe,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <sem_alloc>:
SYSCALL(sem_alloc)
 406:	b8 0f 00 00 00       	mov    $0xf,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <sem_destroy>:
SYSCALL(sem_destroy)
 40e:	b8 10 00 00 00       	mov    $0x10,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <sem_init>:
SYSCALL(sem_init)
 416:	b8 11 00 00 00       	mov    $0x11,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <sem_post>:
SYSCALL(sem_post)
 41e:	b8 12 00 00 00       	mov    $0x12,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <sem_wait>:
SYSCALL(sem_wait)
 426:	b8 13 00 00 00       	mov    $0x13,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 42e:	55                   	push   %ebp
 42f:	89 e5                	mov    %esp,%ebp
 431:	83 ec 18             	sub    $0x18,%esp
 434:	8b 45 0c             	mov    0xc(%ebp),%eax
 437:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 43a:	83 ec 04             	sub    $0x4,%esp
 43d:	6a 01                	push   $0x1
 43f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 442:	50                   	push   %eax
 443:	ff 75 08             	pushl  0x8(%ebp)
 446:	e8 3b ff ff ff       	call   386 <write>
 44b:	83 c4 10             	add    $0x10,%esp
}
 44e:	90                   	nop
 44f:	c9                   	leave  
 450:	c3                   	ret    

00000451 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 451:	55                   	push   %ebp
 452:	89 e5                	mov    %esp,%ebp
 454:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 457:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 45e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 462:	74 17                	je     47b <printint+0x2a>
 464:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 468:	79 11                	jns    47b <printint+0x2a>
    neg = 1;
 46a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 471:	8b 45 0c             	mov    0xc(%ebp),%eax
 474:	f7 d8                	neg    %eax
 476:	89 45 ec             	mov    %eax,-0x14(%ebp)
 479:	eb 06                	jmp    481 <printint+0x30>
  } else {
    x = xx;
 47b:	8b 45 0c             	mov    0xc(%ebp),%eax
 47e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 481:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 488:	8b 4d 10             	mov    0x10(%ebp),%ecx
 48b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48e:	ba 00 00 00 00       	mov    $0x0,%edx
 493:	f7 f1                	div    %ecx
 495:	89 d1                	mov    %edx,%ecx
 497:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49a:	8d 50 01             	lea    0x1(%eax),%edx
 49d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a0:	0f b6 91 50 0b 00 00 	movzbl 0xb50(%ecx),%edx
 4a7:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b1:	ba 00 00 00 00       	mov    $0x0,%edx
 4b6:	f7 f1                	div    %ecx
 4b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4bf:	75 c7                	jne    488 <printint+0x37>
  if(neg)
 4c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c5:	74 2d                	je     4f4 <printint+0xa3>
    buf[i++] = '-';
 4c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ca:	8d 50 01             	lea    0x1(%eax),%edx
 4cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4d0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4d5:	eb 1d                	jmp    4f4 <printint+0xa3>
    putc(fd, buf[i]);
 4d7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4dd:	01 d0                	add    %edx,%eax
 4df:	0f b6 00             	movzbl (%eax),%eax
 4e2:	0f be c0             	movsbl %al,%eax
 4e5:	83 ec 08             	sub    $0x8,%esp
 4e8:	50                   	push   %eax
 4e9:	ff 75 08             	pushl  0x8(%ebp)
 4ec:	e8 3d ff ff ff       	call   42e <putc>
 4f1:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4f4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4fc:	79 d9                	jns    4d7 <printint+0x86>
}
 4fe:	90                   	nop
 4ff:	90                   	nop
 500:	c9                   	leave  
 501:	c3                   	ret    

00000502 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 502:	55                   	push   %ebp
 503:	89 e5                	mov    %esp,%ebp
 505:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 508:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 50f:	8d 45 0c             	lea    0xc(%ebp),%eax
 512:	83 c0 04             	add    $0x4,%eax
 515:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 518:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 51f:	e9 59 01 00 00       	jmp    67d <printf+0x17b>
    c = fmt[i] & 0xff;
 524:	8b 55 0c             	mov    0xc(%ebp),%edx
 527:	8b 45 f0             	mov    -0x10(%ebp),%eax
 52a:	01 d0                	add    %edx,%eax
 52c:	0f b6 00             	movzbl (%eax),%eax
 52f:	0f be c0             	movsbl %al,%eax
 532:	25 ff 00 00 00       	and    $0xff,%eax
 537:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 53a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53e:	75 2c                	jne    56c <printf+0x6a>
      if(c == '%'){
 540:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 544:	75 0c                	jne    552 <printf+0x50>
        state = '%';
 546:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 54d:	e9 27 01 00 00       	jmp    679 <printf+0x177>
      } else {
        putc(fd, c);
 552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 555:	0f be c0             	movsbl %al,%eax
 558:	83 ec 08             	sub    $0x8,%esp
 55b:	50                   	push   %eax
 55c:	ff 75 08             	pushl  0x8(%ebp)
 55f:	e8 ca fe ff ff       	call   42e <putc>
 564:	83 c4 10             	add    $0x10,%esp
 567:	e9 0d 01 00 00       	jmp    679 <printf+0x177>
      }
    } else if(state == '%'){
 56c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 570:	0f 85 03 01 00 00    	jne    679 <printf+0x177>
      if(c == 'd'){
 576:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 57a:	75 1e                	jne    59a <printf+0x98>
        printint(fd, *ap, 10, 1);
 57c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57f:	8b 00                	mov    (%eax),%eax
 581:	6a 01                	push   $0x1
 583:	6a 0a                	push   $0xa
 585:	50                   	push   %eax
 586:	ff 75 08             	pushl  0x8(%ebp)
 589:	e8 c3 fe ff ff       	call   451 <printint>
 58e:	83 c4 10             	add    $0x10,%esp
        ap++;
 591:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 595:	e9 d8 00 00 00       	jmp    672 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 59a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 59e:	74 06                	je     5a6 <printf+0xa4>
 5a0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5a4:	75 1e                	jne    5c4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a9:	8b 00                	mov    (%eax),%eax
 5ab:	6a 00                	push   $0x0
 5ad:	6a 10                	push   $0x10
 5af:	50                   	push   %eax
 5b0:	ff 75 08             	pushl  0x8(%ebp)
 5b3:	e8 99 fe ff ff       	call   451 <printint>
 5b8:	83 c4 10             	add    $0x10,%esp
        ap++;
 5bb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bf:	e9 ae 00 00 00       	jmp    672 <printf+0x170>
      } else if(c == 's'){
 5c4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5c8:	75 43                	jne    60d <printf+0x10b>
        s = (char*)*ap;
 5ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cd:	8b 00                	mov    (%eax),%eax
 5cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5d2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5da:	75 25                	jne    601 <printf+0xff>
          s = "(null)";
 5dc:	c7 45 f4 df 08 00 00 	movl   $0x8df,-0xc(%ebp)
        while(*s != 0){
 5e3:	eb 1c                	jmp    601 <printf+0xff>
          putc(fd, *s);
 5e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e8:	0f b6 00             	movzbl (%eax),%eax
 5eb:	0f be c0             	movsbl %al,%eax
 5ee:	83 ec 08             	sub    $0x8,%esp
 5f1:	50                   	push   %eax
 5f2:	ff 75 08             	pushl  0x8(%ebp)
 5f5:	e8 34 fe ff ff       	call   42e <putc>
 5fa:	83 c4 10             	add    $0x10,%esp
          s++;
 5fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 601:	8b 45 f4             	mov    -0xc(%ebp),%eax
 604:	0f b6 00             	movzbl (%eax),%eax
 607:	84 c0                	test   %al,%al
 609:	75 da                	jne    5e5 <printf+0xe3>
 60b:	eb 65                	jmp    672 <printf+0x170>
        }
      } else if(c == 'c'){
 60d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 611:	75 1d                	jne    630 <printf+0x12e>
        putc(fd, *ap);
 613:	8b 45 e8             	mov    -0x18(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	0f be c0             	movsbl %al,%eax
 61b:	83 ec 08             	sub    $0x8,%esp
 61e:	50                   	push   %eax
 61f:	ff 75 08             	pushl  0x8(%ebp)
 622:	e8 07 fe ff ff       	call   42e <putc>
 627:	83 c4 10             	add    $0x10,%esp
        ap++;
 62a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62e:	eb 42                	jmp    672 <printf+0x170>
      } else if(c == '%'){
 630:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 634:	75 17                	jne    64d <printf+0x14b>
        putc(fd, c);
 636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 639:	0f be c0             	movsbl %al,%eax
 63c:	83 ec 08             	sub    $0x8,%esp
 63f:	50                   	push   %eax
 640:	ff 75 08             	pushl  0x8(%ebp)
 643:	e8 e6 fd ff ff       	call   42e <putc>
 648:	83 c4 10             	add    $0x10,%esp
 64b:	eb 25                	jmp    672 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 64d:	83 ec 08             	sub    $0x8,%esp
 650:	6a 25                	push   $0x25
 652:	ff 75 08             	pushl  0x8(%ebp)
 655:	e8 d4 fd ff ff       	call   42e <putc>
 65a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 65d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 660:	0f be c0             	movsbl %al,%eax
 663:	83 ec 08             	sub    $0x8,%esp
 666:	50                   	push   %eax
 667:	ff 75 08             	pushl  0x8(%ebp)
 66a:	e8 bf fd ff ff       	call   42e <putc>
 66f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 672:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 679:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 67d:	8b 55 0c             	mov    0xc(%ebp),%edx
 680:	8b 45 f0             	mov    -0x10(%ebp),%eax
 683:	01 d0                	add    %edx,%eax
 685:	0f b6 00             	movzbl (%eax),%eax
 688:	84 c0                	test   %al,%al
 68a:	0f 85 94 fe ff ff    	jne    524 <printf+0x22>
    }
  }
}
 690:	90                   	nop
 691:	90                   	nop
 692:	c9                   	leave  
 693:	c3                   	ret    

00000694 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 69a:	8b 45 08             	mov    0x8(%ebp),%eax
 69d:	83 e8 08             	sub    $0x8,%eax
 6a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a3:	a1 88 0d 00 00       	mov    0xd88,%eax
 6a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ab:	eb 24                	jmp    6d1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6b5:	72 12                	jb     6c9 <free+0x35>
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bd:	77 24                	ja     6e3 <free+0x4f>
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	8b 00                	mov    (%eax),%eax
 6c4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6c7:	72 1a                	jb     6e3 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d7:	76 d4                	jbe    6ad <free+0x19>
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	8b 00                	mov    (%eax),%eax
 6de:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6e1:	73 ca                	jae    6ad <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e6:	8b 40 04             	mov    0x4(%eax),%eax
 6e9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f3:	01 c2                	add    %eax,%edx
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	39 c2                	cmp    %eax,%edx
 6fc:	75 24                	jne    722 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 701:	8b 50 04             	mov    0x4(%eax),%edx
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 00                	mov    (%eax),%eax
 709:	8b 40 04             	mov    0x4(%eax),%eax
 70c:	01 c2                	add    %eax,%edx
 70e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 711:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	8b 00                	mov    (%eax),%eax
 719:	8b 10                	mov    (%eax),%edx
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	89 10                	mov    %edx,(%eax)
 720:	eb 0a                	jmp    72c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	8b 10                	mov    (%eax),%edx
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 40 04             	mov    0x4(%eax),%eax
 732:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	01 d0                	add    %edx,%eax
 73e:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 741:	75 20                	jne    763 <free+0xcf>
    p->s.size += bp->s.size;
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	8b 50 04             	mov    0x4(%eax),%edx
 749:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74c:	8b 40 04             	mov    0x4(%eax),%eax
 74f:	01 c2                	add    %eax,%edx
 751:	8b 45 fc             	mov    -0x4(%ebp),%eax
 754:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	8b 10                	mov    (%eax),%edx
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	89 10                	mov    %edx,(%eax)
 761:	eb 08                	jmp    76b <free+0xd7>
  } else
    p->s.ptr = bp;
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	8b 55 f8             	mov    -0x8(%ebp),%edx
 769:	89 10                	mov    %edx,(%eax)
  freep = p;
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	a3 88 0d 00 00       	mov    %eax,0xd88
}
 773:	90                   	nop
 774:	c9                   	leave  
 775:	c3                   	ret    

00000776 <morecore>:

static Header*
morecore(uint nu)
{
 776:	55                   	push   %ebp
 777:	89 e5                	mov    %esp,%ebp
 779:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 77c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 783:	77 07                	ja     78c <morecore+0x16>
    nu = 4096;
 785:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 78c:	8b 45 08             	mov    0x8(%ebp),%eax
 78f:	c1 e0 03             	shl    $0x3,%eax
 792:	83 ec 0c             	sub    $0xc,%esp
 795:	50                   	push   %eax
 796:	e8 53 fc ff ff       	call   3ee <sbrk>
 79b:	83 c4 10             	add    $0x10,%esp
 79e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7a1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7a5:	75 07                	jne    7ae <morecore+0x38>
    return 0;
 7a7:	b8 00 00 00 00       	mov    $0x0,%eax
 7ac:	eb 26                	jmp    7d4 <morecore+0x5e>
  hp = (Header*)p;
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b7:	8b 55 08             	mov    0x8(%ebp),%edx
 7ba:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c0:	83 c0 08             	add    $0x8,%eax
 7c3:	83 ec 0c             	sub    $0xc,%esp
 7c6:	50                   	push   %eax
 7c7:	e8 c8 fe ff ff       	call   694 <free>
 7cc:	83 c4 10             	add    $0x10,%esp
  return freep;
 7cf:	a1 88 0d 00 00       	mov    0xd88,%eax
}
 7d4:	c9                   	leave  
 7d5:	c3                   	ret    

000007d6 <malloc>:

void*
malloc(uint nbytes)
{
 7d6:	55                   	push   %ebp
 7d7:	89 e5                	mov    %esp,%ebp
 7d9:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7dc:	8b 45 08             	mov    0x8(%ebp),%eax
 7df:	83 c0 07             	add    $0x7,%eax
 7e2:	c1 e8 03             	shr    $0x3,%eax
 7e5:	83 c0 01             	add    $0x1,%eax
 7e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7eb:	a1 88 0d 00 00       	mov    0xd88,%eax
 7f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f7:	75 23                	jne    81c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7f9:	c7 45 f0 80 0d 00 00 	movl   $0xd80,-0x10(%ebp)
 800:	8b 45 f0             	mov    -0x10(%ebp),%eax
 803:	a3 88 0d 00 00       	mov    %eax,0xd88
 808:	a1 88 0d 00 00       	mov    0xd88,%eax
 80d:	a3 80 0d 00 00       	mov    %eax,0xd80
    base.s.size = 0;
 812:	c7 05 84 0d 00 00 00 	movl   $0x0,0xd84
 819:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81f:	8b 00                	mov    (%eax),%eax
 821:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	8b 40 04             	mov    0x4(%eax),%eax
 82a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 82d:	77 4d                	ja     87c <malloc+0xa6>
      if(p->s.size == nunits)
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	8b 40 04             	mov    0x4(%eax),%eax
 835:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 838:	75 0c                	jne    846 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	8b 10                	mov    (%eax),%edx
 83f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 842:	89 10                	mov    %edx,(%eax)
 844:	eb 26                	jmp    86c <malloc+0x96>
      else {
        p->s.size -= nunits;
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	8b 40 04             	mov    0x4(%eax),%eax
 84c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 84f:	89 c2                	mov    %eax,%edx
 851:	8b 45 f4             	mov    -0xc(%ebp),%eax
 854:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	8b 40 04             	mov    0x4(%eax),%eax
 85d:	c1 e0 03             	shl    $0x3,%eax
 860:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	8b 55 ec             	mov    -0x14(%ebp),%edx
 869:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 86c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86f:	a3 88 0d 00 00       	mov    %eax,0xd88
      return (void*)(p + 1);
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	83 c0 08             	add    $0x8,%eax
 87a:	eb 3b                	jmp    8b7 <malloc+0xe1>
    }
    if(p == freep)
 87c:	a1 88 0d 00 00       	mov    0xd88,%eax
 881:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 884:	75 1e                	jne    8a4 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 886:	83 ec 0c             	sub    $0xc,%esp
 889:	ff 75 ec             	pushl  -0x14(%ebp)
 88c:	e8 e5 fe ff ff       	call   776 <morecore>
 891:	83 c4 10             	add    $0x10,%esp
 894:	89 45 f4             	mov    %eax,-0xc(%ebp)
 897:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 89b:	75 07                	jne    8a4 <malloc+0xce>
        return 0;
 89d:	b8 00 00 00 00       	mov    $0x0,%eax
 8a2:	eb 13                	jmp    8b7 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ad:	8b 00                	mov    (%eax),%eax
 8af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8b2:	e9 6d ff ff ff       	jmp    824 <malloc+0x4e>
  }
}
 8b7:	c9                   	leave  
 8b8:	c3                   	ret    
