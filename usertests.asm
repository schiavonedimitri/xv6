
_usertests:     formato del file elf32-i386


Disassemblamento della sezione .text:

00000000 <opentest>:

// simple file system tests

void
opentest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
       6:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 7e 41 00 00       	push   $0x417e
      13:	50                   	push   %eax
      14:	e8 98 3d 00 00       	call   3db1 <printf>
      19:	83 c4 10             	add    $0x10,%esp
  fd = open("echo", 0);
      1c:	83 ec 08             	sub    $0x8,%esp
      1f:	6a 00                	push   $0x0
      21:	68 68 41 00 00       	push   $0x4168
      26:	e8 2a 3c 00 00       	call   3c55 <open>
      2b:	83 c4 10             	add    $0x10,%esp
      2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
      31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      35:	79 1b                	jns    52 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
      37:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
      3c:	83 ec 08             	sub    $0x8,%esp
      3f:	68 89 41 00 00       	push   $0x4189
      44:	50                   	push   %eax
      45:	e8 67 3d 00 00       	call   3db1 <printf>
      4a:	83 c4 10             	add    $0x10,%esp
    exit();
      4d:	e8 c3 3b 00 00       	call   3c15 <exit>
  }
  close(fd);
      52:	83 ec 0c             	sub    $0xc,%esp
      55:	ff 75 f4             	pushl  -0xc(%ebp)
      58:	e8 e0 3b 00 00       	call   3c3d <close>
      5d:	83 c4 10             	add    $0x10,%esp
  fd = open("doesnotexist", 0);
      60:	83 ec 08             	sub    $0x8,%esp
      63:	6a 00                	push   $0x0
      65:	68 9c 41 00 00       	push   $0x419c
      6a:	e8 e6 3b 00 00       	call   3c55 <open>
      6f:	83 c4 10             	add    $0x10,%esp
      72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
      75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      79:	78 1b                	js     96 <opentest+0x96>
    printf(stdout, "open doesnotexist succeeded!\n");
      7b:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
      80:	83 ec 08             	sub    $0x8,%esp
      83:	68 a9 41 00 00       	push   $0x41a9
      88:	50                   	push   %eax
      89:	e8 23 3d 00 00       	call   3db1 <printf>
      8e:	83 c4 10             	add    $0x10,%esp
    exit();
      91:	e8 7f 3b 00 00       	call   3c15 <exit>
  }
  printf(stdout, "open test ok\n");
      96:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
      9b:	83 ec 08             	sub    $0x8,%esp
      9e:	68 c7 41 00 00       	push   $0x41c7
      a3:	50                   	push   %eax
      a4:	e8 08 3d 00 00       	call   3db1 <printf>
      a9:	83 c4 10             	add    $0x10,%esp
}
      ac:	90                   	nop
      ad:	c9                   	leave  
      ae:	c3                   	ret    

000000af <writetest>:

void
writetest(void)
{
      af:	55                   	push   %ebp
      b0:	89 e5                	mov    %esp,%ebp
      b2:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
      b5:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
      ba:	83 ec 08             	sub    $0x8,%esp
      bd:	68 d5 41 00 00       	push   $0x41d5
      c2:	50                   	push   %eax
      c3:	e8 e9 3c 00 00       	call   3db1 <printf>
      c8:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_CREATE|O_RDWR);
      cb:	83 ec 08             	sub    $0x8,%esp
      ce:	68 02 02 00 00       	push   $0x202
      d3:	68 e6 41 00 00       	push   $0x41e6
      d8:	e8 78 3b 00 00       	call   3c55 <open>
      dd:	83 c4 10             	add    $0x10,%esp
      e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
      e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
      e7:	78 22                	js     10b <writetest+0x5c>
    printf(stdout, "creat small succeeded; ok\n");
      e9:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
      ee:	83 ec 08             	sub    $0x8,%esp
      f1:	68 ec 41 00 00       	push   $0x41ec
      f6:	50                   	push   %eax
      f7:	e8 b5 3c 00 00       	call   3db1 <printf>
      fc:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
      ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     106:	e9 8f 00 00 00       	jmp    19a <writetest+0xeb>
    printf(stdout, "error: creat small failed!\n");
     10b:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     110:	83 ec 08             	sub    $0x8,%esp
     113:	68 07 42 00 00       	push   $0x4207
     118:	50                   	push   %eax
     119:	e8 93 3c 00 00       	call   3db1 <printf>
     11e:	83 c4 10             	add    $0x10,%esp
    exit();
     121:	e8 ef 3a 00 00       	call   3c15 <exit>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     126:	83 ec 04             	sub    $0x4,%esp
     129:	6a 0a                	push   $0xa
     12b:	68 23 42 00 00       	push   $0x4223
     130:	ff 75 f0             	pushl  -0x10(%ebp)
     133:	e8 fd 3a 00 00       	call   3c35 <write>
     138:	83 c4 10             	add    $0x10,%esp
     13b:	83 f8 0a             	cmp    $0xa,%eax
     13e:	74 1e                	je     15e <writetest+0xaf>
      printf(stdout, "error: write aa %d new file failed\n", i);
     140:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     145:	83 ec 04             	sub    $0x4,%esp
     148:	ff 75 f4             	pushl  -0xc(%ebp)
     14b:	68 30 42 00 00       	push   $0x4230
     150:	50                   	push   %eax
     151:	e8 5b 3c 00 00       	call   3db1 <printf>
     156:	83 c4 10             	add    $0x10,%esp
      exit();
     159:	e8 b7 3a 00 00       	call   3c15 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     15e:	83 ec 04             	sub    $0x4,%esp
     161:	6a 0a                	push   $0xa
     163:	68 54 42 00 00       	push   $0x4254
     168:	ff 75 f0             	pushl  -0x10(%ebp)
     16b:	e8 c5 3a 00 00       	call   3c35 <write>
     170:	83 c4 10             	add    $0x10,%esp
     173:	83 f8 0a             	cmp    $0xa,%eax
     176:	74 1e                	je     196 <writetest+0xe7>
      printf(stdout, "error: write bb %d new file failed\n", i);
     178:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     17d:	83 ec 04             	sub    $0x4,%esp
     180:	ff 75 f4             	pushl  -0xc(%ebp)
     183:	68 60 42 00 00       	push   $0x4260
     188:	50                   	push   %eax
     189:	e8 23 3c 00 00       	call   3db1 <printf>
     18e:	83 c4 10             	add    $0x10,%esp
      exit();
     191:	e8 7f 3a 00 00       	call   3c15 <exit>
  for(i = 0; i < 100; i++){
     196:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     19a:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     19e:	7e 86                	jle    126 <writetest+0x77>
    }
  }
  printf(stdout, "writes ok\n");
     1a0:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     1a5:	83 ec 08             	sub    $0x8,%esp
     1a8:	68 84 42 00 00       	push   $0x4284
     1ad:	50                   	push   %eax
     1ae:	e8 fe 3b 00 00       	call   3db1 <printf>
     1b3:	83 c4 10             	add    $0x10,%esp
  close(fd);
     1b6:	83 ec 0c             	sub    $0xc,%esp
     1b9:	ff 75 f0             	pushl  -0x10(%ebp)
     1bc:	e8 7c 3a 00 00       	call   3c3d <close>
     1c1:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     1c4:	83 ec 08             	sub    $0x8,%esp
     1c7:	6a 00                	push   $0x0
     1c9:	68 e6 41 00 00       	push   $0x41e6
     1ce:	e8 82 3a 00 00       	call   3c55 <open>
     1d3:	83 c4 10             	add    $0x10,%esp
     1d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     1d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1dd:	78 3c                	js     21b <writetest+0x16c>
    printf(stdout, "open small succeeded ok\n");
     1df:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     1e4:	83 ec 08             	sub    $0x8,%esp
     1e7:	68 8f 42 00 00       	push   $0x428f
     1ec:	50                   	push   %eax
     1ed:	e8 bf 3b 00 00       	call   3db1 <printf>
     1f2:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     1f5:	83 ec 04             	sub    $0x4,%esp
     1f8:	68 d0 07 00 00       	push   $0x7d0
     1fd:	68 e0 5e 00 00       	push   $0x5ee0
     202:	ff 75 f0             	pushl  -0x10(%ebp)
     205:	e8 23 3a 00 00       	call   3c2d <read>
     20a:	83 c4 10             	add    $0x10,%esp
     20d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     210:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     217:	75 57                	jne    270 <writetest+0x1c1>
     219:	eb 1b                	jmp    236 <writetest+0x187>
    printf(stdout, "error: open small failed!\n");
     21b:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     220:	83 ec 08             	sub    $0x8,%esp
     223:	68 a8 42 00 00       	push   $0x42a8
     228:	50                   	push   %eax
     229:	e8 83 3b 00 00       	call   3db1 <printf>
     22e:	83 c4 10             	add    $0x10,%esp
    exit();
     231:	e8 df 39 00 00       	call   3c15 <exit>
    printf(stdout, "read succeeded ok\n");
     236:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     23b:	83 ec 08             	sub    $0x8,%esp
     23e:	68 c3 42 00 00       	push   $0x42c3
     243:	50                   	push   %eax
     244:	e8 68 3b 00 00       	call   3db1 <printf>
     249:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     24c:	83 ec 0c             	sub    $0xc,%esp
     24f:	ff 75 f0             	pushl  -0x10(%ebp)
     252:	e8 e6 39 00 00       	call   3c3d <close>
     257:	83 c4 10             	add    $0x10,%esp

  if(unlink("small") < 0){
     25a:	83 ec 0c             	sub    $0xc,%esp
     25d:	68 e6 41 00 00       	push   $0x41e6
     262:	e8 fe 39 00 00       	call   3c65 <unlink>
     267:	83 c4 10             	add    $0x10,%esp
     26a:	85 c0                	test   %eax,%eax
     26c:	79 38                	jns    2a6 <writetest+0x1f7>
     26e:	eb 1b                	jmp    28b <writetest+0x1dc>
    printf(stdout, "read failed\n");
     270:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     275:	83 ec 08             	sub    $0x8,%esp
     278:	68 d6 42 00 00       	push   $0x42d6
     27d:	50                   	push   %eax
     27e:	e8 2e 3b 00 00       	call   3db1 <printf>
     283:	83 c4 10             	add    $0x10,%esp
    exit();
     286:	e8 8a 39 00 00       	call   3c15 <exit>
    printf(stdout, "unlink small failed\n");
     28b:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     290:	83 ec 08             	sub    $0x8,%esp
     293:	68 e3 42 00 00       	push   $0x42e3
     298:	50                   	push   %eax
     299:	e8 13 3b 00 00       	call   3db1 <printf>
     29e:	83 c4 10             	add    $0x10,%esp
    exit();
     2a1:	e8 6f 39 00 00       	call   3c15 <exit>
  }
  printf(stdout, "small file test ok\n");
     2a6:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     2ab:	83 ec 08             	sub    $0x8,%esp
     2ae:	68 f8 42 00 00       	push   $0x42f8
     2b3:	50                   	push   %eax
     2b4:	e8 f8 3a 00 00       	call   3db1 <printf>
     2b9:	83 c4 10             	add    $0x10,%esp
}
     2bc:	90                   	nop
     2bd:	c9                   	leave  
     2be:	c3                   	ret    

000002bf <writetest1>:

void
writetest1(void)
{
     2bf:	55                   	push   %ebp
     2c0:	89 e5                	mov    %esp,%ebp
     2c2:	83 ec 18             	sub    $0x18,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     2c5:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     2ca:	83 ec 08             	sub    $0x8,%esp
     2cd:	68 0c 43 00 00       	push   $0x430c
     2d2:	50                   	push   %eax
     2d3:	e8 d9 3a 00 00       	call   3db1 <printf>
     2d8:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_CREATE|O_RDWR);
     2db:	83 ec 08             	sub    $0x8,%esp
     2de:	68 02 02 00 00       	push   $0x202
     2e3:	68 1c 43 00 00       	push   $0x431c
     2e8:	e8 68 39 00 00       	call   3c55 <open>
     2ed:	83 c4 10             	add    $0x10,%esp
     2f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     2f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     2f7:	79 1b                	jns    314 <writetest1+0x55>
    printf(stdout, "error: creat big failed!\n");
     2f9:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     2fe:	83 ec 08             	sub    $0x8,%esp
     301:	68 20 43 00 00       	push   $0x4320
     306:	50                   	push   %eax
     307:	e8 a5 3a 00 00       	call   3db1 <printf>
     30c:	83 c4 10             	add    $0x10,%esp
    exit();
     30f:	e8 01 39 00 00       	call   3c15 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     31b:	eb 4b                	jmp    368 <writetest1+0xa9>
    ((int*)buf)[0] = i;
     31d:	ba e0 5e 00 00       	mov    $0x5ee0,%edx
     322:	8b 45 f4             	mov    -0xc(%ebp),%eax
     325:	89 02                	mov    %eax,(%edx)
    if(write(fd, buf, 512) != 512){
     327:	83 ec 04             	sub    $0x4,%esp
     32a:	68 00 02 00 00       	push   $0x200
     32f:	68 e0 5e 00 00       	push   $0x5ee0
     334:	ff 75 ec             	pushl  -0x14(%ebp)
     337:	e8 f9 38 00 00       	call   3c35 <write>
     33c:	83 c4 10             	add    $0x10,%esp
     33f:	3d 00 02 00 00       	cmp    $0x200,%eax
     344:	74 1e                	je     364 <writetest1+0xa5>
      printf(stdout, "error: write big file failed\n", i);
     346:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     34b:	83 ec 04             	sub    $0x4,%esp
     34e:	ff 75 f4             	pushl  -0xc(%ebp)
     351:	68 3a 43 00 00       	push   $0x433a
     356:	50                   	push   %eax
     357:	e8 55 3a 00 00       	call   3db1 <printf>
     35c:	83 c4 10             	add    $0x10,%esp
      exit();
     35f:	e8 b1 38 00 00       	call   3c15 <exit>
  for(i = 0; i < MAXFILE; i++){
     364:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     368:	8b 45 f4             	mov    -0xc(%ebp),%eax
     36b:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     370:	76 ab                	jbe    31d <writetest1+0x5e>
    }
  }

  close(fd);
     372:	83 ec 0c             	sub    $0xc,%esp
     375:	ff 75 ec             	pushl  -0x14(%ebp)
     378:	e8 c0 38 00 00       	call   3c3d <close>
     37d:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_RDONLY);
     380:	83 ec 08             	sub    $0x8,%esp
     383:	6a 00                	push   $0x0
     385:	68 1c 43 00 00       	push   $0x431c
     38a:	e8 c6 38 00 00       	call   3c55 <open>
     38f:	83 c4 10             	add    $0x10,%esp
     392:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     395:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     399:	79 1b                	jns    3b6 <writetest1+0xf7>
    printf(stdout, "error: open big failed!\n");
     39b:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     3a0:	83 ec 08             	sub    $0x8,%esp
     3a3:	68 58 43 00 00       	push   $0x4358
     3a8:	50                   	push   %eax
     3a9:	e8 03 3a 00 00       	call   3db1 <printf>
     3ae:	83 c4 10             	add    $0x10,%esp
    exit();
     3b1:	e8 5f 38 00 00       	call   3c15 <exit>
  }

  n = 0;
     3b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     3bd:	83 ec 04             	sub    $0x4,%esp
     3c0:	68 00 02 00 00       	push   $0x200
     3c5:	68 e0 5e 00 00       	push   $0x5ee0
     3ca:	ff 75 ec             	pushl  -0x14(%ebp)
     3cd:	e8 5b 38 00 00       	call   3c2d <read>
     3d2:	83 c4 10             	add    $0x10,%esp
     3d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     3d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     3dc:	75 27                	jne    405 <writetest1+0x146>
      if(n == MAXFILE - 1){
     3de:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     3e5:	75 7d                	jne    464 <writetest1+0x1a5>
        printf(stdout, "read only %d blocks from big", n);
     3e7:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     3ec:	83 ec 04             	sub    $0x4,%esp
     3ef:	ff 75 f0             	pushl  -0x10(%ebp)
     3f2:	68 71 43 00 00       	push   $0x4371
     3f7:	50                   	push   %eax
     3f8:	e8 b4 39 00 00       	call   3db1 <printf>
     3fd:	83 c4 10             	add    $0x10,%esp
        exit();
     400:	e8 10 38 00 00       	call   3c15 <exit>
      }
      break;
    } else if(i != 512){
     405:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     40c:	74 1e                	je     42c <writetest1+0x16d>
      printf(stdout, "read failed %d\n", i);
     40e:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     413:	83 ec 04             	sub    $0x4,%esp
     416:	ff 75 f4             	pushl  -0xc(%ebp)
     419:	68 8e 43 00 00       	push   $0x438e
     41e:	50                   	push   %eax
     41f:	e8 8d 39 00 00       	call   3db1 <printf>
     424:	83 c4 10             	add    $0x10,%esp
      exit();
     427:	e8 e9 37 00 00       	call   3c15 <exit>
    }
    if(((int*)buf)[0] != n){
     42c:	b8 e0 5e 00 00       	mov    $0x5ee0,%eax
     431:	8b 00                	mov    (%eax),%eax
     433:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     436:	74 23                	je     45b <writetest1+0x19c>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     438:	b8 e0 5e 00 00       	mov    $0x5ee0,%eax
      printf(stdout, "read content of block %d is %d\n",
     43d:	8b 10                	mov    (%eax),%edx
     43f:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     444:	52                   	push   %edx
     445:	ff 75 f0             	pushl  -0x10(%ebp)
     448:	68 a0 43 00 00       	push   $0x43a0
     44d:	50                   	push   %eax
     44e:	e8 5e 39 00 00       	call   3db1 <printf>
     453:	83 c4 10             	add    $0x10,%esp
      exit();
     456:	e8 ba 37 00 00       	call   3c15 <exit>
    }
    n++;
     45b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    i = read(fd, buf, 512);
     45f:	e9 59 ff ff ff       	jmp    3bd <writetest1+0xfe>
      break;
     464:	90                   	nop
  }
  close(fd);
     465:	83 ec 0c             	sub    $0xc,%esp
     468:	ff 75 ec             	pushl  -0x14(%ebp)
     46b:	e8 cd 37 00 00       	call   3c3d <close>
     470:	83 c4 10             	add    $0x10,%esp
  if(unlink("big") < 0){
     473:	83 ec 0c             	sub    $0xc,%esp
     476:	68 1c 43 00 00       	push   $0x431c
     47b:	e8 e5 37 00 00       	call   3c65 <unlink>
     480:	83 c4 10             	add    $0x10,%esp
     483:	85 c0                	test   %eax,%eax
     485:	79 1b                	jns    4a2 <writetest1+0x1e3>
    printf(stdout, "unlink big failed\n");
     487:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     48c:	83 ec 08             	sub    $0x8,%esp
     48f:	68 c0 43 00 00       	push   $0x43c0
     494:	50                   	push   %eax
     495:	e8 17 39 00 00       	call   3db1 <printf>
     49a:	83 c4 10             	add    $0x10,%esp
    exit();
     49d:	e8 73 37 00 00       	call   3c15 <exit>
  }
  printf(stdout, "big files ok\n");
     4a2:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     4a7:	83 ec 08             	sub    $0x8,%esp
     4aa:	68 d3 43 00 00       	push   $0x43d3
     4af:	50                   	push   %eax
     4b0:	e8 fc 38 00 00       	call   3db1 <printf>
     4b5:	83 c4 10             	add    $0x10,%esp
}
     4b8:	90                   	nop
     4b9:	c9                   	leave  
     4ba:	c3                   	ret    

000004bb <createtest>:

void
createtest(void)
{
     4bb:	55                   	push   %ebp
     4bc:	89 e5                	mov    %esp,%ebp
     4be:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     4c1:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     4c6:	83 ec 08             	sub    $0x8,%esp
     4c9:	68 e4 43 00 00       	push   $0x43e4
     4ce:	50                   	push   %eax
     4cf:	e8 dd 38 00 00       	call   3db1 <printf>
     4d4:	83 c4 10             	add    $0x10,%esp

  name[0] = 'a';
     4d7:	c6 05 e0 7e 00 00 61 	movb   $0x61,0x7ee0
  name[2] = '\0';
     4de:	c6 05 e2 7e 00 00 00 	movb   $0x0,0x7ee2
  for(i = 0; i < 52; i++){
     4e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4ec:	eb 35                	jmp    523 <createtest+0x68>
    name[1] = '0' + i;
     4ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f1:	83 c0 30             	add    $0x30,%eax
     4f4:	a2 e1 7e 00 00       	mov    %al,0x7ee1
    fd = open(name, O_CREATE|O_RDWR);
     4f9:	83 ec 08             	sub    $0x8,%esp
     4fc:	68 02 02 00 00       	push   $0x202
     501:	68 e0 7e 00 00       	push   $0x7ee0
     506:	e8 4a 37 00 00       	call   3c55 <open>
     50b:	83 c4 10             	add    $0x10,%esp
     50e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     511:	83 ec 0c             	sub    $0xc,%esp
     514:	ff 75 f0             	pushl  -0x10(%ebp)
     517:	e8 21 37 00 00       	call   3c3d <close>
     51c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 52; i++){
     51f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     523:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     527:	7e c5                	jle    4ee <createtest+0x33>
  }
  name[0] = 'a';
     529:	c6 05 e0 7e 00 00 61 	movb   $0x61,0x7ee0
  name[2] = '\0';
     530:	c6 05 e2 7e 00 00 00 	movb   $0x0,0x7ee2
  for(i = 0; i < 52; i++){
     537:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     53e:	eb 1f                	jmp    55f <createtest+0xa4>
    name[1] = '0' + i;
     540:	8b 45 f4             	mov    -0xc(%ebp),%eax
     543:	83 c0 30             	add    $0x30,%eax
     546:	a2 e1 7e 00 00       	mov    %al,0x7ee1
    unlink(name);
     54b:	83 ec 0c             	sub    $0xc,%esp
     54e:	68 e0 7e 00 00       	push   $0x7ee0
     553:	e8 0d 37 00 00       	call   3c65 <unlink>
     558:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 52; i++){
     55b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     55f:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     563:	7e db                	jle    540 <createtest+0x85>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     565:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     56a:	83 ec 08             	sub    $0x8,%esp
     56d:	68 0c 44 00 00       	push   $0x440c
     572:	50                   	push   %eax
     573:	e8 39 38 00 00       	call   3db1 <printf>
     578:	83 c4 10             	add    $0x10,%esp
}
     57b:	90                   	nop
     57c:	c9                   	leave  
     57d:	c3                   	ret    

0000057e <dirtest>:

void dirtest(void)
{
     57e:	55                   	push   %ebp
     57f:	89 e5                	mov    %esp,%ebp
     581:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "mkdir test\n");
     584:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     589:	83 ec 08             	sub    $0x8,%esp
     58c:	68 32 44 00 00       	push   $0x4432
     591:	50                   	push   %eax
     592:	e8 1a 38 00 00       	call   3db1 <printf>
     597:	83 c4 10             	add    $0x10,%esp

  if(mkdir("dir0") < 0){
     59a:	83 ec 0c             	sub    $0xc,%esp
     59d:	68 3e 44 00 00       	push   $0x443e
     5a2:	e8 d6 36 00 00       	call   3c7d <mkdir>
     5a7:	83 c4 10             	add    $0x10,%esp
     5aa:	85 c0                	test   %eax,%eax
     5ac:	79 1b                	jns    5c9 <dirtest+0x4b>
    printf(stdout, "mkdir failed\n");
     5ae:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     5b3:	83 ec 08             	sub    $0x8,%esp
     5b6:	68 43 44 00 00       	push   $0x4443
     5bb:	50                   	push   %eax
     5bc:	e8 f0 37 00 00       	call   3db1 <printf>
     5c1:	83 c4 10             	add    $0x10,%esp
    exit();
     5c4:	e8 4c 36 00 00       	call   3c15 <exit>
  }

  if(chdir("dir0") < 0){
     5c9:	83 ec 0c             	sub    $0xc,%esp
     5cc:	68 3e 44 00 00       	push   $0x443e
     5d1:	e8 af 36 00 00       	call   3c85 <chdir>
     5d6:	83 c4 10             	add    $0x10,%esp
     5d9:	85 c0                	test   %eax,%eax
     5db:	79 1b                	jns    5f8 <dirtest+0x7a>
    printf(stdout, "chdir dir0 failed\n");
     5dd:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     5e2:	83 ec 08             	sub    $0x8,%esp
     5e5:	68 51 44 00 00       	push   $0x4451
     5ea:	50                   	push   %eax
     5eb:	e8 c1 37 00 00       	call   3db1 <printf>
     5f0:	83 c4 10             	add    $0x10,%esp
    exit();
     5f3:	e8 1d 36 00 00       	call   3c15 <exit>
  }

  if(chdir("..") < 0){
     5f8:	83 ec 0c             	sub    $0xc,%esp
     5fb:	68 64 44 00 00       	push   $0x4464
     600:	e8 80 36 00 00       	call   3c85 <chdir>
     605:	83 c4 10             	add    $0x10,%esp
     608:	85 c0                	test   %eax,%eax
     60a:	79 1b                	jns    627 <dirtest+0xa9>
    printf(stdout, "chdir .. failed\n");
     60c:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     611:	83 ec 08             	sub    $0x8,%esp
     614:	68 67 44 00 00       	push   $0x4467
     619:	50                   	push   %eax
     61a:	e8 92 37 00 00       	call   3db1 <printf>
     61f:	83 c4 10             	add    $0x10,%esp
    exit();
     622:	e8 ee 35 00 00       	call   3c15 <exit>
  }

  if(unlink("dir0") < 0){
     627:	83 ec 0c             	sub    $0xc,%esp
     62a:	68 3e 44 00 00       	push   $0x443e
     62f:	e8 31 36 00 00       	call   3c65 <unlink>
     634:	83 c4 10             	add    $0x10,%esp
     637:	85 c0                	test   %eax,%eax
     639:	79 1b                	jns    656 <dirtest+0xd8>
    printf(stdout, "unlink dir0 failed\n");
     63b:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     640:	83 ec 08             	sub    $0x8,%esp
     643:	68 78 44 00 00       	push   $0x4478
     648:	50                   	push   %eax
     649:	e8 63 37 00 00       	call   3db1 <printf>
     64e:	83 c4 10             	add    $0x10,%esp
    exit();
     651:	e8 bf 35 00 00       	call   3c15 <exit>
  }
  printf(stdout, "mkdir test\n");
     656:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     65b:	83 ec 08             	sub    $0x8,%esp
     65e:	68 32 44 00 00       	push   $0x4432
     663:	50                   	push   %eax
     664:	e8 48 37 00 00       	call   3db1 <printf>
     669:	83 c4 10             	add    $0x10,%esp
}
     66c:	90                   	nop
     66d:	c9                   	leave  
     66e:	c3                   	ret    

0000066f <exectest>:

void
exectest(void)
{
     66f:	55                   	push   %ebp
     670:	89 e5                	mov    %esp,%ebp
     672:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "exec test\n");
     675:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     67a:	83 ec 08             	sub    $0x8,%esp
     67d:	68 8c 44 00 00       	push   $0x448c
     682:	50                   	push   %eax
     683:	e8 29 37 00 00       	call   3db1 <printf>
     688:	83 c4 10             	add    $0x10,%esp
  if(exec("echo", echoargv) < 0){
     68b:	83 ec 08             	sub    $0x8,%esp
     68e:	68 a4 5e 00 00       	push   $0x5ea4
     693:	68 68 41 00 00       	push   $0x4168
     698:	e8 b0 35 00 00       	call   3c4d <exec>
     69d:	83 c4 10             	add    $0x10,%esp
     6a0:	85 c0                	test   %eax,%eax
     6a2:	79 1b                	jns    6bf <exectest+0x50>
    printf(stdout, "exec echo failed\n");
     6a4:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
     6a9:	83 ec 08             	sub    $0x8,%esp
     6ac:	68 97 44 00 00       	push   $0x4497
     6b1:	50                   	push   %eax
     6b2:	e8 fa 36 00 00       	call   3db1 <printf>
     6b7:	83 c4 10             	add    $0x10,%esp
    exit();
     6ba:	e8 56 35 00 00       	call   3c15 <exit>
  }
}
     6bf:	90                   	nop
     6c0:	c9                   	leave  
     6c1:	c3                   	ret    

000006c2 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     6c2:	55                   	push   %ebp
     6c3:	89 e5                	mov    %esp,%ebp
     6c5:	83 ec 28             	sub    $0x28,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     6c8:	83 ec 0c             	sub    $0xc,%esp
     6cb:	8d 45 d8             	lea    -0x28(%ebp),%eax
     6ce:	50                   	push   %eax
     6cf:	e8 51 35 00 00       	call   3c25 <pipe>
     6d4:	83 c4 10             	add    $0x10,%esp
     6d7:	85 c0                	test   %eax,%eax
     6d9:	74 17                	je     6f2 <pipe1+0x30>
    printf(1, "pipe() failed\n");
     6db:	83 ec 08             	sub    $0x8,%esp
     6de:	68 a9 44 00 00       	push   $0x44a9
     6e3:	6a 01                	push   $0x1
     6e5:	e8 c7 36 00 00       	call   3db1 <printf>
     6ea:	83 c4 10             	add    $0x10,%esp
    exit();
     6ed:	e8 23 35 00 00       	call   3c15 <exit>
  }
  pid = fork();
     6f2:	e8 16 35 00 00       	call   3c0d <fork>
     6f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     6fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     701:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     705:	0f 85 89 00 00 00    	jne    794 <pipe1+0xd2>
    close(fds[0]);
     70b:	8b 45 d8             	mov    -0x28(%ebp),%eax
     70e:	83 ec 0c             	sub    $0xc,%esp
     711:	50                   	push   %eax
     712:	e8 26 35 00 00       	call   3c3d <close>
     717:	83 c4 10             	add    $0x10,%esp
    for(n = 0; n < 5; n++){
     71a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     721:	eb 66                	jmp    789 <pipe1+0xc7>
      for(i = 0; i < 1033; i++)
     723:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     72a:	eb 19                	jmp    745 <pipe1+0x83>
        buf[i] = seq++;
     72c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     72f:	8d 50 01             	lea    0x1(%eax),%edx
     732:	89 55 f4             	mov    %edx,-0xc(%ebp)
     735:	89 c2                	mov    %eax,%edx
     737:	8b 45 f0             	mov    -0x10(%ebp),%eax
     73a:	05 e0 5e 00 00       	add    $0x5ee0,%eax
     73f:	88 10                	mov    %dl,(%eax)
      for(i = 0; i < 1033; i++)
     741:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     745:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     74c:	7e de                	jle    72c <pipe1+0x6a>
      if(write(fds[1], buf, 1033) != 1033){
     74e:	8b 45 dc             	mov    -0x24(%ebp),%eax
     751:	83 ec 04             	sub    $0x4,%esp
     754:	68 09 04 00 00       	push   $0x409
     759:	68 e0 5e 00 00       	push   $0x5ee0
     75e:	50                   	push   %eax
     75f:	e8 d1 34 00 00       	call   3c35 <write>
     764:	83 c4 10             	add    $0x10,%esp
     767:	3d 09 04 00 00       	cmp    $0x409,%eax
     76c:	74 17                	je     785 <pipe1+0xc3>
        printf(1, "pipe1 oops 1\n");
     76e:	83 ec 08             	sub    $0x8,%esp
     771:	68 b8 44 00 00       	push   $0x44b8
     776:	6a 01                	push   $0x1
     778:	e8 34 36 00 00       	call   3db1 <printf>
     77d:	83 c4 10             	add    $0x10,%esp
        exit();
     780:	e8 90 34 00 00       	call   3c15 <exit>
    for(n = 0; n < 5; n++){
     785:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     789:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     78d:	7e 94                	jle    723 <pipe1+0x61>
      }
    }
    exit();
     78f:	e8 81 34 00 00       	call   3c15 <exit>
  } else if(pid > 0){
     794:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     798:	0f 8e f4 00 00 00    	jle    892 <pipe1+0x1d0>
    close(fds[1]);
     79e:	8b 45 dc             	mov    -0x24(%ebp),%eax
     7a1:	83 ec 0c             	sub    $0xc,%esp
     7a4:	50                   	push   %eax
     7a5:	e8 93 34 00 00       	call   3c3d <close>
     7aa:	83 c4 10             	add    $0x10,%esp
    total = 0;
     7ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     7b4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     7bb:	eb 66                	jmp    823 <pipe1+0x161>
      for(i = 0; i < n; i++){
     7bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     7c4:	eb 3b                	jmp    801 <pipe1+0x13f>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     7c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7c9:	05 e0 5e 00 00       	add    $0x5ee0,%eax
     7ce:	0f b6 00             	movzbl (%eax),%eax
     7d1:	0f be c8             	movsbl %al,%ecx
     7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7d7:	8d 50 01             	lea    0x1(%eax),%edx
     7da:	89 55 f4             	mov    %edx,-0xc(%ebp)
     7dd:	31 c8                	xor    %ecx,%eax
     7df:	0f b6 c0             	movzbl %al,%eax
     7e2:	85 c0                	test   %eax,%eax
     7e4:	74 17                	je     7fd <pipe1+0x13b>
          printf(1, "pipe1 oops 2\n");
     7e6:	83 ec 08             	sub    $0x8,%esp
     7e9:	68 c6 44 00 00       	push   $0x44c6
     7ee:	6a 01                	push   $0x1
     7f0:	e8 bc 35 00 00       	call   3db1 <printf>
     7f5:	83 c4 10             	add    $0x10,%esp
     7f8:	e9 ac 00 00 00       	jmp    8a9 <pipe1+0x1e7>
      for(i = 0; i < n; i++){
     7fd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     801:	8b 45 f0             	mov    -0x10(%ebp),%eax
     804:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     807:	7c bd                	jl     7c6 <pipe1+0x104>
          return;
        }
      }
      total += n;
     809:	8b 45 ec             	mov    -0x14(%ebp),%eax
     80c:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     80f:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     812:	8b 45 e8             	mov    -0x18(%ebp),%eax
     815:	3d 00 20 00 00       	cmp    $0x2000,%eax
     81a:	76 07                	jbe    823 <pipe1+0x161>
        cc = sizeof(buf);
     81c:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     823:	8b 45 d8             	mov    -0x28(%ebp),%eax
     826:	83 ec 04             	sub    $0x4,%esp
     829:	ff 75 e8             	pushl  -0x18(%ebp)
     82c:	68 e0 5e 00 00       	push   $0x5ee0
     831:	50                   	push   %eax
     832:	e8 f6 33 00 00       	call   3c2d <read>
     837:	83 c4 10             	add    $0x10,%esp
     83a:	89 45 ec             	mov    %eax,-0x14(%ebp)
     83d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     841:	0f 8f 76 ff ff ff    	jg     7bd <pipe1+0xfb>
    }
    if(total != 5 * 1033){
     847:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     84e:	74 1a                	je     86a <pipe1+0x1a8>
      printf(1, "pipe1 oops 3 total %d\n", total);
     850:	83 ec 04             	sub    $0x4,%esp
     853:	ff 75 e4             	pushl  -0x1c(%ebp)
     856:	68 d4 44 00 00       	push   $0x44d4
     85b:	6a 01                	push   $0x1
     85d:	e8 4f 35 00 00       	call   3db1 <printf>
     862:	83 c4 10             	add    $0x10,%esp
      exit();
     865:	e8 ab 33 00 00       	call   3c15 <exit>
    }
    close(fds[0]);
     86a:	8b 45 d8             	mov    -0x28(%ebp),%eax
     86d:	83 ec 0c             	sub    $0xc,%esp
     870:	50                   	push   %eax
     871:	e8 c7 33 00 00       	call   3c3d <close>
     876:	83 c4 10             	add    $0x10,%esp
    wait();
     879:	e8 9f 33 00 00       	call   3c1d <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     87e:	83 ec 08             	sub    $0x8,%esp
     881:	68 fa 44 00 00       	push   $0x44fa
     886:	6a 01                	push   $0x1
     888:	e8 24 35 00 00       	call   3db1 <printf>
     88d:	83 c4 10             	add    $0x10,%esp
     890:	eb 17                	jmp    8a9 <pipe1+0x1e7>
    printf(1, "fork() failed\n");
     892:	83 ec 08             	sub    $0x8,%esp
     895:	68 eb 44 00 00       	push   $0x44eb
     89a:	6a 01                	push   $0x1
     89c:	e8 10 35 00 00       	call   3db1 <printf>
     8a1:	83 c4 10             	add    $0x10,%esp
    exit();
     8a4:	e8 6c 33 00 00       	call   3c15 <exit>
}
     8a9:	c9                   	leave  
     8aa:	c3                   	ret    

