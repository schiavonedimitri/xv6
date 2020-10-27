
_grep:     formato del file elf32-i386


Disassemblamento della sezione .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 a3 00 00 00       	jmp    b5 <grep+0xb5>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 00 0e 00 00 	movl   $0xe00,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 44                	jmp    65 <grep+0x65>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	ff 75 f0             	pushl  -0x10(%ebp)
  2d:	ff 75 08             	pushl  0x8(%ebp)
  30:	e8 91 01 00 00       	call   1c6 <match>
  35:	83 c4 10             	add    $0x10,%esp
  38:	85 c0                	test   %eax,%eax
  3a:	74 20                	je     5c <grep+0x5c>
        *q = '\n';
  3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  3f:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  45:	83 c0 01             	add    $0x1,%eax
  48:	2b 45 f0             	sub    -0x10(%ebp),%eax
  4b:	83 ec 04             	sub    $0x4,%esp
  4e:	50                   	push   %eax
  4f:	ff 75 f0             	pushl  -0x10(%ebp)
  52:	6a 01                	push   $0x1
  54:	e8 40 05 00 00       	call   599 <write>
  59:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  5f:	83 c0 01             	add    $0x1,%eax
  62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  65:	83 ec 08             	sub    $0x8,%esp
  68:	6a 0a                	push   $0xa
  6a:	ff 75 f0             	pushl  -0x10(%ebp)
  6d:	e8 86 03 00 00       	call   3f8 <strchr>
  72:	83 c4 10             	add    $0x10,%esp
  75:	89 45 e8             	mov    %eax,-0x18(%ebp)
  78:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  7c:	75 a3                	jne    21 <grep+0x21>
    }
    if(p == buf)
  7e:	81 7d f0 00 0e 00 00 	cmpl   $0xe00,-0x10(%ebp)
  85:	75 07                	jne    8e <grep+0x8e>
      m = 0;
  87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  92:	7e 21                	jle    b5 <grep+0xb5>
      m -= p - buf;
  94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  97:	2d 00 0e 00 00       	sub    $0xe00,%eax
  9c:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	ff 75 f4             	pushl  -0xc(%ebp)
  a5:	ff 75 f0             	pushl  -0x10(%ebp)
  a8:	68 00 0e 00 00       	push   $0xe00
  ad:	e8 82 04 00 00       	call   534 <memmove>
  b2:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  b8:	b8 00 04 00 00       	mov    $0x400,%eax
  bd:	29 d0                	sub    %edx,%eax
  bf:	89 c2                	mov    %eax,%edx
  c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c4:	05 00 0e 00 00       	add    $0xe00,%eax
  c9:	83 ec 04             	sub    $0x4,%esp
  cc:	52                   	push   %edx
  cd:	50                   	push   %eax
  ce:	ff 75 0c             	pushl  0xc(%ebp)
  d1:	e8 bb 04 00 00       	call   591 <read>
  d6:	83 c4 10             	add    $0x10,%esp
  d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  e0:	0f 8f 2c ff ff ff    	jg     12 <grep+0x12>
    }
  }
}
  e6:	90                   	nop
  e7:	90                   	nop
  e8:	c9                   	leave  
  e9:	c3                   	ret    

000000ea <main>:

int
main(int argc, char *argv[])
{
  ea:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  ee:	83 e4 f0             	and    $0xfffffff0,%esp
  f1:	ff 71 fc             	pushl  -0x4(%ecx)
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	53                   	push   %ebx
  f8:	51                   	push   %ecx
  f9:	83 ec 10             	sub    $0x10,%esp
  fc:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
  fe:	83 3b 01             	cmpl   $0x1,(%ebx)
 101:	7f 17                	jg     11a <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 103:	83 ec 08             	sub    $0x8,%esp
 106:	68 cc 0a 00 00       	push   $0xacc
 10b:	6a 02                	push   $0x2
 10d:	e8 03 06 00 00       	call   715 <printf>
 112:	83 c4 10             	add    $0x10,%esp
    exit();
 115:	e8 5f 04 00 00       	call   579 <exit>
  }
  pattern = argv[1];
 11a:	8b 43 04             	mov    0x4(%ebx),%eax
 11d:	8b 40 04             	mov    0x4(%eax),%eax
 120:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
 123:	83 3b 02             	cmpl   $0x2,(%ebx)
 126:	7f 15                	jg     13d <main+0x53>
    grep(pattern, 0);
 128:	83 ec 08             	sub    $0x8,%esp
 12b:	6a 00                	push   $0x0
 12d:	ff 75 f0             	pushl  -0x10(%ebp)
 130:	e8 cb fe ff ff       	call   0 <grep>
 135:	83 c4 10             	add    $0x10,%esp
    exit();
 138:	e8 3c 04 00 00       	call   579 <exit>
  }

  for(i = 2; i < argc; i++){
 13d:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 144:	eb 74                	jmp    1ba <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 146:	8b 45 f4             	mov    -0xc(%ebp),%eax
 149:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 150:	8b 43 04             	mov    0x4(%ebx),%eax
 153:	01 d0                	add    %edx,%eax
 155:	8b 00                	mov    (%eax),%eax
 157:	83 ec 08             	sub    $0x8,%esp
 15a:	6a 00                	push   $0x0
 15c:	50                   	push   %eax
 15d:	e8 57 04 00 00       	call   5b9 <open>
 162:	83 c4 10             	add    $0x10,%esp
 165:	89 45 ec             	mov    %eax,-0x14(%ebp)
 168:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 16c:	79 29                	jns    197 <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 16e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 171:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 178:	8b 43 04             	mov    0x4(%ebx),%eax
 17b:	01 d0                	add    %edx,%eax
 17d:	8b 00                	mov    (%eax),%eax
 17f:	83 ec 04             	sub    $0x4,%esp
 182:	50                   	push   %eax
 183:	68 ec 0a 00 00       	push   $0xaec
 188:	6a 01                	push   $0x1
 18a:	e8 86 05 00 00       	call   715 <printf>
 18f:	83 c4 10             	add    $0x10,%esp
      exit();
 192:	e8 e2 03 00 00       	call   579 <exit>
    }
    grep(pattern, fd);
 197:	83 ec 08             	sub    $0x8,%esp
 19a:	ff 75 ec             	pushl  -0x14(%ebp)
 19d:	ff 75 f0             	pushl  -0x10(%ebp)
 1a0:	e8 5b fe ff ff       	call   0 <grep>
 1a5:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1a8:	83 ec 0c             	sub    $0xc,%esp
 1ab:	ff 75 ec             	pushl  -0x14(%ebp)
 1ae:	e8 ee 03 00 00       	call   5a1 <close>
 1b3:	83 c4 10             	add    $0x10,%esp
  for(i = 2; i < argc; i++){
 1b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1bd:	3b 03                	cmp    (%ebx),%eax
 1bf:	7c 85                	jl     146 <main+0x5c>
  }
  exit();
 1c1:	e8 b3 03 00 00       	call   579 <exit>