000008ab <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     8ab:	55                   	push   %ebp
     8ac:	89 e5                	mov    %esp,%ebp
     8ae:	83 ec 28             	sub    $0x28,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     8b1:	83 ec 08             	sub    $0x8,%esp
     8b4:	68 04 45 00 00       	push   $0x4504
     8b9:	6a 01                	push   $0x1
     8bb:	e8 f1 34 00 00       	call   3db1 <printf>
     8c0:	83 c4 10             	add    $0x10,%esp
  pid1 = fork();
     8c3:	e8 45 33 00 00       	call   3c0d <fork>
     8c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     8cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     8cf:	75 02                	jne    8d3 <preempt+0x28>
    for(;;)
     8d1:	eb fe                	jmp    8d1 <preempt+0x26>
      ;

  pid2 = fork();
     8d3:	e8 35 33 00 00       	call   3c0d <fork>
     8d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     8db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8df:	75 02                	jne    8e3 <preempt+0x38>
    for(;;)
     8e1:	eb fe                	jmp    8e1 <preempt+0x36>
      ;

  pipe(pfds);
     8e3:	83 ec 0c             	sub    $0xc,%esp
     8e6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     8e9:	50                   	push   %eax
     8ea:	e8 36 33 00 00       	call   3c25 <pipe>
     8ef:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     8f2:	e8 16 33 00 00       	call   3c0d <fork>
     8f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     8fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     8fe:	75 4d                	jne    94d <preempt+0xa2>
    close(pfds[0]);
     900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     903:	83 ec 0c             	sub    $0xc,%esp
     906:	50                   	push   %eax
     907:	e8 31 33 00 00       	call   3c3d <close>
     90c:	83 c4 10             	add    $0x10,%esp
    if(write(pfds[1], "x", 1) != 1)
     90f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     912:	83 ec 04             	sub    $0x4,%esp
     915:	6a 01                	push   $0x1
     917:	68 0e 45 00 00       	push   $0x450e
     91c:	50                   	push   %eax
     91d:	e8 13 33 00 00       	call   3c35 <write>
     922:	83 c4 10             	add    $0x10,%esp
     925:	83 f8 01             	cmp    $0x1,%eax
     928:	74 12                	je     93c <preempt+0x91>
      printf(1, "preempt write error");
     92a:	83 ec 08             	sub    $0x8,%esp
     92d:	68 10 45 00 00       	push   $0x4510
     932:	6a 01                	push   $0x1
     934:	e8 78 34 00 00       	call   3db1 <printf>
     939:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     93c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     93f:	83 ec 0c             	sub    $0xc,%esp
     942:	50                   	push   %eax
     943:	e8 f5 32 00 00       	call   3c3d <close>
     948:	83 c4 10             	add    $0x10,%esp
    for(;;)
     94b:	eb fe                	jmp    94b <preempt+0xa0>
      ;
  }

  close(pfds[1]);
     94d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     950:	83 ec 0c             	sub    $0xc,%esp
     953:	50                   	push   %eax
     954:	e8 e4 32 00 00       	call   3c3d <close>
     959:	83 c4 10             	add    $0x10,%esp
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     95c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     95f:	83 ec 04             	sub    $0x4,%esp
     962:	68 00 20 00 00       	push   $0x2000
     967:	68 e0 5e 00 00       	push   $0x5ee0
     96c:	50                   	push   %eax
     96d:	e8 bb 32 00 00       	call   3c2d <read>
     972:	83 c4 10             	add    $0x10,%esp
     975:	83 f8 01             	cmp    $0x1,%eax
     978:	74 14                	je     98e <preempt+0xe3>
    printf(1, "preempt read error");
     97a:	83 ec 08             	sub    $0x8,%esp
     97d:	68 24 45 00 00       	push   $0x4524
     982:	6a 01                	push   $0x1
     984:	e8 28 34 00 00       	call   3db1 <printf>
     989:	83 c4 10             	add    $0x10,%esp
     98c:	eb 7e                	jmp    a0c <preempt+0x161>
    return;
  }
  close(pfds[0]);
     98e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     991:	83 ec 0c             	sub    $0xc,%esp
     994:	50                   	push   %eax
     995:	e8 a3 32 00 00       	call   3c3d <close>
     99a:	83 c4 10             	add    $0x10,%esp
  printf(1, "kill... ");
     99d:	83 ec 08             	sub    $0x8,%esp
     9a0:	68 37 45 00 00       	push   $0x4537
     9a5:	6a 01                	push   $0x1
     9a7:	e8 05 34 00 00       	call   3db1 <printf>
     9ac:	83 c4 10             	add    $0x10,%esp
  kill(pid1);
     9af:	83 ec 0c             	sub    $0xc,%esp
     9b2:	ff 75 f4             	pushl  -0xc(%ebp)
     9b5:	e8 8b 32 00 00       	call   3c45 <kill>
     9ba:	83 c4 10             	add    $0x10,%esp
  kill(pid2);
     9bd:	83 ec 0c             	sub    $0xc,%esp
     9c0:	ff 75 f0             	pushl  -0x10(%ebp)
     9c3:	e8 7d 32 00 00       	call   3c45 <kill>
     9c8:	83 c4 10             	add    $0x10,%esp
  kill(pid3);
     9cb:	83 ec 0c             	sub    $0xc,%esp
     9ce:	ff 75 ec             	pushl  -0x14(%ebp)
     9d1:	e8 6f 32 00 00       	call   3c45 <kill>
     9d6:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
     9d9:	83 ec 08             	sub    $0x8,%esp
     9dc:	68 40 45 00 00       	push   $0x4540
     9e1:	6a 01                	push   $0x1
     9e3:	e8 c9 33 00 00       	call   3db1 <printf>
     9e8:	83 c4 10             	add    $0x10,%esp
  wait();
     9eb:	e8 2d 32 00 00       	call   3c1d <wait>
  wait();
     9f0:	e8 28 32 00 00       	call   3c1d <wait>
  wait();
     9f5:	e8 23 32 00 00       	call   3c1d <wait>
  printf(1, "preempt ok\n");
     9fa:	83 ec 08             	sub    $0x8,%esp
     9fd:	68 49 45 00 00       	push   $0x4549
     a02:	6a 01                	push   $0x1
     a04:	e8 a8 33 00 00       	call   3db1 <printf>
     a09:	83 c4 10             	add    $0x10,%esp
}
     a0c:	c9                   	leave  
     a0d:	c3                   	ret    

00000a0e <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     a0e:	55                   	push   %ebp
     a0f:	89 e5                	mov    %esp,%ebp
     a11:	83 ec 18             	sub    $0x18,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     a14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a1b:	eb 4f                	jmp    a6c <exitwait+0x5e>
    pid = fork();
     a1d:	e8 eb 31 00 00       	call   3c0d <fork>
     a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     a25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a29:	79 14                	jns    a3f <exitwait+0x31>
      printf(1, "fork failed\n");
     a2b:	83 ec 08             	sub    $0x8,%esp
     a2e:	68 55 45 00 00       	push   $0x4555
     a33:	6a 01                	push   $0x1
     a35:	e8 77 33 00 00       	call   3db1 <printf>
     a3a:	83 c4 10             	add    $0x10,%esp
      return;
     a3d:	eb 45                	jmp    a84 <exitwait+0x76>
    }
    if(pid){
     a3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a43:	74 1e                	je     a63 <exitwait+0x55>
      if(wait() != pid){
     a45:	e8 d3 31 00 00       	call   3c1d <wait>
     a4a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     a4d:	74 19                	je     a68 <exitwait+0x5a>
        printf(1, "wait wrong pid\n");
     a4f:	83 ec 08             	sub    $0x8,%esp
     a52:	68 62 45 00 00       	push   $0x4562
     a57:	6a 01                	push   $0x1
     a59:	e8 53 33 00 00       	call   3db1 <printf>
     a5e:	83 c4 10             	add    $0x10,%esp
        return;
     a61:	eb 21                	jmp    a84 <exitwait+0x76>
      }
    } else {
      exit();
     a63:	e8 ad 31 00 00       	call   3c15 <exit>
  for(i = 0; i < 100; i++){
     a68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a6c:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     a70:	7e ab                	jle    a1d <exitwait+0xf>
    }
  }
  printf(1, "exitwait ok\n");
     a72:	83 ec 08             	sub    $0x8,%esp
     a75:	68 72 45 00 00       	push   $0x4572
     a7a:	6a 01                	push   $0x1
     a7c:	e8 30 33 00 00       	call   3db1 <printf>
     a81:	83 c4 10             	add    $0x10,%esp
}
     a84:	c9                   	leave  
     a85:	c3                   	ret    

00000a86 <mem>:

void
mem(void)
{
     a86:	55                   	push   %ebp
     a87:	89 e5                	mov    %esp,%ebp
     a89:	83 ec 18             	sub    $0x18,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     a8c:	83 ec 08             	sub    $0x8,%esp
     a8f:	68 7f 45 00 00       	push   $0x457f
     a94:	6a 01                	push   $0x1
     a96:	e8 16 33 00 00       	call   3db1 <printf>
     a9b:	83 c4 10             	add    $0x10,%esp
  ppid = getpid();
     a9e:	e8 f2 31 00 00       	call   3c95 <getpid>
     aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     aa6:	e8 62 31 00 00       	call   3c0d <fork>
     aab:	89 45 ec             	mov    %eax,-0x14(%ebp)
     aae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ab2:	0f 85 b7 00 00 00    	jne    b6f <mem+0xe9>
    m1 = 0;
     ab8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     abf:	eb 0e                	jmp    acf <mem+0x49>
      *(char**)m2 = m1;
     ac1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ac4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ac7:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     ac9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     acf:	83 ec 0c             	sub    $0xc,%esp
     ad2:	68 11 27 00 00       	push   $0x2711
     ad7:	e8 a9 35 00 00       	call   4085 <malloc>
     adc:	83 c4 10             	add    $0x10,%esp
     adf:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ae2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     ae6:	75 d9                	jne    ac1 <mem+0x3b>
    }
    while(m1){
     ae8:	eb 1c                	jmp    b06 <mem+0x80>
      m2 = *(char**)m1;
     aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aed:	8b 00                	mov    (%eax),%eax
     aef:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     af2:	83 ec 0c             	sub    $0xc,%esp
     af5:	ff 75 f4             	pushl  -0xc(%ebp)
     af8:	e8 46 34 00 00       	call   3f43 <free>
     afd:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(m1){
     b06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b0a:	75 de                	jne    aea <mem+0x64>
    }
    m1 = malloc(1024*20);
     b0c:	83 ec 0c             	sub    $0xc,%esp
     b0f:	68 00 50 00 00       	push   $0x5000
     b14:	e8 6c 35 00 00       	call   4085 <malloc>
     b19:	83 c4 10             	add    $0x10,%esp
     b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     b1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b23:	75 25                	jne    b4a <mem+0xc4>
      printf(1, "couldn't allocate mem?!!\n");
     b25:	83 ec 08             	sub    $0x8,%esp
     b28:	68 89 45 00 00       	push   $0x4589
     b2d:	6a 01                	push   $0x1
     b2f:	e8 7d 32 00 00       	call   3db1 <printf>
     b34:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
     b37:	83 ec 0c             	sub    $0xc,%esp
     b3a:	ff 75 f0             	pushl  -0x10(%ebp)
     b3d:	e8 03 31 00 00       	call   3c45 <kill>
     b42:	83 c4 10             	add    $0x10,%esp
      exit();
     b45:	e8 cb 30 00 00       	call   3c15 <exit>
    }
    free(m1);
     b4a:	83 ec 0c             	sub    $0xc,%esp
     b4d:	ff 75 f4             	pushl  -0xc(%ebp)
     b50:	e8 ee 33 00 00       	call   3f43 <free>
     b55:	83 c4 10             	add    $0x10,%esp
    printf(1, "mem ok\n");
     b58:	83 ec 08             	sub    $0x8,%esp
     b5b:	68 a3 45 00 00       	push   $0x45a3
     b60:	6a 01                	push   $0x1
     b62:	e8 4a 32 00 00       	call   3db1 <printf>
     b67:	83 c4 10             	add    $0x10,%esp
    exit();
     b6a:	e8 a6 30 00 00       	call   3c15 <exit>
  } else {
    wait();
     b6f:	e8 a9 30 00 00       	call   3c1d <wait>
  }
}
     b74:	90                   	nop
     b75:	c9                   	leave  
     b76:	c3                   	ret    

00000b77 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     b77:	55                   	push   %ebp
     b78:	89 e5                	mov    %esp,%ebp
     b7a:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     b7d:	83 ec 08             	sub    $0x8,%esp
     b80:	68 ab 45 00 00       	push   $0x45ab
     b85:	6a 01                	push   $0x1
     b87:	e8 25 32 00 00       	call   3db1 <printf>
     b8c:	83 c4 10             	add    $0x10,%esp

  unlink("sharedfd");
     b8f:	83 ec 0c             	sub    $0xc,%esp
     b92:	68 ba 45 00 00       	push   $0x45ba
     b97:	e8 c9 30 00 00       	call   3c65 <unlink>
     b9c:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", O_CREATE|O_RDWR);
     b9f:	83 ec 08             	sub    $0x8,%esp
     ba2:	68 02 02 00 00       	push   $0x202
     ba7:	68 ba 45 00 00       	push   $0x45ba
     bac:	e8 a4 30 00 00       	call   3c55 <open>
     bb1:	83 c4 10             	add    $0x10,%esp
     bb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     bb7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     bbb:	79 17                	jns    bd4 <sharedfd+0x5d>
    printf(1, "fstests: cannot open sharedfd for writing");
     bbd:	83 ec 08             	sub    $0x8,%esp
     bc0:	68 c4 45 00 00       	push   $0x45c4
     bc5:	6a 01                	push   $0x1
     bc7:	e8 e5 31 00 00       	call   3db1 <printf>
     bcc:	83 c4 10             	add    $0x10,%esp
    return;
     bcf:	e9 84 01 00 00       	jmp    d58 <sharedfd+0x1e1>
  }
  pid = fork();
     bd4:	e8 34 30 00 00       	call   3c0d <fork>
     bd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     bdc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     be0:	75 07                	jne    be9 <sharedfd+0x72>
     be2:	b8 63 00 00 00       	mov    $0x63,%eax
     be7:	eb 05                	jmp    bee <sharedfd+0x77>
     be9:	b8 70 00 00 00       	mov    $0x70,%eax
     bee:	83 ec 04             	sub    $0x4,%esp
     bf1:	6a 0a                	push   $0xa
     bf3:	50                   	push   %eax
     bf4:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     bf7:	50                   	push   %eax
     bf8:	e8 7d 2e 00 00       	call   3a7a <memset>
     bfd:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 1000; i++){
     c00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c07:	eb 31                	jmp    c3a <sharedfd+0xc3>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     c09:	83 ec 04             	sub    $0x4,%esp
     c0c:	6a 0a                	push   $0xa
     c0e:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     c11:	50                   	push   %eax
     c12:	ff 75 e8             	pushl  -0x18(%ebp)
     c15:	e8 1b 30 00 00       	call   3c35 <write>
     c1a:	83 c4 10             	add    $0x10,%esp
     c1d:	83 f8 0a             	cmp    $0xa,%eax
     c20:	74 14                	je     c36 <sharedfd+0xbf>
      printf(1, "fstests: write sharedfd failed\n");
     c22:	83 ec 08             	sub    $0x8,%esp
     c25:	68 f0 45 00 00       	push   $0x45f0
     c2a:	6a 01                	push   $0x1
     c2c:	e8 80 31 00 00       	call   3db1 <printf>
     c31:	83 c4 10             	add    $0x10,%esp
      break;
     c34:	eb 0d                	jmp    c43 <sharedfd+0xcc>
  for(i = 0; i < 1000; i++){
     c36:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c3a:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     c41:	7e c6                	jle    c09 <sharedfd+0x92>
    }
  }
  if(pid == 0)
     c43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     c47:	75 05                	jne    c4e <sharedfd+0xd7>
    exit();
     c49:	e8 c7 2f 00 00       	call   3c15 <exit>
  else
    wait();
     c4e:	e8 ca 2f 00 00       	call   3c1d <wait>
  close(fd);
     c53:	83 ec 0c             	sub    $0xc,%esp
     c56:	ff 75 e8             	pushl  -0x18(%ebp)
     c59:	e8 df 2f 00 00       	call   3c3d <close>
     c5e:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", 0);
     c61:	83 ec 08             	sub    $0x8,%esp
     c64:	6a 00                	push   $0x0
     c66:	68 ba 45 00 00       	push   $0x45ba
     c6b:	e8 e5 2f 00 00       	call   3c55 <open>
     c70:	83 c4 10             	add    $0x10,%esp
     c73:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     c76:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     c7a:	79 17                	jns    c93 <sharedfd+0x11c>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     c7c:	83 ec 08             	sub    $0x8,%esp
     c7f:	68 10 46 00 00       	push   $0x4610
     c84:	6a 01                	push   $0x1
     c86:	e8 26 31 00 00       	call   3db1 <printf>
     c8b:	83 c4 10             	add    $0x10,%esp
    return;
     c8e:	e9 c5 00 00 00       	jmp    d58 <sharedfd+0x1e1>
  }
  nc = np = 0;
     c93:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     ca0:	eb 3b                	jmp    cdd <sharedfd+0x166>
    for(i = 0; i < sizeof(buf); i++){
     ca2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ca9:	eb 2a                	jmp    cd5 <sharedfd+0x15e>
      if(buf[i] == 'c')
     cab:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cb1:	01 d0                	add    %edx,%eax
     cb3:	0f b6 00             	movzbl (%eax),%eax
     cb6:	3c 63                	cmp    $0x63,%al
     cb8:	75 04                	jne    cbe <sharedfd+0x147>
        nc++;
     cba:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     cbe:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cc4:	01 d0                	add    %edx,%eax
     cc6:	0f b6 00             	movzbl (%eax),%eax
     cc9:	3c 70                	cmp    $0x70,%al
     ccb:	75 04                	jne    cd1 <sharedfd+0x15a>
        np++;
     ccd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    for(i = 0; i < sizeof(buf); i++){
     cd1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cd8:	83 f8 09             	cmp    $0x9,%eax
     cdb:	76 ce                	jbe    cab <sharedfd+0x134>
  while((n = read(fd, buf, sizeof(buf))) > 0){
     cdd:	83 ec 04             	sub    $0x4,%esp
     ce0:	6a 0a                	push   $0xa
     ce2:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ce5:	50                   	push   %eax
     ce6:	ff 75 e8             	pushl  -0x18(%ebp)
     ce9:	e8 3f 2f 00 00       	call   3c2d <read>
     cee:	83 c4 10             	add    $0x10,%esp
     cf1:	89 45 e0             	mov    %eax,-0x20(%ebp)
     cf4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     cf8:	7f a8                	jg     ca2 <sharedfd+0x12b>
    }
  }
  close(fd);
     cfa:	83 ec 0c             	sub    $0xc,%esp
     cfd:	ff 75 e8             	pushl  -0x18(%ebp)
     d00:	e8 38 2f 00 00       	call   3c3d <close>
     d05:	83 c4 10             	add    $0x10,%esp
  unlink("sharedfd");
     d08:	83 ec 0c             	sub    $0xc,%esp
     d0b:	68 ba 45 00 00       	push   $0x45ba
     d10:	e8 50 2f 00 00       	call   3c65 <unlink>
     d15:	83 c4 10             	add    $0x10,%esp
  if(nc == 10000 && np == 10000){
     d18:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     d1f:	75 1d                	jne    d3e <sharedfd+0x1c7>
     d21:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
     d28:	75 14                	jne    d3e <sharedfd+0x1c7>
    printf(1, "sharedfd ok\n");
     d2a:	83 ec 08             	sub    $0x8,%esp
     d2d:	68 3b 46 00 00       	push   $0x463b
     d32:	6a 01                	push   $0x1
     d34:	e8 78 30 00 00       	call   3db1 <printf>
     d39:	83 c4 10             	add    $0x10,%esp
     d3c:	eb 1a                	jmp    d58 <sharedfd+0x1e1>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     d3e:	ff 75 ec             	pushl  -0x14(%ebp)
     d41:	ff 75 f0             	pushl  -0x10(%ebp)
     d44:	68 48 46 00 00       	push   $0x4648
     d49:	6a 01                	push   $0x1
     d4b:	e8 61 30 00 00       	call   3db1 <printf>
     d50:	83 c4 10             	add    $0x10,%esp
    exit();
     d53:	e8 bd 2e 00 00       	call   3c15 <exit>
  }
}
     d58:	c9                   	leave  
     d59:	c3                   	ret    

00000d5a <twofiles>:

// two processes write two different files at the same
// time, to test block allocation.
void
twofiles(void)
{
     d5a:	55                   	push   %ebp
     d5b:	89 e5                	mov    %esp,%ebp
     d5d:	83 ec 28             	sub    $0x28,%esp
  int fd, pid, i, j, n, total;
  char *fname;

  printf(1, "twofiles test\n");
     d60:	83 ec 08             	sub    $0x8,%esp
     d63:	68 5d 46 00 00       	push   $0x465d
     d68:	6a 01                	push   $0x1
     d6a:	e8 42 30 00 00       	call   3db1 <printf>
     d6f:	83 c4 10             	add    $0x10,%esp

  unlink("f1");
     d72:	83 ec 0c             	sub    $0xc,%esp
     d75:	68 6c 46 00 00       	push   $0x466c
     d7a:	e8 e6 2e 00 00       	call   3c65 <unlink>
     d7f:	83 c4 10             	add    $0x10,%esp
  unlink("f2");
     d82:	83 ec 0c             	sub    $0xc,%esp
     d85:	68 6f 46 00 00       	push   $0x466f
     d8a:	e8 d6 2e 00 00       	call   3c65 <unlink>
     d8f:	83 c4 10             	add    $0x10,%esp

  pid = fork();
     d92:	e8 76 2e 00 00       	call   3c0d <fork>
     d97:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(pid < 0){
     d9a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d9e:	79 17                	jns    db7 <twofiles+0x5d>
    printf(1, "fork failed\n");
     da0:	83 ec 08             	sub    $0x8,%esp
     da3:	68 55 45 00 00       	push   $0x4555
     da8:	6a 01                	push   $0x1
     daa:	e8 02 30 00 00       	call   3db1 <printf>
     daf:	83 c4 10             	add    $0x10,%esp
    exit();
     db2:	e8 5e 2e 00 00       	call   3c15 <exit>
  }

  fname = pid ? "f1" : "f2";
     db7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     dbb:	74 07                	je     dc4 <twofiles+0x6a>
     dbd:	b8 6c 46 00 00       	mov    $0x466c,%eax
     dc2:	eb 05                	jmp    dc9 <twofiles+0x6f>
     dc4:	b8 6f 46 00 00       	mov    $0x466f,%eax
     dc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  fd = open(fname, O_CREATE | O_RDWR);
     dcc:	83 ec 08             	sub    $0x8,%esp
     dcf:	68 02 02 00 00       	push   $0x202
     dd4:	ff 75 e4             	pushl  -0x1c(%ebp)
     dd7:	e8 79 2e 00 00       	call   3c55 <open>
     ddc:	83 c4 10             	add    $0x10,%esp
     ddf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(fd < 0){
     de2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     de6:	79 17                	jns    dff <twofiles+0xa5>
    printf(1, "create failed\n");
     de8:	83 ec 08             	sub    $0x8,%esp
     deb:	68 72 46 00 00       	push   $0x4672
     df0:	6a 01                	push   $0x1
     df2:	e8 ba 2f 00 00       	call   3db1 <printf>
     df7:	83 c4 10             	add    $0x10,%esp
    exit();
     dfa:	e8 16 2e 00 00       	call   3c15 <exit>
  }

  memset(buf, pid?'p':'c', 512);
     dff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e03:	74 07                	je     e0c <twofiles+0xb2>
     e05:	b8 70 00 00 00       	mov    $0x70,%eax
     e0a:	eb 05                	jmp    e11 <twofiles+0xb7>
     e0c:	b8 63 00 00 00       	mov    $0x63,%eax
     e11:	83 ec 04             	sub    $0x4,%esp
     e14:	68 00 02 00 00       	push   $0x200
     e19:	50                   	push   %eax
     e1a:	68 e0 5e 00 00       	push   $0x5ee0
     e1f:	e8 56 2c 00 00       	call   3a7a <memset>
     e24:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 12; i++){
     e27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e2e:	eb 42                	jmp    e72 <twofiles+0x118>
    if((n = write(fd, buf, 500)) != 500){
     e30:	83 ec 04             	sub    $0x4,%esp
     e33:	68 f4 01 00 00       	push   $0x1f4
     e38:	68 e0 5e 00 00       	push   $0x5ee0
     e3d:	ff 75 e0             	pushl  -0x20(%ebp)
     e40:	e8 f0 2d 00 00       	call   3c35 <write>
     e45:	83 c4 10             	add    $0x10,%esp
     e48:	89 45 dc             	mov    %eax,-0x24(%ebp)
     e4b:	81 7d dc f4 01 00 00 	cmpl   $0x1f4,-0x24(%ebp)
     e52:	74 1a                	je     e6e <twofiles+0x114>
      printf(1, "write failed %d\n", n);
     e54:	83 ec 04             	sub    $0x4,%esp
     e57:	ff 75 dc             	pushl  -0x24(%ebp)
     e5a:	68 81 46 00 00       	push   $0x4681
     e5f:	6a 01                	push   $0x1
     e61:	e8 4b 2f 00 00       	call   3db1 <printf>
     e66:	83 c4 10             	add    $0x10,%esp
      exit();
     e69:	e8 a7 2d 00 00       	call   3c15 <exit>
  for(i = 0; i < 12; i++){
     e6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     e72:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
     e76:	7e b8                	jle    e30 <twofiles+0xd6>
    }
  }
  close(fd);
     e78:	83 ec 0c             	sub    $0xc,%esp
     e7b:	ff 75 e0             	pushl  -0x20(%ebp)
     e7e:	e8 ba 2d 00 00       	call   3c3d <close>
     e83:	83 c4 10             	add    $0x10,%esp
  if(pid)
     e86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e8a:	74 11                	je     e9d <twofiles+0x143>
    wait();
     e8c:	e8 8c 2d 00 00       	call   3c1d <wait>
  else
    exit();

  for(i = 0; i < 2; i++){
     e91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e98:	e9 dd 00 00 00       	jmp    f7a <twofiles+0x220>
    exit();
     e9d:	e8 73 2d 00 00       	call   3c15 <exit>
    fd = open(i?"f1":"f2", 0);
     ea2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ea6:	74 07                	je     eaf <twofiles+0x155>
     ea8:	b8 6c 46 00 00       	mov    $0x466c,%eax
     ead:	eb 05                	jmp    eb4 <twofiles+0x15a>
     eaf:	b8 6f 46 00 00       	mov    $0x466f,%eax
     eb4:	83 ec 08             	sub    $0x8,%esp
     eb7:	6a 00                	push   $0x0
     eb9:	50                   	push   %eax
     eba:	e8 96 2d 00 00       	call   3c55 <open>
     ebf:	83 c4 10             	add    $0x10,%esp
     ec2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    total = 0;
     ec5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
     ecc:	eb 56                	jmp    f24 <twofiles+0x1ca>
      for(j = 0; j < n; j++){
     ece:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     ed5:	eb 3f                	jmp    f16 <twofiles+0x1bc>
        if(buf[j] != (i?'p':'c')){
     ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eda:	05 e0 5e 00 00       	add    $0x5ee0,%eax
     edf:	0f b6 00             	movzbl (%eax),%eax
     ee2:	0f be c0             	movsbl %al,%eax
     ee5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ee9:	74 07                	je     ef2 <twofiles+0x198>
     eeb:	ba 70 00 00 00       	mov    $0x70,%edx
     ef0:	eb 05                	jmp    ef7 <twofiles+0x19d>
     ef2:	ba 63 00 00 00       	mov    $0x63,%edx
     ef7:	39 c2                	cmp    %eax,%edx
     ef9:	74 17                	je     f12 <twofiles+0x1b8>
          printf(1, "wrong char\n");
     efb:	83 ec 08             	sub    $0x8,%esp
     efe:	68 92 46 00 00       	push   $0x4692
     f03:	6a 01                	push   $0x1
     f05:	e8 a7 2e 00 00       	call   3db1 <printf>
     f0a:	83 c4 10             	add    $0x10,%esp
          exit();
     f0d:	e8 03 2d 00 00       	call   3c15 <exit>
      for(j = 0; j < n; j++){
     f12:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f19:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     f1c:	7c b9                	jl     ed7 <twofiles+0x17d>
        }
      }
      total += n;
     f1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
     f21:	01 45 ec             	add    %eax,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
     f24:	83 ec 04             	sub    $0x4,%esp
     f27:	68 00 20 00 00       	push   $0x2000
     f2c:	68 e0 5e 00 00       	push   $0x5ee0
     f31:	ff 75 e0             	pushl  -0x20(%ebp)
     f34:	e8 f4 2c 00 00       	call   3c2d <read>
     f39:	83 c4 10             	add    $0x10,%esp
     f3c:	89 45 dc             	mov    %eax,-0x24(%ebp)
     f3f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
     f43:	7f 89                	jg     ece <twofiles+0x174>
    }
    close(fd);
     f45:	83 ec 0c             	sub    $0xc,%esp
     f48:	ff 75 e0             	pushl  -0x20(%ebp)
     f4b:	e8 ed 2c 00 00       	call   3c3d <close>
     f50:	83 c4 10             	add    $0x10,%esp
    if(total != 12*500){
     f53:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
     f5a:	74 1a                	je     f76 <twofiles+0x21c>
      printf(1, "wrong length %d\n", total);
     f5c:	83 ec 04             	sub    $0x4,%esp
     f5f:	ff 75 ec             	pushl  -0x14(%ebp)
     f62:	68 9e 46 00 00       	push   $0x469e
     f67:	6a 01                	push   $0x1
     f69:	e8 43 2e 00 00       	call   3db1 <printf>
     f6e:	83 c4 10             	add    $0x10,%esp
      exit();
     f71:	e8 9f 2c 00 00       	call   3c15 <exit>
  for(i = 0; i < 2; i++){
     f76:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f7a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
     f7e:	0f 8e 1e ff ff ff    	jle    ea2 <twofiles+0x148>
    }
  }

  unlink("f1");
     f84:	83 ec 0c             	sub    $0xc,%esp
     f87:	68 6c 46 00 00       	push   $0x466c
     f8c:	e8 d4 2c 00 00       	call   3c65 <unlink>
     f91:	83 c4 10             	add    $0x10,%esp
  unlink("f2");
     f94:	83 ec 0c             	sub    $0xc,%esp
     f97:	68 6f 46 00 00       	push   $0x466f
     f9c:	e8 c4 2c 00 00       	call   3c65 <unlink>
     fa1:	83 c4 10             	add    $0x10,%esp

  printf(1, "twofiles ok\n");
     fa4:	83 ec 08             	sub    $0x8,%esp
     fa7:	68 af 46 00 00       	push   $0x46af
     fac:	6a 01                	push   $0x1
     fae:	e8 fe 2d 00 00       	call   3db1 <printf>
     fb3:	83 c4 10             	add    $0x10,%esp
}
     fb6:	90                   	nop
     fb7:	c9                   	leave  
     fb8:	c3                   	ret    

00000fb9 <createdelete>:

// two processes create and delete different files in same directory
void
createdelete(void)
{
     fb9:	55                   	push   %ebp
     fba:	89 e5                	mov    %esp,%ebp
     fbc:	83 ec 38             	sub    $0x38,%esp
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
     fbf:	83 ec 08             	sub    $0x8,%esp
     fc2:	68 bc 46 00 00       	push   $0x46bc
     fc7:	6a 01                	push   $0x1
     fc9:	e8 e3 2d 00 00       	call   3db1 <printf>
     fce:	83 c4 10             	add    $0x10,%esp
  pid = fork();
     fd1:	e8 37 2c 00 00       	call   3c0d <fork>
     fd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid < 0){
     fd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fdd:	79 17                	jns    ff6 <createdelete+0x3d>
    printf(1, "fork failed\n");
     fdf:	83 ec 08             	sub    $0x8,%esp
     fe2:	68 55 45 00 00       	push   $0x4555
     fe7:	6a 01                	push   $0x1
     fe9:	e8 c3 2d 00 00       	call   3db1 <printf>
     fee:	83 c4 10             	add    $0x10,%esp
    exit();
     ff1:	e8 1f 2c 00 00       	call   3c15 <exit>
  }

  name[0] = pid ? 'p' : 'c';
     ff6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ffa:	74 07                	je     1003 <createdelete+0x4a>
     ffc:	b8 70 00 00 00       	mov    $0x70,%eax
    1001:	eb 05                	jmp    1008 <createdelete+0x4f>
    1003:	b8 63 00 00 00       	mov    $0x63,%eax
    1008:	88 45 cc             	mov    %al,-0x34(%ebp)
  name[2] = '\0';
    100b:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
  for(i = 0; i < N; i++){
    100f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1016:	e9 9b 00 00 00       	jmp    10b6 <createdelete+0xfd>
    name[1] = '0' + i;
    101b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    101e:	83 c0 30             	add    $0x30,%eax
    1021:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, O_CREATE | O_RDWR);
    1024:	83 ec 08             	sub    $0x8,%esp
    1027:	68 02 02 00 00       	push   $0x202
    102c:	8d 45 cc             	lea    -0x34(%ebp),%eax
    102f:	50                   	push   %eax
    1030:	e8 20 2c 00 00       	call   3c55 <open>
    1035:	83 c4 10             	add    $0x10,%esp
    1038:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    103b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    103f:	79 17                	jns    1058 <createdelete+0x9f>
      printf(1, "create failed\n");
    1041:	83 ec 08             	sub    $0x8,%esp
    1044:	68 72 46 00 00       	push   $0x4672
    1049:	6a 01                	push   $0x1
    104b:	e8 61 2d 00 00       	call   3db1 <printf>
    1050:	83 c4 10             	add    $0x10,%esp
      exit();
    1053:	e8 bd 2b 00 00       	call   3c15 <exit>
    }
    close(fd);
    1058:	83 ec 0c             	sub    $0xc,%esp
    105b:	ff 75 ec             	pushl  -0x14(%ebp)
    105e:	e8 da 2b 00 00       	call   3c3d <close>
    1063:	83 c4 10             	add    $0x10,%esp
    if(i > 0 && (i % 2 ) == 0){
    1066:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    106a:	7e 46                	jle    10b2 <createdelete+0xf9>
    106c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    106f:	83 e0 01             	and    $0x1,%eax
    1072:	85 c0                	test   %eax,%eax
    1074:	75 3c                	jne    10b2 <createdelete+0xf9>
      name[1] = '0' + (i / 2);
    1076:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1079:	89 c2                	mov    %eax,%edx
    107b:	c1 ea 1f             	shr    $0x1f,%edx
    107e:	01 d0                	add    %edx,%eax
    1080:	d1 f8                	sar    %eax
    1082:	83 c0 30             	add    $0x30,%eax
    1085:	88 45 cd             	mov    %al,-0x33(%ebp)
      if(unlink(name) < 0){
    1088:	83 ec 0c             	sub    $0xc,%esp
    108b:	8d 45 cc             	lea    -0x34(%ebp),%eax
    108e:	50                   	push   %eax
    108f:	e8 d1 2b 00 00       	call   3c65 <unlink>
    1094:	83 c4 10             	add    $0x10,%esp
    1097:	85 c0                	test   %eax,%eax
    1099:	79 17                	jns    10b2 <createdelete+0xf9>
        printf(1, "unlink failed\n");
    109b:	83 ec 08             	sub    $0x8,%esp
    109e:	68 cf 46 00 00       	push   $0x46cf
    10a3:	6a 01                	push   $0x1
    10a5:	e8 07 2d 00 00       	call   3db1 <printf>
    10aa:	83 c4 10             	add    $0x10,%esp
        exit();
    10ad:	e8 63 2b 00 00       	call   3c15 <exit>
  for(i = 0; i < N; i++){
    10b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    10b6:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    10ba:	0f 8e 5b ff ff ff    	jle    101b <createdelete+0x62>
      }
    }
  }

  if(pid==0)
    10c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10c4:	75 05                	jne    10cb <createdelete+0x112>
    exit();
    10c6:	e8 4a 2b 00 00       	call   3c15 <exit>
  else
    wait();
    10cb:	e8 4d 2b 00 00       	call   3c1d <wait>

  for(i = 0; i < N; i++){
    10d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10d7:	e9 22 01 00 00       	jmp    11fe <createdelete+0x245>
    name[0] = 'p';
    10dc:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    10e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10e3:	83 c0 30             	add    $0x30,%eax
    10e6:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    10e9:	83 ec 08             	sub    $0x8,%esp
    10ec:	6a 00                	push   $0x0
    10ee:	8d 45 cc             	lea    -0x34(%ebp),%eax
    10f1:	50                   	push   %eax
    10f2:	e8 5e 2b 00 00       	call   3c55 <open>
    10f7:	83 c4 10             	add    $0x10,%esp
    10fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    10fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1101:	74 06                	je     1109 <createdelete+0x150>
    1103:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1107:	7e 21                	jle    112a <createdelete+0x171>
    1109:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    110d:	79 1b                	jns    112a <createdelete+0x171>
      printf(1, "oops createdelete %s didn't exist\n", name);
    110f:	83 ec 04             	sub    $0x4,%esp
    1112:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1115:	50                   	push   %eax
    1116:	68 e0 46 00 00       	push   $0x46e0
    111b:	6a 01                	push   $0x1
    111d:	e8 8f 2c 00 00       	call   3db1 <printf>
    1122:	83 c4 10             	add    $0x10,%esp
      exit();
    1125:	e8 eb 2a 00 00       	call   3c15 <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    112a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    112e:	7e 27                	jle    1157 <createdelete+0x19e>
    1130:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1134:	7f 21                	jg     1157 <createdelete+0x19e>
    1136:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    113a:	78 1b                	js     1157 <createdelete+0x19e>
      printf(1, "oops createdelete %s did exist\n", name);
    113c:	83 ec 04             	sub    $0x4,%esp
    113f:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1142:	50                   	push   %eax
    1143:	68 04 47 00 00       	push   $0x4704
    1148:	6a 01                	push   $0x1
    114a:	e8 62 2c 00 00       	call   3db1 <printf>
    114f:	83 c4 10             	add    $0x10,%esp
      exit();
    1152:	e8 be 2a 00 00       	call   3c15 <exit>
    }
    if(fd >= 0)
    1157:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    115b:	78 0e                	js     116b <createdelete+0x1b2>
      close(fd);
    115d:	83 ec 0c             	sub    $0xc,%esp
    1160:	ff 75 ec             	pushl  -0x14(%ebp)
    1163:	e8 d5 2a 00 00       	call   3c3d <close>
    1168:	83 c4 10             	add    $0x10,%esp

    name[0] = 'c';
    116b:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    name[1] = '0' + i;
    116f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1172:	83 c0 30             	add    $0x30,%eax
    1175:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    1178:	83 ec 08             	sub    $0x8,%esp
    117b:	6a 00                	push   $0x0
    117d:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1180:	50                   	push   %eax
    1181:	e8 cf 2a 00 00       	call   3c55 <open>
    1186:	83 c4 10             	add    $0x10,%esp
    1189:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    118c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1190:	74 06                	je     1198 <createdelete+0x1df>
    1192:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1196:	7e 21                	jle    11b9 <createdelete+0x200>
    1198:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    119c:	79 1b                	jns    11b9 <createdelete+0x200>
      printf(1, "oops createdelete %s didn't exist\n", name);
    119e:	83 ec 04             	sub    $0x4,%esp
    11a1:	8d 45 cc             	lea    -0x34(%ebp),%eax
    11a4:	50                   	push   %eax
    11a5:	68 e0 46 00 00       	push   $0x46e0
    11aa:	6a 01                	push   $0x1
    11ac:	e8 00 2c 00 00       	call   3db1 <printf>
    11b1:	83 c4 10             	add    $0x10,%esp
      exit();
    11b4:	e8 5c 2a 00 00       	call   3c15 <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    11b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11bd:	7e 27                	jle    11e6 <createdelete+0x22d>
    11bf:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    11c3:	7f 21                	jg     11e6 <createdelete+0x22d>
    11c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    11c9:	78 1b                	js     11e6 <createdelete+0x22d>
      printf(1, "oops createdelete %s did exist\n", name);
    11cb:	83 ec 04             	sub    $0x4,%esp
    11ce:	8d 45 cc             	lea    -0x34(%ebp),%eax
    11d1:	50                   	push   %eax
    11d2:	68 04 47 00 00       	push   $0x4704
    11d7:	6a 01                	push   $0x1
    11d9:	e8 d3 2b 00 00       	call   3db1 <printf>
    11de:	83 c4 10             	add    $0x10,%esp
      exit();
    11e1:	e8 2f 2a 00 00       	call   3c15 <exit>
    }
    if(fd >= 0)
    11e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    11ea:	78 0e                	js     11fa <createdelete+0x241>
      close(fd);
    11ec:	83 ec 0c             	sub    $0xc,%esp
    11ef:	ff 75 ec             	pushl  -0x14(%ebp)
    11f2:	e8 46 2a 00 00       	call   3c3d <close>
    11f7:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < N; i++){
    11fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    11fe:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1202:	0f 8e d4 fe ff ff    	jle    10dc <createdelete+0x123>
  }

  for(i = 0; i < N; i++){
    1208:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    120f:	eb 33                	jmp    1244 <createdelete+0x28b>
    name[0] = 'p';
    1211:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    1215:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1218:	83 c0 30             	add    $0x30,%eax
    121b:	88 45 cd             	mov    %al,-0x33(%ebp)
    unlink(name);
    121e:	83 ec 0c             	sub    $0xc,%esp
    1221:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1224:	50                   	push   %eax
    1225:	e8 3b 2a 00 00       	call   3c65 <unlink>
    122a:	83 c4 10             	add    $0x10,%esp
    name[0] = 'c';
    122d:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    unlink(name);
    1231:	83 ec 0c             	sub    $0xc,%esp
    1234:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1237:	50                   	push   %eax
    1238:	e8 28 2a 00 00       	call   3c65 <unlink>
    123d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < N; i++){
    1240:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1244:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1248:	7e c7                	jle    1211 <createdelete+0x258>
  }

  printf(1, "createdelete ok\n");
    124a:	83 ec 08             	sub    $0x8,%esp
    124d:	68 24 47 00 00       	push   $0x4724
    1252:	6a 01                	push   $0x1
    1254:	e8 58 2b 00 00       	call   3db1 <printf>
    1259:	83 c4 10             	add    $0x10,%esp
}
    125c:	90                   	nop
    125d:	c9                   	leave  
    125e:	c3                   	ret    

0000125f <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    125f:	55                   	push   %ebp
    1260:	89 e5                	mov    %esp,%ebp
    1262:	83 ec 18             	sub    $0x18,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1265:	83 ec 08             	sub    $0x8,%esp
    1268:	68 35 47 00 00       	push   $0x4735
    126d:	6a 01                	push   $0x1
    126f:	e8 3d 2b 00 00       	call   3db1 <printf>
    1274:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1277:	83 ec 08             	sub    $0x8,%esp
    127a:	68 02 02 00 00       	push   $0x202
    127f:	68 46 47 00 00       	push   $0x4746
    1284:	e8 cc 29 00 00       	call   3c55 <open>
    1289:	83 c4 10             	add    $0x10,%esp
    128c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    128f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1293:	79 17                	jns    12ac <unlinkread+0x4d>
    printf(1, "create unlinkread failed\n");
    1295:	83 ec 08             	sub    $0x8,%esp
    1298:	68 51 47 00 00       	push   $0x4751
    129d:	6a 01                	push   $0x1
    129f:	e8 0d 2b 00 00       	call   3db1 <printf>
    12a4:	83 c4 10             	add    $0x10,%esp
    exit();
    12a7:	e8 69 29 00 00       	call   3c15 <exit>
  }
  write(fd, "hello", 5);
    12ac:	83 ec 04             	sub    $0x4,%esp
    12af:	6a 05                	push   $0x5
    12b1:	68 6b 47 00 00       	push   $0x476b
    12b6:	ff 75 f4             	pushl  -0xc(%ebp)
    12b9:	e8 77 29 00 00       	call   3c35 <write>
    12be:	83 c4 10             	add    $0x10,%esp
  close(fd);
    12c1:	83 ec 0c             	sub    $0xc,%esp
    12c4:	ff 75 f4             	pushl  -0xc(%ebp)
    12c7:	e8 71 29 00 00       	call   3c3d <close>
    12cc:	83 c4 10             	add    $0x10,%esp

  fd = open("unlinkread", O_RDWR);
    12cf:	83 ec 08             	sub    $0x8,%esp
    12d2:	6a 02                	push   $0x2
    12d4:	68 46 47 00 00       	push   $0x4746
    12d9:	e8 77 29 00 00       	call   3c55 <open>
    12de:	83 c4 10             	add    $0x10,%esp
    12e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    12e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12e8:	79 17                	jns    1301 <unlinkread+0xa2>
    printf(1, "open unlinkread failed\n");
    12ea:	83 ec 08             	sub    $0x8,%esp
    12ed:	68 71 47 00 00       	push   $0x4771
    12f2:	6a 01                	push   $0x1
    12f4:	e8 b8 2a 00 00       	call   3db1 <printf>
    12f9:	83 c4 10             	add    $0x10,%esp
    exit();
    12fc:	e8 14 29 00 00       	call   3c15 <exit>
  }
  if(unlink("unlinkread") != 0){
    1301:	83 ec 0c             	sub    $0xc,%esp
    1304:	68 46 47 00 00       	push   $0x4746
    1309:	e8 57 29 00 00       	call   3c65 <unlink>
    130e:	83 c4 10             	add    $0x10,%esp
    1311:	85 c0                	test   %eax,%eax
    1313:	74 17                	je     132c <unlinkread+0xcd>
    printf(1, "unlink unlinkread failed\n");
    1315:	83 ec 08             	sub    $0x8,%esp
    1318:	68 89 47 00 00       	push   $0x4789
    131d:	6a 01                	push   $0x1
    131f:	e8 8d 2a 00 00       	call   3db1 <printf>
    1324:	83 c4 10             	add    $0x10,%esp
    exit();
    1327:	e8 e9 28 00 00       	call   3c15 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    132c:	83 ec 08             	sub    $0x8,%esp
    132f:	68 02 02 00 00       	push   $0x202
    1334:	68 46 47 00 00       	push   $0x4746
    1339:	e8 17 29 00 00       	call   3c55 <open>
    133e:	83 c4 10             	add    $0x10,%esp
    1341:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    1344:	83 ec 04             	sub    $0x4,%esp
    1347:	6a 03                	push   $0x3
    1349:	68 a3 47 00 00       	push   $0x47a3
    134e:	ff 75 f0             	pushl  -0x10(%ebp)
    1351:	e8 df 28 00 00       	call   3c35 <write>
    1356:	83 c4 10             	add    $0x10,%esp
  close(fd1);
    1359:	83 ec 0c             	sub    $0xc,%esp
    135c:	ff 75 f0             	pushl  -0x10(%ebp)
    135f:	e8 d9 28 00 00       	call   3c3d <close>
    1364:	83 c4 10             	add    $0x10,%esp

  if(read(fd, buf, sizeof(buf)) != 5){
    1367:	83 ec 04             	sub    $0x4,%esp
    136a:	68 00 20 00 00       	push   $0x2000
    136f:	68 e0 5e 00 00       	push   $0x5ee0
    1374:	ff 75 f4             	pushl  -0xc(%ebp)
    1377:	e8 b1 28 00 00       	call   3c2d <read>
    137c:	83 c4 10             	add    $0x10,%esp
    137f:	83 f8 05             	cmp    $0x5,%eax
    1382:	74 17                	je     139b <unlinkread+0x13c>
    printf(1, "unlinkread read failed");
    1384:	83 ec 08             	sub    $0x8,%esp
    1387:	68 a7 47 00 00       	push   $0x47a7
    138c:	6a 01                	push   $0x1
    138e:	e8 1e 2a 00 00       	call   3db1 <printf>
    1393:	83 c4 10             	add    $0x10,%esp
    exit();
    1396:	e8 7a 28 00 00       	call   3c15 <exit>
  }
  if(buf[0] != 'h'){
    139b:	0f b6 05 e0 5e 00 00 	movzbl 0x5ee0,%eax
    13a2:	3c 68                	cmp    $0x68,%al
    13a4:	74 17                	je     13bd <unlinkread+0x15e>
    printf(1, "unlinkread wrong data\n");
    13a6:	83 ec 08             	sub    $0x8,%esp
    13a9:	68 be 47 00 00       	push   $0x47be
    13ae:	6a 01                	push   $0x1
    13b0:	e8 fc 29 00 00       	call   3db1 <printf>
    13b5:	83 c4 10             	add    $0x10,%esp
    exit();
    13b8:	e8 58 28 00 00       	call   3c15 <exit>
  }
  if(write(fd, buf, 10) != 10){
    13bd:	83 ec 04             	sub    $0x4,%esp
    13c0:	6a 0a                	push   $0xa
    13c2:	68 e0 5e 00 00       	push   $0x5ee0
    13c7:	ff 75 f4             	pushl  -0xc(%ebp)
    13ca:	e8 66 28 00 00       	call   3c35 <write>
    13cf:	83 c4 10             	add    $0x10,%esp
    13d2:	83 f8 0a             	cmp    $0xa,%eax
    13d5:	74 17                	je     13ee <unlinkread+0x18f>
    printf(1, "unlinkread write failed\n");
    13d7:	83 ec 08             	sub    $0x8,%esp
    13da:	68 d5 47 00 00       	push   $0x47d5
    13df:	6a 01                	push   $0x1
    13e1:	e8 cb 29 00 00       	call   3db1 <printf>
    13e6:	83 c4 10             	add    $0x10,%esp
    exit();
    13e9:	e8 27 28 00 00       	call   3c15 <exit>
  }
  close(fd);
    13ee:	83 ec 0c             	sub    $0xc,%esp
    13f1:	ff 75 f4             	pushl  -0xc(%ebp)
    13f4:	e8 44 28 00 00       	call   3c3d <close>
    13f9:	83 c4 10             	add    $0x10,%esp
  unlink("unlinkread");
    13fc:	83 ec 0c             	sub    $0xc,%esp
    13ff:	68 46 47 00 00       	push   $0x4746
    1404:	e8 5c 28 00 00       	call   3c65 <unlink>
    1409:	83 c4 10             	add    $0x10,%esp
  printf(1, "unlinkread ok\n");
    140c:	83 ec 08             	sub    $0x8,%esp
    140f:	68 ee 47 00 00       	push   $0x47ee
    1414:	6a 01                	push   $0x1
    1416:	e8 96 29 00 00       	call   3db1 <printf>
    141b:	83 c4 10             	add    $0x10,%esp
}
    141e:	90                   	nop
    141f:	c9                   	leave  
    1420:	c3                   	ret    

00001421 <linktest>:

void
linktest(void)
{
    1421:	55                   	push   %ebp
    1422:	89 e5                	mov    %esp,%ebp
    1424:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "linktest\n");
    1427:	83 ec 08             	sub    $0x8,%esp
    142a:	68 fd 47 00 00       	push   $0x47fd
    142f:	6a 01                	push   $0x1
    1431:	e8 7b 29 00 00       	call   3db1 <printf>
    1436:	83 c4 10             	add    $0x10,%esp

  unlink("lf1");
    1439:	83 ec 0c             	sub    $0xc,%esp
    143c:	68 07 48 00 00       	push   $0x4807
    1441:	e8 1f 28 00 00       	call   3c65 <unlink>
    1446:	83 c4 10             	add    $0x10,%esp
  unlink("lf2");
    1449:	83 ec 0c             	sub    $0xc,%esp
    144c:	68 0b 48 00 00       	push   $0x480b
    1451:	e8 0f 28 00 00       	call   3c65 <unlink>
    1456:	83 c4 10             	add    $0x10,%esp

  fd = open("lf1", O_CREATE|O_RDWR);
    1459:	83 ec 08             	sub    $0x8,%esp
    145c:	68 02 02 00 00       	push   $0x202
    1461:	68 07 48 00 00       	push   $0x4807
    1466:	e8 ea 27 00 00       	call   3c55 <open>
    146b:	83 c4 10             	add    $0x10,%esp
    146e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1475:	79 17                	jns    148e <linktest+0x6d>
    printf(1, "create lf1 failed\n");
    1477:	83 ec 08             	sub    $0x8,%esp
    147a:	68 0f 48 00 00       	push   $0x480f
    147f:	6a 01                	push   $0x1
    1481:	e8 2b 29 00 00       	call   3db1 <printf>
    1486:	83 c4 10             	add    $0x10,%esp
    exit();
    1489:	e8 87 27 00 00       	call   3c15 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    148e:	83 ec 04             	sub    $0x4,%esp
    1491:	6a 05                	push   $0x5
    1493:	68 6b 47 00 00       	push   $0x476b
    1498:	ff 75 f4             	pushl  -0xc(%ebp)
    149b:	e8 95 27 00 00       	call   3c35 <write>
    14a0:	83 c4 10             	add    $0x10,%esp
    14a3:	83 f8 05             	cmp    $0x5,%eax
    14a6:	74 17                	je     14bf <linktest+0x9e>
    printf(1, "write lf1 failed\n");
    14a8:	83 ec 08             	sub    $0x8,%esp
    14ab:	68 22 48 00 00       	push   $0x4822
    14b0:	6a 01                	push   $0x1
    14b2:	e8 fa 28 00 00       	call   3db1 <printf>
    14b7:	83 c4 10             	add    $0x10,%esp
    exit();
    14ba:	e8 56 27 00 00       	call   3c15 <exit>
  }
  close(fd);
    14bf:	83 ec 0c             	sub    $0xc,%esp
    14c2:	ff 75 f4             	pushl  -0xc(%ebp)
    14c5:	e8 73 27 00 00       	call   3c3d <close>
    14ca:	83 c4 10             	add    $0x10,%esp

  if(link("lf1", "lf2") < 0){
    14cd:	83 ec 08             	sub    $0x8,%esp
    14d0:	68 0b 48 00 00       	push   $0x480b
    14d5:	68 07 48 00 00       	push   $0x4807
    14da:	e8 96 27 00 00       	call   3c75 <link>
    14df:	83 c4 10             	add    $0x10,%esp
    14e2:	85 c0                	test   %eax,%eax
    14e4:	79 17                	jns    14fd <linktest+0xdc>
    printf(1, "link lf1 lf2 failed\n");
    14e6:	83 ec 08             	sub    $0x8,%esp
    14e9:	68 34 48 00 00       	push   $0x4834
    14ee:	6a 01                	push   $0x1
    14f0:	e8 bc 28 00 00       	call   3db1 <printf>
    14f5:	83 c4 10             	add    $0x10,%esp
    exit();
    14f8:	e8 18 27 00 00       	call   3c15 <exit>
  }
  unlink("lf1");
    14fd:	83 ec 0c             	sub    $0xc,%esp
    1500:	68 07 48 00 00       	push   $0x4807
    1505:	e8 5b 27 00 00       	call   3c65 <unlink>
    150a:	83 c4 10             	add    $0x10,%esp

  if(open("lf1", 0) >= 0){
    150d:	83 ec 08             	sub    $0x8,%esp
    1510:	6a 00                	push   $0x0
    1512:	68 07 48 00 00       	push   $0x4807
    1517:	e8 39 27 00 00       	call   3c55 <open>
    151c:	83 c4 10             	add    $0x10,%esp
    151f:	85 c0                	test   %eax,%eax
    1521:	78 17                	js     153a <linktest+0x119>
    printf(1, "unlinked lf1 but it is still there!\n");
    1523:	83 ec 08             	sub    $0x8,%esp
    1526:	68 4c 48 00 00       	push   $0x484c
    152b:	6a 01                	push   $0x1
    152d:	e8 7f 28 00 00       	call   3db1 <printf>
    1532:	83 c4 10             	add    $0x10,%esp
    exit();
    1535:	e8 db 26 00 00       	call   3c15 <exit>
  }

  fd = open("lf2", 0);
    153a:	83 ec 08             	sub    $0x8,%esp
    153d:	6a 00                	push   $0x0
    153f:	68 0b 48 00 00       	push   $0x480b
    1544:	e8 0c 27 00 00       	call   3c55 <open>
    1549:	83 c4 10             	add    $0x10,%esp
    154c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    154f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1553:	79 17                	jns    156c <linktest+0x14b>
    printf(1, "open lf2 failed\n");
    1555:	83 ec 08             	sub    $0x8,%esp
    1558:	68 71 48 00 00       	push   $0x4871
    155d:	6a 01                	push   $0x1
    155f:	e8 4d 28 00 00       	call   3db1 <printf>
    1564:	83 c4 10             	add    $0x10,%esp
    exit();
    1567:	e8 a9 26 00 00       	call   3c15 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    156c:	83 ec 04             	sub    $0x4,%esp
    156f:	68 00 20 00 00       	push   $0x2000
    1574:	68 e0 5e 00 00       	push   $0x5ee0
    1579:	ff 75 f4             	pushl  -0xc(%ebp)
    157c:	e8 ac 26 00 00       	call   3c2d <read>
    1581:	83 c4 10             	add    $0x10,%esp
    1584:	83 f8 05             	cmp    $0x5,%eax
    1587:	74 17                	je     15a0 <linktest+0x17f>
    printf(1, "read lf2 failed\n");
    1589:	83 ec 08             	sub    $0x8,%esp
    158c:	68 82 48 00 00       	push   $0x4882
    1591:	6a 01                	push   $0x1
    1593:	e8 19 28 00 00       	call   3db1 <printf>
    1598:	83 c4 10             	add    $0x10,%esp
    exit();
    159b:	e8 75 26 00 00       	call   3c15 <exit>
  }
  close(fd);
    15a0:	83 ec 0c             	sub    $0xc,%esp
    15a3:	ff 75 f4             	pushl  -0xc(%ebp)
    15a6:	e8 92 26 00 00       	call   3c3d <close>
    15ab:	83 c4 10             	add    $0x10,%esp

  if(link("lf2", "lf2") >= 0){
    15ae:	83 ec 08             	sub    $0x8,%esp
    15b1:	68 0b 48 00 00       	push   $0x480b
    15b6:	68 0b 48 00 00       	push   $0x480b
    15bb:	e8 b5 26 00 00       	call   3c75 <link>
    15c0:	83 c4 10             	add    $0x10,%esp
    15c3:	85 c0                	test   %eax,%eax
    15c5:	78 17                	js     15de <linktest+0x1bd>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    15c7:	83 ec 08             	sub    $0x8,%esp
    15ca:	68 93 48 00 00       	push   $0x4893
    15cf:	6a 01                	push   $0x1
    15d1:	e8 db 27 00 00       	call   3db1 <printf>
    15d6:	83 c4 10             	add    $0x10,%esp
    exit();
    15d9:	e8 37 26 00 00       	call   3c15 <exit>
  }

  unlink("lf2");
    15de:	83 ec 0c             	sub    $0xc,%esp
    15e1:	68 0b 48 00 00       	push   $0x480b
    15e6:	e8 7a 26 00 00       	call   3c65 <unlink>
    15eb:	83 c4 10             	add    $0x10,%esp
  if(link("lf2", "lf1") >= 0){
    15ee:	83 ec 08             	sub    $0x8,%esp
    15f1:	68 07 48 00 00       	push   $0x4807
    15f6:	68 0b 48 00 00       	push   $0x480b
    15fb:	e8 75 26 00 00       	call   3c75 <link>
    1600:	83 c4 10             	add    $0x10,%esp
    1603:	85 c0                	test   %eax,%eax
    1605:	78 17                	js     161e <linktest+0x1fd>
    printf(1, "link non-existant succeeded! oops\n");
    1607:	83 ec 08             	sub    $0x8,%esp
    160a:	68 b4 48 00 00       	push   $0x48b4
    160f:	6a 01                	push   $0x1
    1611:	e8 9b 27 00 00       	call   3db1 <printf>
    1616:	83 c4 10             	add    $0x10,%esp
    exit();
    1619:	e8 f7 25 00 00       	call   3c15 <exit>
  }

  if(link(".", "lf1") >= 0){
    161e:	83 ec 08             	sub    $0x8,%esp
    1621:	68 07 48 00 00       	push   $0x4807
    1626:	68 d7 48 00 00       	push   $0x48d7
    162b:	e8 45 26 00 00       	call   3c75 <link>
    1630:	83 c4 10             	add    $0x10,%esp
    1633:	85 c0                	test   %eax,%eax
    1635:	78 17                	js     164e <linktest+0x22d>
    printf(1, "link . lf1 succeeded! oops\n");
    1637:	83 ec 08             	sub    $0x8,%esp
    163a:	68 d9 48 00 00       	push   $0x48d9
    163f:	6a 01                	push   $0x1
    1641:	e8 6b 27 00 00       	call   3db1 <printf>
    1646:	83 c4 10             	add    $0x10,%esp
    exit();
    1649:	e8 c7 25 00 00       	call   3c15 <exit>
  }

  printf(1, "linktest ok\n");
    164e:	83 ec 08             	sub    $0x8,%esp
    1651:	68 f5 48 00 00       	push   $0x48f5
    1656:	6a 01                	push   $0x1
    1658:	e8 54 27 00 00       	call   3db1 <printf>
    165d:	83 c4 10             	add    $0x10,%esp
}
    1660:	90                   	nop
    1661:	c9                   	leave  
    1662:	c3                   	ret    

00001663 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1663:	55                   	push   %ebp
    1664:	89 e5                	mov    %esp,%ebp
    1666:	53                   	push   %ebx
    1667:	83 ec 54             	sub    $0x54,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    166a:	83 ec 08             	sub    $0x8,%esp
    166d:	68 02 49 00 00       	push   $0x4902
    1672:	6a 01                	push   $0x1
    1674:	e8 38 27 00 00       	call   3db1 <printf>
    1679:	83 c4 10             	add    $0x10,%esp
  file[0] = 'C';
    167c:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1680:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    168b:	e9 00 01 00 00       	jmp    1790 <concreate+0x12d>
    file[1] = '0' + i;
    1690:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1693:	83 c0 30             	add    $0x30,%eax
    1696:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1699:	83 ec 0c             	sub    $0xc,%esp
    169c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    169f:	50                   	push   %eax
    16a0:	e8 c0 25 00 00       	call   3c65 <unlink>
    16a5:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    16a8:	e8 60 25 00 00       	call   3c0d <fork>
    16ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid && (i % 3) == 1){
    16b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    16b4:	74 3d                	je     16f3 <concreate+0x90>
    16b6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16b9:	ba 56 55 55 55       	mov    $0x55555556,%edx
    16be:	89 c8                	mov    %ecx,%eax
    16c0:	f7 ea                	imul   %edx
    16c2:	89 cb                	mov    %ecx,%ebx
    16c4:	c1 fb 1f             	sar    $0x1f,%ebx
    16c7:	89 d0                	mov    %edx,%eax
    16c9:	29 d8                	sub    %ebx,%eax
    16cb:	89 c2                	mov    %eax,%edx
    16cd:	01 d2                	add    %edx,%edx
    16cf:	01 c2                	add    %eax,%edx
    16d1:	89 c8                	mov    %ecx,%eax
    16d3:	29 d0                	sub    %edx,%eax
    16d5:	83 f8 01             	cmp    $0x1,%eax
    16d8:	75 19                	jne    16f3 <concreate+0x90>
      link("C0", file);
    16da:	83 ec 08             	sub    $0x8,%esp
    16dd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16e0:	50                   	push   %eax
    16e1:	68 12 49 00 00       	push   $0x4912
    16e6:	e8 8a 25 00 00       	call   3c75 <link>
    16eb:	83 c4 10             	add    $0x10,%esp
    16ee:	e9 89 00 00 00       	jmp    177c <concreate+0x119>
    } else if(pid == 0 && (i % 5) == 1){
    16f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    16f7:	75 3d                	jne    1736 <concreate+0xd3>
    16f9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16fc:	ba 67 66 66 66       	mov    $0x66666667,%edx
    1701:	89 c8                	mov    %ecx,%eax
    1703:	f7 ea                	imul   %edx
    1705:	89 d0                	mov    %edx,%eax
    1707:	d1 f8                	sar    %eax
    1709:	89 ca                	mov    %ecx,%edx
    170b:	c1 fa 1f             	sar    $0x1f,%edx
    170e:	29 d0                	sub    %edx,%eax
    1710:	89 c2                	mov    %eax,%edx
    1712:	c1 e2 02             	shl    $0x2,%edx
    1715:	01 c2                	add    %eax,%edx
    1717:	89 c8                	mov    %ecx,%eax
    1719:	29 d0                	sub    %edx,%eax
    171b:	83 f8 01             	cmp    $0x1,%eax
    171e:	75 16                	jne    1736 <concreate+0xd3>
      link("C0", file);
    1720:	83 ec 08             	sub    $0x8,%esp
    1723:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1726:	50                   	push   %eax
    1727:	68 12 49 00 00       	push   $0x4912
    172c:	e8 44 25 00 00       	call   3c75 <link>
    1731:	83 c4 10             	add    $0x10,%esp
    1734:	eb 46                	jmp    177c <concreate+0x119>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1736:	83 ec 08             	sub    $0x8,%esp
    1739:	68 02 02 00 00       	push   $0x202
    173e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1741:	50                   	push   %eax
    1742:	e8 0e 25 00 00       	call   3c55 <open>
    1747:	83 c4 10             	add    $0x10,%esp
    174a:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(fd < 0){
    174d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1751:	79 1b                	jns    176e <concreate+0x10b>
        printf(1, "concreate create %s failed\n", file);
    1753:	83 ec 04             	sub    $0x4,%esp
    1756:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1759:	50                   	push   %eax
    175a:	68 15 49 00 00       	push   $0x4915
    175f:	6a 01                	push   $0x1
    1761:	e8 4b 26 00 00       	call   3db1 <printf>
    1766:	83 c4 10             	add    $0x10,%esp
        exit();
    1769:	e8 a7 24 00 00       	call   3c15 <exit>
      }
      close(fd);
    176e:	83 ec 0c             	sub    $0xc,%esp
    1771:	ff 75 ec             	pushl  -0x14(%ebp)
    1774:	e8 c4 24 00 00       	call   3c3d <close>
    1779:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    177c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1780:	75 05                	jne    1787 <concreate+0x124>
      exit();
    1782:	e8 8e 24 00 00       	call   3c15 <exit>
    else
      wait();
    1787:	e8 91 24 00 00       	call   3c1d <wait>
  for(i = 0; i < 40; i++){
    178c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1790:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1794:	0f 8e f6 fe ff ff    	jle    1690 <concreate+0x2d>
  }

  memset(fa, 0, sizeof(fa));
    179a:	83 ec 04             	sub    $0x4,%esp
    179d:	6a 28                	push   $0x28
    179f:	6a 00                	push   $0x0
    17a1:	8d 45 bd             	lea    -0x43(%ebp),%eax
    17a4:	50                   	push   %eax
    17a5:	e8 d0 22 00 00       	call   3a7a <memset>
    17aa:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    17ad:	83 ec 08             	sub    $0x8,%esp
    17b0:	6a 00                	push   $0x0
    17b2:	68 d7 48 00 00       	push   $0x48d7
    17b7:	e8 99 24 00 00       	call   3c55 <open>
    17bc:	83 c4 10             	add    $0x10,%esp
    17bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  n = 0;
    17c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    17c9:	e9 93 00 00 00       	jmp    1861 <concreate+0x1fe>
    if(de.inum == 0)
    17ce:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    17d2:	66 85 c0             	test   %ax,%ax
    17d5:	75 05                	jne    17dc <concreate+0x179>
      continue;
    17d7:	e9 85 00 00 00       	jmp    1861 <concreate+0x1fe>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    17dc:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    17e0:	3c 43                	cmp    $0x43,%al
    17e2:	75 7d                	jne    1861 <concreate+0x1fe>
    17e4:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    17e8:	84 c0                	test   %al,%al
    17ea:	75 75                	jne    1861 <concreate+0x1fe>
      i = de.name[1] - '0';
    17ec:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    17f0:	0f be c0             	movsbl %al,%eax
    17f3:	83 e8 30             	sub    $0x30,%eax
    17f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    17f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17fd:	78 08                	js     1807 <concreate+0x1a4>
    17ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1802:	83 f8 27             	cmp    $0x27,%eax
    1805:	76 1e                	jbe    1825 <concreate+0x1c2>
        printf(1, "concreate weird file %s\n", de.name);
    1807:	83 ec 04             	sub    $0x4,%esp
    180a:	8d 45 ac             	lea    -0x54(%ebp),%eax
    180d:	83 c0 02             	add    $0x2,%eax
    1810:	50                   	push   %eax
    1811:	68 31 49 00 00       	push   $0x4931
    1816:	6a 01                	push   $0x1
    1818:	e8 94 25 00 00       	call   3db1 <printf>
    181d:	83 c4 10             	add    $0x10,%esp
        exit();
    1820:	e8 f0 23 00 00       	call   3c15 <exit>
      }
      if(fa[i]){
    1825:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1828:	8b 45 f4             	mov    -0xc(%ebp),%eax
    182b:	01 d0                	add    %edx,%eax
    182d:	0f b6 00             	movzbl (%eax),%eax
    1830:	84 c0                	test   %al,%al
    1832:	74 1e                	je     1852 <concreate+0x1ef>
        printf(1, "concreate duplicate file %s\n", de.name);
    1834:	83 ec 04             	sub    $0x4,%esp
    1837:	8d 45 ac             	lea    -0x54(%ebp),%eax
    183a:	83 c0 02             	add    $0x2,%eax
    183d:	50                   	push   %eax
    183e:	68 4a 49 00 00       	push   $0x494a
    1843:	6a 01                	push   $0x1
    1845:	e8 67 25 00 00       	call   3db1 <printf>
    184a:	83 c4 10             	add    $0x10,%esp
        exit();
    184d:	e8 c3 23 00 00       	call   3c15 <exit>
      }
      fa[i] = 1;
    1852:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1855:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1858:	01 d0                	add    %edx,%eax
    185a:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    185d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1861:	83 ec 04             	sub    $0x4,%esp
    1864:	6a 10                	push   $0x10
    1866:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1869:	50                   	push   %eax
    186a:	ff 75 ec             	pushl  -0x14(%ebp)
    186d:	e8 bb 23 00 00       	call   3c2d <read>
    1872:	83 c4 10             	add    $0x10,%esp
    1875:	85 c0                	test   %eax,%eax
    1877:	0f 8f 51 ff ff ff    	jg     17ce <concreate+0x16b>
    }
  }
  close(fd);
    187d:	83 ec 0c             	sub    $0xc,%esp
    1880:	ff 75 ec             	pushl  -0x14(%ebp)
    1883:	e8 b5 23 00 00       	call   3c3d <close>
    1888:	83 c4 10             	add    $0x10,%esp

  if(n != 40){
    188b:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    188f:	74 17                	je     18a8 <concreate+0x245>
    printf(1, "concreate not enough files in directory listing\n");
    1891:	83 ec 08             	sub    $0x8,%esp
    1894:	68 68 49 00 00       	push   $0x4968
    1899:	6a 01                	push   $0x1
    189b:	e8 11 25 00 00       	call   3db1 <printf>
    18a0:	83 c4 10             	add    $0x10,%esp
    exit();
    18a3:	e8 6d 23 00 00       	call   3c15 <exit>
  }

  for(i = 0; i < 40; i++){
    18a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    18af:	e9 47 01 00 00       	jmp    19fb <concreate+0x398>
    file[1] = '0' + i;
    18b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b7:	83 c0 30             	add    $0x30,%eax
    18ba:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    18bd:	e8 4b 23 00 00       	call   3c0d <fork>
    18c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    18c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    18c9:	79 17                	jns    18e2 <concreate+0x27f>
      printf(1, "fork failed\n");
    18cb:	83 ec 08             	sub    $0x8,%esp
    18ce:	68 55 45 00 00       	push   $0x4555
    18d3:	6a 01                	push   $0x1
    18d5:	e8 d7 24 00 00       	call   3db1 <printf>
    18da:	83 c4 10             	add    $0x10,%esp
      exit();
    18dd:	e8 33 23 00 00       	call   3c15 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    18e2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    18e5:	ba 56 55 55 55       	mov    $0x55555556,%edx
    18ea:	89 c8                	mov    %ecx,%eax
    18ec:	f7 ea                	imul   %edx
    18ee:	89 cb                	mov    %ecx,%ebx
    18f0:	c1 fb 1f             	sar    $0x1f,%ebx
    18f3:	89 d0                	mov    %edx,%eax
    18f5:	29 d8                	sub    %ebx,%eax
    18f7:	89 c2                	mov    %eax,%edx
    18f9:	01 d2                	add    %edx,%edx
    18fb:	01 c2                	add    %eax,%edx
    18fd:	89 c8                	mov    %ecx,%eax
    18ff:	29 d0                	sub    %edx,%eax
    1901:	85 c0                	test   %eax,%eax
    1903:	75 06                	jne    190b <concreate+0x2a8>
    1905:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1909:	74 2a                	je     1935 <concreate+0x2d2>
       ((i % 3) == 1 && pid != 0)){
    190b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    190e:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1913:	89 c8                	mov    %ecx,%eax
    1915:	f7 ea                	imul   %edx
    1917:	89 cb                	mov    %ecx,%ebx
    1919:	c1 fb 1f             	sar    $0x1f,%ebx
    191c:	89 d0                	mov    %edx,%eax
    191e:	29 d8                	sub    %ebx,%eax
    1920:	89 c2                	mov    %eax,%edx
    1922:	01 d2                	add    %edx,%edx
    1924:	01 c2                	add    %eax,%edx
    1926:	89 c8                	mov    %ecx,%eax
    1928:	29 d0                	sub    %edx,%eax
    if(((i % 3) == 0 && pid == 0) ||
    192a:	83 f8 01             	cmp    $0x1,%eax
    192d:	75 7c                	jne    19ab <concreate+0x348>
       ((i % 3) == 1 && pid != 0)){
    192f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1933:	74 76                	je     19ab <concreate+0x348>
      close(open(file, 0));
    1935:	83 ec 08             	sub    $0x8,%esp
    1938:	6a 00                	push   $0x0
    193a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    193d:	50                   	push   %eax
    193e:	e8 12 23 00 00       	call   3c55 <open>
    1943:	83 c4 10             	add    $0x10,%esp
    1946:	83 ec 0c             	sub    $0xc,%esp
    1949:	50                   	push   %eax
    194a:	e8 ee 22 00 00       	call   3c3d <close>
    194f:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1952:	83 ec 08             	sub    $0x8,%esp
    1955:	6a 00                	push   $0x0
    1957:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    195a:	50                   	push   %eax
    195b:	e8 f5 22 00 00       	call   3c55 <open>
    1960:	83 c4 10             	add    $0x10,%esp
    1963:	83 ec 0c             	sub    $0xc,%esp
    1966:	50                   	push   %eax
    1967:	e8 d1 22 00 00       	call   3c3d <close>
    196c:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    196f:	83 ec 08             	sub    $0x8,%esp
    1972:	6a 00                	push   $0x0
    1974:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1977:	50                   	push   %eax
    1978:	e8 d8 22 00 00       	call   3c55 <open>
    197d:	83 c4 10             	add    $0x10,%esp
    1980:	83 ec 0c             	sub    $0xc,%esp
    1983:	50                   	push   %eax
    1984:	e8 b4 22 00 00       	call   3c3d <close>
    1989:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    198c:	83 ec 08             	sub    $0x8,%esp
    198f:	6a 00                	push   $0x0
    1991:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1994:	50                   	push   %eax
    1995:	e8 bb 22 00 00       	call   3c55 <open>
    199a:	83 c4 10             	add    $0x10,%esp
    199d:	83 ec 0c             	sub    $0xc,%esp
    19a0:	50                   	push   %eax
    19a1:	e8 97 22 00 00       	call   3c3d <close>
    19a6:	83 c4 10             	add    $0x10,%esp
    19a9:	eb 3c                	jmp    19e7 <concreate+0x384>
    } else {
      unlink(file);
    19ab:	83 ec 0c             	sub    $0xc,%esp
    19ae:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19b1:	50                   	push   %eax
    19b2:	e8 ae 22 00 00       	call   3c65 <unlink>
    19b7:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    19ba:	83 ec 0c             	sub    $0xc,%esp
    19bd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19c0:	50                   	push   %eax
    19c1:	e8 9f 22 00 00       	call   3c65 <unlink>
    19c6:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    19c9:	83 ec 0c             	sub    $0xc,%esp
    19cc:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19cf:	50                   	push   %eax
    19d0:	e8 90 22 00 00       	call   3c65 <unlink>
    19d5:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    19d8:	83 ec 0c             	sub    $0xc,%esp
    19db:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19de:	50                   	push   %eax
    19df:	e8 81 22 00 00       	call   3c65 <unlink>
    19e4:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    19e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19eb:	75 05                	jne    19f2 <concreate+0x38f>
      exit();
    19ed:	e8 23 22 00 00       	call   3c15 <exit>
    else
      wait();
    19f2:	e8 26 22 00 00       	call   3c1d <wait>
  for(i = 0; i < 40; i++){
    19f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    19fb:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    19ff:	0f 8e af fe ff ff    	jle    18b4 <concreate+0x251>
  }

  printf(1, "concreate ok\n");
    1a05:	83 ec 08             	sub    $0x8,%esp
    1a08:	68 99 49 00 00       	push   $0x4999
    1a0d:	6a 01                	push   $0x1
    1a0f:	e8 9d 23 00 00       	call   3db1 <printf>
    1a14:	83 c4 10             	add    $0x10,%esp
}
    1a17:	90                   	nop
    1a18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1a1b:	c9                   	leave  
    1a1c:	c3                   	ret    

00001a1d <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1a1d:	55                   	push   %ebp
    1a1e:	89 e5                	mov    %esp,%ebp
    1a20:	83 ec 18             	sub    $0x18,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1a23:	83 ec 08             	sub    $0x8,%esp
    1a26:	68 a7 49 00 00       	push   $0x49a7
    1a2b:	6a 01                	push   $0x1
    1a2d:	e8 7f 23 00 00       	call   3db1 <printf>
    1a32:	83 c4 10             	add    $0x10,%esp

  unlink("x");
    1a35:	83 ec 0c             	sub    $0xc,%esp
    1a38:	68 0e 45 00 00       	push   $0x450e
    1a3d:	e8 23 22 00 00       	call   3c65 <unlink>
    1a42:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1a45:	e8 c3 21 00 00       	call   3c0d <fork>
    1a4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1a4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a51:	79 17                	jns    1a6a <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1a53:	83 ec 08             	sub    $0x8,%esp
    1a56:	68 55 45 00 00       	push   $0x4555
    1a5b:	6a 01                	push   $0x1
    1a5d:	e8 4f 23 00 00       	call   3db1 <printf>
    1a62:	83 c4 10             	add    $0x10,%esp
    exit();
    1a65:	e8 ab 21 00 00       	call   3c15 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1a6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a6e:	74 07                	je     1a77 <linkunlink+0x5a>
    1a70:	b8 01 00 00 00       	mov    $0x1,%eax
    1a75:	eb 05                	jmp    1a7c <linkunlink+0x5f>
    1a77:	b8 61 00 00 00       	mov    $0x61,%eax
    1a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1a86:	e9 9c 00 00 00       	jmp    1b27 <linkunlink+0x10a>
    x = x * 1103515245 + 12345;
    1a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a8e:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1a94:	05 39 30 00 00       	add    $0x3039,%eax
    1a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1a9c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1a9f:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1aa4:	89 c8                	mov    %ecx,%eax
    1aa6:	f7 e2                	mul    %edx
    1aa8:	89 d0                	mov    %edx,%eax
    1aaa:	d1 e8                	shr    %eax
    1aac:	89 c2                	mov    %eax,%edx
    1aae:	01 d2                	add    %edx,%edx
    1ab0:	01 c2                	add    %eax,%edx
    1ab2:	89 c8                	mov    %ecx,%eax
    1ab4:	29 d0                	sub    %edx,%eax
    1ab6:	85 c0                	test   %eax,%eax
    1ab8:	75 23                	jne    1add <linkunlink+0xc0>
      close(open("x", O_RDWR | O_CREATE));
    1aba:	83 ec 08             	sub    $0x8,%esp
    1abd:	68 02 02 00 00       	push   $0x202
    1ac2:	68 0e 45 00 00       	push   $0x450e
    1ac7:	e8 89 21 00 00       	call   3c55 <open>
    1acc:	83 c4 10             	add    $0x10,%esp
    1acf:	83 ec 0c             	sub    $0xc,%esp
    1ad2:	50                   	push   %eax
    1ad3:	e8 65 21 00 00       	call   3c3d <close>
    1ad8:	83 c4 10             	add    $0x10,%esp
    1adb:	eb 46                	jmp    1b23 <linkunlink+0x106>
    } else if((x % 3) == 1){
    1add:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1ae0:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1ae5:	89 c8                	mov    %ecx,%eax
    1ae7:	f7 e2                	mul    %edx
    1ae9:	89 d0                	mov    %edx,%eax
    1aeb:	d1 e8                	shr    %eax
    1aed:	89 c2                	mov    %eax,%edx
    1aef:	01 d2                	add    %edx,%edx
    1af1:	01 c2                	add    %eax,%edx
    1af3:	89 c8                	mov    %ecx,%eax
    1af5:	29 d0                	sub    %edx,%eax
    1af7:	83 f8 01             	cmp    $0x1,%eax
    1afa:	75 17                	jne    1b13 <linkunlink+0xf6>
      link("cat", "x");
    1afc:	83 ec 08             	sub    $0x8,%esp
    1aff:	68 0e 45 00 00       	push   $0x450e
    1b04:	68 b8 49 00 00       	push   $0x49b8
    1b09:	e8 67 21 00 00       	call   3c75 <link>
    1b0e:	83 c4 10             	add    $0x10,%esp
    1b11:	eb 10                	jmp    1b23 <linkunlink+0x106>
    } else {
      unlink("x");
    1b13:	83 ec 0c             	sub    $0xc,%esp
    1b16:	68 0e 45 00 00       	push   $0x450e
    1b1b:	e8 45 21 00 00       	call   3c65 <unlink>
    1b20:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1b23:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1b27:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1b2b:	0f 8e 5a ff ff ff    	jle    1a8b <linkunlink+0x6e>
    }
  }

  if(pid)
    1b31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b35:	74 07                	je     1b3e <linkunlink+0x121>
    wait();
    1b37:	e8 e1 20 00 00       	call   3c1d <wait>
    1b3c:	eb 05                	jmp    1b43 <linkunlink+0x126>
  else 
    exit();
    1b3e:	e8 d2 20 00 00       	call   3c15 <exit>

  printf(1, "linkunlink ok\n");
    1b43:	83 ec 08             	sub    $0x8,%esp
    1b46:	68 bc 49 00 00       	push   $0x49bc
    1b4b:	6a 01                	push   $0x1
    1b4d:	e8 5f 22 00 00       	call   3db1 <printf>
    1b52:	83 c4 10             	add    $0x10,%esp
}
    1b55:	90                   	nop
    1b56:	c9                   	leave  
    1b57:	c3                   	ret    