000001c6 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1c6:	55                   	push   %ebp
 1c7:	89 e5                	mov    %esp,%ebp
 1c9:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	0f b6 00             	movzbl (%eax),%eax
 1d2:	3c 5e                	cmp    $0x5e,%al
 1d4:	75 17                	jne    1ed <match+0x27>
    return matchhere(re+1, text);
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	83 c0 01             	add    $0x1,%eax
 1dc:	83 ec 08             	sub    $0x8,%esp
 1df:	ff 75 0c             	pushl  0xc(%ebp)
 1e2:	50                   	push   %eax
 1e3:	e8 38 00 00 00       	call   220 <matchhere>
 1e8:	83 c4 10             	add    $0x10,%esp
 1eb:	eb 31                	jmp    21e <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 1ed:	83 ec 08             	sub    $0x8,%esp
 1f0:	ff 75 0c             	pushl  0xc(%ebp)
 1f3:	ff 75 08             	pushl  0x8(%ebp)
 1f6:	e8 25 00 00 00       	call   220 <matchhere>
 1fb:	83 c4 10             	add    $0x10,%esp
 1fe:	85 c0                	test   %eax,%eax
 200:	74 07                	je     209 <match+0x43>
      return 1;
 202:	b8 01 00 00 00       	mov    $0x1,%eax
 207:	eb 15                	jmp    21e <match+0x58>
  }while(*text++ != '\0');
 209:	8b 45 0c             	mov    0xc(%ebp),%eax
 20c:	8d 50 01             	lea    0x1(%eax),%edx
 20f:	89 55 0c             	mov    %edx,0xc(%ebp)
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	84 c0                	test   %al,%al
 217:	75 d4                	jne    1ed <match+0x27>
  return 0;
 219:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21e:	c9                   	leave  
 21f:	c3                   	ret    

00000220 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 226:	8b 45 08             	mov    0x8(%ebp),%eax
 229:	0f b6 00             	movzbl (%eax),%eax
 22c:	84 c0                	test   %al,%al
 22e:	75 0a                	jne    23a <matchhere+0x1a>
    return 1;
 230:	b8 01 00 00 00       	mov    $0x1,%eax
 235:	e9 99 00 00 00       	jmp    2d3 <matchhere+0xb3>
  if(re[1] == '*')
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	83 c0 01             	add    $0x1,%eax
 240:	0f b6 00             	movzbl (%eax),%eax
 243:	3c 2a                	cmp    $0x2a,%al
 245:	75 21                	jne    268 <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 50 02             	lea    0x2(%eax),%edx
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	0f be c0             	movsbl %al,%eax
 256:	83 ec 04             	sub    $0x4,%esp
 259:	ff 75 0c             	pushl  0xc(%ebp)
 25c:	52                   	push   %edx
 25d:	50                   	push   %eax
 25e:	e8 72 00 00 00       	call   2d5 <matchstar>
 263:	83 c4 10             	add    $0x10,%esp
 266:	eb 6b                	jmp    2d3 <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 24                	cmp    $0x24,%al
 270:	75 1d                	jne    28f <matchhere+0x6f>
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	83 c0 01             	add    $0x1,%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	84 c0                	test   %al,%al
 27d:	75 10                	jne    28f <matchhere+0x6f>
    return *text == '\0';
 27f:	8b 45 0c             	mov    0xc(%ebp),%eax
 282:	0f b6 00             	movzbl (%eax),%eax
 285:	84 c0                	test   %al,%al
 287:	0f 94 c0             	sete   %al
 28a:	0f b6 c0             	movzbl %al,%eax
 28d:	eb 44                	jmp    2d3 <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 28f:	8b 45 0c             	mov    0xc(%ebp),%eax
 292:	0f b6 00             	movzbl (%eax),%eax
 295:	84 c0                	test   %al,%al
 297:	74 35                	je     2ce <matchhere+0xae>
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	0f b6 00             	movzbl (%eax),%eax
 29f:	3c 2e                	cmp    $0x2e,%al
 2a1:	74 10                	je     2b3 <matchhere+0x93>
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	0f b6 10             	movzbl (%eax),%edx
 2a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ac:	0f b6 00             	movzbl (%eax),%eax
 2af:	38 c2                	cmp    %al,%dl
 2b1:	75 1b                	jne    2ce <matchhere+0xae>
    return matchhere(re+1, text+1);
 2b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b6:	8d 50 01             	lea    0x1(%eax),%edx
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	83 c0 01             	add    $0x1,%eax
 2bf:	83 ec 08             	sub    $0x8,%esp
 2c2:	52                   	push   %edx
 2c3:	50                   	push   %eax
 2c4:	e8 57 ff ff ff       	call   220 <matchhere>
 2c9:	83 c4 10             	add    $0x10,%esp
 2cc:	eb 05                	jmp    2d3 <matchhere+0xb3>
  return 0;
 2ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2d5:	55                   	push   %ebp
 2d6:	89 e5                	mov    %esp,%ebp
 2d8:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2db:	83 ec 08             	sub    $0x8,%esp
 2de:	ff 75 10             	pushl  0x10(%ebp)
 2e1:	ff 75 0c             	pushl  0xc(%ebp)
 2e4:	e8 37 ff ff ff       	call   220 <matchhere>
 2e9:	83 c4 10             	add    $0x10,%esp
 2ec:	85 c0                	test   %eax,%eax
 2ee:	74 07                	je     2f7 <matchstar+0x22>
      return 1;
 2f0:	b8 01 00 00 00       	mov    $0x1,%eax
 2f5:	eb 29                	jmp    320 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 2f7:	8b 45 10             	mov    0x10(%ebp),%eax
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	84 c0                	test   %al,%al
 2ff:	74 1a                	je     31b <matchstar+0x46>
 301:	8b 45 10             	mov    0x10(%ebp),%eax
 304:	8d 50 01             	lea    0x1(%eax),%edx
 307:	89 55 10             	mov    %edx,0x10(%ebp)
 30a:	0f b6 00             	movzbl (%eax),%eax
 30d:	0f be c0             	movsbl %al,%eax
 310:	39 45 08             	cmp    %eax,0x8(%ebp)
 313:	74 c6                	je     2db <matchstar+0x6>
 315:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 319:	74 c0                	je     2db <matchstar+0x6>
  return 0;
 31b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	57                   	push   %edi
 326:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 327:	8b 4d 08             	mov    0x8(%ebp),%ecx
 32a:	8b 55 10             	mov    0x10(%ebp),%edx
 32d:	8b 45 0c             	mov    0xc(%ebp),%eax
 330:	89 cb                	mov    %ecx,%ebx
 332:	89 df                	mov    %ebx,%edi
 334:	89 d1                	mov    %edx,%ecx
 336:	fc                   	cld    
 337:	f3 aa                	rep stos %al,%es:(%edi)
 339:	89 ca                	mov    %ecx,%edx
 33b:	89 fb                	mov    %edi,%ebx
 33d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 340:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 343:	90                   	nop
 344:	5b                   	pop    %ebx
 345:	5f                   	pop    %edi
 346:	5d                   	pop    %ebp
 347:	c3                   	ret    

00000348 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 354:	90                   	nop
 355:	8b 55 0c             	mov    0xc(%ebp),%edx
 358:	8d 42 01             	lea    0x1(%edx),%eax
 35b:	89 45 0c             	mov    %eax,0xc(%ebp)
 35e:	8b 45 08             	mov    0x8(%ebp),%eax
 361:	8d 48 01             	lea    0x1(%eax),%ecx
 364:	89 4d 08             	mov    %ecx,0x8(%ebp)
 367:	0f b6 12             	movzbl (%edx),%edx
 36a:	88 10                	mov    %dl,(%eax)
 36c:	0f b6 00             	movzbl (%eax),%eax
 36f:	84 c0                	test   %al,%al
 371:	75 e2                	jne    355 <strcpy+0xd>
    ;
  return os;
 373:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 376:	c9                   	leave  
 377:	c3                   	ret    

00000378 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 37b:	eb 08                	jmp    385 <strcmp+0xd>
    p++, q++;
 37d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 381:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 385:	8b 45 08             	mov    0x8(%ebp),%eax
 388:	0f b6 00             	movzbl (%eax),%eax
 38b:	84 c0                	test   %al,%al
 38d:	74 10                	je     39f <strcmp+0x27>
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	0f b6 10             	movzbl (%eax),%edx
 395:	8b 45 0c             	mov    0xc(%ebp),%eax
 398:	0f b6 00             	movzbl (%eax),%eax
 39b:	38 c2                	cmp    %al,%dl
 39d:	74 de                	je     37d <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	0f b6 00             	movzbl (%eax),%eax
 3a5:	0f b6 d0             	movzbl %al,%edx
 3a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ab:	0f b6 00             	movzbl (%eax),%eax
 3ae:	0f b6 c8             	movzbl %al,%ecx
 3b1:	89 d0                	mov    %edx,%eax
 3b3:	29 c8                	sub    %ecx,%eax
}
 3b5:	5d                   	pop    %ebp
 3b6:	c3                   	ret    

000003b7 <strlen>:

uint
strlen(char *s)
{
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3c4:	eb 04                	jmp    3ca <strlen+0x13>
 3c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
 3d0:	01 d0                	add    %edx,%eax
 3d2:	0f b6 00             	movzbl (%eax),%eax
 3d5:	84 c0                	test   %al,%al
 3d7:	75 ed                	jne    3c6 <strlen+0xf>
    ;
  return n;
 3d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3dc:	c9                   	leave  
 3dd:	c3                   	ret    

000003de <memset>:

void*
memset(void *dst, int c, uint n)
{
 3de:	55                   	push   %ebp
 3df:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3e1:	8b 45 10             	mov    0x10(%ebp),%eax
 3e4:	50                   	push   %eax
 3e5:	ff 75 0c             	pushl  0xc(%ebp)
 3e8:	ff 75 08             	pushl  0x8(%ebp)
 3eb:	e8 32 ff ff ff       	call   322 <stosb>
 3f0:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f6:	c9                   	leave  
 3f7:	c3                   	ret    

000003f8 <strchr>:

char*
strchr(const char *s, char c)
{
 3f8:	55                   	push   %ebp
 3f9:	89 e5                	mov    %esp,%ebp
 3fb:	83 ec 04             	sub    $0x4,%esp
 3fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 401:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 404:	eb 14                	jmp    41a <strchr+0x22>
    if(*s == c)
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	0f b6 00             	movzbl (%eax),%eax
 40c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 40f:	75 05                	jne    416 <strchr+0x1e>
      return (char*)s;
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	eb 13                	jmp    429 <strchr+0x31>
  for(; *s; s++)
 416:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	84 c0                	test   %al,%al
 422:	75 e2                	jne    406 <strchr+0xe>
  return 0;
 424:	b8 00 00 00 00       	mov    $0x0,%eax
}
 429:	c9                   	leave  
 42a:	c3                   	ret    

0000042b <gets>:

char*
gets(char *buf, int max)
{
 42b:	55                   	push   %ebp
 42c:	89 e5                	mov    %esp,%ebp
 42e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 431:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 438:	eb 42                	jmp    47c <gets+0x51>
    cc = read(0, &c, 1);
 43a:	83 ec 04             	sub    $0x4,%esp
 43d:	6a 01                	push   $0x1
 43f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 442:	50                   	push   %eax
 443:	6a 00                	push   $0x0
 445:	e8 47 01 00 00       	call   591 <read>
 44a:	83 c4 10             	add    $0x10,%esp
 44d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 450:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 454:	7e 33                	jle    489 <gets+0x5e>
      break;
    buf[i++] = c;
 456:	8b 45 f4             	mov    -0xc(%ebp),%eax
 459:	8d 50 01             	lea    0x1(%eax),%edx
 45c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45f:	89 c2                	mov    %eax,%edx
 461:	8b 45 08             	mov    0x8(%ebp),%eax
 464:	01 c2                	add    %eax,%edx
 466:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 46a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 46c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 470:	3c 0a                	cmp    $0xa,%al
 472:	74 16                	je     48a <gets+0x5f>
 474:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 478:	3c 0d                	cmp    $0xd,%al
 47a:	74 0e                	je     48a <gets+0x5f>
  for(i=0; i+1 < max; ){
 47c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47f:	83 c0 01             	add    $0x1,%eax
 482:	39 45 0c             	cmp    %eax,0xc(%ebp)
 485:	7f b3                	jg     43a <gets+0xf>
 487:	eb 01                	jmp    48a <gets+0x5f>
      break;
 489:	90                   	nop
      break;
  }
  buf[i] = '\0';
 48a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	01 d0                	add    %edx,%eax
 492:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 495:	8b 45 08             	mov    0x8(%ebp),%eax
}
 498:	c9                   	leave  
 499:	c3                   	ret    

0000049a <stat>:

int
stat(char *n, struct stat *st)
{
 49a:	55                   	push   %ebp
 49b:	89 e5                	mov    %esp,%ebp
 49d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a0:	83 ec 08             	sub    $0x8,%esp
 4a3:	6a 00                	push   $0x0
 4a5:	ff 75 08             	pushl  0x8(%ebp)
 4a8:	e8 0c 01 00 00       	call   5b9 <open>
 4ad:	83 c4 10             	add    $0x10,%esp
 4b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b7:	79 07                	jns    4c0 <stat+0x26>
    return -1;
 4b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4be:	eb 25                	jmp    4e5 <stat+0x4b>
  r = fstat(fd, st);
 4c0:	83 ec 08             	sub    $0x8,%esp
 4c3:	ff 75 0c             	pushl  0xc(%ebp)
 4c6:	ff 75 f4             	pushl  -0xc(%ebp)
 4c9:	e8 03 01 00 00       	call   5d1 <fstat>
 4ce:	83 c4 10             	add    $0x10,%esp
 4d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4d4:	83 ec 0c             	sub    $0xc,%esp
 4d7:	ff 75 f4             	pushl  -0xc(%ebp)
 4da:	e8 c2 00 00 00       	call   5a1 <close>
 4df:	83 c4 10             	add    $0x10,%esp
  return r;
 4e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4e5:	c9                   	leave  
 4e6:	c3                   	ret    

000004e7 <atoi>:

int
atoi(const char *s)
{
 4e7:	55                   	push   %ebp
 4e8:	89 e5                	mov    %esp,%ebp
 4ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4f4:	eb 25                	jmp    51b <atoi+0x34>
    n = n*10 + *s++ - '0';
 4f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4f9:	89 d0                	mov    %edx,%eax
 4fb:	c1 e0 02             	shl    $0x2,%eax
 4fe:	01 d0                	add    %edx,%eax
 500:	01 c0                	add    %eax,%eax
 502:	89 c1                	mov    %eax,%ecx
 504:	8b 45 08             	mov    0x8(%ebp),%eax
 507:	8d 50 01             	lea    0x1(%eax),%edx
 50a:	89 55 08             	mov    %edx,0x8(%ebp)
 50d:	0f b6 00             	movzbl (%eax),%eax
 510:	0f be c0             	movsbl %al,%eax
 513:	01 c8                	add    %ecx,%eax
 515:	83 e8 30             	sub    $0x30,%eax
 518:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	0f b6 00             	movzbl (%eax),%eax
 521:	3c 2f                	cmp    $0x2f,%al
 523:	7e 0a                	jle    52f <atoi+0x48>
 525:	8b 45 08             	mov    0x8(%ebp),%eax
 528:	0f b6 00             	movzbl (%eax),%eax
 52b:	3c 39                	cmp    $0x39,%al
 52d:	7e c7                	jle    4f6 <atoi+0xf>
  return n;
 52f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 532:	c9                   	leave  
 533:	c3                   	ret    

00000534 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 540:	8b 45 0c             	mov    0xc(%ebp),%eax
 543:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 546:	eb 17                	jmp    55f <memmove+0x2b>
    *dst++ = *src++;
 548:	8b 55 f8             	mov    -0x8(%ebp),%edx
 54b:	8d 42 01             	lea    0x1(%edx),%eax
 54e:	89 45 f8             	mov    %eax,-0x8(%ebp)
 551:	8b 45 fc             	mov    -0x4(%ebp),%eax
 554:	8d 48 01             	lea    0x1(%eax),%ecx
 557:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 55a:	0f b6 12             	movzbl (%edx),%edx
 55d:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 55f:	8b 45 10             	mov    0x10(%ebp),%eax
 562:	8d 50 ff             	lea    -0x1(%eax),%edx
 565:	89 55 10             	mov    %edx,0x10(%ebp)
 568:	85 c0                	test   %eax,%eax
 56a:	7f dc                	jg     548 <memmove+0x14>
  return vdst;
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 56f:	c9                   	leave  
 570:	c3                   	ret    

00000571 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 571:	b8 01 00 00 00       	mov    $0x1,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <exit>:
SYSCALL(exit)
 579:	b8 02 00 00 00       	mov    $0x2,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <wait>:
SYSCALL(wait)
 581:	b8 03 00 00 00       	mov    $0x3,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <pipe>:
SYSCALL(pipe)
 589:	b8 04 00 00 00       	mov    $0x4,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <read>:
SYSCALL(read)
 591:	b8 05 00 00 00       	mov    $0x5,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <write>:
SYSCALL(write)
 599:	b8 15 00 00 00       	mov    $0x15,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <close>:
SYSCALL(close)
 5a1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <kill>:
SYSCALL(kill)
 5a9:	b8 06 00 00 00       	mov    $0x6,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <exec>:
SYSCALL(exec)
 5b1:	b8 07 00 00 00       	mov    $0x7,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <open>:
SYSCALL(open)
 5b9:	b8 14 00 00 00       	mov    $0x14,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <mknod>:
SYSCALL(mknod)
 5c1:	b8 16 00 00 00       	mov    $0x16,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <unlink>:
SYSCALL(unlink)
 5c9:	b8 17 00 00 00       	mov    $0x17,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <fstat>:
SYSCALL(fstat)
 5d1:	b8 08 00 00 00       	mov    $0x8,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <link>:
SYSCALL(link)
 5d9:	b8 18 00 00 00       	mov    $0x18,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <mkdir>:
SYSCALL(mkdir)
 5e1:	b8 19 00 00 00       	mov    $0x19,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <chdir>:
SYSCALL(chdir)
 5e9:	b8 09 00 00 00       	mov    $0x9,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <dup>:
SYSCALL(dup)
 5f1:	b8 0a 00 00 00       	mov    $0xa,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <getpid>:
SYSCALL(getpid)
 5f9:	b8 0b 00 00 00       	mov    $0xb,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <sbrk>:
SYSCALL(sbrk)
 601:	b8 0c 00 00 00       	mov    $0xc,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <sleep>:
SYSCALL(sleep)
 609:	b8 0d 00 00 00       	mov    $0xd,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <uptime>:
SYSCALL(uptime)
 611:	b8 0e 00 00 00       	mov    $0xe,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <sem_alloc>:
SYSCALL(sem_alloc)
 619:	b8 0f 00 00 00       	mov    $0xf,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <sem_destroy>:
SYSCALL(sem_destroy)
 621:	b8 10 00 00 00       	mov    $0x10,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <sem_init>:
SYSCALL(sem_init)
 629:	b8 11 00 00 00       	mov    $0x11,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <sem_post>:
SYSCALL(sem_post)
 631:	b8 12 00 00 00       	mov    $0x12,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <sem_wait>:
SYSCALL(sem_wait)
 639:	b8 13 00 00 00       	mov    $0x13,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 641:	55                   	push   %ebp
 642:	89 e5                	mov    %esp,%ebp
 644:	83 ec 18             	sub    $0x18,%esp
 647:	8b 45 0c             	mov    0xc(%ebp),%eax
 64a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 64d:	83 ec 04             	sub    $0x4,%esp
 650:	6a 01                	push   $0x1
 652:	8d 45 f4             	lea    -0xc(%ebp),%eax
 655:	50                   	push   %eax
 656:	ff 75 08             	pushl  0x8(%ebp)
 659:	e8 3b ff ff ff       	call   599 <write>
 65e:	83 c4 10             	add    $0x10,%esp
}
 661:	90                   	nop
 662:	c9                   	leave  
 663:	c3                   	ret    

00000664 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 664:	55                   	push   %ebp
 665:	89 e5                	mov    %esp,%ebp
 667:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 66a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 671:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 675:	74 17                	je     68e <printint+0x2a>
 677:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 67b:	79 11                	jns    68e <printint+0x2a>
    neg = 1;
 67d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 684:	8b 45 0c             	mov    0xc(%ebp),%eax
 687:	f7 d8                	neg    %eax
 689:	89 45 ec             	mov    %eax,-0x14(%ebp)
 68c:	eb 06                	jmp    694 <printint+0x30>
  } else {
    x = xx;
 68e:	8b 45 0c             	mov    0xc(%ebp),%eax
 691:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 694:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 69b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 69e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a1:	ba 00 00 00 00       	mov    $0x0,%edx
 6a6:	f7 f1                	div    %ecx
 6a8:	89 d1                	mov    %edx,%ecx
 6aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ad:	8d 50 01             	lea    0x1(%eax),%edx
 6b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6b3:	0f b6 91 d4 0d 00 00 	movzbl 0xdd4(%ecx),%edx
 6ba:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 6be:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6c4:	ba 00 00 00 00       	mov    $0x0,%edx
 6c9:	f7 f1                	div    %ecx
 6cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6d2:	75 c7                	jne    69b <printint+0x37>
  if(neg)
 6d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6d8:	74 2d                	je     707 <printint+0xa3>
    buf[i++] = '-';
 6da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6dd:	8d 50 01             	lea    0x1(%eax),%edx
 6e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6e3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6e8:	eb 1d                	jmp    707 <printint+0xa3>
    putc(fd, buf[i]);
 6ea:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f0:	01 d0                	add    %edx,%eax
 6f2:	0f b6 00             	movzbl (%eax),%eax
 6f5:	0f be c0             	movsbl %al,%eax
 6f8:	83 ec 08             	sub    $0x8,%esp
 6fb:	50                   	push   %eax
 6fc:	ff 75 08             	pushl  0x8(%ebp)
 6ff:	e8 3d ff ff ff       	call   641 <putc>
 704:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 707:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 70b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 70f:	79 d9                	jns    6ea <printint+0x86>
}
 711:	90                   	nop
 712:	90                   	nop
 713:	c9                   	leave  
 714:	c3                   	ret    

00000715 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 715:	55                   	push   %ebp
 716:	89 e5                	mov    %esp,%ebp
 718:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 71b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 722:	8d 45 0c             	lea    0xc(%ebp),%eax
 725:	83 c0 04             	add    $0x4,%eax
 728:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 72b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 732:	e9 59 01 00 00       	jmp    890 <printf+0x17b>
    c = fmt[i] & 0xff;
 737:	8b 55 0c             	mov    0xc(%ebp),%edx
 73a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73d:	01 d0                	add    %edx,%eax
 73f:	0f b6 00             	movzbl (%eax),%eax
 742:	0f be c0             	movsbl %al,%eax
 745:	25 ff 00 00 00       	and    $0xff,%eax
 74a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 74d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 751:	75 2c                	jne    77f <printf+0x6a>
      if(c == '%'){
 753:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 757:	75 0c                	jne    765 <printf+0x50>
        state = '%';
 759:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 760:	e9 27 01 00 00       	jmp    88c <printf+0x177>
      } else {
        putc(fd, c);
 765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 768:	0f be c0             	movsbl %al,%eax
 76b:	83 ec 08             	sub    $0x8,%esp
 76e:	50                   	push   %eax
 76f:	ff 75 08             	pushl  0x8(%ebp)
 772:	e8 ca fe ff ff       	call   641 <putc>
 777:	83 c4 10             	add    $0x10,%esp
 77a:	e9 0d 01 00 00       	jmp    88c <printf+0x177>
      }
    } else if(state == '%'){
 77f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 783:	0f 85 03 01 00 00    	jne    88c <printf+0x177>
      if(c == 'd'){
 789:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 78d:	75 1e                	jne    7ad <printf+0x98>
        printint(fd, *ap, 10, 1);
 78f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 792:	8b 00                	mov    (%eax),%eax
 794:	6a 01                	push   $0x1
 796:	6a 0a                	push   $0xa
 798:	50                   	push   %eax
 799:	ff 75 08             	pushl  0x8(%ebp)
 79c:	e8 c3 fe ff ff       	call   664 <printint>
 7a1:	83 c4 10             	add    $0x10,%esp
        ap++;
 7a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a8:	e9 d8 00 00 00       	jmp    885 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7ad:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7b1:	74 06                	je     7b9 <printf+0xa4>
 7b3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7b7:	75 1e                	jne    7d7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7bc:	8b 00                	mov    (%eax),%eax
 7be:	6a 00                	push   $0x0
 7c0:	6a 10                	push   $0x10
 7c2:	50                   	push   %eax
 7c3:	ff 75 08             	pushl  0x8(%ebp)
 7c6:	e8 99 fe ff ff       	call   664 <printint>
 7cb:	83 c4 10             	add    $0x10,%esp
        ap++;
 7ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d2:	e9 ae 00 00 00       	jmp    885 <printf+0x170>
      } else if(c == 's'){
 7d7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7db:	75 43                	jne    820 <printf+0x10b>
        s = (char*)*ap;
 7dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e0:	8b 00                	mov    (%eax),%eax
 7e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ed:	75 25                	jne    814 <printf+0xff>
          s = "(null)";
 7ef:	c7 45 f4 02 0b 00 00 	movl   $0xb02,-0xc(%ebp)
        while(*s != 0){
 7f6:	eb 1c                	jmp    814 <printf+0xff>
          putc(fd, *s);
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	0f b6 00             	movzbl (%eax),%eax
 7fe:	0f be c0             	movsbl %al,%eax
 801:	83 ec 08             	sub    $0x8,%esp
 804:	50                   	push   %eax
 805:	ff 75 08             	pushl  0x8(%ebp)
 808:	e8 34 fe ff ff       	call   641 <putc>
 80d:	83 c4 10             	add    $0x10,%esp
          s++;
 810:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	0f b6 00             	movzbl (%eax),%eax
 81a:	84 c0                	test   %al,%al
 81c:	75 da                	jne    7f8 <printf+0xe3>
 81e:	eb 65                	jmp    885 <printf+0x170>
        }
      } else if(c == 'c'){
 820:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 824:	75 1d                	jne    843 <printf+0x12e>
        putc(fd, *ap);
 826:	8b 45 e8             	mov    -0x18(%ebp),%eax
 829:	8b 00                	mov    (%eax),%eax
 82b:	0f be c0             	movsbl %al,%eax
 82e:	83 ec 08             	sub    $0x8,%esp
 831:	50                   	push   %eax
 832:	ff 75 08             	pushl  0x8(%ebp)
 835:	e8 07 fe ff ff       	call   641 <putc>
 83a:	83 c4 10             	add    $0x10,%esp
        ap++;
 83d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 841:	eb 42                	jmp    885 <printf+0x170>
      } else if(c == '%'){
 843:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 847:	75 17                	jne    860 <printf+0x14b>
        putc(fd, c);
 849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 84c:	0f be c0             	movsbl %al,%eax
 84f:	83 ec 08             	sub    $0x8,%esp
 852:	50                   	push   %eax
 853:	ff 75 08             	pushl  0x8(%ebp)
 856:	e8 e6 fd ff ff       	call   641 <putc>
 85b:	83 c4 10             	add    $0x10,%esp
 85e:	eb 25                	jmp    885 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 860:	83 ec 08             	sub    $0x8,%esp
 863:	6a 25                	push   $0x25
 865:	ff 75 08             	pushl  0x8(%ebp)
 868:	e8 d4 fd ff ff       	call   641 <putc>
 86d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 873:	0f be c0             	movsbl %al,%eax
 876:	83 ec 08             	sub    $0x8,%esp
 879:	50                   	push   %eax
 87a:	ff 75 08             	pushl  0x8(%ebp)
 87d:	e8 bf fd ff ff       	call   641 <putc>
 882:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 885:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 88c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 890:	8b 55 0c             	mov    0xc(%ebp),%edx
 893:	8b 45 f0             	mov    -0x10(%ebp),%eax
 896:	01 d0                	add    %edx,%eax
 898:	0f b6 00             	movzbl (%eax),%eax
 89b:	84 c0                	test   %al,%al
 89d:	0f 85 94 fe ff ff    	jne    737 <printf+0x22>
    }
  }
}
 8a3:	90                   	nop
 8a4:	90                   	nop
 8a5:	c9                   	leave  
 8a6:	c3                   	ret    