00001b58 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1b58:	55                   	push   %ebp
    1b59:	89 e5                	mov    %esp,%ebp
    1b5b:	83 ec 28             	sub    $0x28,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1b5e:	83 ec 08             	sub    $0x8,%esp
    1b61:	68 cb 49 00 00       	push   $0x49cb
    1b66:	6a 01                	push   $0x1
    1b68:	e8 44 22 00 00       	call   3db1 <printf>
    1b6d:	83 c4 10             	add    $0x10,%esp
  unlink("bd");
    1b70:	83 ec 0c             	sub    $0xc,%esp
    1b73:	68 d8 49 00 00       	push   $0x49d8
    1b78:	e8 e8 20 00 00       	call   3c65 <unlink>
    1b7d:	83 c4 10             	add    $0x10,%esp

  fd = open("bd", O_CREATE);
    1b80:	83 ec 08             	sub    $0x8,%esp
    1b83:	68 00 02 00 00       	push   $0x200
    1b88:	68 d8 49 00 00       	push   $0x49d8
    1b8d:	e8 c3 20 00 00       	call   3c55 <open>
    1b92:	83 c4 10             	add    $0x10,%esp
    1b95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1b98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1b9c:	79 17                	jns    1bb5 <bigdir+0x5d>
    printf(1, "bigdir create failed\n");
    1b9e:	83 ec 08             	sub    $0x8,%esp
    1ba1:	68 db 49 00 00       	push   $0x49db
    1ba6:	6a 01                	push   $0x1
    1ba8:	e8 04 22 00 00       	call   3db1 <printf>
    1bad:	83 c4 10             	add    $0x10,%esp
    exit();
    1bb0:	e8 60 20 00 00       	call   3c15 <exit>
  }
  close(fd);
    1bb5:	83 ec 0c             	sub    $0xc,%esp
    1bb8:	ff 75 f0             	pushl  -0x10(%ebp)
    1bbb:	e8 7d 20 00 00       	call   3c3d <close>
    1bc0:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    1bc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1bca:	eb 63                	jmp    1c2f <bigdir+0xd7>
    name[0] = 'x';
    1bcc:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bd3:	8d 50 3f             	lea    0x3f(%eax),%edx
    1bd6:	85 c0                	test   %eax,%eax
    1bd8:	0f 48 c2             	cmovs  %edx,%eax
    1bdb:	c1 f8 06             	sar    $0x6,%eax
    1bde:	83 c0 30             	add    $0x30,%eax
    1be1:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1be7:	99                   	cltd   
    1be8:	c1 ea 1a             	shr    $0x1a,%edx
    1beb:	01 d0                	add    %edx,%eax
    1bed:	83 e0 3f             	and    $0x3f,%eax
    1bf0:	29 d0                	sub    %edx,%eax
    1bf2:	83 c0 30             	add    $0x30,%eax
    1bf5:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1bf8:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1bfc:	83 ec 08             	sub    $0x8,%esp
    1bff:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1c02:	50                   	push   %eax
    1c03:	68 d8 49 00 00       	push   $0x49d8
    1c08:	e8 68 20 00 00       	call   3c75 <link>
    1c0d:	83 c4 10             	add    $0x10,%esp
    1c10:	85 c0                	test   %eax,%eax
    1c12:	74 17                	je     1c2b <bigdir+0xd3>
      printf(1, "bigdir link failed\n");
    1c14:	83 ec 08             	sub    $0x8,%esp
    1c17:	68 f1 49 00 00       	push   $0x49f1
    1c1c:	6a 01                	push   $0x1
    1c1e:	e8 8e 21 00 00       	call   3db1 <printf>
    1c23:	83 c4 10             	add    $0x10,%esp
      exit();
    1c26:	e8 ea 1f 00 00       	call   3c15 <exit>
  for(i = 0; i < 500; i++){
    1c2b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1c2f:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1c36:	7e 94                	jle    1bcc <bigdir+0x74>
    }
  }

  unlink("bd");
    1c38:	83 ec 0c             	sub    $0xc,%esp
    1c3b:	68 d8 49 00 00       	push   $0x49d8
    1c40:	e8 20 20 00 00       	call   3c65 <unlink>
    1c45:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    1c48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1c4f:	eb 5e                	jmp    1caf <bigdir+0x157>
    name[0] = 'x';
    1c51:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c58:	8d 50 3f             	lea    0x3f(%eax),%edx
    1c5b:	85 c0                	test   %eax,%eax
    1c5d:	0f 48 c2             	cmovs  %edx,%eax
    1c60:	c1 f8 06             	sar    $0x6,%eax
    1c63:	83 c0 30             	add    $0x30,%eax
    1c66:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c6c:	99                   	cltd   
    1c6d:	c1 ea 1a             	shr    $0x1a,%edx
    1c70:	01 d0                	add    %edx,%eax
    1c72:	83 e0 3f             	and    $0x3f,%eax
    1c75:	29 d0                	sub    %edx,%eax
    1c77:	83 c0 30             	add    $0x30,%eax
    1c7a:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1c7d:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1c81:	83 ec 0c             	sub    $0xc,%esp
    1c84:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1c87:	50                   	push   %eax
    1c88:	e8 d8 1f 00 00       	call   3c65 <unlink>
    1c8d:	83 c4 10             	add    $0x10,%esp
    1c90:	85 c0                	test   %eax,%eax
    1c92:	74 17                	je     1cab <bigdir+0x153>
      printf(1, "bigdir unlink failed");
    1c94:	83 ec 08             	sub    $0x8,%esp
    1c97:	68 05 4a 00 00       	push   $0x4a05
    1c9c:	6a 01                	push   $0x1
    1c9e:	e8 0e 21 00 00       	call   3db1 <printf>
    1ca3:	83 c4 10             	add    $0x10,%esp
      exit();
    1ca6:	e8 6a 1f 00 00       	call   3c15 <exit>
  for(i = 0; i < 500; i++){
    1cab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1caf:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1cb6:	7e 99                	jle    1c51 <bigdir+0xf9>
    }
  }

  printf(1, "bigdir ok\n");
    1cb8:	83 ec 08             	sub    $0x8,%esp
    1cbb:	68 1a 4a 00 00       	push   $0x4a1a
    1cc0:	6a 01                	push   $0x1
    1cc2:	e8 ea 20 00 00       	call   3db1 <printf>
    1cc7:	83 c4 10             	add    $0x10,%esp
}
    1cca:	90                   	nop
    1ccb:	c9                   	leave  
    1ccc:	c3                   	ret    

00001ccd <subdir>:

void
subdir(void)
{
    1ccd:	55                   	push   %ebp
    1cce:	89 e5                	mov    %esp,%ebp
    1cd0:	83 ec 18             	sub    $0x18,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1cd3:	83 ec 08             	sub    $0x8,%esp
    1cd6:	68 25 4a 00 00       	push   $0x4a25
    1cdb:	6a 01                	push   $0x1
    1cdd:	e8 cf 20 00 00       	call   3db1 <printf>
    1ce2:	83 c4 10             	add    $0x10,%esp

  unlink("ff");
    1ce5:	83 ec 0c             	sub    $0xc,%esp
    1ce8:	68 32 4a 00 00       	push   $0x4a32
    1ced:	e8 73 1f 00 00       	call   3c65 <unlink>
    1cf2:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dd") != 0){
    1cf5:	83 ec 0c             	sub    $0xc,%esp
    1cf8:	68 35 4a 00 00       	push   $0x4a35
    1cfd:	e8 7b 1f 00 00       	call   3c7d <mkdir>
    1d02:	83 c4 10             	add    $0x10,%esp
    1d05:	85 c0                	test   %eax,%eax
    1d07:	74 17                	je     1d20 <subdir+0x53>
    printf(1, "subdir mkdir dd failed\n");
    1d09:	83 ec 08             	sub    $0x8,%esp
    1d0c:	68 38 4a 00 00       	push   $0x4a38
    1d11:	6a 01                	push   $0x1
    1d13:	e8 99 20 00 00       	call   3db1 <printf>
    1d18:	83 c4 10             	add    $0x10,%esp
    exit();
    1d1b:	e8 f5 1e 00 00       	call   3c15 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1d20:	83 ec 08             	sub    $0x8,%esp
    1d23:	68 02 02 00 00       	push   $0x202
    1d28:	68 50 4a 00 00       	push   $0x4a50
    1d2d:	e8 23 1f 00 00       	call   3c55 <open>
    1d32:	83 c4 10             	add    $0x10,%esp
    1d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1d38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1d3c:	79 17                	jns    1d55 <subdir+0x88>
    printf(1, "create dd/ff failed\n");
    1d3e:	83 ec 08             	sub    $0x8,%esp
    1d41:	68 56 4a 00 00       	push   $0x4a56
    1d46:	6a 01                	push   $0x1
    1d48:	e8 64 20 00 00       	call   3db1 <printf>
    1d4d:	83 c4 10             	add    $0x10,%esp
    exit();
    1d50:	e8 c0 1e 00 00       	call   3c15 <exit>
  }
  write(fd, "ff", 2);
    1d55:	83 ec 04             	sub    $0x4,%esp
    1d58:	6a 02                	push   $0x2
    1d5a:	68 32 4a 00 00       	push   $0x4a32
    1d5f:	ff 75 f4             	pushl  -0xc(%ebp)
    1d62:	e8 ce 1e 00 00       	call   3c35 <write>
    1d67:	83 c4 10             	add    $0x10,%esp
  close(fd);
    1d6a:	83 ec 0c             	sub    $0xc,%esp
    1d6d:	ff 75 f4             	pushl  -0xc(%ebp)
    1d70:	e8 c8 1e 00 00       	call   3c3d <close>
    1d75:	83 c4 10             	add    $0x10,%esp
  
  if(unlink("dd") >= 0){
    1d78:	83 ec 0c             	sub    $0xc,%esp
    1d7b:	68 35 4a 00 00       	push   $0x4a35
    1d80:	e8 e0 1e 00 00       	call   3c65 <unlink>
    1d85:	83 c4 10             	add    $0x10,%esp
    1d88:	85 c0                	test   %eax,%eax
    1d8a:	78 17                	js     1da3 <subdir+0xd6>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1d8c:	83 ec 08             	sub    $0x8,%esp
    1d8f:	68 6c 4a 00 00       	push   $0x4a6c
    1d94:	6a 01                	push   $0x1
    1d96:	e8 16 20 00 00       	call   3db1 <printf>
    1d9b:	83 c4 10             	add    $0x10,%esp
    exit();
    1d9e:	e8 72 1e 00 00       	call   3c15 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    1da3:	83 ec 0c             	sub    $0xc,%esp
    1da6:	68 92 4a 00 00       	push   $0x4a92
    1dab:	e8 cd 1e 00 00       	call   3c7d <mkdir>
    1db0:	83 c4 10             	add    $0x10,%esp
    1db3:	85 c0                	test   %eax,%eax
    1db5:	74 17                	je     1dce <subdir+0x101>
    printf(1, "subdir mkdir dd/dd failed\n");
    1db7:	83 ec 08             	sub    $0x8,%esp
    1dba:	68 99 4a 00 00       	push   $0x4a99
    1dbf:	6a 01                	push   $0x1
    1dc1:	e8 eb 1f 00 00       	call   3db1 <printf>
    1dc6:	83 c4 10             	add    $0x10,%esp
    exit();
    1dc9:	e8 47 1e 00 00       	call   3c15 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1dce:	83 ec 08             	sub    $0x8,%esp
    1dd1:	68 02 02 00 00       	push   $0x202
    1dd6:	68 b4 4a 00 00       	push   $0x4ab4
    1ddb:	e8 75 1e 00 00       	call   3c55 <open>
    1de0:	83 c4 10             	add    $0x10,%esp
    1de3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1de6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1dea:	79 17                	jns    1e03 <subdir+0x136>
    printf(1, "create dd/dd/ff failed\n");
    1dec:	83 ec 08             	sub    $0x8,%esp
    1def:	68 bd 4a 00 00       	push   $0x4abd
    1df4:	6a 01                	push   $0x1
    1df6:	e8 b6 1f 00 00       	call   3db1 <printf>
    1dfb:	83 c4 10             	add    $0x10,%esp
    exit();
    1dfe:	e8 12 1e 00 00       	call   3c15 <exit>
  }
  write(fd, "FF", 2);
    1e03:	83 ec 04             	sub    $0x4,%esp
    1e06:	6a 02                	push   $0x2
    1e08:	68 d5 4a 00 00       	push   $0x4ad5
    1e0d:	ff 75 f4             	pushl  -0xc(%ebp)
    1e10:	e8 20 1e 00 00       	call   3c35 <write>
    1e15:	83 c4 10             	add    $0x10,%esp
  close(fd);
    1e18:	83 ec 0c             	sub    $0xc,%esp
    1e1b:	ff 75 f4             	pushl  -0xc(%ebp)
    1e1e:	e8 1a 1e 00 00       	call   3c3d <close>
    1e23:	83 c4 10             	add    $0x10,%esp

  fd = open("dd/dd/../ff", 0);
    1e26:	83 ec 08             	sub    $0x8,%esp
    1e29:	6a 00                	push   $0x0
    1e2b:	68 d8 4a 00 00       	push   $0x4ad8
    1e30:	e8 20 1e 00 00       	call   3c55 <open>
    1e35:	83 c4 10             	add    $0x10,%esp
    1e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1e3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1e3f:	79 17                	jns    1e58 <subdir+0x18b>
    printf(1, "open dd/dd/../ff failed\n");
    1e41:	83 ec 08             	sub    $0x8,%esp
    1e44:	68 e4 4a 00 00       	push   $0x4ae4
    1e49:	6a 01                	push   $0x1
    1e4b:	e8 61 1f 00 00       	call   3db1 <printf>
    1e50:	83 c4 10             	add    $0x10,%esp
    exit();
    1e53:	e8 bd 1d 00 00       	call   3c15 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    1e58:	83 ec 04             	sub    $0x4,%esp
    1e5b:	68 00 20 00 00       	push   $0x2000
    1e60:	68 e0 5e 00 00       	push   $0x5ee0
    1e65:	ff 75 f4             	pushl  -0xc(%ebp)
    1e68:	e8 c0 1d 00 00       	call   3c2d <read>
    1e6d:	83 c4 10             	add    $0x10,%esp
    1e70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    1e73:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    1e77:	75 0b                	jne    1e84 <subdir+0x1b7>
    1e79:	0f b6 05 e0 5e 00 00 	movzbl 0x5ee0,%eax
    1e80:	3c 66                	cmp    $0x66,%al
    1e82:	74 17                	je     1e9b <subdir+0x1ce>
    printf(1, "dd/dd/../ff wrong content\n");
    1e84:	83 ec 08             	sub    $0x8,%esp
    1e87:	68 fd 4a 00 00       	push   $0x4afd
    1e8c:	6a 01                	push   $0x1
    1e8e:	e8 1e 1f 00 00       	call   3db1 <printf>
    1e93:	83 c4 10             	add    $0x10,%esp
    exit();
    1e96:	e8 7a 1d 00 00       	call   3c15 <exit>
  }
  close(fd);
    1e9b:	83 ec 0c             	sub    $0xc,%esp
    1e9e:	ff 75 f4             	pushl  -0xc(%ebp)
    1ea1:	e8 97 1d 00 00       	call   3c3d <close>
    1ea6:	83 c4 10             	add    $0x10,%esp

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1ea9:	83 ec 08             	sub    $0x8,%esp
    1eac:	68 18 4b 00 00       	push   $0x4b18
    1eb1:	68 b4 4a 00 00       	push   $0x4ab4
    1eb6:	e8 ba 1d 00 00       	call   3c75 <link>
    1ebb:	83 c4 10             	add    $0x10,%esp
    1ebe:	85 c0                	test   %eax,%eax
    1ec0:	74 17                	je     1ed9 <subdir+0x20c>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    1ec2:	83 ec 08             	sub    $0x8,%esp
    1ec5:	68 24 4b 00 00       	push   $0x4b24
    1eca:	6a 01                	push   $0x1
    1ecc:	e8 e0 1e 00 00       	call   3db1 <printf>
    1ed1:	83 c4 10             	add    $0x10,%esp
    exit();
    1ed4:	e8 3c 1d 00 00       	call   3c15 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    1ed9:	83 ec 0c             	sub    $0xc,%esp
    1edc:	68 b4 4a 00 00       	push   $0x4ab4
    1ee1:	e8 7f 1d 00 00       	call   3c65 <unlink>
    1ee6:	83 c4 10             	add    $0x10,%esp
    1ee9:	85 c0                	test   %eax,%eax
    1eeb:	74 17                	je     1f04 <subdir+0x237>
    printf(1, "unlink dd/dd/ff failed\n");
    1eed:	83 ec 08             	sub    $0x8,%esp
    1ef0:	68 45 4b 00 00       	push   $0x4b45
    1ef5:	6a 01                	push   $0x1
    1ef7:	e8 b5 1e 00 00       	call   3db1 <printf>
    1efc:	83 c4 10             	add    $0x10,%esp
    exit();
    1eff:	e8 11 1d 00 00       	call   3c15 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1f04:	83 ec 08             	sub    $0x8,%esp
    1f07:	6a 00                	push   $0x0
    1f09:	68 b4 4a 00 00       	push   $0x4ab4
    1f0e:	e8 42 1d 00 00       	call   3c55 <open>
    1f13:	83 c4 10             	add    $0x10,%esp
    1f16:	85 c0                	test   %eax,%eax
    1f18:	78 17                	js     1f31 <subdir+0x264>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    1f1a:	83 ec 08             	sub    $0x8,%esp
    1f1d:	68 60 4b 00 00       	push   $0x4b60
    1f22:	6a 01                	push   $0x1
    1f24:	e8 88 1e 00 00       	call   3db1 <printf>
    1f29:	83 c4 10             	add    $0x10,%esp
    exit();
    1f2c:	e8 e4 1c 00 00       	call   3c15 <exit>
  }

  if(chdir("dd") != 0){
    1f31:	83 ec 0c             	sub    $0xc,%esp
    1f34:	68 35 4a 00 00       	push   $0x4a35
    1f39:	e8 47 1d 00 00       	call   3c85 <chdir>
    1f3e:	83 c4 10             	add    $0x10,%esp
    1f41:	85 c0                	test   %eax,%eax
    1f43:	74 17                	je     1f5c <subdir+0x28f>
    printf(1, "chdir dd failed\n");
    1f45:	83 ec 08             	sub    $0x8,%esp
    1f48:	68 84 4b 00 00       	push   $0x4b84
    1f4d:	6a 01                	push   $0x1
    1f4f:	e8 5d 1e 00 00       	call   3db1 <printf>
    1f54:	83 c4 10             	add    $0x10,%esp
    exit();
    1f57:	e8 b9 1c 00 00       	call   3c15 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    1f5c:	83 ec 0c             	sub    $0xc,%esp
    1f5f:	68 95 4b 00 00       	push   $0x4b95
    1f64:	e8 1c 1d 00 00       	call   3c85 <chdir>
    1f69:	83 c4 10             	add    $0x10,%esp
    1f6c:	85 c0                	test   %eax,%eax
    1f6e:	74 17                	je     1f87 <subdir+0x2ba>
    printf(1, "chdir dd/../../dd failed\n");
    1f70:	83 ec 08             	sub    $0x8,%esp
    1f73:	68 a1 4b 00 00       	push   $0x4ba1
    1f78:	6a 01                	push   $0x1
    1f7a:	e8 32 1e 00 00       	call   3db1 <printf>
    1f7f:	83 c4 10             	add    $0x10,%esp
    exit();
    1f82:	e8 8e 1c 00 00       	call   3c15 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    1f87:	83 ec 0c             	sub    $0xc,%esp
    1f8a:	68 bb 4b 00 00       	push   $0x4bbb
    1f8f:	e8 f1 1c 00 00       	call   3c85 <chdir>
    1f94:	83 c4 10             	add    $0x10,%esp
    1f97:	85 c0                	test   %eax,%eax
    1f99:	74 17                	je     1fb2 <subdir+0x2e5>
    printf(1, "chdir dd/../../dd failed\n");
    1f9b:	83 ec 08             	sub    $0x8,%esp
    1f9e:	68 a1 4b 00 00       	push   $0x4ba1
    1fa3:	6a 01                	push   $0x1
    1fa5:	e8 07 1e 00 00       	call   3db1 <printf>
    1faa:	83 c4 10             	add    $0x10,%esp
    exit();
    1fad:	e8 63 1c 00 00       	call   3c15 <exit>
  }
  if(chdir("./..") != 0){
    1fb2:	83 ec 0c             	sub    $0xc,%esp
    1fb5:	68 ca 4b 00 00       	push   $0x4bca
    1fba:	e8 c6 1c 00 00       	call   3c85 <chdir>
    1fbf:	83 c4 10             	add    $0x10,%esp
    1fc2:	85 c0                	test   %eax,%eax
    1fc4:	74 17                	je     1fdd <subdir+0x310>
    printf(1, "chdir ./.. failed\n");
    1fc6:	83 ec 08             	sub    $0x8,%esp
    1fc9:	68 cf 4b 00 00       	push   $0x4bcf
    1fce:	6a 01                	push   $0x1
    1fd0:	e8 dc 1d 00 00       	call   3db1 <printf>
    1fd5:	83 c4 10             	add    $0x10,%esp
    exit();
    1fd8:	e8 38 1c 00 00       	call   3c15 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    1fdd:	83 ec 08             	sub    $0x8,%esp
    1fe0:	6a 00                	push   $0x0
    1fe2:	68 18 4b 00 00       	push   $0x4b18
    1fe7:	e8 69 1c 00 00       	call   3c55 <open>
    1fec:	83 c4 10             	add    $0x10,%esp
    1fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1ff2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ff6:	79 17                	jns    200f <subdir+0x342>
    printf(1, "open dd/dd/ffff failed\n");
    1ff8:	83 ec 08             	sub    $0x8,%esp
    1ffb:	68 e2 4b 00 00       	push   $0x4be2
    2000:	6a 01                	push   $0x1
    2002:	e8 aa 1d 00 00       	call   3db1 <printf>
    2007:	83 c4 10             	add    $0x10,%esp
    exit();
    200a:	e8 06 1c 00 00       	call   3c15 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    200f:	83 ec 04             	sub    $0x4,%esp
    2012:	68 00 20 00 00       	push   $0x2000
    2017:	68 e0 5e 00 00       	push   $0x5ee0
    201c:	ff 75 f4             	pushl  -0xc(%ebp)
    201f:	e8 09 1c 00 00       	call   3c2d <read>
    2024:	83 c4 10             	add    $0x10,%esp
    2027:	83 f8 02             	cmp    $0x2,%eax
    202a:	74 17                	je     2043 <subdir+0x376>
    printf(1, "read dd/dd/ffff wrong len\n");
    202c:	83 ec 08             	sub    $0x8,%esp
    202f:	68 fa 4b 00 00       	push   $0x4bfa
    2034:	6a 01                	push   $0x1
    2036:	e8 76 1d 00 00       	call   3db1 <printf>
    203b:	83 c4 10             	add    $0x10,%esp
    exit();
    203e:	e8 d2 1b 00 00       	call   3c15 <exit>
  }
  close(fd);
    2043:	83 ec 0c             	sub    $0xc,%esp
    2046:	ff 75 f4             	pushl  -0xc(%ebp)
    2049:	e8 ef 1b 00 00       	call   3c3d <close>
    204e:	83 c4 10             	add    $0x10,%esp

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2051:	83 ec 08             	sub    $0x8,%esp
    2054:	6a 00                	push   $0x0
    2056:	68 b4 4a 00 00       	push   $0x4ab4
    205b:	e8 f5 1b 00 00       	call   3c55 <open>
    2060:	83 c4 10             	add    $0x10,%esp
    2063:	85 c0                	test   %eax,%eax
    2065:	78 17                	js     207e <subdir+0x3b1>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2067:	83 ec 08             	sub    $0x8,%esp
    206a:	68 18 4c 00 00       	push   $0x4c18
    206f:	6a 01                	push   $0x1
    2071:	e8 3b 1d 00 00       	call   3db1 <printf>
    2076:	83 c4 10             	add    $0x10,%esp
    exit();
    2079:	e8 97 1b 00 00       	call   3c15 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    207e:	83 ec 08             	sub    $0x8,%esp
    2081:	68 02 02 00 00       	push   $0x202
    2086:	68 3d 4c 00 00       	push   $0x4c3d
    208b:	e8 c5 1b 00 00       	call   3c55 <open>
    2090:	83 c4 10             	add    $0x10,%esp
    2093:	85 c0                	test   %eax,%eax
    2095:	78 17                	js     20ae <subdir+0x3e1>
    printf(1, "create dd/ff/ff succeeded!\n");
    2097:	83 ec 08             	sub    $0x8,%esp
    209a:	68 46 4c 00 00       	push   $0x4c46
    209f:	6a 01                	push   $0x1
    20a1:	e8 0b 1d 00 00       	call   3db1 <printf>
    20a6:	83 c4 10             	add    $0x10,%esp
    exit();
    20a9:	e8 67 1b 00 00       	call   3c15 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    20ae:	83 ec 08             	sub    $0x8,%esp
    20b1:	68 02 02 00 00       	push   $0x202
    20b6:	68 62 4c 00 00       	push   $0x4c62
    20bb:	e8 95 1b 00 00       	call   3c55 <open>
    20c0:	83 c4 10             	add    $0x10,%esp
    20c3:	85 c0                	test   %eax,%eax
    20c5:	78 17                	js     20de <subdir+0x411>
    printf(1, "create dd/xx/ff succeeded!\n");
    20c7:	83 ec 08             	sub    $0x8,%esp
    20ca:	68 6b 4c 00 00       	push   $0x4c6b
    20cf:	6a 01                	push   $0x1
    20d1:	e8 db 1c 00 00       	call   3db1 <printf>
    20d6:	83 c4 10             	add    $0x10,%esp
    exit();
    20d9:	e8 37 1b 00 00       	call   3c15 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    20de:	83 ec 08             	sub    $0x8,%esp
    20e1:	68 00 02 00 00       	push   $0x200
    20e6:	68 35 4a 00 00       	push   $0x4a35
    20eb:	e8 65 1b 00 00       	call   3c55 <open>
    20f0:	83 c4 10             	add    $0x10,%esp
    20f3:	85 c0                	test   %eax,%eax
    20f5:	78 17                	js     210e <subdir+0x441>
    printf(1, "create dd succeeded!\n");
    20f7:	83 ec 08             	sub    $0x8,%esp
    20fa:	68 87 4c 00 00       	push   $0x4c87
    20ff:	6a 01                	push   $0x1
    2101:	e8 ab 1c 00 00       	call   3db1 <printf>
    2106:	83 c4 10             	add    $0x10,%esp
    exit();
    2109:	e8 07 1b 00 00       	call   3c15 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    210e:	83 ec 08             	sub    $0x8,%esp
    2111:	6a 02                	push   $0x2
    2113:	68 35 4a 00 00       	push   $0x4a35
    2118:	e8 38 1b 00 00       	call   3c55 <open>
    211d:	83 c4 10             	add    $0x10,%esp
    2120:	85 c0                	test   %eax,%eax
    2122:	78 17                	js     213b <subdir+0x46e>
    printf(1, "open dd rdwr succeeded!\n");
    2124:	83 ec 08             	sub    $0x8,%esp
    2127:	68 9d 4c 00 00       	push   $0x4c9d
    212c:	6a 01                	push   $0x1
    212e:	e8 7e 1c 00 00       	call   3db1 <printf>
    2133:	83 c4 10             	add    $0x10,%esp
    exit();
    2136:	e8 da 1a 00 00       	call   3c15 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    213b:	83 ec 08             	sub    $0x8,%esp
    213e:	6a 01                	push   $0x1
    2140:	68 35 4a 00 00       	push   $0x4a35
    2145:	e8 0b 1b 00 00       	call   3c55 <open>
    214a:	83 c4 10             	add    $0x10,%esp
    214d:	85 c0                	test   %eax,%eax
    214f:	78 17                	js     2168 <subdir+0x49b>
    printf(1, "open dd wronly succeeded!\n");
    2151:	83 ec 08             	sub    $0x8,%esp
    2154:	68 b6 4c 00 00       	push   $0x4cb6
    2159:	6a 01                	push   $0x1
    215b:	e8 51 1c 00 00       	call   3db1 <printf>
    2160:	83 c4 10             	add    $0x10,%esp
    exit();
    2163:	e8 ad 1a 00 00       	call   3c15 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2168:	83 ec 08             	sub    $0x8,%esp
    216b:	68 d1 4c 00 00       	push   $0x4cd1
    2170:	68 3d 4c 00 00       	push   $0x4c3d
    2175:	e8 fb 1a 00 00       	call   3c75 <link>
    217a:	83 c4 10             	add    $0x10,%esp
    217d:	85 c0                	test   %eax,%eax
    217f:	75 17                	jne    2198 <subdir+0x4cb>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    2181:	83 ec 08             	sub    $0x8,%esp
    2184:	68 dc 4c 00 00       	push   $0x4cdc
    2189:	6a 01                	push   $0x1
    218b:	e8 21 1c 00 00       	call   3db1 <printf>
    2190:	83 c4 10             	add    $0x10,%esp
    exit();
    2193:	e8 7d 1a 00 00       	call   3c15 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2198:	83 ec 08             	sub    $0x8,%esp
    219b:	68 d1 4c 00 00       	push   $0x4cd1
    21a0:	68 62 4c 00 00       	push   $0x4c62
    21a5:	e8 cb 1a 00 00       	call   3c75 <link>
    21aa:	83 c4 10             	add    $0x10,%esp
    21ad:	85 c0                	test   %eax,%eax
    21af:	75 17                	jne    21c8 <subdir+0x4fb>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    21b1:	83 ec 08             	sub    $0x8,%esp
    21b4:	68 00 4d 00 00       	push   $0x4d00
    21b9:	6a 01                	push   $0x1
    21bb:	e8 f1 1b 00 00       	call   3db1 <printf>
    21c0:	83 c4 10             	add    $0x10,%esp
    exit();
    21c3:	e8 4d 1a 00 00       	call   3c15 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    21c8:	83 ec 08             	sub    $0x8,%esp
    21cb:	68 18 4b 00 00       	push   $0x4b18
    21d0:	68 50 4a 00 00       	push   $0x4a50
    21d5:	e8 9b 1a 00 00       	call   3c75 <link>
    21da:	83 c4 10             	add    $0x10,%esp
    21dd:	85 c0                	test   %eax,%eax
    21df:	75 17                	jne    21f8 <subdir+0x52b>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    21e1:	83 ec 08             	sub    $0x8,%esp
    21e4:	68 24 4d 00 00       	push   $0x4d24
    21e9:	6a 01                	push   $0x1
    21eb:	e8 c1 1b 00 00       	call   3db1 <printf>
    21f0:	83 c4 10             	add    $0x10,%esp
    exit();
    21f3:	e8 1d 1a 00 00       	call   3c15 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    21f8:	83 ec 0c             	sub    $0xc,%esp
    21fb:	68 3d 4c 00 00       	push   $0x4c3d
    2200:	e8 78 1a 00 00       	call   3c7d <mkdir>
    2205:	83 c4 10             	add    $0x10,%esp
    2208:	85 c0                	test   %eax,%eax
    220a:	75 17                	jne    2223 <subdir+0x556>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    220c:	83 ec 08             	sub    $0x8,%esp
    220f:	68 46 4d 00 00       	push   $0x4d46
    2214:	6a 01                	push   $0x1
    2216:	e8 96 1b 00 00       	call   3db1 <printf>
    221b:	83 c4 10             	add    $0x10,%esp
    exit();
    221e:	e8 f2 19 00 00       	call   3c15 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    2223:	83 ec 0c             	sub    $0xc,%esp
    2226:	68 62 4c 00 00       	push   $0x4c62
    222b:	e8 4d 1a 00 00       	call   3c7d <mkdir>
    2230:	83 c4 10             	add    $0x10,%esp
    2233:	85 c0                	test   %eax,%eax
    2235:	75 17                	jne    224e <subdir+0x581>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2237:	83 ec 08             	sub    $0x8,%esp
    223a:	68 61 4d 00 00       	push   $0x4d61
    223f:	6a 01                	push   $0x1
    2241:	e8 6b 1b 00 00       	call   3db1 <printf>
    2246:	83 c4 10             	add    $0x10,%esp
    exit();
    2249:	e8 c7 19 00 00       	call   3c15 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    224e:	83 ec 0c             	sub    $0xc,%esp
    2251:	68 18 4b 00 00       	push   $0x4b18
    2256:	e8 22 1a 00 00       	call   3c7d <mkdir>
    225b:	83 c4 10             	add    $0x10,%esp
    225e:	85 c0                	test   %eax,%eax
    2260:	75 17                	jne    2279 <subdir+0x5ac>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2262:	83 ec 08             	sub    $0x8,%esp
    2265:	68 7c 4d 00 00       	push   $0x4d7c
    226a:	6a 01                	push   $0x1
    226c:	e8 40 1b 00 00       	call   3db1 <printf>
    2271:	83 c4 10             	add    $0x10,%esp
    exit();
    2274:	e8 9c 19 00 00       	call   3c15 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    2279:	83 ec 0c             	sub    $0xc,%esp
    227c:	68 62 4c 00 00       	push   $0x4c62
    2281:	e8 df 19 00 00       	call   3c65 <unlink>
    2286:	83 c4 10             	add    $0x10,%esp
    2289:	85 c0                	test   %eax,%eax
    228b:	75 17                	jne    22a4 <subdir+0x5d7>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    228d:	83 ec 08             	sub    $0x8,%esp
    2290:	68 99 4d 00 00       	push   $0x4d99
    2295:	6a 01                	push   $0x1
    2297:	e8 15 1b 00 00       	call   3db1 <printf>
    229c:	83 c4 10             	add    $0x10,%esp
    exit();
    229f:	e8 71 19 00 00       	call   3c15 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    22a4:	83 ec 0c             	sub    $0xc,%esp
    22a7:	68 3d 4c 00 00       	push   $0x4c3d
    22ac:	e8 b4 19 00 00       	call   3c65 <unlink>
    22b1:	83 c4 10             	add    $0x10,%esp
    22b4:	85 c0                	test   %eax,%eax
    22b6:	75 17                	jne    22cf <subdir+0x602>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    22b8:	83 ec 08             	sub    $0x8,%esp
    22bb:	68 b5 4d 00 00       	push   $0x4db5
    22c0:	6a 01                	push   $0x1
    22c2:	e8 ea 1a 00 00       	call   3db1 <printf>
    22c7:	83 c4 10             	add    $0x10,%esp
    exit();
    22ca:	e8 46 19 00 00       	call   3c15 <exit>
  }
  if(chdir("dd/ff") == 0){
    22cf:	83 ec 0c             	sub    $0xc,%esp
    22d2:	68 50 4a 00 00       	push   $0x4a50
    22d7:	e8 a9 19 00 00       	call   3c85 <chdir>
    22dc:	83 c4 10             	add    $0x10,%esp
    22df:	85 c0                	test   %eax,%eax
    22e1:	75 17                	jne    22fa <subdir+0x62d>
    printf(1, "chdir dd/ff succeeded!\n");
    22e3:	83 ec 08             	sub    $0x8,%esp
    22e6:	68 d1 4d 00 00       	push   $0x4dd1
    22eb:	6a 01                	push   $0x1
    22ed:	e8 bf 1a 00 00       	call   3db1 <printf>
    22f2:	83 c4 10             	add    $0x10,%esp
    exit();
    22f5:	e8 1b 19 00 00       	call   3c15 <exit>
  }
  if(chdir("dd/xx") == 0){
    22fa:	83 ec 0c             	sub    $0xc,%esp
    22fd:	68 e9 4d 00 00       	push   $0x4de9
    2302:	e8 7e 19 00 00       	call   3c85 <chdir>
    2307:	83 c4 10             	add    $0x10,%esp
    230a:	85 c0                	test   %eax,%eax
    230c:	75 17                	jne    2325 <subdir+0x658>
    printf(1, "chdir dd/xx succeeded!\n");
    230e:	83 ec 08             	sub    $0x8,%esp
    2311:	68 ef 4d 00 00       	push   $0x4def
    2316:	6a 01                	push   $0x1
    2318:	e8 94 1a 00 00       	call   3db1 <printf>
    231d:	83 c4 10             	add    $0x10,%esp
    exit();
    2320:	e8 f0 18 00 00       	call   3c15 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    2325:	83 ec 0c             	sub    $0xc,%esp
    2328:	68 18 4b 00 00       	push   $0x4b18
    232d:	e8 33 19 00 00       	call   3c65 <unlink>
    2332:	83 c4 10             	add    $0x10,%esp
    2335:	85 c0                	test   %eax,%eax
    2337:	74 17                	je     2350 <subdir+0x683>
    printf(1, "unlink dd/dd/ff failed\n");
    2339:	83 ec 08             	sub    $0x8,%esp
    233c:	68 45 4b 00 00       	push   $0x4b45
    2341:	6a 01                	push   $0x1
    2343:	e8 69 1a 00 00       	call   3db1 <printf>
    2348:	83 c4 10             	add    $0x10,%esp
    exit();
    234b:	e8 c5 18 00 00       	call   3c15 <exit>
  }
  if(unlink("dd/ff") != 0){
    2350:	83 ec 0c             	sub    $0xc,%esp
    2353:	68 50 4a 00 00       	push   $0x4a50
    2358:	e8 08 19 00 00       	call   3c65 <unlink>
    235d:	83 c4 10             	add    $0x10,%esp
    2360:	85 c0                	test   %eax,%eax
    2362:	74 17                	je     237b <subdir+0x6ae>
    printf(1, "unlink dd/ff failed\n");
    2364:	83 ec 08             	sub    $0x8,%esp
    2367:	68 07 4e 00 00       	push   $0x4e07
    236c:	6a 01                	push   $0x1
    236e:	e8 3e 1a 00 00       	call   3db1 <printf>
    2373:	83 c4 10             	add    $0x10,%esp
    exit();
    2376:	e8 9a 18 00 00       	call   3c15 <exit>
  }
  if(unlink("dd") == 0){
    237b:	83 ec 0c             	sub    $0xc,%esp
    237e:	68 35 4a 00 00       	push   $0x4a35
    2383:	e8 dd 18 00 00       	call   3c65 <unlink>
    2388:	83 c4 10             	add    $0x10,%esp
    238b:	85 c0                	test   %eax,%eax
    238d:	75 17                	jne    23a6 <subdir+0x6d9>
    printf(1, "unlink non-empty dd succeeded!\n");
    238f:	83 ec 08             	sub    $0x8,%esp
    2392:	68 1c 4e 00 00       	push   $0x4e1c
    2397:	6a 01                	push   $0x1
    2399:	e8 13 1a 00 00       	call   3db1 <printf>
    239e:	83 c4 10             	add    $0x10,%esp
    exit();
    23a1:	e8 6f 18 00 00       	call   3c15 <exit>
  }
  if(unlink("dd/dd") < 0){
    23a6:	83 ec 0c             	sub    $0xc,%esp
    23a9:	68 3c 4e 00 00       	push   $0x4e3c
    23ae:	e8 b2 18 00 00       	call   3c65 <unlink>
    23b3:	83 c4 10             	add    $0x10,%esp
    23b6:	85 c0                	test   %eax,%eax
    23b8:	79 17                	jns    23d1 <subdir+0x704>
    printf(1, "unlink dd/dd failed\n");
    23ba:	83 ec 08             	sub    $0x8,%esp
    23bd:	68 42 4e 00 00       	push   $0x4e42
    23c2:	6a 01                	push   $0x1
    23c4:	e8 e8 19 00 00       	call   3db1 <printf>
    23c9:	83 c4 10             	add    $0x10,%esp
    exit();
    23cc:	e8 44 18 00 00       	call   3c15 <exit>
  }
  if(unlink("dd") < 0){
    23d1:	83 ec 0c             	sub    $0xc,%esp
    23d4:	68 35 4a 00 00       	push   $0x4a35
    23d9:	e8 87 18 00 00       	call   3c65 <unlink>
    23de:	83 c4 10             	add    $0x10,%esp
    23e1:	85 c0                	test   %eax,%eax
    23e3:	79 17                	jns    23fc <subdir+0x72f>
    printf(1, "unlink dd failed\n");
    23e5:	83 ec 08             	sub    $0x8,%esp
    23e8:	68 57 4e 00 00       	push   $0x4e57
    23ed:	6a 01                	push   $0x1
    23ef:	e8 bd 19 00 00       	call   3db1 <printf>
    23f4:	83 c4 10             	add    $0x10,%esp
    exit();
    23f7:	e8 19 18 00 00       	call   3c15 <exit>
  }

  printf(1, "subdir ok\n");
    23fc:	83 ec 08             	sub    $0x8,%esp
    23ff:	68 69 4e 00 00       	push   $0x4e69
    2404:	6a 01                	push   $0x1
    2406:	e8 a6 19 00 00       	call   3db1 <printf>
    240b:	83 c4 10             	add    $0x10,%esp
}
    240e:	90                   	nop
    240f:	c9                   	leave  
    2410:	c3                   	ret    