000008a7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a7:	55                   	push   %ebp
 8a8:	89 e5                	mov    %esp,%ebp
 8aa:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ad:	8b 45 08             	mov    0x8(%ebp),%eax
 8b0:	83 e8 08             	sub    $0x8,%eax
 8b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b6:	a1 08 12 00 00       	mov    0x1208,%eax
 8bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8be:	eb 24                	jmp    8e4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c3:	8b 00                	mov    (%eax),%eax
 8c5:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8c8:	72 12                	jb     8dc <free+0x35>
 8ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d0:	77 24                	ja     8f6 <free+0x4f>
 8d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d5:	8b 00                	mov    (%eax),%eax
 8d7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8da:	72 1a                	jb     8f6 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8df:	8b 00                	mov    (%eax),%eax
 8e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ea:	76 d4                	jbe    8c0 <free+0x19>
 8ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ef:	8b 00                	mov    (%eax),%eax
 8f1:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8f4:	73 ca                	jae    8c0 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f9:	8b 40 04             	mov    0x4(%eax),%eax
 8fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 903:	8b 45 f8             	mov    -0x8(%ebp),%eax
 906:	01 c2                	add    %eax,%edx
 908:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90b:	8b 00                	mov    (%eax),%eax
 90d:	39 c2                	cmp    %eax,%edx
 90f:	75 24                	jne    935 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 911:	8b 45 f8             	mov    -0x8(%ebp),%eax
 914:	8b 50 04             	mov    0x4(%eax),%edx
 917:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91a:	8b 00                	mov    (%eax),%eax
 91c:	8b 40 04             	mov    0x4(%eax),%eax
 91f:	01 c2                	add    %eax,%edx
 921:	8b 45 f8             	mov    -0x8(%ebp),%eax
 924:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 927:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92a:	8b 00                	mov    (%eax),%eax
 92c:	8b 10                	mov    (%eax),%edx
 92e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 931:	89 10                	mov    %edx,(%eax)
 933:	eb 0a                	jmp    93f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 935:	8b 45 fc             	mov    -0x4(%ebp),%eax
 938:	8b 10                	mov    (%eax),%edx
 93a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 93f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 942:	8b 40 04             	mov    0x4(%eax),%eax
 945:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 94c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94f:	01 d0                	add    %edx,%eax
 951:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 954:	75 20                	jne    976 <free+0xcf>
    p->s.size += bp->s.size;
 956:	8b 45 fc             	mov    -0x4(%ebp),%eax
 959:	8b 50 04             	mov    0x4(%eax),%edx
 95c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95f:	8b 40 04             	mov    0x4(%eax),%eax
 962:	01 c2                	add    %eax,%edx
 964:	8b 45 fc             	mov    -0x4(%ebp),%eax
 967:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 96a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96d:	8b 10                	mov    (%eax),%edx
 96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 972:	89 10                	mov    %edx,(%eax)
 974:	eb 08                	jmp    97e <free+0xd7>
  } else
    p->s.ptr = bp;
 976:	8b 45 fc             	mov    -0x4(%ebp),%eax
 979:	8b 55 f8             	mov    -0x8(%ebp),%edx
 97c:	89 10                	mov    %edx,(%eax)
  freep = p;
 97e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 981:	a3 08 12 00 00       	mov    %eax,0x1208
}
 986:	90                   	nop
 987:	c9                   	leave  
 988:	c3                   	ret    

00000989 <morecore>:

static Header*
morecore(uint nu)
{
 989:	55                   	push   %ebp
 98a:	89 e5                	mov    %esp,%ebp
 98c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 98f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 996:	77 07                	ja     99f <morecore+0x16>
    nu = 4096;
 998:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 99f:	8b 45 08             	mov    0x8(%ebp),%eax
 9a2:	c1 e0 03             	shl    $0x3,%eax
 9a5:	83 ec 0c             	sub    $0xc,%esp
 9a8:	50                   	push   %eax
 9a9:	e8 53 fc ff ff       	call   601 <sbrk>
 9ae:	83 c4 10             	add    $0x10,%esp
 9b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9b4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9b8:	75 07                	jne    9c1 <morecore+0x38>
    return 0;
 9ba:	b8 00 00 00 00       	mov    $0x0,%eax
 9bf:	eb 26                	jmp    9e7 <morecore+0x5e>
  hp = (Header*)p;
 9c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ca:	8b 55 08             	mov    0x8(%ebp),%edx
 9cd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d3:	83 c0 08             	add    $0x8,%eax
 9d6:	83 ec 0c             	sub    $0xc,%esp
 9d9:	50                   	push   %eax
 9da:	e8 c8 fe ff ff       	call   8a7 <free>
 9df:	83 c4 10             	add    $0x10,%esp
  return freep;
 9e2:	a1 08 12 00 00       	mov    0x1208,%eax
}
 9e7:	c9                   	leave  
 9e8:	c3                   	ret    