00002411 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    2411:	55                   	push   %ebp
    2412:	89 e5                	mov    %esp,%ebp
    2414:	83 ec 18             	sub    $0x18,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    2417:	83 ec 08             	sub    $0x8,%esp
    241a:	68 74 4e 00 00       	push   $0x4e74
    241f:	6a 01                	push   $0x1
    2421:	e8 8b 19 00 00       	call   3db1 <printf>
    2426:	83 c4 10             	add    $0x10,%esp

  unlink("bigwrite");
    2429:	83 ec 0c             	sub    $0xc,%esp
    242c:	68 83 4e 00 00       	push   $0x4e83
    2431:	e8 2f 18 00 00       	call   3c65 <unlink>
    2436:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    2439:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    2440:	e9 a8 00 00 00       	jmp    24ed <bigwrite+0xdc>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2445:	83 ec 08             	sub    $0x8,%esp
    2448:	68 02 02 00 00       	push   $0x202
    244d:	68 83 4e 00 00       	push   $0x4e83
    2452:	e8 fe 17 00 00       	call   3c55 <open>
    2457:	83 c4 10             	add    $0x10,%esp
    245a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    245d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2461:	79 17                	jns    247a <bigwrite+0x69>
      printf(1, "cannot create bigwrite\n");
    2463:	83 ec 08             	sub    $0x8,%esp
    2466:	68 8c 4e 00 00       	push   $0x4e8c
    246b:	6a 01                	push   $0x1
    246d:	e8 3f 19 00 00       	call   3db1 <printf>
    2472:	83 c4 10             	add    $0x10,%esp
      exit();
    2475:	e8 9b 17 00 00       	call   3c15 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    247a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2481:	eb 3f                	jmp    24c2 <bigwrite+0xb1>
      int cc = write(fd, buf, sz);
    2483:	83 ec 04             	sub    $0x4,%esp
    2486:	ff 75 f4             	pushl  -0xc(%ebp)
    2489:	68 e0 5e 00 00       	push   $0x5ee0
    248e:	ff 75 ec             	pushl  -0x14(%ebp)
    2491:	e8 9f 17 00 00       	call   3c35 <write>
    2496:	83 c4 10             	add    $0x10,%esp
    2499:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    249c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    249f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    24a2:	74 1a                	je     24be <bigwrite+0xad>
        printf(1, "write(%d) ret %d\n", sz, cc);
    24a4:	ff 75 e8             	pushl  -0x18(%ebp)
    24a7:	ff 75 f4             	pushl  -0xc(%ebp)
    24aa:	68 a4 4e 00 00       	push   $0x4ea4
    24af:	6a 01                	push   $0x1
    24b1:	e8 fb 18 00 00       	call   3db1 <printf>
    24b6:	83 c4 10             	add    $0x10,%esp
        exit();
    24b9:	e8 57 17 00 00       	call   3c15 <exit>
    for(i = 0; i < 2; i++){
    24be:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    24c2:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    24c6:	7e bb                	jle    2483 <bigwrite+0x72>
      }
    }
    close(fd);
    24c8:	83 ec 0c             	sub    $0xc,%esp
    24cb:	ff 75 ec             	pushl  -0x14(%ebp)
    24ce:	e8 6a 17 00 00       	call   3c3d <close>
    24d3:	83 c4 10             	add    $0x10,%esp
    unlink("bigwrite");
    24d6:	83 ec 0c             	sub    $0xc,%esp
    24d9:	68 83 4e 00 00       	push   $0x4e83
    24de:	e8 82 17 00 00       	call   3c65 <unlink>
    24e3:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    24e6:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    24ed:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    24f4:	0f 8e 4b ff ff ff    	jle    2445 <bigwrite+0x34>
  }

  printf(1, "bigwrite ok\n");
    24fa:	83 ec 08             	sub    $0x8,%esp
    24fd:	68 b6 4e 00 00       	push   $0x4eb6
    2502:	6a 01                	push   $0x1
    2504:	e8 a8 18 00 00       	call   3db1 <printf>
    2509:	83 c4 10             	add    $0x10,%esp
}
    250c:	90                   	nop
    250d:	c9                   	leave  
    250e:	c3                   	ret    

0000250f <bigfile>:

void
bigfile(void)
{
    250f:	55                   	push   %ebp
    2510:	89 e5                	mov    %esp,%ebp
    2512:	83 ec 18             	sub    $0x18,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    2515:	83 ec 08             	sub    $0x8,%esp
    2518:	68 c3 4e 00 00       	push   $0x4ec3
    251d:	6a 01                	push   $0x1
    251f:	e8 8d 18 00 00       	call   3db1 <printf>
    2524:	83 c4 10             	add    $0x10,%esp

  unlink("bigfile");
    2527:	83 ec 0c             	sub    $0xc,%esp
    252a:	68 d1 4e 00 00       	push   $0x4ed1
    252f:	e8 31 17 00 00       	call   3c65 <unlink>
    2534:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", O_CREATE | O_RDWR);
    2537:	83 ec 08             	sub    $0x8,%esp
    253a:	68 02 02 00 00       	push   $0x202
    253f:	68 d1 4e 00 00       	push   $0x4ed1
    2544:	e8 0c 17 00 00       	call   3c55 <open>
    2549:	83 c4 10             	add    $0x10,%esp
    254c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    254f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2553:	79 17                	jns    256c <bigfile+0x5d>
    printf(1, "cannot create bigfile");
    2555:	83 ec 08             	sub    $0x8,%esp
    2558:	68 d9 4e 00 00       	push   $0x4ed9
    255d:	6a 01                	push   $0x1
    255f:	e8 4d 18 00 00       	call   3db1 <printf>
    2564:	83 c4 10             	add    $0x10,%esp
    exit();
    2567:	e8 a9 16 00 00       	call   3c15 <exit>
  }
  for(i = 0; i < 20; i++){
    256c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2573:	eb 52                	jmp    25c7 <bigfile+0xb8>
    memset(buf, i, 600);
    2575:	83 ec 04             	sub    $0x4,%esp
    2578:	68 58 02 00 00       	push   $0x258
    257d:	ff 75 f4             	pushl  -0xc(%ebp)
    2580:	68 e0 5e 00 00       	push   $0x5ee0
    2585:	e8 f0 14 00 00       	call   3a7a <memset>
    258a:	83 c4 10             	add    $0x10,%esp
    if(write(fd, buf, 600) != 600){
    258d:	83 ec 04             	sub    $0x4,%esp
    2590:	68 58 02 00 00       	push   $0x258
    2595:	68 e0 5e 00 00       	push   $0x5ee0
    259a:	ff 75 ec             	pushl  -0x14(%ebp)
    259d:	e8 93 16 00 00       	call   3c35 <write>
    25a2:	83 c4 10             	add    $0x10,%esp
    25a5:	3d 58 02 00 00       	cmp    $0x258,%eax
    25aa:	74 17                	je     25c3 <bigfile+0xb4>
      printf(1, "write bigfile failed\n");
    25ac:	83 ec 08             	sub    $0x8,%esp
    25af:	68 ef 4e 00 00       	push   $0x4eef
    25b4:	6a 01                	push   $0x1
    25b6:	e8 f6 17 00 00       	call   3db1 <printf>
    25bb:	83 c4 10             	add    $0x10,%esp
      exit();
    25be:	e8 52 16 00 00       	call   3c15 <exit>
  for(i = 0; i < 20; i++){
    25c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    25c7:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    25cb:	7e a8                	jle    2575 <bigfile+0x66>
    }
  }
  close(fd);
    25cd:	83 ec 0c             	sub    $0xc,%esp
    25d0:	ff 75 ec             	pushl  -0x14(%ebp)
    25d3:	e8 65 16 00 00       	call   3c3d <close>
    25d8:	83 c4 10             	add    $0x10,%esp

  fd = open("bigfile", 0);
    25db:	83 ec 08             	sub    $0x8,%esp
    25de:	6a 00                	push   $0x0
    25e0:	68 d1 4e 00 00       	push   $0x4ed1
    25e5:	e8 6b 16 00 00       	call   3c55 <open>
    25ea:	83 c4 10             	add    $0x10,%esp
    25ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    25f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    25f4:	79 17                	jns    260d <bigfile+0xfe>
    printf(1, "cannot open bigfile\n");
    25f6:	83 ec 08             	sub    $0x8,%esp
    25f9:	68 05 4f 00 00       	push   $0x4f05
    25fe:	6a 01                	push   $0x1
    2600:	e8 ac 17 00 00       	call   3db1 <printf>
    2605:	83 c4 10             	add    $0x10,%esp
    exit();
    2608:	e8 08 16 00 00       	call   3c15 <exit>
  }
  total = 0;
    260d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    2614:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    261b:	83 ec 04             	sub    $0x4,%esp
    261e:	68 2c 01 00 00       	push   $0x12c
    2623:	68 e0 5e 00 00       	push   $0x5ee0
    2628:	ff 75 ec             	pushl  -0x14(%ebp)
    262b:	e8 fd 15 00 00       	call   3c2d <read>
    2630:	83 c4 10             	add    $0x10,%esp
    2633:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    2636:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    263a:	79 17                	jns    2653 <bigfile+0x144>
      printf(1, "read bigfile failed\n");
    263c:	83 ec 08             	sub    $0x8,%esp
    263f:	68 1a 4f 00 00       	push   $0x4f1a
    2644:	6a 01                	push   $0x1
    2646:	e8 66 17 00 00       	call   3db1 <printf>
    264b:	83 c4 10             	add    $0x10,%esp
      exit();
    264e:	e8 c2 15 00 00       	call   3c15 <exit>
    }
    if(cc == 0)
    2653:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2657:	74 7a                	je     26d3 <bigfile+0x1c4>
      break;
    if(cc != 300){
    2659:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    2660:	74 17                	je     2679 <bigfile+0x16a>
      printf(1, "short read bigfile\n");
    2662:	83 ec 08             	sub    $0x8,%esp
    2665:	68 2f 4f 00 00       	push   $0x4f2f
    266a:	6a 01                	push   $0x1
    266c:	e8 40 17 00 00       	call   3db1 <printf>
    2671:	83 c4 10             	add    $0x10,%esp
      exit();
    2674:	e8 9c 15 00 00       	call   3c15 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    2679:	0f b6 05 e0 5e 00 00 	movzbl 0x5ee0,%eax
    2680:	0f be d0             	movsbl %al,%edx
    2683:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2686:	89 c1                	mov    %eax,%ecx
    2688:	c1 e9 1f             	shr    $0x1f,%ecx
    268b:	01 c8                	add    %ecx,%eax
    268d:	d1 f8                	sar    %eax
    268f:	39 c2                	cmp    %eax,%edx
    2691:	75 1a                	jne    26ad <bigfile+0x19e>
    2693:	0f b6 05 0b 60 00 00 	movzbl 0x600b,%eax
    269a:	0f be d0             	movsbl %al,%edx
    269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26a0:	89 c1                	mov    %eax,%ecx
    26a2:	c1 e9 1f             	shr    $0x1f,%ecx
    26a5:	01 c8                	add    %ecx,%eax
    26a7:	d1 f8                	sar    %eax
    26a9:	39 c2                	cmp    %eax,%edx
    26ab:	74 17                	je     26c4 <bigfile+0x1b5>
      printf(1, "read bigfile wrong data\n");
    26ad:	83 ec 08             	sub    $0x8,%esp
    26b0:	68 43 4f 00 00       	push   $0x4f43
    26b5:	6a 01                	push   $0x1
    26b7:	e8 f5 16 00 00       	call   3db1 <printf>
    26bc:	83 c4 10             	add    $0x10,%esp
      exit();
    26bf:	e8 51 15 00 00       	call   3c15 <exit>
    }
    total += cc;
    26c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    26c7:	01 45 f0             	add    %eax,-0x10(%ebp)
  for(i = 0; ; i++){
    26ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    cc = read(fd, buf, 300);
    26ce:	e9 48 ff ff ff       	jmp    261b <bigfile+0x10c>
      break;
    26d3:	90                   	nop
  }
  close(fd);
    26d4:	83 ec 0c             	sub    $0xc,%esp
    26d7:	ff 75 ec             	pushl  -0x14(%ebp)
    26da:	e8 5e 15 00 00       	call   3c3d <close>
    26df:	83 c4 10             	add    $0x10,%esp
  if(total != 20*600){
    26e2:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    26e9:	74 17                	je     2702 <bigfile+0x1f3>
    printf(1, "read bigfile wrong total\n");
    26eb:	83 ec 08             	sub    $0x8,%esp
    26ee:	68 5c 4f 00 00       	push   $0x4f5c
    26f3:	6a 01                	push   $0x1
    26f5:	e8 b7 16 00 00       	call   3db1 <printf>
    26fa:	83 c4 10             	add    $0x10,%esp
    exit();
    26fd:	e8 13 15 00 00       	call   3c15 <exit>
  }
  unlink("bigfile");
    2702:	83 ec 0c             	sub    $0xc,%esp
    2705:	68 d1 4e 00 00       	push   $0x4ed1
    270a:	e8 56 15 00 00       	call   3c65 <unlink>
    270f:	83 c4 10             	add    $0x10,%esp

  printf(1, "bigfile test ok\n");
    2712:	83 ec 08             	sub    $0x8,%esp
    2715:	68 76 4f 00 00       	push   $0x4f76
    271a:	6a 01                	push   $0x1
    271c:	e8 90 16 00 00       	call   3db1 <printf>
    2721:	83 c4 10             	add    $0x10,%esp
}
    2724:	90                   	nop
    2725:	c9                   	leave  
    2726:	c3                   	ret    

00002727 <fourteen>:

void
fourteen(void)
{
    2727:	55                   	push   %ebp
    2728:	89 e5                	mov    %esp,%ebp
    272a:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    272d:	83 ec 08             	sub    $0x8,%esp
    2730:	68 87 4f 00 00       	push   $0x4f87
    2735:	6a 01                	push   $0x1
    2737:	e8 75 16 00 00       	call   3db1 <printf>
    273c:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234") != 0){
    273f:	83 ec 0c             	sub    $0xc,%esp
    2742:	68 96 4f 00 00       	push   $0x4f96
    2747:	e8 31 15 00 00       	call   3c7d <mkdir>
    274c:	83 c4 10             	add    $0x10,%esp
    274f:	85 c0                	test   %eax,%eax
    2751:	74 17                	je     276a <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2753:	83 ec 08             	sub    $0x8,%esp
    2756:	68 a5 4f 00 00       	push   $0x4fa5
    275b:	6a 01                	push   $0x1
    275d:	e8 4f 16 00 00       	call   3db1 <printf>
    2762:	83 c4 10             	add    $0x10,%esp
    exit();
    2765:	e8 ab 14 00 00       	call   3c15 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    276a:	83 ec 0c             	sub    $0xc,%esp
    276d:	68 c4 4f 00 00       	push   $0x4fc4
    2772:	e8 06 15 00 00       	call   3c7d <mkdir>
    2777:	83 c4 10             	add    $0x10,%esp
    277a:	85 c0                	test   %eax,%eax
    277c:	74 17                	je     2795 <fourteen+0x6e>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    277e:	83 ec 08             	sub    $0x8,%esp
    2781:	68 e4 4f 00 00       	push   $0x4fe4
    2786:	6a 01                	push   $0x1
    2788:	e8 24 16 00 00       	call   3db1 <printf>
    278d:	83 c4 10             	add    $0x10,%esp
    exit();
    2790:	e8 80 14 00 00       	call   3c15 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2795:	83 ec 08             	sub    $0x8,%esp
    2798:	68 00 02 00 00       	push   $0x200
    279d:	68 14 50 00 00       	push   $0x5014
    27a2:	e8 ae 14 00 00       	call   3c55 <open>
    27a7:	83 c4 10             	add    $0x10,%esp
    27aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    27ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    27b1:	79 17                	jns    27ca <fourteen+0xa3>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    27b3:	83 ec 08             	sub    $0x8,%esp
    27b6:	68 44 50 00 00       	push   $0x5044
    27bb:	6a 01                	push   $0x1
    27bd:	e8 ef 15 00 00       	call   3db1 <printf>
    27c2:	83 c4 10             	add    $0x10,%esp
    exit();
    27c5:	e8 4b 14 00 00       	call   3c15 <exit>
  }
  close(fd);
    27ca:	83 ec 0c             	sub    $0xc,%esp
    27cd:	ff 75 f4             	pushl  -0xc(%ebp)
    27d0:	e8 68 14 00 00       	call   3c3d <close>
    27d5:	83 c4 10             	add    $0x10,%esp
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    27d8:	83 ec 08             	sub    $0x8,%esp
    27db:	6a 00                	push   $0x0
    27dd:	68 84 50 00 00       	push   $0x5084
    27e2:	e8 6e 14 00 00       	call   3c55 <open>
    27e7:	83 c4 10             	add    $0x10,%esp
    27ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    27ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    27f1:	79 17                	jns    280a <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    27f3:	83 ec 08             	sub    $0x8,%esp
    27f6:	68 b4 50 00 00       	push   $0x50b4
    27fb:	6a 01                	push   $0x1
    27fd:	e8 af 15 00 00       	call   3db1 <printf>
    2802:	83 c4 10             	add    $0x10,%esp
    exit();
    2805:	e8 0b 14 00 00       	call   3c15 <exit>
  }
  close(fd);
    280a:	83 ec 0c             	sub    $0xc,%esp
    280d:	ff 75 f4             	pushl  -0xc(%ebp)
    2810:	e8 28 14 00 00       	call   3c3d <close>
    2815:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234/12345678901234") == 0){
    2818:	83 ec 0c             	sub    $0xc,%esp
    281b:	68 ee 50 00 00       	push   $0x50ee
    2820:	e8 58 14 00 00       	call   3c7d <mkdir>
    2825:	83 c4 10             	add    $0x10,%esp
    2828:	85 c0                	test   %eax,%eax
    282a:	75 17                	jne    2843 <fourteen+0x11c>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    282c:	83 ec 08             	sub    $0x8,%esp
    282f:	68 0c 51 00 00       	push   $0x510c
    2834:	6a 01                	push   $0x1
    2836:	e8 76 15 00 00       	call   3db1 <printf>
    283b:	83 c4 10             	add    $0x10,%esp
    exit();
    283e:	e8 d2 13 00 00       	call   3c15 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2843:	83 ec 0c             	sub    $0xc,%esp
    2846:	68 3c 51 00 00       	push   $0x513c
    284b:	e8 2d 14 00 00       	call   3c7d <mkdir>
    2850:	83 c4 10             	add    $0x10,%esp
    2853:	85 c0                	test   %eax,%eax
    2855:	75 17                	jne    286e <fourteen+0x147>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2857:	83 ec 08             	sub    $0x8,%esp
    285a:	68 5c 51 00 00       	push   $0x515c
    285f:	6a 01                	push   $0x1
    2861:	e8 4b 15 00 00       	call   3db1 <printf>
    2866:	83 c4 10             	add    $0x10,%esp
    exit();
    2869:	e8 a7 13 00 00       	call   3c15 <exit>
  }

  printf(1, "fourteen ok\n");
    286e:	83 ec 08             	sub    $0x8,%esp
    2871:	68 8d 51 00 00       	push   $0x518d
    2876:	6a 01                	push   $0x1
    2878:	e8 34 15 00 00       	call   3db1 <printf>
    287d:	83 c4 10             	add    $0x10,%esp
}
    2880:	90                   	nop
    2881:	c9                   	leave  
    2882:	c3                   	ret    

00002883 <rmdot>:

void
rmdot(void)
{
    2883:	55                   	push   %ebp
    2884:	89 e5                	mov    %esp,%ebp
    2886:	83 ec 08             	sub    $0x8,%esp
  printf(1, "rmdot test\n");
    2889:	83 ec 08             	sub    $0x8,%esp
    288c:	68 9a 51 00 00       	push   $0x519a
    2891:	6a 01                	push   $0x1
    2893:	e8 19 15 00 00       	call   3db1 <printf>
    2898:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dots") != 0){
    289b:	83 ec 0c             	sub    $0xc,%esp
    289e:	68 a6 51 00 00       	push   $0x51a6
    28a3:	e8 d5 13 00 00       	call   3c7d <mkdir>
    28a8:	83 c4 10             	add    $0x10,%esp
    28ab:	85 c0                	test   %eax,%eax
    28ad:	74 17                	je     28c6 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    28af:	83 ec 08             	sub    $0x8,%esp
    28b2:	68 ab 51 00 00       	push   $0x51ab
    28b7:	6a 01                	push   $0x1
    28b9:	e8 f3 14 00 00       	call   3db1 <printf>
    28be:	83 c4 10             	add    $0x10,%esp
    exit();
    28c1:	e8 4f 13 00 00       	call   3c15 <exit>
  }
  if(chdir("dots") != 0){
    28c6:	83 ec 0c             	sub    $0xc,%esp
    28c9:	68 a6 51 00 00       	push   $0x51a6
    28ce:	e8 b2 13 00 00       	call   3c85 <chdir>
    28d3:	83 c4 10             	add    $0x10,%esp
    28d6:	85 c0                	test   %eax,%eax
    28d8:	74 17                	je     28f1 <rmdot+0x6e>
    printf(1, "chdir dots failed\n");
    28da:	83 ec 08             	sub    $0x8,%esp
    28dd:	68 be 51 00 00       	push   $0x51be
    28e2:	6a 01                	push   $0x1
    28e4:	e8 c8 14 00 00       	call   3db1 <printf>
    28e9:	83 c4 10             	add    $0x10,%esp
    exit();
    28ec:	e8 24 13 00 00       	call   3c15 <exit>
  }
  if(unlink(".") == 0){
    28f1:	83 ec 0c             	sub    $0xc,%esp
    28f4:	68 d7 48 00 00       	push   $0x48d7
    28f9:	e8 67 13 00 00       	call   3c65 <unlink>
    28fe:	83 c4 10             	add    $0x10,%esp
    2901:	85 c0                	test   %eax,%eax
    2903:	75 17                	jne    291c <rmdot+0x99>
    printf(1, "rm . worked!\n");
    2905:	83 ec 08             	sub    $0x8,%esp
    2908:	68 d1 51 00 00       	push   $0x51d1
    290d:	6a 01                	push   $0x1
    290f:	e8 9d 14 00 00       	call   3db1 <printf>
    2914:	83 c4 10             	add    $0x10,%esp
    exit();
    2917:	e8 f9 12 00 00       	call   3c15 <exit>
  }
  if(unlink("..") == 0){
    291c:	83 ec 0c             	sub    $0xc,%esp
    291f:	68 64 44 00 00       	push   $0x4464
    2924:	e8 3c 13 00 00       	call   3c65 <unlink>
    2929:	83 c4 10             	add    $0x10,%esp
    292c:	85 c0                	test   %eax,%eax
    292e:	75 17                	jne    2947 <rmdot+0xc4>
    printf(1, "rm .. worked!\n");
    2930:	83 ec 08             	sub    $0x8,%esp
    2933:	68 df 51 00 00       	push   $0x51df
    2938:	6a 01                	push   $0x1
    293a:	e8 72 14 00 00       	call   3db1 <printf>
    293f:	83 c4 10             	add    $0x10,%esp
    exit();
    2942:	e8 ce 12 00 00       	call   3c15 <exit>
  }
  if(chdir("/") != 0){
    2947:	83 ec 0c             	sub    $0xc,%esp
    294a:	68 ee 51 00 00       	push   $0x51ee
    294f:	e8 31 13 00 00       	call   3c85 <chdir>
    2954:	83 c4 10             	add    $0x10,%esp
    2957:	85 c0                	test   %eax,%eax
    2959:	74 17                	je     2972 <rmdot+0xef>
    printf(1, "chdir / failed\n");
    295b:	83 ec 08             	sub    $0x8,%esp
    295e:	68 f0 51 00 00       	push   $0x51f0
    2963:	6a 01                	push   $0x1
    2965:	e8 47 14 00 00       	call   3db1 <printf>
    296a:	83 c4 10             	add    $0x10,%esp
    exit();
    296d:	e8 a3 12 00 00       	call   3c15 <exit>
  }
  if(unlink("dots/.") == 0){
    2972:	83 ec 0c             	sub    $0xc,%esp
    2975:	68 00 52 00 00       	push   $0x5200
    297a:	e8 e6 12 00 00       	call   3c65 <unlink>
    297f:	83 c4 10             	add    $0x10,%esp
    2982:	85 c0                	test   %eax,%eax
    2984:	75 17                	jne    299d <rmdot+0x11a>
    printf(1, "unlink dots/. worked!\n");
    2986:	83 ec 08             	sub    $0x8,%esp
    2989:	68 07 52 00 00       	push   $0x5207
    298e:	6a 01                	push   $0x1
    2990:	e8 1c 14 00 00       	call   3db1 <printf>
    2995:	83 c4 10             	add    $0x10,%esp
    exit();
    2998:	e8 78 12 00 00       	call   3c15 <exit>
  }
  if(unlink("dots/..") == 0){
    299d:	83 ec 0c             	sub    $0xc,%esp
    29a0:	68 1e 52 00 00       	push   $0x521e
    29a5:	e8 bb 12 00 00       	call   3c65 <unlink>
    29aa:	83 c4 10             	add    $0x10,%esp
    29ad:	85 c0                	test   %eax,%eax
    29af:	75 17                	jne    29c8 <rmdot+0x145>
    printf(1, "unlink dots/.. worked!\n");
    29b1:	83 ec 08             	sub    $0x8,%esp
    29b4:	68 26 52 00 00       	push   $0x5226
    29b9:	6a 01                	push   $0x1
    29bb:	e8 f1 13 00 00       	call   3db1 <printf>
    29c0:	83 c4 10             	add    $0x10,%esp
    exit();
    29c3:	e8 4d 12 00 00       	call   3c15 <exit>
  }
  if(unlink("dots") != 0){
    29c8:	83 ec 0c             	sub    $0xc,%esp
    29cb:	68 a6 51 00 00       	push   $0x51a6
    29d0:	e8 90 12 00 00       	call   3c65 <unlink>
    29d5:	83 c4 10             	add    $0x10,%esp
    29d8:	85 c0                	test   %eax,%eax
    29da:	74 17                	je     29f3 <rmdot+0x170>
    printf(1, "unlink dots failed!\n");
    29dc:	83 ec 08             	sub    $0x8,%esp
    29df:	68 3e 52 00 00       	push   $0x523e
    29e4:	6a 01                	push   $0x1
    29e6:	e8 c6 13 00 00       	call   3db1 <printf>
    29eb:	83 c4 10             	add    $0x10,%esp
    exit();
    29ee:	e8 22 12 00 00       	call   3c15 <exit>
  }
  printf(1, "rmdot ok\n");
    29f3:	83 ec 08             	sub    $0x8,%esp
    29f6:	68 53 52 00 00       	push   $0x5253
    29fb:	6a 01                	push   $0x1
    29fd:	e8 af 13 00 00       	call   3db1 <printf>
    2a02:	83 c4 10             	add    $0x10,%esp
}
    2a05:	90                   	nop
    2a06:	c9                   	leave  
    2a07:	c3                   	ret    

00002a08 <dirfile>:

void
dirfile(void)
{
    2a08:	55                   	push   %ebp
    2a09:	89 e5                	mov    %esp,%ebp
    2a0b:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "dir vs file\n");
    2a0e:	83 ec 08             	sub    $0x8,%esp
    2a11:	68 5d 52 00 00       	push   $0x525d
    2a16:	6a 01                	push   $0x1
    2a18:	e8 94 13 00 00       	call   3db1 <printf>
    2a1d:	83 c4 10             	add    $0x10,%esp

  fd = open("dirfile", O_CREATE);
    2a20:	83 ec 08             	sub    $0x8,%esp
    2a23:	68 00 02 00 00       	push   $0x200
    2a28:	68 6a 52 00 00       	push   $0x526a
    2a2d:	e8 23 12 00 00       	call   3c55 <open>
    2a32:	83 c4 10             	add    $0x10,%esp
    2a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a3c:	79 17                	jns    2a55 <dirfile+0x4d>
    printf(1, "create dirfile failed\n");
    2a3e:	83 ec 08             	sub    $0x8,%esp
    2a41:	68 72 52 00 00       	push   $0x5272
    2a46:	6a 01                	push   $0x1
    2a48:	e8 64 13 00 00       	call   3db1 <printf>
    2a4d:	83 c4 10             	add    $0x10,%esp
    exit();
    2a50:	e8 c0 11 00 00       	call   3c15 <exit>
  }
  close(fd);
    2a55:	83 ec 0c             	sub    $0xc,%esp
    2a58:	ff 75 f4             	pushl  -0xc(%ebp)
    2a5b:	e8 dd 11 00 00       	call   3c3d <close>
    2a60:	83 c4 10             	add    $0x10,%esp
  if(chdir("dirfile") == 0){
    2a63:	83 ec 0c             	sub    $0xc,%esp
    2a66:	68 6a 52 00 00       	push   $0x526a
    2a6b:	e8 15 12 00 00       	call   3c85 <chdir>
    2a70:	83 c4 10             	add    $0x10,%esp
    2a73:	85 c0                	test   %eax,%eax
    2a75:	75 17                	jne    2a8e <dirfile+0x86>
    printf(1, "chdir dirfile succeeded!\n");
    2a77:	83 ec 08             	sub    $0x8,%esp
    2a7a:	68 89 52 00 00       	push   $0x5289
    2a7f:	6a 01                	push   $0x1
    2a81:	e8 2b 13 00 00       	call   3db1 <printf>
    2a86:	83 c4 10             	add    $0x10,%esp
    exit();
    2a89:	e8 87 11 00 00       	call   3c15 <exit>
  }
  fd = open("dirfile/xx", 0);
    2a8e:	83 ec 08             	sub    $0x8,%esp
    2a91:	6a 00                	push   $0x0
    2a93:	68 a3 52 00 00       	push   $0x52a3
    2a98:	e8 b8 11 00 00       	call   3c55 <open>
    2a9d:	83 c4 10             	add    $0x10,%esp
    2aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2aa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2aa7:	78 17                	js     2ac0 <dirfile+0xb8>
    printf(1, "create dirfile/xx succeeded!\n");
    2aa9:	83 ec 08             	sub    $0x8,%esp
    2aac:	68 ae 52 00 00       	push   $0x52ae
    2ab1:	6a 01                	push   $0x1
    2ab3:	e8 f9 12 00 00       	call   3db1 <printf>
    2ab8:	83 c4 10             	add    $0x10,%esp
    exit();
    2abb:	e8 55 11 00 00       	call   3c15 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2ac0:	83 ec 08             	sub    $0x8,%esp
    2ac3:	68 00 02 00 00       	push   $0x200
    2ac8:	68 a3 52 00 00       	push   $0x52a3
    2acd:	e8 83 11 00 00       	call   3c55 <open>
    2ad2:	83 c4 10             	add    $0x10,%esp
    2ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2ad8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2adc:	78 17                	js     2af5 <dirfile+0xed>
    printf(1, "create dirfile/xx succeeded!\n");
    2ade:	83 ec 08             	sub    $0x8,%esp
    2ae1:	68 ae 52 00 00       	push   $0x52ae
    2ae6:	6a 01                	push   $0x1
    2ae8:	e8 c4 12 00 00       	call   3db1 <printf>
    2aed:	83 c4 10             	add    $0x10,%esp
    exit();
    2af0:	e8 20 11 00 00       	call   3c15 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2af5:	83 ec 0c             	sub    $0xc,%esp
    2af8:	68 a3 52 00 00       	push   $0x52a3
    2afd:	e8 7b 11 00 00       	call   3c7d <mkdir>
    2b02:	83 c4 10             	add    $0x10,%esp
    2b05:	85 c0                	test   %eax,%eax
    2b07:	75 17                	jne    2b20 <dirfile+0x118>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2b09:	83 ec 08             	sub    $0x8,%esp
    2b0c:	68 cc 52 00 00       	push   $0x52cc
    2b11:	6a 01                	push   $0x1
    2b13:	e8 99 12 00 00       	call   3db1 <printf>
    2b18:	83 c4 10             	add    $0x10,%esp
    exit();
    2b1b:	e8 f5 10 00 00       	call   3c15 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2b20:	83 ec 0c             	sub    $0xc,%esp
    2b23:	68 a3 52 00 00       	push   $0x52a3
    2b28:	e8 38 11 00 00       	call   3c65 <unlink>
    2b2d:	83 c4 10             	add    $0x10,%esp
    2b30:	85 c0                	test   %eax,%eax
    2b32:	75 17                	jne    2b4b <dirfile+0x143>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2b34:	83 ec 08             	sub    $0x8,%esp
    2b37:	68 e9 52 00 00       	push   $0x52e9
    2b3c:	6a 01                	push   $0x1
    2b3e:	e8 6e 12 00 00       	call   3db1 <printf>
    2b43:	83 c4 10             	add    $0x10,%esp
    exit();
    2b46:	e8 ca 10 00 00       	call   3c15 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2b4b:	83 ec 08             	sub    $0x8,%esp
    2b4e:	68 a3 52 00 00       	push   $0x52a3
    2b53:	68 07 53 00 00       	push   $0x5307
    2b58:	e8 18 11 00 00       	call   3c75 <link>
    2b5d:	83 c4 10             	add    $0x10,%esp
    2b60:	85 c0                	test   %eax,%eax
    2b62:	75 17                	jne    2b7b <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2b64:	83 ec 08             	sub    $0x8,%esp
    2b67:	68 10 53 00 00       	push   $0x5310
    2b6c:	6a 01                	push   $0x1
    2b6e:	e8 3e 12 00 00       	call   3db1 <printf>
    2b73:	83 c4 10             	add    $0x10,%esp
    exit();
    2b76:	e8 9a 10 00 00       	call   3c15 <exit>
  }
  if(unlink("dirfile") != 0){
    2b7b:	83 ec 0c             	sub    $0xc,%esp
    2b7e:	68 6a 52 00 00       	push   $0x526a
    2b83:	e8 dd 10 00 00       	call   3c65 <unlink>
    2b88:	83 c4 10             	add    $0x10,%esp
    2b8b:	85 c0                	test   %eax,%eax
    2b8d:	74 17                	je     2ba6 <dirfile+0x19e>
    printf(1, "unlink dirfile failed!\n");
    2b8f:	83 ec 08             	sub    $0x8,%esp
    2b92:	68 2f 53 00 00       	push   $0x532f
    2b97:	6a 01                	push   $0x1
    2b99:	e8 13 12 00 00       	call   3db1 <printf>
    2b9e:	83 c4 10             	add    $0x10,%esp
    exit();
    2ba1:	e8 6f 10 00 00       	call   3c15 <exit>
  }

  fd = open(".", O_RDWR);
    2ba6:	83 ec 08             	sub    $0x8,%esp
    2ba9:	6a 02                	push   $0x2
    2bab:	68 d7 48 00 00       	push   $0x48d7
    2bb0:	e8 a0 10 00 00       	call   3c55 <open>
    2bb5:	83 c4 10             	add    $0x10,%esp
    2bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2bbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2bbf:	78 17                	js     2bd8 <dirfile+0x1d0>
    printf(1, "open . for writing succeeded!\n");
    2bc1:	83 ec 08             	sub    $0x8,%esp
    2bc4:	68 48 53 00 00       	push   $0x5348
    2bc9:	6a 01                	push   $0x1
    2bcb:	e8 e1 11 00 00       	call   3db1 <printf>
    2bd0:	83 c4 10             	add    $0x10,%esp
    exit();
    2bd3:	e8 3d 10 00 00       	call   3c15 <exit>
  }
  fd = open(".", 0);
    2bd8:	83 ec 08             	sub    $0x8,%esp
    2bdb:	6a 00                	push   $0x0
    2bdd:	68 d7 48 00 00       	push   $0x48d7
    2be2:	e8 6e 10 00 00       	call   3c55 <open>
    2be7:	83 c4 10             	add    $0x10,%esp
    2bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2bed:	83 ec 04             	sub    $0x4,%esp
    2bf0:	6a 01                	push   $0x1
    2bf2:	68 0e 45 00 00       	push   $0x450e
    2bf7:	ff 75 f4             	pushl  -0xc(%ebp)
    2bfa:	e8 36 10 00 00       	call   3c35 <write>
    2bff:	83 c4 10             	add    $0x10,%esp
    2c02:	85 c0                	test   %eax,%eax
    2c04:	7e 17                	jle    2c1d <dirfile+0x215>
    printf(1, "write . succeeded!\n");
    2c06:	83 ec 08             	sub    $0x8,%esp
    2c09:	68 67 53 00 00       	push   $0x5367
    2c0e:	6a 01                	push   $0x1
    2c10:	e8 9c 11 00 00       	call   3db1 <printf>
    2c15:	83 c4 10             	add    $0x10,%esp
    exit();
    2c18:	e8 f8 0f 00 00       	call   3c15 <exit>
  }
  close(fd);
    2c1d:	83 ec 0c             	sub    $0xc,%esp
    2c20:	ff 75 f4             	pushl  -0xc(%ebp)
    2c23:	e8 15 10 00 00       	call   3c3d <close>
    2c28:	83 c4 10             	add    $0x10,%esp

  printf(1, "dir vs file OK\n");
    2c2b:	83 ec 08             	sub    $0x8,%esp
    2c2e:	68 7b 53 00 00       	push   $0x537b
    2c33:	6a 01                	push   $0x1
    2c35:	e8 77 11 00 00       	call   3db1 <printf>
    2c3a:	83 c4 10             	add    $0x10,%esp
}
    2c3d:	90                   	nop
    2c3e:	c9                   	leave  
    2c3f:	c3                   	ret    

00002c40 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2c40:	55                   	push   %ebp
    2c41:	89 e5                	mov    %esp,%ebp
    2c43:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2c46:	83 ec 08             	sub    $0x8,%esp
    2c49:	68 8b 53 00 00       	push   $0x538b
    2c4e:	6a 01                	push   $0x1
    2c50:	e8 5c 11 00 00       	call   3db1 <printf>
    2c55:	83 c4 10             	add    $0x10,%esp

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2c58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2c5f:	e9 e7 00 00 00       	jmp    2d4b <iref+0x10b>
    if(mkdir("irefd") != 0){
    2c64:	83 ec 0c             	sub    $0xc,%esp
    2c67:	68 9c 53 00 00       	push   $0x539c
    2c6c:	e8 0c 10 00 00       	call   3c7d <mkdir>
    2c71:	83 c4 10             	add    $0x10,%esp
    2c74:	85 c0                	test   %eax,%eax
    2c76:	74 17                	je     2c8f <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2c78:	83 ec 08             	sub    $0x8,%esp
    2c7b:	68 a2 53 00 00       	push   $0x53a2
    2c80:	6a 01                	push   $0x1
    2c82:	e8 2a 11 00 00       	call   3db1 <printf>
    2c87:	83 c4 10             	add    $0x10,%esp
      exit();
    2c8a:	e8 86 0f 00 00       	call   3c15 <exit>
    }
    if(chdir("irefd") != 0){
    2c8f:	83 ec 0c             	sub    $0xc,%esp
    2c92:	68 9c 53 00 00       	push   $0x539c
    2c97:	e8 e9 0f 00 00       	call   3c85 <chdir>
    2c9c:	83 c4 10             	add    $0x10,%esp
    2c9f:	85 c0                	test   %eax,%eax
    2ca1:	74 17                	je     2cba <iref+0x7a>
      printf(1, "chdir irefd failed\n");
    2ca3:	83 ec 08             	sub    $0x8,%esp
    2ca6:	68 b6 53 00 00       	push   $0x53b6
    2cab:	6a 01                	push   $0x1
    2cad:	e8 ff 10 00 00       	call   3db1 <printf>
    2cb2:	83 c4 10             	add    $0x10,%esp
      exit();
    2cb5:	e8 5b 0f 00 00       	call   3c15 <exit>
    }

    mkdir("");
    2cba:	83 ec 0c             	sub    $0xc,%esp
    2cbd:	68 ca 53 00 00       	push   $0x53ca
    2cc2:	e8 b6 0f 00 00       	call   3c7d <mkdir>
    2cc7:	83 c4 10             	add    $0x10,%esp
    link("README", "");
    2cca:	83 ec 08             	sub    $0x8,%esp
    2ccd:	68 ca 53 00 00       	push   $0x53ca
    2cd2:	68 07 53 00 00       	push   $0x5307
    2cd7:	e8 99 0f 00 00       	call   3c75 <link>
    2cdc:	83 c4 10             	add    $0x10,%esp
    fd = open("", O_CREATE);
    2cdf:	83 ec 08             	sub    $0x8,%esp
    2ce2:	68 00 02 00 00       	push   $0x200
    2ce7:	68 ca 53 00 00       	push   $0x53ca
    2cec:	e8 64 0f 00 00       	call   3c55 <open>
    2cf1:	83 c4 10             	add    $0x10,%esp
    2cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2cf7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2cfb:	78 0e                	js     2d0b <iref+0xcb>
      close(fd);
    2cfd:	83 ec 0c             	sub    $0xc,%esp
    2d00:	ff 75 f0             	pushl  -0x10(%ebp)
    2d03:	e8 35 0f 00 00       	call   3c3d <close>
    2d08:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2d0b:	83 ec 08             	sub    $0x8,%esp
    2d0e:	68 00 02 00 00       	push   $0x200
    2d13:	68 cb 53 00 00       	push   $0x53cb
    2d18:	e8 38 0f 00 00       	call   3c55 <open>
    2d1d:	83 c4 10             	add    $0x10,%esp
    2d20:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2d23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2d27:	78 0e                	js     2d37 <iref+0xf7>
      close(fd);
    2d29:	83 ec 0c             	sub    $0xc,%esp
    2d2c:	ff 75 f0             	pushl  -0x10(%ebp)
    2d2f:	e8 09 0f 00 00       	call   3c3d <close>
    2d34:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2d37:	83 ec 0c             	sub    $0xc,%esp
    2d3a:	68 cb 53 00 00       	push   $0x53cb
    2d3f:	e8 21 0f 00 00       	call   3c65 <unlink>
    2d44:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 50 + 1; i++){
    2d47:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2d4b:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    2d4f:	0f 8e 0f ff ff ff    	jle    2c64 <iref+0x24>
  }

  chdir("/");
    2d55:	83 ec 0c             	sub    $0xc,%esp
    2d58:	68 ee 51 00 00       	push   $0x51ee
    2d5d:	e8 23 0f 00 00       	call   3c85 <chdir>
    2d62:	83 c4 10             	add    $0x10,%esp
  printf(1, "empty file name OK\n");
    2d65:	83 ec 08             	sub    $0x8,%esp
    2d68:	68 ce 53 00 00       	push   $0x53ce
    2d6d:	6a 01                	push   $0x1
    2d6f:	e8 3d 10 00 00       	call   3db1 <printf>
    2d74:	83 c4 10             	add    $0x10,%esp
}
    2d77:	90                   	nop
    2d78:	c9                   	leave  
    2d79:	c3                   	ret    

00002d7a <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2d7a:	55                   	push   %ebp
    2d7b:	89 e5                	mov    %esp,%ebp
    2d7d:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
    2d80:	83 ec 08             	sub    $0x8,%esp
    2d83:	68 e2 53 00 00       	push   $0x53e2
    2d88:	6a 01                	push   $0x1
    2d8a:	e8 22 10 00 00       	call   3db1 <printf>
    2d8f:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    2d92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2d99:	eb 1d                	jmp    2db8 <forktest+0x3e>
    pid = fork();
    2d9b:	e8 6d 0e 00 00       	call   3c0d <fork>
    2da0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    2da3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2da7:	78 1a                	js     2dc3 <forktest+0x49>
      break;
    if(pid == 0)
    2da9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2dad:	75 05                	jne    2db4 <forktest+0x3a>
      exit();
    2daf:	e8 61 0e 00 00       	call   3c15 <exit>
  for(n=0; n<1000; n++){
    2db4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2db8:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    2dbf:	7e da                	jle    2d9b <forktest+0x21>
    2dc1:	eb 01                	jmp    2dc4 <forktest+0x4a>
      break;
    2dc3:	90                   	nop
  }
  
  if(n == 1000){
    2dc4:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    2dcb:	75 3b                	jne    2e08 <forktest+0x8e>
    printf(1, "fork claimed to work 1000 times!\n");
    2dcd:	83 ec 08             	sub    $0x8,%esp
    2dd0:	68 f0 53 00 00       	push   $0x53f0
    2dd5:	6a 01                	push   $0x1
    2dd7:	e8 d5 0f 00 00       	call   3db1 <printf>
    2ddc:	83 c4 10             	add    $0x10,%esp
    exit();
    2ddf:	e8 31 0e 00 00       	call   3c15 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
    2de4:	e8 34 0e 00 00       	call   3c1d <wait>
    2de9:	85 c0                	test   %eax,%eax
    2deb:	79 17                	jns    2e04 <forktest+0x8a>
      printf(1, "wait stopped early\n");
    2ded:	83 ec 08             	sub    $0x8,%esp
    2df0:	68 12 54 00 00       	push   $0x5412
    2df5:	6a 01                	push   $0x1
    2df7:	e8 b5 0f 00 00       	call   3db1 <printf>
    2dfc:	83 c4 10             	add    $0x10,%esp
      exit();
    2dff:	e8 11 0e 00 00       	call   3c15 <exit>
  for(; n > 0; n--){
    2e04:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    2e08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e0c:	7f d6                	jg     2de4 <forktest+0x6a>
    }
  }
  
  if(wait() != -1){
    2e0e:	e8 0a 0e 00 00       	call   3c1d <wait>
    2e13:	83 f8 ff             	cmp    $0xffffffff,%eax
    2e16:	74 17                	je     2e2f <forktest+0xb5>
    printf(1, "wait got too many\n");
    2e18:	83 ec 08             	sub    $0x8,%esp
    2e1b:	68 26 54 00 00       	push   $0x5426
    2e20:	6a 01                	push   $0x1
    2e22:	e8 8a 0f 00 00       	call   3db1 <printf>
    2e27:	83 c4 10             	add    $0x10,%esp
    exit();
    2e2a:	e8 e6 0d 00 00       	call   3c15 <exit>
  }
  
  printf(1, "fork test OK\n");
    2e2f:	83 ec 08             	sub    $0x8,%esp
    2e32:	68 39 54 00 00       	push   $0x5439
    2e37:	6a 01                	push   $0x1
    2e39:	e8 73 0f 00 00       	call   3db1 <printf>
    2e3e:	83 c4 10             	add    $0x10,%esp
}
    2e41:	90                   	nop
    2e42:	c9                   	leave  
    2e43:	c3                   	ret    

00002e44 <sbrktest>:

void
sbrktest(void)
{
    2e44:	55                   	push   %ebp
    2e45:	89 e5                	mov    %esp,%ebp
    2e47:	83 ec 68             	sub    $0x68,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    2e4a:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    2e4f:	83 ec 08             	sub    $0x8,%esp
    2e52:	68 47 54 00 00       	push   $0x5447
    2e57:	50                   	push   %eax
    2e58:	e8 54 0f 00 00       	call   3db1 <printf>
    2e5d:	83 c4 10             	add    $0x10,%esp
  oldbrk = sbrk(0);
    2e60:	83 ec 0c             	sub    $0xc,%esp
    2e63:	6a 00                	push   $0x0
    2e65:	e8 33 0e 00 00       	call   3c9d <sbrk>
    2e6a:	83 c4 10             	add    $0x10,%esp
    2e6d:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    2e70:	83 ec 0c             	sub    $0xc,%esp
    2e73:	6a 00                	push   $0x0
    2e75:	e8 23 0e 00 00       	call   3c9d <sbrk>
    2e7a:	83 c4 10             	add    $0x10,%esp
    2e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    2e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2e87:	eb 4f                	jmp    2ed8 <sbrktest+0x94>
    b = sbrk(1);
    2e89:	83 ec 0c             	sub    $0xc,%esp
    2e8c:	6a 01                	push   $0x1
    2e8e:	e8 0a 0e 00 00       	call   3c9d <sbrk>
    2e93:	83 c4 10             	add    $0x10,%esp
    2e96:	89 45 d0             	mov    %eax,-0x30(%ebp)
    if(b != a){
    2e99:	8b 45 d0             	mov    -0x30(%ebp),%eax
    2e9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2e9f:	74 24                	je     2ec5 <sbrktest+0x81>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2ea1:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    2ea6:	83 ec 0c             	sub    $0xc,%esp
    2ea9:	ff 75 d0             	pushl  -0x30(%ebp)
    2eac:	ff 75 f4             	pushl  -0xc(%ebp)
    2eaf:	ff 75 f0             	pushl  -0x10(%ebp)
    2eb2:	68 52 54 00 00       	push   $0x5452
    2eb7:	50                   	push   %eax
    2eb8:	e8 f4 0e 00 00       	call   3db1 <printf>
    2ebd:	83 c4 20             	add    $0x20,%esp
      exit();
    2ec0:	e8 50 0d 00 00       	call   3c15 <exit>
    }
    *b = 1;
    2ec5:	8b 45 d0             	mov    -0x30(%ebp),%eax
    2ec8:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    2ecb:	8b 45 d0             	mov    -0x30(%ebp),%eax
    2ece:	83 c0 01             	add    $0x1,%eax
    2ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; i < 5000; i++){ 
    2ed4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2ed8:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    2edf:	7e a8                	jle    2e89 <sbrktest+0x45>
  }
  pid = fork();
    2ee1:	e8 27 0d 00 00       	call   3c0d <fork>
    2ee6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(pid < 0){
    2ee9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2eed:	79 1b                	jns    2f0a <sbrktest+0xc6>
    printf(stdout, "sbrk test fork failed\n");
    2eef:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    2ef4:	83 ec 08             	sub    $0x8,%esp
    2ef7:	68 6d 54 00 00       	push   $0x546d
    2efc:	50                   	push   %eax
    2efd:	e8 af 0e 00 00       	call   3db1 <printf>
    2f02:	83 c4 10             	add    $0x10,%esp
    exit();
    2f05:	e8 0b 0d 00 00       	call   3c15 <exit>
  }
  c = sbrk(1);
    2f0a:	83 ec 0c             	sub    $0xc,%esp
    2f0d:	6a 01                	push   $0x1
    2f0f:	e8 89 0d 00 00       	call   3c9d <sbrk>
    2f14:	83 c4 10             	add    $0x10,%esp
    2f17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c = sbrk(1);
    2f1a:	83 ec 0c             	sub    $0xc,%esp
    2f1d:	6a 01                	push   $0x1
    2f1f:	e8 79 0d 00 00       	call   3c9d <sbrk>
    2f24:	83 c4 10             	add    $0x10,%esp
    2f27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a + 1){
    2f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f2d:	83 c0 01             	add    $0x1,%eax
    2f30:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
    2f33:	74 1b                	je     2f50 <sbrktest+0x10c>
    printf(stdout, "sbrk test failed post-fork\n");
    2f35:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    2f3a:	83 ec 08             	sub    $0x8,%esp
    2f3d:	68 84 54 00 00       	push   $0x5484
    2f42:	50                   	push   %eax
    2f43:	e8 69 0e 00 00       	call   3db1 <printf>
    2f48:	83 c4 10             	add    $0x10,%esp
    exit();
    2f4b:	e8 c5 0c 00 00       	call   3c15 <exit>
  }
  if(pid == 0)
    2f50:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2f54:	75 05                	jne    2f5b <sbrktest+0x117>
    exit();
    2f56:	e8 ba 0c 00 00       	call   3c15 <exit>
  wait();
    2f5b:	e8 bd 0c 00 00       	call   3c1d <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    2f60:	83 ec 0c             	sub    $0xc,%esp
    2f63:	6a 00                	push   $0x0
    2f65:	e8 33 0d 00 00       	call   3c9d <sbrk>
    2f6a:	83 c4 10             	add    $0x10,%esp
    2f6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    2f70:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2f73:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2f78:	29 d0                	sub    %edx,%eax
    2f7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  p = sbrk(amt);
    2f7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
    2f80:	83 ec 0c             	sub    $0xc,%esp
    2f83:	50                   	push   %eax
    2f84:	e8 14 0d 00 00       	call   3c9d <sbrk>
    2f89:	83 c4 10             	add    $0x10,%esp
    2f8c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (p != a) { 
    2f8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
    2f92:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2f95:	74 1b                	je     2fb2 <sbrktest+0x16e>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    2f97:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    2f9c:	83 ec 08             	sub    $0x8,%esp
    2f9f:	68 a0 54 00 00       	push   $0x54a0
    2fa4:	50                   	push   %eax
    2fa5:	e8 07 0e 00 00       	call   3db1 <printf>
    2faa:	83 c4 10             	add    $0x10,%esp
    exit();
    2fad:	e8 63 0c 00 00       	call   3c15 <exit>
  }
  lastaddr = (char*) (BIG-1);
    2fb2:	c7 45 d8 ff ff 3f 06 	movl   $0x63fffff,-0x28(%ebp)
  *lastaddr = 99;
    2fb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
    2fbc:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    2fbf:	83 ec 0c             	sub    $0xc,%esp
    2fc2:	6a 00                	push   $0x0
    2fc4:	e8 d4 0c 00 00       	call   3c9d <sbrk>
    2fc9:	83 c4 10             	add    $0x10,%esp
    2fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    2fcf:	83 ec 0c             	sub    $0xc,%esp
    2fd2:	68 00 f0 ff ff       	push   $0xfffff000
    2fd7:	e8 c1 0c 00 00       	call   3c9d <sbrk>
    2fdc:	83 c4 10             	add    $0x10,%esp
    2fdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c == (char*)0xffffffff){
    2fe2:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
    2fe6:	75 1b                	jne    3003 <sbrktest+0x1bf>
    printf(stdout, "sbrk could not deallocate\n");
    2fe8:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    2fed:	83 ec 08             	sub    $0x8,%esp
    2ff0:	68 de 54 00 00       	push   $0x54de
    2ff5:	50                   	push   %eax
    2ff6:	e8 b6 0d 00 00       	call   3db1 <printf>
    2ffb:	83 c4 10             	add    $0x10,%esp
    exit();
    2ffe:	e8 12 0c 00 00       	call   3c15 <exit>
  }
  c = sbrk(0);
    3003:	83 ec 0c             	sub    $0xc,%esp
    3006:	6a 00                	push   $0x0
    3008:	e8 90 0c 00 00       	call   3c9d <sbrk>
    300d:	83 c4 10             	add    $0x10,%esp
    3010:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a - 4096){
    3013:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3016:	2d 00 10 00 00       	sub    $0x1000,%eax
    301b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
    301e:	74 1e                	je     303e <sbrktest+0x1fa>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3020:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    3025:	ff 75 e4             	pushl  -0x1c(%ebp)
    3028:	ff 75 f4             	pushl  -0xc(%ebp)
    302b:	68 fc 54 00 00       	push   $0x54fc
    3030:	50                   	push   %eax
    3031:	e8 7b 0d 00 00       	call   3db1 <printf>
    3036:	83 c4 10             	add    $0x10,%esp
    exit();
    3039:	e8 d7 0b 00 00       	call   3c15 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    303e:	83 ec 0c             	sub    $0xc,%esp
    3041:	6a 00                	push   $0x0
    3043:	e8 55 0c 00 00       	call   3c9d <sbrk>
    3048:	83 c4 10             	add    $0x10,%esp
    304b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    304e:	83 ec 0c             	sub    $0xc,%esp
    3051:	68 00 10 00 00       	push   $0x1000
    3056:	e8 42 0c 00 00       	call   3c9d <sbrk>
    305b:	83 c4 10             	add    $0x10,%esp
    305e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    3061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3064:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3067:	75 1a                	jne    3083 <sbrktest+0x23f>
    3069:	83 ec 0c             	sub    $0xc,%esp
    306c:	6a 00                	push   $0x0
    306e:	e8 2a 0c 00 00       	call   3c9d <sbrk>
    3073:	83 c4 10             	add    $0x10,%esp
    3076:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3079:	81 c2 00 10 00 00    	add    $0x1000,%edx
    307f:	39 d0                	cmp    %edx,%eax
    3081:	74 1e                	je     30a1 <sbrktest+0x25d>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3083:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    3088:	ff 75 e4             	pushl  -0x1c(%ebp)
    308b:	ff 75 f4             	pushl  -0xc(%ebp)
    308e:	68 34 55 00 00       	push   $0x5534
    3093:	50                   	push   %eax
    3094:	e8 18 0d 00 00       	call   3db1 <printf>
    3099:	83 c4 10             	add    $0x10,%esp
    exit();
    309c:	e8 74 0b 00 00       	call   3c15 <exit>
  }
  if(*lastaddr == 99){
    30a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
    30a4:	0f b6 00             	movzbl (%eax),%eax
    30a7:	3c 63                	cmp    $0x63,%al
    30a9:	75 1b                	jne    30c6 <sbrktest+0x282>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    30ab:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    30b0:	83 ec 08             	sub    $0x8,%esp
    30b3:	68 5c 55 00 00       	push   $0x555c
    30b8:	50                   	push   %eax
    30b9:	e8 f3 0c 00 00       	call   3db1 <printf>
    30be:	83 c4 10             	add    $0x10,%esp
    exit();
    30c1:	e8 4f 0b 00 00       	call   3c15 <exit>
  }

  a = sbrk(0);
    30c6:	83 ec 0c             	sub    $0xc,%esp
    30c9:	6a 00                	push   $0x0
    30cb:	e8 cd 0b 00 00       	call   3c9d <sbrk>
    30d0:	83 c4 10             	add    $0x10,%esp
    30d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    30d6:	83 ec 0c             	sub    $0xc,%esp
    30d9:	6a 00                	push   $0x0
    30db:	e8 bd 0b 00 00       	call   3c9d <sbrk>
    30e0:	83 c4 10             	add    $0x10,%esp
    30e3:	89 c2                	mov    %eax,%edx
    30e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    30e8:	29 d0                	sub    %edx,%eax
    30ea:	83 ec 0c             	sub    $0xc,%esp
    30ed:	50                   	push   %eax
    30ee:	e8 aa 0b 00 00       	call   3c9d <sbrk>
    30f3:	83 c4 10             	add    $0x10,%esp
    30f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a){
    30f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    30fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    30ff:	74 1e                	je     311f <sbrktest+0x2db>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    3101:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    3106:	ff 75 e4             	pushl  -0x1c(%ebp)
    3109:	ff 75 f4             	pushl  -0xc(%ebp)
    310c:	68 8c 55 00 00       	push   $0x558c
    3111:	50                   	push   %eax
    3112:	e8 9a 0c 00 00       	call   3db1 <printf>
    3117:	83 c4 10             	add    $0x10,%esp
    exit();
    311a:	e8 f6 0a 00 00       	call   3c15 <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    311f:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    3126:	eb 76                	jmp    319e <sbrktest+0x35a>
    ppid = getpid();
    3128:	e8 68 0b 00 00       	call   3c95 <getpid>
    312d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    pid = fork();
    3130:	e8 d8 0a 00 00       	call   3c0d <fork>
    3135:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    3138:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    313c:	79 1b                	jns    3159 <sbrktest+0x315>
      printf(stdout, "fork failed\n");
    313e:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    3143:	83 ec 08             	sub    $0x8,%esp
    3146:	68 55 45 00 00       	push   $0x4555
    314b:	50                   	push   %eax
    314c:	e8 60 0c 00 00       	call   3db1 <printf>
    3151:	83 c4 10             	add    $0x10,%esp
      exit();
    3154:	e8 bc 0a 00 00       	call   3c15 <exit>
    }
    if(pid == 0){
    3159:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    315d:	75 33                	jne    3192 <sbrktest+0x34e>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    315f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3162:	0f b6 00             	movzbl (%eax),%eax
    3165:	0f be d0             	movsbl %al,%edx
    3168:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    316d:	52                   	push   %edx
    316e:	ff 75 f4             	pushl  -0xc(%ebp)
    3171:	68 ad 55 00 00       	push   $0x55ad
    3176:	50                   	push   %eax
    3177:	e8 35 0c 00 00       	call   3db1 <printf>
    317c:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
    317f:	83 ec 0c             	sub    $0xc,%esp
    3182:	ff 75 d4             	pushl  -0x2c(%ebp)
    3185:	e8 bb 0a 00 00       	call   3c45 <kill>
    318a:	83 c4 10             	add    $0x10,%esp
      exit();
    318d:	e8 83 0a 00 00       	call   3c15 <exit>
    }
    wait();
    3192:	e8 86 0a 00 00       	call   3c1d <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3197:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    319e:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    31a5:	76 81                	jbe    3128 <sbrktest+0x2e4>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    31a7:	83 ec 0c             	sub    $0xc,%esp
    31aa:	8d 45 c8             	lea    -0x38(%ebp),%eax
    31ad:	50                   	push   %eax
    31ae:	e8 72 0a 00 00       	call   3c25 <pipe>
    31b3:	83 c4 10             	add    $0x10,%esp
    31b6:	85 c0                	test   %eax,%eax
    31b8:	74 17                	je     31d1 <sbrktest+0x38d>
    printf(1, "pipe() failed\n");
    31ba:	83 ec 08             	sub    $0x8,%esp
    31bd:	68 a9 44 00 00       	push   $0x44a9
    31c2:	6a 01                	push   $0x1
    31c4:	e8 e8 0b 00 00       	call   3db1 <printf>
    31c9:	83 c4 10             	add    $0x10,%esp
    exit();
    31cc:	e8 44 0a 00 00       	call   3c15 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    31d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    31d8:	e9 86 00 00 00       	jmp    3263 <sbrktest+0x41f>
    if((pids[i] = fork()) == 0){
    31dd:	e8 2b 0a 00 00       	call   3c0d <fork>
    31e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
    31e5:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    31e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    31ec:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    31f0:	85 c0                	test   %eax,%eax
    31f2:	75 4a                	jne    323e <sbrktest+0x3fa>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    31f4:	83 ec 0c             	sub    $0xc,%esp
    31f7:	6a 00                	push   $0x0
    31f9:	e8 9f 0a 00 00       	call   3c9d <sbrk>
    31fe:	83 c4 10             	add    $0x10,%esp
    3201:	89 c2                	mov    %eax,%edx
    3203:	b8 00 00 40 06       	mov    $0x6400000,%eax
    3208:	29 d0                	sub    %edx,%eax
    320a:	83 ec 0c             	sub    $0xc,%esp
    320d:	50                   	push   %eax
    320e:	e8 8a 0a 00 00       	call   3c9d <sbrk>
    3213:	83 c4 10             	add    $0x10,%esp
      write(fds[1], "x", 1);
    3216:	8b 45 cc             	mov    -0x34(%ebp),%eax
    3219:	83 ec 04             	sub    $0x4,%esp
    321c:	6a 01                	push   $0x1
    321e:	68 0e 45 00 00       	push   $0x450e
    3223:	50                   	push   %eax
    3224:	e8 0c 0a 00 00       	call   3c35 <write>
    3229:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    322c:	83 ec 0c             	sub    $0xc,%esp
    322f:	68 e8 03 00 00       	push   $0x3e8
    3234:	e8 6c 0a 00 00       	call   3ca5 <sleep>
    3239:	83 c4 10             	add    $0x10,%esp
    323c:	eb ee                	jmp    322c <sbrktest+0x3e8>
    }
    if(pids[i] != -1)
    323e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3241:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3245:	83 f8 ff             	cmp    $0xffffffff,%eax
    3248:	74 15                	je     325f <sbrktest+0x41b>
      read(fds[0], &scratch, 1);
    324a:	8b 45 c8             	mov    -0x38(%ebp),%eax
    324d:	83 ec 04             	sub    $0x4,%esp
    3250:	6a 01                	push   $0x1
    3252:	8d 55 9f             	lea    -0x61(%ebp),%edx
    3255:	52                   	push   %edx
    3256:	50                   	push   %eax
    3257:	e8 d1 09 00 00       	call   3c2d <read>
    325c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    325f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3263:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3266:	83 f8 09             	cmp    $0x9,%eax
    3269:	0f 86 6e ff ff ff    	jbe    31dd <sbrktest+0x399>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    326f:	83 ec 0c             	sub    $0xc,%esp
    3272:	68 00 10 00 00       	push   $0x1000
    3277:	e8 21 0a 00 00       	call   3c9d <sbrk>
    327c:	83 c4 10             	add    $0x10,%esp
    327f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3282:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3289:	eb 2b                	jmp    32b6 <sbrktest+0x472>
    if(pids[i] == -1)
    328b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    328e:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3292:	83 f8 ff             	cmp    $0xffffffff,%eax
    3295:	74 1a                	je     32b1 <sbrktest+0x46d>
      continue;
    kill(pids[i]);
    3297:	8b 45 f0             	mov    -0x10(%ebp),%eax
    329a:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    329e:	83 ec 0c             	sub    $0xc,%esp
    32a1:	50                   	push   %eax
    32a2:	e8 9e 09 00 00       	call   3c45 <kill>
    32a7:	83 c4 10             	add    $0x10,%esp
    wait();
    32aa:	e8 6e 09 00 00       	call   3c1d <wait>
    32af:	eb 01                	jmp    32b2 <sbrktest+0x46e>
      continue;
    32b1:	90                   	nop
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    32b2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    32b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    32b9:	83 f8 09             	cmp    $0x9,%eax
    32bc:	76 cd                	jbe    328b <sbrktest+0x447>
  }
  if(c == (char*)0xffffffff){
    32be:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
    32c2:	75 1b                	jne    32df <sbrktest+0x49b>
    printf(stdout, "failed sbrk leaked memory\n");
    32c4:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    32c9:	83 ec 08             	sub    $0x8,%esp
    32cc:	68 c6 55 00 00       	push   $0x55c6
    32d1:	50                   	push   %eax
    32d2:	e8 da 0a 00 00       	call   3db1 <printf>
    32d7:	83 c4 10             	add    $0x10,%esp
    exit();
    32da:	e8 36 09 00 00       	call   3c15 <exit>
  }

  if(sbrk(0) > oldbrk)
    32df:	83 ec 0c             	sub    $0xc,%esp
    32e2:	6a 00                	push   $0x0
    32e4:	e8 b4 09 00 00       	call   3c9d <sbrk>
    32e9:	83 c4 10             	add    $0x10,%esp
    32ec:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    32ef:	73 20                	jae    3311 <sbrktest+0x4cd>
    sbrk(-(sbrk(0) - oldbrk));
    32f1:	83 ec 0c             	sub    $0xc,%esp
    32f4:	6a 00                	push   $0x0
    32f6:	e8 a2 09 00 00       	call   3c9d <sbrk>
    32fb:	83 c4 10             	add    $0x10,%esp
    32fe:	89 c2                	mov    %eax,%edx
    3300:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3303:	29 d0                	sub    %edx,%eax
    3305:	83 ec 0c             	sub    $0xc,%esp
    3308:	50                   	push   %eax
    3309:	e8 8f 09 00 00       	call   3c9d <sbrk>
    330e:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "sbrk test OK\n");
    3311:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    3316:	83 ec 08             	sub    $0x8,%esp
    3319:	68 e1 55 00 00       	push   $0x55e1
    331e:	50                   	push   %eax
    331f:	e8 8d 0a 00 00       	call   3db1 <printf>
    3324:	83 c4 10             	add    $0x10,%esp
}
    3327:	90                   	nop
    3328:	c9                   	leave  
    3329:	c3                   	ret    