000009e9 <malloc>:

void*
malloc(uint nbytes)
{
 9e9:	55                   	push   %ebp
 9ea:	89 e5                	mov    %esp,%ebp
 9ec:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ef:	8b 45 08             	mov    0x8(%ebp),%eax
 9f2:	83 c0 07             	add    $0x7,%eax
 9f5:	c1 e8 03             	shr    $0x3,%eax
 9f8:	83 c0 01             	add    $0x1,%eax
 9fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9fe:	a1 08 12 00 00       	mov    0x1208,%eax
 a03:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a0a:	75 23                	jne    a2f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a0c:	c7 45 f0 00 12 00 00 	movl   $0x1200,-0x10(%ebp)
 a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a16:	a3 08 12 00 00       	mov    %eax,0x1208
 a1b:	a1 08 12 00 00       	mov    0x1208,%eax
 a20:	a3 00 12 00 00       	mov    %eax,0x1200
    base.s.size = 0;
 a25:	c7 05 04 12 00 00 00 	movl   $0x0,0x1204
 a2c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a32:	8b 00                	mov    (%eax),%eax
 a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3a:	8b 40 04             	mov    0x4(%eax),%eax
 a3d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a40:	77 4d                	ja     a8f <malloc+0xa6>
      if(p->s.size == nunits)
 a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a45:	8b 40 04             	mov    0x4(%eax),%eax
 a48:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a4b:	75 0c                	jne    a59 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a50:	8b 10                	mov    (%eax),%edx
 a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a55:	89 10                	mov    %edx,(%eax)
 a57:	eb 26                	jmp    a7f <malloc+0x96>
      else {
        p->s.size -= nunits;
 a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5c:	8b 40 04             	mov    0x4(%eax),%eax
 a5f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a62:	89 c2                	mov    %eax,%edx
 a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a67:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6d:	8b 40 04             	mov    0x4(%eax),%eax
 a70:	c1 e0 03             	shl    $0x3,%eax
 a73:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a79:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a7c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a82:	a3 08 12 00 00       	mov    %eax,0x1208
      return (void*)(p + 1);
 a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8a:	83 c0 08             	add    $0x8,%eax
 a8d:	eb 3b                	jmp    aca <malloc+0xe1>
    }
    if(p == freep)
 a8f:	a1 08 12 00 00       	mov    0x1208,%eax
 a94:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a97:	75 1e                	jne    ab7 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a99:	83 ec 0c             	sub    $0xc,%esp
 a9c:	ff 75 ec             	pushl  -0x14(%ebp)
 a9f:	e8 e5 fe ff ff       	call   989 <morecore>
 aa4:	83 c4 10             	add    $0x10,%esp
 aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aae:	75 07                	jne    ab7 <malloc+0xce>
        return 0;
 ab0:	b8 00 00 00 00       	mov    $0x0,%eax
 ab5:	eb 13                	jmp    aca <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	89 45 f0             	mov    %eax,-0x10(%ebp)
 abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac0:	8b 00                	mov    (%eax),%eax
 ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ac5:	e9 6d ff ff ff       	jmp    a37 <malloc+0x4e>
  }
}
 aca:	c9                   	leave  
 acb:	c3                   	ret    