0000332a <validateint>:

void
validateint(int *p)
{
    332a:	55                   	push   %ebp
    332b:	89 e5                	mov    %esp,%ebp
    332d:	53                   	push   %ebx
    332e:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    3331:	b8 0d 00 00 00       	mov    $0xd,%eax
    3336:	8b 55 08             	mov    0x8(%ebp),%edx
    3339:	89 d1                	mov    %edx,%ecx
    333b:	89 e3                	mov    %esp,%ebx
    333d:	89 cc                	mov    %ecx,%esp
    333f:	cd 40                	int    $0x40
    3341:	89 dc                	mov    %ebx,%esp
    3343:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3346:	90                   	nop
    3347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    334a:	c9                   	leave  
    334b:	c3                   	ret    

0000334c <validatetest>:

void
validatetest(void)
{
    334c:	55                   	push   %ebp
    334d:	89 e5                	mov    %esp,%ebp
    334f:	83 ec 18             	sub    $0x18,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3352:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    3357:	83 ec 08             	sub    $0x8,%esp
    335a:	68 ef 55 00 00       	push   $0x55ef
    335f:	50                   	push   %eax
    3360:	e8 4c 0a 00 00       	call   3db1 <printf>
    3365:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;
    3368:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    336f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3376:	e9 8a 00 00 00       	jmp    3405 <validatetest+0xb9>
    if((pid = fork()) == 0){
    337b:	e8 8d 08 00 00       	call   3c0d <fork>
    3380:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3383:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3387:	75 14                	jne    339d <validatetest+0x51>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    3389:	8b 45 f4             	mov    -0xc(%ebp),%eax
    338c:	83 ec 0c             	sub    $0xc,%esp
    338f:	50                   	push   %eax
    3390:	e8 95 ff ff ff       	call   332a <validateint>
    3395:	83 c4 10             	add    $0x10,%esp
      exit();
    3398:	e8 78 08 00 00       	call   3c15 <exit>
    }
    sleep(0);
    339d:	83 ec 0c             	sub    $0xc,%esp
    33a0:	6a 00                	push   $0x0
    33a2:	e8 fe 08 00 00       	call   3ca5 <sleep>
    33a7:	83 c4 10             	add    $0x10,%esp
    sleep(0);
    33aa:	83 ec 0c             	sub    $0xc,%esp
    33ad:	6a 00                	push   $0x0
    33af:	e8 f1 08 00 00       	call   3ca5 <sleep>
    33b4:	83 c4 10             	add    $0x10,%esp
    kill(pid);
    33b7:	83 ec 0c             	sub    $0xc,%esp
    33ba:	ff 75 ec             	pushl  -0x14(%ebp)
    33bd:	e8 83 08 00 00       	call   3c45 <kill>
    33c2:	83 c4 10             	add    $0x10,%esp
    wait();
    33c5:	e8 53 08 00 00       	call   3c1d <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    33ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    33cd:	83 ec 08             	sub    $0x8,%esp
    33d0:	50                   	push   %eax
    33d1:	68 fe 55 00 00       	push   $0x55fe
    33d6:	e8 9a 08 00 00       	call   3c75 <link>
    33db:	83 c4 10             	add    $0x10,%esp
    33de:	83 f8 ff             	cmp    $0xffffffff,%eax
    33e1:	74 1b                	je     33fe <validatetest+0xb2>
      printf(stdout, "link should not succeed\n");
    33e3:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    33e8:	83 ec 08             	sub    $0x8,%esp
    33eb:	68 09 56 00 00       	push   $0x5609
    33f0:	50                   	push   %eax
    33f1:	e8 bb 09 00 00       	call   3db1 <printf>
    33f6:	83 c4 10             	add    $0x10,%esp
      exit();
    33f9:	e8 17 08 00 00       	call   3c15 <exit>
  for(p = 0; p <= (uint)hi; p += 4096){
    33fe:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    3405:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3408:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    340b:	0f 86 6a ff ff ff    	jbe    337b <validatetest+0x2f>
    }
  }

  printf(stdout, "validate ok\n");
    3411:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    3416:	83 ec 08             	sub    $0x8,%esp
    3419:	68 22 56 00 00       	push   $0x5622
    341e:	50                   	push   %eax
    341f:	e8 8d 09 00 00       	call   3db1 <printf>
    3424:	83 c4 10             	add    $0x10,%esp
}
    3427:	90                   	nop
    3428:	c9                   	leave  
    3429:	c3                   	ret    

0000342a <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    342a:	55                   	push   %ebp
    342b:	89 e5                	mov    %esp,%ebp
    342d:	83 ec 18             	sub    $0x18,%esp
  int i;

  printf(stdout, "bss test\n");
    3430:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    3435:	83 ec 08             	sub    $0x8,%esp
    3438:	68 2f 56 00 00       	push   $0x562f
    343d:	50                   	push   %eax
    343e:	e8 6e 09 00 00       	call   3db1 <printf>
    3443:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    3446:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    344d:	eb 2e                	jmp    347d <bsstest+0x53>
    if(uninit[i] != '\0'){
    344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3452:	05 00 7f 00 00       	add    $0x7f00,%eax
    3457:	0f b6 00             	movzbl (%eax),%eax
    345a:	84 c0                	test   %al,%al
    345c:	74 1b                	je     3479 <bsstest+0x4f>
      printf(stdout, "bss test failed\n");
    345e:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    3463:	83 ec 08             	sub    $0x8,%esp
    3466:	68 39 56 00 00       	push   $0x5639
    346b:	50                   	push   %eax
    346c:	e8 40 09 00 00       	call   3db1 <printf>
    3471:	83 c4 10             	add    $0x10,%esp
      exit();
    3474:	e8 9c 07 00 00       	call   3c15 <exit>
  for(i = 0; i < sizeof(uninit); i++){
    3479:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3480:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    3485:	76 c8                	jbe    344f <bsstest+0x25>
    }
  }
  printf(stdout, "bss test ok\n");
    3487:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    348c:	83 ec 08             	sub    $0x8,%esp
    348f:	68 4a 56 00 00       	push   $0x564a
    3494:	50                   	push   %eax
    3495:	e8 17 09 00 00       	call   3db1 <printf>
    349a:	83 c4 10             	add    $0x10,%esp
}
    349d:	90                   	nop
    349e:	c9                   	leave  
    349f:	c3                   	ret    

000034a0 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    34a0:	55                   	push   %ebp
    34a1:	89 e5                	mov    %esp,%ebp
    34a3:	83 ec 18             	sub    $0x18,%esp
  int pid, fd;

  unlink("bigarg-ok");
    34a6:	83 ec 0c             	sub    $0xc,%esp
    34a9:	68 57 56 00 00       	push   $0x5657
    34ae:	e8 b2 07 00 00       	call   3c65 <unlink>
    34b3:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    34b6:	e8 52 07 00 00       	call   3c0d <fork>
    34bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    34be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    34c2:	0f 85 97 00 00 00    	jne    355f <bigargtest+0xbf>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    34c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    34cf:	eb 12                	jmp    34e3 <bigargtest+0x43>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    34d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34d4:	c7 04 85 20 a6 00 00 	movl   $0x5664,0xa620(,%eax,4)
    34db:	64 56 00 00 
    for(i = 0; i < MAXARG-1; i++)
    34df:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    34e3:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    34e7:	7e e8                	jle    34d1 <bigargtest+0x31>
    args[MAXARG-1] = 0;
    34e9:	c7 05 9c a6 00 00 00 	movl   $0x0,0xa69c
    34f0:	00 00 00 
    printf(stdout, "bigarg test\n");
    34f3:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    34f8:	83 ec 08             	sub    $0x8,%esp
    34fb:	68 41 57 00 00       	push   $0x5741
    3500:	50                   	push   %eax
    3501:	e8 ab 08 00 00       	call   3db1 <printf>
    3506:	83 c4 10             	add    $0x10,%esp
    exec("echo", args);
    3509:	83 ec 08             	sub    $0x8,%esp
    350c:	68 20 a6 00 00       	push   $0xa620
    3511:	68 68 41 00 00       	push   $0x4168
    3516:	e8 32 07 00 00       	call   3c4d <exec>
    351b:	83 c4 10             	add    $0x10,%esp
    printf(stdout, "bigarg test ok\n");
    351e:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    3523:	83 ec 08             	sub    $0x8,%esp
    3526:	68 4e 57 00 00       	push   $0x574e
    352b:	50                   	push   %eax
    352c:	e8 80 08 00 00       	call   3db1 <printf>
    3531:	83 c4 10             	add    $0x10,%esp
    fd = open("bigarg-ok", O_CREATE);
    3534:	83 ec 08             	sub    $0x8,%esp
    3537:	68 00 02 00 00       	push   $0x200
    353c:	68 57 56 00 00       	push   $0x5657
    3541:	e8 0f 07 00 00       	call   3c55 <open>
    3546:	83 c4 10             	add    $0x10,%esp
    3549:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    354c:	83 ec 0c             	sub    $0xc,%esp
    354f:	ff 75 ec             	pushl  -0x14(%ebp)
    3552:	e8 e6 06 00 00       	call   3c3d <close>
    3557:	83 c4 10             	add    $0x10,%esp
    exit();
    355a:	e8 b6 06 00 00       	call   3c15 <exit>
  } else if(pid < 0){
    355f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3563:	79 1b                	jns    3580 <bigargtest+0xe0>
    printf(stdout, "bigargtest: fork failed\n");
    3565:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    356a:	83 ec 08             	sub    $0x8,%esp
    356d:	68 5e 57 00 00       	push   $0x575e
    3572:	50                   	push   %eax
    3573:	e8 39 08 00 00       	call   3db1 <printf>
    3578:	83 c4 10             	add    $0x10,%esp
    exit();
    357b:	e8 95 06 00 00       	call   3c15 <exit>
  }
  wait();
    3580:	e8 98 06 00 00       	call   3c1d <wait>
  fd = open("bigarg-ok", 0);
    3585:	83 ec 08             	sub    $0x8,%esp
    3588:	6a 00                	push   $0x0
    358a:	68 57 56 00 00       	push   $0x5657
    358f:	e8 c1 06 00 00       	call   3c55 <open>
    3594:	83 c4 10             	add    $0x10,%esp
    3597:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    359a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    359e:	79 1b                	jns    35bb <bigargtest+0x11b>
    printf(stdout, "bigarg test failed!\n");
    35a0:	a1 b8 5e 00 00       	mov    0x5eb8,%eax
    35a5:	83 ec 08             	sub    $0x8,%esp
    35a8:	68 77 57 00 00       	push   $0x5777
    35ad:	50                   	push   %eax
    35ae:	e8 fe 07 00 00       	call   3db1 <printf>
    35b3:	83 c4 10             	add    $0x10,%esp
    exit();
    35b6:	e8 5a 06 00 00       	call   3c15 <exit>
  }
  close(fd);
    35bb:	83 ec 0c             	sub    $0xc,%esp
    35be:	ff 75 ec             	pushl  -0x14(%ebp)
    35c1:	e8 77 06 00 00       	call   3c3d <close>
    35c6:	83 c4 10             	add    $0x10,%esp
  unlink("bigarg-ok");
    35c9:	83 ec 0c             	sub    $0xc,%esp
    35cc:	68 57 56 00 00       	push   $0x5657
    35d1:	e8 8f 06 00 00       	call   3c65 <unlink>
    35d6:	83 c4 10             	add    $0x10,%esp
}
    35d9:	90                   	nop
    35da:	c9                   	leave  
    35db:	c3                   	ret    

000035dc <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    35dc:	55                   	push   %ebp
    35dd:	89 e5                	mov    %esp,%ebp
    35df:	53                   	push   %ebx
    35e0:	83 ec 64             	sub    $0x64,%esp
  int nfiles;
  int fsblocks = 0;
    35e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    35ea:	83 ec 08             	sub    $0x8,%esp
    35ed:	68 8c 57 00 00       	push   $0x578c
    35f2:	6a 01                	push   $0x1
    35f4:	e8 b8 07 00 00       	call   3db1 <printf>
    35f9:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    35fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    3603:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3607:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    360a:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    360f:	89 c8                	mov    %ecx,%eax
    3611:	f7 ea                	imul   %edx
    3613:	89 d0                	mov    %edx,%eax
    3615:	c1 f8 06             	sar    $0x6,%eax
    3618:	c1 f9 1f             	sar    $0x1f,%ecx
    361b:	89 ca                	mov    %ecx,%edx
    361d:	29 d0                	sub    %edx,%eax
    361f:	83 c0 30             	add    $0x30,%eax
    3622:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3625:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3628:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    362d:	89 d8                	mov    %ebx,%eax
    362f:	f7 ea                	imul   %edx
    3631:	89 d0                	mov    %edx,%eax
    3633:	c1 f8 06             	sar    $0x6,%eax
    3636:	89 da                	mov    %ebx,%edx
    3638:	c1 fa 1f             	sar    $0x1f,%edx
    363b:	29 d0                	sub    %edx,%eax
    363d:	89 c1                	mov    %eax,%ecx
    363f:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3645:	29 c3                	sub    %eax,%ebx
    3647:	89 d9                	mov    %ebx,%ecx
    3649:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    364e:	89 c8                	mov    %ecx,%eax
    3650:	f7 ea                	imul   %edx
    3652:	89 d0                	mov    %edx,%eax
    3654:	c1 f8 05             	sar    $0x5,%eax
    3657:	c1 f9 1f             	sar    $0x1f,%ecx
    365a:	89 ca                	mov    %ecx,%edx
    365c:	29 d0                	sub    %edx,%eax
    365e:	83 c0 30             	add    $0x30,%eax
    3661:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3664:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3667:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    366c:	89 d8                	mov    %ebx,%eax
    366e:	f7 ea                	imul   %edx
    3670:	89 d0                	mov    %edx,%eax
    3672:	c1 f8 05             	sar    $0x5,%eax
    3675:	89 da                	mov    %ebx,%edx
    3677:	c1 fa 1f             	sar    $0x1f,%edx
    367a:	29 d0                	sub    %edx,%eax
    367c:	89 c1                	mov    %eax,%ecx
    367e:	6b c1 64             	imul   $0x64,%ecx,%eax
    3681:	29 c3                	sub    %eax,%ebx
    3683:	89 d9                	mov    %ebx,%ecx
    3685:	ba 67 66 66 66       	mov    $0x66666667,%edx
    368a:	89 c8                	mov    %ecx,%eax
    368c:	f7 ea                	imul   %edx
    368e:	89 d0                	mov    %edx,%eax
    3690:	c1 f8 02             	sar    $0x2,%eax
    3693:	c1 f9 1f             	sar    $0x1f,%ecx
    3696:	89 ca                	mov    %ecx,%edx
    3698:	29 d0                	sub    %edx,%eax
    369a:	83 c0 30             	add    $0x30,%eax
    369d:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    36a0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    36a3:	ba 67 66 66 66       	mov    $0x66666667,%edx
    36a8:	89 c8                	mov    %ecx,%eax
    36aa:	f7 ea                	imul   %edx
    36ac:	89 d0                	mov    %edx,%eax
    36ae:	c1 f8 02             	sar    $0x2,%eax
    36b1:	89 cb                	mov    %ecx,%ebx
    36b3:	c1 fb 1f             	sar    $0x1f,%ebx
    36b6:	29 d8                	sub    %ebx,%eax
    36b8:	89 c2                	mov    %eax,%edx
    36ba:	89 d0                	mov    %edx,%eax
    36bc:	c1 e0 02             	shl    $0x2,%eax
    36bf:	01 d0                	add    %edx,%eax
    36c1:	01 c0                	add    %eax,%eax
    36c3:	29 c1                	sub    %eax,%ecx
    36c5:	89 ca                	mov    %ecx,%edx
    36c7:	89 d0                	mov    %edx,%eax
    36c9:	83 c0 30             	add    $0x30,%eax
    36cc:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    36cf:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    36d3:	83 ec 04             	sub    $0x4,%esp
    36d6:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    36d9:	50                   	push   %eax
    36da:	68 99 57 00 00       	push   $0x5799
    36df:	6a 01                	push   $0x1
    36e1:	e8 cb 06 00 00       	call   3db1 <printf>
    36e6:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    36e9:	83 ec 08             	sub    $0x8,%esp
    36ec:	68 02 02 00 00       	push   $0x202
    36f1:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    36f4:	50                   	push   %eax
    36f5:	e8 5b 05 00 00       	call   3c55 <open>
    36fa:	83 c4 10             	add    $0x10,%esp
    36fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    3700:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3704:	79 18                	jns    371e <fsfull+0x142>
      printf(1, "open %s failed\n", name);
    3706:	83 ec 04             	sub    $0x4,%esp
    3709:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    370c:	50                   	push   %eax
    370d:	68 a5 57 00 00       	push   $0x57a5
    3712:	6a 01                	push   $0x1
    3714:	e8 98 06 00 00       	call   3db1 <printf>
    3719:	83 c4 10             	add    $0x10,%esp
      break;
    371c:	eb 6b                	jmp    3789 <fsfull+0x1ad>
    }
    int total = 0;
    371e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    3725:	83 ec 04             	sub    $0x4,%esp
    3728:	68 00 02 00 00       	push   $0x200
    372d:	68 e0 5e 00 00       	push   $0x5ee0
    3732:	ff 75 e8             	pushl  -0x18(%ebp)
    3735:	e8 fb 04 00 00       	call   3c35 <write>
    373a:	83 c4 10             	add    $0x10,%esp
    373d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    3740:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    3747:	7e 0c                	jle    3755 <fsfull+0x179>
        break;
      total += cc;
    3749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    374c:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    374f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while(1){
    3753:	eb d0                	jmp    3725 <fsfull+0x149>
        break;
    3755:	90                   	nop
    }
    printf(1, "wrote %d bytes\n", total);
    3756:	83 ec 04             	sub    $0x4,%esp
    3759:	ff 75 ec             	pushl  -0x14(%ebp)
    375c:	68 b5 57 00 00       	push   $0x57b5
    3761:	6a 01                	push   $0x1
    3763:	e8 49 06 00 00       	call   3db1 <printf>
    3768:	83 c4 10             	add    $0x10,%esp
    close(fd);
    376b:	83 ec 0c             	sub    $0xc,%esp
    376e:	ff 75 e8             	pushl  -0x18(%ebp)
    3771:	e8 c7 04 00 00       	call   3c3d <close>
    3776:	83 c4 10             	add    $0x10,%esp
    if(total == 0)
    3779:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    377d:	74 09                	je     3788 <fsfull+0x1ac>
  for(nfiles = 0; ; nfiles++){
    377f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3783:	e9 7b fe ff ff       	jmp    3603 <fsfull+0x27>
      break;
    3788:	90                   	nop
  }

  while(nfiles >= 0){
    3789:	e9 e3 00 00 00       	jmp    3871 <fsfull+0x295>
    char name[64];
    name[0] = 'f';
    378e:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3792:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3795:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    379a:	89 c8                	mov    %ecx,%eax
    379c:	f7 ea                	imul   %edx
    379e:	89 d0                	mov    %edx,%eax
    37a0:	c1 f8 06             	sar    $0x6,%eax
    37a3:	c1 f9 1f             	sar    $0x1f,%ecx
    37a6:	89 ca                	mov    %ecx,%edx
    37a8:	29 d0                	sub    %edx,%eax
    37aa:	83 c0 30             	add    $0x30,%eax
    37ad:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    37b0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    37b3:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    37b8:	89 d8                	mov    %ebx,%eax
    37ba:	f7 ea                	imul   %edx
    37bc:	89 d0                	mov    %edx,%eax
    37be:	c1 f8 06             	sar    $0x6,%eax
    37c1:	89 da                	mov    %ebx,%edx
    37c3:	c1 fa 1f             	sar    $0x1f,%edx
    37c6:	29 d0                	sub    %edx,%eax
    37c8:	89 c1                	mov    %eax,%ecx
    37ca:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    37d0:	29 c3                	sub    %eax,%ebx
    37d2:	89 d9                	mov    %ebx,%ecx
    37d4:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    37d9:	89 c8                	mov    %ecx,%eax
    37db:	f7 ea                	imul   %edx
    37dd:	89 d0                	mov    %edx,%eax
    37df:	c1 f8 05             	sar    $0x5,%eax
    37e2:	c1 f9 1f             	sar    $0x1f,%ecx
    37e5:	89 ca                	mov    %ecx,%edx
    37e7:	29 d0                	sub    %edx,%eax
    37e9:	83 c0 30             	add    $0x30,%eax
    37ec:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    37ef:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    37f2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    37f7:	89 d8                	mov    %ebx,%eax
    37f9:	f7 ea                	imul   %edx
    37fb:	89 d0                	mov    %edx,%eax
    37fd:	c1 f8 05             	sar    $0x5,%eax
    3800:	89 da                	mov    %ebx,%edx
    3802:	c1 fa 1f             	sar    $0x1f,%edx
    3805:	29 d0                	sub    %edx,%eax
    3807:	89 c1                	mov    %eax,%ecx
    3809:	6b c1 64             	imul   $0x64,%ecx,%eax
    380c:	29 c3                	sub    %eax,%ebx
    380e:	89 d9                	mov    %ebx,%ecx
    3810:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3815:	89 c8                	mov    %ecx,%eax
    3817:	f7 ea                	imul   %edx
    3819:	89 d0                	mov    %edx,%eax
    381b:	c1 f8 02             	sar    $0x2,%eax
    381e:	c1 f9 1f             	sar    $0x1f,%ecx
    3821:	89 ca                	mov    %ecx,%edx
    3823:	29 d0                	sub    %edx,%eax
    3825:	83 c0 30             	add    $0x30,%eax
    3828:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    382b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    382e:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3833:	89 c8                	mov    %ecx,%eax
    3835:	f7 ea                	imul   %edx
    3837:	89 d0                	mov    %edx,%eax
    3839:	c1 f8 02             	sar    $0x2,%eax
    383c:	89 cb                	mov    %ecx,%ebx
    383e:	c1 fb 1f             	sar    $0x1f,%ebx
    3841:	29 d8                	sub    %ebx,%eax
    3843:	89 c2                	mov    %eax,%edx
    3845:	89 d0                	mov    %edx,%eax
    3847:	c1 e0 02             	shl    $0x2,%eax
    384a:	01 d0                	add    %edx,%eax
    384c:	01 c0                	add    %eax,%eax
    384e:	29 c1                	sub    %eax,%ecx
    3850:	89 ca                	mov    %ecx,%edx
    3852:	89 d0                	mov    %edx,%eax
    3854:	83 c0 30             	add    $0x30,%eax
    3857:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    385a:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    385e:	83 ec 0c             	sub    $0xc,%esp
    3861:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3864:	50                   	push   %eax
    3865:	e8 fb 03 00 00       	call   3c65 <unlink>
    386a:	83 c4 10             	add    $0x10,%esp
    nfiles--;
    386d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  while(nfiles >= 0){
    3871:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3875:	0f 89 13 ff ff ff    	jns    378e <fsfull+0x1b2>
  }

  printf(1, "fsfull test finished\n");
    387b:	83 ec 08             	sub    $0x8,%esp
    387e:	68 c5 57 00 00       	push   $0x57c5
    3883:	6a 01                	push   $0x1
    3885:	e8 27 05 00 00       	call   3db1 <printf>
    388a:	83 c4 10             	add    $0x10,%esp
}
    388d:	90                   	nop
    388e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3891:	c9                   	leave  
    3892:	c3                   	ret    

00003893 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3893:	55                   	push   %ebp
    3894:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3896:	a1 bc 5e 00 00       	mov    0x5ebc,%eax
    389b:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    38a1:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    38a6:	a3 bc 5e 00 00       	mov    %eax,0x5ebc
  return randstate;
    38ab:	a1 bc 5e 00 00       	mov    0x5ebc,%eax
}
    38b0:	5d                   	pop    %ebp
    38b1:	c3                   	ret    

000038b2 <main>:

int
main(int argc, char *argv[])
{
    38b2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    38b6:	83 e4 f0             	and    $0xfffffff0,%esp
    38b9:	ff 71 fc             	pushl  -0x4(%ecx)
    38bc:	55                   	push   %ebp
    38bd:	89 e5                	mov    %esp,%ebp
    38bf:	51                   	push   %ecx
    38c0:	83 ec 04             	sub    $0x4,%esp
  printf(1, "usertests starting\n");
    38c3:	83 ec 08             	sub    $0x8,%esp
    38c6:	68 db 57 00 00       	push   $0x57db
    38cb:	6a 01                	push   $0x1
    38cd:	e8 df 04 00 00       	call   3db1 <printf>
    38d2:	83 c4 10             	add    $0x10,%esp

  if(open("usertests.ran", 0) >= 0){
    38d5:	83 ec 08             	sub    $0x8,%esp
    38d8:	6a 00                	push   $0x0
    38da:	68 ef 57 00 00       	push   $0x57ef
    38df:	e8 71 03 00 00       	call   3c55 <open>
    38e4:	83 c4 10             	add    $0x10,%esp
    38e7:	85 c0                	test   %eax,%eax
    38e9:	78 17                	js     3902 <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    38eb:	83 ec 08             	sub    $0x8,%esp
    38ee:	68 00 58 00 00       	push   $0x5800
    38f3:	6a 01                	push   $0x1
    38f5:	e8 b7 04 00 00       	call   3db1 <printf>
    38fa:	83 c4 10             	add    $0x10,%esp
    exit();
    38fd:	e8 13 03 00 00       	call   3c15 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3902:	83 ec 08             	sub    $0x8,%esp
    3905:	68 00 02 00 00       	push   $0x200
    390a:	68 ef 57 00 00       	push   $0x57ef
    390f:	e8 41 03 00 00       	call   3c55 <open>
    3914:	83 c4 10             	add    $0x10,%esp
    3917:	83 ec 0c             	sub    $0xc,%esp
    391a:	50                   	push   %eax
    391b:	e8 1d 03 00 00       	call   3c3d <close>
    3920:	83 c4 10             	add    $0x10,%esp

  bigargtest();
    3923:	e8 78 fb ff ff       	call   34a0 <bigargtest>
  bigwrite();
    3928:	e8 e4 ea ff ff       	call   2411 <bigwrite>
  bigargtest();
    392d:	e8 6e fb ff ff       	call   34a0 <bigargtest>
  bsstest();
    3932:	e8 f3 fa ff ff       	call   342a <bsstest>
  sbrktest();
    3937:	e8 08 f5 ff ff       	call   2e44 <sbrktest>
  validatetest();
    393c:	e8 0b fa ff ff       	call   334c <validatetest>

  opentest();
    3941:	e8 ba c6 ff ff       	call   0 <opentest>
  writetest();
    3946:	e8 64 c7 ff ff       	call   af <writetest>
  writetest1();
    394b:	e8 6f c9 ff ff       	call   2bf <writetest1>
  createtest();
    3950:	e8 66 cb ff ff       	call   4bb <createtest>

  mem();
    3955:	e8 2c d1 ff ff       	call   a86 <mem>
  pipe1();
    395a:	e8 63 cd ff ff       	call   6c2 <pipe1>
  preempt();
    395f:	e8 47 cf ff ff       	call   8ab <preempt>
  exitwait();
    3964:	e8 a5 d0 ff ff       	call   a0e <exitwait>

  rmdot();
    3969:	e8 15 ef ff ff       	call   2883 <rmdot>
  fourteen();
    396e:	e8 b4 ed ff ff       	call   2727 <fourteen>
  bigfile();
    3973:	e8 97 eb ff ff       	call   250f <bigfile>
  subdir();
    3978:	e8 50 e3 ff ff       	call   1ccd <subdir>
  concreate();
    397d:	e8 e1 dc ff ff       	call   1663 <concreate>
  linkunlink();
    3982:	e8 96 e0 ff ff       	call   1a1d <linkunlink>
  linktest();
    3987:	e8 95 da ff ff       	call   1421 <linktest>
  unlinkread();
    398c:	e8 ce d8 ff ff       	call   125f <unlinkread>
  createdelete();
    3991:	e8 23 d6 ff ff       	call   fb9 <createdelete>
  twofiles();
    3996:	e8 bf d3 ff ff       	call   d5a <twofiles>
  sharedfd();
    399b:	e8 d7 d1 ff ff       	call   b77 <sharedfd>
  dirfile();
    39a0:	e8 63 f0 ff ff       	call   2a08 <dirfile>
  iref();
    39a5:	e8 96 f2 ff ff       	call   2c40 <iref>
  forktest();
    39aa:	e8 cb f3 ff ff       	call   2d7a <forktest>
  bigdir(); // slow
    39af:	e8 a4 e1 ff ff       	call   1b58 <bigdir>

  exectest();
    39b4:	e8 b6 cc ff ff       	call   66f <exectest>

  exit();
    39b9:	e8 57 02 00 00       	call   3c15 <exit>

000039be <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    39be:	55                   	push   %ebp
    39bf:	89 e5                	mov    %esp,%ebp
    39c1:	57                   	push   %edi
    39c2:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    39c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
    39c6:	8b 55 10             	mov    0x10(%ebp),%edx
    39c9:	8b 45 0c             	mov    0xc(%ebp),%eax
    39cc:	89 cb                	mov    %ecx,%ebx
    39ce:	89 df                	mov    %ebx,%edi
    39d0:	89 d1                	mov    %edx,%ecx
    39d2:	fc                   	cld    
    39d3:	f3 aa                	rep stos %al,%es:(%edi)
    39d5:	89 ca                	mov    %ecx,%edx
    39d7:	89 fb                	mov    %edi,%ebx
    39d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
    39dc:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    39df:	90                   	nop
    39e0:	5b                   	pop    %ebx
    39e1:	5f                   	pop    %edi
    39e2:	5d                   	pop    %ebp
    39e3:	c3                   	ret    

000039e4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    39e4:	55                   	push   %ebp
    39e5:	89 e5                	mov    %esp,%ebp
    39e7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    39ea:	8b 45 08             	mov    0x8(%ebp),%eax
    39ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    39f0:	90                   	nop
    39f1:	8b 55 0c             	mov    0xc(%ebp),%edx
    39f4:	8d 42 01             	lea    0x1(%edx),%eax
    39f7:	89 45 0c             	mov    %eax,0xc(%ebp)
    39fa:	8b 45 08             	mov    0x8(%ebp),%eax
    39fd:	8d 48 01             	lea    0x1(%eax),%ecx
    3a00:	89 4d 08             	mov    %ecx,0x8(%ebp)
    3a03:	0f b6 12             	movzbl (%edx),%edx
    3a06:	88 10                	mov    %dl,(%eax)
    3a08:	0f b6 00             	movzbl (%eax),%eax
    3a0b:	84 c0                	test   %al,%al
    3a0d:	75 e2                	jne    39f1 <strcpy+0xd>
    ;
  return os;
    3a0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3a12:	c9                   	leave  
    3a13:	c3                   	ret    

00003a14 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3a14:	55                   	push   %ebp
    3a15:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3a17:	eb 08                	jmp    3a21 <strcmp+0xd>
    p++, q++;
    3a19:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3a1d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    3a21:	8b 45 08             	mov    0x8(%ebp),%eax
    3a24:	0f b6 00             	movzbl (%eax),%eax
    3a27:	84 c0                	test   %al,%al
    3a29:	74 10                	je     3a3b <strcmp+0x27>
    3a2b:	8b 45 08             	mov    0x8(%ebp),%eax
    3a2e:	0f b6 10             	movzbl (%eax),%edx
    3a31:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a34:	0f b6 00             	movzbl (%eax),%eax
    3a37:	38 c2                	cmp    %al,%dl
    3a39:	74 de                	je     3a19 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    3a3b:	8b 45 08             	mov    0x8(%ebp),%eax
    3a3e:	0f b6 00             	movzbl (%eax),%eax
    3a41:	0f b6 d0             	movzbl %al,%edx
    3a44:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a47:	0f b6 00             	movzbl (%eax),%eax
    3a4a:	0f b6 c8             	movzbl %al,%ecx
    3a4d:	89 d0                	mov    %edx,%eax
    3a4f:	29 c8                	sub    %ecx,%eax
}
    3a51:	5d                   	pop    %ebp
    3a52:	c3                   	ret    

00003a53 <strlen>:

uint
strlen(char *s)
{
    3a53:	55                   	push   %ebp
    3a54:	89 e5                	mov    %esp,%ebp
    3a56:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3a59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3a60:	eb 04                	jmp    3a66 <strlen+0x13>
    3a62:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3a66:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3a69:	8b 45 08             	mov    0x8(%ebp),%eax
    3a6c:	01 d0                	add    %edx,%eax
    3a6e:	0f b6 00             	movzbl (%eax),%eax
    3a71:	84 c0                	test   %al,%al
    3a73:	75 ed                	jne    3a62 <strlen+0xf>
    ;
  return n;
    3a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3a78:	c9                   	leave  
    3a79:	c3                   	ret    

00003a7a <memset>:

void*
memset(void *dst, int c, uint n)
{
    3a7a:	55                   	push   %ebp
    3a7b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    3a7d:	8b 45 10             	mov    0x10(%ebp),%eax
    3a80:	50                   	push   %eax
    3a81:	ff 75 0c             	pushl  0xc(%ebp)
    3a84:	ff 75 08             	pushl  0x8(%ebp)
    3a87:	e8 32 ff ff ff       	call   39be <stosb>
    3a8c:	83 c4 0c             	add    $0xc,%esp
  return dst;
    3a8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3a92:	c9                   	leave  
    3a93:	c3                   	ret    

00003a94 <strchr>:

char*
strchr(const char *s, char c)
{
    3a94:	55                   	push   %ebp
    3a95:	89 e5                	mov    %esp,%ebp
    3a97:	83 ec 04             	sub    $0x4,%esp
    3a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a9d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3aa0:	eb 14                	jmp    3ab6 <strchr+0x22>
    if(*s == c)
    3aa2:	8b 45 08             	mov    0x8(%ebp),%eax
    3aa5:	0f b6 00             	movzbl (%eax),%eax
    3aa8:	38 45 fc             	cmp    %al,-0x4(%ebp)
    3aab:	75 05                	jne    3ab2 <strchr+0x1e>
      return (char*)s;
    3aad:	8b 45 08             	mov    0x8(%ebp),%eax
    3ab0:	eb 13                	jmp    3ac5 <strchr+0x31>
  for(; *s; s++)
    3ab2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3ab6:	8b 45 08             	mov    0x8(%ebp),%eax
    3ab9:	0f b6 00             	movzbl (%eax),%eax
    3abc:	84 c0                	test   %al,%al
    3abe:	75 e2                	jne    3aa2 <strchr+0xe>
  return 0;
    3ac0:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3ac5:	c9                   	leave  
    3ac6:	c3                   	ret    

00003ac7 <gets>:

char*
gets(char *buf, int max)
{
    3ac7:	55                   	push   %ebp
    3ac8:	89 e5                	mov    %esp,%ebp
    3aca:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3acd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3ad4:	eb 42                	jmp    3b18 <gets+0x51>
    cc = read(0, &c, 1);
    3ad6:	83 ec 04             	sub    $0x4,%esp
    3ad9:	6a 01                	push   $0x1
    3adb:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3ade:	50                   	push   %eax
    3adf:	6a 00                	push   $0x0
    3ae1:	e8 47 01 00 00       	call   3c2d <read>
    3ae6:	83 c4 10             	add    $0x10,%esp
    3ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3aec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3af0:	7e 33                	jle    3b25 <gets+0x5e>
      break;
    buf[i++] = c;
    3af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3af5:	8d 50 01             	lea    0x1(%eax),%edx
    3af8:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3afb:	89 c2                	mov    %eax,%edx
    3afd:	8b 45 08             	mov    0x8(%ebp),%eax
    3b00:	01 c2                	add    %eax,%edx
    3b02:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3b06:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    3b08:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3b0c:	3c 0a                	cmp    $0xa,%al
    3b0e:	74 16                	je     3b26 <gets+0x5f>
    3b10:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3b14:	3c 0d                	cmp    $0xd,%al
    3b16:	74 0e                	je     3b26 <gets+0x5f>
  for(i=0; i+1 < max; ){
    3b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b1b:	83 c0 01             	add    $0x1,%eax
    3b1e:	39 45 0c             	cmp    %eax,0xc(%ebp)
    3b21:	7f b3                	jg     3ad6 <gets+0xf>
    3b23:	eb 01                	jmp    3b26 <gets+0x5f>
      break;
    3b25:	90                   	nop
      break;
  }
  buf[i] = '\0';
    3b26:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3b29:	8b 45 08             	mov    0x8(%ebp),%eax
    3b2c:	01 d0                	add    %edx,%eax
    3b2e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3b31:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3b34:	c9                   	leave  
    3b35:	c3                   	ret    

00003b36 <stat>:

int
stat(char *n, struct stat *st)
{
    3b36:	55                   	push   %ebp
    3b37:	89 e5                	mov    %esp,%ebp
    3b39:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3b3c:	83 ec 08             	sub    $0x8,%esp
    3b3f:	6a 00                	push   $0x0
    3b41:	ff 75 08             	pushl  0x8(%ebp)
    3b44:	e8 0c 01 00 00       	call   3c55 <open>
    3b49:	83 c4 10             	add    $0x10,%esp
    3b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3b4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b53:	79 07                	jns    3b5c <stat+0x26>
    return -1;
    3b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3b5a:	eb 25                	jmp    3b81 <stat+0x4b>
  r = fstat(fd, st);
    3b5c:	83 ec 08             	sub    $0x8,%esp
    3b5f:	ff 75 0c             	pushl  0xc(%ebp)
    3b62:	ff 75 f4             	pushl  -0xc(%ebp)
    3b65:	e8 03 01 00 00       	call   3c6d <fstat>
    3b6a:	83 c4 10             	add    $0x10,%esp
    3b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3b70:	83 ec 0c             	sub    $0xc,%esp
    3b73:	ff 75 f4             	pushl  -0xc(%ebp)
    3b76:	e8 c2 00 00 00       	call   3c3d <close>
    3b7b:	83 c4 10             	add    $0x10,%esp
  return r;
    3b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3b81:	c9                   	leave  
    3b82:	c3                   	ret    

00003b83 <atoi>:

int
atoi(const char *s)
{
    3b83:	55                   	push   %ebp
    3b84:	89 e5                	mov    %esp,%ebp
    3b86:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3b89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3b90:	eb 25                	jmp    3bb7 <atoi+0x34>
    n = n*10 + *s++ - '0';
    3b92:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3b95:	89 d0                	mov    %edx,%eax
    3b97:	c1 e0 02             	shl    $0x2,%eax
    3b9a:	01 d0                	add    %edx,%eax
    3b9c:	01 c0                	add    %eax,%eax
    3b9e:	89 c1                	mov    %eax,%ecx
    3ba0:	8b 45 08             	mov    0x8(%ebp),%eax
    3ba3:	8d 50 01             	lea    0x1(%eax),%edx
    3ba6:	89 55 08             	mov    %edx,0x8(%ebp)
    3ba9:	0f b6 00             	movzbl (%eax),%eax
    3bac:	0f be c0             	movsbl %al,%eax
    3baf:	01 c8                	add    %ecx,%eax
    3bb1:	83 e8 30             	sub    $0x30,%eax
    3bb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3bb7:	8b 45 08             	mov    0x8(%ebp),%eax
    3bba:	0f b6 00             	movzbl (%eax),%eax
    3bbd:	3c 2f                	cmp    $0x2f,%al
    3bbf:	7e 0a                	jle    3bcb <atoi+0x48>
    3bc1:	8b 45 08             	mov    0x8(%ebp),%eax
    3bc4:	0f b6 00             	movzbl (%eax),%eax
    3bc7:	3c 39                	cmp    $0x39,%al
    3bc9:	7e c7                	jle    3b92 <atoi+0xf>
  return n;
    3bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3bce:	c9                   	leave  
    3bcf:	c3                   	ret    

00003bd0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3bd0:	55                   	push   %ebp
    3bd1:	89 e5                	mov    %esp,%ebp
    3bd3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3bd6:	8b 45 08             	mov    0x8(%ebp),%eax
    3bd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
    3bdf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3be2:	eb 17                	jmp    3bfb <memmove+0x2b>
    *dst++ = *src++;
    3be4:	8b 55 f8             	mov    -0x8(%ebp),%edx
    3be7:	8d 42 01             	lea    0x1(%edx),%eax
    3bea:	89 45 f8             	mov    %eax,-0x8(%ebp)
    3bed:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3bf0:	8d 48 01             	lea    0x1(%eax),%ecx
    3bf3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    3bf6:	0f b6 12             	movzbl (%edx),%edx
    3bf9:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    3bfb:	8b 45 10             	mov    0x10(%ebp),%eax
    3bfe:	8d 50 ff             	lea    -0x1(%eax),%edx
    3c01:	89 55 10             	mov    %edx,0x10(%ebp)
    3c04:	85 c0                	test   %eax,%eax
    3c06:	7f dc                	jg     3be4 <memmove+0x14>
  return vdst;
    3c08:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3c0b:	c9                   	leave  
    3c0c:	c3                   	ret    

00003c0d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3c0d:	b8 01 00 00 00       	mov    $0x1,%eax
    3c12:	cd 40                	int    $0x40
    3c14:	c3                   	ret    

00003c15 <exit>:
SYSCALL(exit)
    3c15:	b8 02 00 00 00       	mov    $0x2,%eax
    3c1a:	cd 40                	int    $0x40
    3c1c:	c3                   	ret    

00003c1d <wait>:
SYSCALL(wait)
    3c1d:	b8 03 00 00 00       	mov    $0x3,%eax
    3c22:	cd 40                	int    $0x40
    3c24:	c3                   	ret    

00003c25 <pipe>:
SYSCALL(pipe)
    3c25:	b8 04 00 00 00       	mov    $0x4,%eax
    3c2a:	cd 40                	int    $0x40
    3c2c:	c3                   	ret    

00003c2d <read>:
SYSCALL(read)
    3c2d:	b8 05 00 00 00       	mov    $0x5,%eax
    3c32:	cd 40                	int    $0x40
    3c34:	c3                   	ret    

00003c35 <write>:
SYSCALL(write)
    3c35:	b8 15 00 00 00       	mov    $0x15,%eax
    3c3a:	cd 40                	int    $0x40
    3c3c:	c3                   	ret    

00003c3d <close>:
SYSCALL(close)
    3c3d:	b8 1a 00 00 00       	mov    $0x1a,%eax
    3c42:	cd 40                	int    $0x40
    3c44:	c3                   	ret    

00003c45 <kill>:
SYSCALL(kill)
    3c45:	b8 06 00 00 00       	mov    $0x6,%eax
    3c4a:	cd 40                	int    $0x40
    3c4c:	c3                   	ret    

00003c4d <exec>:
SYSCALL(exec)
    3c4d:	b8 07 00 00 00       	mov    $0x7,%eax
    3c52:	cd 40                	int    $0x40
    3c54:	c3                   	ret    

00003c55 <open>:
SYSCALL(open)
    3c55:	b8 14 00 00 00       	mov    $0x14,%eax
    3c5a:	cd 40                	int    $0x40
    3c5c:	c3                   	ret    

00003c5d <mknod>:
SYSCALL(mknod)
    3c5d:	b8 16 00 00 00       	mov    $0x16,%eax
    3c62:	cd 40                	int    $0x40
    3c64:	c3                   	ret    

00003c65 <unlink>:
SYSCALL(unlink)
    3c65:	b8 17 00 00 00       	mov    $0x17,%eax
    3c6a:	cd 40                	int    $0x40
    3c6c:	c3                   	ret    

00003c6d <fstat>:
SYSCALL(fstat)
    3c6d:	b8 08 00 00 00       	mov    $0x8,%eax
    3c72:	cd 40                	int    $0x40
    3c74:	c3                   	ret    

00003c75 <link>:
SYSCALL(link)
    3c75:	b8 18 00 00 00       	mov    $0x18,%eax
    3c7a:	cd 40                	int    $0x40
    3c7c:	c3                   	ret    

00003c7d <mkdir>:
SYSCALL(mkdir)
    3c7d:	b8 19 00 00 00       	mov    $0x19,%eax
    3c82:	cd 40                	int    $0x40
    3c84:	c3                   	ret    

00003c85 <chdir>:
SYSCALL(chdir)
    3c85:	b8 09 00 00 00       	mov    $0x9,%eax
    3c8a:	cd 40                	int    $0x40
    3c8c:	c3                   	ret    

00003c8d <dup>:
SYSCALL(dup)
    3c8d:	b8 0a 00 00 00       	mov    $0xa,%eax
    3c92:	cd 40                	int    $0x40
    3c94:	c3                   	ret    

00003c95 <getpid>:
SYSCALL(getpid)
    3c95:	b8 0b 00 00 00       	mov    $0xb,%eax
    3c9a:	cd 40                	int    $0x40
    3c9c:	c3                   	ret    

00003c9d <sbrk>:
SYSCALL(sbrk)
    3c9d:	b8 0c 00 00 00       	mov    $0xc,%eax
    3ca2:	cd 40                	int    $0x40
    3ca4:	c3                   	ret    

00003ca5 <sleep>:
SYSCALL(sleep)
    3ca5:	b8 0d 00 00 00       	mov    $0xd,%eax
    3caa:	cd 40                	int    $0x40
    3cac:	c3                   	ret    

00003cad <uptime>:
SYSCALL(uptime)
    3cad:	b8 0e 00 00 00       	mov    $0xe,%eax
    3cb2:	cd 40                	int    $0x40
    3cb4:	c3                   	ret    

00003cb5 <sem_alloc>:
SYSCALL(sem_alloc)
    3cb5:	b8 0f 00 00 00       	mov    $0xf,%eax
    3cba:	cd 40                	int    $0x40
    3cbc:	c3                   	ret    

00003cbd <sem_destroy>:
SYSCALL(sem_destroy)
    3cbd:	b8 10 00 00 00       	mov    $0x10,%eax
    3cc2:	cd 40                	int    $0x40
    3cc4:	c3                   	ret    

00003cc5 <sem_init>:
SYSCALL(sem_init)
    3cc5:	b8 11 00 00 00       	mov    $0x11,%eax
    3cca:	cd 40                	int    $0x40
    3ccc:	c3                   	ret    

00003ccd <sem_post>:
SYSCALL(sem_post)
    3ccd:	b8 12 00 00 00       	mov    $0x12,%eax
    3cd2:	cd 40                	int    $0x40
    3cd4:	c3                   	ret    

00003cd5 <sem_wait>:
SYSCALL(sem_wait)
    3cd5:	b8 13 00 00 00       	mov    $0x13,%eax
    3cda:	cd 40                	int    $0x40
    3cdc:	c3                   	ret    

00003cdd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3cdd:	55                   	push   %ebp
    3cde:	89 e5                	mov    %esp,%ebp
    3ce0:	83 ec 18             	sub    $0x18,%esp
    3ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
    3ce6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3ce9:	83 ec 04             	sub    $0x4,%esp
    3cec:	6a 01                	push   $0x1
    3cee:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3cf1:	50                   	push   %eax
    3cf2:	ff 75 08             	pushl  0x8(%ebp)
    3cf5:	e8 3b ff ff ff       	call   3c35 <write>
    3cfa:	83 c4 10             	add    $0x10,%esp
}
    3cfd:	90                   	nop
    3cfe:	c9                   	leave  
    3cff:	c3                   	ret    

00003d00 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3d00:	55                   	push   %ebp
    3d01:	89 e5                	mov    %esp,%ebp
    3d03:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3d06:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3d0d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3d11:	74 17                	je     3d2a <printint+0x2a>
    3d13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3d17:	79 11                	jns    3d2a <printint+0x2a>
    neg = 1;
    3d19:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3d20:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d23:	f7 d8                	neg    %eax
    3d25:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3d28:	eb 06                	jmp    3d30 <printint+0x30>
  } else {
    x = xx;
    3d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3d30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3d37:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3d3d:	ba 00 00 00 00       	mov    $0x0,%edx
    3d42:	f7 f1                	div    %ecx
    3d44:	89 d1                	mov    %edx,%ecx
    3d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d49:	8d 50 01             	lea    0x1(%eax),%edx
    3d4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3d4f:	0f b6 91 c0 5e 00 00 	movzbl 0x5ec0(%ecx),%edx
    3d56:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
    3d5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3d5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3d60:	ba 00 00 00 00       	mov    $0x0,%edx
    3d65:	f7 f1                	div    %ecx
    3d67:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3d6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3d6e:	75 c7                	jne    3d37 <printint+0x37>
  if(neg)
    3d70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3d74:	74 2d                	je     3da3 <printint+0xa3>
    buf[i++] = '-';
    3d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d79:	8d 50 01             	lea    0x1(%eax),%edx
    3d7c:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3d7f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    3d84:	eb 1d                	jmp    3da3 <printint+0xa3>
    putc(fd, buf[i]);
    3d86:	8d 55 dc             	lea    -0x24(%ebp),%edx
    3d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d8c:	01 d0                	add    %edx,%eax
    3d8e:	0f b6 00             	movzbl (%eax),%eax
    3d91:	0f be c0             	movsbl %al,%eax
    3d94:	83 ec 08             	sub    $0x8,%esp
    3d97:	50                   	push   %eax
    3d98:	ff 75 08             	pushl  0x8(%ebp)
    3d9b:	e8 3d ff ff ff       	call   3cdd <putc>
    3da0:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
    3da3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    3da7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3dab:	79 d9                	jns    3d86 <printint+0x86>
}
    3dad:	90                   	nop
    3dae:	90                   	nop
    3daf:	c9                   	leave  
    3db0:	c3                   	ret    

00003db1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    3db1:	55                   	push   %ebp
    3db2:	89 e5                	mov    %esp,%ebp
    3db4:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    3db7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    3dbe:	8d 45 0c             	lea    0xc(%ebp),%eax
    3dc1:	83 c0 04             	add    $0x4,%eax
    3dc4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    3dc7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3dce:	e9 59 01 00 00       	jmp    3f2c <printf+0x17b>
    c = fmt[i] & 0xff;
    3dd3:	8b 55 0c             	mov    0xc(%ebp),%edx
    3dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3dd9:	01 d0                	add    %edx,%eax
    3ddb:	0f b6 00             	movzbl (%eax),%eax
    3dde:	0f be c0             	movsbl %al,%eax
    3de1:	25 ff 00 00 00       	and    $0xff,%eax
    3de6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    3de9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3ded:	75 2c                	jne    3e1b <printf+0x6a>
      if(c == '%'){
    3def:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    3df3:	75 0c                	jne    3e01 <printf+0x50>
        state = '%';
    3df5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    3dfc:	e9 27 01 00 00       	jmp    3f28 <printf+0x177>
      } else {
        putc(fd, c);
    3e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3e04:	0f be c0             	movsbl %al,%eax
    3e07:	83 ec 08             	sub    $0x8,%esp
    3e0a:	50                   	push   %eax
    3e0b:	ff 75 08             	pushl  0x8(%ebp)
    3e0e:	e8 ca fe ff ff       	call   3cdd <putc>
    3e13:	83 c4 10             	add    $0x10,%esp
    3e16:	e9 0d 01 00 00       	jmp    3f28 <printf+0x177>
      }
    } else if(state == '%'){
    3e1b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    3e1f:	0f 85 03 01 00 00    	jne    3f28 <printf+0x177>
      if(c == 'd'){
    3e25:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    3e29:	75 1e                	jne    3e49 <printf+0x98>
        printint(fd, *ap, 10, 1);
    3e2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3e2e:	8b 00                	mov    (%eax),%eax
    3e30:	6a 01                	push   $0x1
    3e32:	6a 0a                	push   $0xa
    3e34:	50                   	push   %eax
    3e35:	ff 75 08             	pushl  0x8(%ebp)
    3e38:	e8 c3 fe ff ff       	call   3d00 <printint>
    3e3d:	83 c4 10             	add    $0x10,%esp
        ap++;
    3e40:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3e44:	e9 d8 00 00 00       	jmp    3f21 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    3e49:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    3e4d:	74 06                	je     3e55 <printf+0xa4>
    3e4f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    3e53:	75 1e                	jne    3e73 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    3e55:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3e58:	8b 00                	mov    (%eax),%eax
    3e5a:	6a 00                	push   $0x0
    3e5c:	6a 10                	push   $0x10
    3e5e:	50                   	push   %eax
    3e5f:	ff 75 08             	pushl  0x8(%ebp)
    3e62:	e8 99 fe ff ff       	call   3d00 <printint>
    3e67:	83 c4 10             	add    $0x10,%esp
        ap++;
    3e6a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3e6e:	e9 ae 00 00 00       	jmp    3f21 <printf+0x170>
      } else if(c == 's'){
    3e73:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    3e77:	75 43                	jne    3ebc <printf+0x10b>
        s = (char*)*ap;
    3e79:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3e7c:	8b 00                	mov    (%eax),%eax
    3e7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    3e81:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    3e85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3e89:	75 25                	jne    3eb0 <printf+0xff>
          s = "(null)";
    3e8b:	c7 45 f4 2a 58 00 00 	movl   $0x582a,-0xc(%ebp)
        while(*s != 0){
    3e92:	eb 1c                	jmp    3eb0 <printf+0xff>
          putc(fd, *s);
    3e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e97:	0f b6 00             	movzbl (%eax),%eax
    3e9a:	0f be c0             	movsbl %al,%eax
    3e9d:	83 ec 08             	sub    $0x8,%esp
    3ea0:	50                   	push   %eax
    3ea1:	ff 75 08             	pushl  0x8(%ebp)
    3ea4:	e8 34 fe ff ff       	call   3cdd <putc>
    3ea9:	83 c4 10             	add    $0x10,%esp
          s++;
    3eac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    3eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3eb3:	0f b6 00             	movzbl (%eax),%eax
    3eb6:	84 c0                	test   %al,%al
    3eb8:	75 da                	jne    3e94 <printf+0xe3>
    3eba:	eb 65                	jmp    3f21 <printf+0x170>
        }
      } else if(c == 'c'){
    3ebc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    3ec0:	75 1d                	jne    3edf <printf+0x12e>
        putc(fd, *ap);
    3ec2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3ec5:	8b 00                	mov    (%eax),%eax
    3ec7:	0f be c0             	movsbl %al,%eax
    3eca:	83 ec 08             	sub    $0x8,%esp
    3ecd:	50                   	push   %eax
    3ece:	ff 75 08             	pushl  0x8(%ebp)
    3ed1:	e8 07 fe ff ff       	call   3cdd <putc>
    3ed6:	83 c4 10             	add    $0x10,%esp
        ap++;
    3ed9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3edd:	eb 42                	jmp    3f21 <printf+0x170>
      } else if(c == '%'){
    3edf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    3ee3:	75 17                	jne    3efc <printf+0x14b>
        putc(fd, c);
    3ee5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3ee8:	0f be c0             	movsbl %al,%eax
    3eeb:	83 ec 08             	sub    $0x8,%esp
    3eee:	50                   	push   %eax
    3eef:	ff 75 08             	pushl  0x8(%ebp)
    3ef2:	e8 e6 fd ff ff       	call   3cdd <putc>
    3ef7:	83 c4 10             	add    $0x10,%esp
    3efa:	eb 25                	jmp    3f21 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    3efc:	83 ec 08             	sub    $0x8,%esp
    3eff:	6a 25                	push   $0x25
    3f01:	ff 75 08             	pushl  0x8(%ebp)
    3f04:	e8 d4 fd ff ff       	call   3cdd <putc>
    3f09:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    3f0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3f0f:	0f be c0             	movsbl %al,%eax
    3f12:	83 ec 08             	sub    $0x8,%esp
    3f15:	50                   	push   %eax
    3f16:	ff 75 08             	pushl  0x8(%ebp)
    3f19:	e8 bf fd ff ff       	call   3cdd <putc>
    3f1e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    3f21:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    3f28:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3f2c:	8b 55 0c             	mov    0xc(%ebp),%edx
    3f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3f32:	01 d0                	add    %edx,%eax
    3f34:	0f b6 00             	movzbl (%eax),%eax
    3f37:	84 c0                	test   %al,%al
    3f39:	0f 85 94 fe ff ff    	jne    3dd3 <printf+0x22>
    }
  }
}
    3f3f:	90                   	nop
    3f40:	90                   	nop
    3f41:	c9                   	leave  
    3f42:	c3                   	ret    

00003f43 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3f43:	55                   	push   %ebp
    3f44:	89 e5                	mov    %esp,%ebp
    3f46:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3f49:	8b 45 08             	mov    0x8(%ebp),%eax
    3f4c:	83 e8 08             	sub    $0x8,%eax
    3f4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3f52:	a1 a8 a6 00 00       	mov    0xa6a8,%eax
    3f57:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3f5a:	eb 24                	jmp    3f80 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f5f:	8b 00                	mov    (%eax),%eax
    3f61:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    3f64:	72 12                	jb     3f78 <free+0x35>
    3f66:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f69:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3f6c:	77 24                	ja     3f92 <free+0x4f>
    3f6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f71:	8b 00                	mov    (%eax),%eax
    3f73:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    3f76:	72 1a                	jb     3f92 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3f78:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f7b:	8b 00                	mov    (%eax),%eax
    3f7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3f80:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f83:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3f86:	76 d4                	jbe    3f5c <free+0x19>
    3f88:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f8b:	8b 00                	mov    (%eax),%eax
    3f8d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    3f90:	73 ca                	jae    3f5c <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3f92:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f95:	8b 40 04             	mov    0x4(%eax),%eax
    3f98:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    3f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fa2:	01 c2                	add    %eax,%edx
    3fa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fa7:	8b 00                	mov    (%eax),%eax
    3fa9:	39 c2                	cmp    %eax,%edx
    3fab:	75 24                	jne    3fd1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    3fad:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fb0:	8b 50 04             	mov    0x4(%eax),%edx
    3fb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fb6:	8b 00                	mov    (%eax),%eax
    3fb8:	8b 40 04             	mov    0x4(%eax),%eax
    3fbb:	01 c2                	add    %eax,%edx
    3fbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fc0:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    3fc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fc6:	8b 00                	mov    (%eax),%eax
    3fc8:	8b 10                	mov    (%eax),%edx
    3fca:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fcd:	89 10                	mov    %edx,(%eax)
    3fcf:	eb 0a                	jmp    3fdb <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    3fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fd4:	8b 10                	mov    (%eax),%edx
    3fd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fd9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    3fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fde:	8b 40 04             	mov    0x4(%eax),%eax
    3fe1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    3fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3feb:	01 d0                	add    %edx,%eax
    3fed:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    3ff0:	75 20                	jne    4012 <free+0xcf>
    p->s.size += bp->s.size;
    3ff2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3ff5:	8b 50 04             	mov    0x4(%eax),%edx
    3ff8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3ffb:	8b 40 04             	mov    0x4(%eax),%eax
    3ffe:	01 c2                	add    %eax,%edx
    4000:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4003:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    4006:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4009:	8b 10                	mov    (%eax),%edx
    400b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    400e:	89 10                	mov    %edx,(%eax)
    4010:	eb 08                	jmp    401a <free+0xd7>
  } else
    p->s.ptr = bp;
    4012:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4015:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4018:	89 10                	mov    %edx,(%eax)
  freep = p;
    401a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    401d:	a3 a8 a6 00 00       	mov    %eax,0xa6a8
}
    4022:	90                   	nop
    4023:	c9                   	leave  
    4024:	c3                   	ret    

00004025 <morecore>:

static Header*
morecore(uint nu)
{
    4025:	55                   	push   %ebp
    4026:	89 e5                	mov    %esp,%ebp
    4028:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    402b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    4032:	77 07                	ja     403b <morecore+0x16>
    nu = 4096;
    4034:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    403b:	8b 45 08             	mov    0x8(%ebp),%eax
    403e:	c1 e0 03             	shl    $0x3,%eax
    4041:	83 ec 0c             	sub    $0xc,%esp
    4044:	50                   	push   %eax
    4045:	e8 53 fc ff ff       	call   3c9d <sbrk>
    404a:	83 c4 10             	add    $0x10,%esp
    404d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    4050:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    4054:	75 07                	jne    405d <morecore+0x38>
    return 0;
    4056:	b8 00 00 00 00       	mov    $0x0,%eax
    405b:	eb 26                	jmp    4083 <morecore+0x5e>
  hp = (Header*)p;
    405d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4060:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    4063:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4066:	8b 55 08             	mov    0x8(%ebp),%edx
    4069:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    406c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    406f:	83 c0 08             	add    $0x8,%eax
    4072:	83 ec 0c             	sub    $0xc,%esp
    4075:	50                   	push   %eax
    4076:	e8 c8 fe ff ff       	call   3f43 <free>
    407b:	83 c4 10             	add    $0x10,%esp
  return freep;
    407e:	a1 a8 a6 00 00       	mov    0xa6a8,%eax
}
    4083:	c9                   	leave  
    4084:	c3                   	ret    

00004085 <malloc>:

void*
malloc(uint nbytes)
{
    4085:	55                   	push   %ebp
    4086:	89 e5                	mov    %esp,%ebp
    4088:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    408b:	8b 45 08             	mov    0x8(%ebp),%eax
    408e:	83 c0 07             	add    $0x7,%eax
    4091:	c1 e8 03             	shr    $0x3,%eax
    4094:	83 c0 01             	add    $0x1,%eax
    4097:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    409a:	a1 a8 a6 00 00       	mov    0xa6a8,%eax
    409f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    40a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    40a6:	75 23                	jne    40cb <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    40a8:	c7 45 f0 a0 a6 00 00 	movl   $0xa6a0,-0x10(%ebp)
    40af:	8b 45 f0             	mov    -0x10(%ebp),%eax
    40b2:	a3 a8 a6 00 00       	mov    %eax,0xa6a8
    40b7:	a1 a8 a6 00 00       	mov    0xa6a8,%eax
    40bc:	a3 a0 a6 00 00       	mov    %eax,0xa6a0
    base.s.size = 0;
    40c1:	c7 05 a4 a6 00 00 00 	movl   $0x0,0xa6a4
    40c8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    40cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    40ce:	8b 00                	mov    (%eax),%eax
    40d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    40d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40d6:	8b 40 04             	mov    0x4(%eax),%eax
    40d9:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    40dc:	77 4d                	ja     412b <malloc+0xa6>
      if(p->s.size == nunits)
    40de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40e1:	8b 40 04             	mov    0x4(%eax),%eax
    40e4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    40e7:	75 0c                	jne    40f5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    40e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40ec:	8b 10                	mov    (%eax),%edx
    40ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
    40f1:	89 10                	mov    %edx,(%eax)
    40f3:	eb 26                	jmp    411b <malloc+0x96>
      else {
        p->s.size -= nunits;
    40f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40f8:	8b 40 04             	mov    0x4(%eax),%eax
    40fb:	2b 45 ec             	sub    -0x14(%ebp),%eax
    40fe:	89 c2                	mov    %eax,%edx
    4100:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4103:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    4106:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4109:	8b 40 04             	mov    0x4(%eax),%eax
    410c:	c1 e0 03             	shl    $0x3,%eax
    410f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    4112:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4115:	8b 55 ec             	mov    -0x14(%ebp),%edx
    4118:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    411b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    411e:	a3 a8 a6 00 00       	mov    %eax,0xa6a8
      return (void*)(p + 1);
    4123:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4126:	83 c0 08             	add    $0x8,%eax
    4129:	eb 3b                	jmp    4166 <malloc+0xe1>
    }
    if(p == freep)
    412b:	a1 a8 a6 00 00       	mov    0xa6a8,%eax
    4130:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    4133:	75 1e                	jne    4153 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    4135:	83 ec 0c             	sub    $0xc,%esp
    4138:	ff 75 ec             	pushl  -0x14(%ebp)
    413b:	e8 e5 fe ff ff       	call   4025 <morecore>
    4140:	83 c4 10             	add    $0x10,%esp
    4143:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4146:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    414a:	75 07                	jne    4153 <malloc+0xce>
        return 0;
    414c:	b8 00 00 00 00       	mov    $0x0,%eax
    4151:	eb 13                	jmp    4166 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4153:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4156:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4159:	8b 45 f4             	mov    -0xc(%ebp),%eax
    415c:	8b 00                	mov    (%eax),%eax
    415e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4161:	e9 6d ff ff ff       	jmp    40d3 <malloc+0x4e>
  }
}
    4166:	c9                   	leave  
    4167:	c3                   	ret    
