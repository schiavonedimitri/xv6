
kernel:     formato del file elf32-i386


Disassemblamento della sezione .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc e0 3b 11 80       	mov    $0x80113be0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 ad 34 10 80       	mov    $0x801034ad,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 b8 85 10 80       	push   $0x801085b8
80100042:	68 c0 b5 10 80       	push   $0x8010b5c0
80100047:	e8 6d 4f 00 00       	call   80104fb9 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 f0 ca 10 80 e4 	movl   $0x8010cae4,0x8010caf0
80100056:	ca 10 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 f4 ca 10 80 e4 	movl   $0x8010cae4,0x8010caf4
80100060:	ca 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 f4 b5 10 80 	movl   $0x8010b5f4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 f4 ca 10 80    	mov    0x8010caf4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c e4 ca 10 80 	movl   $0x8010cae4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 f4 ca 10 80       	mov    0x8010caf4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 f4 ca 10 80       	mov    %eax,0x8010caf4
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 e4 ca 10 80       	mov    $0x8010cae4,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
  }
}
801000b0:	90                   	nop
801000b1:	90                   	nop
801000b2:	c9                   	leave  
801000b3:	c3                   	ret    

801000b4 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b4:	55                   	push   %ebp
801000b5:	89 e5                	mov    %esp,%ebp
801000b7:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000ba:	83 ec 0c             	sub    $0xc,%esp
801000bd:	68 c0 b5 10 80       	push   $0x8010b5c0
801000c2:	e8 14 4f 00 00       	call   80104fdb <acquire>
801000c7:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ca:	a1 f4 ca 10 80       	mov    0x8010caf4,%eax
801000cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d2:	eb 67                	jmp    8010013b <bget+0x87>
    if(b->dev == dev && b->sector == sector){
801000d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d7:	8b 40 04             	mov    0x4(%eax),%eax
801000da:	39 45 08             	cmp    %eax,0x8(%ebp)
801000dd:	75 53                	jne    80100132 <bget+0x7e>
801000df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e2:	8b 40 08             	mov    0x8(%eax),%eax
801000e5:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000e8:	75 48                	jne    80100132 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ed:	8b 00                	mov    (%eax),%eax
801000ef:	83 e0 01             	and    $0x1,%eax
801000f2:	85 c0                	test   %eax,%eax
801000f4:	75 27                	jne    8010011d <bget+0x69>
        b->flags |= B_BUSY;
801000f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f9:	8b 00                	mov    (%eax),%eax
801000fb:	83 c8 01             	or     $0x1,%eax
801000fe:	89 c2                	mov    %eax,%edx
80100100:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100103:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100105:	83 ec 0c             	sub    $0xc,%esp
80100108:	68 c0 b5 10 80       	push   $0x8010b5c0
8010010d:	e8 30 4f 00 00       	call   80105042 <release>
80100112:	83 c4 10             	add    $0x10,%esp
        return b;
80100115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100118:	e9 98 00 00 00       	jmp    801001b5 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011d:	83 ec 08             	sub    $0x8,%esp
80100120:	68 c0 b5 10 80       	push   $0x8010b5c0
80100125:	ff 75 f4             	pushl  -0xc(%ebp)
80100128:	e8 8f 48 00 00       	call   801049bc <sleep>
8010012d:	83 c4 10             	add    $0x10,%esp
      goto loop;
80100130:	eb 98                	jmp    801000ca <bget+0x16>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100132:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100135:	8b 40 10             	mov    0x10(%eax),%eax
80100138:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013b:	81 7d f4 e4 ca 10 80 	cmpl   $0x8010cae4,-0xc(%ebp)
80100142:	75 90                	jne    801000d4 <bget+0x20>
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100144:	a1 f0 ca 10 80       	mov    0x8010caf0,%eax
80100149:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014c:	eb 51                	jmp    8010019f <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 01             	and    $0x1,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 3c                	jne    80100196 <bget+0xe2>
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 00                	mov    (%eax),%eax
8010015f:	83 e0 04             	and    $0x4,%eax
80100162:	85 c0                	test   %eax,%eax
80100164:	75 30                	jne    80100196 <bget+0xe2>
      b->dev = dev;
80100166:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100169:	8b 55 08             	mov    0x8(%ebp),%edx
8010016c:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
8010016f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100172:	8b 55 0c             	mov    0xc(%ebp),%edx
80100175:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100181:	83 ec 0c             	sub    $0xc,%esp
80100184:	68 c0 b5 10 80       	push   $0x8010b5c0
80100189:	e8 b4 4e 00 00       	call   80105042 <release>
8010018e:	83 c4 10             	add    $0x10,%esp
      return b;
80100191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100194:	eb 1f                	jmp    801001b5 <bget+0x101>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100199:	8b 40 0c             	mov    0xc(%eax),%eax
8010019c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019f:	81 7d f4 e4 ca 10 80 	cmpl   $0x8010cae4,-0xc(%ebp)
801001a6:	75 a6                	jne    8010014e <bget+0x9a>
    }
  }
  panic("bget: no buffers");
801001a8:	83 ec 0c             	sub    $0xc,%esp
801001ab:	68 bf 85 10 80       	push   $0x801085bf
801001b0:	e8 c6 03 00 00       	call   8010057b <panic>
}
801001b5:	c9                   	leave  
801001b6:	c3                   	ret    

801001b7 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001b7:	55                   	push   %ebp
801001b8:	89 e5                	mov    %esp,%ebp
801001ba:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, sector);
801001bd:	83 ec 08             	sub    $0x8,%esp
801001c0:	ff 75 0c             	pushl  0xc(%ebp)
801001c3:	ff 75 08             	pushl  0x8(%ebp)
801001c6:	e8 e9 fe ff ff       	call   801000b4 <bget>
801001cb:	83 c4 10             	add    $0x10,%esp
801001ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d4:	8b 00                	mov    (%eax),%eax
801001d6:	83 e0 02             	and    $0x2,%eax
801001d9:	85 c0                	test   %eax,%eax
801001db:	75 0e                	jne    801001eb <bread+0x34>
    iderw(b);
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	ff 75 f4             	pushl  -0xc(%ebp)
801001e3:	e8 99 26 00 00       	call   80102881 <iderw>
801001e8:	83 c4 10             	add    $0x10,%esp
  return b;
801001eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ee:	c9                   	leave  
801001ef:	c3                   	ret    

801001f0 <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f6:	8b 45 08             	mov    0x8(%ebp),%eax
801001f9:	8b 00                	mov    (%eax),%eax
801001fb:	83 e0 01             	and    $0x1,%eax
801001fe:	85 c0                	test   %eax,%eax
80100200:	75 0d                	jne    8010020f <bwrite+0x1f>
    panic("bwrite");
80100202:	83 ec 0c             	sub    $0xc,%esp
80100205:	68 d0 85 10 80       	push   $0x801085d0
8010020a:	e8 6c 03 00 00       	call   8010057b <panic>
  b->flags |= B_DIRTY;
8010020f:	8b 45 08             	mov    0x8(%ebp),%eax
80100212:	8b 00                	mov    (%eax),%eax
80100214:	83 c8 04             	or     $0x4,%eax
80100217:	89 c2                	mov    %eax,%edx
80100219:	8b 45 08             	mov    0x8(%ebp),%eax
8010021c:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021e:	83 ec 0c             	sub    $0xc,%esp
80100221:	ff 75 08             	pushl  0x8(%ebp)
80100224:	e8 58 26 00 00       	call   80102881 <iderw>
80100229:	83 c4 10             	add    $0x10,%esp
}
8010022c:	90                   	nop
8010022d:	c9                   	leave  
8010022e:	c3                   	ret    

8010022f <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022f:	55                   	push   %ebp
80100230:	89 e5                	mov    %esp,%ebp
80100232:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100235:	8b 45 08             	mov    0x8(%ebp),%eax
80100238:	8b 00                	mov    (%eax),%eax
8010023a:	83 e0 01             	and    $0x1,%eax
8010023d:	85 c0                	test   %eax,%eax
8010023f:	75 0d                	jne    8010024e <brelse+0x1f>
    panic("brelse");
80100241:	83 ec 0c             	sub    $0xc,%esp
80100244:	68 d7 85 10 80       	push   $0x801085d7
80100249:	e8 2d 03 00 00       	call   8010057b <panic>

  acquire(&bcache.lock);
8010024e:	83 ec 0c             	sub    $0xc,%esp
80100251:	68 c0 b5 10 80       	push   $0x8010b5c0
80100256:	e8 80 4d 00 00       	call   80104fdb <acquire>
8010025b:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025e:	8b 45 08             	mov    0x8(%ebp),%eax
80100261:	8b 40 10             	mov    0x10(%eax),%eax
80100264:	8b 55 08             	mov    0x8(%ebp),%edx
80100267:	8b 52 0c             	mov    0xc(%edx),%edx
8010026a:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026d:	8b 45 08             	mov    0x8(%ebp),%eax
80100270:	8b 40 0c             	mov    0xc(%eax),%eax
80100273:	8b 55 08             	mov    0x8(%ebp),%edx
80100276:	8b 52 10             	mov    0x10(%edx),%edx
80100279:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027c:	8b 15 f4 ca 10 80    	mov    0x8010caf4,%edx
80100282:	8b 45 08             	mov    0x8(%ebp),%eax
80100285:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	c7 40 0c e4 ca 10 80 	movl   $0x8010cae4,0xc(%eax)
  bcache.head.next->prev = b;
80100292:	a1 f4 ca 10 80       	mov    0x8010caf4,%eax
80100297:	8b 55 08             	mov    0x8(%ebp),%edx
8010029a:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029d:	8b 45 08             	mov    0x8(%ebp),%eax
801002a0:	a3 f4 ca 10 80       	mov    %eax,0x8010caf4

  b->flags &= ~B_BUSY;
801002a5:	8b 45 08             	mov    0x8(%ebp),%eax
801002a8:	8b 00                	mov    (%eax),%eax
801002aa:	83 e0 fe             	and    $0xfffffffe,%eax
801002ad:	89 c2                	mov    %eax,%edx
801002af:	8b 45 08             	mov    0x8(%ebp),%eax
801002b2:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b4:	83 ec 0c             	sub    $0xc,%esp
801002b7:	ff 75 08             	pushl  0x8(%ebp)
801002ba:	e8 ec 47 00 00       	call   80104aab <wakeup>
801002bf:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c2:	83 ec 0c             	sub    $0xc,%esp
801002c5:	68 c0 b5 10 80       	push   $0x8010b5c0
801002ca:	e8 73 4d 00 00       	call   80105042 <release>
801002cf:	83 c4 10             	add    $0x10,%esp
}
801002d2:	90                   	nop
801002d3:	c9                   	leave  
801002d4:	c3                   	ret    

801002d5 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d5:	55                   	push   %ebp
801002d6:	89 e5                	mov    %esp,%ebp
801002d8:	83 ec 14             	sub    $0x14,%esp
801002db:	8b 45 08             	mov    0x8(%ebp),%eax
801002de:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e6:	89 c2                	mov    %eax,%edx
801002e8:	ec                   	in     (%dx),%al
801002e9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002ec:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002f0:	c9                   	leave  
801002f1:	c3                   	ret    

801002f2 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f2:	55                   	push   %ebp
801002f3:	89 e5                	mov    %esp,%ebp
801002f5:	83 ec 08             	sub    $0x8,%esp
801002f8:	8b 45 08             	mov    0x8(%ebp),%eax
801002fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801002fe:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80100302:	89 d0                	mov    %edx,%eax
80100304:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100307:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010030b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030f:	ee                   	out    %al,(%dx)
}
80100310:	90                   	nop
80100311:	c9                   	leave  
80100312:	c3                   	ret    

80100313 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100313:	55                   	push   %ebp
80100314:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100316:	fa                   	cli    
}
80100317:	90                   	nop
80100318:	5d                   	pop    %ebp
80100319:	c3                   	ret    

8010031a <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010031a:	55                   	push   %ebp
8010031b:	89 e5                	mov    %esp,%ebp
8010031d:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100320:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100324:	74 1c                	je     80100342 <printint+0x28>
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	c1 e8 1f             	shr    $0x1f,%eax
8010032c:	0f b6 c0             	movzbl %al,%eax
8010032f:	89 45 10             	mov    %eax,0x10(%ebp)
80100332:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100336:	74 0a                	je     80100342 <printint+0x28>
    x = -xx;
80100338:	8b 45 08             	mov    0x8(%ebp),%eax
8010033b:	f7 d8                	neg    %eax
8010033d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100340:	eb 06                	jmp    80100348 <printint+0x2e>
  else
    x = xx;
80100342:	8b 45 08             	mov    0x8(%ebp),%eax
80100345:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100352:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100355:	ba 00 00 00 00       	mov    $0x0,%edx
8010035a:	f7 f1                	div    %ecx
8010035c:	89 d1                	mov    %edx,%ecx
8010035e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100361:	8d 50 01             	lea    0x1(%eax),%edx
80100364:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100367:	0f b6 91 04 90 10 80 	movzbl -0x7fef6ffc(%ecx),%edx
8010036e:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
80100372:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100375:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100378:	ba 00 00 00 00       	mov    $0x0,%edx
8010037d:	f7 f1                	div    %ecx
8010037f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100382:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100386:	75 c7                	jne    8010034f <printint+0x35>

  if(sign)
80100388:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038c:	74 2a                	je     801003b8 <printint+0x9e>
    buf[i++] = '-';
8010038e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100391:	8d 50 01             	lea    0x1(%eax),%edx
80100394:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100397:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039c:	eb 1a                	jmp    801003b8 <printint+0x9e>
    consputc(buf[i]);
8010039e:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a4:	01 d0                	add    %edx,%eax
801003a6:	0f b6 00             	movzbl (%eax),%eax
801003a9:	0f be c0             	movsbl %al,%eax
801003ac:	83 ec 0c             	sub    $0xc,%esp
801003af:	50                   	push   %eax
801003b0:	e8 e4 03 00 00       	call   80100799 <consputc>
801003b5:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003b8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003c0:	79 dc                	jns    8010039e <printint+0x84>
}
801003c2:	90                   	nop
801003c3:	90                   	nop
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 14 ce 10 80       	mov    0x8010ce14,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 cd 10 80       	push   $0x8010cde0
801003e2:	e8 f4 4b 00 00       	call   80104fdb <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 de 85 10 80       	push   $0x801085de
801003f9:	e8 7d 01 00 00       	call   8010057b <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 2f 01 00 00       	jmp    8010053f <cprintf+0x179>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 78 03 00 00       	call   80100799 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 12 01 00 00       	jmp    8010053b <cprintf+0x175>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 14 01 00 00    	je     80100561 <cprintf+0x19b>
      break;
    switch(c){
8010044d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100451:	74 5e                	je     801004b1 <cprintf+0xeb>
80100453:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100457:	0f 8f c2 00 00 00    	jg     8010051f <cprintf+0x159>
8010045d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100461:	74 6b                	je     801004ce <cprintf+0x108>
80100463:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100467:	0f 8f b2 00 00 00    	jg     8010051f <cprintf+0x159>
8010046d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
80100471:	74 3e                	je     801004b1 <cprintf+0xeb>
80100473:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
80100477:	0f 8f a2 00 00 00    	jg     8010051f <cprintf+0x159>
8010047d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100481:	0f 84 89 00 00 00    	je     80100510 <cprintf+0x14a>
80100487:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
8010048b:	0f 85 8e 00 00 00    	jne    8010051f <cprintf+0x159>
    case 'd':
      printint(*argp++, 10, 1);
80100491:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100494:	8d 50 04             	lea    0x4(%eax),%edx
80100497:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010049a:	8b 00                	mov    (%eax),%eax
8010049c:	83 ec 04             	sub    $0x4,%esp
8010049f:	6a 01                	push   $0x1
801004a1:	6a 0a                	push   $0xa
801004a3:	50                   	push   %eax
801004a4:	e8 71 fe ff ff       	call   8010031a <printint>
801004a9:	83 c4 10             	add    $0x10,%esp
      break;
801004ac:	e9 8a 00 00 00       	jmp    8010053b <cprintf+0x175>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b4:	8d 50 04             	lea    0x4(%eax),%edx
801004b7:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004ba:	8b 00                	mov    (%eax),%eax
801004bc:	83 ec 04             	sub    $0x4,%esp
801004bf:	6a 00                	push   $0x0
801004c1:	6a 10                	push   $0x10
801004c3:	50                   	push   %eax
801004c4:	e8 51 fe ff ff       	call   8010031a <printint>
801004c9:	83 c4 10             	add    $0x10,%esp
      break;
801004cc:	eb 6d                	jmp    8010053b <cprintf+0x175>
    case 's':
      if((s = (char*)*argp++) == 0)
801004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004d1:	8d 50 04             	lea    0x4(%eax),%edx
801004d4:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004d7:	8b 00                	mov    (%eax),%eax
801004d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004e0:	75 22                	jne    80100504 <cprintf+0x13e>
        s = "(null)";
801004e2:	c7 45 ec e7 85 10 80 	movl   $0x801085e7,-0x14(%ebp)
      for(; *s; s++)
801004e9:	eb 19                	jmp    80100504 <cprintf+0x13e>
        consputc(*s);
801004eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004ee:	0f b6 00             	movzbl (%eax),%eax
801004f1:	0f be c0             	movsbl %al,%eax
801004f4:	83 ec 0c             	sub    $0xc,%esp
801004f7:	50                   	push   %eax
801004f8:	e8 9c 02 00 00       	call   80100799 <consputc>
801004fd:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
80100500:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100504:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100507:	0f b6 00             	movzbl (%eax),%eax
8010050a:	84 c0                	test   %al,%al
8010050c:	75 dd                	jne    801004eb <cprintf+0x125>
      break;
8010050e:	eb 2b                	jmp    8010053b <cprintf+0x175>
    case '%':
      consputc('%');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 25                	push   $0x25
80100515:	e8 7f 02 00 00       	call   80100799 <consputc>
8010051a:	83 c4 10             	add    $0x10,%esp
      break;
8010051d:	eb 1c                	jmp    8010053b <cprintf+0x175>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010051f:	83 ec 0c             	sub    $0xc,%esp
80100522:	6a 25                	push   $0x25
80100524:	e8 70 02 00 00       	call   80100799 <consputc>
80100529:	83 c4 10             	add    $0x10,%esp
      consputc(c);
8010052c:	83 ec 0c             	sub    $0xc,%esp
8010052f:	ff 75 e4             	pushl  -0x1c(%ebp)
80100532:	e8 62 02 00 00       	call   80100799 <consputc>
80100537:	83 c4 10             	add    $0x10,%esp
      break;
8010053a:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010053b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010053f:	8b 55 08             	mov    0x8(%ebp),%edx
80100542:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100545:	01 d0                	add    %edx,%eax
80100547:	0f b6 00             	movzbl (%eax),%eax
8010054a:	0f be c0             	movsbl %al,%eax
8010054d:	25 ff 00 00 00       	and    $0xff,%eax
80100552:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100555:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100559:	0f 85 b1 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010055f:	eb 01                	jmp    80100562 <cprintf+0x19c>
      break;
80100561:	90                   	nop
    }
  }

  if(locking)
80100562:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100566:	74 10                	je     80100578 <cprintf+0x1b2>
    release(&cons.lock);
80100568:	83 ec 0c             	sub    $0xc,%esp
8010056b:	68 e0 cd 10 80       	push   $0x8010cde0
80100570:	e8 cd 4a 00 00       	call   80105042 <release>
80100575:	83 c4 10             	add    $0x10,%esp
}
80100578:	90                   	nop
80100579:	c9                   	leave  
8010057a:	c3                   	ret    

8010057b <panic>:

void
panic(char *s)
{
8010057b:	55                   	push   %ebp
8010057c:	89 e5                	mov    %esp,%ebp
8010057e:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
80100581:	e8 8d fd ff ff       	call   80100313 <cli>
  cons.locking = 0;
80100586:	c7 05 14 ce 10 80 00 	movl   $0x0,0x8010ce14
8010058d:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100590:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100596:	0f b6 00             	movzbl (%eax),%eax
80100599:	0f b6 c0             	movzbl %al,%eax
8010059c:	83 ec 08             	sub    $0x8,%esp
8010059f:	50                   	push   %eax
801005a0:	68 ee 85 10 80       	push   $0x801085ee
801005a5:	e8 1c fe ff ff       	call   801003c6 <cprintf>
801005aa:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005ad:	8b 45 08             	mov    0x8(%ebp),%eax
801005b0:	83 ec 0c             	sub    $0xc,%esp
801005b3:	50                   	push   %eax
801005b4:	e8 0d fe ff ff       	call   801003c6 <cprintf>
801005b9:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005bc:	83 ec 0c             	sub    $0xc,%esp
801005bf:	68 fd 85 10 80       	push   $0x801085fd
801005c4:	e8 fd fd ff ff       	call   801003c6 <cprintf>
801005c9:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005cc:	83 ec 08             	sub    $0x8,%esp
801005cf:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005d2:	50                   	push   %eax
801005d3:	8d 45 08             	lea    0x8(%ebp),%eax
801005d6:	50                   	push   %eax
801005d7:	e8 b8 4a 00 00       	call   80105094 <getcallerpcs>
801005dc:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005e6:	eb 1c                	jmp    80100604 <panic+0x89>
    cprintf(" %p", pcs[i]);
801005e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005eb:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005ef:	83 ec 08             	sub    $0x8,%esp
801005f2:	50                   	push   %eax
801005f3:	68 ff 85 10 80       	push   $0x801085ff
801005f8:	e8 c9 fd ff ff       	call   801003c6 <cprintf>
801005fd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100600:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100604:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100608:	7e de                	jle    801005e8 <panic+0x6d>
  panicked = 1; // freeze other CPU
8010060a:	c7 05 c0 cd 10 80 01 	movl   $0x1,0x8010cdc0
80100611:	00 00 00 
  for(;;)
80100614:	eb fe                	jmp    80100614 <panic+0x99>

80100616 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100616:	55                   	push   %ebp
80100617:	89 e5                	mov    %esp,%ebp
80100619:	53                   	push   %ebx
8010061a:	83 ec 14             	sub    $0x14,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
8010061d:	6a 0e                	push   $0xe
8010061f:	68 d4 03 00 00       	push   $0x3d4
80100624:	e8 c9 fc ff ff       	call   801002f2 <outb>
80100629:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
8010062c:	68 d5 03 00 00       	push   $0x3d5
80100631:	e8 9f fc ff ff       	call   801002d5 <inb>
80100636:	83 c4 04             	add    $0x4,%esp
80100639:	0f b6 c0             	movzbl %al,%eax
8010063c:	c1 e0 08             	shl    $0x8,%eax
8010063f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100642:	6a 0f                	push   $0xf
80100644:	68 d4 03 00 00       	push   $0x3d4
80100649:	e8 a4 fc ff ff       	call   801002f2 <outb>
8010064e:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100651:	68 d5 03 00 00       	push   $0x3d5
80100656:	e8 7a fc ff ff       	call   801002d5 <inb>
8010065b:	83 c4 04             	add    $0x4,%esp
8010065e:	0f b6 c0             	movzbl %al,%eax
80100661:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100664:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100668:	75 34                	jne    8010069e <cgaputc+0x88>
    pos += 80 - pos%80;
8010066a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010066d:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100672:	89 c8                	mov    %ecx,%eax
80100674:	f7 ea                	imul   %edx
80100676:	89 d0                	mov    %edx,%eax
80100678:	c1 f8 05             	sar    $0x5,%eax
8010067b:	89 cb                	mov    %ecx,%ebx
8010067d:	c1 fb 1f             	sar    $0x1f,%ebx
80100680:	29 d8                	sub    %ebx,%eax
80100682:	89 c2                	mov    %eax,%edx
80100684:	89 d0                	mov    %edx,%eax
80100686:	c1 e0 02             	shl    $0x2,%eax
80100689:	01 d0                	add    %edx,%eax
8010068b:	c1 e0 04             	shl    $0x4,%eax
8010068e:	29 c1                	sub    %eax,%ecx
80100690:	89 ca                	mov    %ecx,%edx
80100692:	b8 50 00 00 00       	mov    $0x50,%eax
80100697:	29 d0                	sub    %edx,%eax
80100699:	01 45 f4             	add    %eax,-0xc(%ebp)
8010069c:	eb 38                	jmp    801006d6 <cgaputc+0xc0>
  else if(c == BACKSPACE){
8010069e:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006a5:	75 0c                	jne    801006b3 <cgaputc+0x9d>
    if(pos > 0) --pos;
801006a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006ab:	7e 29                	jle    801006d6 <cgaputc+0xc0>
801006ad:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801006b1:	eb 23                	jmp    801006d6 <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801006b3:	8b 45 08             	mov    0x8(%ebp),%eax
801006b6:	0f b6 c0             	movzbl %al,%eax
801006b9:	80 cc 07             	or     $0x7,%ah
801006bc:	89 c1                	mov    %eax,%ecx
801006be:	8b 1d 00 90 10 80    	mov    0x80109000,%ebx
801006c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006c7:	8d 50 01             	lea    0x1(%eax),%edx
801006ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006cd:	01 c0                	add    %eax,%eax
801006cf:	01 d8                	add    %ebx,%eax
801006d1:	89 ca                	mov    %ecx,%edx
801006d3:	66 89 10             	mov    %dx,(%eax)
  
  if((pos/80) >= 24){  // Scroll up.
801006d6:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006dd:	7e 4d                	jle    8010072c <cgaputc+0x116>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006df:	a1 00 90 10 80       	mov    0x80109000,%eax
801006e4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006ea:	a1 00 90 10 80       	mov    0x80109000,%eax
801006ef:	83 ec 04             	sub    $0x4,%esp
801006f2:	68 60 0e 00 00       	push   $0xe60
801006f7:	52                   	push   %edx
801006f8:	50                   	push   %eax
801006f9:	e8 ff 4b 00 00       	call   801052fd <memmove>
801006fe:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
80100701:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100705:	b8 80 07 00 00       	mov    $0x780,%eax
8010070a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070d:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100710:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100719:	01 c0                	add    %eax,%eax
8010071b:	01 c8                	add    %ecx,%eax
8010071d:	83 ec 04             	sub    $0x4,%esp
80100720:	52                   	push   %edx
80100721:	6a 00                	push   $0x0
80100723:	50                   	push   %eax
80100724:	e8 15 4b 00 00       	call   8010523e <memset>
80100729:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
8010072c:	83 ec 08             	sub    $0x8,%esp
8010072f:	6a 0e                	push   $0xe
80100731:	68 d4 03 00 00       	push   $0x3d4
80100736:	e8 b7 fb ff ff       	call   801002f2 <outb>
8010073b:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100741:	c1 f8 08             	sar    $0x8,%eax
80100744:	0f b6 c0             	movzbl %al,%eax
80100747:	83 ec 08             	sub    $0x8,%esp
8010074a:	50                   	push   %eax
8010074b:	68 d5 03 00 00       	push   $0x3d5
80100750:	e8 9d fb ff ff       	call   801002f2 <outb>
80100755:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100758:	83 ec 08             	sub    $0x8,%esp
8010075b:	6a 0f                	push   $0xf
8010075d:	68 d4 03 00 00       	push   $0x3d4
80100762:	e8 8b fb ff ff       	call   801002f2 <outb>
80100767:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010076a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076d:	0f b6 c0             	movzbl %al,%eax
80100770:	83 ec 08             	sub    $0x8,%esp
80100773:	50                   	push   %eax
80100774:	68 d5 03 00 00       	push   $0x3d5
80100779:	e8 74 fb ff ff       	call   801002f2 <outb>
8010077e:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100781:	8b 15 00 90 10 80    	mov    0x80109000,%edx
80100787:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010078a:	01 c0                	add    %eax,%eax
8010078c:	01 d0                	add    %edx,%eax
8010078e:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100793:	90                   	nop
80100794:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100797:	c9                   	leave  
80100798:	c3                   	ret    

80100799 <consputc>:

void
consputc(int c)
{
80100799:	55                   	push   %ebp
8010079a:	89 e5                	mov    %esp,%ebp
8010079c:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
8010079f:	a1 c0 cd 10 80       	mov    0x8010cdc0,%eax
801007a4:	85 c0                	test   %eax,%eax
801007a6:	74 07                	je     801007af <consputc+0x16>
    cli();
801007a8:	e8 66 fb ff ff       	call   80100313 <cli>
    for(;;)
801007ad:	eb fe                	jmp    801007ad <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
801007af:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007b6:	75 29                	jne    801007e1 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b8:	83 ec 0c             	sub    $0xc,%esp
801007bb:	6a 08                	push   $0x8
801007bd:	e8 91 64 00 00       	call   80106c53 <uartputc>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	83 ec 0c             	sub    $0xc,%esp
801007c8:	6a 20                	push   $0x20
801007ca:	e8 84 64 00 00       	call   80106c53 <uartputc>
801007cf:	83 c4 10             	add    $0x10,%esp
801007d2:	83 ec 0c             	sub    $0xc,%esp
801007d5:	6a 08                	push   $0x8
801007d7:	e8 77 64 00 00       	call   80106c53 <uartputc>
801007dc:	83 c4 10             	add    $0x10,%esp
801007df:	eb 0e                	jmp    801007ef <consputc+0x56>
  } else
    uartputc(c);
801007e1:	83 ec 0c             	sub    $0xc,%esp
801007e4:	ff 75 08             	pushl  0x8(%ebp)
801007e7:	e8 67 64 00 00       	call   80106c53 <uartputc>
801007ec:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007ef:	83 ec 0c             	sub    $0xc,%esp
801007f2:	ff 75 08             	pushl  0x8(%ebp)
801007f5:	e8 1c fe ff ff       	call   80100616 <cgaputc>
801007fa:	83 c4 10             	add    $0x10,%esp
}
801007fd:	90                   	nop
801007fe:	c9                   	leave  
801007ff:	c3                   	ret    

80100800 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100800:	55                   	push   %ebp
80100801:	89 e5                	mov    %esp,%ebp
80100803:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
80100806:	83 ec 0c             	sub    $0xc,%esp
80100809:	68 00 cd 10 80       	push   $0x8010cd00
8010080e:	e8 c8 47 00 00       	call   80104fdb <acquire>
80100813:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100816:	e9 4a 01 00 00       	jmp    80100965 <consoleintr+0x165>
    switch(c){
8010081b:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010081f:	74 7f                	je     801008a0 <consoleintr+0xa0>
80100821:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80100825:	0f 8f aa 00 00 00    	jg     801008d5 <consoleintr+0xd5>
8010082b:	83 7d f4 15          	cmpl   $0x15,-0xc(%ebp)
8010082f:	74 41                	je     80100872 <consoleintr+0x72>
80100831:	83 7d f4 15          	cmpl   $0x15,-0xc(%ebp)
80100835:	0f 8f 9a 00 00 00    	jg     801008d5 <consoleintr+0xd5>
8010083b:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
8010083f:	74 5f                	je     801008a0 <consoleintr+0xa0>
80100841:	83 7d f4 10          	cmpl   $0x10,-0xc(%ebp)
80100845:	0f 85 8a 00 00 00    	jne    801008d5 <consoleintr+0xd5>
    case C('P'):  // Process listing.
      procdump();
8010084b:	e8 19 43 00 00       	call   80104b69 <procdump>
      break;
80100850:	e9 10 01 00 00       	jmp    80100965 <consoleintr+0x165>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100855:	a1 bc cd 10 80       	mov    0x8010cdbc,%eax
8010085a:	83 e8 01             	sub    $0x1,%eax
8010085d:	a3 bc cd 10 80       	mov    %eax,0x8010cdbc
        consputc(BACKSPACE);
80100862:	83 ec 0c             	sub    $0xc,%esp
80100865:	68 00 01 00 00       	push   $0x100
8010086a:	e8 2a ff ff ff       	call   80100799 <consputc>
8010086f:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
80100872:	8b 15 bc cd 10 80    	mov    0x8010cdbc,%edx
80100878:	a1 b8 cd 10 80       	mov    0x8010cdb8,%eax
8010087d:	39 c2                	cmp    %eax,%edx
8010087f:	0f 84 e0 00 00 00    	je     80100965 <consoleintr+0x165>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100885:	a1 bc cd 10 80       	mov    0x8010cdbc,%eax
8010088a:	83 e8 01             	sub    $0x1,%eax
8010088d:	83 e0 7f             	and    $0x7f,%eax
80100890:	0f b6 80 34 cd 10 80 	movzbl -0x7fef32cc(%eax),%eax
      while(input.e != input.w &&
80100897:	3c 0a                	cmp    $0xa,%al
80100899:	75 ba                	jne    80100855 <consoleintr+0x55>
      }
      break;
8010089b:	e9 c5 00 00 00       	jmp    80100965 <consoleintr+0x165>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008a0:	8b 15 bc cd 10 80    	mov    0x8010cdbc,%edx
801008a6:	a1 b8 cd 10 80       	mov    0x8010cdb8,%eax
801008ab:	39 c2                	cmp    %eax,%edx
801008ad:	0f 84 b2 00 00 00    	je     80100965 <consoleintr+0x165>
        input.e--;
801008b3:	a1 bc cd 10 80       	mov    0x8010cdbc,%eax
801008b8:	83 e8 01             	sub    $0x1,%eax
801008bb:	a3 bc cd 10 80       	mov    %eax,0x8010cdbc
        consputc(BACKSPACE);
801008c0:	83 ec 0c             	sub    $0xc,%esp
801008c3:	68 00 01 00 00       	push   $0x100
801008c8:	e8 cc fe ff ff       	call   80100799 <consputc>
801008cd:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008d0:	e9 90 00 00 00       	jmp    80100965 <consoleintr+0x165>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801008d9:	0f 84 85 00 00 00    	je     80100964 <consoleintr+0x164>
801008df:	a1 bc cd 10 80       	mov    0x8010cdbc,%eax
801008e4:	8b 15 b4 cd 10 80    	mov    0x8010cdb4,%edx
801008ea:	29 d0                	sub    %edx,%eax
801008ec:	83 f8 7f             	cmp    $0x7f,%eax
801008ef:	77 73                	ja     80100964 <consoleintr+0x164>
        c = (c == '\r') ? '\n' : c;
801008f1:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008f5:	74 05                	je     801008fc <consoleintr+0xfc>
801008f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008fa:	eb 05                	jmp    80100901 <consoleintr+0x101>
801008fc:	b8 0a 00 00 00       	mov    $0xa,%eax
80100901:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100904:	a1 bc cd 10 80       	mov    0x8010cdbc,%eax
80100909:	8d 50 01             	lea    0x1(%eax),%edx
8010090c:	89 15 bc cd 10 80    	mov    %edx,0x8010cdbc
80100912:	83 e0 7f             	and    $0x7f,%eax
80100915:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100918:	88 90 34 cd 10 80    	mov    %dl,-0x7fef32cc(%eax)
        consputc(c);
8010091e:	83 ec 0c             	sub    $0xc,%esp
80100921:	ff 75 f4             	pushl  -0xc(%ebp)
80100924:	e8 70 fe ff ff       	call   80100799 <consputc>
80100929:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010092c:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80100930:	74 18                	je     8010094a <consoleintr+0x14a>
80100932:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80100936:	74 12                	je     8010094a <consoleintr+0x14a>
80100938:	a1 bc cd 10 80       	mov    0x8010cdbc,%eax
8010093d:	8b 15 b4 cd 10 80    	mov    0x8010cdb4,%edx
80100943:	83 ea 80             	sub    $0xffffff80,%edx
80100946:	39 d0                	cmp    %edx,%eax
80100948:	75 1a                	jne    80100964 <consoleintr+0x164>
          input.w = input.e;
8010094a:	a1 bc cd 10 80       	mov    0x8010cdbc,%eax
8010094f:	a3 b8 cd 10 80       	mov    %eax,0x8010cdb8
          wakeup(&input.r);
80100954:	83 ec 0c             	sub    $0xc,%esp
80100957:	68 b4 cd 10 80       	push   $0x8010cdb4
8010095c:	e8 4a 41 00 00       	call   80104aab <wakeup>
80100961:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100964:	90                   	nop
  while((c = getc()) >= 0){
80100965:	8b 45 08             	mov    0x8(%ebp),%eax
80100968:	ff d0                	call   *%eax
8010096a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010096d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100971:	0f 89 a4 fe ff ff    	jns    8010081b <consoleintr+0x1b>
    }
  }
  release(&input.lock);
80100977:	83 ec 0c             	sub    $0xc,%esp
8010097a:	68 00 cd 10 80       	push   $0x8010cd00
8010097f:	e8 be 46 00 00       	call   80105042 <release>
80100984:	83 c4 10             	add    $0x10,%esp
}
80100987:	90                   	nop
80100988:	c9                   	leave  
80100989:	c3                   	ret    

8010098a <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010098a:	55                   	push   %ebp
8010098b:	89 e5                	mov    %esp,%ebp
8010098d:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100990:	83 ec 0c             	sub    $0xc,%esp
80100993:	ff 75 08             	pushl  0x8(%ebp)
80100996:	e8 e8 10 00 00       	call   80101a83 <iunlock>
8010099b:	83 c4 10             	add    $0x10,%esp
  target = n;
8010099e:	8b 45 10             	mov    0x10(%ebp),%eax
801009a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
801009a4:	83 ec 0c             	sub    $0xc,%esp
801009a7:	68 00 cd 10 80       	push   $0x8010cd00
801009ac:	e8 2a 46 00 00       	call   80104fdb <acquire>
801009b1:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009b4:	e9 ac 00 00 00       	jmp    80100a65 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
801009b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009bf:	8b 40 24             	mov    0x24(%eax),%eax
801009c2:	85 c0                	test   %eax,%eax
801009c4:	74 28                	je     801009ee <consoleread+0x64>
        release(&input.lock);
801009c6:	83 ec 0c             	sub    $0xc,%esp
801009c9:	68 00 cd 10 80       	push   $0x8010cd00
801009ce:	e8 6f 46 00 00       	call   80105042 <release>
801009d3:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009d6:	83 ec 0c             	sub    $0xc,%esp
801009d9:	ff 75 08             	pushl  0x8(%ebp)
801009dc:	e8 4a 0f 00 00       	call   8010192b <ilock>
801009e1:	83 c4 10             	add    $0x10,%esp
        return -1;
801009e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009e9:	e9 a9 00 00 00       	jmp    80100a97 <consoleread+0x10d>
      }
      sleep(&input.r, &input.lock);
801009ee:	83 ec 08             	sub    $0x8,%esp
801009f1:	68 00 cd 10 80       	push   $0x8010cd00
801009f6:	68 b4 cd 10 80       	push   $0x8010cdb4
801009fb:	e8 bc 3f 00 00       	call   801049bc <sleep>
80100a00:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100a03:	8b 15 b4 cd 10 80    	mov    0x8010cdb4,%edx
80100a09:	a1 b8 cd 10 80       	mov    0x8010cdb8,%eax
80100a0e:	39 c2                	cmp    %eax,%edx
80100a10:	74 a7                	je     801009b9 <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a12:	a1 b4 cd 10 80       	mov    0x8010cdb4,%eax
80100a17:	8d 50 01             	lea    0x1(%eax),%edx
80100a1a:	89 15 b4 cd 10 80    	mov    %edx,0x8010cdb4
80100a20:	83 e0 7f             	and    $0x7f,%eax
80100a23:	0f b6 80 34 cd 10 80 	movzbl -0x7fef32cc(%eax),%eax
80100a2a:	0f be c0             	movsbl %al,%eax
80100a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a30:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a34:	75 17                	jne    80100a4d <consoleread+0xc3>
      if(n < target){
80100a36:	8b 45 10             	mov    0x10(%ebp),%eax
80100a39:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100a3c:	76 2f                	jbe    80100a6d <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a3e:	a1 b4 cd 10 80       	mov    0x8010cdb4,%eax
80100a43:	83 e8 01             	sub    $0x1,%eax
80100a46:	a3 b4 cd 10 80       	mov    %eax,0x8010cdb4
      }
      break;
80100a4b:	eb 20                	jmp    80100a6d <consoleread+0xe3>
    }
    *dst++ = c;
80100a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a50:	8d 50 01             	lea    0x1(%eax),%edx
80100a53:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a56:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a59:	88 10                	mov    %dl,(%eax)
    --n;
80100a5b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a5f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a63:	74 0b                	je     80100a70 <consoleread+0xe6>
  while(n > 0){
80100a65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a69:	7f 98                	jg     80100a03 <consoleread+0x79>
80100a6b:	eb 04                	jmp    80100a71 <consoleread+0xe7>
      break;
80100a6d:	90                   	nop
80100a6e:	eb 01                	jmp    80100a71 <consoleread+0xe7>
      break;
80100a70:	90                   	nop
  }
  release(&input.lock);
80100a71:	83 ec 0c             	sub    $0xc,%esp
80100a74:	68 00 cd 10 80       	push   $0x8010cd00
80100a79:	e8 c4 45 00 00       	call   80105042 <release>
80100a7e:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a81:	83 ec 0c             	sub    $0xc,%esp
80100a84:	ff 75 08             	pushl  0x8(%ebp)
80100a87:	e8 9f 0e 00 00       	call   8010192b <ilock>
80100a8c:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a8f:	8b 55 10             	mov    0x10(%ebp),%edx
80100a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a95:	29 d0                	sub    %edx,%eax
}
80100a97:	c9                   	leave  
80100a98:	c3                   	ret    

80100a99 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a99:	55                   	push   %ebp
80100a9a:	89 e5                	mov    %esp,%ebp
80100a9c:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a9f:	83 ec 0c             	sub    $0xc,%esp
80100aa2:	ff 75 08             	pushl  0x8(%ebp)
80100aa5:	e8 d9 0f 00 00       	call   80101a83 <iunlock>
80100aaa:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100aad:	83 ec 0c             	sub    $0xc,%esp
80100ab0:	68 e0 cd 10 80       	push   $0x8010cde0
80100ab5:	e8 21 45 00 00       	call   80104fdb <acquire>
80100aba:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100abd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100ac4:	eb 21                	jmp    80100ae7 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100ac6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100acc:	01 d0                	add    %edx,%eax
80100ace:	0f b6 00             	movzbl (%eax),%eax
80100ad1:	0f be c0             	movsbl %al,%eax
80100ad4:	0f b6 c0             	movzbl %al,%eax
80100ad7:	83 ec 0c             	sub    $0xc,%esp
80100ada:	50                   	push   %eax
80100adb:	e8 b9 fc ff ff       	call   80100799 <consputc>
80100ae0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ae3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100aea:	3b 45 10             	cmp    0x10(%ebp),%eax
80100aed:	7c d7                	jl     80100ac6 <consolewrite+0x2d>
  release(&cons.lock);
80100aef:	83 ec 0c             	sub    $0xc,%esp
80100af2:	68 e0 cd 10 80       	push   $0x8010cde0
80100af7:	e8 46 45 00 00       	call   80105042 <release>
80100afc:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100aff:	83 ec 0c             	sub    $0xc,%esp
80100b02:	ff 75 08             	pushl  0x8(%ebp)
80100b05:	e8 21 0e 00 00       	call   8010192b <ilock>
80100b0a:	83 c4 10             	add    $0x10,%esp

  return n;
80100b0d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b10:	c9                   	leave  
80100b11:	c3                   	ret    

80100b12 <consoleinit>:

void
consoleinit(void)
{
80100b12:	55                   	push   %ebp
80100b13:	89 e5                	mov    %esp,%ebp
80100b15:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b18:	83 ec 08             	sub    $0x8,%esp
80100b1b:	68 03 86 10 80       	push   $0x80108603
80100b20:	68 e0 cd 10 80       	push   $0x8010cde0
80100b25:	e8 8f 44 00 00       	call   80104fb9 <initlock>
80100b2a:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100b2d:	83 ec 08             	sub    $0x8,%esp
80100b30:	68 0b 86 10 80       	push   $0x8010860b
80100b35:	68 00 cd 10 80       	push   $0x8010cd00
80100b3a:	e8 7a 44 00 00       	call   80104fb9 <initlock>
80100b3f:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b42:	c7 05 2c ce 10 80 99 	movl   $0x80100a99,0x8010ce2c
80100b49:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b4c:	c7 05 28 ce 10 80 8a 	movl   $0x8010098a,0x8010ce28
80100b53:	09 10 80 
  cons.locking = 1;
80100b56:	c7 05 14 ce 10 80 01 	movl   $0x1,0x8010ce14
80100b5d:	00 00 00 

  picenable(IRQ_KBD);
80100b60:	83 ec 0c             	sub    $0xc,%esp
80100b63:	6a 01                	push   $0x1
80100b65:	e8 1e 30 00 00       	call   80103b88 <picenable>
80100b6a:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b6d:	83 ec 08             	sub    $0x8,%esp
80100b70:	6a 00                	push   $0x0
80100b72:	6a 01                	push   $0x1
80100b74:	e8 d5 1e 00 00       	call   80102a4e <ioapicenable>
80100b79:	83 c4 10             	add    $0x10,%esp
}
80100b7c:	90                   	nop
80100b7d:	c9                   	leave  
80100b7e:	c3                   	ret    

80100b7f <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b7f:	55                   	push   %ebp
80100b80:	89 e5                	mov    %esp,%ebp
80100b82:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100b88:	83 ec 0c             	sub    $0xc,%esp
80100b8b:	ff 75 08             	pushl  0x8(%ebp)
80100b8e:	e8 43 19 00 00       	call   801024d6 <namei>
80100b93:	83 c4 10             	add    $0x10,%esp
80100b96:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b99:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b9d:	75 0a                	jne    80100ba9 <exec+0x2a>
    return -1;
80100b9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba4:	e9 cf 03 00 00       	jmp    80100f78 <exec+0x3f9>
  ilock(ip);
80100ba9:	83 ec 0c             	sub    $0xc,%esp
80100bac:	ff 75 d8             	pushl  -0x28(%ebp)
80100baf:	e8 77 0d 00 00       	call   8010192b <ilock>
80100bb4:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bb7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100bbe:	6a 34                	push   $0x34
80100bc0:	6a 00                	push   $0x0
80100bc2:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100bc8:	50                   	push   %eax
80100bc9:	ff 75 d8             	pushl  -0x28(%ebp)
80100bcc:	e8 bd 12 00 00       	call   80101e8e <readi>
80100bd1:	83 c4 10             	add    $0x10,%esp
80100bd4:	83 f8 33             	cmp    $0x33,%eax
80100bd7:	0f 86 4f 03 00 00    	jbe    80100f2c <exec+0x3ad>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100bdd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100be3:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100be8:	0f 85 41 03 00 00    	jne    80100f2f <exec+0x3b0>
    goto bad;

  if((pgdir = setupkvm(kalloc)) == 0)
80100bee:	83 ec 0c             	sub    $0xc,%esp
80100bf1:	68 db 2b 10 80       	push   $0x80102bdb
80100bf6:	e8 ad 71 00 00       	call   80107da8 <setupkvm>
80100bfb:	83 c4 10             	add    $0x10,%esp
80100bfe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c01:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c05:	0f 84 27 03 00 00    	je     80100f32 <exec+0x3b3>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c0b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c12:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c19:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c22:	e9 ab 00 00 00       	jmp    80100cd2 <exec+0x153>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c27:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c2a:	6a 20                	push   $0x20
80100c2c:	50                   	push   %eax
80100c2d:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c33:	50                   	push   %eax
80100c34:	ff 75 d8             	pushl  -0x28(%ebp)
80100c37:	e8 52 12 00 00       	call   80101e8e <readi>
80100c3c:	83 c4 10             	add    $0x10,%esp
80100c3f:	83 f8 20             	cmp    $0x20,%eax
80100c42:	0f 85 ed 02 00 00    	jne    80100f35 <exec+0x3b6>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c48:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c4e:	83 f8 01             	cmp    $0x1,%eax
80100c51:	75 71                	jne    80100cc4 <exec+0x145>
      continue;
    if(ph.memsz < ph.filesz)
80100c53:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c59:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c5f:	39 c2                	cmp    %eax,%edx
80100c61:	0f 82 d1 02 00 00    	jb     80100f38 <exec+0x3b9>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c67:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c6d:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c73:	01 d0                	add    %edx,%eax
80100c75:	83 ec 04             	sub    $0x4,%esp
80100c78:	50                   	push   %eax
80100c79:	ff 75 e0             	pushl  -0x20(%ebp)
80100c7c:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c7f:	e8 cc 74 00 00       	call   80108150 <allocuvm>
80100c84:	83 c4 10             	add    $0x10,%esp
80100c87:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c8a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c8e:	0f 84 a7 02 00 00    	je     80100f3b <exec+0x3bc>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c94:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c9a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ca0:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100ca6:	83 ec 0c             	sub    $0xc,%esp
80100ca9:	52                   	push   %edx
80100caa:	50                   	push   %eax
80100cab:	ff 75 d8             	pushl  -0x28(%ebp)
80100cae:	51                   	push   %ecx
80100caf:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cb2:	e8 c2 73 00 00       	call   80108079 <loaduvm>
80100cb7:	83 c4 20             	add    $0x20,%esp
80100cba:	85 c0                	test   %eax,%eax
80100cbc:	0f 88 7c 02 00 00    	js     80100f3e <exec+0x3bf>
80100cc2:	eb 01                	jmp    80100cc5 <exec+0x146>
      continue;
80100cc4:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cc5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100cc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ccc:	83 c0 20             	add    $0x20,%eax
80100ccf:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cd2:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cd9:	0f b7 c0             	movzwl %ax,%eax
80100cdc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100cdf:	0f 8c 42 ff ff ff    	jl     80100c27 <exec+0xa8>
      goto bad;
  }
  iunlockput(ip);
80100ce5:	83 ec 0c             	sub    $0xc,%esp
80100ce8:	ff 75 d8             	pushl  -0x28(%ebp)
80100ceb:	e8 f5 0e 00 00       	call   80101be5 <iunlockput>
80100cf0:	83 c4 10             	add    $0x10,%esp
  ip = 0;
80100cf3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cfd:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d07:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0d:	05 00 20 00 00       	add    $0x2000,%eax
80100d12:	83 ec 04             	sub    $0x4,%esp
80100d15:	50                   	push   %eax
80100d16:	ff 75 e0             	pushl  -0x20(%ebp)
80100d19:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d1c:	e8 2f 74 00 00       	call   80108150 <allocuvm>
80100d21:	83 c4 10             	add    $0x10,%esp
80100d24:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d27:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d2b:	0f 84 10 02 00 00    	je     80100f41 <exec+0x3c2>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d31:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d34:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d39:	83 ec 08             	sub    $0x8,%esp
80100d3c:	50                   	push   %eax
80100d3d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d40:	e8 2f 76 00 00       	call   80108374 <clearpteu>
80100d45:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d4b:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d4e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d55:	e9 96 00 00 00       	jmp    80100df0 <exec+0x271>
    if(argc >= MAXARG)
80100d5a:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d5e:	0f 87 e0 01 00 00    	ja     80100f44 <exec+0x3c5>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d71:	01 d0                	add    %edx,%eax
80100d73:	8b 00                	mov    (%eax),%eax
80100d75:	83 ec 0c             	sub    $0xc,%esp
80100d78:	50                   	push   %eax
80100d79:	e8 0d 47 00 00       	call   8010548b <strlen>
80100d7e:	83 c4 10             	add    $0x10,%esp
80100d81:	89 c2                	mov    %eax,%edx
80100d83:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d86:	29 d0                	sub    %edx,%eax
80100d88:	83 e8 01             	sub    $0x1,%eax
80100d8b:	83 e0 fc             	and    $0xfffffffc,%eax
80100d8e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d9e:	01 d0                	add    %edx,%eax
80100da0:	8b 00                	mov    (%eax),%eax
80100da2:	83 ec 0c             	sub    $0xc,%esp
80100da5:	50                   	push   %eax
80100da6:	e8 e0 46 00 00       	call   8010548b <strlen>
80100dab:	83 c4 10             	add    $0x10,%esp
80100dae:	83 c0 01             	add    $0x1,%eax
80100db1:	89 c2                	mov    %eax,%edx
80100db3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dc0:	01 c8                	add    %ecx,%eax
80100dc2:	8b 00                	mov    (%eax),%eax
80100dc4:	52                   	push   %edx
80100dc5:	50                   	push   %eax
80100dc6:	ff 75 dc             	pushl  -0x24(%ebp)
80100dc9:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dcc:	e8 46 77 00 00       	call   80108517 <copyout>
80100dd1:	83 c4 10             	add    $0x10,%esp
80100dd4:	85 c0                	test   %eax,%eax
80100dd6:	0f 88 6b 01 00 00    	js     80100f47 <exec+0x3c8>
      goto bad;
    ustack[3+argc] = sp;
80100ddc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ddf:	8d 50 03             	lea    0x3(%eax),%edx
80100de2:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de5:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100dec:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100df0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dfd:	01 d0                	add    %edx,%eax
80100dff:	8b 00                	mov    (%eax),%eax
80100e01:	85 c0                	test   %eax,%eax
80100e03:	0f 85 51 ff ff ff    	jne    80100d5a <exec+0x1db>
  }
  ustack[3+argc] = 0;
80100e09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0c:	83 c0 03             	add    $0x3,%eax
80100e0f:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e16:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e1a:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e21:	ff ff ff 
  ustack[1] = argc;
80100e24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e27:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e30:	83 c0 01             	add    $0x1,%eax
80100e33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e3d:	29 d0                	sub    %edx,%eax
80100e3f:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e48:	83 c0 04             	add    $0x4,%eax
80100e4b:	c1 e0 02             	shl    $0x2,%eax
80100e4e:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e54:	83 c0 04             	add    $0x4,%eax
80100e57:	c1 e0 02             	shl    $0x2,%eax
80100e5a:	50                   	push   %eax
80100e5b:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e61:	50                   	push   %eax
80100e62:	ff 75 dc             	pushl  -0x24(%ebp)
80100e65:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e68:	e8 aa 76 00 00       	call   80108517 <copyout>
80100e6d:	83 c4 10             	add    $0x10,%esp
80100e70:	85 c0                	test   %eax,%eax
80100e72:	0f 88 d2 00 00 00    	js     80100f4a <exec+0x3cb>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e78:	8b 45 08             	mov    0x8(%ebp),%eax
80100e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e81:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e84:	eb 17                	jmp    80100e9d <exec+0x31e>
    if(*s == '/')
80100e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e89:	0f b6 00             	movzbl (%eax),%eax
80100e8c:	3c 2f                	cmp    $0x2f,%al
80100e8e:	75 09                	jne    80100e99 <exec+0x31a>
      last = s+1;
80100e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e93:	83 c0 01             	add    $0x1,%eax
80100e96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100e99:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ea0:	0f b6 00             	movzbl (%eax),%eax
80100ea3:	84 c0                	test   %al,%al
80100ea5:	75 df                	jne    80100e86 <exec+0x307>
  safestrcpy(proc->name, last, sizeof(proc->name));
80100ea7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ead:	83 c0 6c             	add    $0x6c,%eax
80100eb0:	83 ec 04             	sub    $0x4,%esp
80100eb3:	6a 10                	push   $0x10
80100eb5:	ff 75 f0             	pushl  -0x10(%ebp)
80100eb8:	50                   	push   %eax
80100eb9:	e8 83 45 00 00       	call   80105441 <safestrcpy>
80100ebe:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ec1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec7:	8b 40 04             	mov    0x4(%eax),%eax
80100eca:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ecd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ed6:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ed9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100edf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ee2:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ee4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eea:	8b 40 18             	mov    0x18(%eax),%eax
80100eed:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ef3:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ef6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100efc:	8b 40 18             	mov    0x18(%eax),%eax
80100eff:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f02:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f0b:	83 ec 0c             	sub    $0xc,%esp
80100f0e:	50                   	push   %eax
80100f0f:	e8 7b 6f 00 00       	call   80107e8f <switchuvm>
80100f14:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f17:	83 ec 0c             	sub    $0xc,%esp
80100f1a:	ff 75 d0             	pushl  -0x30(%ebp)
80100f1d:	e8 b2 73 00 00       	call   801082d4 <freevm>
80100f22:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f25:	b8 00 00 00 00       	mov    $0x0,%eax
80100f2a:	eb 4c                	jmp    80100f78 <exec+0x3f9>
    goto bad;
80100f2c:	90                   	nop
80100f2d:	eb 1c                	jmp    80100f4b <exec+0x3cc>
    goto bad;
80100f2f:	90                   	nop
80100f30:	eb 19                	jmp    80100f4b <exec+0x3cc>
    goto bad;
80100f32:	90                   	nop
80100f33:	eb 16                	jmp    80100f4b <exec+0x3cc>
      goto bad;
80100f35:	90                   	nop
80100f36:	eb 13                	jmp    80100f4b <exec+0x3cc>
      goto bad;
80100f38:	90                   	nop
80100f39:	eb 10                	jmp    80100f4b <exec+0x3cc>
      goto bad;
80100f3b:	90                   	nop
80100f3c:	eb 0d                	jmp    80100f4b <exec+0x3cc>
      goto bad;
80100f3e:	90                   	nop
80100f3f:	eb 0a                	jmp    80100f4b <exec+0x3cc>
    goto bad;
80100f41:	90                   	nop
80100f42:	eb 07                	jmp    80100f4b <exec+0x3cc>
      goto bad;
80100f44:	90                   	nop
80100f45:	eb 04                	jmp    80100f4b <exec+0x3cc>
      goto bad;
80100f47:	90                   	nop
80100f48:	eb 01                	jmp    80100f4b <exec+0x3cc>
    goto bad;
80100f4a:	90                   	nop

 bad:
  if(pgdir)
80100f4b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f4f:	74 0e                	je     80100f5f <exec+0x3e0>
    freevm(pgdir);
80100f51:	83 ec 0c             	sub    $0xc,%esp
80100f54:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f57:	e8 78 73 00 00       	call   801082d4 <freevm>
80100f5c:	83 c4 10             	add    $0x10,%esp
  if(ip)
80100f5f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f63:	74 0e                	je     80100f73 <exec+0x3f4>
    iunlockput(ip);
80100f65:	83 ec 0c             	sub    $0xc,%esp
80100f68:	ff 75 d8             	pushl  -0x28(%ebp)
80100f6b:	e8 75 0c 00 00       	call   80101be5 <iunlockput>
80100f70:	83 c4 10             	add    $0x10,%esp
  return -1;
80100f73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f78:	c9                   	leave  
80100f79:	c3                   	ret    

80100f7a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f7a:	55                   	push   %ebp
80100f7b:	89 e5                	mov    %esp,%ebp
80100f7d:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f80:	83 ec 08             	sub    $0x8,%esp
80100f83:	68 11 86 10 80       	push   $0x80108611
80100f88:	68 80 ce 10 80       	push   $0x8010ce80
80100f8d:	e8 27 40 00 00       	call   80104fb9 <initlock>
80100f92:	83 c4 10             	add    $0x10,%esp
}
80100f95:	90                   	nop
80100f96:	c9                   	leave  
80100f97:	c3                   	ret    

80100f98 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f98:	55                   	push   %ebp
80100f99:	89 e5                	mov    %esp,%ebp
80100f9b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f9e:	83 ec 0c             	sub    $0xc,%esp
80100fa1:	68 80 ce 10 80       	push   $0x8010ce80
80100fa6:	e8 30 40 00 00       	call   80104fdb <acquire>
80100fab:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fae:	c7 45 f4 b4 ce 10 80 	movl   $0x8010ceb4,-0xc(%ebp)
80100fb5:	eb 2d                	jmp    80100fe4 <filealloc+0x4c>
    if(f->ref == 0){
80100fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fba:	8b 40 04             	mov    0x4(%eax),%eax
80100fbd:	85 c0                	test   %eax,%eax
80100fbf:	75 1f                	jne    80100fe0 <filealloc+0x48>
      f->ref = 1;
80100fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fc4:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fcb:	83 ec 0c             	sub    $0xc,%esp
80100fce:	68 80 ce 10 80       	push   $0x8010ce80
80100fd3:	e8 6a 40 00 00       	call   80105042 <release>
80100fd8:	83 c4 10             	add    $0x10,%esp
      return f;
80100fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fde:	eb 23                	jmp    80101003 <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fe0:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fe4:	b8 14 d8 10 80       	mov    $0x8010d814,%eax
80100fe9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100fec:	72 c9                	jb     80100fb7 <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
80100fee:	83 ec 0c             	sub    $0xc,%esp
80100ff1:	68 80 ce 10 80       	push   $0x8010ce80
80100ff6:	e8 47 40 00 00       	call   80105042 <release>
80100ffb:	83 c4 10             	add    $0x10,%esp
  return 0;
80100ffe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101003:	c9                   	leave  
80101004:	c3                   	ret    

80101005 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101005:	55                   	push   %ebp
80101006:	89 e5                	mov    %esp,%ebp
80101008:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
8010100b:	83 ec 0c             	sub    $0xc,%esp
8010100e:	68 80 ce 10 80       	push   $0x8010ce80
80101013:	e8 c3 3f 00 00       	call   80104fdb <acquire>
80101018:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010101b:	8b 45 08             	mov    0x8(%ebp),%eax
8010101e:	8b 40 04             	mov    0x4(%eax),%eax
80101021:	85 c0                	test   %eax,%eax
80101023:	7f 0d                	jg     80101032 <filedup+0x2d>
    panic("filedup");
80101025:	83 ec 0c             	sub    $0xc,%esp
80101028:	68 18 86 10 80       	push   $0x80108618
8010102d:	e8 49 f5 ff ff       	call   8010057b <panic>
  f->ref++;
80101032:	8b 45 08             	mov    0x8(%ebp),%eax
80101035:	8b 40 04             	mov    0x4(%eax),%eax
80101038:	8d 50 01             	lea    0x1(%eax),%edx
8010103b:	8b 45 08             	mov    0x8(%ebp),%eax
8010103e:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101041:	83 ec 0c             	sub    $0xc,%esp
80101044:	68 80 ce 10 80       	push   $0x8010ce80
80101049:	e8 f4 3f 00 00       	call   80105042 <release>
8010104e:	83 c4 10             	add    $0x10,%esp
  return f;
80101051:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101054:	c9                   	leave  
80101055:	c3                   	ret    

80101056 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101056:	55                   	push   %ebp
80101057:	89 e5                	mov    %esp,%ebp
80101059:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
8010105c:	83 ec 0c             	sub    $0xc,%esp
8010105f:	68 80 ce 10 80       	push   $0x8010ce80
80101064:	e8 72 3f 00 00       	call   80104fdb <acquire>
80101069:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010106c:	8b 45 08             	mov    0x8(%ebp),%eax
8010106f:	8b 40 04             	mov    0x4(%eax),%eax
80101072:	85 c0                	test   %eax,%eax
80101074:	7f 0d                	jg     80101083 <fileclose+0x2d>
    panic("fileclose");
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	68 20 86 10 80       	push   $0x80108620
8010107e:	e8 f8 f4 ff ff       	call   8010057b <panic>
  if(--f->ref > 0){
80101083:	8b 45 08             	mov    0x8(%ebp),%eax
80101086:	8b 40 04             	mov    0x4(%eax),%eax
80101089:	8d 50 ff             	lea    -0x1(%eax),%edx
8010108c:	8b 45 08             	mov    0x8(%ebp),%eax
8010108f:	89 50 04             	mov    %edx,0x4(%eax)
80101092:	8b 45 08             	mov    0x8(%ebp),%eax
80101095:	8b 40 04             	mov    0x4(%eax),%eax
80101098:	85 c0                	test   %eax,%eax
8010109a:	7e 15                	jle    801010b1 <fileclose+0x5b>
    release(&ftable.lock);
8010109c:	83 ec 0c             	sub    $0xc,%esp
8010109f:	68 80 ce 10 80       	push   $0x8010ce80
801010a4:	e8 99 3f 00 00       	call   80105042 <release>
801010a9:	83 c4 10             	add    $0x10,%esp
801010ac:	e9 8b 00 00 00       	jmp    8010113c <fileclose+0xe6>
    return;
  }
  ff = *f;
801010b1:	8b 45 08             	mov    0x8(%ebp),%eax
801010b4:	8b 10                	mov    (%eax),%edx
801010b6:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010b9:	8b 50 04             	mov    0x4(%eax),%edx
801010bc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010bf:	8b 50 08             	mov    0x8(%eax),%edx
801010c2:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010c5:	8b 50 0c             	mov    0xc(%eax),%edx
801010c8:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010cb:	8b 50 10             	mov    0x10(%eax),%edx
801010ce:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010d1:	8b 40 14             	mov    0x14(%eax),%eax
801010d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010d7:	8b 45 08             	mov    0x8(%ebp),%eax
801010da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010e1:	8b 45 08             	mov    0x8(%ebp),%eax
801010e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010ea:	83 ec 0c             	sub    $0xc,%esp
801010ed:	68 80 ce 10 80       	push   $0x8010ce80
801010f2:	e8 4b 3f 00 00       	call   80105042 <release>
801010f7:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010fd:	83 f8 01             	cmp    $0x1,%eax
80101100:	75 19                	jne    8010111b <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101102:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101106:	0f be d0             	movsbl %al,%edx
80101109:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010110c:	83 ec 08             	sub    $0x8,%esp
8010110f:	52                   	push   %edx
80101110:	50                   	push   %eax
80101111:	e8 da 2c 00 00       	call   80103df0 <pipeclose>
80101116:	83 c4 10             	add    $0x10,%esp
80101119:	eb 21                	jmp    8010113c <fileclose+0xe6>
  else if(ff.type == FD_INODE){
8010111b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010111e:	83 f8 02             	cmp    $0x2,%eax
80101121:	75 19                	jne    8010113c <fileclose+0xe6>
    begin_trans();
80101123:	e8 83 21 00 00       	call   801032ab <begin_trans>
    iput(ff.ip);
80101128:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010112b:	83 ec 0c             	sub    $0xc,%esp
8010112e:	50                   	push   %eax
8010112f:	e8 c1 09 00 00       	call   80101af5 <iput>
80101134:	83 c4 10             	add    $0x10,%esp
    commit_trans();
80101137:	e8 c2 21 00 00       	call   801032fe <commit_trans>
  }
}
8010113c:	c9                   	leave  
8010113d:	c3                   	ret    

8010113e <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010113e:	55                   	push   %ebp
8010113f:	89 e5                	mov    %esp,%ebp
80101141:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101144:	8b 45 08             	mov    0x8(%ebp),%eax
80101147:	8b 00                	mov    (%eax),%eax
80101149:	83 f8 02             	cmp    $0x2,%eax
8010114c:	75 40                	jne    8010118e <filestat+0x50>
    ilock(f->ip);
8010114e:	8b 45 08             	mov    0x8(%ebp),%eax
80101151:	8b 40 10             	mov    0x10(%eax),%eax
80101154:	83 ec 0c             	sub    $0xc,%esp
80101157:	50                   	push   %eax
80101158:	e8 ce 07 00 00       	call   8010192b <ilock>
8010115d:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101160:	8b 45 08             	mov    0x8(%ebp),%eax
80101163:	8b 40 10             	mov    0x10(%eax),%eax
80101166:	83 ec 08             	sub    $0x8,%esp
80101169:	ff 75 0c             	pushl  0xc(%ebp)
8010116c:	50                   	push   %eax
8010116d:	e8 d6 0c 00 00       	call   80101e48 <stati>
80101172:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101175:	8b 45 08             	mov    0x8(%ebp),%eax
80101178:	8b 40 10             	mov    0x10(%eax),%eax
8010117b:	83 ec 0c             	sub    $0xc,%esp
8010117e:	50                   	push   %eax
8010117f:	e8 ff 08 00 00       	call   80101a83 <iunlock>
80101184:	83 c4 10             	add    $0x10,%esp
    return 0;
80101187:	b8 00 00 00 00       	mov    $0x0,%eax
8010118c:	eb 05                	jmp    80101193 <filestat+0x55>
  }
  return -1;
8010118e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101193:	c9                   	leave  
80101194:	c3                   	ret    

80101195 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101195:	55                   	push   %ebp
80101196:	89 e5                	mov    %esp,%ebp
80101198:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010119b:	8b 45 08             	mov    0x8(%ebp),%eax
8010119e:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011a2:	84 c0                	test   %al,%al
801011a4:	75 0a                	jne    801011b0 <fileread+0x1b>
    return -1;
801011a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011ab:	e9 9b 00 00 00       	jmp    8010124b <fileread+0xb6>
  if(f->type == FD_PIPE)
801011b0:	8b 45 08             	mov    0x8(%ebp),%eax
801011b3:	8b 00                	mov    (%eax),%eax
801011b5:	83 f8 01             	cmp    $0x1,%eax
801011b8:	75 1a                	jne    801011d4 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801011ba:	8b 45 08             	mov    0x8(%ebp),%eax
801011bd:	8b 40 0c             	mov    0xc(%eax),%eax
801011c0:	83 ec 04             	sub    $0x4,%esp
801011c3:	ff 75 10             	pushl  0x10(%ebp)
801011c6:	ff 75 0c             	pushl  0xc(%ebp)
801011c9:	50                   	push   %eax
801011ca:	e8 cf 2d 00 00       	call   80103f9e <piperead>
801011cf:	83 c4 10             	add    $0x10,%esp
801011d2:	eb 77                	jmp    8010124b <fileread+0xb6>
  if(f->type == FD_INODE){
801011d4:	8b 45 08             	mov    0x8(%ebp),%eax
801011d7:	8b 00                	mov    (%eax),%eax
801011d9:	83 f8 02             	cmp    $0x2,%eax
801011dc:	75 60                	jne    8010123e <fileread+0xa9>
    ilock(f->ip);
801011de:	8b 45 08             	mov    0x8(%ebp),%eax
801011e1:	8b 40 10             	mov    0x10(%eax),%eax
801011e4:	83 ec 0c             	sub    $0xc,%esp
801011e7:	50                   	push   %eax
801011e8:	e8 3e 07 00 00       	call   8010192b <ilock>
801011ed:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011f3:	8b 45 08             	mov    0x8(%ebp),%eax
801011f6:	8b 50 14             	mov    0x14(%eax),%edx
801011f9:	8b 45 08             	mov    0x8(%ebp),%eax
801011fc:	8b 40 10             	mov    0x10(%eax),%eax
801011ff:	51                   	push   %ecx
80101200:	52                   	push   %edx
80101201:	ff 75 0c             	pushl  0xc(%ebp)
80101204:	50                   	push   %eax
80101205:	e8 84 0c 00 00       	call   80101e8e <readi>
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101214:	7e 11                	jle    80101227 <fileread+0x92>
      f->off += r;
80101216:	8b 45 08             	mov    0x8(%ebp),%eax
80101219:	8b 50 14             	mov    0x14(%eax),%edx
8010121c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010121f:	01 c2                	add    %eax,%edx
80101221:	8b 45 08             	mov    0x8(%ebp),%eax
80101224:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101227:	8b 45 08             	mov    0x8(%ebp),%eax
8010122a:	8b 40 10             	mov    0x10(%eax),%eax
8010122d:	83 ec 0c             	sub    $0xc,%esp
80101230:	50                   	push   %eax
80101231:	e8 4d 08 00 00       	call   80101a83 <iunlock>
80101236:	83 c4 10             	add    $0x10,%esp
    return r;
80101239:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010123c:	eb 0d                	jmp    8010124b <fileread+0xb6>
  }
  panic("fileread");
8010123e:	83 ec 0c             	sub    $0xc,%esp
80101241:	68 2a 86 10 80       	push   $0x8010862a
80101246:	e8 30 f3 ff ff       	call   8010057b <panic>
}
8010124b:	c9                   	leave  
8010124c:	c3                   	ret    

8010124d <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010124d:	55                   	push   %ebp
8010124e:	89 e5                	mov    %esp,%ebp
80101250:	53                   	push   %ebx
80101251:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101254:	8b 45 08             	mov    0x8(%ebp),%eax
80101257:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010125b:	84 c0                	test   %al,%al
8010125d:	75 0a                	jne    80101269 <filewrite+0x1c>
    return -1;
8010125f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101264:	e9 1b 01 00 00       	jmp    80101384 <filewrite+0x137>
  if(f->type == FD_PIPE)
80101269:	8b 45 08             	mov    0x8(%ebp),%eax
8010126c:	8b 00                	mov    (%eax),%eax
8010126e:	83 f8 01             	cmp    $0x1,%eax
80101271:	75 1d                	jne    80101290 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101273:	8b 45 08             	mov    0x8(%ebp),%eax
80101276:	8b 40 0c             	mov    0xc(%eax),%eax
80101279:	83 ec 04             	sub    $0x4,%esp
8010127c:	ff 75 10             	pushl  0x10(%ebp)
8010127f:	ff 75 0c             	pushl  0xc(%ebp)
80101282:	50                   	push   %eax
80101283:	e8 13 2c 00 00       	call   80103e9b <pipewrite>
80101288:	83 c4 10             	add    $0x10,%esp
8010128b:	e9 f4 00 00 00       	jmp    80101384 <filewrite+0x137>
  if(f->type == FD_INODE){
80101290:	8b 45 08             	mov    0x8(%ebp),%eax
80101293:	8b 00                	mov    (%eax),%eax
80101295:	83 f8 02             	cmp    $0x2,%eax
80101298:	0f 85 d9 00 00 00    	jne    80101377 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010129e:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801012a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012ac:	e9 a3 00 00 00       	jmp    80101354 <filewrite+0x107>
      int n1 = n - i;
801012b1:	8b 45 10             	mov    0x10(%ebp),%eax
801012b4:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012bd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012c0:	7e 06                	jle    801012c8 <filewrite+0x7b>
        n1 = max;
801012c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012c5:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
801012c8:	e8 de 1f 00 00       	call   801032ab <begin_trans>
      ilock(f->ip);
801012cd:	8b 45 08             	mov    0x8(%ebp),%eax
801012d0:	8b 40 10             	mov    0x10(%eax),%eax
801012d3:	83 ec 0c             	sub    $0xc,%esp
801012d6:	50                   	push   %eax
801012d7:	e8 4f 06 00 00       	call   8010192b <ilock>
801012dc:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012df:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012e2:	8b 45 08             	mov    0x8(%ebp),%eax
801012e5:	8b 50 14             	mov    0x14(%eax),%edx
801012e8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801012ee:	01 c3                	add    %eax,%ebx
801012f0:	8b 45 08             	mov    0x8(%ebp),%eax
801012f3:	8b 40 10             	mov    0x10(%eax),%eax
801012f6:	51                   	push   %ecx
801012f7:	52                   	push   %edx
801012f8:	53                   	push   %ebx
801012f9:	50                   	push   %eax
801012fa:	e8 e4 0c 00 00       	call   80101fe3 <writei>
801012ff:	83 c4 10             	add    $0x10,%esp
80101302:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101305:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101309:	7e 11                	jle    8010131c <filewrite+0xcf>
        f->off += r;
8010130b:	8b 45 08             	mov    0x8(%ebp),%eax
8010130e:	8b 50 14             	mov    0x14(%eax),%edx
80101311:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101314:	01 c2                	add    %eax,%edx
80101316:	8b 45 08             	mov    0x8(%ebp),%eax
80101319:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010131c:	8b 45 08             	mov    0x8(%ebp),%eax
8010131f:	8b 40 10             	mov    0x10(%eax),%eax
80101322:	83 ec 0c             	sub    $0xc,%esp
80101325:	50                   	push   %eax
80101326:	e8 58 07 00 00       	call   80101a83 <iunlock>
8010132b:	83 c4 10             	add    $0x10,%esp
      commit_trans();
8010132e:	e8 cb 1f 00 00       	call   801032fe <commit_trans>

      if(r < 0)
80101333:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101337:	78 29                	js     80101362 <filewrite+0x115>
        break;
      if(r != n1)
80101339:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010133c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010133f:	74 0d                	je     8010134e <filewrite+0x101>
        panic("short filewrite");
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	68 33 86 10 80       	push   $0x80108633
80101349:	e8 2d f2 ff ff       	call   8010057b <panic>
      i += r;
8010134e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101351:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
80101354:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101357:	3b 45 10             	cmp    0x10(%ebp),%eax
8010135a:	0f 8c 51 ff ff ff    	jl     801012b1 <filewrite+0x64>
80101360:	eb 01                	jmp    80101363 <filewrite+0x116>
        break;
80101362:	90                   	nop
    }
    return i == n ? n : -1;
80101363:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101366:	3b 45 10             	cmp    0x10(%ebp),%eax
80101369:	75 05                	jne    80101370 <filewrite+0x123>
8010136b:	8b 45 10             	mov    0x10(%ebp),%eax
8010136e:	eb 14                	jmp    80101384 <filewrite+0x137>
80101370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101375:	eb 0d                	jmp    80101384 <filewrite+0x137>
  }
  panic("filewrite");
80101377:	83 ec 0c             	sub    $0xc,%esp
8010137a:	68 43 86 10 80       	push   $0x80108643
8010137f:	e8 f7 f1 ff ff       	call   8010057b <panic>
}
80101384:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101387:	c9                   	leave  
80101388:	c3                   	ret    

80101389 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101389:	55                   	push   %ebp
8010138a:	89 e5                	mov    %esp,%ebp
8010138c:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010138f:	8b 45 08             	mov    0x8(%ebp),%eax
80101392:	83 ec 08             	sub    $0x8,%esp
80101395:	6a 01                	push   $0x1
80101397:	50                   	push   %eax
80101398:	e8 1a ee ff ff       	call   801001b7 <bread>
8010139d:	83 c4 10             	add    $0x10,%esp
801013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a6:	83 c0 18             	add    $0x18,%eax
801013a9:	83 ec 04             	sub    $0x4,%esp
801013ac:	6a 10                	push   $0x10
801013ae:	50                   	push   %eax
801013af:	ff 75 0c             	pushl  0xc(%ebp)
801013b2:	e8 46 3f 00 00       	call   801052fd <memmove>
801013b7:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013ba:	83 ec 0c             	sub    $0xc,%esp
801013bd:	ff 75 f4             	pushl  -0xc(%ebp)
801013c0:	e8 6a ee ff ff       	call   8010022f <brelse>
801013c5:	83 c4 10             	add    $0x10,%esp
}
801013c8:	90                   	nop
801013c9:	c9                   	leave  
801013ca:	c3                   	ret    

801013cb <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013cb:	55                   	push   %ebp
801013cc:	89 e5                	mov    %esp,%ebp
801013ce:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013d1:	8b 55 0c             	mov    0xc(%ebp),%edx
801013d4:	8b 45 08             	mov    0x8(%ebp),%eax
801013d7:	83 ec 08             	sub    $0x8,%esp
801013da:	52                   	push   %edx
801013db:	50                   	push   %eax
801013dc:	e8 d6 ed ff ff       	call   801001b7 <bread>
801013e1:	83 c4 10             	add    $0x10,%esp
801013e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ea:	83 c0 18             	add    $0x18,%eax
801013ed:	83 ec 04             	sub    $0x4,%esp
801013f0:	68 00 02 00 00       	push   $0x200
801013f5:	6a 00                	push   $0x0
801013f7:	50                   	push   %eax
801013f8:	e8 41 3e 00 00       	call   8010523e <memset>
801013fd:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101400:	83 ec 0c             	sub    $0xc,%esp
80101403:	ff 75 f4             	pushl  -0xc(%ebp)
80101406:	e8 58 1f 00 00       	call   80103363 <log_write>
8010140b:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010140e:	83 ec 0c             	sub    $0xc,%esp
80101411:	ff 75 f4             	pushl  -0xc(%ebp)
80101414:	e8 16 ee ff ff       	call   8010022f <brelse>
80101419:	83 c4 10             	add    $0x10,%esp
}
8010141c:	90                   	nop
8010141d:	c9                   	leave  
8010141e:	c3                   	ret    

8010141f <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010141f:	55                   	push   %ebp
80101420:	89 e5                	mov    %esp,%ebp
80101422:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
80101425:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
8010142c:	8b 45 08             	mov    0x8(%ebp),%eax
8010142f:	83 ec 08             	sub    $0x8,%esp
80101432:	8d 55 d8             	lea    -0x28(%ebp),%edx
80101435:	52                   	push   %edx
80101436:	50                   	push   %eax
80101437:	e8 4d ff ff ff       	call   80101389 <readsb>
8010143c:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
8010143f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101446:	e9 15 01 00 00       	jmp    80101560 <balloc+0x141>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
8010144b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010144e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101454:	85 c0                	test   %eax,%eax
80101456:	0f 48 c2             	cmovs  %edx,%eax
80101459:	c1 f8 0c             	sar    $0xc,%eax
8010145c:	89 c2                	mov    %eax,%edx
8010145e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101461:	c1 e8 03             	shr    $0x3,%eax
80101464:	01 d0                	add    %edx,%eax
80101466:	83 c0 03             	add    $0x3,%eax
80101469:	83 ec 08             	sub    $0x8,%esp
8010146c:	50                   	push   %eax
8010146d:	ff 75 08             	pushl  0x8(%ebp)
80101470:	e8 42 ed ff ff       	call   801001b7 <bread>
80101475:	83 c4 10             	add    $0x10,%esp
80101478:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010147b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101482:	e9 a6 00 00 00       	jmp    8010152d <balloc+0x10e>
      m = 1 << (bi % 8);
80101487:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148a:	99                   	cltd   
8010148b:	c1 ea 1d             	shr    $0x1d,%edx
8010148e:	01 d0                	add    %edx,%eax
80101490:	83 e0 07             	and    $0x7,%eax
80101493:	29 d0                	sub    %edx,%eax
80101495:	ba 01 00 00 00       	mov    $0x1,%edx
8010149a:	89 c1                	mov    %eax,%ecx
8010149c:	d3 e2                	shl    %cl,%edx
8010149e:	89 d0                	mov    %edx,%eax
801014a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a6:	8d 50 07             	lea    0x7(%eax),%edx
801014a9:	85 c0                	test   %eax,%eax
801014ab:	0f 48 c2             	cmovs  %edx,%eax
801014ae:	c1 f8 03             	sar    $0x3,%eax
801014b1:	89 c2                	mov    %eax,%edx
801014b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014b6:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801014bb:	0f b6 c0             	movzbl %al,%eax
801014be:	23 45 e8             	and    -0x18(%ebp),%eax
801014c1:	85 c0                	test   %eax,%eax
801014c3:	75 64                	jne    80101529 <balloc+0x10a>
        bp->data[bi/8] |= m;  // Mark block in use.
801014c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c8:	8d 50 07             	lea    0x7(%eax),%edx
801014cb:	85 c0                	test   %eax,%eax
801014cd:	0f 48 c2             	cmovs  %edx,%eax
801014d0:	c1 f8 03             	sar    $0x3,%eax
801014d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014d6:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801014db:	89 d1                	mov    %edx,%ecx
801014dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014e0:	09 ca                	or     %ecx,%edx
801014e2:	89 d1                	mov    %edx,%ecx
801014e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014e7:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014eb:	83 ec 0c             	sub    $0xc,%esp
801014ee:	ff 75 ec             	pushl  -0x14(%ebp)
801014f1:	e8 6d 1e 00 00       	call   80103363 <log_write>
801014f6:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014f9:	83 ec 0c             	sub    $0xc,%esp
801014fc:	ff 75 ec             	pushl  -0x14(%ebp)
801014ff:	e8 2b ed ff ff       	call   8010022f <brelse>
80101504:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101507:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010150a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010150d:	01 c2                	add    %eax,%edx
8010150f:	8b 45 08             	mov    0x8(%ebp),%eax
80101512:	83 ec 08             	sub    $0x8,%esp
80101515:	52                   	push   %edx
80101516:	50                   	push   %eax
80101517:	e8 af fe ff ff       	call   801013cb <bzero>
8010151c:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010151f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101522:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101525:	01 d0                	add    %edx,%eax
80101527:	eb 52                	jmp    8010157b <balloc+0x15c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101529:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010152d:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101534:	7f 15                	jg     8010154b <balloc+0x12c>
80101536:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101539:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010153c:	01 d0                	add    %edx,%eax
8010153e:	89 c2                	mov    %eax,%edx
80101540:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101543:	39 c2                	cmp    %eax,%edx
80101545:	0f 82 3c ff ff ff    	jb     80101487 <balloc+0x68>
      }
    }
    brelse(bp);
8010154b:	83 ec 0c             	sub    $0xc,%esp
8010154e:	ff 75 ec             	pushl  -0x14(%ebp)
80101551:	e8 d9 ec ff ff       	call   8010022f <brelse>
80101556:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
80101559:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101560:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101566:	39 c2                	cmp    %eax,%edx
80101568:	0f 87 dd fe ff ff    	ja     8010144b <balloc+0x2c>
  }
  panic("balloc: out of blocks");
8010156e:	83 ec 0c             	sub    $0xc,%esp
80101571:	68 4d 86 10 80       	push   $0x8010864d
80101576:	e8 00 f0 ff ff       	call   8010057b <panic>
}
8010157b:	c9                   	leave  
8010157c:	c3                   	ret    

8010157d <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010157d:	55                   	push   %ebp
8010157e:	89 e5                	mov    %esp,%ebp
80101580:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101583:	83 ec 08             	sub    $0x8,%esp
80101586:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101589:	50                   	push   %eax
8010158a:	ff 75 08             	pushl  0x8(%ebp)
8010158d:	e8 f7 fd ff ff       	call   80101389 <readsb>
80101592:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101595:	8b 45 0c             	mov    0xc(%ebp),%eax
80101598:	c1 e8 0c             	shr    $0xc,%eax
8010159b:	89 c2                	mov    %eax,%edx
8010159d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801015a0:	c1 e8 03             	shr    $0x3,%eax
801015a3:	01 d0                	add    %edx,%eax
801015a5:	8d 50 03             	lea    0x3(%eax),%edx
801015a8:	8b 45 08             	mov    0x8(%ebp),%eax
801015ab:	83 ec 08             	sub    $0x8,%esp
801015ae:	52                   	push   %edx
801015af:	50                   	push   %eax
801015b0:	e8 02 ec ff ff       	call   801001b7 <bread>
801015b5:	83 c4 10             	add    $0x10,%esp
801015b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801015be:	25 ff 0f 00 00       	and    $0xfff,%eax
801015c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c9:	99                   	cltd   
801015ca:	c1 ea 1d             	shr    $0x1d,%edx
801015cd:	01 d0                	add    %edx,%eax
801015cf:	83 e0 07             	and    $0x7,%eax
801015d2:	29 d0                	sub    %edx,%eax
801015d4:	ba 01 00 00 00       	mov    $0x1,%edx
801015d9:	89 c1                	mov    %eax,%ecx
801015db:	d3 e2                	shl    %cl,%edx
801015dd:	89 d0                	mov    %edx,%eax
801015df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015e5:	8d 50 07             	lea    0x7(%eax),%edx
801015e8:	85 c0                	test   %eax,%eax
801015ea:	0f 48 c2             	cmovs  %edx,%eax
801015ed:	c1 f8 03             	sar    $0x3,%eax
801015f0:	89 c2                	mov    %eax,%edx
801015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015f5:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015fa:	0f b6 c0             	movzbl %al,%eax
801015fd:	23 45 ec             	and    -0x14(%ebp),%eax
80101600:	85 c0                	test   %eax,%eax
80101602:	75 0d                	jne    80101611 <bfree+0x94>
    panic("freeing free block");
80101604:	83 ec 0c             	sub    $0xc,%esp
80101607:	68 63 86 10 80       	push   $0x80108663
8010160c:	e8 6a ef ff ff       	call   8010057b <panic>
  bp->data[bi/8] &= ~m;
80101611:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101614:	8d 50 07             	lea    0x7(%eax),%edx
80101617:	85 c0                	test   %eax,%eax
80101619:	0f 48 c2             	cmovs  %edx,%eax
8010161c:	c1 f8 03             	sar    $0x3,%eax
8010161f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101622:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101627:	89 d1                	mov    %edx,%ecx
80101629:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010162c:	f7 d2                	not    %edx
8010162e:	21 ca                	and    %ecx,%edx
80101630:	89 d1                	mov    %edx,%ecx
80101632:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101635:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101639:	83 ec 0c             	sub    $0xc,%esp
8010163c:	ff 75 f4             	pushl  -0xc(%ebp)
8010163f:	e8 1f 1d 00 00       	call   80103363 <log_write>
80101644:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101647:	83 ec 0c             	sub    $0xc,%esp
8010164a:	ff 75 f4             	pushl  -0xc(%ebp)
8010164d:	e8 dd eb ff ff       	call   8010022f <brelse>
80101652:	83 c4 10             	add    $0x10,%esp
}
80101655:	90                   	nop
80101656:	c9                   	leave  
80101657:	c3                   	ret    

80101658 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101658:	55                   	push   %ebp
80101659:	89 e5                	mov    %esp,%ebp
8010165b:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
8010165e:	83 ec 08             	sub    $0x8,%esp
80101661:	68 76 86 10 80       	push   $0x80108676
80101666:	68 20 d8 10 80       	push   $0x8010d820
8010166b:	e8 49 39 00 00       	call   80104fb9 <initlock>
80101670:	83 c4 10             	add    $0x10,%esp
}
80101673:	90                   	nop
80101674:	c9                   	leave  
80101675:	c3                   	ret    

80101676 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101676:	55                   	push   %ebp
80101677:	89 e5                	mov    %esp,%ebp
80101679:	83 ec 38             	sub    $0x38,%esp
8010167c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010167f:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101683:	8b 45 08             	mov    0x8(%ebp),%eax
80101686:	83 ec 08             	sub    $0x8,%esp
80101689:	8d 55 dc             	lea    -0x24(%ebp),%edx
8010168c:	52                   	push   %edx
8010168d:	50                   	push   %eax
8010168e:	e8 f6 fc ff ff       	call   80101389 <readsb>
80101693:	83 c4 10             	add    $0x10,%esp

  for(inum = 1; inum < sb.ninodes; inum++){
80101696:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010169d:	e9 98 00 00 00       	jmp    8010173a <ialloc+0xc4>
    bp = bread(dev, IBLOCK(inum));
801016a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016a5:	c1 e8 03             	shr    $0x3,%eax
801016a8:	83 c0 02             	add    $0x2,%eax
801016ab:	83 ec 08             	sub    $0x8,%esp
801016ae:	50                   	push   %eax
801016af:	ff 75 08             	pushl  0x8(%ebp)
801016b2:	e8 00 eb ff ff       	call   801001b7 <bread>
801016b7:	83 c4 10             	add    $0x10,%esp
801016ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016c0:	8d 50 18             	lea    0x18(%eax),%edx
801016c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016c6:	83 e0 07             	and    $0x7,%eax
801016c9:	c1 e0 06             	shl    $0x6,%eax
801016cc:	01 d0                	add    %edx,%eax
801016ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801016d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016d4:	0f b7 00             	movzwl (%eax),%eax
801016d7:	66 85 c0             	test   %ax,%ax
801016da:	75 4c                	jne    80101728 <ialloc+0xb2>
      memset(dip, 0, sizeof(*dip));
801016dc:	83 ec 04             	sub    $0x4,%esp
801016df:	6a 40                	push   $0x40
801016e1:	6a 00                	push   $0x0
801016e3:	ff 75 ec             	pushl  -0x14(%ebp)
801016e6:	e8 53 3b 00 00       	call   8010523e <memset>
801016eb:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801016ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016f1:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
801016f5:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016f8:	83 ec 0c             	sub    $0xc,%esp
801016fb:	ff 75 f0             	pushl  -0x10(%ebp)
801016fe:	e8 60 1c 00 00       	call   80103363 <log_write>
80101703:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
80101706:	83 ec 0c             	sub    $0xc,%esp
80101709:	ff 75 f0             	pushl  -0x10(%ebp)
8010170c:	e8 1e eb ff ff       	call   8010022f <brelse>
80101711:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
80101714:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101717:	83 ec 08             	sub    $0x8,%esp
8010171a:	50                   	push   %eax
8010171b:	ff 75 08             	pushl  0x8(%ebp)
8010171e:	e8 ef 00 00 00       	call   80101812 <iget>
80101723:	83 c4 10             	add    $0x10,%esp
80101726:	eb 2d                	jmp    80101755 <ialloc+0xdf>
    }
    brelse(bp);
80101728:	83 ec 0c             	sub    $0xc,%esp
8010172b:	ff 75 f0             	pushl  -0x10(%ebp)
8010172e:	e8 fc ea ff ff       	call   8010022f <brelse>
80101733:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101736:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010173a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010173d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101740:	39 c2                	cmp    %eax,%edx
80101742:	0f 87 5a ff ff ff    	ja     801016a2 <ialloc+0x2c>
  }
  panic("ialloc: no inodes");
80101748:	83 ec 0c             	sub    $0xc,%esp
8010174b:	68 7d 86 10 80       	push   $0x8010867d
80101750:	e8 26 ee ff ff       	call   8010057b <panic>
}
80101755:	c9                   	leave  
80101756:	c3                   	ret    

80101757 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101757:	55                   	push   %ebp
80101758:	89 e5                	mov    %esp,%ebp
8010175a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
8010175d:	8b 45 08             	mov    0x8(%ebp),%eax
80101760:	8b 40 04             	mov    0x4(%eax),%eax
80101763:	c1 e8 03             	shr    $0x3,%eax
80101766:	8d 50 02             	lea    0x2(%eax),%edx
80101769:	8b 45 08             	mov    0x8(%ebp),%eax
8010176c:	8b 00                	mov    (%eax),%eax
8010176e:	83 ec 08             	sub    $0x8,%esp
80101771:	52                   	push   %edx
80101772:	50                   	push   %eax
80101773:	e8 3f ea ff ff       	call   801001b7 <bread>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010177e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101781:	8d 50 18             	lea    0x18(%eax),%edx
80101784:	8b 45 08             	mov    0x8(%ebp),%eax
80101787:	8b 40 04             	mov    0x4(%eax),%eax
8010178a:	83 e0 07             	and    $0x7,%eax
8010178d:	c1 e0 06             	shl    $0x6,%eax
80101790:	01 d0                	add    %edx,%eax
80101792:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101795:	8b 45 08             	mov    0x8(%ebp),%eax
80101798:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010179c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010179f:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017a2:	8b 45 08             	mov    0x8(%ebp),%eax
801017a5:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801017a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ac:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801017b0:	8b 45 08             	mov    0x8(%ebp),%eax
801017b3:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801017b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ba:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801017be:	8b 45 08             	mov    0x8(%ebp),%eax
801017c1:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801017c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c8:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801017cc:	8b 45 08             	mov    0x8(%ebp),%eax
801017cf:	8b 50 18             	mov    0x18(%eax),%edx
801017d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d5:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017d8:	8b 45 08             	mov    0x8(%ebp),%eax
801017db:	8d 50 1c             	lea    0x1c(%eax),%edx
801017de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e1:	83 c0 0c             	add    $0xc,%eax
801017e4:	83 ec 04             	sub    $0x4,%esp
801017e7:	6a 34                	push   $0x34
801017e9:	52                   	push   %edx
801017ea:	50                   	push   %eax
801017eb:	e8 0d 3b 00 00       	call   801052fd <memmove>
801017f0:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801017f3:	83 ec 0c             	sub    $0xc,%esp
801017f6:	ff 75 f4             	pushl  -0xc(%ebp)
801017f9:	e8 65 1b 00 00       	call   80103363 <log_write>
801017fe:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101801:	83 ec 0c             	sub    $0xc,%esp
80101804:	ff 75 f4             	pushl  -0xc(%ebp)
80101807:	e8 23 ea ff ff       	call   8010022f <brelse>
8010180c:	83 c4 10             	add    $0x10,%esp
}
8010180f:	90                   	nop
80101810:	c9                   	leave  
80101811:	c3                   	ret    

80101812 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101812:	55                   	push   %ebp
80101813:	89 e5                	mov    %esp,%ebp
80101815:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 20 d8 10 80       	push   $0x8010d820
80101820:	e8 b6 37 00 00       	call   80104fdb <acquire>
80101825:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101828:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010182f:	c7 45 f4 54 d8 10 80 	movl   $0x8010d854,-0xc(%ebp)
80101836:	eb 5d                	jmp    80101895 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183b:	8b 40 08             	mov    0x8(%eax),%eax
8010183e:	85 c0                	test   %eax,%eax
80101840:	7e 39                	jle    8010187b <iget+0x69>
80101842:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101845:	8b 00                	mov    (%eax),%eax
80101847:	39 45 08             	cmp    %eax,0x8(%ebp)
8010184a:	75 2f                	jne    8010187b <iget+0x69>
8010184c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184f:	8b 40 04             	mov    0x4(%eax),%eax
80101852:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101855:	75 24                	jne    8010187b <iget+0x69>
      ip->ref++;
80101857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185a:	8b 40 08             	mov    0x8(%eax),%eax
8010185d:	8d 50 01             	lea    0x1(%eax),%edx
80101860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101863:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101866:	83 ec 0c             	sub    $0xc,%esp
80101869:	68 20 d8 10 80       	push   $0x8010d820
8010186e:	e8 cf 37 00 00       	call   80105042 <release>
80101873:	83 c4 10             	add    $0x10,%esp
      return ip;
80101876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101879:	eb 74                	jmp    801018ef <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010187b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010187f:	75 10                	jne    80101891 <iget+0x7f>
80101881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101884:	8b 40 08             	mov    0x8(%eax),%eax
80101887:	85 c0                	test   %eax,%eax
80101889:	75 06                	jne    80101891 <iget+0x7f>
      empty = ip;
8010188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101891:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101895:	81 7d f4 f4 e7 10 80 	cmpl   $0x8010e7f4,-0xc(%ebp)
8010189c:	72 9a                	jb     80101838 <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010189e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018a2:	75 0d                	jne    801018b1 <iget+0x9f>
    panic("iget: no inodes");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 8f 86 10 80       	push   $0x8010868f
801018ac:	e8 ca ec ff ff       	call   8010057b <panic>

  ip = empty;
801018b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801018b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ba:	8b 55 08             	mov    0x8(%ebp),%edx
801018bd:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c2:	8b 55 0c             	mov    0xc(%ebp),%edx
801018c5:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018cb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801018dc:	83 ec 0c             	sub    $0xc,%esp
801018df:	68 20 d8 10 80       	push   $0x8010d820
801018e4:	e8 59 37 00 00       	call   80105042 <release>
801018e9:	83 c4 10             	add    $0x10,%esp

  return ip;
801018ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801018ef:	c9                   	leave  
801018f0:	c3                   	ret    

801018f1 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018f1:	55                   	push   %ebp
801018f2:	89 e5                	mov    %esp,%ebp
801018f4:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801018f7:	83 ec 0c             	sub    $0xc,%esp
801018fa:	68 20 d8 10 80       	push   $0x8010d820
801018ff:	e8 d7 36 00 00       	call   80104fdb <acquire>
80101904:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101907:	8b 45 08             	mov    0x8(%ebp),%eax
8010190a:	8b 40 08             	mov    0x8(%eax),%eax
8010190d:	8d 50 01             	lea    0x1(%eax),%edx
80101910:	8b 45 08             	mov    0x8(%ebp),%eax
80101913:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101916:	83 ec 0c             	sub    $0xc,%esp
80101919:	68 20 d8 10 80       	push   $0x8010d820
8010191e:	e8 1f 37 00 00       	call   80105042 <release>
80101923:	83 c4 10             	add    $0x10,%esp
  return ip;
80101926:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101929:	c9                   	leave  
8010192a:	c3                   	ret    

8010192b <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010192b:	55                   	push   %ebp
8010192c:	89 e5                	mov    %esp,%ebp
8010192e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101931:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101935:	74 0a                	je     80101941 <ilock+0x16>
80101937:	8b 45 08             	mov    0x8(%ebp),%eax
8010193a:	8b 40 08             	mov    0x8(%eax),%eax
8010193d:	85 c0                	test   %eax,%eax
8010193f:	7f 0d                	jg     8010194e <ilock+0x23>
    panic("ilock");
80101941:	83 ec 0c             	sub    $0xc,%esp
80101944:	68 9f 86 10 80       	push   $0x8010869f
80101949:	e8 2d ec ff ff       	call   8010057b <panic>

  acquire(&icache.lock);
8010194e:	83 ec 0c             	sub    $0xc,%esp
80101951:	68 20 d8 10 80       	push   $0x8010d820
80101956:	e8 80 36 00 00       	call   80104fdb <acquire>
8010195b:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010195e:	eb 13                	jmp    80101973 <ilock+0x48>
    sleep(ip, &icache.lock);
80101960:	83 ec 08             	sub    $0x8,%esp
80101963:	68 20 d8 10 80       	push   $0x8010d820
80101968:	ff 75 08             	pushl  0x8(%ebp)
8010196b:	e8 4c 30 00 00       	call   801049bc <sleep>
80101970:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101973:	8b 45 08             	mov    0x8(%ebp),%eax
80101976:	8b 40 0c             	mov    0xc(%eax),%eax
80101979:	83 e0 01             	and    $0x1,%eax
8010197c:	85 c0                	test   %eax,%eax
8010197e:	75 e0                	jne    80101960 <ilock+0x35>
  ip->flags |= I_BUSY;
80101980:	8b 45 08             	mov    0x8(%ebp),%eax
80101983:	8b 40 0c             	mov    0xc(%eax),%eax
80101986:	83 c8 01             	or     $0x1,%eax
80101989:	89 c2                	mov    %eax,%edx
8010198b:	8b 45 08             	mov    0x8(%ebp),%eax
8010198e:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101991:	83 ec 0c             	sub    $0xc,%esp
80101994:	68 20 d8 10 80       	push   $0x8010d820
80101999:	e8 a4 36 00 00       	call   80105042 <release>
8010199e:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
801019a1:	8b 45 08             	mov    0x8(%ebp),%eax
801019a4:	8b 40 0c             	mov    0xc(%eax),%eax
801019a7:	83 e0 02             	and    $0x2,%eax
801019aa:	85 c0                	test   %eax,%eax
801019ac:	0f 85 ce 00 00 00    	jne    80101a80 <ilock+0x155>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801019b2:	8b 45 08             	mov    0x8(%ebp),%eax
801019b5:	8b 40 04             	mov    0x4(%eax),%eax
801019b8:	c1 e8 03             	shr    $0x3,%eax
801019bb:	8d 50 02             	lea    0x2(%eax),%edx
801019be:	8b 45 08             	mov    0x8(%ebp),%eax
801019c1:	8b 00                	mov    (%eax),%eax
801019c3:	83 ec 08             	sub    $0x8,%esp
801019c6:	52                   	push   %edx
801019c7:	50                   	push   %eax
801019c8:	e8 ea e7 ff ff       	call   801001b7 <bread>
801019cd:	83 c4 10             	add    $0x10,%esp
801019d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019d6:	8d 50 18             	lea    0x18(%eax),%edx
801019d9:	8b 45 08             	mov    0x8(%ebp),%eax
801019dc:	8b 40 04             	mov    0x4(%eax),%eax
801019df:	83 e0 07             	and    $0x7,%eax
801019e2:	c1 e0 06             	shl    $0x6,%eax
801019e5:	01 d0                	add    %edx,%eax
801019e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ed:	0f b7 10             	movzwl (%eax),%edx
801019f0:	8b 45 08             	mov    0x8(%ebp),%eax
801019f3:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
801019f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019fa:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101a01:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a08:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0f:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a16:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1d:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a24:	8b 50 08             	mov    0x8(%eax),%edx
80101a27:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2a:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a30:	8d 50 0c             	lea    0xc(%eax),%edx
80101a33:	8b 45 08             	mov    0x8(%ebp),%eax
80101a36:	83 c0 1c             	add    $0x1c,%eax
80101a39:	83 ec 04             	sub    $0x4,%esp
80101a3c:	6a 34                	push   $0x34
80101a3e:	52                   	push   %edx
80101a3f:	50                   	push   %eax
80101a40:	e8 b8 38 00 00       	call   801052fd <memmove>
80101a45:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a48:	83 ec 0c             	sub    $0xc,%esp
80101a4b:	ff 75 f4             	pushl  -0xc(%ebp)
80101a4e:	e8 dc e7 ff ff       	call   8010022f <brelse>
80101a53:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a56:	8b 45 08             	mov    0x8(%ebp),%eax
80101a59:	8b 40 0c             	mov    0xc(%eax),%eax
80101a5c:	83 c8 02             	or     $0x2,%eax
80101a5f:	89 c2                	mov    %eax,%edx
80101a61:	8b 45 08             	mov    0x8(%ebp),%eax
80101a64:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a67:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a6e:	66 85 c0             	test   %ax,%ax
80101a71:	75 0d                	jne    80101a80 <ilock+0x155>
      panic("ilock: no type");
80101a73:	83 ec 0c             	sub    $0xc,%esp
80101a76:	68 a5 86 10 80       	push   $0x801086a5
80101a7b:	e8 fb ea ff ff       	call   8010057b <panic>
  }
}
80101a80:	90                   	nop
80101a81:	c9                   	leave  
80101a82:	c3                   	ret    

80101a83 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a83:	55                   	push   %ebp
80101a84:	89 e5                	mov    %esp,%ebp
80101a86:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a8d:	74 17                	je     80101aa6 <iunlock+0x23>
80101a8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a92:	8b 40 0c             	mov    0xc(%eax),%eax
80101a95:	83 e0 01             	and    $0x1,%eax
80101a98:	85 c0                	test   %eax,%eax
80101a9a:	74 0a                	je     80101aa6 <iunlock+0x23>
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 40 08             	mov    0x8(%eax),%eax
80101aa2:	85 c0                	test   %eax,%eax
80101aa4:	7f 0d                	jg     80101ab3 <iunlock+0x30>
    panic("iunlock");
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	68 b4 86 10 80       	push   $0x801086b4
80101aae:	e8 c8 ea ff ff       	call   8010057b <panic>

  acquire(&icache.lock);
80101ab3:	83 ec 0c             	sub    $0xc,%esp
80101ab6:	68 20 d8 10 80       	push   $0x8010d820
80101abb:	e8 1b 35 00 00       	call   80104fdb <acquire>
80101ac0:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac6:	8b 40 0c             	mov    0xc(%eax),%eax
80101ac9:	83 e0 fe             	and    $0xfffffffe,%eax
80101acc:	89 c2                	mov    %eax,%edx
80101ace:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad1:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101ad4:	83 ec 0c             	sub    $0xc,%esp
80101ad7:	ff 75 08             	pushl  0x8(%ebp)
80101ada:	e8 cc 2f 00 00       	call   80104aab <wakeup>
80101adf:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ae2:	83 ec 0c             	sub    $0xc,%esp
80101ae5:	68 20 d8 10 80       	push   $0x8010d820
80101aea:	e8 53 35 00 00       	call   80105042 <release>
80101aef:	83 c4 10             	add    $0x10,%esp
}
80101af2:	90                   	nop
80101af3:	c9                   	leave  
80101af4:	c3                   	ret    

80101af5 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101af5:	55                   	push   %ebp
80101af6:	89 e5                	mov    %esp,%ebp
80101af8:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101afb:	83 ec 0c             	sub    $0xc,%esp
80101afe:	68 20 d8 10 80       	push   $0x8010d820
80101b03:	e8 d3 34 00 00       	call   80104fdb <acquire>
80101b08:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0e:	8b 40 08             	mov    0x8(%eax),%eax
80101b11:	83 f8 01             	cmp    $0x1,%eax
80101b14:	0f 85 a9 00 00 00    	jne    80101bc3 <iput+0xce>
80101b1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1d:	8b 40 0c             	mov    0xc(%eax),%eax
80101b20:	83 e0 02             	and    $0x2,%eax
80101b23:	85 c0                	test   %eax,%eax
80101b25:	0f 84 98 00 00 00    	je     80101bc3 <iput+0xce>
80101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b32:	66 85 c0             	test   %ax,%ax
80101b35:	0f 85 88 00 00 00    	jne    80101bc3 <iput+0xce>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3e:	8b 40 0c             	mov    0xc(%eax),%eax
80101b41:	83 e0 01             	and    $0x1,%eax
80101b44:	85 c0                	test   %eax,%eax
80101b46:	74 0d                	je     80101b55 <iput+0x60>
      panic("iput busy");
80101b48:	83 ec 0c             	sub    $0xc,%esp
80101b4b:	68 bc 86 10 80       	push   $0x801086bc
80101b50:	e8 26 ea ff ff       	call   8010057b <panic>
    ip->flags |= I_BUSY;
80101b55:	8b 45 08             	mov    0x8(%ebp),%eax
80101b58:	8b 40 0c             	mov    0xc(%eax),%eax
80101b5b:	83 c8 01             	or     $0x1,%eax
80101b5e:	89 c2                	mov    %eax,%edx
80101b60:	8b 45 08             	mov    0x8(%ebp),%eax
80101b63:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b66:	83 ec 0c             	sub    $0xc,%esp
80101b69:	68 20 d8 10 80       	push   $0x8010d820
80101b6e:	e8 cf 34 00 00       	call   80105042 <release>
80101b73:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b76:	83 ec 0c             	sub    $0xc,%esp
80101b79:	ff 75 08             	pushl  0x8(%ebp)
80101b7c:	e8 a3 01 00 00       	call   80101d24 <itrunc>
80101b81:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b84:	8b 45 08             	mov    0x8(%ebp),%eax
80101b87:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b8d:	83 ec 0c             	sub    $0xc,%esp
80101b90:	ff 75 08             	pushl  0x8(%ebp)
80101b93:	e8 bf fb ff ff       	call   80101757 <iupdate>
80101b98:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101b9b:	83 ec 0c             	sub    $0xc,%esp
80101b9e:	68 20 d8 10 80       	push   $0x8010d820
80101ba3:	e8 33 34 00 00       	call   80104fdb <acquire>
80101ba8:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101bab:	8b 45 08             	mov    0x8(%ebp),%eax
80101bae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101bb5:	83 ec 0c             	sub    $0xc,%esp
80101bb8:	ff 75 08             	pushl  0x8(%ebp)
80101bbb:	e8 eb 2e 00 00       	call   80104aab <wakeup>
80101bc0:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101bc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc6:	8b 40 08             	mov    0x8(%eax),%eax
80101bc9:	8d 50 ff             	lea    -0x1(%eax),%edx
80101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcf:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bd2:	83 ec 0c             	sub    $0xc,%esp
80101bd5:	68 20 d8 10 80       	push   $0x8010d820
80101bda:	e8 63 34 00 00       	call   80105042 <release>
80101bdf:	83 c4 10             	add    $0x10,%esp
}
80101be2:	90                   	nop
80101be3:	c9                   	leave  
80101be4:	c3                   	ret    

80101be5 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101be5:	55                   	push   %ebp
80101be6:	89 e5                	mov    %esp,%ebp
80101be8:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101beb:	83 ec 0c             	sub    $0xc,%esp
80101bee:	ff 75 08             	pushl  0x8(%ebp)
80101bf1:	e8 8d fe ff ff       	call   80101a83 <iunlock>
80101bf6:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101bf9:	83 ec 0c             	sub    $0xc,%esp
80101bfc:	ff 75 08             	pushl  0x8(%ebp)
80101bff:	e8 f1 fe ff ff       	call   80101af5 <iput>
80101c04:	83 c4 10             	add    $0x10,%esp
}
80101c07:	90                   	nop
80101c08:	c9                   	leave  
80101c09:	c3                   	ret    

80101c0a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c0a:	55                   	push   %ebp
80101c0b:	89 e5                	mov    %esp,%ebp
80101c0d:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c10:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c14:	77 42                	ja     80101c58 <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
80101c16:	8b 45 08             	mov    0x8(%ebp),%eax
80101c19:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c1c:	83 c2 04             	add    $0x4,%edx
80101c1f:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c23:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c2a:	75 24                	jne    80101c50 <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2f:	8b 00                	mov    (%eax),%eax
80101c31:	83 ec 0c             	sub    $0xc,%esp
80101c34:	50                   	push   %eax
80101c35:	e8 e5 f7 ff ff       	call   8010141f <balloc>
80101c3a:	83 c4 10             	add    $0x10,%esp
80101c3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c40:	8b 45 08             	mov    0x8(%ebp),%eax
80101c43:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c46:	8d 4a 04             	lea    0x4(%edx),%ecx
80101c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c4c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c53:	e9 ca 00 00 00       	jmp    80101d22 <bmap+0x118>
  }
  bn -= NDIRECT;
80101c58:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c5c:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c60:	0f 87 af 00 00 00    	ja     80101d15 <bmap+0x10b>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c66:	8b 45 08             	mov    0x8(%ebp),%eax
80101c69:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c73:	75 1d                	jne    80101c92 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c75:	8b 45 08             	mov    0x8(%ebp),%eax
80101c78:	8b 00                	mov    (%eax),%eax
80101c7a:	83 ec 0c             	sub    $0xc,%esp
80101c7d:	50                   	push   %eax
80101c7e:	e8 9c f7 ff ff       	call   8010141f <balloc>
80101c83:	83 c4 10             	add    $0x10,%esp
80101c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c89:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c8f:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c92:	8b 45 08             	mov    0x8(%ebp),%eax
80101c95:	8b 00                	mov    (%eax),%eax
80101c97:	83 ec 08             	sub    $0x8,%esp
80101c9a:	ff 75 f4             	pushl  -0xc(%ebp)
80101c9d:	50                   	push   %eax
80101c9e:	e8 14 e5 ff ff       	call   801001b7 <bread>
80101ca3:	83 c4 10             	add    $0x10,%esp
80101ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cac:	83 c0 18             	add    $0x18,%eax
80101caf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cb5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cbf:	01 d0                	add    %edx,%eax
80101cc1:	8b 00                	mov    (%eax),%eax
80101cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cca:	75 36                	jne    80101d02 <bmap+0xf8>
      a[bn] = addr = balloc(ip->dev);
80101ccc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccf:	8b 00                	mov    (%eax),%eax
80101cd1:	83 ec 0c             	sub    $0xc,%esp
80101cd4:	50                   	push   %eax
80101cd5:	e8 45 f7 ff ff       	call   8010141f <balloc>
80101cda:	83 c4 10             	add    $0x10,%esp
80101cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ce3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ced:	01 c2                	add    %eax,%edx
80101cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cf2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101cf4:	83 ec 0c             	sub    $0xc,%esp
80101cf7:	ff 75 f0             	pushl  -0x10(%ebp)
80101cfa:	e8 64 16 00 00       	call   80103363 <log_write>
80101cff:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d02:	83 ec 0c             	sub    $0xc,%esp
80101d05:	ff 75 f0             	pushl  -0x10(%ebp)
80101d08:	e8 22 e5 ff ff       	call   8010022f <brelse>
80101d0d:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d13:	eb 0d                	jmp    80101d22 <bmap+0x118>
  }

  panic("bmap: out of range");
80101d15:	83 ec 0c             	sub    $0xc,%esp
80101d18:	68 c6 86 10 80       	push   $0x801086c6
80101d1d:	e8 59 e8 ff ff       	call   8010057b <panic>
}
80101d22:	c9                   	leave  
80101d23:	c3                   	ret    

80101d24 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d24:	55                   	push   %ebp
80101d25:	89 e5                	mov    %esp,%ebp
80101d27:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d31:	eb 45                	jmp    80101d78 <itrunc+0x54>
    if(ip->addrs[i]){
80101d33:	8b 45 08             	mov    0x8(%ebp),%eax
80101d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d39:	83 c2 04             	add    $0x4,%edx
80101d3c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d40:	85 c0                	test   %eax,%eax
80101d42:	74 30                	je     80101d74 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d44:	8b 45 08             	mov    0x8(%ebp),%eax
80101d47:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d4a:	83 c2 04             	add    $0x4,%edx
80101d4d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d51:	8b 55 08             	mov    0x8(%ebp),%edx
80101d54:	8b 12                	mov    (%edx),%edx
80101d56:	83 ec 08             	sub    $0x8,%esp
80101d59:	50                   	push   %eax
80101d5a:	52                   	push   %edx
80101d5b:	e8 1d f8 ff ff       	call   8010157d <bfree>
80101d60:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d63:	8b 45 08             	mov    0x8(%ebp),%eax
80101d66:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d69:	83 c2 04             	add    $0x4,%edx
80101d6c:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d73:	00 
  for(i = 0; i < NDIRECT; i++){
80101d74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d78:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d7c:	7e b5                	jle    80101d33 <itrunc+0xf>
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d81:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d84:	85 c0                	test   %eax,%eax
80101d86:	0f 84 a1 00 00 00    	je     80101e2d <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8f:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d92:	8b 45 08             	mov    0x8(%ebp),%eax
80101d95:	8b 00                	mov    (%eax),%eax
80101d97:	83 ec 08             	sub    $0x8,%esp
80101d9a:	52                   	push   %edx
80101d9b:	50                   	push   %eax
80101d9c:	e8 16 e4 ff ff       	call   801001b7 <bread>
80101da1:	83 c4 10             	add    $0x10,%esp
80101da4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101da7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101daa:	83 c0 18             	add    $0x18,%eax
80101dad:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101db0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101db7:	eb 3c                	jmp    80101df5 <itrunc+0xd1>
      if(a[j])
80101db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dbc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dc6:	01 d0                	add    %edx,%eax
80101dc8:	8b 00                	mov    (%eax),%eax
80101dca:	85 c0                	test   %eax,%eax
80101dcc:	74 23                	je     80101df1 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dd1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ddb:	01 d0                	add    %edx,%eax
80101ddd:	8b 00                	mov    (%eax),%eax
80101ddf:	8b 55 08             	mov    0x8(%ebp),%edx
80101de2:	8b 12                	mov    (%edx),%edx
80101de4:	83 ec 08             	sub    $0x8,%esp
80101de7:	50                   	push   %eax
80101de8:	52                   	push   %edx
80101de9:	e8 8f f7 ff ff       	call   8010157d <bfree>
80101dee:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101df1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101df8:	83 f8 7f             	cmp    $0x7f,%eax
80101dfb:	76 bc                	jbe    80101db9 <itrunc+0x95>
    }
    brelse(bp);
80101dfd:	83 ec 0c             	sub    $0xc,%esp
80101e00:	ff 75 ec             	pushl  -0x14(%ebp)
80101e03:	e8 27 e4 ff ff       	call   8010022f <brelse>
80101e08:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0e:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e11:	8b 55 08             	mov    0x8(%ebp),%edx
80101e14:	8b 12                	mov    (%edx),%edx
80101e16:	83 ec 08             	sub    $0x8,%esp
80101e19:	50                   	push   %eax
80101e1a:	52                   	push   %edx
80101e1b:	e8 5d f7 ff ff       	call   8010157d <bfree>
80101e20:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e23:	8b 45 08             	mov    0x8(%ebp),%eax
80101e26:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e30:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e37:	83 ec 0c             	sub    $0xc,%esp
80101e3a:	ff 75 08             	pushl  0x8(%ebp)
80101e3d:	e8 15 f9 ff ff       	call   80101757 <iupdate>
80101e42:	83 c4 10             	add    $0x10,%esp
}
80101e45:	90                   	nop
80101e46:	c9                   	leave  
80101e47:	c3                   	ret    

80101e48 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e48:	55                   	push   %ebp
80101e49:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4e:	8b 00                	mov    (%eax),%eax
80101e50:	89 c2                	mov    %eax,%edx
80101e52:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e55:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e58:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5b:	8b 50 04             	mov    0x4(%eax),%edx
80101e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e61:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e64:	8b 45 08             	mov    0x8(%ebp),%eax
80101e67:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e6e:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e71:	8b 45 08             	mov    0x8(%ebp),%eax
80101e74:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e78:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e7b:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e82:	8b 50 18             	mov    0x18(%eax),%edx
80101e85:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e88:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e8b:	90                   	nop
80101e8c:	5d                   	pop    %ebp
80101e8d:	c3                   	ret    

80101e8e <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e8e:	55                   	push   %ebp
80101e8f:	89 e5                	mov    %esp,%ebp
80101e91:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e94:	8b 45 08             	mov    0x8(%ebp),%eax
80101e97:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e9b:	66 83 f8 03          	cmp    $0x3,%ax
80101e9f:	75 5c                	jne    80101efd <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ea8:	66 85 c0             	test   %ax,%ax
80101eab:	78 20                	js     80101ecd <readi+0x3f>
80101ead:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eb4:	66 83 f8 09          	cmp    $0x9,%ax
80101eb8:	7f 13                	jg     80101ecd <readi+0x3f>
80101eba:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebd:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ec1:	98                   	cwtl   
80101ec2:	8b 04 c5 20 ce 10 80 	mov    -0x7fef31e0(,%eax,8),%eax
80101ec9:	85 c0                	test   %eax,%eax
80101ecb:	75 0a                	jne    80101ed7 <readi+0x49>
      return -1;
80101ecd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ed2:	e9 0a 01 00 00       	jmp    80101fe1 <readi+0x153>
    return devsw[ip->major].read(ip, dst, n);
80101ed7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eda:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ede:	98                   	cwtl   
80101edf:	8b 04 c5 20 ce 10 80 	mov    -0x7fef31e0(,%eax,8),%eax
80101ee6:	8b 55 14             	mov    0x14(%ebp),%edx
80101ee9:	83 ec 04             	sub    $0x4,%esp
80101eec:	52                   	push   %edx
80101eed:	ff 75 0c             	pushl  0xc(%ebp)
80101ef0:	ff 75 08             	pushl  0x8(%ebp)
80101ef3:	ff d0                	call   *%eax
80101ef5:	83 c4 10             	add    $0x10,%esp
80101ef8:	e9 e4 00 00 00       	jmp    80101fe1 <readi+0x153>
  }

  if(off > ip->size || off + n < off)
80101efd:	8b 45 08             	mov    0x8(%ebp),%eax
80101f00:	8b 40 18             	mov    0x18(%eax),%eax
80101f03:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f06:	77 0d                	ja     80101f15 <readi+0x87>
80101f08:	8b 55 10             	mov    0x10(%ebp),%edx
80101f0b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f0e:	01 d0                	add    %edx,%eax
80101f10:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f13:	76 0a                	jbe    80101f1f <readi+0x91>
    return -1;
80101f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f1a:	e9 c2 00 00 00       	jmp    80101fe1 <readi+0x153>
  if(off + n > ip->size)
80101f1f:	8b 55 10             	mov    0x10(%ebp),%edx
80101f22:	8b 45 14             	mov    0x14(%ebp),%eax
80101f25:	01 c2                	add    %eax,%edx
80101f27:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2a:	8b 40 18             	mov    0x18(%eax),%eax
80101f2d:	39 c2                	cmp    %eax,%edx
80101f2f:	76 0c                	jbe    80101f3d <readi+0xaf>
    n = ip->size - off;
80101f31:	8b 45 08             	mov    0x8(%ebp),%eax
80101f34:	8b 40 18             	mov    0x18(%eax),%eax
80101f37:	2b 45 10             	sub    0x10(%ebp),%eax
80101f3a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f44:	e9 89 00 00 00       	jmp    80101fd2 <readi+0x144>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f49:	8b 45 10             	mov    0x10(%ebp),%eax
80101f4c:	c1 e8 09             	shr    $0x9,%eax
80101f4f:	83 ec 08             	sub    $0x8,%esp
80101f52:	50                   	push   %eax
80101f53:	ff 75 08             	pushl  0x8(%ebp)
80101f56:	e8 af fc ff ff       	call   80101c0a <bmap>
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	8b 55 08             	mov    0x8(%ebp),%edx
80101f61:	8b 12                	mov    (%edx),%edx
80101f63:	83 ec 08             	sub    $0x8,%esp
80101f66:	50                   	push   %eax
80101f67:	52                   	push   %edx
80101f68:	e8 4a e2 ff ff       	call   801001b7 <bread>
80101f6d:	83 c4 10             	add    $0x10,%esp
80101f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f73:	8b 45 10             	mov    0x10(%ebp),%eax
80101f76:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f7b:	ba 00 02 00 00       	mov    $0x200,%edx
80101f80:	29 c2                	sub    %eax,%edx
80101f82:	8b 45 14             	mov    0x14(%ebp),%eax
80101f85:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f88:	39 c2                	cmp    %eax,%edx
80101f8a:	0f 46 c2             	cmovbe %edx,%eax
80101f8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f93:	8d 50 18             	lea    0x18(%eax),%edx
80101f96:	8b 45 10             	mov    0x10(%ebp),%eax
80101f99:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f9e:	01 d0                	add    %edx,%eax
80101fa0:	83 ec 04             	sub    $0x4,%esp
80101fa3:	ff 75 ec             	pushl  -0x14(%ebp)
80101fa6:	50                   	push   %eax
80101fa7:	ff 75 0c             	pushl  0xc(%ebp)
80101faa:	e8 4e 33 00 00       	call   801052fd <memmove>
80101faf:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101fb2:	83 ec 0c             	sub    $0xc,%esp
80101fb5:	ff 75 f0             	pushl  -0x10(%ebp)
80101fb8:	e8 72 e2 ff ff       	call   8010022f <brelse>
80101fbd:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fc3:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fc9:	01 45 10             	add    %eax,0x10(%ebp)
80101fcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fcf:	01 45 0c             	add    %eax,0xc(%ebp)
80101fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fd5:	3b 45 14             	cmp    0x14(%ebp),%eax
80101fd8:	0f 82 6b ff ff ff    	jb     80101f49 <readi+0xbb>
  }
  return n;
80101fde:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101fe1:	c9                   	leave  
80101fe2:	c3                   	ret    

80101fe3 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101fe3:	55                   	push   %ebp
80101fe4:	89 e5                	mov    %esp,%ebp
80101fe6:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fec:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ff0:	66 83 f8 03          	cmp    $0x3,%ax
80101ff4:	75 5c                	jne    80102052 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ffd:	66 85 c0             	test   %ax,%ax
80102000:	78 20                	js     80102022 <writei+0x3f>
80102002:	8b 45 08             	mov    0x8(%ebp),%eax
80102005:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102009:	66 83 f8 09          	cmp    $0x9,%ax
8010200d:	7f 13                	jg     80102022 <writei+0x3f>
8010200f:	8b 45 08             	mov    0x8(%ebp),%eax
80102012:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102016:	98                   	cwtl   
80102017:	8b 04 c5 24 ce 10 80 	mov    -0x7fef31dc(,%eax,8),%eax
8010201e:	85 c0                	test   %eax,%eax
80102020:	75 0a                	jne    8010202c <writei+0x49>
      return -1;
80102022:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102027:	e9 3b 01 00 00       	jmp    80102167 <writei+0x184>
    return devsw[ip->major].write(ip, src, n);
8010202c:	8b 45 08             	mov    0x8(%ebp),%eax
8010202f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102033:	98                   	cwtl   
80102034:	8b 04 c5 24 ce 10 80 	mov    -0x7fef31dc(,%eax,8),%eax
8010203b:	8b 55 14             	mov    0x14(%ebp),%edx
8010203e:	83 ec 04             	sub    $0x4,%esp
80102041:	52                   	push   %edx
80102042:	ff 75 0c             	pushl  0xc(%ebp)
80102045:	ff 75 08             	pushl  0x8(%ebp)
80102048:	ff d0                	call   *%eax
8010204a:	83 c4 10             	add    $0x10,%esp
8010204d:	e9 15 01 00 00       	jmp    80102167 <writei+0x184>
  }

  if(off > ip->size || off + n < off)
80102052:	8b 45 08             	mov    0x8(%ebp),%eax
80102055:	8b 40 18             	mov    0x18(%eax),%eax
80102058:	39 45 10             	cmp    %eax,0x10(%ebp)
8010205b:	77 0d                	ja     8010206a <writei+0x87>
8010205d:	8b 55 10             	mov    0x10(%ebp),%edx
80102060:	8b 45 14             	mov    0x14(%ebp),%eax
80102063:	01 d0                	add    %edx,%eax
80102065:	39 45 10             	cmp    %eax,0x10(%ebp)
80102068:	76 0a                	jbe    80102074 <writei+0x91>
    return -1;
8010206a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010206f:	e9 f3 00 00 00       	jmp    80102167 <writei+0x184>
  if(off + n > MAXFILE*BSIZE)
80102074:	8b 55 10             	mov    0x10(%ebp),%edx
80102077:	8b 45 14             	mov    0x14(%ebp),%eax
8010207a:	01 d0                	add    %edx,%eax
8010207c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102081:	76 0a                	jbe    8010208d <writei+0xaa>
    return -1;
80102083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102088:	e9 da 00 00 00       	jmp    80102167 <writei+0x184>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010208d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102094:	e9 97 00 00 00       	jmp    80102130 <writei+0x14d>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102099:	8b 45 10             	mov    0x10(%ebp),%eax
8010209c:	c1 e8 09             	shr    $0x9,%eax
8010209f:	83 ec 08             	sub    $0x8,%esp
801020a2:	50                   	push   %eax
801020a3:	ff 75 08             	pushl  0x8(%ebp)
801020a6:	e8 5f fb ff ff       	call   80101c0a <bmap>
801020ab:	83 c4 10             	add    $0x10,%esp
801020ae:	8b 55 08             	mov    0x8(%ebp),%edx
801020b1:	8b 12                	mov    (%edx),%edx
801020b3:	83 ec 08             	sub    $0x8,%esp
801020b6:	50                   	push   %eax
801020b7:	52                   	push   %edx
801020b8:	e8 fa e0 ff ff       	call   801001b7 <bread>
801020bd:	83 c4 10             	add    $0x10,%esp
801020c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020c3:	8b 45 10             	mov    0x10(%ebp),%eax
801020c6:	25 ff 01 00 00       	and    $0x1ff,%eax
801020cb:	ba 00 02 00 00       	mov    $0x200,%edx
801020d0:	29 c2                	sub    %eax,%edx
801020d2:	8b 45 14             	mov    0x14(%ebp),%eax
801020d5:	2b 45 f4             	sub    -0xc(%ebp),%eax
801020d8:	39 c2                	cmp    %eax,%edx
801020da:	0f 46 c2             	cmovbe %edx,%eax
801020dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020e3:	8d 50 18             	lea    0x18(%eax),%edx
801020e6:	8b 45 10             	mov    0x10(%ebp),%eax
801020e9:	25 ff 01 00 00       	and    $0x1ff,%eax
801020ee:	01 d0                	add    %edx,%eax
801020f0:	83 ec 04             	sub    $0x4,%esp
801020f3:	ff 75 ec             	pushl  -0x14(%ebp)
801020f6:	ff 75 0c             	pushl  0xc(%ebp)
801020f9:	50                   	push   %eax
801020fa:	e8 fe 31 00 00       	call   801052fd <memmove>
801020ff:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102102:	83 ec 0c             	sub    $0xc,%esp
80102105:	ff 75 f0             	pushl  -0x10(%ebp)
80102108:	e8 56 12 00 00       	call   80103363 <log_write>
8010210d:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102110:	83 ec 0c             	sub    $0xc,%esp
80102113:	ff 75 f0             	pushl  -0x10(%ebp)
80102116:	e8 14 e1 ff ff       	call   8010022f <brelse>
8010211b:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010211e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102121:	01 45 f4             	add    %eax,-0xc(%ebp)
80102124:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102127:	01 45 10             	add    %eax,0x10(%ebp)
8010212a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010212d:	01 45 0c             	add    %eax,0xc(%ebp)
80102130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102133:	3b 45 14             	cmp    0x14(%ebp),%eax
80102136:	0f 82 5d ff ff ff    	jb     80102099 <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
8010213c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102140:	74 22                	je     80102164 <writei+0x181>
80102142:	8b 45 08             	mov    0x8(%ebp),%eax
80102145:	8b 40 18             	mov    0x18(%eax),%eax
80102148:	39 45 10             	cmp    %eax,0x10(%ebp)
8010214b:	76 17                	jbe    80102164 <writei+0x181>
    ip->size = off;
8010214d:	8b 45 08             	mov    0x8(%ebp),%eax
80102150:	8b 55 10             	mov    0x10(%ebp),%edx
80102153:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102156:	83 ec 0c             	sub    $0xc,%esp
80102159:	ff 75 08             	pushl  0x8(%ebp)
8010215c:	e8 f6 f5 ff ff       	call   80101757 <iupdate>
80102161:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102164:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102167:	c9                   	leave  
80102168:	c3                   	ret    

80102169 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102169:	55                   	push   %ebp
8010216a:	89 e5                	mov    %esp,%ebp
8010216c:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010216f:	83 ec 04             	sub    $0x4,%esp
80102172:	6a 0e                	push   $0xe
80102174:	ff 75 0c             	pushl  0xc(%ebp)
80102177:	ff 75 08             	pushl  0x8(%ebp)
8010217a:	e8 14 32 00 00       	call   80105393 <strncmp>
8010217f:	83 c4 10             	add    $0x10,%esp
}
80102182:	c9                   	leave  
80102183:	c3                   	ret    

80102184 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102184:	55                   	push   %ebp
80102185:	89 e5                	mov    %esp,%ebp
80102187:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010218a:	8b 45 08             	mov    0x8(%ebp),%eax
8010218d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102191:	66 83 f8 01          	cmp    $0x1,%ax
80102195:	74 0d                	je     801021a4 <dirlookup+0x20>
    panic("dirlookup not DIR");
80102197:	83 ec 0c             	sub    $0xc,%esp
8010219a:	68 d9 86 10 80       	push   $0x801086d9
8010219f:	e8 d7 e3 ff ff       	call   8010057b <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021ab:	eb 7b                	jmp    80102228 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021ad:	6a 10                	push   $0x10
801021af:	ff 75 f4             	pushl  -0xc(%ebp)
801021b2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021b5:	50                   	push   %eax
801021b6:	ff 75 08             	pushl  0x8(%ebp)
801021b9:	e8 d0 fc ff ff       	call   80101e8e <readi>
801021be:	83 c4 10             	add    $0x10,%esp
801021c1:	83 f8 10             	cmp    $0x10,%eax
801021c4:	74 0d                	je     801021d3 <dirlookup+0x4f>
      panic("dirlink read");
801021c6:	83 ec 0c             	sub    $0xc,%esp
801021c9:	68 eb 86 10 80       	push   $0x801086eb
801021ce:	e8 a8 e3 ff ff       	call   8010057b <panic>
    if(de.inum == 0)
801021d3:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021d7:	66 85 c0             	test   %ax,%ax
801021da:	74 47                	je     80102223 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801021dc:	83 ec 08             	sub    $0x8,%esp
801021df:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021e2:	83 c0 02             	add    $0x2,%eax
801021e5:	50                   	push   %eax
801021e6:	ff 75 0c             	pushl  0xc(%ebp)
801021e9:	e8 7b ff ff ff       	call   80102169 <namecmp>
801021ee:	83 c4 10             	add    $0x10,%esp
801021f1:	85 c0                	test   %eax,%eax
801021f3:	75 2f                	jne    80102224 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801021f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021f9:	74 08                	je     80102203 <dirlookup+0x7f>
        *poff = off;
801021fb:	8b 45 10             	mov    0x10(%ebp),%eax
801021fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102201:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102203:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102207:	0f b7 c0             	movzwl %ax,%eax
8010220a:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010220d:	8b 45 08             	mov    0x8(%ebp),%eax
80102210:	8b 00                	mov    (%eax),%eax
80102212:	83 ec 08             	sub    $0x8,%esp
80102215:	ff 75 f0             	pushl  -0x10(%ebp)
80102218:	50                   	push   %eax
80102219:	e8 f4 f5 ff ff       	call   80101812 <iget>
8010221e:	83 c4 10             	add    $0x10,%esp
80102221:	eb 19                	jmp    8010223c <dirlookup+0xb8>
      continue;
80102223:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
80102224:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102228:	8b 45 08             	mov    0x8(%ebp),%eax
8010222b:	8b 40 18             	mov    0x18(%eax),%eax
8010222e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102231:	0f 82 76 ff ff ff    	jb     801021ad <dirlookup+0x29>
    }
  }

  return 0;
80102237:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010223c:	c9                   	leave  
8010223d:	c3                   	ret    

8010223e <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010223e:	55                   	push   %ebp
8010223f:	89 e5                	mov    %esp,%ebp
80102241:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102244:	83 ec 04             	sub    $0x4,%esp
80102247:	6a 00                	push   $0x0
80102249:	ff 75 0c             	pushl  0xc(%ebp)
8010224c:	ff 75 08             	pushl  0x8(%ebp)
8010224f:	e8 30 ff ff ff       	call   80102184 <dirlookup>
80102254:	83 c4 10             	add    $0x10,%esp
80102257:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010225a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010225e:	74 18                	je     80102278 <dirlink+0x3a>
    iput(ip);
80102260:	83 ec 0c             	sub    $0xc,%esp
80102263:	ff 75 f0             	pushl  -0x10(%ebp)
80102266:	e8 8a f8 ff ff       	call   80101af5 <iput>
8010226b:	83 c4 10             	add    $0x10,%esp
    return -1;
8010226e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102273:	e9 9c 00 00 00       	jmp    80102314 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102278:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010227f:	eb 39                	jmp    801022ba <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102284:	6a 10                	push   $0x10
80102286:	50                   	push   %eax
80102287:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010228a:	50                   	push   %eax
8010228b:	ff 75 08             	pushl  0x8(%ebp)
8010228e:	e8 fb fb ff ff       	call   80101e8e <readi>
80102293:	83 c4 10             	add    $0x10,%esp
80102296:	83 f8 10             	cmp    $0x10,%eax
80102299:	74 0d                	je     801022a8 <dirlink+0x6a>
      panic("dirlink read");
8010229b:	83 ec 0c             	sub    $0xc,%esp
8010229e:	68 eb 86 10 80       	push   $0x801086eb
801022a3:	e8 d3 e2 ff ff       	call   8010057b <panic>
    if(de.inum == 0)
801022a8:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022ac:	66 85 c0             	test   %ax,%ax
801022af:	74 18                	je     801022c9 <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
801022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022b4:	83 c0 10             	add    $0x10,%eax
801022b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022ba:	8b 45 08             	mov    0x8(%ebp),%eax
801022bd:	8b 50 18             	mov    0x18(%eax),%edx
801022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c3:	39 c2                	cmp    %eax,%edx
801022c5:	77 ba                	ja     80102281 <dirlink+0x43>
801022c7:	eb 01                	jmp    801022ca <dirlink+0x8c>
      break;
801022c9:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801022ca:	83 ec 04             	sub    $0x4,%esp
801022cd:	6a 0e                	push   $0xe
801022cf:	ff 75 0c             	pushl  0xc(%ebp)
801022d2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022d5:	83 c0 02             	add    $0x2,%eax
801022d8:	50                   	push   %eax
801022d9:	e8 0b 31 00 00       	call   801053e9 <strncpy>
801022de:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801022e1:	8b 45 10             	mov    0x10(%ebp),%eax
801022e4:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022eb:	6a 10                	push   $0x10
801022ed:	50                   	push   %eax
801022ee:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022f1:	50                   	push   %eax
801022f2:	ff 75 08             	pushl  0x8(%ebp)
801022f5:	e8 e9 fc ff ff       	call   80101fe3 <writei>
801022fa:	83 c4 10             	add    $0x10,%esp
801022fd:	83 f8 10             	cmp    $0x10,%eax
80102300:	74 0d                	je     8010230f <dirlink+0xd1>
    panic("dirlink");
80102302:	83 ec 0c             	sub    $0xc,%esp
80102305:	68 f8 86 10 80       	push   $0x801086f8
8010230a:	e8 6c e2 ff ff       	call   8010057b <panic>
  
  return 0;
8010230f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102314:	c9                   	leave  
80102315:	c3                   	ret    

80102316 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102316:	55                   	push   %ebp
80102317:	89 e5                	mov    %esp,%ebp
80102319:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010231c:	eb 04                	jmp    80102322 <skipelem+0xc>
    path++;
8010231e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102322:	8b 45 08             	mov    0x8(%ebp),%eax
80102325:	0f b6 00             	movzbl (%eax),%eax
80102328:	3c 2f                	cmp    $0x2f,%al
8010232a:	74 f2                	je     8010231e <skipelem+0x8>
  if(*path == 0)
8010232c:	8b 45 08             	mov    0x8(%ebp),%eax
8010232f:	0f b6 00             	movzbl (%eax),%eax
80102332:	84 c0                	test   %al,%al
80102334:	75 07                	jne    8010233d <skipelem+0x27>
    return 0;
80102336:	b8 00 00 00 00       	mov    $0x0,%eax
8010233b:	eb 77                	jmp    801023b4 <skipelem+0x9e>
  s = path;
8010233d:	8b 45 08             	mov    0x8(%ebp),%eax
80102340:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102343:	eb 04                	jmp    80102349 <skipelem+0x33>
    path++;
80102345:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
80102349:	8b 45 08             	mov    0x8(%ebp),%eax
8010234c:	0f b6 00             	movzbl (%eax),%eax
8010234f:	3c 2f                	cmp    $0x2f,%al
80102351:	74 0a                	je     8010235d <skipelem+0x47>
80102353:	8b 45 08             	mov    0x8(%ebp),%eax
80102356:	0f b6 00             	movzbl (%eax),%eax
80102359:	84 c0                	test   %al,%al
8010235b:	75 e8                	jne    80102345 <skipelem+0x2f>
  len = path - s;
8010235d:	8b 45 08             	mov    0x8(%ebp),%eax
80102360:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102363:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102366:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010236a:	7e 15                	jle    80102381 <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
8010236c:	83 ec 04             	sub    $0x4,%esp
8010236f:	6a 0e                	push   $0xe
80102371:	ff 75 f4             	pushl  -0xc(%ebp)
80102374:	ff 75 0c             	pushl  0xc(%ebp)
80102377:	e8 81 2f 00 00       	call   801052fd <memmove>
8010237c:	83 c4 10             	add    $0x10,%esp
8010237f:	eb 26                	jmp    801023a7 <skipelem+0x91>
  else {
    memmove(name, s, len);
80102381:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102384:	83 ec 04             	sub    $0x4,%esp
80102387:	50                   	push   %eax
80102388:	ff 75 f4             	pushl  -0xc(%ebp)
8010238b:	ff 75 0c             	pushl  0xc(%ebp)
8010238e:	e8 6a 2f 00 00       	call   801052fd <memmove>
80102393:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102396:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102399:	8b 45 0c             	mov    0xc(%ebp),%eax
8010239c:	01 d0                	add    %edx,%eax
8010239e:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023a1:	eb 04                	jmp    801023a7 <skipelem+0x91>
    path++;
801023a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801023a7:	8b 45 08             	mov    0x8(%ebp),%eax
801023aa:	0f b6 00             	movzbl (%eax),%eax
801023ad:	3c 2f                	cmp    $0x2f,%al
801023af:	74 f2                	je     801023a3 <skipelem+0x8d>
  return path;
801023b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023b4:	c9                   	leave  
801023b5:	c3                   	ret    

801023b6 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023b6:	55                   	push   %ebp
801023b7:	89 e5                	mov    %esp,%ebp
801023b9:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023bc:	8b 45 08             	mov    0x8(%ebp),%eax
801023bf:	0f b6 00             	movzbl (%eax),%eax
801023c2:	3c 2f                	cmp    $0x2f,%al
801023c4:	75 17                	jne    801023dd <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801023c6:	83 ec 08             	sub    $0x8,%esp
801023c9:	6a 01                	push   $0x1
801023cb:	6a 01                	push   $0x1
801023cd:	e8 40 f4 ff ff       	call   80101812 <iget>
801023d2:	83 c4 10             	add    $0x10,%esp
801023d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023d8:	e9 bb 00 00 00       	jmp    80102498 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801023dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023e3:	8b 40 68             	mov    0x68(%eax),%eax
801023e6:	83 ec 0c             	sub    $0xc,%esp
801023e9:	50                   	push   %eax
801023ea:	e8 02 f5 ff ff       	call   801018f1 <idup>
801023ef:	83 c4 10             	add    $0x10,%esp
801023f2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023f5:	e9 9e 00 00 00       	jmp    80102498 <namex+0xe2>
    ilock(ip);
801023fa:	83 ec 0c             	sub    $0xc,%esp
801023fd:	ff 75 f4             	pushl  -0xc(%ebp)
80102400:	e8 26 f5 ff ff       	call   8010192b <ilock>
80102405:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102408:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010240b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010240f:	66 83 f8 01          	cmp    $0x1,%ax
80102413:	74 18                	je     8010242d <namex+0x77>
      iunlockput(ip);
80102415:	83 ec 0c             	sub    $0xc,%esp
80102418:	ff 75 f4             	pushl  -0xc(%ebp)
8010241b:	e8 c5 f7 ff ff       	call   80101be5 <iunlockput>
80102420:	83 c4 10             	add    $0x10,%esp
      return 0;
80102423:	b8 00 00 00 00       	mov    $0x0,%eax
80102428:	e9 a7 00 00 00       	jmp    801024d4 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
8010242d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102431:	74 20                	je     80102453 <namex+0x9d>
80102433:	8b 45 08             	mov    0x8(%ebp),%eax
80102436:	0f b6 00             	movzbl (%eax),%eax
80102439:	84 c0                	test   %al,%al
8010243b:	75 16                	jne    80102453 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
8010243d:	83 ec 0c             	sub    $0xc,%esp
80102440:	ff 75 f4             	pushl  -0xc(%ebp)
80102443:	e8 3b f6 ff ff       	call   80101a83 <iunlock>
80102448:	83 c4 10             	add    $0x10,%esp
      return ip;
8010244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010244e:	e9 81 00 00 00       	jmp    801024d4 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102453:	83 ec 04             	sub    $0x4,%esp
80102456:	6a 00                	push   $0x0
80102458:	ff 75 10             	pushl  0x10(%ebp)
8010245b:	ff 75 f4             	pushl  -0xc(%ebp)
8010245e:	e8 21 fd ff ff       	call   80102184 <dirlookup>
80102463:	83 c4 10             	add    $0x10,%esp
80102466:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102469:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010246d:	75 15                	jne    80102484 <namex+0xce>
      iunlockput(ip);
8010246f:	83 ec 0c             	sub    $0xc,%esp
80102472:	ff 75 f4             	pushl  -0xc(%ebp)
80102475:	e8 6b f7 ff ff       	call   80101be5 <iunlockput>
8010247a:	83 c4 10             	add    $0x10,%esp
      return 0;
8010247d:	b8 00 00 00 00       	mov    $0x0,%eax
80102482:	eb 50                	jmp    801024d4 <namex+0x11e>
    }
    iunlockput(ip);
80102484:	83 ec 0c             	sub    $0xc,%esp
80102487:	ff 75 f4             	pushl  -0xc(%ebp)
8010248a:	e8 56 f7 ff ff       	call   80101be5 <iunlockput>
8010248f:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102492:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102495:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
80102498:	83 ec 08             	sub    $0x8,%esp
8010249b:	ff 75 10             	pushl  0x10(%ebp)
8010249e:	ff 75 08             	pushl  0x8(%ebp)
801024a1:	e8 70 fe ff ff       	call   80102316 <skipelem>
801024a6:	83 c4 10             	add    $0x10,%esp
801024a9:	89 45 08             	mov    %eax,0x8(%ebp)
801024ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024b0:	0f 85 44 ff ff ff    	jne    801023fa <namex+0x44>
  }
  if(nameiparent){
801024b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024ba:	74 15                	je     801024d1 <namex+0x11b>
    iput(ip);
801024bc:	83 ec 0c             	sub    $0xc,%esp
801024bf:	ff 75 f4             	pushl  -0xc(%ebp)
801024c2:	e8 2e f6 ff ff       	call   80101af5 <iput>
801024c7:	83 c4 10             	add    $0x10,%esp
    return 0;
801024ca:	b8 00 00 00 00       	mov    $0x0,%eax
801024cf:	eb 03                	jmp    801024d4 <namex+0x11e>
  }
  return ip;
801024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801024d4:	c9                   	leave  
801024d5:	c3                   	ret    

801024d6 <namei>:

struct inode*
namei(char *path)
{
801024d6:	55                   	push   %ebp
801024d7:	89 e5                	mov    %esp,%ebp
801024d9:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024dc:	83 ec 04             	sub    $0x4,%esp
801024df:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024e2:	50                   	push   %eax
801024e3:	6a 00                	push   $0x0
801024e5:	ff 75 08             	pushl  0x8(%ebp)
801024e8:	e8 c9 fe ff ff       	call   801023b6 <namex>
801024ed:	83 c4 10             	add    $0x10,%esp
}
801024f0:	c9                   	leave  
801024f1:	c3                   	ret    

801024f2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024f2:	55                   	push   %ebp
801024f3:	89 e5                	mov    %esp,%ebp
801024f5:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801024f8:	83 ec 04             	sub    $0x4,%esp
801024fb:	ff 75 0c             	pushl  0xc(%ebp)
801024fe:	6a 01                	push   $0x1
80102500:	ff 75 08             	pushl  0x8(%ebp)
80102503:	e8 ae fe ff ff       	call   801023b6 <namex>
80102508:	83 c4 10             	add    $0x10,%esp
}
8010250b:	c9                   	leave  
8010250c:	c3                   	ret    

8010250d <inb>:
{
8010250d:	55                   	push   %ebp
8010250e:	89 e5                	mov    %esp,%ebp
80102510:	83 ec 14             	sub    $0x14,%esp
80102513:	8b 45 08             	mov    0x8(%ebp),%eax
80102516:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010251a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010251e:	89 c2                	mov    %eax,%edx
80102520:	ec                   	in     (%dx),%al
80102521:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102524:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102528:	c9                   	leave  
80102529:	c3                   	ret    

8010252a <insl>:
{
8010252a:	55                   	push   %ebp
8010252b:	89 e5                	mov    %esp,%ebp
8010252d:	57                   	push   %edi
8010252e:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010252f:	8b 55 08             	mov    0x8(%ebp),%edx
80102532:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102535:	8b 45 10             	mov    0x10(%ebp),%eax
80102538:	89 cb                	mov    %ecx,%ebx
8010253a:	89 df                	mov    %ebx,%edi
8010253c:	89 c1                	mov    %eax,%ecx
8010253e:	fc                   	cld    
8010253f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102541:	89 c8                	mov    %ecx,%eax
80102543:	89 fb                	mov    %edi,%ebx
80102545:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102548:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010254b:	90                   	nop
8010254c:	5b                   	pop    %ebx
8010254d:	5f                   	pop    %edi
8010254e:	5d                   	pop    %ebp
8010254f:	c3                   	ret    

80102550 <outb>:
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	83 ec 08             	sub    $0x8,%esp
80102556:	8b 45 08             	mov    0x8(%ebp),%eax
80102559:	8b 55 0c             	mov    0xc(%ebp),%edx
8010255c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102560:	89 d0                	mov    %edx,%eax
80102562:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102565:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102569:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010256d:	ee                   	out    %al,(%dx)
}
8010256e:	90                   	nop
8010256f:	c9                   	leave  
80102570:	c3                   	ret    

80102571 <outsl>:
{
80102571:	55                   	push   %ebp
80102572:	89 e5                	mov    %esp,%ebp
80102574:	56                   	push   %esi
80102575:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102576:	8b 55 08             	mov    0x8(%ebp),%edx
80102579:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010257c:	8b 45 10             	mov    0x10(%ebp),%eax
8010257f:	89 cb                	mov    %ecx,%ebx
80102581:	89 de                	mov    %ebx,%esi
80102583:	89 c1                	mov    %eax,%ecx
80102585:	fc                   	cld    
80102586:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102588:	89 c8                	mov    %ecx,%eax
8010258a:	89 f3                	mov    %esi,%ebx
8010258c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010258f:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102592:	90                   	nop
80102593:	5b                   	pop    %ebx
80102594:	5e                   	pop    %esi
80102595:	5d                   	pop    %ebp
80102596:	c3                   	ret    

80102597 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102597:	55                   	push   %ebp
80102598:	89 e5                	mov    %esp,%ebp
8010259a:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010259d:	90                   	nop
8010259e:	68 f7 01 00 00       	push   $0x1f7
801025a3:	e8 65 ff ff ff       	call   8010250d <inb>
801025a8:	83 c4 04             	add    $0x4,%esp
801025ab:	0f b6 c0             	movzbl %al,%eax
801025ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
801025b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025b4:	25 c0 00 00 00       	and    $0xc0,%eax
801025b9:	83 f8 40             	cmp    $0x40,%eax
801025bc:	75 e0                	jne    8010259e <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025c2:	74 11                	je     801025d5 <idewait+0x3e>
801025c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025c7:	83 e0 21             	and    $0x21,%eax
801025ca:	85 c0                	test   %eax,%eax
801025cc:	74 07                	je     801025d5 <idewait+0x3e>
    return -1;
801025ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025d3:	eb 05                	jmp    801025da <idewait+0x43>
  return 0;
801025d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025da:	c9                   	leave  
801025db:	c3                   	ret    

801025dc <ideinit>:

void
ideinit(void)
{
801025dc:	55                   	push   %ebp
801025dd:	89 e5                	mov    %esp,%ebp
801025df:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
801025e2:	83 ec 08             	sub    $0x8,%esp
801025e5:	68 00 87 10 80       	push   $0x80108700
801025ea:	68 00 e8 10 80       	push   $0x8010e800
801025ef:	e8 c5 29 00 00       	call   80104fb9 <initlock>
801025f4:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801025f7:	83 ec 0c             	sub    $0xc,%esp
801025fa:	6a 0e                	push   $0xe
801025fc:	e8 87 15 00 00       	call   80103b88 <picenable>
80102601:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102604:	a1 04 ef 10 80       	mov    0x8010ef04,%eax
80102609:	83 e8 01             	sub    $0x1,%eax
8010260c:	83 ec 08             	sub    $0x8,%esp
8010260f:	50                   	push   %eax
80102610:	6a 0e                	push   $0xe
80102612:	e8 37 04 00 00       	call   80102a4e <ioapicenable>
80102617:	83 c4 10             	add    $0x10,%esp
  idewait(0);
8010261a:	83 ec 0c             	sub    $0xc,%esp
8010261d:	6a 00                	push   $0x0
8010261f:	e8 73 ff ff ff       	call   80102597 <idewait>
80102624:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102627:	83 ec 08             	sub    $0x8,%esp
8010262a:	68 f0 00 00 00       	push   $0xf0
8010262f:	68 f6 01 00 00       	push   $0x1f6
80102634:	e8 17 ff ff ff       	call   80102550 <outb>
80102639:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
8010263c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102643:	eb 24                	jmp    80102669 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102645:	83 ec 0c             	sub    $0xc,%esp
80102648:	68 f7 01 00 00       	push   $0x1f7
8010264d:	e8 bb fe ff ff       	call   8010250d <inb>
80102652:	83 c4 10             	add    $0x10,%esp
80102655:	84 c0                	test   %al,%al
80102657:	74 0c                	je     80102665 <ideinit+0x89>
      havedisk1 = 1;
80102659:	c7 05 38 e8 10 80 01 	movl   $0x1,0x8010e838
80102660:	00 00 00 
      break;
80102663:	eb 0d                	jmp    80102672 <ideinit+0x96>
  for(i=0; i<1000; i++){
80102665:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102669:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102670:	7e d3                	jle    80102645 <ideinit+0x69>
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102672:	83 ec 08             	sub    $0x8,%esp
80102675:	68 e0 00 00 00       	push   $0xe0
8010267a:	68 f6 01 00 00       	push   $0x1f6
8010267f:	e8 cc fe ff ff       	call   80102550 <outb>
80102684:	83 c4 10             	add    $0x10,%esp
}
80102687:	90                   	nop
80102688:	c9                   	leave  
80102689:	c3                   	ret    

8010268a <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010268a:	55                   	push   %ebp
8010268b:	89 e5                	mov    %esp,%ebp
8010268d:	83 ec 08             	sub    $0x8,%esp
  if(b == 0)
80102690:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102694:	75 0d                	jne    801026a3 <idestart+0x19>
    panic("idestart");
80102696:	83 ec 0c             	sub    $0xc,%esp
80102699:	68 04 87 10 80       	push   $0x80108704
8010269e:	e8 d8 de ff ff       	call   8010057b <panic>

  idewait(0);
801026a3:	83 ec 0c             	sub    $0xc,%esp
801026a6:	6a 00                	push   $0x0
801026a8:	e8 ea fe ff ff       	call   80102597 <idewait>
801026ad:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801026b0:	83 ec 08             	sub    $0x8,%esp
801026b3:	6a 00                	push   $0x0
801026b5:	68 f6 03 00 00       	push   $0x3f6
801026ba:	e8 91 fe ff ff       	call   80102550 <outb>
801026bf:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, 1);  // number of sectors
801026c2:	83 ec 08             	sub    $0x8,%esp
801026c5:	6a 01                	push   $0x1
801026c7:	68 f2 01 00 00       	push   $0x1f2
801026cc:	e8 7f fe ff ff       	call   80102550 <outb>
801026d1:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, b->sector & 0xff);
801026d4:	8b 45 08             	mov    0x8(%ebp),%eax
801026d7:	8b 40 08             	mov    0x8(%eax),%eax
801026da:	0f b6 c0             	movzbl %al,%eax
801026dd:	83 ec 08             	sub    $0x8,%esp
801026e0:	50                   	push   %eax
801026e1:	68 f3 01 00 00       	push   $0x1f3
801026e6:	e8 65 fe ff ff       	call   80102550 <outb>
801026eb:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (b->sector >> 8) & 0xff);
801026ee:	8b 45 08             	mov    0x8(%ebp),%eax
801026f1:	8b 40 08             	mov    0x8(%eax),%eax
801026f4:	c1 e8 08             	shr    $0x8,%eax
801026f7:	0f b6 c0             	movzbl %al,%eax
801026fa:	83 ec 08             	sub    $0x8,%esp
801026fd:	50                   	push   %eax
801026fe:	68 f4 01 00 00       	push   $0x1f4
80102703:	e8 48 fe ff ff       	call   80102550 <outb>
80102708:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010270b:	8b 45 08             	mov    0x8(%ebp),%eax
8010270e:	8b 40 08             	mov    0x8(%eax),%eax
80102711:	c1 e8 10             	shr    $0x10,%eax
80102714:	0f b6 c0             	movzbl %al,%eax
80102717:	83 ec 08             	sub    $0x8,%esp
8010271a:	50                   	push   %eax
8010271b:	68 f5 01 00 00       	push   $0x1f5
80102720:	e8 2b fe ff ff       	call   80102550 <outb>
80102725:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102728:	8b 45 08             	mov    0x8(%ebp),%eax
8010272b:	8b 40 04             	mov    0x4(%eax),%eax
8010272e:	c1 e0 04             	shl    $0x4,%eax
80102731:	83 e0 10             	and    $0x10,%eax
80102734:	89 c2                	mov    %eax,%edx
80102736:	8b 45 08             	mov    0x8(%ebp),%eax
80102739:	8b 40 08             	mov    0x8(%eax),%eax
8010273c:	c1 e8 18             	shr    $0x18,%eax
8010273f:	83 e0 0f             	and    $0xf,%eax
80102742:	09 d0                	or     %edx,%eax
80102744:	83 c8 e0             	or     $0xffffffe0,%eax
80102747:	0f b6 c0             	movzbl %al,%eax
8010274a:	83 ec 08             	sub    $0x8,%esp
8010274d:	50                   	push   %eax
8010274e:	68 f6 01 00 00       	push   $0x1f6
80102753:	e8 f8 fd ff ff       	call   80102550 <outb>
80102758:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010275b:	8b 45 08             	mov    0x8(%ebp),%eax
8010275e:	8b 00                	mov    (%eax),%eax
80102760:	83 e0 04             	and    $0x4,%eax
80102763:	85 c0                	test   %eax,%eax
80102765:	74 30                	je     80102797 <idestart+0x10d>
    outb(0x1f7, IDE_CMD_WRITE);
80102767:	83 ec 08             	sub    $0x8,%esp
8010276a:	6a 30                	push   $0x30
8010276c:	68 f7 01 00 00       	push   $0x1f7
80102771:	e8 da fd ff ff       	call   80102550 <outb>
80102776:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, 512/4);
80102779:	8b 45 08             	mov    0x8(%ebp),%eax
8010277c:	83 c0 18             	add    $0x18,%eax
8010277f:	83 ec 04             	sub    $0x4,%esp
80102782:	68 80 00 00 00       	push   $0x80
80102787:	50                   	push   %eax
80102788:	68 f0 01 00 00       	push   $0x1f0
8010278d:	e8 df fd ff ff       	call   80102571 <outsl>
80102792:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102795:	eb 12                	jmp    801027a9 <idestart+0x11f>
    outb(0x1f7, IDE_CMD_READ);
80102797:	83 ec 08             	sub    $0x8,%esp
8010279a:	6a 20                	push   $0x20
8010279c:	68 f7 01 00 00       	push   $0x1f7
801027a1:	e8 aa fd ff ff       	call   80102550 <outb>
801027a6:	83 c4 10             	add    $0x10,%esp
}
801027a9:	90                   	nop
801027aa:	c9                   	leave  
801027ab:	c3                   	ret    

801027ac <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027ac:	55                   	push   %ebp
801027ad:	89 e5                	mov    %esp,%ebp
801027af:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027b2:	83 ec 0c             	sub    $0xc,%esp
801027b5:	68 00 e8 10 80       	push   $0x8010e800
801027ba:	e8 1c 28 00 00       	call   80104fdb <acquire>
801027bf:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801027c2:	a1 34 e8 10 80       	mov    0x8010e834,%eax
801027c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027ce:	75 15                	jne    801027e5 <ideintr+0x39>
    release(&idelock);
801027d0:	83 ec 0c             	sub    $0xc,%esp
801027d3:	68 00 e8 10 80       	push   $0x8010e800
801027d8:	e8 65 28 00 00       	call   80105042 <release>
801027dd:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801027e0:	e9 9a 00 00 00       	jmp    8010287f <ideintr+0xd3>
  }
  idequeue = b->qnext;
801027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027e8:	8b 40 14             	mov    0x14(%eax),%eax
801027eb:	a3 34 e8 10 80       	mov    %eax,0x8010e834

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f3:	8b 00                	mov    (%eax),%eax
801027f5:	83 e0 04             	and    $0x4,%eax
801027f8:	85 c0                	test   %eax,%eax
801027fa:	75 2d                	jne    80102829 <ideintr+0x7d>
801027fc:	83 ec 0c             	sub    $0xc,%esp
801027ff:	6a 01                	push   $0x1
80102801:	e8 91 fd ff ff       	call   80102597 <idewait>
80102806:	83 c4 10             	add    $0x10,%esp
80102809:	85 c0                	test   %eax,%eax
8010280b:	78 1c                	js     80102829 <ideintr+0x7d>
    insl(0x1f0, b->data, 512/4);
8010280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102810:	83 c0 18             	add    $0x18,%eax
80102813:	83 ec 04             	sub    $0x4,%esp
80102816:	68 80 00 00 00       	push   $0x80
8010281b:	50                   	push   %eax
8010281c:	68 f0 01 00 00       	push   $0x1f0
80102821:	e8 04 fd ff ff       	call   8010252a <insl>
80102826:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282c:	8b 00                	mov    (%eax),%eax
8010282e:	83 c8 02             	or     $0x2,%eax
80102831:	89 c2                	mov    %eax,%edx
80102833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102836:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010283b:	8b 00                	mov    (%eax),%eax
8010283d:	83 e0 fb             	and    $0xfffffffb,%eax
80102840:	89 c2                	mov    %eax,%edx
80102842:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102845:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102847:	83 ec 0c             	sub    $0xc,%esp
8010284a:	ff 75 f4             	pushl  -0xc(%ebp)
8010284d:	e8 59 22 00 00       	call   80104aab <wakeup>
80102852:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102855:	a1 34 e8 10 80       	mov    0x8010e834,%eax
8010285a:	85 c0                	test   %eax,%eax
8010285c:	74 11                	je     8010286f <ideintr+0xc3>
    idestart(idequeue);
8010285e:	a1 34 e8 10 80       	mov    0x8010e834,%eax
80102863:	83 ec 0c             	sub    $0xc,%esp
80102866:	50                   	push   %eax
80102867:	e8 1e fe ff ff       	call   8010268a <idestart>
8010286c:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
8010286f:	83 ec 0c             	sub    $0xc,%esp
80102872:	68 00 e8 10 80       	push   $0x8010e800
80102877:	e8 c6 27 00 00       	call   80105042 <release>
8010287c:	83 c4 10             	add    $0x10,%esp
}
8010287f:	c9                   	leave  
80102880:	c3                   	ret    

80102881 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102881:	55                   	push   %ebp
80102882:	89 e5                	mov    %esp,%ebp
80102884:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102887:	8b 45 08             	mov    0x8(%ebp),%eax
8010288a:	8b 00                	mov    (%eax),%eax
8010288c:	83 e0 01             	and    $0x1,%eax
8010288f:	85 c0                	test   %eax,%eax
80102891:	75 0d                	jne    801028a0 <iderw+0x1f>
    panic("iderw: buf not busy");
80102893:	83 ec 0c             	sub    $0xc,%esp
80102896:	68 0d 87 10 80       	push   $0x8010870d
8010289b:	e8 db dc ff ff       	call   8010057b <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801028a0:	8b 45 08             	mov    0x8(%ebp),%eax
801028a3:	8b 00                	mov    (%eax),%eax
801028a5:	83 e0 06             	and    $0x6,%eax
801028a8:	83 f8 02             	cmp    $0x2,%eax
801028ab:	75 0d                	jne    801028ba <iderw+0x39>
    panic("iderw: nothing to do");
801028ad:	83 ec 0c             	sub    $0xc,%esp
801028b0:	68 21 87 10 80       	push   $0x80108721
801028b5:	e8 c1 dc ff ff       	call   8010057b <panic>
  if(b->dev != 0 && !havedisk1)
801028ba:	8b 45 08             	mov    0x8(%ebp),%eax
801028bd:	8b 40 04             	mov    0x4(%eax),%eax
801028c0:	85 c0                	test   %eax,%eax
801028c2:	74 16                	je     801028da <iderw+0x59>
801028c4:	a1 38 e8 10 80       	mov    0x8010e838,%eax
801028c9:	85 c0                	test   %eax,%eax
801028cb:	75 0d                	jne    801028da <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801028cd:	83 ec 0c             	sub    $0xc,%esp
801028d0:	68 36 87 10 80       	push   $0x80108736
801028d5:	e8 a1 dc ff ff       	call   8010057b <panic>

  acquire(&idelock);  //DOC: acquire-lock
801028da:	83 ec 0c             	sub    $0xc,%esp
801028dd:	68 00 e8 10 80       	push   $0x8010e800
801028e2:	e8 f4 26 00 00       	call   80104fdb <acquire>
801028e7:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801028ea:	8b 45 08             	mov    0x8(%ebp),%eax
801028ed:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC: insert-queue
801028f4:	c7 45 f4 34 e8 10 80 	movl   $0x8010e834,-0xc(%ebp)
801028fb:	eb 0b                	jmp    80102908 <iderw+0x87>
801028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102900:	8b 00                	mov    (%eax),%eax
80102902:	83 c0 14             	add    $0x14,%eax
80102905:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010290b:	8b 00                	mov    (%eax),%eax
8010290d:	85 c0                	test   %eax,%eax
8010290f:	75 ec                	jne    801028fd <iderw+0x7c>
    ;
  *pp = b;
80102911:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102914:	8b 55 08             	mov    0x8(%ebp),%edx
80102917:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102919:	a1 34 e8 10 80       	mov    0x8010e834,%eax
8010291e:	39 45 08             	cmp    %eax,0x8(%ebp)
80102921:	75 23                	jne    80102946 <iderw+0xc5>
    idestart(b);
80102923:	83 ec 0c             	sub    $0xc,%esp
80102926:	ff 75 08             	pushl  0x8(%ebp)
80102929:	e8 5c fd ff ff       	call   8010268a <idestart>
8010292e:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102931:	eb 13                	jmp    80102946 <iderw+0xc5>
    sleep(b, &idelock);
80102933:	83 ec 08             	sub    $0x8,%esp
80102936:	68 00 e8 10 80       	push   $0x8010e800
8010293b:	ff 75 08             	pushl  0x8(%ebp)
8010293e:	e8 79 20 00 00       	call   801049bc <sleep>
80102943:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102946:	8b 45 08             	mov    0x8(%ebp),%eax
80102949:	8b 00                	mov    (%eax),%eax
8010294b:	83 e0 06             	and    $0x6,%eax
8010294e:	83 f8 02             	cmp    $0x2,%eax
80102951:	75 e0                	jne    80102933 <iderw+0xb2>
  }

  release(&idelock);
80102953:	83 ec 0c             	sub    $0xc,%esp
80102956:	68 00 e8 10 80       	push   $0x8010e800
8010295b:	e8 e2 26 00 00       	call   80105042 <release>
80102960:	83 c4 10             	add    $0x10,%esp
}
80102963:	90                   	nop
80102964:	c9                   	leave  
80102965:	c3                   	ret    

80102966 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102966:	55                   	push   %ebp
80102967:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102969:	a1 3c e8 10 80       	mov    0x8010e83c,%eax
8010296e:	8b 55 08             	mov    0x8(%ebp),%edx
80102971:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102973:	a1 3c e8 10 80       	mov    0x8010e83c,%eax
80102978:	8b 40 10             	mov    0x10(%eax),%eax
}
8010297b:	5d                   	pop    %ebp
8010297c:	c3                   	ret    

8010297d <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
8010297d:	55                   	push   %ebp
8010297e:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102980:	a1 3c e8 10 80       	mov    0x8010e83c,%eax
80102985:	8b 55 08             	mov    0x8(%ebp),%edx
80102988:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010298a:	a1 3c e8 10 80       	mov    0x8010e83c,%eax
8010298f:	8b 55 0c             	mov    0xc(%ebp),%edx
80102992:	89 50 10             	mov    %edx,0x10(%eax)
}
80102995:	90                   	nop
80102996:	5d                   	pop    %ebp
80102997:	c3                   	ret    

80102998 <ioapicinit>:

void
ioapicinit(void)
{
80102998:	55                   	push   %ebp
80102999:	89 e5                	mov    %esp,%ebp
8010299b:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
8010299e:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801029a3:	85 c0                	test   %eax,%eax
801029a5:	0f 84 a0 00 00 00    	je     80102a4b <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801029ab:	c7 05 3c e8 10 80 00 	movl   $0xfec00000,0x8010e83c
801029b2:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029b5:	6a 01                	push   $0x1
801029b7:	e8 aa ff ff ff       	call   80102966 <ioapicread>
801029bc:	83 c4 04             	add    $0x4,%esp
801029bf:	c1 e8 10             	shr    $0x10,%eax
801029c2:	25 ff 00 00 00       	and    $0xff,%eax
801029c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801029ca:	6a 00                	push   $0x0
801029cc:	e8 95 ff ff ff       	call   80102966 <ioapicread>
801029d1:	83 c4 04             	add    $0x4,%esp
801029d4:	c1 e8 18             	shr    $0x18,%eax
801029d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801029da:	0f b6 05 08 ef 10 80 	movzbl 0x8010ef08,%eax
801029e1:	0f b6 c0             	movzbl %al,%eax
801029e4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801029e7:	74 10                	je     801029f9 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029e9:	83 ec 0c             	sub    $0xc,%esp
801029ec:	68 54 87 10 80       	push   $0x80108754
801029f1:	e8 d0 d9 ff ff       	call   801003c6 <cprintf>
801029f6:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a00:	eb 3f                	jmp    80102a41 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a05:	83 c0 20             	add    $0x20,%eax
80102a08:	0d 00 00 01 00       	or     $0x10000,%eax
80102a0d:	89 c2                	mov    %eax,%edx
80102a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a12:	83 c0 08             	add    $0x8,%eax
80102a15:	01 c0                	add    %eax,%eax
80102a17:	83 ec 08             	sub    $0x8,%esp
80102a1a:	52                   	push   %edx
80102a1b:	50                   	push   %eax
80102a1c:	e8 5c ff ff ff       	call   8010297d <ioapicwrite>
80102a21:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a27:	83 c0 08             	add    $0x8,%eax
80102a2a:	01 c0                	add    %eax,%eax
80102a2c:	83 c0 01             	add    $0x1,%eax
80102a2f:	83 ec 08             	sub    $0x8,%esp
80102a32:	6a 00                	push   $0x0
80102a34:	50                   	push   %eax
80102a35:	e8 43 ff ff ff       	call   8010297d <ioapicwrite>
80102a3a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102a3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a47:	7e b9                	jle    80102a02 <ioapicinit+0x6a>
80102a49:	eb 01                	jmp    80102a4c <ioapicinit+0xb4>
    return;
80102a4b:	90                   	nop
  }
}
80102a4c:	c9                   	leave  
80102a4d:	c3                   	ret    

80102a4e <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a4e:	55                   	push   %ebp
80102a4f:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102a51:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80102a56:	85 c0                	test   %eax,%eax
80102a58:	74 39                	je     80102a93 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a5d:	83 c0 20             	add    $0x20,%eax
80102a60:	89 c2                	mov    %eax,%edx
80102a62:	8b 45 08             	mov    0x8(%ebp),%eax
80102a65:	83 c0 08             	add    $0x8,%eax
80102a68:	01 c0                	add    %eax,%eax
80102a6a:	52                   	push   %edx
80102a6b:	50                   	push   %eax
80102a6c:	e8 0c ff ff ff       	call   8010297d <ioapicwrite>
80102a71:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a74:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a77:	c1 e0 18             	shl    $0x18,%eax
80102a7a:	89 c2                	mov    %eax,%edx
80102a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a7f:	83 c0 08             	add    $0x8,%eax
80102a82:	01 c0                	add    %eax,%eax
80102a84:	83 c0 01             	add    $0x1,%eax
80102a87:	52                   	push   %edx
80102a88:	50                   	push   %eax
80102a89:	e8 ef fe ff ff       	call   8010297d <ioapicwrite>
80102a8e:	83 c4 08             	add    $0x8,%esp
80102a91:	eb 01                	jmp    80102a94 <ioapicenable+0x46>
    return;
80102a93:	90                   	nop
}
80102a94:	c9                   	leave  
80102a95:	c3                   	ret    

80102a96 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a96:	55                   	push   %ebp
80102a97:	89 e5                	mov    %esp,%ebp
80102a99:	8b 45 08             	mov    0x8(%ebp),%eax
80102a9c:	05 00 00 00 80       	add    $0x80000000,%eax
80102aa1:	5d                   	pop    %ebp
80102aa2:	c3                   	ret    

80102aa3 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102aa3:	55                   	push   %ebp
80102aa4:	89 e5                	mov    %esp,%ebp
80102aa6:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102aa9:	83 ec 08             	sub    $0x8,%esp
80102aac:	68 86 87 10 80       	push   $0x80108786
80102ab1:	68 40 e8 10 80       	push   $0x8010e840
80102ab6:	e8 fe 24 00 00       	call   80104fb9 <initlock>
80102abb:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102abe:	c7 05 74 e8 10 80 00 	movl   $0x0,0x8010e874
80102ac5:	00 00 00 
  freerange(vstart, vend);
80102ac8:	83 ec 08             	sub    $0x8,%esp
80102acb:	ff 75 0c             	pushl  0xc(%ebp)
80102ace:	ff 75 08             	pushl  0x8(%ebp)
80102ad1:	e8 2a 00 00 00       	call   80102b00 <freerange>
80102ad6:	83 c4 10             	add    $0x10,%esp
}
80102ad9:	90                   	nop
80102ada:	c9                   	leave  
80102adb:	c3                   	ret    

80102adc <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102adc:	55                   	push   %ebp
80102add:	89 e5                	mov    %esp,%ebp
80102adf:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102ae2:	83 ec 08             	sub    $0x8,%esp
80102ae5:	ff 75 0c             	pushl  0xc(%ebp)
80102ae8:	ff 75 08             	pushl  0x8(%ebp)
80102aeb:	e8 10 00 00 00       	call   80102b00 <freerange>
80102af0:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102af3:	c7 05 74 e8 10 80 01 	movl   $0x1,0x8010e874
80102afa:	00 00 00 
}
80102afd:	90                   	nop
80102afe:	c9                   	leave  
80102aff:	c3                   	ret    

80102b00 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b06:	8b 45 08             	mov    0x8(%ebp),%eax
80102b09:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b0e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b16:	eb 15                	jmp    80102b2d <freerange+0x2d>
    kfree(p);
80102b18:	83 ec 0c             	sub    $0xc,%esp
80102b1b:	ff 75 f4             	pushl  -0xc(%ebp)
80102b1e:	e8 1b 00 00 00       	call   80102b3e <kfree>
80102b23:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b26:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b30:	05 00 10 00 00       	add    $0x1000,%eax
80102b35:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102b38:	73 de                	jae    80102b18 <freerange+0x18>
}
80102b3a:	90                   	nop
80102b3b:	90                   	nop
80102b3c:	c9                   	leave  
80102b3d:	c3                   	ret    

80102b3e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b3e:	55                   	push   %ebp
80102b3f:	89 e5                	mov    %esp,%ebp
80102b41:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b44:	8b 45 08             	mov    0x8(%ebp),%eax
80102b47:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b4c:	85 c0                	test   %eax,%eax
80102b4e:	75 1b                	jne    80102b6b <kfree+0x2d>
80102b50:	81 7d 08 e0 3b 11 80 	cmpl   $0x80113be0,0x8(%ebp)
80102b57:	72 12                	jb     80102b6b <kfree+0x2d>
80102b59:	ff 75 08             	pushl  0x8(%ebp)
80102b5c:	e8 35 ff ff ff       	call   80102a96 <v2p>
80102b61:	83 c4 04             	add    $0x4,%esp
80102b64:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b69:	76 0d                	jbe    80102b78 <kfree+0x3a>
    panic("kfree");
80102b6b:	83 ec 0c             	sub    $0xc,%esp
80102b6e:	68 8b 87 10 80       	push   $0x8010878b
80102b73:	e8 03 da ff ff       	call   8010057b <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b78:	83 ec 04             	sub    $0x4,%esp
80102b7b:	68 00 10 00 00       	push   $0x1000
80102b80:	6a 01                	push   $0x1
80102b82:	ff 75 08             	pushl  0x8(%ebp)
80102b85:	e8 b4 26 00 00       	call   8010523e <memset>
80102b8a:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102b8d:	a1 74 e8 10 80       	mov    0x8010e874,%eax
80102b92:	85 c0                	test   %eax,%eax
80102b94:	74 10                	je     80102ba6 <kfree+0x68>
    acquire(&kmem.lock);
80102b96:	83 ec 0c             	sub    $0xc,%esp
80102b99:	68 40 e8 10 80       	push   $0x8010e840
80102b9e:	e8 38 24 00 00       	call   80104fdb <acquire>
80102ba3:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102bac:	8b 15 78 e8 10 80    	mov    0x8010e878,%edx
80102bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bb5:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bba:	a3 78 e8 10 80       	mov    %eax,0x8010e878
  if(kmem.use_lock)
80102bbf:	a1 74 e8 10 80       	mov    0x8010e874,%eax
80102bc4:	85 c0                	test   %eax,%eax
80102bc6:	74 10                	je     80102bd8 <kfree+0x9a>
    release(&kmem.lock);
80102bc8:	83 ec 0c             	sub    $0xc,%esp
80102bcb:	68 40 e8 10 80       	push   $0x8010e840
80102bd0:	e8 6d 24 00 00       	call   80105042 <release>
80102bd5:	83 c4 10             	add    $0x10,%esp
}
80102bd8:	90                   	nop
80102bd9:	c9                   	leave  
80102bda:	c3                   	ret    

80102bdb <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102bdb:	55                   	push   %ebp
80102bdc:	89 e5                	mov    %esp,%ebp
80102bde:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102be1:	a1 74 e8 10 80       	mov    0x8010e874,%eax
80102be6:	85 c0                	test   %eax,%eax
80102be8:	74 10                	je     80102bfa <kalloc+0x1f>
    acquire(&kmem.lock);
80102bea:	83 ec 0c             	sub    $0xc,%esp
80102bed:	68 40 e8 10 80       	push   $0x8010e840
80102bf2:	e8 e4 23 00 00       	call   80104fdb <acquire>
80102bf7:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102bfa:	a1 78 e8 10 80       	mov    0x8010e878,%eax
80102bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c06:	74 0a                	je     80102c12 <kalloc+0x37>
    kmem.freelist = r->next;
80102c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c0b:	8b 00                	mov    (%eax),%eax
80102c0d:	a3 78 e8 10 80       	mov    %eax,0x8010e878
  if(kmem.use_lock)
80102c12:	a1 74 e8 10 80       	mov    0x8010e874,%eax
80102c17:	85 c0                	test   %eax,%eax
80102c19:	74 10                	je     80102c2b <kalloc+0x50>
    release(&kmem.lock);
80102c1b:	83 ec 0c             	sub    $0xc,%esp
80102c1e:	68 40 e8 10 80       	push   $0x8010e840
80102c23:	e8 1a 24 00 00       	call   80105042 <release>
80102c28:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c2e:	c9                   	leave  
80102c2f:	c3                   	ret    

80102c30 <inb>:
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	83 ec 14             	sub    $0x14,%esp
80102c36:	8b 45 08             	mov    0x8(%ebp),%eax
80102c39:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c41:	89 c2                	mov    %eax,%edx
80102c43:	ec                   	in     (%dx),%al
80102c44:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c47:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c4b:	c9                   	leave  
80102c4c:	c3                   	ret    

80102c4d <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c4d:	55                   	push   %ebp
80102c4e:	89 e5                	mov    %esp,%ebp
80102c50:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c53:	6a 64                	push   $0x64
80102c55:	e8 d6 ff ff ff       	call   80102c30 <inb>
80102c5a:	83 c4 04             	add    $0x4,%esp
80102c5d:	0f b6 c0             	movzbl %al,%eax
80102c60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c66:	83 e0 01             	and    $0x1,%eax
80102c69:	85 c0                	test   %eax,%eax
80102c6b:	75 0a                	jne    80102c77 <kbdgetc+0x2a>
    return -1;
80102c6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c72:	e9 23 01 00 00       	jmp    80102d9a <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102c77:	6a 60                	push   $0x60
80102c79:	e8 b2 ff ff ff       	call   80102c30 <inb>
80102c7e:	83 c4 04             	add    $0x4,%esp
80102c81:	0f b6 c0             	movzbl %al,%eax
80102c84:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c87:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c8e:	75 17                	jne    80102ca7 <kbdgetc+0x5a>
    shift |= E0ESC;
80102c90:	a1 7c e8 10 80       	mov    0x8010e87c,%eax
80102c95:	83 c8 40             	or     $0x40,%eax
80102c98:	a3 7c e8 10 80       	mov    %eax,0x8010e87c
    return 0;
80102c9d:	b8 00 00 00 00       	mov    $0x0,%eax
80102ca2:	e9 f3 00 00 00       	jmp    80102d9a <kbdgetc+0x14d>
  } else if(data & 0x80){
80102ca7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102caa:	25 80 00 00 00       	and    $0x80,%eax
80102caf:	85 c0                	test   %eax,%eax
80102cb1:	74 45                	je     80102cf8 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102cb3:	a1 7c e8 10 80       	mov    0x8010e87c,%eax
80102cb8:	83 e0 40             	and    $0x40,%eax
80102cbb:	85 c0                	test   %eax,%eax
80102cbd:	75 08                	jne    80102cc7 <kbdgetc+0x7a>
80102cbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cc2:	83 e0 7f             	and    $0x7f,%eax
80102cc5:	eb 03                	jmp    80102cca <kbdgetc+0x7d>
80102cc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cca:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102ccd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cd0:	05 20 90 10 80       	add    $0x80109020,%eax
80102cd5:	0f b6 00             	movzbl (%eax),%eax
80102cd8:	83 c8 40             	or     $0x40,%eax
80102cdb:	0f b6 c0             	movzbl %al,%eax
80102cde:	f7 d0                	not    %eax
80102ce0:	89 c2                	mov    %eax,%edx
80102ce2:	a1 7c e8 10 80       	mov    0x8010e87c,%eax
80102ce7:	21 d0                	and    %edx,%eax
80102ce9:	a3 7c e8 10 80       	mov    %eax,0x8010e87c
    return 0;
80102cee:	b8 00 00 00 00       	mov    $0x0,%eax
80102cf3:	e9 a2 00 00 00       	jmp    80102d9a <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102cf8:	a1 7c e8 10 80       	mov    0x8010e87c,%eax
80102cfd:	83 e0 40             	and    $0x40,%eax
80102d00:	85 c0                	test   %eax,%eax
80102d02:	74 14                	je     80102d18 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d04:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d0b:	a1 7c e8 10 80       	mov    0x8010e87c,%eax
80102d10:	83 e0 bf             	and    $0xffffffbf,%eax
80102d13:	a3 7c e8 10 80       	mov    %eax,0x8010e87c
  }

  shift |= shiftcode[data];
80102d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d1b:	05 20 90 10 80       	add    $0x80109020,%eax
80102d20:	0f b6 00             	movzbl (%eax),%eax
80102d23:	0f b6 d0             	movzbl %al,%edx
80102d26:	a1 7c e8 10 80       	mov    0x8010e87c,%eax
80102d2b:	09 d0                	or     %edx,%eax
80102d2d:	a3 7c e8 10 80       	mov    %eax,0x8010e87c
  shift ^= togglecode[data];
80102d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d35:	05 20 91 10 80       	add    $0x80109120,%eax
80102d3a:	0f b6 00             	movzbl (%eax),%eax
80102d3d:	0f b6 d0             	movzbl %al,%edx
80102d40:	a1 7c e8 10 80       	mov    0x8010e87c,%eax
80102d45:	31 d0                	xor    %edx,%eax
80102d47:	a3 7c e8 10 80       	mov    %eax,0x8010e87c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d4c:	a1 7c e8 10 80       	mov    0x8010e87c,%eax
80102d51:	83 e0 03             	and    $0x3,%eax
80102d54:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102d5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d5e:	01 d0                	add    %edx,%eax
80102d60:	0f b6 00             	movzbl (%eax),%eax
80102d63:	0f b6 c0             	movzbl %al,%eax
80102d66:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d69:	a1 7c e8 10 80       	mov    0x8010e87c,%eax
80102d6e:	83 e0 08             	and    $0x8,%eax
80102d71:	85 c0                	test   %eax,%eax
80102d73:	74 22                	je     80102d97 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102d75:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d79:	76 0c                	jbe    80102d87 <kbdgetc+0x13a>
80102d7b:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d7f:	77 06                	ja     80102d87 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102d81:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d85:	eb 10                	jmp    80102d97 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102d87:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d8b:	76 0a                	jbe    80102d97 <kbdgetc+0x14a>
80102d8d:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d91:	77 04                	ja     80102d97 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102d93:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d97:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d9a:	c9                   	leave  
80102d9b:	c3                   	ret    

80102d9c <kbdintr>:

void
kbdintr(void)
{
80102d9c:	55                   	push   %ebp
80102d9d:	89 e5                	mov    %esp,%ebp
80102d9f:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102da2:	83 ec 0c             	sub    $0xc,%esp
80102da5:	68 4d 2c 10 80       	push   $0x80102c4d
80102daa:	e8 51 da ff ff       	call   80100800 <consoleintr>
80102daf:	83 c4 10             	add    $0x10,%esp
}
80102db2:	90                   	nop
80102db3:	c9                   	leave  
80102db4:	c3                   	ret    

80102db5 <outb>:
{
80102db5:	55                   	push   %ebp
80102db6:	89 e5                	mov    %esp,%ebp
80102db8:	83 ec 08             	sub    $0x8,%esp
80102dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80102dbe:	8b 55 0c             	mov    0xc(%ebp),%edx
80102dc1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102dc5:	89 d0                	mov    %edx,%eax
80102dc7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dca:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102dce:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102dd2:	ee                   	out    %al,(%dx)
}
80102dd3:	90                   	nop
80102dd4:	c9                   	leave  
80102dd5:	c3                   	ret    

80102dd6 <readeflags>:
{
80102dd6:	55                   	push   %ebp
80102dd7:	89 e5                	mov    %esp,%ebp
80102dd9:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102ddc:	9c                   	pushf  
80102ddd:	58                   	pop    %eax
80102dde:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102de1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102de4:	c9                   	leave  
80102de5:	c3                   	ret    

80102de6 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102de6:	55                   	push   %ebp
80102de7:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102de9:	8b 15 80 e8 10 80    	mov    0x8010e880,%edx
80102def:	8b 45 08             	mov    0x8(%ebp),%eax
80102df2:	c1 e0 02             	shl    $0x2,%eax
80102df5:	01 c2                	add    %eax,%edx
80102df7:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dfa:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102dfc:	a1 80 e8 10 80       	mov    0x8010e880,%eax
80102e01:	83 c0 20             	add    $0x20,%eax
80102e04:	8b 00                	mov    (%eax),%eax
}
80102e06:	90                   	nop
80102e07:	5d                   	pop    %ebp
80102e08:	c3                   	ret    

80102e09 <lapicinit>:
//PAGEBREAK!

void
lapicinit(int c)
{
80102e09:	55                   	push   %ebp
80102e0a:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102e0c:	a1 80 e8 10 80       	mov    0x8010e880,%eax
80102e11:	85 c0                	test   %eax,%eax
80102e13:	0f 84 0c 01 00 00    	je     80102f25 <lapicinit+0x11c>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e19:	68 3f 01 00 00       	push   $0x13f
80102e1e:	6a 3c                	push   $0x3c
80102e20:	e8 c1 ff ff ff       	call   80102de6 <lapicw>
80102e25:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e28:	6a 0b                	push   $0xb
80102e2a:	68 f8 00 00 00       	push   $0xf8
80102e2f:	e8 b2 ff ff ff       	call   80102de6 <lapicw>
80102e34:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e37:	68 20 00 02 00       	push   $0x20020
80102e3c:	68 c8 00 00 00       	push   $0xc8
80102e41:	e8 a0 ff ff ff       	call   80102de6 <lapicw>
80102e46:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102e49:	68 80 96 98 00       	push   $0x989680
80102e4e:	68 e0 00 00 00       	push   $0xe0
80102e53:	e8 8e ff ff ff       	call   80102de6 <lapicw>
80102e58:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e5b:	68 00 00 01 00       	push   $0x10000
80102e60:	68 d4 00 00 00       	push   $0xd4
80102e65:	e8 7c ff ff ff       	call   80102de6 <lapicw>
80102e6a:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102e6d:	68 00 00 01 00       	push   $0x10000
80102e72:	68 d8 00 00 00       	push   $0xd8
80102e77:	e8 6a ff ff ff       	call   80102de6 <lapicw>
80102e7c:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e7f:	a1 80 e8 10 80       	mov    0x8010e880,%eax
80102e84:	83 c0 30             	add    $0x30,%eax
80102e87:	8b 00                	mov    (%eax),%eax
80102e89:	c1 e8 10             	shr    $0x10,%eax
80102e8c:	25 fc 00 00 00       	and    $0xfc,%eax
80102e91:	85 c0                	test   %eax,%eax
80102e93:	74 12                	je     80102ea7 <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102e95:	68 00 00 01 00       	push   $0x10000
80102e9a:	68 d0 00 00 00       	push   $0xd0
80102e9f:	e8 42 ff ff ff       	call   80102de6 <lapicw>
80102ea4:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102ea7:	6a 33                	push   $0x33
80102ea9:	68 dc 00 00 00       	push   $0xdc
80102eae:	e8 33 ff ff ff       	call   80102de6 <lapicw>
80102eb3:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102eb6:	6a 00                	push   $0x0
80102eb8:	68 a0 00 00 00       	push   $0xa0
80102ebd:	e8 24 ff ff ff       	call   80102de6 <lapicw>
80102ec2:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102ec5:	6a 00                	push   $0x0
80102ec7:	68 a0 00 00 00       	push   $0xa0
80102ecc:	e8 15 ff ff ff       	call   80102de6 <lapicw>
80102ed1:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ed4:	6a 00                	push   $0x0
80102ed6:	6a 2c                	push   $0x2c
80102ed8:	e8 09 ff ff ff       	call   80102de6 <lapicw>
80102edd:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ee0:	6a 00                	push   $0x0
80102ee2:	68 c4 00 00 00       	push   $0xc4
80102ee7:	e8 fa fe ff ff       	call   80102de6 <lapicw>
80102eec:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102eef:	68 00 85 08 00       	push   $0x88500
80102ef4:	68 c0 00 00 00       	push   $0xc0
80102ef9:	e8 e8 fe ff ff       	call   80102de6 <lapicw>
80102efe:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102f01:	90                   	nop
80102f02:	a1 80 e8 10 80       	mov    0x8010e880,%eax
80102f07:	05 00 03 00 00       	add    $0x300,%eax
80102f0c:	8b 00                	mov    (%eax),%eax
80102f0e:	25 00 10 00 00       	and    $0x1000,%eax
80102f13:	85 c0                	test   %eax,%eax
80102f15:	75 eb                	jne    80102f02 <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f17:	6a 00                	push   $0x0
80102f19:	6a 20                	push   $0x20
80102f1b:	e8 c6 fe ff ff       	call   80102de6 <lapicw>
80102f20:	83 c4 08             	add    $0x8,%esp
80102f23:	eb 01                	jmp    80102f26 <lapicinit+0x11d>
    return;
80102f25:	90                   	nop
}
80102f26:	c9                   	leave  
80102f27:	c3                   	ret    

80102f28 <cpunum>:

int
cpunum(void)
{
80102f28:	55                   	push   %ebp
80102f29:	89 e5                	mov    %esp,%ebp
80102f2b:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f2e:	e8 a3 fe ff ff       	call   80102dd6 <readeflags>
80102f33:	25 00 02 00 00       	and    $0x200,%eax
80102f38:	85 c0                	test   %eax,%eax
80102f3a:	74 26                	je     80102f62 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102f3c:	a1 84 e8 10 80       	mov    0x8010e884,%eax
80102f41:	8d 50 01             	lea    0x1(%eax),%edx
80102f44:	89 15 84 e8 10 80    	mov    %edx,0x8010e884
80102f4a:	85 c0                	test   %eax,%eax
80102f4c:	75 14                	jne    80102f62 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f4e:	8b 45 04             	mov    0x4(%ebp),%eax
80102f51:	83 ec 08             	sub    $0x8,%esp
80102f54:	50                   	push   %eax
80102f55:	68 94 87 10 80       	push   $0x80108794
80102f5a:	e8 67 d4 ff ff       	call   801003c6 <cprintf>
80102f5f:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102f62:	a1 80 e8 10 80       	mov    0x8010e880,%eax
80102f67:	85 c0                	test   %eax,%eax
80102f69:	74 0f                	je     80102f7a <cpunum+0x52>
    return lapic[ID]>>24;
80102f6b:	a1 80 e8 10 80       	mov    0x8010e880,%eax
80102f70:	83 c0 20             	add    $0x20,%eax
80102f73:	8b 00                	mov    (%eax),%eax
80102f75:	c1 e8 18             	shr    $0x18,%eax
80102f78:	eb 05                	jmp    80102f7f <cpunum+0x57>
  return 0;
80102f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f7f:	c9                   	leave  
80102f80:	c3                   	ret    

80102f81 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f81:	55                   	push   %ebp
80102f82:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102f84:	a1 80 e8 10 80       	mov    0x8010e880,%eax
80102f89:	85 c0                	test   %eax,%eax
80102f8b:	74 0c                	je     80102f99 <lapiceoi+0x18>
    lapicw(EOI, 0);
80102f8d:	6a 00                	push   $0x0
80102f8f:	6a 2c                	push   $0x2c
80102f91:	e8 50 fe ff ff       	call   80102de6 <lapicw>
80102f96:	83 c4 08             	add    $0x8,%esp
}
80102f99:	90                   	nop
80102f9a:	c9                   	leave  
80102f9b:	c3                   	ret    

80102f9c <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f9c:	55                   	push   %ebp
80102f9d:	89 e5                	mov    %esp,%ebp
}
80102f9f:	90                   	nop
80102fa0:	5d                   	pop    %ebp
80102fa1:	c3                   	ret    

80102fa2 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fa2:	55                   	push   %ebp
80102fa3:	89 e5                	mov    %esp,%ebp
80102fa5:	83 ec 14             	sub    $0x14,%esp
80102fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80102fab:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102fae:	6a 0f                	push   $0xf
80102fb0:	6a 70                	push   $0x70
80102fb2:	e8 fe fd ff ff       	call   80102db5 <outb>
80102fb7:	83 c4 08             	add    $0x8,%esp
  outb(IO_RTC+1, 0x0A);
80102fba:	6a 0a                	push   $0xa
80102fbc:	6a 71                	push   $0x71
80102fbe:	e8 f2 fd ff ff       	call   80102db5 <outb>
80102fc3:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102fc6:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102fcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fd0:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fd8:	c1 e8 04             	shr    $0x4,%eax
80102fdb:	89 c2                	mov    %eax,%edx
80102fdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fe0:	83 c0 02             	add    $0x2,%eax
80102fe3:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fe6:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fea:	c1 e0 18             	shl    $0x18,%eax
80102fed:	50                   	push   %eax
80102fee:	68 c4 00 00 00       	push   $0xc4
80102ff3:	e8 ee fd ff ff       	call   80102de6 <lapicw>
80102ff8:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102ffb:	68 00 c5 00 00       	push   $0xc500
80103000:	68 c0 00 00 00       	push   $0xc0
80103005:	e8 dc fd ff ff       	call   80102de6 <lapicw>
8010300a:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010300d:	68 c8 00 00 00       	push   $0xc8
80103012:	e8 85 ff ff ff       	call   80102f9c <microdelay>
80103017:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010301a:	68 00 85 00 00       	push   $0x8500
8010301f:	68 c0 00 00 00       	push   $0xc0
80103024:	e8 bd fd ff ff       	call   80102de6 <lapicw>
80103029:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010302c:	6a 64                	push   $0x64
8010302e:	e8 69 ff ff ff       	call   80102f9c <microdelay>
80103033:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103036:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010303d:	eb 3d                	jmp    8010307c <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
8010303f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103043:	c1 e0 18             	shl    $0x18,%eax
80103046:	50                   	push   %eax
80103047:	68 c4 00 00 00       	push   $0xc4
8010304c:	e8 95 fd ff ff       	call   80102de6 <lapicw>
80103051:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103054:	8b 45 0c             	mov    0xc(%ebp),%eax
80103057:	c1 e8 0c             	shr    $0xc,%eax
8010305a:	80 cc 06             	or     $0x6,%ah
8010305d:	50                   	push   %eax
8010305e:	68 c0 00 00 00       	push   $0xc0
80103063:	e8 7e fd ff ff       	call   80102de6 <lapicw>
80103068:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
8010306b:	68 c8 00 00 00       	push   $0xc8
80103070:	e8 27 ff ff ff       	call   80102f9c <microdelay>
80103075:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80103078:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010307c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103080:	7e bd                	jle    8010303f <lapicstartap+0x9d>
  }
}
80103082:	90                   	nop
80103083:	90                   	nop
80103084:	c9                   	leave  
80103085:	c3                   	ret    

80103086 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80103086:	55                   	push   %ebp
80103087:	89 e5                	mov    %esp,%ebp
80103089:	83 ec 18             	sub    $0x18,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010308c:	83 ec 08             	sub    $0x8,%esp
8010308f:	68 c0 87 10 80       	push   $0x801087c0
80103094:	68 a0 e8 10 80       	push   $0x8010e8a0
80103099:	e8 1b 1f 00 00       	call   80104fb9 <initlock>
8010309e:	83 c4 10             	add    $0x10,%esp
  readsb(ROOTDEV, &sb);
801030a1:	83 ec 08             	sub    $0x8,%esp
801030a4:	8d 45 e8             	lea    -0x18(%ebp),%eax
801030a7:	50                   	push   %eax
801030a8:	6a 01                	push   $0x1
801030aa:	e8 da e2 ff ff       	call   80101389 <readsb>
801030af:	83 c4 10             	add    $0x10,%esp
  log.start = sb.size - sb.nlog;
801030b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801030b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801030b8:	29 d0                	sub    %edx,%eax
801030ba:	a3 d4 e8 10 80       	mov    %eax,0x8010e8d4
  log.size = sb.nlog;
801030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030c2:	a3 d8 e8 10 80       	mov    %eax,0x8010e8d8
  log.dev = ROOTDEV;
801030c7:	c7 05 e0 e8 10 80 01 	movl   $0x1,0x8010e8e0
801030ce:	00 00 00 
  recover_from_log();
801030d1:	e8 b3 01 00 00       	call   80103289 <recover_from_log>
}
801030d6:	90                   	nop
801030d7:	c9                   	leave  
801030d8:	c3                   	ret    

801030d9 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801030d9:	55                   	push   %ebp
801030da:	89 e5                	mov    %esp,%ebp
801030dc:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801030e6:	e9 95 00 00 00       	jmp    80103180 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801030eb:	8b 15 d4 e8 10 80    	mov    0x8010e8d4,%edx
801030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030f4:	01 d0                	add    %edx,%eax
801030f6:	83 c0 01             	add    $0x1,%eax
801030f9:	89 c2                	mov    %eax,%edx
801030fb:	a1 e0 e8 10 80       	mov    0x8010e8e0,%eax
80103100:	83 ec 08             	sub    $0x8,%esp
80103103:	52                   	push   %edx
80103104:	50                   	push   %eax
80103105:	e8 ad d0 ff ff       	call   801001b7 <bread>
8010310a:	83 c4 10             	add    $0x10,%esp
8010310d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103110:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103113:	83 c0 10             	add    $0x10,%eax
80103116:	8b 04 85 a8 e8 10 80 	mov    -0x7fef1758(,%eax,4),%eax
8010311d:	89 c2                	mov    %eax,%edx
8010311f:	a1 e0 e8 10 80       	mov    0x8010e8e0,%eax
80103124:	83 ec 08             	sub    $0x8,%esp
80103127:	52                   	push   %edx
80103128:	50                   	push   %eax
80103129:	e8 89 d0 ff ff       	call   801001b7 <bread>
8010312e:	83 c4 10             	add    $0x10,%esp
80103131:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103134:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103137:	8d 50 18             	lea    0x18(%eax),%edx
8010313a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010313d:	83 c0 18             	add    $0x18,%eax
80103140:	83 ec 04             	sub    $0x4,%esp
80103143:	68 00 02 00 00       	push   $0x200
80103148:	52                   	push   %edx
80103149:	50                   	push   %eax
8010314a:	e8 ae 21 00 00       	call   801052fd <memmove>
8010314f:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103152:	83 ec 0c             	sub    $0xc,%esp
80103155:	ff 75 ec             	pushl  -0x14(%ebp)
80103158:	e8 93 d0 ff ff       	call   801001f0 <bwrite>
8010315d:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
80103160:	83 ec 0c             	sub    $0xc,%esp
80103163:	ff 75 f0             	pushl  -0x10(%ebp)
80103166:	e8 c4 d0 ff ff       	call   8010022f <brelse>
8010316b:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010316e:	83 ec 0c             	sub    $0xc,%esp
80103171:	ff 75 ec             	pushl  -0x14(%ebp)
80103174:	e8 b6 d0 ff ff       	call   8010022f <brelse>
80103179:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010317c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103180:	a1 e4 e8 10 80       	mov    0x8010e8e4,%eax
80103185:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103188:	0f 8c 5d ff ff ff    	jl     801030eb <install_trans+0x12>
  }
}
8010318e:	90                   	nop
8010318f:	90                   	nop
80103190:	c9                   	leave  
80103191:	c3                   	ret    

80103192 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103192:	55                   	push   %ebp
80103193:	89 e5                	mov    %esp,%ebp
80103195:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103198:	a1 d4 e8 10 80       	mov    0x8010e8d4,%eax
8010319d:	89 c2                	mov    %eax,%edx
8010319f:	a1 e0 e8 10 80       	mov    0x8010e8e0,%eax
801031a4:	83 ec 08             	sub    $0x8,%esp
801031a7:	52                   	push   %edx
801031a8:	50                   	push   %eax
801031a9:	e8 09 d0 ff ff       	call   801001b7 <bread>
801031ae:	83 c4 10             	add    $0x10,%esp
801031b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801031b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031b7:	83 c0 18             	add    $0x18,%eax
801031ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801031bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031c0:	8b 00                	mov    (%eax),%eax
801031c2:	a3 e4 e8 10 80       	mov    %eax,0x8010e8e4
  for (i = 0; i < log.lh.n; i++) {
801031c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031ce:	eb 1b                	jmp    801031eb <read_head+0x59>
    log.lh.sector[i] = lh->sector[i];
801031d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031d6:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801031da:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031dd:	83 c2 10             	add    $0x10,%edx
801031e0:	89 04 95 a8 e8 10 80 	mov    %eax,-0x7fef1758(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801031e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031eb:	a1 e4 e8 10 80       	mov    0x8010e8e4,%eax
801031f0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801031f3:	7c db                	jl     801031d0 <read_head+0x3e>
  }
  brelse(buf);
801031f5:	83 ec 0c             	sub    $0xc,%esp
801031f8:	ff 75 f0             	pushl  -0x10(%ebp)
801031fb:	e8 2f d0 ff ff       	call   8010022f <brelse>
80103200:	83 c4 10             	add    $0x10,%esp
}
80103203:	90                   	nop
80103204:	c9                   	leave  
80103205:	c3                   	ret    

80103206 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103206:	55                   	push   %ebp
80103207:	89 e5                	mov    %esp,%ebp
80103209:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010320c:	a1 d4 e8 10 80       	mov    0x8010e8d4,%eax
80103211:	89 c2                	mov    %eax,%edx
80103213:	a1 e0 e8 10 80       	mov    0x8010e8e0,%eax
80103218:	83 ec 08             	sub    $0x8,%esp
8010321b:	52                   	push   %edx
8010321c:	50                   	push   %eax
8010321d:	e8 95 cf ff ff       	call   801001b7 <bread>
80103222:	83 c4 10             	add    $0x10,%esp
80103225:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103228:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010322b:	83 c0 18             	add    $0x18,%eax
8010322e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103231:	8b 15 e4 e8 10 80    	mov    0x8010e8e4,%edx
80103237:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010323a:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010323c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103243:	eb 1b                	jmp    80103260 <write_head+0x5a>
    hb->sector[i] = log.lh.sector[i];
80103245:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103248:	83 c0 10             	add    $0x10,%eax
8010324b:	8b 0c 85 a8 e8 10 80 	mov    -0x7fef1758(,%eax,4),%ecx
80103252:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103255:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103258:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010325c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103260:	a1 e4 e8 10 80       	mov    0x8010e8e4,%eax
80103265:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103268:	7c db                	jl     80103245 <write_head+0x3f>
  }
  bwrite(buf);
8010326a:	83 ec 0c             	sub    $0xc,%esp
8010326d:	ff 75 f0             	pushl  -0x10(%ebp)
80103270:	e8 7b cf ff ff       	call   801001f0 <bwrite>
80103275:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103278:	83 ec 0c             	sub    $0xc,%esp
8010327b:	ff 75 f0             	pushl  -0x10(%ebp)
8010327e:	e8 ac cf ff ff       	call   8010022f <brelse>
80103283:	83 c4 10             	add    $0x10,%esp
}
80103286:	90                   	nop
80103287:	c9                   	leave  
80103288:	c3                   	ret    

80103289 <recover_from_log>:

static void
recover_from_log(void)
{
80103289:	55                   	push   %ebp
8010328a:	89 e5                	mov    %esp,%ebp
8010328c:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010328f:	e8 fe fe ff ff       	call   80103192 <read_head>
  install_trans(); // if committed, copy from log to disk
80103294:	e8 40 fe ff ff       	call   801030d9 <install_trans>
  log.lh.n = 0;
80103299:	c7 05 e4 e8 10 80 00 	movl   $0x0,0x8010e8e4
801032a0:	00 00 00 
  write_head(); // clear the log
801032a3:	e8 5e ff ff ff       	call   80103206 <write_head>
}
801032a8:	90                   	nop
801032a9:	c9                   	leave  
801032aa:	c3                   	ret    

801032ab <begin_trans>:

void
begin_trans(void)
{
801032ab:	55                   	push   %ebp
801032ac:	89 e5                	mov    %esp,%ebp
801032ae:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801032b1:	83 ec 0c             	sub    $0xc,%esp
801032b4:	68 a0 e8 10 80       	push   $0x8010e8a0
801032b9:	e8 1d 1d 00 00       	call   80104fdb <acquire>
801032be:	83 c4 10             	add    $0x10,%esp
  while (log.busy) {
801032c1:	eb 15                	jmp    801032d8 <begin_trans+0x2d>
    sleep(&log, &log.lock);
801032c3:	83 ec 08             	sub    $0x8,%esp
801032c6:	68 a0 e8 10 80       	push   $0x8010e8a0
801032cb:	68 a0 e8 10 80       	push   $0x8010e8a0
801032d0:	e8 e7 16 00 00       	call   801049bc <sleep>
801032d5:	83 c4 10             	add    $0x10,%esp
  while (log.busy) {
801032d8:	a1 dc e8 10 80       	mov    0x8010e8dc,%eax
801032dd:	85 c0                	test   %eax,%eax
801032df:	75 e2                	jne    801032c3 <begin_trans+0x18>
  }
  log.busy = 1;
801032e1:	c7 05 dc e8 10 80 01 	movl   $0x1,0x8010e8dc
801032e8:	00 00 00 
  release(&log.lock);
801032eb:	83 ec 0c             	sub    $0xc,%esp
801032ee:	68 a0 e8 10 80       	push   $0x8010e8a0
801032f3:	e8 4a 1d 00 00       	call   80105042 <release>
801032f8:	83 c4 10             	add    $0x10,%esp
}
801032fb:	90                   	nop
801032fc:	c9                   	leave  
801032fd:	c3                   	ret    

801032fe <commit_trans>:

void
commit_trans(void)
{
801032fe:	55                   	push   %ebp
801032ff:	89 e5                	mov    %esp,%ebp
80103301:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103304:	a1 e4 e8 10 80       	mov    0x8010e8e4,%eax
80103309:	85 c0                	test   %eax,%eax
8010330b:	7e 19                	jle    80103326 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
8010330d:	e8 f4 fe ff ff       	call   80103206 <write_head>
    install_trans(); // Now install writes to home locations
80103312:	e8 c2 fd ff ff       	call   801030d9 <install_trans>
    log.lh.n = 0; 
80103317:	c7 05 e4 e8 10 80 00 	movl   $0x0,0x8010e8e4
8010331e:	00 00 00 
    write_head();    // Erase the transaction from the log
80103321:	e8 e0 fe ff ff       	call   80103206 <write_head>
  }
  
  acquire(&log.lock);
80103326:	83 ec 0c             	sub    $0xc,%esp
80103329:	68 a0 e8 10 80       	push   $0x8010e8a0
8010332e:	e8 a8 1c 00 00       	call   80104fdb <acquire>
80103333:	83 c4 10             	add    $0x10,%esp
  log.busy = 0;
80103336:	c7 05 dc e8 10 80 00 	movl   $0x0,0x8010e8dc
8010333d:	00 00 00 
  wakeup(&log);
80103340:	83 ec 0c             	sub    $0xc,%esp
80103343:	68 a0 e8 10 80       	push   $0x8010e8a0
80103348:	e8 5e 17 00 00       	call   80104aab <wakeup>
8010334d:	83 c4 10             	add    $0x10,%esp
  release(&log.lock);
80103350:	83 ec 0c             	sub    $0xc,%esp
80103353:	68 a0 e8 10 80       	push   $0x8010e8a0
80103358:	e8 e5 1c 00 00       	call   80105042 <release>
8010335d:	83 c4 10             	add    $0x10,%esp
}
80103360:	90                   	nop
80103361:	c9                   	leave  
80103362:	c3                   	ret    

80103363 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103363:	55                   	push   %ebp
80103364:	89 e5                	mov    %esp,%ebp
80103366:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103369:	a1 e4 e8 10 80       	mov    0x8010e8e4,%eax
8010336e:	83 f8 09             	cmp    $0x9,%eax
80103371:	7f 12                	jg     80103385 <log_write+0x22>
80103373:	a1 e4 e8 10 80       	mov    0x8010e8e4,%eax
80103378:	8b 15 d8 e8 10 80    	mov    0x8010e8d8,%edx
8010337e:	83 ea 01             	sub    $0x1,%edx
80103381:	39 d0                	cmp    %edx,%eax
80103383:	7c 0d                	jl     80103392 <log_write+0x2f>
    panic("too big a transaction");
80103385:	83 ec 0c             	sub    $0xc,%esp
80103388:	68 c4 87 10 80       	push   $0x801087c4
8010338d:	e8 e9 d1 ff ff       	call   8010057b <panic>
  if (!log.busy)
80103392:	a1 dc e8 10 80       	mov    0x8010e8dc,%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	75 0d                	jne    801033a8 <log_write+0x45>
    panic("write outside of trans");
8010339b:	83 ec 0c             	sub    $0xc,%esp
8010339e:	68 da 87 10 80       	push   $0x801087da
801033a3:	e8 d3 d1 ff ff       	call   8010057b <panic>

  for (i = 0; i < log.lh.n; i++) {
801033a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033af:	eb 1d                	jmp    801033ce <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801033b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033b4:	83 c0 10             	add    $0x10,%eax
801033b7:	8b 04 85 a8 e8 10 80 	mov    -0x7fef1758(,%eax,4),%eax
801033be:	89 c2                	mov    %eax,%edx
801033c0:	8b 45 08             	mov    0x8(%ebp),%eax
801033c3:	8b 40 08             	mov    0x8(%eax),%eax
801033c6:	39 c2                	cmp    %eax,%edx
801033c8:	74 10                	je     801033da <log_write+0x77>
  for (i = 0; i < log.lh.n; i++) {
801033ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033ce:	a1 e4 e8 10 80       	mov    0x8010e8e4,%eax
801033d3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801033d6:	7c d9                	jl     801033b1 <log_write+0x4e>
801033d8:	eb 01                	jmp    801033db <log_write+0x78>
      break;
801033da:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
801033db:	8b 45 08             	mov    0x8(%ebp),%eax
801033de:	8b 40 08             	mov    0x8(%eax),%eax
801033e1:	89 c2                	mov    %eax,%edx
801033e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033e6:	83 c0 10             	add    $0x10,%eax
801033e9:	89 14 85 a8 e8 10 80 	mov    %edx,-0x7fef1758(,%eax,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
801033f0:	8b 15 d4 e8 10 80    	mov    0x8010e8d4,%edx
801033f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033f9:	01 d0                	add    %edx,%eax
801033fb:	83 c0 01             	add    $0x1,%eax
801033fe:	89 c2                	mov    %eax,%edx
80103400:	8b 45 08             	mov    0x8(%ebp),%eax
80103403:	8b 40 04             	mov    0x4(%eax),%eax
80103406:	83 ec 08             	sub    $0x8,%esp
80103409:	52                   	push   %edx
8010340a:	50                   	push   %eax
8010340b:	e8 a7 cd ff ff       	call   801001b7 <bread>
80103410:	83 c4 10             	add    $0x10,%esp
80103413:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103416:	8b 45 08             	mov    0x8(%ebp),%eax
80103419:	8d 50 18             	lea    0x18(%eax),%edx
8010341c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010341f:	83 c0 18             	add    $0x18,%eax
80103422:	83 ec 04             	sub    $0x4,%esp
80103425:	68 00 02 00 00       	push   $0x200
8010342a:	52                   	push   %edx
8010342b:	50                   	push   %eax
8010342c:	e8 cc 1e 00 00       	call   801052fd <memmove>
80103431:	83 c4 10             	add    $0x10,%esp
  bwrite(lbuf);
80103434:	83 ec 0c             	sub    $0xc,%esp
80103437:	ff 75 f0             	pushl  -0x10(%ebp)
8010343a:	e8 b1 cd ff ff       	call   801001f0 <bwrite>
8010343f:	83 c4 10             	add    $0x10,%esp
  brelse(lbuf);
80103442:	83 ec 0c             	sub    $0xc,%esp
80103445:	ff 75 f0             	pushl  -0x10(%ebp)
80103448:	e8 e2 cd ff ff       	call   8010022f <brelse>
8010344d:	83 c4 10             	add    $0x10,%esp
  if (i == log.lh.n)
80103450:	a1 e4 e8 10 80       	mov    0x8010e8e4,%eax
80103455:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103458:	75 0d                	jne    80103467 <log_write+0x104>
    log.lh.n++;
8010345a:	a1 e4 e8 10 80       	mov    0x8010e8e4,%eax
8010345f:	83 c0 01             	add    $0x1,%eax
80103462:	a3 e4 e8 10 80       	mov    %eax,0x8010e8e4
  b->flags |= B_DIRTY; // XXX prevent eviction
80103467:	8b 45 08             	mov    0x8(%ebp),%eax
8010346a:	8b 00                	mov    (%eax),%eax
8010346c:	83 c8 04             	or     $0x4,%eax
8010346f:	89 c2                	mov    %eax,%edx
80103471:	8b 45 08             	mov    0x8(%ebp),%eax
80103474:	89 10                	mov    %edx,(%eax)
}
80103476:	90                   	nop
80103477:	c9                   	leave  
80103478:	c3                   	ret    

80103479 <v2p>:
80103479:	55                   	push   %ebp
8010347a:	89 e5                	mov    %esp,%ebp
8010347c:	8b 45 08             	mov    0x8(%ebp),%eax
8010347f:	05 00 00 00 80       	add    $0x80000000,%eax
80103484:	5d                   	pop    %ebp
80103485:	c3                   	ret    

80103486 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103486:	55                   	push   %ebp
80103487:	89 e5                	mov    %esp,%ebp
80103489:	8b 45 08             	mov    0x8(%ebp),%eax
8010348c:	05 00 00 00 80       	add    $0x80000000,%eax
80103491:	5d                   	pop    %ebp
80103492:	c3                   	ret    

80103493 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103493:	55                   	push   %ebp
80103494:	89 e5                	mov    %esp,%ebp
80103496:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103499:	8b 55 08             	mov    0x8(%ebp),%edx
8010349c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010349f:	8b 4d 08             	mov    0x8(%ebp),%ecx
801034a2:	f0 87 02             	lock xchg %eax,(%edx)
801034a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801034a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801034ab:	c9                   	leave  
801034ac:	c3                   	ret    

801034ad <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801034ad:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801034b1:	83 e4 f0             	and    $0xfffffff0,%esp
801034b4:	ff 71 fc             	pushl  -0x4(%ecx)
801034b7:	55                   	push   %ebp
801034b8:	89 e5                	mov    %esp,%ebp
801034ba:	51                   	push   %ecx
801034bb:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801034be:	83 ec 08             	sub    $0x8,%esp
801034c1:	68 00 00 40 80       	push   $0x80400000
801034c6:	68 e0 3b 11 80       	push   $0x80113be0
801034cb:	e8 d3 f5 ff ff       	call   80102aa3 <kinit1>
801034d0:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801034d3:	e8 82 49 00 00       	call   80107e5a <kvmalloc>
  mpinit();        // collect info about this machine
801034d8:	e8 5c 04 00 00       	call   80103939 <mpinit>
  lapicinit(mpbcpu());
801034dd:	e8 34 02 00 00       	call   80103716 <mpbcpu>
801034e2:	83 ec 0c             	sub    $0xc,%esp
801034e5:	50                   	push   %eax
801034e6:	e8 1e f9 ff ff       	call   80102e09 <lapicinit>
801034eb:	83 c4 10             	add    $0x10,%esp
  seginit();       // set up segments
801034ee:	e8 10 43 00 00       	call   80107803 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801034f3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034f9:	0f b6 00             	movzbl (%eax),%eax
801034fc:	0f b6 c0             	movzbl %al,%eax
801034ff:	83 ec 08             	sub    $0x8,%esp
80103502:	50                   	push   %eax
80103503:	68 f1 87 10 80       	push   $0x801087f1
80103508:	e8 b9 ce ff ff       	call   801003c6 <cprintf>
8010350d:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103510:	e8 a0 06 00 00       	call   80103bb5 <picinit>
  ioapicinit();    // another interrupt controller
80103515:	e8 7e f4 ff ff       	call   80102998 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010351a:	e8 f3 d5 ff ff       	call   80100b12 <consoleinit>
  uartinit();      // serial port
8010351f:	e8 3b 36 00 00       	call   80106b5f <uartinit>
  pinit();         // process table
80103524:	e8 89 0b 00 00       	call   801040b2 <pinit>
  tvinit();        // trap vectors
80103529:	e8 f8 31 00 00       	call   80106726 <tvinit>
  binit();         // buffer cache
8010352e:	e8 01 cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103533:	e8 42 da ff ff       	call   80100f7a <fileinit>
  iinit();         // inode cache
80103538:	e8 1b e1 ff ff       	call   80101658 <iinit>
  ideinit();       // disk
8010353d:	e8 9a f0 ff ff       	call   801025dc <ideinit>
	semaphore_init(); //semaphore initialization
80103542:	e8 1f 17 00 00       	call   80104c66 <semaphore_init>
  if(!ismp)
80103547:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010354c:	85 c0                	test   %eax,%eax
8010354e:	75 05                	jne    80103555 <main+0xa8>
    timerinit();   // uniprocessor timer
80103550:	e8 2e 31 00 00       	call   80106683 <timerinit>
  startothers();   // start other processors
80103555:	e8 8b 00 00 00       	call   801035e5 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010355a:	83 ec 08             	sub    $0x8,%esp
8010355d:	68 00 00 00 8e       	push   $0x8e000000
80103562:	68 00 00 40 80       	push   $0x80400000
80103567:	e8 70 f5 ff ff       	call   80102adc <kinit2>
8010356c:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
8010356f:	e8 a0 0c 00 00       	call   80104214 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103574:	e8 26 00 00 00       	call   8010359f <mpmain>

80103579 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103579:	55                   	push   %ebp
8010357a:	89 e5                	mov    %esp,%ebp
8010357c:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
8010357f:	e8 ee 48 00 00       	call   80107e72 <switchkvm>
  seginit();
80103584:	e8 7a 42 00 00       	call   80107803 <seginit>
  lapicinit(cpunum());
80103589:	e8 9a f9 ff ff       	call   80102f28 <cpunum>
8010358e:	83 ec 0c             	sub    $0xc,%esp
80103591:	50                   	push   %eax
80103592:	e8 72 f8 ff ff       	call   80102e09 <lapicinit>
80103597:	83 c4 10             	add    $0x10,%esp
  mpmain();
8010359a:	e8 00 00 00 00       	call   8010359f <mpmain>

8010359f <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010359f:	55                   	push   %ebp
801035a0:	89 e5                	mov    %esp,%ebp
801035a2:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801035a5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801035ab:	0f b6 00             	movzbl (%eax),%eax
801035ae:	0f b6 c0             	movzbl %al,%eax
801035b1:	83 ec 08             	sub    $0x8,%esp
801035b4:	50                   	push   %eax
801035b5:	68 08 88 10 80       	push   $0x80108808
801035ba:	e8 07 ce ff ff       	call   801003c6 <cprintf>
801035bf:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801035c2:	e8 d5 32 00 00       	call   8010689c <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801035c7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801035cd:	05 a8 00 00 00       	add    $0xa8,%eax
801035d2:	83 ec 08             	sub    $0x8,%esp
801035d5:	6a 01                	push   $0x1
801035d7:	50                   	push   %eax
801035d8:	e8 b6 fe ff ff       	call   80103493 <xchg>
801035dd:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801035e0:	e8 07 12 00 00       	call   801047ec <scheduler>

801035e5 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801035e5:	55                   	push   %ebp
801035e6:	89 e5                	mov    %esp,%ebp
801035e8:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801035eb:	68 00 70 00 00       	push   $0x7000
801035f0:	e8 91 fe ff ff       	call   80103486 <p2v>
801035f5:	83 c4 04             	add    $0x4,%esp
801035f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801035fb:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103600:	83 ec 04             	sub    $0x4,%esp
80103603:	50                   	push   %eax
80103604:	68 2c b5 10 80       	push   $0x8010b52c
80103609:	ff 75 f0             	pushl  -0x10(%ebp)
8010360c:	e8 ec 1c 00 00       	call   801052fd <memmove>
80103611:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103614:	c7 45 f4 20 e9 10 80 	movl   $0x8010e920,-0xc(%ebp)
8010361b:	e9 8e 00 00 00       	jmp    801036ae <startothers+0xc9>
    if(c == cpus+cpunum())  // We've started already.
80103620:	e8 03 f9 ff ff       	call   80102f28 <cpunum>
80103625:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010362b:	05 20 e9 10 80       	add    $0x8010e920,%eax
80103630:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103633:	74 71                	je     801036a6 <startothers+0xc1>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103635:	e8 a1 f5 ff ff       	call   80102bdb <kalloc>
8010363a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010363d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103640:	83 e8 04             	sub    $0x4,%eax
80103643:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103646:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010364c:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010364e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103651:	83 e8 08             	sub    $0x8,%eax
80103654:	c7 00 79 35 10 80    	movl   $0x80103579,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
8010365a:	83 ec 0c             	sub    $0xc,%esp
8010365d:	68 00 a0 10 80       	push   $0x8010a000
80103662:	e8 12 fe ff ff       	call   80103479 <v2p>
80103667:	83 c4 10             	add    $0x10,%esp
8010366a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010366d:	83 ea 0c             	sub    $0xc,%edx
80103670:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->id, v2p(code));
80103672:	83 ec 0c             	sub    $0xc,%esp
80103675:	ff 75 f0             	pushl  -0x10(%ebp)
80103678:	e8 fc fd ff ff       	call   80103479 <v2p>
8010367d:	83 c4 10             	add    $0x10,%esp
80103680:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103683:	0f b6 12             	movzbl (%edx),%edx
80103686:	0f b6 d2             	movzbl %dl,%edx
80103689:	83 ec 08             	sub    $0x8,%esp
8010368c:	50                   	push   %eax
8010368d:	52                   	push   %edx
8010368e:	e8 0f f9 ff ff       	call   80102fa2 <lapicstartap>
80103693:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103696:	90                   	nop
80103697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010369a:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801036a0:	85 c0                	test   %eax,%eax
801036a2:	74 f3                	je     80103697 <startothers+0xb2>
801036a4:	eb 01                	jmp    801036a7 <startothers+0xc2>
      continue;
801036a6:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
801036a7:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801036ae:	a1 04 ef 10 80       	mov    0x8010ef04,%eax
801036b3:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801036b9:	05 20 e9 10 80       	add    $0x8010e920,%eax
801036be:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801036c1:	0f 82 59 ff ff ff    	jb     80103620 <startothers+0x3b>
      ;
  }
}
801036c7:	90                   	nop
801036c8:	90                   	nop
801036c9:	c9                   	leave  
801036ca:	c3                   	ret    

801036cb <p2v>:
801036cb:	55                   	push   %ebp
801036cc:	89 e5                	mov    %esp,%ebp
801036ce:	8b 45 08             	mov    0x8(%ebp),%eax
801036d1:	05 00 00 00 80       	add    $0x80000000,%eax
801036d6:	5d                   	pop    %ebp
801036d7:	c3                   	ret    

801036d8 <inb>:
{
801036d8:	55                   	push   %ebp
801036d9:	89 e5                	mov    %esp,%ebp
801036db:	83 ec 14             	sub    $0x14,%esp
801036de:	8b 45 08             	mov    0x8(%ebp),%eax
801036e1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801036e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801036e9:	89 c2                	mov    %eax,%edx
801036eb:	ec                   	in     (%dx),%al
801036ec:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801036ef:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801036f3:	c9                   	leave  
801036f4:	c3                   	ret    

801036f5 <outb>:
{
801036f5:	55                   	push   %ebp
801036f6:	89 e5                	mov    %esp,%ebp
801036f8:	83 ec 08             	sub    $0x8,%esp
801036fb:	8b 45 08             	mov    0x8(%ebp),%eax
801036fe:	8b 55 0c             	mov    0xc(%ebp),%edx
80103701:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103705:	89 d0                	mov    %edx,%eax
80103707:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010370a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010370e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103712:	ee                   	out    %al,(%dx)
}
80103713:	90                   	nop
80103714:	c9                   	leave  
80103715:	c3                   	ret    

80103716 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103716:	55                   	push   %ebp
80103717:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103719:	a1 0c ef 10 80       	mov    0x8010ef0c,%eax
8010371e:	2d 20 e9 10 80       	sub    $0x8010e920,%eax
80103723:	c1 f8 02             	sar    $0x2,%eax
80103726:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
8010372c:	5d                   	pop    %ebp
8010372d:	c3                   	ret    

8010372e <sum>:

static uchar
sum(uchar *addr, int len)
{
8010372e:	55                   	push   %ebp
8010372f:	89 e5                	mov    %esp,%ebp
80103731:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103734:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010373b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103742:	eb 15                	jmp    80103759 <sum+0x2b>
    sum += addr[i];
80103744:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103747:	8b 45 08             	mov    0x8(%ebp),%eax
8010374a:	01 d0                	add    %edx,%eax
8010374c:	0f b6 00             	movzbl (%eax),%eax
8010374f:	0f b6 c0             	movzbl %al,%eax
80103752:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103755:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103759:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010375c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010375f:	7c e3                	jl     80103744 <sum+0x16>
  return sum;
80103761:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103764:	c9                   	leave  
80103765:	c3                   	ret    

80103766 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103766:	55                   	push   %ebp
80103767:	89 e5                	mov    %esp,%ebp
80103769:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
8010376c:	ff 75 08             	pushl  0x8(%ebp)
8010376f:	e8 57 ff ff ff       	call   801036cb <p2v>
80103774:	83 c4 04             	add    $0x4,%esp
80103777:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
8010377a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010377d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103780:	01 d0                	add    %edx,%eax
80103782:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103785:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103788:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010378b:	eb 36                	jmp    801037c3 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010378d:	83 ec 04             	sub    $0x4,%esp
80103790:	6a 04                	push   $0x4
80103792:	68 1c 88 10 80       	push   $0x8010881c
80103797:	ff 75 f4             	pushl  -0xc(%ebp)
8010379a:	e8 06 1b 00 00       	call   801052a5 <memcmp>
8010379f:	83 c4 10             	add    $0x10,%esp
801037a2:	85 c0                	test   %eax,%eax
801037a4:	75 19                	jne    801037bf <mpsearch1+0x59>
801037a6:	83 ec 08             	sub    $0x8,%esp
801037a9:	6a 10                	push   $0x10
801037ab:	ff 75 f4             	pushl  -0xc(%ebp)
801037ae:	e8 7b ff ff ff       	call   8010372e <sum>
801037b3:	83 c4 10             	add    $0x10,%esp
801037b6:	84 c0                	test   %al,%al
801037b8:	75 05                	jne    801037bf <mpsearch1+0x59>
      return (struct mp*)p;
801037ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037bd:	eb 11                	jmp    801037d0 <mpsearch1+0x6a>
  for(p = addr; p < e; p += sizeof(struct mp))
801037bf:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801037c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801037c9:	72 c2                	jb     8010378d <mpsearch1+0x27>
  return 0;
801037cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801037d0:	c9                   	leave  
801037d1:	c3                   	ret    

801037d2 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801037d2:	55                   	push   %ebp
801037d3:	89 e5                	mov    %esp,%ebp
801037d5:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801037d8:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801037df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037e2:	83 c0 0f             	add    $0xf,%eax
801037e5:	0f b6 00             	movzbl (%eax),%eax
801037e8:	0f b6 c0             	movzbl %al,%eax
801037eb:	c1 e0 08             	shl    $0x8,%eax
801037ee:	89 c2                	mov    %eax,%edx
801037f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037f3:	83 c0 0e             	add    $0xe,%eax
801037f6:	0f b6 00             	movzbl (%eax),%eax
801037f9:	0f b6 c0             	movzbl %al,%eax
801037fc:	09 d0                	or     %edx,%eax
801037fe:	c1 e0 04             	shl    $0x4,%eax
80103801:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103804:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103808:	74 21                	je     8010382b <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
8010380a:	83 ec 08             	sub    $0x8,%esp
8010380d:	68 00 04 00 00       	push   $0x400
80103812:	ff 75 f0             	pushl  -0x10(%ebp)
80103815:	e8 4c ff ff ff       	call   80103766 <mpsearch1>
8010381a:	83 c4 10             	add    $0x10,%esp
8010381d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103820:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103824:	74 51                	je     80103877 <mpsearch+0xa5>
      return mp;
80103826:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103829:	eb 61                	jmp    8010388c <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
8010382b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010382e:	83 c0 14             	add    $0x14,%eax
80103831:	0f b6 00             	movzbl (%eax),%eax
80103834:	0f b6 c0             	movzbl %al,%eax
80103837:	c1 e0 08             	shl    $0x8,%eax
8010383a:	89 c2                	mov    %eax,%edx
8010383c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010383f:	83 c0 13             	add    $0x13,%eax
80103842:	0f b6 00             	movzbl (%eax),%eax
80103845:	0f b6 c0             	movzbl %al,%eax
80103848:	09 d0                	or     %edx,%eax
8010384a:	c1 e0 0a             	shl    $0xa,%eax
8010384d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103850:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103853:	2d 00 04 00 00       	sub    $0x400,%eax
80103858:	83 ec 08             	sub    $0x8,%esp
8010385b:	68 00 04 00 00       	push   $0x400
80103860:	50                   	push   %eax
80103861:	e8 00 ff ff ff       	call   80103766 <mpsearch1>
80103866:	83 c4 10             	add    $0x10,%esp
80103869:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010386c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103870:	74 05                	je     80103877 <mpsearch+0xa5>
      return mp;
80103872:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103875:	eb 15                	jmp    8010388c <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103877:	83 ec 08             	sub    $0x8,%esp
8010387a:	68 00 00 01 00       	push   $0x10000
8010387f:	68 00 00 0f 00       	push   $0xf0000
80103884:	e8 dd fe ff ff       	call   80103766 <mpsearch1>
80103889:	83 c4 10             	add    $0x10,%esp
}
8010388c:	c9                   	leave  
8010388d:	c3                   	ret    

8010388e <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
8010388e:	55                   	push   %ebp
8010388f:	89 e5                	mov    %esp,%ebp
80103891:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103894:	e8 39 ff ff ff       	call   801037d2 <mpsearch>
80103899:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010389c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801038a0:	74 0a                	je     801038ac <mpconfig+0x1e>
801038a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038a5:	8b 40 04             	mov    0x4(%eax),%eax
801038a8:	85 c0                	test   %eax,%eax
801038aa:	75 0a                	jne    801038b6 <mpconfig+0x28>
    return 0;
801038ac:	b8 00 00 00 00       	mov    $0x0,%eax
801038b1:	e9 81 00 00 00       	jmp    80103937 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801038b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038b9:	8b 40 04             	mov    0x4(%eax),%eax
801038bc:	83 ec 0c             	sub    $0xc,%esp
801038bf:	50                   	push   %eax
801038c0:	e8 06 fe ff ff       	call   801036cb <p2v>
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801038cb:	83 ec 04             	sub    $0x4,%esp
801038ce:	6a 04                	push   $0x4
801038d0:	68 21 88 10 80       	push   $0x80108821
801038d5:	ff 75 f0             	pushl  -0x10(%ebp)
801038d8:	e8 c8 19 00 00       	call   801052a5 <memcmp>
801038dd:	83 c4 10             	add    $0x10,%esp
801038e0:	85 c0                	test   %eax,%eax
801038e2:	74 07                	je     801038eb <mpconfig+0x5d>
    return 0;
801038e4:	b8 00 00 00 00       	mov    $0x0,%eax
801038e9:	eb 4c                	jmp    80103937 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
801038eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ee:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801038f2:	3c 01                	cmp    $0x1,%al
801038f4:	74 12                	je     80103908 <mpconfig+0x7a>
801038f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038f9:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801038fd:	3c 04                	cmp    $0x4,%al
801038ff:	74 07                	je     80103908 <mpconfig+0x7a>
    return 0;
80103901:	b8 00 00 00 00       	mov    $0x0,%eax
80103906:	eb 2f                	jmp    80103937 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103908:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010390b:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010390f:	0f b7 c0             	movzwl %ax,%eax
80103912:	83 ec 08             	sub    $0x8,%esp
80103915:	50                   	push   %eax
80103916:	ff 75 f0             	pushl  -0x10(%ebp)
80103919:	e8 10 fe ff ff       	call   8010372e <sum>
8010391e:	83 c4 10             	add    $0x10,%esp
80103921:	84 c0                	test   %al,%al
80103923:	74 07                	je     8010392c <mpconfig+0x9e>
    return 0;
80103925:	b8 00 00 00 00       	mov    $0x0,%eax
8010392a:	eb 0b                	jmp    80103937 <mpconfig+0xa9>
  *pmp = mp;
8010392c:	8b 45 08             	mov    0x8(%ebp),%eax
8010392f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103932:	89 10                	mov    %edx,(%eax)
  return conf;
80103934:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103937:	c9                   	leave  
80103938:	c3                   	ret    

80103939 <mpinit>:

void
mpinit(void)
{
80103939:	55                   	push   %ebp
8010393a:	89 e5                	mov    %esp,%ebp
8010393c:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
8010393f:	c7 05 0c ef 10 80 20 	movl   $0x8010e920,0x8010ef0c
80103946:	e9 10 80 
  if((conf = mpconfig(&mp)) == 0)
80103949:	83 ec 0c             	sub    $0xc,%esp
8010394c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010394f:	50                   	push   %eax
80103950:	e8 39 ff ff ff       	call   8010388e <mpconfig>
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010395b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010395f:	0f 84 ba 01 00 00    	je     80103b1f <mpinit+0x1e6>
    return;
  ismp = 1;
80103965:	c7 05 00 ef 10 80 01 	movl   $0x1,0x8010ef00
8010396c:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010396f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103972:	8b 40 24             	mov    0x24(%eax),%eax
80103975:	a3 80 e8 10 80       	mov    %eax,0x8010e880
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010397a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010397d:	83 c0 2c             	add    $0x2c,%eax
80103980:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103983:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103986:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010398a:	0f b7 d0             	movzwl %ax,%edx
8010398d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103990:	01 d0                	add    %edx,%eax
80103992:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103995:	e9 16 01 00 00       	jmp    80103ab0 <mpinit+0x177>
    switch(*p){
8010399a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010399d:	0f b6 00             	movzbl (%eax),%eax
801039a0:	0f b6 c0             	movzbl %al,%eax
801039a3:	83 f8 04             	cmp    $0x4,%eax
801039a6:	0f 8f e0 00 00 00    	jg     80103a8c <mpinit+0x153>
801039ac:	83 f8 03             	cmp    $0x3,%eax
801039af:	0f 8d d1 00 00 00    	jge    80103a86 <mpinit+0x14d>
801039b5:	83 f8 02             	cmp    $0x2,%eax
801039b8:	0f 84 b0 00 00 00    	je     80103a6e <mpinit+0x135>
801039be:	83 f8 02             	cmp    $0x2,%eax
801039c1:	0f 8f c5 00 00 00    	jg     80103a8c <mpinit+0x153>
801039c7:	85 c0                	test   %eax,%eax
801039c9:	74 0e                	je     801039d9 <mpinit+0xa0>
801039cb:	83 f8 01             	cmp    $0x1,%eax
801039ce:	0f 84 b2 00 00 00    	je     80103a86 <mpinit+0x14d>
801039d4:	e9 b3 00 00 00       	jmp    80103a8c <mpinit+0x153>
    case MPPROC:
      proc = (struct mpproc*)p;
801039d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu != proc->apicid){
801039df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039e2:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801039e6:	0f b6 d0             	movzbl %al,%edx
801039e9:	a1 04 ef 10 80       	mov    0x8010ef04,%eax
801039ee:	39 c2                	cmp    %eax,%edx
801039f0:	74 2b                	je     80103a1d <mpinit+0xe4>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801039f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039f5:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801039f9:	0f b6 d0             	movzbl %al,%edx
801039fc:	a1 04 ef 10 80       	mov    0x8010ef04,%eax
80103a01:	83 ec 04             	sub    $0x4,%esp
80103a04:	52                   	push   %edx
80103a05:	50                   	push   %eax
80103a06:	68 26 88 10 80       	push   $0x80108826
80103a0b:	e8 b6 c9 ff ff       	call   801003c6 <cprintf>
80103a10:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103a13:	c7 05 00 ef 10 80 00 	movl   $0x0,0x8010ef00
80103a1a:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a20:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103a24:	0f b6 c0             	movzbl %al,%eax
80103a27:	83 e0 02             	and    $0x2,%eax
80103a2a:	85 c0                	test   %eax,%eax
80103a2c:	74 15                	je     80103a43 <mpinit+0x10a>
        bcpu = &cpus[ncpu];
80103a2e:	a1 04 ef 10 80       	mov    0x8010ef04,%eax
80103a33:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a39:	05 20 e9 10 80       	add    $0x8010e920,%eax
80103a3e:	a3 0c ef 10 80       	mov    %eax,0x8010ef0c
      cpus[ncpu].id = ncpu;
80103a43:	8b 15 04 ef 10 80    	mov    0x8010ef04,%edx
80103a49:	a1 04 ef 10 80       	mov    0x8010ef04,%eax
80103a4e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a54:	05 20 e9 10 80       	add    $0x8010e920,%eax
80103a59:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103a5b:	a1 04 ef 10 80       	mov    0x8010ef04,%eax
80103a60:	83 c0 01             	add    $0x1,%eax
80103a63:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
      p += sizeof(struct mpproc);
80103a68:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103a6c:	eb 42                	jmp    80103ab0 <mpinit+0x177>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a71:	89 45 e8             	mov    %eax,-0x18(%ebp)
      ioapicid = ioapic->apicno;
80103a74:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103a77:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103a7b:	a2 08 ef 10 80       	mov    %al,0x8010ef08
      p += sizeof(struct mpioapic);
80103a80:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103a84:	eb 2a                	jmp    80103ab0 <mpinit+0x177>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103a86:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103a8a:	eb 24                	jmp    80103ab0 <mpinit+0x177>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a8f:	0f b6 00             	movzbl (%eax),%eax
80103a92:	0f b6 c0             	movzbl %al,%eax
80103a95:	83 ec 08             	sub    $0x8,%esp
80103a98:	50                   	push   %eax
80103a99:	68 44 88 10 80       	push   $0x80108844
80103a9e:	e8 23 c9 ff ff       	call   801003c6 <cprintf>
80103aa3:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103aa6:	c7 05 00 ef 10 80 00 	movl   $0x0,0x8010ef00
80103aad:	00 00 00 
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ab3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ab6:	0f 82 de fe ff ff    	jb     8010399a <mpinit+0x61>
    }
  }
  if(!ismp){
80103abc:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80103ac1:	85 c0                	test   %eax,%eax
80103ac3:	75 1d                	jne    80103ae2 <mpinit+0x1a9>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103ac5:	c7 05 04 ef 10 80 01 	movl   $0x1,0x8010ef04
80103acc:	00 00 00 
    lapic = 0;
80103acf:	c7 05 80 e8 10 80 00 	movl   $0x0,0x8010e880
80103ad6:	00 00 00 
    ioapicid = 0;
80103ad9:	c6 05 08 ef 10 80 00 	movb   $0x0,0x8010ef08
    return;
80103ae0:	eb 3e                	jmp    80103b20 <mpinit+0x1e7>
  }

  if(mp->imcrp){
80103ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ae5:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103ae9:	84 c0                	test   %al,%al
80103aeb:	74 33                	je     80103b20 <mpinit+0x1e7>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103aed:	83 ec 08             	sub    $0x8,%esp
80103af0:	6a 70                	push   $0x70
80103af2:	6a 22                	push   $0x22
80103af4:	e8 fc fb ff ff       	call   801036f5 <outb>
80103af9:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103afc:	83 ec 0c             	sub    $0xc,%esp
80103aff:	6a 23                	push   $0x23
80103b01:	e8 d2 fb ff ff       	call   801036d8 <inb>
80103b06:	83 c4 10             	add    $0x10,%esp
80103b09:	83 c8 01             	or     $0x1,%eax
80103b0c:	0f b6 c0             	movzbl %al,%eax
80103b0f:	83 ec 08             	sub    $0x8,%esp
80103b12:	50                   	push   %eax
80103b13:	6a 23                	push   $0x23
80103b15:	e8 db fb ff ff       	call   801036f5 <outb>
80103b1a:	83 c4 10             	add    $0x10,%esp
80103b1d:	eb 01                	jmp    80103b20 <mpinit+0x1e7>
    return;
80103b1f:	90                   	nop
  }
}
80103b20:	c9                   	leave  
80103b21:	c3                   	ret    

80103b22 <outb>:
{
80103b22:	55                   	push   %ebp
80103b23:	89 e5                	mov    %esp,%ebp
80103b25:	83 ec 08             	sub    $0x8,%esp
80103b28:	8b 45 08             	mov    0x8(%ebp),%eax
80103b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b2e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103b32:	89 d0                	mov    %edx,%eax
80103b34:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b37:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b3b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103b3f:	ee                   	out    %al,(%dx)
}
80103b40:	90                   	nop
80103b41:	c9                   	leave  
80103b42:	c3                   	ret    

80103b43 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103b43:	55                   	push   %ebp
80103b44:	89 e5                	mov    %esp,%ebp
80103b46:	83 ec 04             	sub    $0x4,%esp
80103b49:	8b 45 08             	mov    0x8(%ebp),%eax
80103b4c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103b50:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b54:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103b5a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b5e:	0f b6 c0             	movzbl %al,%eax
80103b61:	50                   	push   %eax
80103b62:	6a 21                	push   $0x21
80103b64:	e8 b9 ff ff ff       	call   80103b22 <outb>
80103b69:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103b6c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b70:	66 c1 e8 08          	shr    $0x8,%ax
80103b74:	0f b6 c0             	movzbl %al,%eax
80103b77:	50                   	push   %eax
80103b78:	68 a1 00 00 00       	push   $0xa1
80103b7d:	e8 a0 ff ff ff       	call   80103b22 <outb>
80103b82:	83 c4 08             	add    $0x8,%esp
}
80103b85:	90                   	nop
80103b86:	c9                   	leave  
80103b87:	c3                   	ret    

80103b88 <picenable>:

void
picenable(int irq)
{
80103b88:	55                   	push   %ebp
80103b89:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103b8e:	ba 01 00 00 00       	mov    $0x1,%edx
80103b93:	89 c1                	mov    %eax,%ecx
80103b95:	d3 e2                	shl    %cl,%edx
80103b97:	89 d0                	mov    %edx,%eax
80103b99:	f7 d0                	not    %eax
80103b9b:	89 c2                	mov    %eax,%edx
80103b9d:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103ba4:	21 d0                	and    %edx,%eax
80103ba6:	0f b7 c0             	movzwl %ax,%eax
80103ba9:	50                   	push   %eax
80103baa:	e8 94 ff ff ff       	call   80103b43 <picsetmask>
80103baf:	83 c4 04             	add    $0x4,%esp
}
80103bb2:	90                   	nop
80103bb3:	c9                   	leave  
80103bb4:	c3                   	ret    

80103bb5 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103bb5:	55                   	push   %ebp
80103bb6:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103bb8:	68 ff 00 00 00       	push   $0xff
80103bbd:	6a 21                	push   $0x21
80103bbf:	e8 5e ff ff ff       	call   80103b22 <outb>
80103bc4:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103bc7:	68 ff 00 00 00       	push   $0xff
80103bcc:	68 a1 00 00 00       	push   $0xa1
80103bd1:	e8 4c ff ff ff       	call   80103b22 <outb>
80103bd6:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103bd9:	6a 11                	push   $0x11
80103bdb:	6a 20                	push   $0x20
80103bdd:	e8 40 ff ff ff       	call   80103b22 <outb>
80103be2:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103be5:	6a 20                	push   $0x20
80103be7:	6a 21                	push   $0x21
80103be9:	e8 34 ff ff ff       	call   80103b22 <outb>
80103bee:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103bf1:	6a 04                	push   $0x4
80103bf3:	6a 21                	push   $0x21
80103bf5:	e8 28 ff ff ff       	call   80103b22 <outb>
80103bfa:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103bfd:	6a 03                	push   $0x3
80103bff:	6a 21                	push   $0x21
80103c01:	e8 1c ff ff ff       	call   80103b22 <outb>
80103c06:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103c09:	6a 11                	push   $0x11
80103c0b:	68 a0 00 00 00       	push   $0xa0
80103c10:	e8 0d ff ff ff       	call   80103b22 <outb>
80103c15:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103c18:	6a 28                	push   $0x28
80103c1a:	68 a1 00 00 00       	push   $0xa1
80103c1f:	e8 fe fe ff ff       	call   80103b22 <outb>
80103c24:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103c27:	6a 02                	push   $0x2
80103c29:	68 a1 00 00 00       	push   $0xa1
80103c2e:	e8 ef fe ff ff       	call   80103b22 <outb>
80103c33:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103c36:	6a 03                	push   $0x3
80103c38:	68 a1 00 00 00       	push   $0xa1
80103c3d:	e8 e0 fe ff ff       	call   80103b22 <outb>
80103c42:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103c45:	6a 68                	push   $0x68
80103c47:	6a 20                	push   $0x20
80103c49:	e8 d4 fe ff ff       	call   80103b22 <outb>
80103c4e:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103c51:	6a 0a                	push   $0xa
80103c53:	6a 20                	push   $0x20
80103c55:	e8 c8 fe ff ff       	call   80103b22 <outb>
80103c5a:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103c5d:	6a 68                	push   $0x68
80103c5f:	68 a0 00 00 00       	push   $0xa0
80103c64:	e8 b9 fe ff ff       	call   80103b22 <outb>
80103c69:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103c6c:	6a 0a                	push   $0xa
80103c6e:	68 a0 00 00 00       	push   $0xa0
80103c73:	e8 aa fe ff ff       	call   80103b22 <outb>
80103c78:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103c7b:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c82:	66 83 f8 ff          	cmp    $0xffff,%ax
80103c86:	74 13                	je     80103c9b <picinit+0xe6>
    picsetmask(irqmask);
80103c88:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c8f:	0f b7 c0             	movzwl %ax,%eax
80103c92:	50                   	push   %eax
80103c93:	e8 ab fe ff ff       	call   80103b43 <picsetmask>
80103c98:	83 c4 04             	add    $0x4,%esp
}
80103c9b:	90                   	nop
80103c9c:	c9                   	leave  
80103c9d:	c3                   	ret    

80103c9e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c9e:	55                   	push   %ebp
80103c9f:	89 e5                	mov    %esp,%ebp
80103ca1:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103ca4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103cab:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cb7:	8b 10                	mov    (%eax),%edx
80103cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80103cbc:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103cbe:	e8 d5 d2 ff ff       	call   80100f98 <filealloc>
80103cc3:	8b 55 08             	mov    0x8(%ebp),%edx
80103cc6:	89 02                	mov    %eax,(%edx)
80103cc8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ccb:	8b 00                	mov    (%eax),%eax
80103ccd:	85 c0                	test   %eax,%eax
80103ccf:	0f 84 c8 00 00 00    	je     80103d9d <pipealloc+0xff>
80103cd5:	e8 be d2 ff ff       	call   80100f98 <filealloc>
80103cda:	8b 55 0c             	mov    0xc(%ebp),%edx
80103cdd:	89 02                	mov    %eax,(%edx)
80103cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ce2:	8b 00                	mov    (%eax),%eax
80103ce4:	85 c0                	test   %eax,%eax
80103ce6:	0f 84 b1 00 00 00    	je     80103d9d <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103cec:	e8 ea ee ff ff       	call   80102bdb <kalloc>
80103cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cf8:	0f 84 a2 00 00 00    	je     80103da0 <pipealloc+0x102>
    goto bad;
  p->readopen = 1;
80103cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d01:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d08:	00 00 00 
  p->writeopen = 1;
80103d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d0e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d15:	00 00 00 
  p->nwrite = 0;
80103d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d1b:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d22:	00 00 00 
  p->nread = 0;
80103d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d28:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d2f:	00 00 00 
  initlock(&p->lock, "pipe");
80103d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d35:	83 ec 08             	sub    $0x8,%esp
80103d38:	68 64 88 10 80       	push   $0x80108864
80103d3d:	50                   	push   %eax
80103d3e:	e8 76 12 00 00       	call   80104fb9 <initlock>
80103d43:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103d46:	8b 45 08             	mov    0x8(%ebp),%eax
80103d49:	8b 00                	mov    (%eax),%eax
80103d4b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d51:	8b 45 08             	mov    0x8(%ebp),%eax
80103d54:	8b 00                	mov    (%eax),%eax
80103d56:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d5a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d5d:	8b 00                	mov    (%eax),%eax
80103d5f:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d63:	8b 45 08             	mov    0x8(%ebp),%eax
80103d66:	8b 00                	mov    (%eax),%eax
80103d68:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d6b:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d71:	8b 00                	mov    (%eax),%eax
80103d73:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d79:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d7c:	8b 00                	mov    (%eax),%eax
80103d7e:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d82:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d85:	8b 00                	mov    (%eax),%eax
80103d87:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d8e:	8b 00                	mov    (%eax),%eax
80103d90:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d93:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103d96:	b8 00 00 00 00       	mov    $0x0,%eax
80103d9b:	eb 51                	jmp    80103dee <pipealloc+0x150>
    goto bad;
80103d9d:	90                   	nop
80103d9e:	eb 01                	jmp    80103da1 <pipealloc+0x103>
    goto bad;
80103da0:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
80103da1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103da5:	74 0e                	je     80103db5 <pipealloc+0x117>
    kfree((char*)p);
80103da7:	83 ec 0c             	sub    $0xc,%esp
80103daa:	ff 75 f4             	pushl  -0xc(%ebp)
80103dad:	e8 8c ed ff ff       	call   80102b3e <kfree>
80103db2:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103db5:	8b 45 08             	mov    0x8(%ebp),%eax
80103db8:	8b 00                	mov    (%eax),%eax
80103dba:	85 c0                	test   %eax,%eax
80103dbc:	74 11                	je     80103dcf <pipealloc+0x131>
    fileclose(*f0);
80103dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc1:	8b 00                	mov    (%eax),%eax
80103dc3:	83 ec 0c             	sub    $0xc,%esp
80103dc6:	50                   	push   %eax
80103dc7:	e8 8a d2 ff ff       	call   80101056 <fileclose>
80103dcc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dd2:	8b 00                	mov    (%eax),%eax
80103dd4:	85 c0                	test   %eax,%eax
80103dd6:	74 11                	je     80103de9 <pipealloc+0x14b>
    fileclose(*f1);
80103dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ddb:	8b 00                	mov    (%eax),%eax
80103ddd:	83 ec 0c             	sub    $0xc,%esp
80103de0:	50                   	push   %eax
80103de1:	e8 70 d2 ff ff       	call   80101056 <fileclose>
80103de6:	83 c4 10             	add    $0x10,%esp
  return -1;
80103de9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103dee:	c9                   	leave  
80103def:	c3                   	ret    

80103df0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80103df6:	8b 45 08             	mov    0x8(%ebp),%eax
80103df9:	83 ec 0c             	sub    $0xc,%esp
80103dfc:	50                   	push   %eax
80103dfd:	e8 d9 11 00 00       	call   80104fdb <acquire>
80103e02:	83 c4 10             	add    $0x10,%esp
  if(writable){
80103e05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103e09:	74 23                	je     80103e2e <pipeclose+0x3e>
    p->writeopen = 0;
80103e0b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e0e:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103e15:	00 00 00 
    wakeup(&p->nread);
80103e18:	8b 45 08             	mov    0x8(%ebp),%eax
80103e1b:	05 34 02 00 00       	add    $0x234,%eax
80103e20:	83 ec 0c             	sub    $0xc,%esp
80103e23:	50                   	push   %eax
80103e24:	e8 82 0c 00 00       	call   80104aab <wakeup>
80103e29:	83 c4 10             	add    $0x10,%esp
80103e2c:	eb 21                	jmp    80103e4f <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80103e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e31:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103e38:	00 00 00 
    wakeup(&p->nwrite);
80103e3b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3e:	05 38 02 00 00       	add    $0x238,%eax
80103e43:	83 ec 0c             	sub    $0xc,%esp
80103e46:	50                   	push   %eax
80103e47:	e8 5f 0c 00 00       	call   80104aab <wakeup>
80103e4c:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e4f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e52:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e58:	85 c0                	test   %eax,%eax
80103e5a:	75 2c                	jne    80103e88 <pipeclose+0x98>
80103e5c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e5f:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103e65:	85 c0                	test   %eax,%eax
80103e67:	75 1f                	jne    80103e88 <pipeclose+0x98>
    release(&p->lock);
80103e69:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6c:	83 ec 0c             	sub    $0xc,%esp
80103e6f:	50                   	push   %eax
80103e70:	e8 cd 11 00 00       	call   80105042 <release>
80103e75:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80103e78:	83 ec 0c             	sub    $0xc,%esp
80103e7b:	ff 75 08             	pushl  0x8(%ebp)
80103e7e:	e8 bb ec ff ff       	call   80102b3e <kfree>
80103e83:	83 c4 10             	add    $0x10,%esp
80103e86:	eb 10                	jmp    80103e98 <pipeclose+0xa8>
  } else
    release(&p->lock);
80103e88:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8b:	83 ec 0c             	sub    $0xc,%esp
80103e8e:	50                   	push   %eax
80103e8f:	e8 ae 11 00 00       	call   80105042 <release>
80103e94:	83 c4 10             	add    $0x10,%esp
}
80103e97:	90                   	nop
80103e98:	90                   	nop
80103e99:	c9                   	leave  
80103e9a:	c3                   	ret    

80103e9b <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e9b:	55                   	push   %ebp
80103e9c:	89 e5                	mov    %esp,%ebp
80103e9e:	53                   	push   %ebx
80103e9f:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80103ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea5:	83 ec 0c             	sub    $0xc,%esp
80103ea8:	50                   	push   %eax
80103ea9:	e8 2d 11 00 00       	call   80104fdb <acquire>
80103eae:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80103eb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103eb8:	e9 ae 00 00 00       	jmp    80103f6b <pipewrite+0xd0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec0:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103ec6:	85 c0                	test   %eax,%eax
80103ec8:	74 0d                	je     80103ed7 <pipewrite+0x3c>
80103eca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ed0:	8b 40 24             	mov    0x24(%eax),%eax
80103ed3:	85 c0                	test   %eax,%eax
80103ed5:	74 19                	je     80103ef0 <pipewrite+0x55>
        release(&p->lock);
80103ed7:	8b 45 08             	mov    0x8(%ebp),%eax
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	50                   	push   %eax
80103ede:	e8 5f 11 00 00       	call   80105042 <release>
80103ee3:	83 c4 10             	add    $0x10,%esp
        return -1;
80103ee6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103eeb:	e9 a9 00 00 00       	jmp    80103f99 <pipewrite+0xfe>
      }
      wakeup(&p->nread);
80103ef0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef3:	05 34 02 00 00       	add    $0x234,%eax
80103ef8:	83 ec 0c             	sub    $0xc,%esp
80103efb:	50                   	push   %eax
80103efc:	e8 aa 0b 00 00       	call   80104aab <wakeup>
80103f01:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f04:	8b 45 08             	mov    0x8(%ebp),%eax
80103f07:	8b 55 08             	mov    0x8(%ebp),%edx
80103f0a:	81 c2 38 02 00 00    	add    $0x238,%edx
80103f10:	83 ec 08             	sub    $0x8,%esp
80103f13:	50                   	push   %eax
80103f14:	52                   	push   %edx
80103f15:	e8 a2 0a 00 00       	call   801049bc <sleep>
80103f1a:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f1d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f20:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103f26:	8b 45 08             	mov    0x8(%ebp),%eax
80103f29:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f2f:	05 00 02 00 00       	add    $0x200,%eax
80103f34:	39 c2                	cmp    %eax,%edx
80103f36:	74 85                	je     80103ebd <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f38:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f3e:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80103f41:	8b 45 08             	mov    0x8(%ebp),%eax
80103f44:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f4a:	8d 48 01             	lea    0x1(%eax),%ecx
80103f4d:	8b 55 08             	mov    0x8(%ebp),%edx
80103f50:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103f56:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f5b:	89 c1                	mov    %eax,%ecx
80103f5d:	0f b6 13             	movzbl (%ebx),%edx
80103f60:	8b 45 08             	mov    0x8(%ebp),%eax
80103f63:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80103f67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f6e:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f71:	7c aa                	jl     80103f1d <pipewrite+0x82>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f73:	8b 45 08             	mov    0x8(%ebp),%eax
80103f76:	05 34 02 00 00       	add    $0x234,%eax
80103f7b:	83 ec 0c             	sub    $0xc,%esp
80103f7e:	50                   	push   %eax
80103f7f:	e8 27 0b 00 00       	call   80104aab <wakeup>
80103f84:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103f87:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8a:	83 ec 0c             	sub    $0xc,%esp
80103f8d:	50                   	push   %eax
80103f8e:	e8 af 10 00 00       	call   80105042 <release>
80103f93:	83 c4 10             	add    $0x10,%esp
  return n;
80103f96:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103f99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f9c:	c9                   	leave  
80103f9d:	c3                   	ret    

80103f9e <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f9e:	55                   	push   %ebp
80103f9f:	89 e5                	mov    %esp,%ebp
80103fa1:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80103fa4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa7:	83 ec 0c             	sub    $0xc,%esp
80103faa:	50                   	push   %eax
80103fab:	e8 2b 10 00 00       	call   80104fdb <acquire>
80103fb0:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fb3:	eb 3f                	jmp    80103ff4 <piperead+0x56>
    if(proc->killed){
80103fb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103fbb:	8b 40 24             	mov    0x24(%eax),%eax
80103fbe:	85 c0                	test   %eax,%eax
80103fc0:	74 19                	je     80103fdb <piperead+0x3d>
      release(&p->lock);
80103fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc5:	83 ec 0c             	sub    $0xc,%esp
80103fc8:	50                   	push   %eax
80103fc9:	e8 74 10 00 00       	call   80105042 <release>
80103fce:	83 c4 10             	add    $0x10,%esp
      return -1;
80103fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fd6:	e9 be 00 00 00       	jmp    80104099 <piperead+0xfb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fde:	8b 55 08             	mov    0x8(%ebp),%edx
80103fe1:	81 c2 34 02 00 00    	add    $0x234,%edx
80103fe7:	83 ec 08             	sub    $0x8,%esp
80103fea:	50                   	push   %eax
80103feb:	52                   	push   %edx
80103fec:	e8 cb 09 00 00       	call   801049bc <sleep>
80103ff1:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ff4:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff7:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80104000:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104006:	39 c2                	cmp    %eax,%edx
80104008:	75 0d                	jne    80104017 <piperead+0x79>
8010400a:	8b 45 08             	mov    0x8(%ebp),%eax
8010400d:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104013:	85 c0                	test   %eax,%eax
80104015:	75 9e                	jne    80103fb5 <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104017:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010401e:	eb 48                	jmp    80104068 <piperead+0xca>
    if(p->nread == p->nwrite)
80104020:	8b 45 08             	mov    0x8(%ebp),%eax
80104023:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104029:	8b 45 08             	mov    0x8(%ebp),%eax
8010402c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104032:	39 c2                	cmp    %eax,%edx
80104034:	74 3c                	je     80104072 <piperead+0xd4>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104036:	8b 45 08             	mov    0x8(%ebp),%eax
80104039:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010403f:	8d 48 01             	lea    0x1(%eax),%ecx
80104042:	8b 55 08             	mov    0x8(%ebp),%edx
80104045:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010404b:	25 ff 01 00 00       	and    $0x1ff,%eax
80104050:	89 c1                	mov    %eax,%ecx
80104052:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104055:	8b 45 0c             	mov    0xc(%ebp),%eax
80104058:	01 c2                	add    %eax,%edx
8010405a:	8b 45 08             	mov    0x8(%ebp),%eax
8010405d:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
80104062:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104064:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104068:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010406e:	7c b0                	jl     80104020 <piperead+0x82>
80104070:	eb 01                	jmp    80104073 <piperead+0xd5>
      break;
80104072:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104073:	8b 45 08             	mov    0x8(%ebp),%eax
80104076:	05 38 02 00 00       	add    $0x238,%eax
8010407b:	83 ec 0c             	sub    $0xc,%esp
8010407e:	50                   	push   %eax
8010407f:	e8 27 0a 00 00       	call   80104aab <wakeup>
80104084:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104087:	8b 45 08             	mov    0x8(%ebp),%eax
8010408a:	83 ec 0c             	sub    $0xc,%esp
8010408d:	50                   	push   %eax
8010408e:	e8 af 0f 00 00       	call   80105042 <release>
80104093:	83 c4 10             	add    $0x10,%esp
  return i;
80104096:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104099:	c9                   	leave  
8010409a:	c3                   	ret    

8010409b <readeflags>:
{
8010409b:	55                   	push   %ebp
8010409c:	89 e5                	mov    %esp,%ebp
8010409e:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040a1:	9c                   	pushf  
801040a2:	58                   	pop    %eax
801040a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801040a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801040a9:	c9                   	leave  
801040aa:	c3                   	ret    

801040ab <sti>:
{
801040ab:	55                   	push   %ebp
801040ac:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801040ae:	fb                   	sti    
}
801040af:	90                   	nop
801040b0:	5d                   	pop    %ebp
801040b1:	c3                   	ret    

801040b2 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801040b2:	55                   	push   %ebp
801040b3:	89 e5                	mov    %esp,%ebp
801040b5:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801040b8:	83 ec 08             	sub    $0x8,%esp
801040bb:	68 69 88 10 80       	push   $0x80108869
801040c0:	68 20 ef 10 80       	push   $0x8010ef20
801040c5:	e8 ef 0e 00 00       	call   80104fb9 <initlock>
801040ca:	83 c4 10             	add    $0x10,%esp
}
801040cd:	90                   	nop
801040ce:	c9                   	leave  
801040cf:	c3                   	ret    

801040d0 <sem_alloc_proctable>:

// after a user space process calls sem_alloc record its usage in the process proc table
void sem_alloc_proctable(int sem){
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	83 ec 08             	sub    $0x8,%esp
	acquire(&ptable.lock);
801040d6:	83 ec 0c             	sub    $0xc,%esp
801040d9:	68 20 ef 10 80       	push   $0x8010ef20
801040de:	e8 f8 0e 00 00       	call   80104fdb <acquire>
801040e3:	83 c4 10             	add    $0x10,%esp
	proc->sem[sem] = 1;
801040e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801040ec:	8b 55 08             	mov    0x8(%ebp),%edx
801040ef:	83 c2 1c             	add    $0x1c,%edx
801040f2:	c7 44 90 0c 01 00 00 	movl   $0x1,0xc(%eax,%edx,4)
801040f9:	00 
	release(&ptable.lock);
801040fa:	83 ec 0c             	sub    $0xc,%esp
801040fd:	68 20 ef 10 80       	push   $0x8010ef20
80104102:	e8 3b 0f 00 00       	call   80105042 <release>
80104107:	83 c4 10             	add    $0x10,%esp
	return;
8010410a:	90                   	nop
}
8010410b:	c9                   	leave  
8010410c:	c3                   	ret    

8010410d <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010410d:	55                   	push   %ebp
8010410e:	89 e5                	mov    %esp,%ebp
80104110:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104113:	83 ec 0c             	sub    $0xc,%esp
80104116:	68 20 ef 10 80       	push   $0x8010ef20
8010411b:	e8 bb 0e 00 00       	call   80104fdb <acquire>
80104120:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104123:	c7 45 f4 54 ef 10 80 	movl   $0x8010ef54,-0xc(%ebp)
8010412a:	eb 11                	jmp    8010413d <allocproc+0x30>
    if(p->state == UNUSED)
8010412c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010412f:	8b 40 0c             	mov    0xc(%eax),%eax
80104132:	85 c0                	test   %eax,%eax
80104134:	74 2a                	je     80104160 <allocproc+0x53>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104136:	81 45 f4 cc 00 00 00 	addl   $0xcc,-0xc(%ebp)
8010413d:	81 7d f4 54 22 11 80 	cmpl   $0x80112254,-0xc(%ebp)
80104144:	72 e6                	jb     8010412c <allocproc+0x1f>
      goto found;
  release(&ptable.lock);
80104146:	83 ec 0c             	sub    $0xc,%esp
80104149:	68 20 ef 10 80       	push   $0x8010ef20
8010414e:	e8 ef 0e 00 00       	call   80105042 <release>
80104153:	83 c4 10             	add    $0x10,%esp
  return 0;
80104156:	b8 00 00 00 00       	mov    $0x0,%eax
8010415b:	e9 b2 00 00 00       	jmp    80104212 <allocproc+0x105>
      goto found;
80104160:	90                   	nop

found:
  p->state = EMBRYO;
80104161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104164:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010416b:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104170:	8d 50 01             	lea    0x1(%eax),%edx
80104173:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80104179:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010417c:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
8010417f:	83 ec 0c             	sub    $0xc,%esp
80104182:	68 20 ef 10 80       	push   $0x8010ef20
80104187:	e8 b6 0e 00 00       	call   80105042 <release>
8010418c:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010418f:	e8 47 ea ff ff       	call   80102bdb <kalloc>
80104194:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104197:	89 42 08             	mov    %eax,0x8(%edx)
8010419a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419d:	8b 40 08             	mov    0x8(%eax),%eax
801041a0:	85 c0                	test   %eax,%eax
801041a2:	75 11                	jne    801041b5 <allocproc+0xa8>
    p->state = UNUSED;
801041a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801041ae:	b8 00 00 00 00       	mov    $0x0,%eax
801041b3:	eb 5d                	jmp    80104212 <allocproc+0x105>
  }
  sp = p->kstack + KSTACKSIZE;
801041b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b8:	8b 40 08             	mov    0x8(%eax),%eax
801041bb:	05 00 10 00 00       	add    $0x1000,%eax
801041c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801041c3:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801041c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
801041cd:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801041d0:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801041d4:	ba e0 66 10 80       	mov    $0x801066e0,%edx
801041d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041dc:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801041de:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801041e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801041e8:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801041eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ee:	8b 40 1c             	mov    0x1c(%eax),%eax
801041f1:	83 ec 04             	sub    $0x4,%esp
801041f4:	6a 14                	push   $0x14
801041f6:	6a 00                	push   $0x0
801041f8:	50                   	push   %eax
801041f9:	e8 40 10 00 00       	call   8010523e <memset>
801041fe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104201:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104204:	8b 40 1c             	mov    0x1c(%eax),%eax
80104207:	ba 8b 49 10 80       	mov    $0x8010498b,%edx
8010420c:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010420f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104212:	c9                   	leave  
80104213:	c3                   	ret    

80104214 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104214:	55                   	push   %ebp
80104215:	89 e5                	mov    %esp,%ebp
80104217:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
8010421a:	e8 ee fe ff ff       	call   8010410d <allocproc>
8010421f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104222:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104225:	a3 54 22 11 80       	mov    %eax,0x80112254
  if((p->pgdir = setupkvm(kalloc)) == 0)
8010422a:	83 ec 0c             	sub    $0xc,%esp
8010422d:	68 db 2b 10 80       	push   $0x80102bdb
80104232:	e8 71 3b 00 00       	call   80107da8 <setupkvm>
80104237:	83 c4 10             	add    $0x10,%esp
8010423a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010423d:	89 42 04             	mov    %eax,0x4(%edx)
80104240:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104243:	8b 40 04             	mov    0x4(%eax),%eax
80104246:	85 c0                	test   %eax,%eax
80104248:	75 0d                	jne    80104257 <userinit+0x43>
    panic("userinit: out of memory?");
8010424a:	83 ec 0c             	sub    $0xc,%esp
8010424d:	68 70 88 10 80       	push   $0x80108870
80104252:	e8 24 c3 ff ff       	call   8010057b <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104257:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010425c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425f:	8b 40 04             	mov    0x4(%eax),%eax
80104262:	83 ec 04             	sub    $0x4,%esp
80104265:	52                   	push   %edx
80104266:	68 00 b5 10 80       	push   $0x8010b500
8010426b:	50                   	push   %eax
8010426c:	e8 92 3d 00 00       	call   80108003 <inituvm>
80104271:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104274:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104277:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010427d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104280:	8b 40 18             	mov    0x18(%eax),%eax
80104283:	83 ec 04             	sub    $0x4,%esp
80104286:	6a 4c                	push   $0x4c
80104288:	6a 00                	push   $0x0
8010428a:	50                   	push   %eax
8010428b:	e8 ae 0f 00 00       	call   8010523e <memset>
80104290:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104293:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104296:	8b 40 18             	mov    0x18(%eax),%eax
80104299:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010429f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a2:	8b 40 18             	mov    0x18(%eax),%eax
801042a5:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801042ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ae:	8b 50 18             	mov    0x18(%eax),%edx
801042b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b4:	8b 40 18             	mov    0x18(%eax),%eax
801042b7:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801042bb:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801042bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c2:	8b 50 18             	mov    0x18(%eax),%edx
801042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c8:	8b 40 18             	mov    0x18(%eax),%eax
801042cb:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801042cf:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801042d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d6:	8b 40 18             	mov    0x18(%eax),%eax
801042d9:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801042e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e3:	8b 40 18             	mov    0x18(%eax),%eax
801042e6:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801042ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f0:	8b 40 18             	mov    0x18(%eax),%eax
801042f3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801042fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042fd:	83 c0 6c             	add    $0x6c,%eax
80104300:	83 ec 04             	sub    $0x4,%esp
80104303:	6a 10                	push   $0x10
80104305:	68 89 88 10 80       	push   $0x80108889
8010430a:	50                   	push   %eax
8010430b:	e8 31 11 00 00       	call   80105441 <safestrcpy>
80104310:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104313:	83 ec 0c             	sub    $0xc,%esp
80104316:	68 92 88 10 80       	push   $0x80108892
8010431b:	e8 b6 e1 ff ff       	call   801024d6 <namei>
80104320:	83 c4 10             	add    $0x10,%esp
80104323:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104326:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104329:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104333:	90                   	nop
80104334:	c9                   	leave  
80104335:	c3                   	ret    

80104336 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104336:	55                   	push   %ebp
80104337:	89 e5                	mov    %esp,%ebp
80104339:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010433c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104342:	8b 00                	mov    (%eax),%eax
80104344:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104347:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010434b:	7e 31                	jle    8010437e <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010434d:	8b 55 08             	mov    0x8(%ebp),%edx
80104350:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104353:	01 c2                	add    %eax,%edx
80104355:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010435b:	8b 40 04             	mov    0x4(%eax),%eax
8010435e:	83 ec 04             	sub    $0x4,%esp
80104361:	52                   	push   %edx
80104362:	ff 75 f4             	pushl  -0xc(%ebp)
80104365:	50                   	push   %eax
80104366:	e8 e5 3d 00 00       	call   80108150 <allocuvm>
8010436b:	83 c4 10             	add    $0x10,%esp
8010436e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104375:	75 3e                	jne    801043b5 <growproc+0x7f>
      return -1;
80104377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010437c:	eb 59                	jmp    801043d7 <growproc+0xa1>
  } else if(n < 0){
8010437e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104382:	79 31                	jns    801043b5 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104384:	8b 55 08             	mov    0x8(%ebp),%edx
80104387:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010438a:	01 c2                	add    %eax,%edx
8010438c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104392:	8b 40 04             	mov    0x4(%eax),%eax
80104395:	83 ec 04             	sub    $0x4,%esp
80104398:	52                   	push   %edx
80104399:	ff 75 f4             	pushl  -0xc(%ebp)
8010439c:	50                   	push   %eax
8010439d:	e8 75 3e 00 00       	call   80108217 <deallocuvm>
801043a2:	83 c4 10             	add    $0x10,%esp
801043a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043ac:	75 07                	jne    801043b5 <growproc+0x7f>
      return -1;
801043ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043b3:	eb 22                	jmp    801043d7 <growproc+0xa1>
  }
  proc->sz = sz;
801043b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043be:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801043c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043c6:	83 ec 0c             	sub    $0xc,%esp
801043c9:	50                   	push   %eax
801043ca:	e8 c0 3a 00 00       	call   80107e8f <switchuvm>
801043cf:	83 c4 10             	add    $0x10,%esp
  return 0;
801043d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801043d7:	c9                   	leave  
801043d8:	c3                   	ret    

801043d9 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801043d9:	55                   	push   %ebp
801043da:	89 e5                	mov    %esp,%ebp
801043dc:	57                   	push   %edi
801043dd:	56                   	push   %esi
801043de:	53                   	push   %ebx
801043df:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801043e2:	e8 26 fd ff ff       	call   8010410d <allocproc>
801043e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801043ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801043ee:	75 0a                	jne    801043fa <fork+0x21>
    return -1;
801043f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043f5:	e9 44 01 00 00       	jmp    8010453e <fork+0x165>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801043fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104400:	8b 10                	mov    (%eax),%edx
80104402:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104408:	8b 40 04             	mov    0x4(%eax),%eax
8010440b:	83 ec 08             	sub    $0x8,%esp
8010440e:	52                   	push   %edx
8010440f:	50                   	push   %eax
80104410:	e8 a0 3f 00 00       	call   801083b5 <copyuvm>
80104415:	83 c4 10             	add    $0x10,%esp
80104418:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010441b:	89 42 04             	mov    %eax,0x4(%edx)
8010441e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104421:	8b 40 04             	mov    0x4(%eax),%eax
80104424:	85 c0                	test   %eax,%eax
80104426:	75 30                	jne    80104458 <fork+0x7f>
    kfree(np->kstack);
80104428:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010442b:	8b 40 08             	mov    0x8(%eax),%eax
8010442e:	83 ec 0c             	sub    $0xc,%esp
80104431:	50                   	push   %eax
80104432:	e8 07 e7 ff ff       	call   80102b3e <kfree>
80104437:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010443a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010443d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104444:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104447:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010444e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104453:	e9 e6 00 00 00       	jmp    8010453e <fork+0x165>
  }
  np->sz = proc->sz;
80104458:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010445e:	8b 10                	mov    (%eax),%edx
80104460:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104463:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104465:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010446c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010446f:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104472:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104478:	8b 48 18             	mov    0x18(%eax),%ecx
8010447b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010447e:	8b 40 18             	mov    0x18(%eax),%eax
80104481:	89 c2                	mov    %eax,%edx
80104483:	89 cb                	mov    %ecx,%ebx
80104485:	b8 13 00 00 00       	mov    $0x13,%eax
8010448a:	89 d7                	mov    %edx,%edi
8010448c:	89 de                	mov    %ebx,%esi
8010448e:	89 c1                	mov    %eax,%ecx
80104490:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104492:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104495:	8b 40 18             	mov    0x18(%eax),%eax
80104498:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010449f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801044a6:	eb 41                	jmp    801044e9 <fork+0x110>
    if(proc->ofile[i])
801044a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801044b1:	83 c2 08             	add    $0x8,%edx
801044b4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044b8:	85 c0                	test   %eax,%eax
801044ba:	74 29                	je     801044e5 <fork+0x10c>
      np->ofile[i] = filedup(proc->ofile[i]);
801044bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801044c5:	83 c2 08             	add    $0x8,%edx
801044c8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044cc:	83 ec 0c             	sub    $0xc,%esp
801044cf:	50                   	push   %eax
801044d0:	e8 30 cb ff ff       	call   80101005 <filedup>
801044d5:	83 c4 10             	add    $0x10,%esp
801044d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801044db:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801044de:	83 c1 08             	add    $0x8,%ecx
801044e1:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
801044e5:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801044e9:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801044ed:	7e b9                	jle    801044a8 <fork+0xcf>
  np->cwd = idup(proc->cwd);
801044ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044f5:	8b 40 68             	mov    0x68(%eax),%eax
801044f8:	83 ec 0c             	sub    $0xc,%esp
801044fb:	50                   	push   %eax
801044fc:	e8 f0 d3 ff ff       	call   801018f1 <idup>
80104501:	83 c4 10             	add    $0x10,%esp
80104504:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104507:	89 42 68             	mov    %eax,0x68(%edx)
  pid = np->pid;
8010450a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010450d:	8b 40 10             	mov    0x10(%eax),%eax
80104510:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
80104513:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104516:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010451d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104523:	8d 50 6c             	lea    0x6c(%eax),%edx
80104526:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104529:	83 c0 6c             	add    $0x6c,%eax
8010452c:	83 ec 04             	sub    $0x4,%esp
8010452f:	6a 10                	push   $0x10
80104531:	52                   	push   %edx
80104532:	50                   	push   %eax
80104533:	e8 09 0f 00 00       	call   80105441 <safestrcpy>
80104538:	83 c4 10             	add    $0x10,%esp
  return pid;
8010453b:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
8010453e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104541:	5b                   	pop    %ebx
80104542:	5e                   	pop    %esi
80104543:	5f                   	pop    %edi
80104544:	5d                   	pop    %ebp
80104545:	c3                   	ret    

80104546 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104546:	55                   	push   %ebp
80104547:	89 e5                	mov    %esp,%ebp
80104549:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
8010454c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104553:	a1 54 22 11 80       	mov    0x80112254,%eax
80104558:	39 c2                	cmp    %eax,%edx
8010455a:	75 0d                	jne    80104569 <exit+0x23>
    panic("init exiting");
8010455c:	83 ec 0c             	sub    $0xc,%esp
8010455f:	68 94 88 10 80       	push   $0x80108894
80104564:	e8 12 c0 ff ff       	call   8010057b <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104569:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104570:	eb 48                	jmp    801045ba <exit+0x74>
    if(proc->ofile[fd]){
80104572:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104578:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010457b:	83 c2 08             	add    $0x8,%edx
8010457e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104582:	85 c0                	test   %eax,%eax
80104584:	74 30                	je     801045b6 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104586:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010458c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010458f:	83 c2 08             	add    $0x8,%edx
80104592:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104596:	83 ec 0c             	sub    $0xc,%esp
80104599:	50                   	push   %eax
8010459a:	e8 b7 ca ff ff       	call   80101056 <fileclose>
8010459f:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
801045a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045ab:	83 c2 08             	add    $0x8,%edx
801045ae:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801045b5:	00 
  for(fd = 0; fd < NOFILE; fd++){
801045b6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801045ba:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801045be:	7e b2                	jle    80104572 <exit+0x2c>
    }
  }

  iput(proc->cwd);
801045c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045c6:	8b 40 68             	mov    0x68(%eax),%eax
801045c9:	83 ec 0c             	sub    $0xc,%esp
801045cc:	50                   	push   %eax
801045cd:	e8 23 d5 ff ff       	call   80101af5 <iput>
801045d2:	83 c4 10             	add    $0x10,%esp
  proc->cwd = 0;
801045d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045db:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

	int i;
	for(i = 0; i < NSEM; i++){
801045e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801045e9:	eb 3f                	jmp    8010462a <exit+0xe4>
		if(proc->sem[i] == 1 && proc->parent->sem[i] != 1){
801045eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
801045f4:	83 c2 1c             	add    $0x1c,%edx
801045f7:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801045fb:	83 f8 01             	cmp    $0x1,%eax
801045fe:	75 26                	jne    80104626 <exit+0xe0>
80104600:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104606:	8b 40 14             	mov    0x14(%eax),%eax
80104609:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010460c:	83 c2 1c             	add    $0x1c,%edx
8010460f:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80104613:	83 f8 01             	cmp    $0x1,%eax
80104616:	74 0e                	je     80104626 <exit+0xe0>
			sem_destroy(i);
80104618:	83 ec 0c             	sub    $0xc,%esp
8010461b:	ff 75 ec             	pushl  -0x14(%ebp)
8010461e:	e8 0b 07 00 00       	call   80104d2e <sem_destroy>
80104623:	83 c4 10             	add    $0x10,%esp
	for(i = 0; i < NSEM; i++){
80104626:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010462a:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
8010462e:	7e bb                	jle    801045eb <exit+0xa5>
		} 
	}

  acquire(&ptable.lock);
80104630:	83 ec 0c             	sub    $0xc,%esp
80104633:	68 20 ef 10 80       	push   $0x8010ef20
80104638:	e8 9e 09 00 00       	call   80104fdb <acquire>
8010463d:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104640:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104646:	8b 40 14             	mov    0x14(%eax),%eax
80104649:	83 ec 0c             	sub    $0xc,%esp
8010464c:	50                   	push   %eax
8010464d:	e8 16 04 00 00       	call   80104a68 <wakeup1>
80104652:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104655:	c7 45 f4 54 ef 10 80 	movl   $0x8010ef54,-0xc(%ebp)
8010465c:	eb 3f                	jmp    8010469d <exit+0x157>
    if(p->parent == proc){
8010465e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104661:	8b 50 14             	mov    0x14(%eax),%edx
80104664:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010466a:	39 c2                	cmp    %eax,%edx
8010466c:	75 28                	jne    80104696 <exit+0x150>
      p->parent = initproc;
8010466e:	8b 15 54 22 11 80    	mov    0x80112254,%edx
80104674:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104677:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010467a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467d:	8b 40 0c             	mov    0xc(%eax),%eax
80104680:	83 f8 05             	cmp    $0x5,%eax
80104683:	75 11                	jne    80104696 <exit+0x150>
        wakeup1(initproc);
80104685:	a1 54 22 11 80       	mov    0x80112254,%eax
8010468a:	83 ec 0c             	sub    $0xc,%esp
8010468d:	50                   	push   %eax
8010468e:	e8 d5 03 00 00       	call   80104a68 <wakeup1>
80104693:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104696:	81 45 f4 cc 00 00 00 	addl   $0xcc,-0xc(%ebp)
8010469d:	81 7d f4 54 22 11 80 	cmpl   $0x80112254,-0xc(%ebp)
801046a4:	72 b8                	jb     8010465e <exit+0x118>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801046a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ac:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801046b3:	e8 dc 01 00 00       	call   80104894 <sched>
  panic("zombie exit");
801046b8:	83 ec 0c             	sub    $0xc,%esp
801046bb:	68 a1 88 10 80       	push   $0x801088a1
801046c0:	e8 b6 be ff ff       	call   8010057b <panic>

801046c5 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801046c5:	55                   	push   %ebp
801046c6:	89 e5                	mov    %esp,%ebp
801046c8:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801046cb:	83 ec 0c             	sub    $0xc,%esp
801046ce:	68 20 ef 10 80       	push   $0x8010ef20
801046d3:	e8 03 09 00 00       	call   80104fdb <acquire>
801046d8:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801046db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046e2:	c7 45 f4 54 ef 10 80 	movl   $0x8010ef54,-0xc(%ebp)
801046e9:	e9 a9 00 00 00       	jmp    80104797 <wait+0xd2>
      if(p->parent != proc)
801046ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f1:	8b 50 14             	mov    0x14(%eax),%edx
801046f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046fa:	39 c2                	cmp    %eax,%edx
801046fc:	0f 85 8d 00 00 00    	jne    8010478f <wait+0xca>
        continue;
      havekids = 1;
80104702:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010470c:	8b 40 0c             	mov    0xc(%eax),%eax
8010470f:	83 f8 05             	cmp    $0x5,%eax
80104712:	75 7c                	jne    80104790 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104714:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104717:	8b 40 10             	mov    0x10(%eax),%eax
8010471a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
8010471d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104720:	8b 40 08             	mov    0x8(%eax),%eax
80104723:	83 ec 0c             	sub    $0xc,%esp
80104726:	50                   	push   %eax
80104727:	e8 12 e4 ff ff       	call   80102b3e <kfree>
8010472c:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
8010472f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104732:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104739:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010473c:	8b 40 04             	mov    0x4(%eax),%eax
8010473f:	83 ec 0c             	sub    $0xc,%esp
80104742:	50                   	push   %eax
80104743:	e8 8c 3b 00 00       	call   801082d4 <freevm>
80104748:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
8010474b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104755:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104758:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010475f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104762:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104769:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476c:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104773:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
8010477a:	83 ec 0c             	sub    $0xc,%esp
8010477d:	68 20 ef 10 80       	push   $0x8010ef20
80104782:	e8 bb 08 00 00       	call   80105042 <release>
80104787:	83 c4 10             	add    $0x10,%esp
        return pid;
8010478a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010478d:	eb 5b                	jmp    801047ea <wait+0x125>
        continue;
8010478f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104790:	81 45 f4 cc 00 00 00 	addl   $0xcc,-0xc(%ebp)
80104797:	81 7d f4 54 22 11 80 	cmpl   $0x80112254,-0xc(%ebp)
8010479e:	0f 82 4a ff ff ff    	jb     801046ee <wait+0x29>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801047a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801047a8:	74 0d                	je     801047b7 <wait+0xf2>
801047aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b0:	8b 40 24             	mov    0x24(%eax),%eax
801047b3:	85 c0                	test   %eax,%eax
801047b5:	74 17                	je     801047ce <wait+0x109>
      release(&ptable.lock);
801047b7:	83 ec 0c             	sub    $0xc,%esp
801047ba:	68 20 ef 10 80       	push   $0x8010ef20
801047bf:	e8 7e 08 00 00       	call   80105042 <release>
801047c4:	83 c4 10             	add    $0x10,%esp
      return -1;
801047c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047cc:	eb 1c                	jmp    801047ea <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801047ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047d4:	83 ec 08             	sub    $0x8,%esp
801047d7:	68 20 ef 10 80       	push   $0x8010ef20
801047dc:	50                   	push   %eax
801047dd:	e8 da 01 00 00       	call   801049bc <sleep>
801047e2:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801047e5:	e9 f1 fe ff ff       	jmp    801046db <wait+0x16>
  }
}
801047ea:	c9                   	leave  
801047eb:	c3                   	ret    

801047ec <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801047ec:	55                   	push   %ebp
801047ed:	89 e5                	mov    %esp,%ebp
801047ef:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
801047f2:	e8 b4 f8 ff ff       	call   801040ab <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801047f7:	83 ec 0c             	sub    $0xc,%esp
801047fa:	68 20 ef 10 80       	push   $0x8010ef20
801047ff:	e8 d7 07 00 00       	call   80104fdb <acquire>
80104804:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104807:	c7 45 f4 54 ef 10 80 	movl   $0x8010ef54,-0xc(%ebp)
8010480e:	eb 66                	jmp    80104876 <scheduler+0x8a>
      if(p->state != RUNNABLE)
80104810:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104813:	8b 40 0c             	mov    0xc(%eax),%eax
80104816:	83 f8 03             	cmp    $0x3,%eax
80104819:	75 53                	jne    8010486e <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
8010481b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481e:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104824:	83 ec 0c             	sub    $0xc,%esp
80104827:	ff 75 f4             	pushl  -0xc(%ebp)
8010482a:	e8 60 36 00 00       	call   80107e8f <switchuvm>
8010482f:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104832:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104835:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
8010483c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104842:	8b 40 1c             	mov    0x1c(%eax),%eax
80104845:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010484c:	83 c2 04             	add    $0x4,%edx
8010484f:	83 ec 08             	sub    $0x8,%esp
80104852:	50                   	push   %eax
80104853:	52                   	push   %edx
80104854:	e8 59 0c 00 00       	call   801054b2 <swtch>
80104859:	83 c4 10             	add    $0x10,%esp
      switchkvm();
8010485c:	e8 11 36 00 00       	call   80107e72 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104861:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104868:	00 00 00 00 
8010486c:	eb 01                	jmp    8010486f <scheduler+0x83>
        continue;
8010486e:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010486f:	81 45 f4 cc 00 00 00 	addl   $0xcc,-0xc(%ebp)
80104876:	81 7d f4 54 22 11 80 	cmpl   $0x80112254,-0xc(%ebp)
8010487d:	72 91                	jb     80104810 <scheduler+0x24>
    }
    release(&ptable.lock);
8010487f:	83 ec 0c             	sub    $0xc,%esp
80104882:	68 20 ef 10 80       	push   $0x8010ef20
80104887:	e8 b6 07 00 00       	call   80105042 <release>
8010488c:	83 c4 10             	add    $0x10,%esp
    sti();
8010488f:	e9 5e ff ff ff       	jmp    801047f2 <scheduler+0x6>

80104894 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104894:	55                   	push   %ebp
80104895:	89 e5                	mov    %esp,%ebp
80104897:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
8010489a:	83 ec 0c             	sub    $0xc,%esp
8010489d:	68 20 ef 10 80       	push   $0x8010ef20
801048a2:	e8 68 08 00 00       	call   8010510f <holding>
801048a7:	83 c4 10             	add    $0x10,%esp
801048aa:	85 c0                	test   %eax,%eax
801048ac:	75 0d                	jne    801048bb <sched+0x27>
    panic("sched ptable.lock");
801048ae:	83 ec 0c             	sub    $0xc,%esp
801048b1:	68 ad 88 10 80       	push   $0x801088ad
801048b6:	e8 c0 bc ff ff       	call   8010057b <panic>
  if(cpu->ncli != 1)
801048bb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801048c1:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801048c7:	83 f8 01             	cmp    $0x1,%eax
801048ca:	74 0d                	je     801048d9 <sched+0x45>
    panic("sched locks");
801048cc:	83 ec 0c             	sub    $0xc,%esp
801048cf:	68 bf 88 10 80       	push   $0x801088bf
801048d4:	e8 a2 bc ff ff       	call   8010057b <panic>
  if(proc->state == RUNNING)
801048d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048df:	8b 40 0c             	mov    0xc(%eax),%eax
801048e2:	83 f8 04             	cmp    $0x4,%eax
801048e5:	75 0d                	jne    801048f4 <sched+0x60>
    panic("sched running");
801048e7:	83 ec 0c             	sub    $0xc,%esp
801048ea:	68 cb 88 10 80       	push   $0x801088cb
801048ef:	e8 87 bc ff ff       	call   8010057b <panic>
  if(readeflags()&FL_IF)
801048f4:	e8 a2 f7 ff ff       	call   8010409b <readeflags>
801048f9:	25 00 02 00 00       	and    $0x200,%eax
801048fe:	85 c0                	test   %eax,%eax
80104900:	74 0d                	je     8010490f <sched+0x7b>
    panic("sched interruptible");
80104902:	83 ec 0c             	sub    $0xc,%esp
80104905:	68 d9 88 10 80       	push   $0x801088d9
8010490a:	e8 6c bc ff ff       	call   8010057b <panic>
  intena = cpu->intena;
8010490f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104915:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010491b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
8010491e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104924:	8b 40 04             	mov    0x4(%eax),%eax
80104927:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010492e:	83 c2 1c             	add    $0x1c,%edx
80104931:	83 ec 08             	sub    $0x8,%esp
80104934:	50                   	push   %eax
80104935:	52                   	push   %edx
80104936:	e8 77 0b 00 00       	call   801054b2 <swtch>
8010493b:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
8010493e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104944:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104947:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010494d:	90                   	nop
8010494e:	c9                   	leave  
8010494f:	c3                   	ret    

80104950 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104956:	83 ec 0c             	sub    $0xc,%esp
80104959:	68 20 ef 10 80       	push   $0x8010ef20
8010495e:	e8 78 06 00 00       	call   80104fdb <acquire>
80104963:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104966:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010496c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104973:	e8 1c ff ff ff       	call   80104894 <sched>
  release(&ptable.lock);
80104978:	83 ec 0c             	sub    $0xc,%esp
8010497b:	68 20 ef 10 80       	push   $0x8010ef20
80104980:	e8 bd 06 00 00       	call   80105042 <release>
80104985:	83 c4 10             	add    $0x10,%esp
}
80104988:	90                   	nop
80104989:	c9                   	leave  
8010498a:	c3                   	ret    

8010498b <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010498b:	55                   	push   %ebp
8010498c:	89 e5                	mov    %esp,%ebp
8010498e:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104991:	83 ec 0c             	sub    $0xc,%esp
80104994:	68 20 ef 10 80       	push   $0x8010ef20
80104999:	e8 a4 06 00 00       	call   80105042 <release>
8010499e:	83 c4 10             	add    $0x10,%esp

  if (first) {
801049a1:	a1 08 b0 10 80       	mov    0x8010b008,%eax
801049a6:	85 c0                	test   %eax,%eax
801049a8:	74 0f                	je     801049b9 <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801049aa:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
801049b1:	00 00 00 
    initlog();
801049b4:	e8 cd e6 ff ff       	call   80103086 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801049b9:	90                   	nop
801049ba:	c9                   	leave  
801049bb:	c3                   	ret    

801049bc <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801049bc:	55                   	push   %ebp
801049bd:	89 e5                	mov    %esp,%ebp
801049bf:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
801049c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c8:	85 c0                	test   %eax,%eax
801049ca:	75 0d                	jne    801049d9 <sleep+0x1d>
    panic("sleep");
801049cc:	83 ec 0c             	sub    $0xc,%esp
801049cf:	68 ed 88 10 80       	push   $0x801088ed
801049d4:	e8 a2 bb ff ff       	call   8010057b <panic>

  if(lk == 0)
801049d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801049dd:	75 0d                	jne    801049ec <sleep+0x30>
    panic("sleep without lk");
801049df:	83 ec 0c             	sub    $0xc,%esp
801049e2:	68 f3 88 10 80       	push   $0x801088f3
801049e7:	e8 8f bb ff ff       	call   8010057b <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801049ec:	81 7d 0c 20 ef 10 80 	cmpl   $0x8010ef20,0xc(%ebp)
801049f3:	74 1e                	je     80104a13 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
801049f5:	83 ec 0c             	sub    $0xc,%esp
801049f8:	68 20 ef 10 80       	push   $0x8010ef20
801049fd:	e8 d9 05 00 00       	call   80104fdb <acquire>
80104a02:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104a05:	83 ec 0c             	sub    $0xc,%esp
80104a08:	ff 75 0c             	pushl  0xc(%ebp)
80104a0b:	e8 32 06 00 00       	call   80105042 <release>
80104a10:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104a13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a19:	8b 55 08             	mov    0x8(%ebp),%edx
80104a1c:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104a1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a25:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104a2c:	e8 63 fe ff ff       	call   80104894 <sched>

  // Tidy up.
  proc->chan = 0;
80104a31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a37:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104a3e:	81 7d 0c 20 ef 10 80 	cmpl   $0x8010ef20,0xc(%ebp)
80104a45:	74 1e                	je     80104a65 <sleep+0xa9>
    release(&ptable.lock);
80104a47:	83 ec 0c             	sub    $0xc,%esp
80104a4a:	68 20 ef 10 80       	push   $0x8010ef20
80104a4f:	e8 ee 05 00 00       	call   80105042 <release>
80104a54:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104a57:	83 ec 0c             	sub    $0xc,%esp
80104a5a:	ff 75 0c             	pushl  0xc(%ebp)
80104a5d:	e8 79 05 00 00       	call   80104fdb <acquire>
80104a62:	83 c4 10             	add    $0x10,%esp
  }
}
80104a65:	90                   	nop
80104a66:	c9                   	leave  
80104a67:	c3                   	ret    

80104a68 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104a68:	55                   	push   %ebp
80104a69:	89 e5                	mov    %esp,%ebp
80104a6b:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a6e:	c7 45 fc 54 ef 10 80 	movl   $0x8010ef54,-0x4(%ebp)
80104a75:	eb 27                	jmp    80104a9e <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104a77:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a7a:	8b 40 0c             	mov    0xc(%eax),%eax
80104a7d:	83 f8 02             	cmp    $0x2,%eax
80104a80:	75 15                	jne    80104a97 <wakeup1+0x2f>
80104a82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a85:	8b 40 20             	mov    0x20(%eax),%eax
80104a88:	39 45 08             	cmp    %eax,0x8(%ebp)
80104a8b:	75 0a                	jne    80104a97 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a90:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a97:	81 45 fc cc 00 00 00 	addl   $0xcc,-0x4(%ebp)
80104a9e:	81 7d fc 54 22 11 80 	cmpl   $0x80112254,-0x4(%ebp)
80104aa5:	72 d0                	jb     80104a77 <wakeup1+0xf>
}
80104aa7:	90                   	nop
80104aa8:	90                   	nop
80104aa9:	c9                   	leave  
80104aaa:	c3                   	ret    

80104aab <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104aab:	55                   	push   %ebp
80104aac:	89 e5                	mov    %esp,%ebp
80104aae:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104ab1:	83 ec 0c             	sub    $0xc,%esp
80104ab4:	68 20 ef 10 80       	push   $0x8010ef20
80104ab9:	e8 1d 05 00 00       	call   80104fdb <acquire>
80104abe:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104ac1:	83 ec 0c             	sub    $0xc,%esp
80104ac4:	ff 75 08             	pushl  0x8(%ebp)
80104ac7:	e8 9c ff ff ff       	call   80104a68 <wakeup1>
80104acc:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104acf:	83 ec 0c             	sub    $0xc,%esp
80104ad2:	68 20 ef 10 80       	push   $0x8010ef20
80104ad7:	e8 66 05 00 00       	call   80105042 <release>
80104adc:	83 c4 10             	add    $0x10,%esp
}
80104adf:	90                   	nop
80104ae0:	c9                   	leave  
80104ae1:	c3                   	ret    

80104ae2 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104ae2:	55                   	push   %ebp
80104ae3:	89 e5                	mov    %esp,%ebp
80104ae5:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104ae8:	83 ec 0c             	sub    $0xc,%esp
80104aeb:	68 20 ef 10 80       	push   $0x8010ef20
80104af0:	e8 e6 04 00 00       	call   80104fdb <acquire>
80104af5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104af8:	c7 45 f4 54 ef 10 80 	movl   $0x8010ef54,-0xc(%ebp)
80104aff:	eb 48                	jmp    80104b49 <kill+0x67>
    if(p->pid == pid){
80104b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b04:	8b 40 10             	mov    0x10(%eax),%eax
80104b07:	39 45 08             	cmp    %eax,0x8(%ebp)
80104b0a:	75 36                	jne    80104b42 <kill+0x60>
      p->killed = 1;
80104b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b19:	8b 40 0c             	mov    0xc(%eax),%eax
80104b1c:	83 f8 02             	cmp    $0x2,%eax
80104b1f:	75 0a                	jne    80104b2b <kill+0x49>
        p->state = RUNNABLE;
80104b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b24:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104b2b:	83 ec 0c             	sub    $0xc,%esp
80104b2e:	68 20 ef 10 80       	push   $0x8010ef20
80104b33:	e8 0a 05 00 00       	call   80105042 <release>
80104b38:	83 c4 10             	add    $0x10,%esp
      return 0;
80104b3b:	b8 00 00 00 00       	mov    $0x0,%eax
80104b40:	eb 25                	jmp    80104b67 <kill+0x85>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b42:	81 45 f4 cc 00 00 00 	addl   $0xcc,-0xc(%ebp)
80104b49:	81 7d f4 54 22 11 80 	cmpl   $0x80112254,-0xc(%ebp)
80104b50:	72 af                	jb     80104b01 <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104b52:	83 ec 0c             	sub    $0xc,%esp
80104b55:	68 20 ef 10 80       	push   $0x8010ef20
80104b5a:	e8 e3 04 00 00       	call   80105042 <release>
80104b5f:	83 c4 10             	add    $0x10,%esp
  return -1;
80104b62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b67:	c9                   	leave  
80104b68:	c3                   	ret    

80104b69 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104b69:	55                   	push   %ebp
80104b6a:	89 e5                	mov    %esp,%ebp
80104b6c:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b6f:	c7 45 f0 54 ef 10 80 	movl   $0x8010ef54,-0x10(%ebp)
80104b76:	e9 da 00 00 00       	jmp    80104c55 <procdump+0xec>
    if(p->state == UNUSED)
80104b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b7e:	8b 40 0c             	mov    0xc(%eax),%eax
80104b81:	85 c0                	test   %eax,%eax
80104b83:	0f 84 c4 00 00 00    	je     80104c4d <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b8c:	8b 40 0c             	mov    0xc(%eax),%eax
80104b8f:	83 f8 05             	cmp    $0x5,%eax
80104b92:	77 23                	ja     80104bb7 <procdump+0x4e>
80104b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b97:	8b 40 0c             	mov    0xc(%eax),%eax
80104b9a:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104ba1:	85 c0                	test   %eax,%eax
80104ba3:	74 12                	je     80104bb7 <procdump+0x4e>
      state = states[p->state];
80104ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ba8:	8b 40 0c             	mov    0xc(%eax),%eax
80104bab:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104bb2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104bb5:	eb 07                	jmp    80104bbe <procdump+0x55>
    else
      state = "???";
80104bb7:	c7 45 ec 04 89 10 80 	movl   $0x80108904,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bc1:	8d 50 6c             	lea    0x6c(%eax),%edx
80104bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bc7:	8b 40 10             	mov    0x10(%eax),%eax
80104bca:	52                   	push   %edx
80104bcb:	ff 75 ec             	pushl  -0x14(%ebp)
80104bce:	50                   	push   %eax
80104bcf:	68 08 89 10 80       	push   $0x80108908
80104bd4:	e8 ed b7 ff ff       	call   801003c6 <cprintf>
80104bd9:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bdf:	8b 40 0c             	mov    0xc(%eax),%eax
80104be2:	83 f8 02             	cmp    $0x2,%eax
80104be5:	75 54                	jne    80104c3b <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bea:	8b 40 1c             	mov    0x1c(%eax),%eax
80104bed:	8b 40 0c             	mov    0xc(%eax),%eax
80104bf0:	83 c0 08             	add    $0x8,%eax
80104bf3:	89 c2                	mov    %eax,%edx
80104bf5:	83 ec 08             	sub    $0x8,%esp
80104bf8:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104bfb:	50                   	push   %eax
80104bfc:	52                   	push   %edx
80104bfd:	e8 92 04 00 00       	call   80105094 <getcallerpcs>
80104c02:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104c05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104c0c:	eb 1c                	jmp    80104c2a <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c11:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c15:	83 ec 08             	sub    $0x8,%esp
80104c18:	50                   	push   %eax
80104c19:	68 11 89 10 80       	push   $0x80108911
80104c1e:	e8 a3 b7 ff ff       	call   801003c6 <cprintf>
80104c23:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104c26:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104c2a:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104c2e:	7f 0b                	jg     80104c3b <procdump+0xd2>
80104c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c33:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c37:	85 c0                	test   %eax,%eax
80104c39:	75 d3                	jne    80104c0e <procdump+0xa5>
    }
    cprintf("\n");
80104c3b:	83 ec 0c             	sub    $0xc,%esp
80104c3e:	68 15 89 10 80       	push   $0x80108915
80104c43:	e8 7e b7 ff ff       	call   801003c6 <cprintf>
80104c48:	83 c4 10             	add    $0x10,%esp
80104c4b:	eb 01                	jmp    80104c4e <procdump+0xe5>
      continue;
80104c4d:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c4e:	81 45 f0 cc 00 00 00 	addl   $0xcc,-0x10(%ebp)
80104c55:	81 7d f0 54 22 11 80 	cmpl   $0x80112254,-0x10(%ebp)
80104c5c:	0f 82 19 ff ff ff    	jb     80104b7b <procdump+0x12>
  }
}
80104c62:	90                   	nop
80104c63:	90                   	nop
80104c64:	c9                   	leave  
80104c65:	c3                   	ret    

80104c66 <semaphore_init>:
struct {
	struct spinlock lock;
	struct semaphore semtab[NSEM];
} semtable;

void semaphore_init(void){
80104c66:	55                   	push   %ebp
80104c67:	89 e5                	mov    %esp,%ebp
80104c69:	83 ec 18             	sub    $0x18,%esp
	initlock(&semtable.lock, "semtable");
80104c6c:	83 ec 08             	sub    $0x8,%esp
80104c6f:	68 41 89 10 80       	push   $0x80108941
80104c74:	68 60 22 11 80       	push   $0x80112260
80104c79:	e8 3b 03 00 00       	call   80104fb9 <initlock>
80104c7e:	83 c4 10             	add    $0x10,%esp
	struct semaphore* sem;
	for(sem = semtable.semtab; sem < semtable.semtab + NSEM; sem++){
80104c81:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
80104c88:	eb 0d                	jmp    80104c97 <semaphore_init+0x31>
		sem->free = S_FREE;	
80104c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for(sem = semtable.semtab; sem < semtable.semtab + NSEM; sem++){
80104c93:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
80104c97:	b8 34 23 11 80       	mov    $0x80112334,%eax
80104c9c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104c9f:	72 e9                	jb     80104c8a <semaphore_init+0x24>
	}
	return;
80104ca1:	90                   	nop
}
80104ca2:	c9                   	leave  
80104ca3:	c3                   	ret    

80104ca4 <sem_alloc>:

int sem_alloc(){
80104ca4:	55                   	push   %ebp
80104ca5:	89 e5                	mov    %esp,%ebp
80104ca7:	83 ec 18             	sub    $0x18,%esp
		struct semaphore* sem;
		acquire(&semtable.lock);
80104caa:	83 ec 0c             	sub    $0xc,%esp
80104cad:	68 60 22 11 80       	push   $0x80112260
80104cb2:	e8 24 03 00 00       	call   80104fdb <acquire>
80104cb7:	83 c4 10             	add    $0x10,%esp
		for(sem = semtable.semtab; sem < semtable.semtab + NSEM; sem++){
80104cba:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
80104cc1:	eb 4a                	jmp    80104d0d <sem_alloc+0x69>
			if(sem->free == S_FREE){
80104cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc6:	8b 00                	mov    (%eax),%eax
80104cc8:	85 c0                	test   %eax,%eax
80104cca:	75 3d                	jne    80104d09 <sem_alloc+0x65>
				sem->free = S_ALLOC;
80104ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ccf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				sem_alloc_proctable(sem - semtable.semtab);
80104cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cd8:	2d 94 22 11 80       	sub    $0x80112294,%eax
80104cdd:	c1 f8 03             	sar    $0x3,%eax
80104ce0:	83 ec 0c             	sub    $0xc,%esp
80104ce3:	50                   	push   %eax
80104ce4:	e8 e7 f3 ff ff       	call   801040d0 <sem_alloc_proctable>
80104ce9:	83 c4 10             	add    $0x10,%esp
				release(&semtable.lock);
80104cec:	83 ec 0c             	sub    $0xc,%esp
80104cef:	68 60 22 11 80       	push   $0x80112260
80104cf4:	e8 49 03 00 00       	call   80105042 <release>
80104cf9:	83 c4 10             	add    $0x10,%esp
				return (sem - semtable.semtab);			
80104cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cff:	2d 94 22 11 80       	sub    $0x80112294,%eax
80104d04:	c1 f8 03             	sar    $0x3,%eax
80104d07:	eb 23                	jmp    80104d2c <sem_alloc+0x88>
		for(sem = semtable.semtab; sem < semtable.semtab + NSEM; sem++){
80104d09:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
80104d0d:	b8 34 23 11 80       	mov    $0x80112334,%eax
80104d12:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104d15:	72 ac                	jb     80104cc3 <sem_alloc+0x1f>
			}		
		}
		release(&semtable.lock);
80104d17:	83 ec 0c             	sub    $0xc,%esp
80104d1a:	68 60 22 11 80       	push   $0x80112260
80104d1f:	e8 1e 03 00 00       	call   80105042 <release>
80104d24:	83 c4 10             	add    $0x10,%esp
		return -1;
80104d27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d2c:	c9                   	leave  
80104d2d:	c3                   	ret    

80104d2e <sem_destroy>:

int sem_destroy(int sem){
80104d2e:	55                   	push   %ebp
80104d2f:	89 e5                	mov    %esp,%ebp
80104d31:	83 ec 18             	sub    $0x18,%esp
	struct semaphore* semph;
	acquire(&semtable.lock);
80104d34:	83 ec 0c             	sub    $0xc,%esp
80104d37:	68 60 22 11 80       	push   $0x80112260
80104d3c:	e8 9a 02 00 00       	call   80104fdb <acquire>
80104d41:	83 c4 10             	add    $0x10,%esp
	semph = semtable.semtab + sem;
80104d44:	8b 45 08             	mov    0x8(%ebp),%eax
80104d47:	c1 e0 03             	shl    $0x3,%eax
80104d4a:	05 94 22 11 80       	add    $0x80112294,%eax
80104d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if((semph < semtable.semtab) || (semph > semtable.semtab + NSEM) || (semph->free == S_FREE)){
80104d52:	81 7d f4 94 22 11 80 	cmpl   $0x80112294,-0xc(%ebp)
80104d59:	72 13                	jb     80104d6e <sem_destroy+0x40>
80104d5b:	b8 34 23 11 80       	mov    $0x80112334,%eax
80104d60:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104d63:	77 09                	ja     80104d6e <sem_destroy+0x40>
80104d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d68:	8b 00                	mov    (%eax),%eax
80104d6a:	85 c0                	test   %eax,%eax
80104d6c:	75 17                	jne    80104d85 <sem_destroy+0x57>
		release(&semtable.lock);		
80104d6e:	83 ec 0c             	sub    $0xc,%esp
80104d71:	68 60 22 11 80       	push   $0x80112260
80104d76:	e8 c7 02 00 00       	call   80105042 <release>
80104d7b:	83 c4 10             	add    $0x10,%esp
		return -1;
80104d7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d83:	eb 2c                	jmp    80104db1 <sem_destroy+0x83>
	} 
	wakeup(semph);
80104d85:	83 ec 0c             	sub    $0xc,%esp
80104d88:	ff 75 f4             	pushl  -0xc(%ebp)
80104d8b:	e8 1b fd ff ff       	call   80104aab <wakeup>
80104d90:	83 c4 10             	add    $0x10,%esp
	semph->free = S_FREE;
80104d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	release(&semtable.lock);
80104d9c:	83 ec 0c             	sub    $0xc,%esp
80104d9f:	68 60 22 11 80       	push   $0x80112260
80104da4:	e8 99 02 00 00       	call   80105042 <release>
80104da9:	83 c4 10             	add    $0x10,%esp
	return 0;	
80104dac:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104db1:	c9                   	leave  
80104db2:	c3                   	ret    

80104db3 <sem_init>:

int sem_init(int sem, int count){
80104db3:	55                   	push   %ebp
80104db4:	89 e5                	mov    %esp,%ebp
80104db6:	83 ec 18             	sub    $0x18,%esp
	struct semaphore* semph;
	acquire(&semtable.lock);
80104db9:	83 ec 0c             	sub    $0xc,%esp
80104dbc:	68 60 22 11 80       	push   $0x80112260
80104dc1:	e8 15 02 00 00       	call   80104fdb <acquire>
80104dc6:	83 c4 10             	add    $0x10,%esp
	semph = semtable.semtab + sem;
80104dc9:	8b 45 08             	mov    0x8(%ebp),%eax
80104dcc:	c1 e0 03             	shl    $0x3,%eax
80104dcf:	05 94 22 11 80       	add    $0x80112294,%eax
80104dd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if((semph < semtable.semtab) || (semph > semtable.semtab + NSEM) || (semph->free == S_FREE)){
80104dd7:	81 7d f4 94 22 11 80 	cmpl   $0x80112294,-0xc(%ebp)
80104dde:	72 13                	jb     80104df3 <sem_init+0x40>
80104de0:	b8 34 23 11 80       	mov    $0x80112334,%eax
80104de5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104de8:	77 09                	ja     80104df3 <sem_init+0x40>
80104dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ded:	8b 00                	mov    (%eax),%eax
80104def:	85 c0                	test   %eax,%eax
80104df1:	75 17                	jne    80104e0a <sem_init+0x57>
		release(&semtable.lock);
80104df3:	83 ec 0c             	sub    $0xc,%esp
80104df6:	68 60 22 11 80       	push   $0x80112260
80104dfb:	e8 42 02 00 00       	call   80105042 <release>
80104e00:	83 c4 10             	add    $0x10,%esp
		return -1;
80104e03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e08:	eb 1e                	jmp    80104e28 <sem_init+0x75>
	}
	semph->count = count;
80104e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e10:	89 50 04             	mov    %edx,0x4(%eax)
	release(&semtable.lock);
80104e13:	83 ec 0c             	sub    $0xc,%esp
80104e16:	68 60 22 11 80       	push   $0x80112260
80104e1b:	e8 22 02 00 00       	call   80105042 <release>
80104e20:	83 c4 10             	add    $0x10,%esp
	return 0; 
80104e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e28:	c9                   	leave  
80104e29:	c3                   	ret    

80104e2a <sem_wait>:

int sem_wait(int sem){
80104e2a:	55                   	push   %ebp
80104e2b:	89 e5                	mov    %esp,%ebp
80104e2d:	83 ec 18             	sub    $0x18,%esp
	struct semaphore* semph;
	acquire(&semtable.lock);
80104e30:	83 ec 0c             	sub    $0xc,%esp
80104e33:	68 60 22 11 80       	push   $0x80112260
80104e38:	e8 9e 01 00 00       	call   80104fdb <acquire>
80104e3d:	83 c4 10             	add    $0x10,%esp
	semph = semtable.semtab + sem;
80104e40:	8b 45 08             	mov    0x8(%ebp),%eax
80104e43:	c1 e0 03             	shl    $0x3,%eax
80104e46:	05 94 22 11 80       	add    $0x80112294,%eax
80104e4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if((semph < semtable.semtab) || (semph > semtable.semtab + NSEM) || (semph->free == S_FREE)){
80104e4e:	81 7d f4 94 22 11 80 	cmpl   $0x80112294,-0xc(%ebp)
80104e55:	72 13                	jb     80104e6a <sem_wait+0x40>
80104e57:	b8 34 23 11 80       	mov    $0x80112334,%eax
80104e5c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104e5f:	77 09                	ja     80104e6a <sem_wait+0x40>
80104e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e64:	8b 00                	mov    (%eax),%eax
80104e66:	85 c0                	test   %eax,%eax
80104e68:	75 17                	jne    80104e81 <sem_wait+0x57>
		release(&semtable.lock);		
80104e6a:	83 ec 0c             	sub    $0xc,%esp
80104e6d:	68 60 22 11 80       	push   $0x80112260
80104e72:	e8 cb 01 00 00       	call   80105042 <release>
80104e77:	83 c4 10             	add    $0x10,%esp
		return -1;
80104e7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e7f:	eb 58                	jmp    80104ed9 <sem_wait+0xaf>
	}
	if(--semph->count < 0){
80104e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e84:	8b 40 04             	mov    0x4(%eax),%eax
80104e87:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e8d:	89 50 04             	mov    %edx,0x4(%eax)
80104e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e93:	8b 40 04             	mov    0x4(%eax),%eax
80104e96:	85 c0                	test   %eax,%eax
80104e98:	79 2a                	jns    80104ec4 <sem_wait+0x9a>
		sleep(semph, &semtable.lock);
80104e9a:	83 ec 08             	sub    $0x8,%esp
80104e9d:	68 60 22 11 80       	push   $0x80112260
80104ea2:	ff 75 f4             	pushl  -0xc(%ebp)
80104ea5:	e8 12 fb ff ff       	call   801049bc <sleep>
80104eaa:	83 c4 10             	add    $0x10,%esp
		release(&semtable.lock);		
80104ead:	83 ec 0c             	sub    $0xc,%esp
80104eb0:	68 60 22 11 80       	push   $0x80112260
80104eb5:	e8 88 01 00 00       	call   80105042 <release>
80104eba:	83 c4 10             	add    $0x10,%esp
		return 0;
80104ebd:	b8 00 00 00 00       	mov    $0x0,%eax
80104ec2:	eb 15                	jmp    80104ed9 <sem_wait+0xaf>
	}
	release(&semtable.lock);
80104ec4:	83 ec 0c             	sub    $0xc,%esp
80104ec7:	68 60 22 11 80       	push   $0x80112260
80104ecc:	e8 71 01 00 00       	call   80105042 <release>
80104ed1:	83 c4 10             	add    $0x10,%esp
	return 0;
80104ed4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ed9:	c9                   	leave  
80104eda:	c3                   	ret    

80104edb <sem_post>:

int sem_post(int sem){
80104edb:	55                   	push   %ebp
80104edc:	89 e5                	mov    %esp,%ebp
80104ede:	83 ec 18             	sub    $0x18,%esp
	struct semaphore* semph;
	acquire(&semtable.lock);
80104ee1:	83 ec 0c             	sub    $0xc,%esp
80104ee4:	68 60 22 11 80       	push   $0x80112260
80104ee9:	e8 ed 00 00 00       	call   80104fdb <acquire>
80104eee:	83 c4 10             	add    $0x10,%esp
	semph = semtable.semtab + sem;
80104ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef4:	c1 e0 03             	shl    $0x3,%eax
80104ef7:	05 94 22 11 80       	add    $0x80112294,%eax
80104efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if((semph < semtable.semtab) || (semph > semtable.semtab + NSEM) || (semph->free == S_FREE)){
80104eff:	81 7d f4 94 22 11 80 	cmpl   $0x80112294,-0xc(%ebp)
80104f06:	72 13                	jb     80104f1b <sem_post+0x40>
80104f08:	b8 34 23 11 80       	mov    $0x80112334,%eax
80104f0d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104f10:	77 09                	ja     80104f1b <sem_post+0x40>
80104f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f15:	8b 00                	mov    (%eax),%eax
80104f17:	85 c0                	test   %eax,%eax
80104f19:	75 17                	jne    80104f32 <sem_post+0x57>
		release(&semtable.lock);		
80104f1b:	83 ec 0c             	sub    $0xc,%esp
80104f1e:	68 60 22 11 80       	push   $0x80112260
80104f23:	e8 1a 01 00 00       	call   80105042 <release>
80104f28:	83 c4 10             	add    $0x10,%esp
		return -1;
80104f2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f30:	eb 4d                	jmp    80104f7f <sem_post+0xa4>
	}
	if(semph->count++ < 0){
80104f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f35:	8b 40 04             	mov    0x4(%eax),%eax
80104f38:	8d 48 01             	lea    0x1(%eax),%ecx
80104f3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f3e:	89 4a 04             	mov    %ecx,0x4(%edx)
80104f41:	85 c0                	test   %eax,%eax
80104f43:	79 25                	jns    80104f6a <sem_post+0x8f>
		wakeup(semph);
80104f45:	83 ec 0c             	sub    $0xc,%esp
80104f48:	ff 75 f4             	pushl  -0xc(%ebp)
80104f4b:	e8 5b fb ff ff       	call   80104aab <wakeup>
80104f50:	83 c4 10             	add    $0x10,%esp
		release(&semtable.lock);		
80104f53:	83 ec 0c             	sub    $0xc,%esp
80104f56:	68 60 22 11 80       	push   $0x80112260
80104f5b:	e8 e2 00 00 00       	call   80105042 <release>
80104f60:	83 c4 10             	add    $0x10,%esp
		return 0;
80104f63:	b8 00 00 00 00       	mov    $0x0,%eax
80104f68:	eb 15                	jmp    80104f7f <sem_post+0xa4>
	}
	release(&semtable.lock);
80104f6a:	83 ec 0c             	sub    $0xc,%esp
80104f6d:	68 60 22 11 80       	push   $0x80112260
80104f72:	e8 cb 00 00 00       	call   80105042 <release>
80104f77:	83 c4 10             	add    $0x10,%esp
	return 0;
80104f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f7f:	c9                   	leave  
80104f80:	c3                   	ret    

80104f81 <readeflags>:
{
80104f81:	55                   	push   %ebp
80104f82:	89 e5                	mov    %esp,%ebp
80104f84:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f87:	9c                   	pushf  
80104f88:	58                   	pop    %eax
80104f89:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104f8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f8f:	c9                   	leave  
80104f90:	c3                   	ret    

80104f91 <cli>:
{
80104f91:	55                   	push   %ebp
80104f92:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f94:	fa                   	cli    
}
80104f95:	90                   	nop
80104f96:	5d                   	pop    %ebp
80104f97:	c3                   	ret    

80104f98 <sti>:
{
80104f98:	55                   	push   %ebp
80104f99:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f9b:	fb                   	sti    
}
80104f9c:	90                   	nop
80104f9d:	5d                   	pop    %ebp
80104f9e:	c3                   	ret    

80104f9f <xchg>:
{
80104f9f:	55                   	push   %ebp
80104fa0:	89 e5                	mov    %esp,%ebp
80104fa2:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104fa5:	8b 55 08             	mov    0x8(%ebp),%edx
80104fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fab:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fae:	f0 87 02             	lock xchg %eax,(%edx)
80104fb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104fb7:	c9                   	leave  
80104fb8:	c3                   	ret    

80104fb9 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104fb9:	55                   	push   %ebp
80104fba:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80104fbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fc2:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104fc5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104fce:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104fd8:	90                   	nop
80104fd9:	5d                   	pop    %ebp
80104fda:	c3                   	ret    

80104fdb <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104fdb:	55                   	push   %ebp
80104fdc:	89 e5                	mov    %esp,%ebp
80104fde:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104fe1:	e8 53 01 00 00       	call   80105139 <pushcli>
  if(holding(lk))
80104fe6:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe9:	83 ec 0c             	sub    $0xc,%esp
80104fec:	50                   	push   %eax
80104fed:	e8 1d 01 00 00       	call   8010510f <holding>
80104ff2:	83 c4 10             	add    $0x10,%esp
80104ff5:	85 c0                	test   %eax,%eax
80104ff7:	74 0d                	je     80105006 <acquire+0x2b>
    panic("acquire");
80104ff9:	83 ec 0c             	sub    $0xc,%esp
80104ffc:	68 4a 89 10 80       	push   $0x8010894a
80105001:	e8 75 b5 ff ff       	call   8010057b <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105006:	90                   	nop
80105007:	8b 45 08             	mov    0x8(%ebp),%eax
8010500a:	83 ec 08             	sub    $0x8,%esp
8010500d:	6a 01                	push   $0x1
8010500f:	50                   	push   %eax
80105010:	e8 8a ff ff ff       	call   80104f9f <xchg>
80105015:	83 c4 10             	add    $0x10,%esp
80105018:	85 c0                	test   %eax,%eax
8010501a:	75 eb                	jne    80105007 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010501c:	8b 45 08             	mov    0x8(%ebp),%eax
8010501f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105026:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105029:	8b 45 08             	mov    0x8(%ebp),%eax
8010502c:	83 c0 0c             	add    $0xc,%eax
8010502f:	83 ec 08             	sub    $0x8,%esp
80105032:	50                   	push   %eax
80105033:	8d 45 08             	lea    0x8(%ebp),%eax
80105036:	50                   	push   %eax
80105037:	e8 58 00 00 00       	call   80105094 <getcallerpcs>
8010503c:	83 c4 10             	add    $0x10,%esp
}
8010503f:	90                   	nop
80105040:	c9                   	leave  
80105041:	c3                   	ret    

80105042 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105042:	55                   	push   %ebp
80105043:	89 e5                	mov    %esp,%ebp
80105045:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105048:	83 ec 0c             	sub    $0xc,%esp
8010504b:	ff 75 08             	pushl  0x8(%ebp)
8010504e:	e8 bc 00 00 00       	call   8010510f <holding>
80105053:	83 c4 10             	add    $0x10,%esp
80105056:	85 c0                	test   %eax,%eax
80105058:	75 0d                	jne    80105067 <release+0x25>
    panic("release");
8010505a:	83 ec 0c             	sub    $0xc,%esp
8010505d:	68 52 89 10 80       	push   $0x80108952
80105062:	e8 14 b5 ff ff       	call   8010057b <panic>

  lk->pcs[0] = 0;
80105067:	8b 45 08             	mov    0x8(%ebp),%eax
8010506a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105071:	8b 45 08             	mov    0x8(%ebp),%eax
80105074:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010507b:	8b 45 08             	mov    0x8(%ebp),%eax
8010507e:	83 ec 08             	sub    $0x8,%esp
80105081:	6a 00                	push   $0x0
80105083:	50                   	push   %eax
80105084:	e8 16 ff ff ff       	call   80104f9f <xchg>
80105089:	83 c4 10             	add    $0x10,%esp

  popcli();
8010508c:	e8 ec 00 00 00       	call   8010517d <popcli>
}
80105091:	90                   	nop
80105092:	c9                   	leave  
80105093:	c3                   	ret    

80105094 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010509a:	8b 45 08             	mov    0x8(%ebp),%eax
8010509d:	83 e8 08             	sub    $0x8,%eax
801050a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801050a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801050aa:	eb 38                	jmp    801050e4 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801050ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801050b0:	74 53                	je     80105105 <getcallerpcs+0x71>
801050b2:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801050b9:	76 4a                	jbe    80105105 <getcallerpcs+0x71>
801050bb:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801050bf:	74 44                	je     80105105 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801050c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801050cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ce:	01 c2                	add    %eax,%edx
801050d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050d3:	8b 40 04             	mov    0x4(%eax),%eax
801050d6:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801050d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050db:	8b 00                	mov    (%eax),%eax
801050dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801050e0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801050e4:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801050e8:	7e c2                	jle    801050ac <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
801050ea:	eb 19                	jmp    80105105 <getcallerpcs+0x71>
    pcs[i] = 0;
801050ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801050f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801050f9:	01 d0                	add    %edx,%eax
801050fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105101:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105105:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105109:	7e e1                	jle    801050ec <getcallerpcs+0x58>
}
8010510b:	90                   	nop
8010510c:	90                   	nop
8010510d:	c9                   	leave  
8010510e:	c3                   	ret    

8010510f <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010510f:	55                   	push   %ebp
80105110:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105112:	8b 45 08             	mov    0x8(%ebp),%eax
80105115:	8b 00                	mov    (%eax),%eax
80105117:	85 c0                	test   %eax,%eax
80105119:	74 17                	je     80105132 <holding+0x23>
8010511b:	8b 45 08             	mov    0x8(%ebp),%eax
8010511e:	8b 50 08             	mov    0x8(%eax),%edx
80105121:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105127:	39 c2                	cmp    %eax,%edx
80105129:	75 07                	jne    80105132 <holding+0x23>
8010512b:	b8 01 00 00 00       	mov    $0x1,%eax
80105130:	eb 05                	jmp    80105137 <holding+0x28>
80105132:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105137:	5d                   	pop    %ebp
80105138:	c3                   	ret    

80105139 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105139:	55                   	push   %ebp
8010513a:	89 e5                	mov    %esp,%ebp
8010513c:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
8010513f:	e8 3d fe ff ff       	call   80104f81 <readeflags>
80105144:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105147:	e8 45 fe ff ff       	call   80104f91 <cli>
  if(cpu->ncli++ == 0)
8010514c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105152:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105158:	8d 4a 01             	lea    0x1(%edx),%ecx
8010515b:	89 88 ac 00 00 00    	mov    %ecx,0xac(%eax)
80105161:	85 d2                	test   %edx,%edx
80105163:	75 15                	jne    8010517a <pushcli+0x41>
    cpu->intena = eflags & FL_IF;
80105165:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010516b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010516e:	81 e2 00 02 00 00    	and    $0x200,%edx
80105174:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010517a:	90                   	nop
8010517b:	c9                   	leave  
8010517c:	c3                   	ret    

8010517d <popcli>:

void
popcli(void)
{
8010517d:	55                   	push   %ebp
8010517e:	89 e5                	mov    %esp,%ebp
80105180:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105183:	e8 f9 fd ff ff       	call   80104f81 <readeflags>
80105188:	25 00 02 00 00       	and    $0x200,%eax
8010518d:	85 c0                	test   %eax,%eax
8010518f:	74 0d                	je     8010519e <popcli+0x21>
    panic("popcli - interruptible");
80105191:	83 ec 0c             	sub    $0xc,%esp
80105194:	68 5a 89 10 80       	push   $0x8010895a
80105199:	e8 dd b3 ff ff       	call   8010057b <panic>
  if(--cpu->ncli < 0)
8010519e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051a4:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801051aa:	83 ea 01             	sub    $0x1,%edx
801051ad:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801051b3:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801051b9:	85 c0                	test   %eax,%eax
801051bb:	79 0d                	jns    801051ca <popcli+0x4d>
    panic("popcli");
801051bd:	83 ec 0c             	sub    $0xc,%esp
801051c0:	68 71 89 10 80       	push   $0x80108971
801051c5:	e8 b1 b3 ff ff       	call   8010057b <panic>
  if(cpu->ncli == 0 && cpu->intena)
801051ca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051d0:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801051d6:	85 c0                	test   %eax,%eax
801051d8:	75 15                	jne    801051ef <popcli+0x72>
801051da:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051e0:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801051e6:	85 c0                	test   %eax,%eax
801051e8:	74 05                	je     801051ef <popcli+0x72>
    sti();
801051ea:	e8 a9 fd ff ff       	call   80104f98 <sti>
}
801051ef:	90                   	nop
801051f0:	c9                   	leave  
801051f1:	c3                   	ret    

801051f2 <stosb>:
{
801051f2:	55                   	push   %ebp
801051f3:	89 e5                	mov    %esp,%ebp
801051f5:	57                   	push   %edi
801051f6:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801051f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051fa:	8b 55 10             	mov    0x10(%ebp),%edx
801051fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80105200:	89 cb                	mov    %ecx,%ebx
80105202:	89 df                	mov    %ebx,%edi
80105204:	89 d1                	mov    %edx,%ecx
80105206:	fc                   	cld    
80105207:	f3 aa                	rep stos %al,%es:(%edi)
80105209:	89 ca                	mov    %ecx,%edx
8010520b:	89 fb                	mov    %edi,%ebx
8010520d:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105210:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105213:	90                   	nop
80105214:	5b                   	pop    %ebx
80105215:	5f                   	pop    %edi
80105216:	5d                   	pop    %ebp
80105217:	c3                   	ret    

80105218 <stosl>:
{
80105218:	55                   	push   %ebp
80105219:	89 e5                	mov    %esp,%ebp
8010521b:	57                   	push   %edi
8010521c:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010521d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105220:	8b 55 10             	mov    0x10(%ebp),%edx
80105223:	8b 45 0c             	mov    0xc(%ebp),%eax
80105226:	89 cb                	mov    %ecx,%ebx
80105228:	89 df                	mov    %ebx,%edi
8010522a:	89 d1                	mov    %edx,%ecx
8010522c:	fc                   	cld    
8010522d:	f3 ab                	rep stos %eax,%es:(%edi)
8010522f:	89 ca                	mov    %ecx,%edx
80105231:	89 fb                	mov    %edi,%ebx
80105233:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105236:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105239:	90                   	nop
8010523a:	5b                   	pop    %ebx
8010523b:	5f                   	pop    %edi
8010523c:	5d                   	pop    %ebp
8010523d:	c3                   	ret    

8010523e <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010523e:	55                   	push   %ebp
8010523f:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105241:	8b 45 08             	mov    0x8(%ebp),%eax
80105244:	83 e0 03             	and    $0x3,%eax
80105247:	85 c0                	test   %eax,%eax
80105249:	75 43                	jne    8010528e <memset+0x50>
8010524b:	8b 45 10             	mov    0x10(%ebp),%eax
8010524e:	83 e0 03             	and    $0x3,%eax
80105251:	85 c0                	test   %eax,%eax
80105253:	75 39                	jne    8010528e <memset+0x50>
    c &= 0xFF;
80105255:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010525c:	8b 45 10             	mov    0x10(%ebp),%eax
8010525f:	c1 e8 02             	shr    $0x2,%eax
80105262:	89 c2                	mov    %eax,%edx
80105264:	8b 45 0c             	mov    0xc(%ebp),%eax
80105267:	c1 e0 18             	shl    $0x18,%eax
8010526a:	89 c1                	mov    %eax,%ecx
8010526c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010526f:	c1 e0 10             	shl    $0x10,%eax
80105272:	09 c1                	or     %eax,%ecx
80105274:	8b 45 0c             	mov    0xc(%ebp),%eax
80105277:	c1 e0 08             	shl    $0x8,%eax
8010527a:	09 c8                	or     %ecx,%eax
8010527c:	0b 45 0c             	or     0xc(%ebp),%eax
8010527f:	52                   	push   %edx
80105280:	50                   	push   %eax
80105281:	ff 75 08             	pushl  0x8(%ebp)
80105284:	e8 8f ff ff ff       	call   80105218 <stosl>
80105289:	83 c4 0c             	add    $0xc,%esp
8010528c:	eb 12                	jmp    801052a0 <memset+0x62>
  } else
    stosb(dst, c, n);
8010528e:	8b 45 10             	mov    0x10(%ebp),%eax
80105291:	50                   	push   %eax
80105292:	ff 75 0c             	pushl  0xc(%ebp)
80105295:	ff 75 08             	pushl  0x8(%ebp)
80105298:	e8 55 ff ff ff       	call   801051f2 <stosb>
8010529d:	83 c4 0c             	add    $0xc,%esp
  return dst;
801052a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
801052a3:	c9                   	leave  
801052a4:	c3                   	ret    

801052a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801052a5:	55                   	push   %ebp
801052a6:	89 e5                	mov    %esp,%ebp
801052a8:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801052ab:	8b 45 08             	mov    0x8(%ebp),%eax
801052ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801052b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801052b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801052b7:	eb 30                	jmp    801052e9 <memcmp+0x44>
    if(*s1 != *s2)
801052b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052bc:	0f b6 10             	movzbl (%eax),%edx
801052bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052c2:	0f b6 00             	movzbl (%eax),%eax
801052c5:	38 c2                	cmp    %al,%dl
801052c7:	74 18                	je     801052e1 <memcmp+0x3c>
      return *s1 - *s2;
801052c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052cc:	0f b6 00             	movzbl (%eax),%eax
801052cf:	0f b6 d0             	movzbl %al,%edx
801052d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052d5:	0f b6 00             	movzbl (%eax),%eax
801052d8:	0f b6 c8             	movzbl %al,%ecx
801052db:	89 d0                	mov    %edx,%eax
801052dd:	29 c8                	sub    %ecx,%eax
801052df:	eb 1a                	jmp    801052fb <memcmp+0x56>
    s1++, s2++;
801052e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801052e5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
801052e9:	8b 45 10             	mov    0x10(%ebp),%eax
801052ec:	8d 50 ff             	lea    -0x1(%eax),%edx
801052ef:	89 55 10             	mov    %edx,0x10(%ebp)
801052f2:	85 c0                	test   %eax,%eax
801052f4:	75 c3                	jne    801052b9 <memcmp+0x14>
  }

  return 0;
801052f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052fb:	c9                   	leave  
801052fc:	c3                   	ret    

801052fd <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801052fd:	55                   	push   %ebp
801052fe:	89 e5                	mov    %esp,%ebp
80105300:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105303:	8b 45 0c             	mov    0xc(%ebp),%eax
80105306:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105309:	8b 45 08             	mov    0x8(%ebp),%eax
8010530c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010530f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105312:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105315:	73 54                	jae    8010536b <memmove+0x6e>
80105317:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010531a:	8b 45 10             	mov    0x10(%ebp),%eax
8010531d:	01 d0                	add    %edx,%eax
8010531f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80105322:	73 47                	jae    8010536b <memmove+0x6e>
    s += n;
80105324:	8b 45 10             	mov    0x10(%ebp),%eax
80105327:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010532a:	8b 45 10             	mov    0x10(%ebp),%eax
8010532d:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105330:	eb 13                	jmp    80105345 <memmove+0x48>
      *--d = *--s;
80105332:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105336:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010533a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010533d:	0f b6 10             	movzbl (%eax),%edx
80105340:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105343:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105345:	8b 45 10             	mov    0x10(%ebp),%eax
80105348:	8d 50 ff             	lea    -0x1(%eax),%edx
8010534b:	89 55 10             	mov    %edx,0x10(%ebp)
8010534e:	85 c0                	test   %eax,%eax
80105350:	75 e0                	jne    80105332 <memmove+0x35>
  if(s < d && s + n > d){
80105352:	eb 24                	jmp    80105378 <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
80105354:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105357:	8d 42 01             	lea    0x1(%edx),%eax
8010535a:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010535d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105360:	8d 48 01             	lea    0x1(%eax),%ecx
80105363:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80105366:	0f b6 12             	movzbl (%edx),%edx
80105369:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
8010536b:	8b 45 10             	mov    0x10(%ebp),%eax
8010536e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105371:	89 55 10             	mov    %edx,0x10(%ebp)
80105374:	85 c0                	test   %eax,%eax
80105376:	75 dc                	jne    80105354 <memmove+0x57>

  return dst;
80105378:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010537b:	c9                   	leave  
8010537c:	c3                   	ret    

8010537d <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010537d:	55                   	push   %ebp
8010537e:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105380:	ff 75 10             	pushl  0x10(%ebp)
80105383:	ff 75 0c             	pushl  0xc(%ebp)
80105386:	ff 75 08             	pushl  0x8(%ebp)
80105389:	e8 6f ff ff ff       	call   801052fd <memmove>
8010538e:	83 c4 0c             	add    $0xc,%esp
}
80105391:	c9                   	leave  
80105392:	c3                   	ret    

80105393 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105393:	55                   	push   %ebp
80105394:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105396:	eb 0c                	jmp    801053a4 <strncmp+0x11>
    n--, p++, q++;
80105398:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010539c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801053a0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
801053a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053a8:	74 1a                	je     801053c4 <strncmp+0x31>
801053aa:	8b 45 08             	mov    0x8(%ebp),%eax
801053ad:	0f b6 00             	movzbl (%eax),%eax
801053b0:	84 c0                	test   %al,%al
801053b2:	74 10                	je     801053c4 <strncmp+0x31>
801053b4:	8b 45 08             	mov    0x8(%ebp),%eax
801053b7:	0f b6 10             	movzbl (%eax),%edx
801053ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801053bd:	0f b6 00             	movzbl (%eax),%eax
801053c0:	38 c2                	cmp    %al,%dl
801053c2:	74 d4                	je     80105398 <strncmp+0x5>
  if(n == 0)
801053c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053c8:	75 07                	jne    801053d1 <strncmp+0x3e>
    return 0;
801053ca:	b8 00 00 00 00       	mov    $0x0,%eax
801053cf:	eb 16                	jmp    801053e7 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801053d1:	8b 45 08             	mov    0x8(%ebp),%eax
801053d4:	0f b6 00             	movzbl (%eax),%eax
801053d7:	0f b6 d0             	movzbl %al,%edx
801053da:	8b 45 0c             	mov    0xc(%ebp),%eax
801053dd:	0f b6 00             	movzbl (%eax),%eax
801053e0:	0f b6 c8             	movzbl %al,%ecx
801053e3:	89 d0                	mov    %edx,%eax
801053e5:	29 c8                	sub    %ecx,%eax
}
801053e7:	5d                   	pop    %ebp
801053e8:	c3                   	ret    

801053e9 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053e9:	55                   	push   %ebp
801053ea:	89 e5                	mov    %esp,%ebp
801053ec:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801053ef:	8b 45 08             	mov    0x8(%ebp),%eax
801053f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801053f5:	90                   	nop
801053f6:	8b 45 10             	mov    0x10(%ebp),%eax
801053f9:	8d 50 ff             	lea    -0x1(%eax),%edx
801053fc:	89 55 10             	mov    %edx,0x10(%ebp)
801053ff:	85 c0                	test   %eax,%eax
80105401:	7e 2c                	jle    8010542f <strncpy+0x46>
80105403:	8b 55 0c             	mov    0xc(%ebp),%edx
80105406:	8d 42 01             	lea    0x1(%edx),%eax
80105409:	89 45 0c             	mov    %eax,0xc(%ebp)
8010540c:	8b 45 08             	mov    0x8(%ebp),%eax
8010540f:	8d 48 01             	lea    0x1(%eax),%ecx
80105412:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105415:	0f b6 12             	movzbl (%edx),%edx
80105418:	88 10                	mov    %dl,(%eax)
8010541a:	0f b6 00             	movzbl (%eax),%eax
8010541d:	84 c0                	test   %al,%al
8010541f:	75 d5                	jne    801053f6 <strncpy+0xd>
    ;
  while(n-- > 0)
80105421:	eb 0c                	jmp    8010542f <strncpy+0x46>
    *s++ = 0;
80105423:	8b 45 08             	mov    0x8(%ebp),%eax
80105426:	8d 50 01             	lea    0x1(%eax),%edx
80105429:	89 55 08             	mov    %edx,0x8(%ebp)
8010542c:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
8010542f:	8b 45 10             	mov    0x10(%ebp),%eax
80105432:	8d 50 ff             	lea    -0x1(%eax),%edx
80105435:	89 55 10             	mov    %edx,0x10(%ebp)
80105438:	85 c0                	test   %eax,%eax
8010543a:	7f e7                	jg     80105423 <strncpy+0x3a>
  return os;
8010543c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010543f:	c9                   	leave  
80105440:	c3                   	ret    

80105441 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105441:	55                   	push   %ebp
80105442:	89 e5                	mov    %esp,%ebp
80105444:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105447:	8b 45 08             	mov    0x8(%ebp),%eax
8010544a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010544d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105451:	7f 05                	jg     80105458 <safestrcpy+0x17>
    return os;
80105453:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105456:	eb 31                	jmp    80105489 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105458:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010545c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105460:	7e 1e                	jle    80105480 <safestrcpy+0x3f>
80105462:	8b 55 0c             	mov    0xc(%ebp),%edx
80105465:	8d 42 01             	lea    0x1(%edx),%eax
80105468:	89 45 0c             	mov    %eax,0xc(%ebp)
8010546b:	8b 45 08             	mov    0x8(%ebp),%eax
8010546e:	8d 48 01             	lea    0x1(%eax),%ecx
80105471:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105474:	0f b6 12             	movzbl (%edx),%edx
80105477:	88 10                	mov    %dl,(%eax)
80105479:	0f b6 00             	movzbl (%eax),%eax
8010547c:	84 c0                	test   %al,%al
8010547e:	75 d8                	jne    80105458 <safestrcpy+0x17>
    ;
  *s = 0;
80105480:	8b 45 08             	mov    0x8(%ebp),%eax
80105483:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105486:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105489:	c9                   	leave  
8010548a:	c3                   	ret    

8010548b <strlen>:

int
strlen(const char *s)
{
8010548b:	55                   	push   %ebp
8010548c:	89 e5                	mov    %esp,%ebp
8010548e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105498:	eb 04                	jmp    8010549e <strlen+0x13>
8010549a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010549e:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054a1:	8b 45 08             	mov    0x8(%ebp),%eax
801054a4:	01 d0                	add    %edx,%eax
801054a6:	0f b6 00             	movzbl (%eax),%eax
801054a9:	84 c0                	test   %al,%al
801054ab:	75 ed                	jne    8010549a <strlen+0xf>
    ;
  return n;
801054ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054b0:	c9                   	leave  
801054b1:	c3                   	ret    

801054b2 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801054b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801054b6:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801054ba:	55                   	push   %ebp
  pushl %ebx
801054bb:	53                   	push   %ebx
  pushl %esi
801054bc:	56                   	push   %esi
  pushl %edi
801054bd:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801054be:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801054c0:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801054c2:	5f                   	pop    %edi
  popl %esi
801054c3:	5e                   	pop    %esi
  popl %ebx
801054c4:	5b                   	pop    %ebx
  popl %ebp
801054c5:	5d                   	pop    %ebp
  ret
801054c6:	c3                   	ret    

801054c7 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801054c7:	55                   	push   %ebp
801054c8:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801054ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054d0:	8b 00                	mov    (%eax),%eax
801054d2:	39 45 08             	cmp    %eax,0x8(%ebp)
801054d5:	73 12                	jae    801054e9 <fetchint+0x22>
801054d7:	8b 45 08             	mov    0x8(%ebp),%eax
801054da:	8d 50 04             	lea    0x4(%eax),%edx
801054dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054e3:	8b 00                	mov    (%eax),%eax
801054e5:	39 c2                	cmp    %eax,%edx
801054e7:	76 07                	jbe    801054f0 <fetchint+0x29>
    return -1;
801054e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ee:	eb 0f                	jmp    801054ff <fetchint+0x38>
  *ip = *(int*)(addr);
801054f0:	8b 45 08             	mov    0x8(%ebp),%eax
801054f3:	8b 10                	mov    (%eax),%edx
801054f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801054f8:	89 10                	mov    %edx,(%eax)
  return 0;
801054fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054ff:	5d                   	pop    %ebp
80105500:	c3                   	ret    

80105501 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105501:	55                   	push   %ebp
80105502:	89 e5                	mov    %esp,%ebp
80105504:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105507:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010550d:	8b 00                	mov    (%eax),%eax
8010550f:	39 45 08             	cmp    %eax,0x8(%ebp)
80105512:	72 07                	jb     8010551b <fetchstr+0x1a>
    return -1;
80105514:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105519:	eb 44                	jmp    8010555f <fetchstr+0x5e>
  *pp = (char*)addr;
8010551b:	8b 55 08             	mov    0x8(%ebp),%edx
8010551e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105521:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105523:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105529:	8b 00                	mov    (%eax),%eax
8010552b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010552e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105531:	8b 00                	mov    (%eax),%eax
80105533:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105536:	eb 1a                	jmp    80105552 <fetchstr+0x51>
    if(*s == 0)
80105538:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010553b:	0f b6 00             	movzbl (%eax),%eax
8010553e:	84 c0                	test   %al,%al
80105540:	75 0c                	jne    8010554e <fetchstr+0x4d>
      return s - *pp;
80105542:	8b 45 0c             	mov    0xc(%ebp),%eax
80105545:	8b 10                	mov    (%eax),%edx
80105547:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010554a:	29 d0                	sub    %edx,%eax
8010554c:	eb 11                	jmp    8010555f <fetchstr+0x5e>
  for(s = *pp; s < ep; s++)
8010554e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105552:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105555:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105558:	72 de                	jb     80105538 <fetchstr+0x37>
  return -1;
8010555a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010555f:	c9                   	leave  
80105560:	c3                   	ret    

80105561 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105561:	55                   	push   %ebp
80105562:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105564:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010556a:	8b 40 18             	mov    0x18(%eax),%eax
8010556d:	8b 50 44             	mov    0x44(%eax),%edx
80105570:	8b 45 08             	mov    0x8(%ebp),%eax
80105573:	c1 e0 02             	shl    $0x2,%eax
80105576:	01 d0                	add    %edx,%eax
80105578:	83 c0 04             	add    $0x4,%eax
8010557b:	ff 75 0c             	pushl  0xc(%ebp)
8010557e:	50                   	push   %eax
8010557f:	e8 43 ff ff ff       	call   801054c7 <fetchint>
80105584:	83 c4 08             	add    $0x8,%esp
}
80105587:	c9                   	leave  
80105588:	c3                   	ret    

80105589 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105589:	55                   	push   %ebp
8010558a:	89 e5                	mov    %esp,%ebp
8010558c:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
8010558f:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105592:	50                   	push   %eax
80105593:	ff 75 08             	pushl  0x8(%ebp)
80105596:	e8 c6 ff ff ff       	call   80105561 <argint>
8010559b:	83 c4 08             	add    $0x8,%esp
8010559e:	85 c0                	test   %eax,%eax
801055a0:	79 07                	jns    801055a9 <argptr+0x20>
    return -1;
801055a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055a7:	eb 3b                	jmp    801055e4 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801055a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055af:	8b 00                	mov    (%eax),%eax
801055b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055b4:	39 d0                	cmp    %edx,%eax
801055b6:	76 16                	jbe    801055ce <argptr+0x45>
801055b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055bb:	89 c2                	mov    %eax,%edx
801055bd:	8b 45 10             	mov    0x10(%ebp),%eax
801055c0:	01 c2                	add    %eax,%edx
801055c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055c8:	8b 00                	mov    (%eax),%eax
801055ca:	39 c2                	cmp    %eax,%edx
801055cc:	76 07                	jbe    801055d5 <argptr+0x4c>
    return -1;
801055ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d3:	eb 0f                	jmp    801055e4 <argptr+0x5b>
  *pp = (char*)i;
801055d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055d8:	89 c2                	mov    %eax,%edx
801055da:	8b 45 0c             	mov    0xc(%ebp),%eax
801055dd:	89 10                	mov    %edx,(%eax)
  return 0;
801055df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055e4:	c9                   	leave  
801055e5:	c3                   	ret    

801055e6 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801055e6:	55                   	push   %ebp
801055e7:	89 e5                	mov    %esp,%ebp
801055e9:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
801055ec:	8d 45 fc             	lea    -0x4(%ebp),%eax
801055ef:	50                   	push   %eax
801055f0:	ff 75 08             	pushl  0x8(%ebp)
801055f3:	e8 69 ff ff ff       	call   80105561 <argint>
801055f8:	83 c4 08             	add    $0x8,%esp
801055fb:	85 c0                	test   %eax,%eax
801055fd:	79 07                	jns    80105606 <argstr+0x20>
    return -1;
801055ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105604:	eb 0f                	jmp    80105615 <argstr+0x2f>
  return fetchstr(addr, pp);
80105606:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105609:	ff 75 0c             	pushl  0xc(%ebp)
8010560c:	50                   	push   %eax
8010560d:	e8 ef fe ff ff       	call   80105501 <fetchstr>
80105612:	83 c4 08             	add    $0x8,%esp
}
80105615:	c9                   	leave  
80105616:	c3                   	ret    

80105617 <syscall>:
[SYS_close]   		sys_close,
};

void
syscall(void)
{
80105617:	55                   	push   %ebp
80105618:	89 e5                	mov    %esp,%ebp
8010561a:	83 ec 18             	sub    $0x18,%esp
  int num;

  num = proc->tf->eax;
8010561d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105623:	8b 40 18             	mov    0x18(%eax),%eax
80105626:	8b 40 1c             	mov    0x1c(%eax),%eax
80105629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num >= 0 && num < SYS_open && syscalls[num]) {
8010562c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105630:	78 30                	js     80105662 <syscall+0x4b>
80105632:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
80105636:	7f 2a                	jg     80105662 <syscall+0x4b>
80105638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010563b:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105642:	85 c0                	test   %eax,%eax
80105644:	74 1c                	je     80105662 <syscall+0x4b>
    proc->tf->eax = syscalls[num]();
80105646:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105649:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105650:	ff d0                	call   *%eax
80105652:	89 c2                	mov    %eax,%edx
80105654:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010565a:	8b 40 18             	mov    0x18(%eax),%eax
8010565d:	89 50 1c             	mov    %edx,0x1c(%eax)
80105660:	eb 6d                	jmp    801056cf <syscall+0xb8>
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
80105662:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
80105666:	7e 32                	jle    8010569a <syscall+0x83>
80105668:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010566b:	83 f8 1a             	cmp    $0x1a,%eax
8010566e:	77 2a                	ja     8010569a <syscall+0x83>
80105670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105673:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010567a:	85 c0                	test   %eax,%eax
8010567c:	74 1c                	je     8010569a <syscall+0x83>
    proc->tf->eax = syscalls[num]();
8010567e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105681:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105688:	ff d0                	call   *%eax
8010568a:	89 c2                	mov    %eax,%edx
8010568c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105692:	8b 40 18             	mov    0x18(%eax),%eax
80105695:	89 50 1c             	mov    %edx,0x1c(%eax)
80105698:	eb 35                	jmp    801056cf <syscall+0xb8>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
8010569a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056a0:	8d 50 6c             	lea    0x6c(%eax),%edx
801056a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("%d %s: unknown sys call %d\n",
801056a9:	8b 40 10             	mov    0x10(%eax),%eax
801056ac:	ff 75 f4             	pushl  -0xc(%ebp)
801056af:	52                   	push   %edx
801056b0:	50                   	push   %eax
801056b1:	68 78 89 10 80       	push   $0x80108978
801056b6:	e8 0b ad ff ff       	call   801003c6 <cprintf>
801056bb:	83 c4 10             	add    $0x10,%esp
    proc->tf->eax = -1;
801056be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056c4:	8b 40 18             	mov    0x18(%eax),%eax
801056c7:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801056ce:	90                   	nop
801056cf:	90                   	nop
801056d0:	c9                   	leave  
801056d1:	c3                   	ret    

801056d2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801056d2:	55                   	push   %ebp
801056d3:	89 e5                	mov    %esp,%ebp
801056d5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801056d8:	83 ec 08             	sub    $0x8,%esp
801056db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056de:	50                   	push   %eax
801056df:	ff 75 08             	pushl  0x8(%ebp)
801056e2:	e8 7a fe ff ff       	call   80105561 <argint>
801056e7:	83 c4 10             	add    $0x10,%esp
801056ea:	85 c0                	test   %eax,%eax
801056ec:	79 07                	jns    801056f5 <argfd+0x23>
    return -1;
801056ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f3:	eb 50                	jmp    80105745 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801056f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f8:	85 c0                	test   %eax,%eax
801056fa:	78 21                	js     8010571d <argfd+0x4b>
801056fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056ff:	83 f8 0f             	cmp    $0xf,%eax
80105702:	7f 19                	jg     8010571d <argfd+0x4b>
80105704:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010570a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010570d:	83 c2 08             	add    $0x8,%edx
80105710:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105714:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105717:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010571b:	75 07                	jne    80105724 <argfd+0x52>
    return -1;
8010571d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105722:	eb 21                	jmp    80105745 <argfd+0x73>
  if(pfd)
80105724:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105728:	74 08                	je     80105732 <argfd+0x60>
    *pfd = fd;
8010572a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010572d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105730:	89 10                	mov    %edx,(%eax)
  if(pf)
80105732:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105736:	74 08                	je     80105740 <argfd+0x6e>
    *pf = f;
80105738:	8b 45 10             	mov    0x10(%ebp),%eax
8010573b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010573e:	89 10                	mov    %edx,(%eax)
  return 0;
80105740:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105745:	c9                   	leave  
80105746:	c3                   	ret    

80105747 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105747:	55                   	push   %ebp
80105748:	89 e5                	mov    %esp,%ebp
8010574a:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010574d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105754:	eb 30                	jmp    80105786 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105756:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010575c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010575f:	83 c2 08             	add    $0x8,%edx
80105762:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105766:	85 c0                	test   %eax,%eax
80105768:	75 18                	jne    80105782 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010576a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105770:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105773:	8d 4a 08             	lea    0x8(%edx),%ecx
80105776:	8b 55 08             	mov    0x8(%ebp),%edx
80105779:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010577d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105780:	eb 0f                	jmp    80105791 <fdalloc+0x4a>
  for(fd = 0; fd < NOFILE; fd++){
80105782:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105786:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
8010578a:	7e ca                	jle    80105756 <fdalloc+0xf>
    }
  }
  return -1;
8010578c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105791:	c9                   	leave  
80105792:	c3                   	ret    

80105793 <sys_dup>:

int
sys_dup(void)
{
80105793:	55                   	push   %ebp
80105794:	89 e5                	mov    %esp,%ebp
80105796:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105799:	83 ec 04             	sub    $0x4,%esp
8010579c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010579f:	50                   	push   %eax
801057a0:	6a 00                	push   $0x0
801057a2:	6a 00                	push   $0x0
801057a4:	e8 29 ff ff ff       	call   801056d2 <argfd>
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	85 c0                	test   %eax,%eax
801057ae:	79 07                	jns    801057b7 <sys_dup+0x24>
    return -1;
801057b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b5:	eb 31                	jmp    801057e8 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801057b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ba:	83 ec 0c             	sub    $0xc,%esp
801057bd:	50                   	push   %eax
801057be:	e8 84 ff ff ff       	call   80105747 <fdalloc>
801057c3:	83 c4 10             	add    $0x10,%esp
801057c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057cd:	79 07                	jns    801057d6 <sys_dup+0x43>
    return -1;
801057cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d4:	eb 12                	jmp    801057e8 <sys_dup+0x55>
  filedup(f);
801057d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d9:	83 ec 0c             	sub    $0xc,%esp
801057dc:	50                   	push   %eax
801057dd:	e8 23 b8 ff ff       	call   80101005 <filedup>
801057e2:	83 c4 10             	add    $0x10,%esp
  return fd;
801057e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801057e8:	c9                   	leave  
801057e9:	c3                   	ret    

801057ea <sys_read>:

int
sys_read(void)
{
801057ea:	55                   	push   %ebp
801057eb:	89 e5                	mov    %esp,%ebp
801057ed:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057f0:	83 ec 04             	sub    $0x4,%esp
801057f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057f6:	50                   	push   %eax
801057f7:	6a 00                	push   $0x0
801057f9:	6a 00                	push   $0x0
801057fb:	e8 d2 fe ff ff       	call   801056d2 <argfd>
80105800:	83 c4 10             	add    $0x10,%esp
80105803:	85 c0                	test   %eax,%eax
80105805:	78 2e                	js     80105835 <sys_read+0x4b>
80105807:	83 ec 08             	sub    $0x8,%esp
8010580a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010580d:	50                   	push   %eax
8010580e:	6a 02                	push   $0x2
80105810:	e8 4c fd ff ff       	call   80105561 <argint>
80105815:	83 c4 10             	add    $0x10,%esp
80105818:	85 c0                	test   %eax,%eax
8010581a:	78 19                	js     80105835 <sys_read+0x4b>
8010581c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010581f:	83 ec 04             	sub    $0x4,%esp
80105822:	50                   	push   %eax
80105823:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105826:	50                   	push   %eax
80105827:	6a 01                	push   $0x1
80105829:	e8 5b fd ff ff       	call   80105589 <argptr>
8010582e:	83 c4 10             	add    $0x10,%esp
80105831:	85 c0                	test   %eax,%eax
80105833:	79 07                	jns    8010583c <sys_read+0x52>
    return -1;
80105835:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583a:	eb 17                	jmp    80105853 <sys_read+0x69>
  return fileread(f, p, n);
8010583c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010583f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105842:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105845:	83 ec 04             	sub    $0x4,%esp
80105848:	51                   	push   %ecx
80105849:	52                   	push   %edx
8010584a:	50                   	push   %eax
8010584b:	e8 45 b9 ff ff       	call   80101195 <fileread>
80105850:	83 c4 10             	add    $0x10,%esp
}
80105853:	c9                   	leave  
80105854:	c3                   	ret    

80105855 <sys_write>:

int
sys_write(void)
{
80105855:	55                   	push   %ebp
80105856:	89 e5                	mov    %esp,%ebp
80105858:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010585b:	83 ec 04             	sub    $0x4,%esp
8010585e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105861:	50                   	push   %eax
80105862:	6a 00                	push   $0x0
80105864:	6a 00                	push   $0x0
80105866:	e8 67 fe ff ff       	call   801056d2 <argfd>
8010586b:	83 c4 10             	add    $0x10,%esp
8010586e:	85 c0                	test   %eax,%eax
80105870:	78 2e                	js     801058a0 <sys_write+0x4b>
80105872:	83 ec 08             	sub    $0x8,%esp
80105875:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105878:	50                   	push   %eax
80105879:	6a 02                	push   $0x2
8010587b:	e8 e1 fc ff ff       	call   80105561 <argint>
80105880:	83 c4 10             	add    $0x10,%esp
80105883:	85 c0                	test   %eax,%eax
80105885:	78 19                	js     801058a0 <sys_write+0x4b>
80105887:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010588a:	83 ec 04             	sub    $0x4,%esp
8010588d:	50                   	push   %eax
8010588e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105891:	50                   	push   %eax
80105892:	6a 01                	push   $0x1
80105894:	e8 f0 fc ff ff       	call   80105589 <argptr>
80105899:	83 c4 10             	add    $0x10,%esp
8010589c:	85 c0                	test   %eax,%eax
8010589e:	79 07                	jns    801058a7 <sys_write+0x52>
    return -1;
801058a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a5:	eb 17                	jmp    801058be <sys_write+0x69>
  return filewrite(f, p, n);
801058a7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801058aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
801058ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058b0:	83 ec 04             	sub    $0x4,%esp
801058b3:	51                   	push   %ecx
801058b4:	52                   	push   %edx
801058b5:	50                   	push   %eax
801058b6:	e8 92 b9 ff ff       	call   8010124d <filewrite>
801058bb:	83 c4 10             	add    $0x10,%esp
}
801058be:	c9                   	leave  
801058bf:	c3                   	ret    

801058c0 <sys_close>:

int
sys_close(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801058c6:	83 ec 04             	sub    $0x4,%esp
801058c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058cc:	50                   	push   %eax
801058cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058d0:	50                   	push   %eax
801058d1:	6a 00                	push   $0x0
801058d3:	e8 fa fd ff ff       	call   801056d2 <argfd>
801058d8:	83 c4 10             	add    $0x10,%esp
801058db:	85 c0                	test   %eax,%eax
801058dd:	79 07                	jns    801058e6 <sys_close+0x26>
    return -1;
801058df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058e4:	eb 28                	jmp    8010590e <sys_close+0x4e>
  proc->ofile[fd] = 0;
801058e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058ef:	83 c2 08             	add    $0x8,%edx
801058f2:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801058f9:	00 
  fileclose(f);
801058fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058fd:	83 ec 0c             	sub    $0xc,%esp
80105900:	50                   	push   %eax
80105901:	e8 50 b7 ff ff       	call   80101056 <fileclose>
80105906:	83 c4 10             	add    $0x10,%esp
  return 0;
80105909:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010590e:	c9                   	leave  
8010590f:	c3                   	ret    

80105910 <sys_fstat>:

int
sys_fstat(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105916:	83 ec 04             	sub    $0x4,%esp
80105919:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010591c:	50                   	push   %eax
8010591d:	6a 00                	push   $0x0
8010591f:	6a 00                	push   $0x0
80105921:	e8 ac fd ff ff       	call   801056d2 <argfd>
80105926:	83 c4 10             	add    $0x10,%esp
80105929:	85 c0                	test   %eax,%eax
8010592b:	78 17                	js     80105944 <sys_fstat+0x34>
8010592d:	83 ec 04             	sub    $0x4,%esp
80105930:	6a 14                	push   $0x14
80105932:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105935:	50                   	push   %eax
80105936:	6a 01                	push   $0x1
80105938:	e8 4c fc ff ff       	call   80105589 <argptr>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	79 07                	jns    8010594b <sys_fstat+0x3b>
    return -1;
80105944:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105949:	eb 13                	jmp    8010595e <sys_fstat+0x4e>
  return filestat(f, st);
8010594b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010594e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105951:	83 ec 08             	sub    $0x8,%esp
80105954:	52                   	push   %edx
80105955:	50                   	push   %eax
80105956:	e8 e3 b7 ff ff       	call   8010113e <filestat>
8010595b:	83 c4 10             	add    $0x10,%esp
}
8010595e:	c9                   	leave  
8010595f:	c3                   	ret    

80105960 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105966:	83 ec 08             	sub    $0x8,%esp
80105969:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010596c:	50                   	push   %eax
8010596d:	6a 00                	push   $0x0
8010596f:	e8 72 fc ff ff       	call   801055e6 <argstr>
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	85 c0                	test   %eax,%eax
80105979:	78 15                	js     80105990 <sys_link+0x30>
8010597b:	83 ec 08             	sub    $0x8,%esp
8010597e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105981:	50                   	push   %eax
80105982:	6a 01                	push   $0x1
80105984:	e8 5d fc ff ff       	call   801055e6 <argstr>
80105989:	83 c4 10             	add    $0x10,%esp
8010598c:	85 c0                	test   %eax,%eax
8010598e:	79 0a                	jns    8010599a <sys_link+0x3a>
    return -1;
80105990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105995:	e9 63 01 00 00       	jmp    80105afd <sys_link+0x19d>
  if((ip = namei(old)) == 0)
8010599a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010599d:	83 ec 0c             	sub    $0xc,%esp
801059a0:	50                   	push   %eax
801059a1:	e8 30 cb ff ff       	call   801024d6 <namei>
801059a6:	83 c4 10             	add    $0x10,%esp
801059a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059b0:	75 0a                	jne    801059bc <sys_link+0x5c>
    return -1;
801059b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059b7:	e9 41 01 00 00       	jmp    80105afd <sys_link+0x19d>

  begin_trans();
801059bc:	e8 ea d8 ff ff       	call   801032ab <begin_trans>

  ilock(ip);
801059c1:	83 ec 0c             	sub    $0xc,%esp
801059c4:	ff 75 f4             	pushl  -0xc(%ebp)
801059c7:	e8 5f bf ff ff       	call   8010192b <ilock>
801059cc:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
801059cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801059d6:	66 83 f8 01          	cmp    $0x1,%ax
801059da:	75 1d                	jne    801059f9 <sys_link+0x99>
    iunlockput(ip);
801059dc:	83 ec 0c             	sub    $0xc,%esp
801059df:	ff 75 f4             	pushl  -0xc(%ebp)
801059e2:	e8 fe c1 ff ff       	call   80101be5 <iunlockput>
801059e7:	83 c4 10             	add    $0x10,%esp
    commit_trans();
801059ea:	e8 0f d9 ff ff       	call   801032fe <commit_trans>
    return -1;
801059ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f4:	e9 04 01 00 00       	jmp    80105afd <sys_link+0x19d>
  }

  ip->nlink++;
801059f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059fc:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a00:	83 c0 01             	add    $0x1,%eax
80105a03:	89 c2                	mov    %eax,%edx
80105a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a08:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105a0c:	83 ec 0c             	sub    $0xc,%esp
80105a0f:	ff 75 f4             	pushl  -0xc(%ebp)
80105a12:	e8 40 bd ff ff       	call   80101757 <iupdate>
80105a17:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105a1a:	83 ec 0c             	sub    $0xc,%esp
80105a1d:	ff 75 f4             	pushl  -0xc(%ebp)
80105a20:	e8 5e c0 ff ff       	call   80101a83 <iunlock>
80105a25:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105a28:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a2b:	83 ec 08             	sub    $0x8,%esp
80105a2e:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105a31:	52                   	push   %edx
80105a32:	50                   	push   %eax
80105a33:	e8 ba ca ff ff       	call   801024f2 <nameiparent>
80105a38:	83 c4 10             	add    $0x10,%esp
80105a3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a42:	74 71                	je     80105ab5 <sys_link+0x155>
    goto bad;
  ilock(dp);
80105a44:	83 ec 0c             	sub    $0xc,%esp
80105a47:	ff 75 f0             	pushl  -0x10(%ebp)
80105a4a:	e8 dc be ff ff       	call   8010192b <ilock>
80105a4f:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a55:	8b 10                	mov    (%eax),%edx
80105a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a5a:	8b 00                	mov    (%eax),%eax
80105a5c:	39 c2                	cmp    %eax,%edx
80105a5e:	75 1d                	jne    80105a7d <sys_link+0x11d>
80105a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a63:	8b 40 04             	mov    0x4(%eax),%eax
80105a66:	83 ec 04             	sub    $0x4,%esp
80105a69:	50                   	push   %eax
80105a6a:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105a6d:	50                   	push   %eax
80105a6e:	ff 75 f0             	pushl  -0x10(%ebp)
80105a71:	e8 c8 c7 ff ff       	call   8010223e <dirlink>
80105a76:	83 c4 10             	add    $0x10,%esp
80105a79:	85 c0                	test   %eax,%eax
80105a7b:	79 10                	jns    80105a8d <sys_link+0x12d>
    iunlockput(dp);
80105a7d:	83 ec 0c             	sub    $0xc,%esp
80105a80:	ff 75 f0             	pushl  -0x10(%ebp)
80105a83:	e8 5d c1 ff ff       	call   80101be5 <iunlockput>
80105a88:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105a8b:	eb 29                	jmp    80105ab6 <sys_link+0x156>
  }
  iunlockput(dp);
80105a8d:	83 ec 0c             	sub    $0xc,%esp
80105a90:	ff 75 f0             	pushl  -0x10(%ebp)
80105a93:	e8 4d c1 ff ff       	call   80101be5 <iunlockput>
80105a98:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105a9b:	83 ec 0c             	sub    $0xc,%esp
80105a9e:	ff 75 f4             	pushl  -0xc(%ebp)
80105aa1:	e8 4f c0 ff ff       	call   80101af5 <iput>
80105aa6:	83 c4 10             	add    $0x10,%esp

  commit_trans();
80105aa9:	e8 50 d8 ff ff       	call   801032fe <commit_trans>

  return 0;
80105aae:	b8 00 00 00 00       	mov    $0x0,%eax
80105ab3:	eb 48                	jmp    80105afd <sys_link+0x19d>
    goto bad;
80105ab5:	90                   	nop

bad:
  ilock(ip);
80105ab6:	83 ec 0c             	sub    $0xc,%esp
80105ab9:	ff 75 f4             	pushl  -0xc(%ebp)
80105abc:	e8 6a be ff ff       	call   8010192b <ilock>
80105ac1:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac7:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105acb:	83 e8 01             	sub    $0x1,%eax
80105ace:	89 c2                	mov    %eax,%edx
80105ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad3:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ad7:	83 ec 0c             	sub    $0xc,%esp
80105ada:	ff 75 f4             	pushl  -0xc(%ebp)
80105add:	e8 75 bc ff ff       	call   80101757 <iupdate>
80105ae2:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105ae5:	83 ec 0c             	sub    $0xc,%esp
80105ae8:	ff 75 f4             	pushl  -0xc(%ebp)
80105aeb:	e8 f5 c0 ff ff       	call   80101be5 <iunlockput>
80105af0:	83 c4 10             	add    $0x10,%esp
  commit_trans();
80105af3:	e8 06 d8 ff ff       	call   801032fe <commit_trans>
  return -1;
80105af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105afd:	c9                   	leave  
80105afe:	c3                   	ret    

80105aff <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105aff:	55                   	push   %ebp
80105b00:	89 e5                	mov    %esp,%ebp
80105b02:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b05:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105b0c:	eb 40                	jmp    80105b4e <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b11:	6a 10                	push   $0x10
80105b13:	50                   	push   %eax
80105b14:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b17:	50                   	push   %eax
80105b18:	ff 75 08             	pushl  0x8(%ebp)
80105b1b:	e8 6e c3 ff ff       	call   80101e8e <readi>
80105b20:	83 c4 10             	add    $0x10,%esp
80105b23:	83 f8 10             	cmp    $0x10,%eax
80105b26:	74 0d                	je     80105b35 <isdirempty+0x36>
      panic("isdirempty: readi");
80105b28:	83 ec 0c             	sub    $0xc,%esp
80105b2b:	68 94 89 10 80       	push   $0x80108994
80105b30:	e8 46 aa ff ff       	call   8010057b <panic>
    if(de.inum != 0)
80105b35:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105b39:	66 85 c0             	test   %ax,%ax
80105b3c:	74 07                	je     80105b45 <isdirempty+0x46>
      return 0;
80105b3e:	b8 00 00 00 00       	mov    $0x0,%eax
80105b43:	eb 1b                	jmp    80105b60 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b48:	83 c0 10             	add    $0x10,%eax
80105b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b4e:	8b 45 08             	mov    0x8(%ebp),%eax
80105b51:	8b 50 18             	mov    0x18(%eax),%edx
80105b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b57:	39 c2                	cmp    %eax,%edx
80105b59:	77 b3                	ja     80105b0e <isdirempty+0xf>
  }
  return 1;
80105b5b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b60:	c9                   	leave  
80105b61:	c3                   	ret    

80105b62 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b62:	55                   	push   %ebp
80105b63:	89 e5                	mov    %esp,%ebp
80105b65:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b68:	83 ec 08             	sub    $0x8,%esp
80105b6b:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105b6e:	50                   	push   %eax
80105b6f:	6a 00                	push   $0x0
80105b71:	e8 70 fa ff ff       	call   801055e6 <argstr>
80105b76:	83 c4 10             	add    $0x10,%esp
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	79 0a                	jns    80105b87 <sys_unlink+0x25>
    return -1;
80105b7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b82:	e9 ba 01 00 00       	jmp    80105d41 <sys_unlink+0x1df>
  if((dp = nameiparent(path, name)) == 0)
80105b87:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105b8a:	83 ec 08             	sub    $0x8,%esp
80105b8d:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105b90:	52                   	push   %edx
80105b91:	50                   	push   %eax
80105b92:	e8 5b c9 ff ff       	call   801024f2 <nameiparent>
80105b97:	83 c4 10             	add    $0x10,%esp
80105b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ba1:	75 0a                	jne    80105bad <sys_unlink+0x4b>
    return -1;
80105ba3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba8:	e9 94 01 00 00       	jmp    80105d41 <sys_unlink+0x1df>

  begin_trans();
80105bad:	e8 f9 d6 ff ff       	call   801032ab <begin_trans>

  ilock(dp);
80105bb2:	83 ec 0c             	sub    $0xc,%esp
80105bb5:	ff 75 f4             	pushl  -0xc(%ebp)
80105bb8:	e8 6e bd ff ff       	call   8010192b <ilock>
80105bbd:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105bc0:	83 ec 08             	sub    $0x8,%esp
80105bc3:	68 a6 89 10 80       	push   $0x801089a6
80105bc8:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105bcb:	50                   	push   %eax
80105bcc:	e8 98 c5 ff ff       	call   80102169 <namecmp>
80105bd1:	83 c4 10             	add    $0x10,%esp
80105bd4:	85 c0                	test   %eax,%eax
80105bd6:	0f 84 49 01 00 00    	je     80105d25 <sys_unlink+0x1c3>
80105bdc:	83 ec 08             	sub    $0x8,%esp
80105bdf:	68 a8 89 10 80       	push   $0x801089a8
80105be4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105be7:	50                   	push   %eax
80105be8:	e8 7c c5 ff ff       	call   80102169 <namecmp>
80105bed:	83 c4 10             	add    $0x10,%esp
80105bf0:	85 c0                	test   %eax,%eax
80105bf2:	0f 84 2d 01 00 00    	je     80105d25 <sys_unlink+0x1c3>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105bf8:	83 ec 04             	sub    $0x4,%esp
80105bfb:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105bfe:	50                   	push   %eax
80105bff:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c02:	50                   	push   %eax
80105c03:	ff 75 f4             	pushl  -0xc(%ebp)
80105c06:	e8 79 c5 ff ff       	call   80102184 <dirlookup>
80105c0b:	83 c4 10             	add    $0x10,%esp
80105c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c15:	0f 84 0d 01 00 00    	je     80105d28 <sys_unlink+0x1c6>
    goto bad;
  ilock(ip);
80105c1b:	83 ec 0c             	sub    $0xc,%esp
80105c1e:	ff 75 f0             	pushl  -0x10(%ebp)
80105c21:	e8 05 bd ff ff       	call   8010192b <ilock>
80105c26:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c2c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c30:	66 85 c0             	test   %ax,%ax
80105c33:	7f 0d                	jg     80105c42 <sys_unlink+0xe0>
    panic("unlink: nlink < 1");
80105c35:	83 ec 0c             	sub    $0xc,%esp
80105c38:	68 ab 89 10 80       	push   $0x801089ab
80105c3d:	e8 39 a9 ff ff       	call   8010057b <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c45:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c49:	66 83 f8 01          	cmp    $0x1,%ax
80105c4d:	75 25                	jne    80105c74 <sys_unlink+0x112>
80105c4f:	83 ec 0c             	sub    $0xc,%esp
80105c52:	ff 75 f0             	pushl  -0x10(%ebp)
80105c55:	e8 a5 fe ff ff       	call   80105aff <isdirempty>
80105c5a:	83 c4 10             	add    $0x10,%esp
80105c5d:	85 c0                	test   %eax,%eax
80105c5f:	75 13                	jne    80105c74 <sys_unlink+0x112>
    iunlockput(ip);
80105c61:	83 ec 0c             	sub    $0xc,%esp
80105c64:	ff 75 f0             	pushl  -0x10(%ebp)
80105c67:	e8 79 bf ff ff       	call   80101be5 <iunlockput>
80105c6c:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105c6f:	e9 b5 00 00 00       	jmp    80105d29 <sys_unlink+0x1c7>
  }

  memset(&de, 0, sizeof(de));
80105c74:	83 ec 04             	sub    $0x4,%esp
80105c77:	6a 10                	push   $0x10
80105c79:	6a 00                	push   $0x0
80105c7b:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c7e:	50                   	push   %eax
80105c7f:	e8 ba f5 ff ff       	call   8010523e <memset>
80105c84:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c87:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105c8a:	6a 10                	push   $0x10
80105c8c:	50                   	push   %eax
80105c8d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c90:	50                   	push   %eax
80105c91:	ff 75 f4             	pushl  -0xc(%ebp)
80105c94:	e8 4a c3 ff ff       	call   80101fe3 <writei>
80105c99:	83 c4 10             	add    $0x10,%esp
80105c9c:	83 f8 10             	cmp    $0x10,%eax
80105c9f:	74 0d                	je     80105cae <sys_unlink+0x14c>
    panic("unlink: writei");
80105ca1:	83 ec 0c             	sub    $0xc,%esp
80105ca4:	68 bd 89 10 80       	push   $0x801089bd
80105ca9:	e8 cd a8 ff ff       	call   8010057b <panic>
  if(ip->type == T_DIR){
80105cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cb1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105cb5:	66 83 f8 01          	cmp    $0x1,%ax
80105cb9:	75 21                	jne    80105cdc <sys_unlink+0x17a>
    dp->nlink--;
80105cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cbe:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105cc2:	83 e8 01             	sub    $0x1,%eax
80105cc5:	89 c2                	mov    %eax,%edx
80105cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cca:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105cce:	83 ec 0c             	sub    $0xc,%esp
80105cd1:	ff 75 f4             	pushl  -0xc(%ebp)
80105cd4:	e8 7e ba ff ff       	call   80101757 <iupdate>
80105cd9:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105cdc:	83 ec 0c             	sub    $0xc,%esp
80105cdf:	ff 75 f4             	pushl  -0xc(%ebp)
80105ce2:	e8 fe be ff ff       	call   80101be5 <iunlockput>
80105ce7:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ced:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105cf1:	83 e8 01             	sub    $0x1,%eax
80105cf4:	89 c2                	mov    %eax,%edx
80105cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf9:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105cfd:	83 ec 0c             	sub    $0xc,%esp
80105d00:	ff 75 f0             	pushl  -0x10(%ebp)
80105d03:	e8 4f ba ff ff       	call   80101757 <iupdate>
80105d08:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105d0b:	83 ec 0c             	sub    $0xc,%esp
80105d0e:	ff 75 f0             	pushl  -0x10(%ebp)
80105d11:	e8 cf be ff ff       	call   80101be5 <iunlockput>
80105d16:	83 c4 10             	add    $0x10,%esp

  commit_trans();
80105d19:	e8 e0 d5 ff ff       	call   801032fe <commit_trans>

  return 0;
80105d1e:	b8 00 00 00 00       	mov    $0x0,%eax
80105d23:	eb 1c                	jmp    80105d41 <sys_unlink+0x1df>
    goto bad;
80105d25:	90                   	nop
80105d26:	eb 01                	jmp    80105d29 <sys_unlink+0x1c7>
    goto bad;
80105d28:	90                   	nop

bad:
  iunlockput(dp);
80105d29:	83 ec 0c             	sub    $0xc,%esp
80105d2c:	ff 75 f4             	pushl  -0xc(%ebp)
80105d2f:	e8 b1 be ff ff       	call   80101be5 <iunlockput>
80105d34:	83 c4 10             	add    $0x10,%esp
  commit_trans();
80105d37:	e8 c2 d5 ff ff       	call   801032fe <commit_trans>
  return -1;
80105d3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d41:	c9                   	leave  
80105d42:	c3                   	ret    

80105d43 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105d43:	55                   	push   %ebp
80105d44:	89 e5                	mov    %esp,%ebp
80105d46:	83 ec 38             	sub    $0x38,%esp
80105d49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105d4c:	8b 55 10             	mov    0x10(%ebp),%edx
80105d4f:	8b 45 14             	mov    0x14(%ebp),%eax
80105d52:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105d56:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105d5a:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d5e:	83 ec 08             	sub    $0x8,%esp
80105d61:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d64:	50                   	push   %eax
80105d65:	ff 75 08             	pushl  0x8(%ebp)
80105d68:	e8 85 c7 ff ff       	call   801024f2 <nameiparent>
80105d6d:	83 c4 10             	add    $0x10,%esp
80105d70:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d77:	75 0a                	jne    80105d83 <create+0x40>
    return 0;
80105d79:	b8 00 00 00 00       	mov    $0x0,%eax
80105d7e:	e9 90 01 00 00       	jmp    80105f13 <create+0x1d0>
  ilock(dp);
80105d83:	83 ec 0c             	sub    $0xc,%esp
80105d86:	ff 75 f4             	pushl  -0xc(%ebp)
80105d89:	e8 9d bb ff ff       	call   8010192b <ilock>
80105d8e:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105d91:	83 ec 04             	sub    $0x4,%esp
80105d94:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d97:	50                   	push   %eax
80105d98:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d9b:	50                   	push   %eax
80105d9c:	ff 75 f4             	pushl  -0xc(%ebp)
80105d9f:	e8 e0 c3 ff ff       	call   80102184 <dirlookup>
80105da4:	83 c4 10             	add    $0x10,%esp
80105da7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105daa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105dae:	74 50                	je     80105e00 <create+0xbd>
    iunlockput(dp);
80105db0:	83 ec 0c             	sub    $0xc,%esp
80105db3:	ff 75 f4             	pushl  -0xc(%ebp)
80105db6:	e8 2a be ff ff       	call   80101be5 <iunlockput>
80105dbb:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105dbe:	83 ec 0c             	sub    $0xc,%esp
80105dc1:	ff 75 f0             	pushl  -0x10(%ebp)
80105dc4:	e8 62 bb ff ff       	call   8010192b <ilock>
80105dc9:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105dcc:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105dd1:	75 15                	jne    80105de8 <create+0xa5>
80105dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105dda:	66 83 f8 02          	cmp    $0x2,%ax
80105dde:	75 08                	jne    80105de8 <create+0xa5>
      return ip;
80105de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de3:	e9 2b 01 00 00       	jmp    80105f13 <create+0x1d0>
    iunlockput(ip);
80105de8:	83 ec 0c             	sub    $0xc,%esp
80105deb:	ff 75 f0             	pushl  -0x10(%ebp)
80105dee:	e8 f2 bd ff ff       	call   80101be5 <iunlockput>
80105df3:	83 c4 10             	add    $0x10,%esp
    return 0;
80105df6:	b8 00 00 00 00       	mov    $0x0,%eax
80105dfb:	e9 13 01 00 00       	jmp    80105f13 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105e00:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e07:	8b 00                	mov    (%eax),%eax
80105e09:	83 ec 08             	sub    $0x8,%esp
80105e0c:	52                   	push   %edx
80105e0d:	50                   	push   %eax
80105e0e:	e8 63 b8 ff ff       	call   80101676 <ialloc>
80105e13:	83 c4 10             	add    $0x10,%esp
80105e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e1d:	75 0d                	jne    80105e2c <create+0xe9>
    panic("create: ialloc");
80105e1f:	83 ec 0c             	sub    $0xc,%esp
80105e22:	68 cc 89 10 80       	push   $0x801089cc
80105e27:	e8 4f a7 ff ff       	call   8010057b <panic>

  ilock(ip);
80105e2c:	83 ec 0c             	sub    $0xc,%esp
80105e2f:	ff 75 f0             	pushl  -0x10(%ebp)
80105e32:	e8 f4 ba ff ff       	call   8010192b <ilock>
80105e37:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e3d:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105e41:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e48:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105e4c:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e53:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105e59:	83 ec 0c             	sub    $0xc,%esp
80105e5c:	ff 75 f0             	pushl  -0x10(%ebp)
80105e5f:	e8 f3 b8 ff ff       	call   80101757 <iupdate>
80105e64:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105e67:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e6c:	75 6a                	jne    80105ed8 <create+0x195>
    dp->nlink++;  // for ".."
80105e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e71:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e75:	83 c0 01             	add    $0x1,%eax
80105e78:	89 c2                	mov    %eax,%edx
80105e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e7d:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105e81:	83 ec 0c             	sub    $0xc,%esp
80105e84:	ff 75 f4             	pushl  -0xc(%ebp)
80105e87:	e8 cb b8 ff ff       	call   80101757 <iupdate>
80105e8c:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e92:	8b 40 04             	mov    0x4(%eax),%eax
80105e95:	83 ec 04             	sub    $0x4,%esp
80105e98:	50                   	push   %eax
80105e99:	68 a6 89 10 80       	push   $0x801089a6
80105e9e:	ff 75 f0             	pushl  -0x10(%ebp)
80105ea1:	e8 98 c3 ff ff       	call   8010223e <dirlink>
80105ea6:	83 c4 10             	add    $0x10,%esp
80105ea9:	85 c0                	test   %eax,%eax
80105eab:	78 1e                	js     80105ecb <create+0x188>
80105ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb0:	8b 40 04             	mov    0x4(%eax),%eax
80105eb3:	83 ec 04             	sub    $0x4,%esp
80105eb6:	50                   	push   %eax
80105eb7:	68 a8 89 10 80       	push   $0x801089a8
80105ebc:	ff 75 f0             	pushl  -0x10(%ebp)
80105ebf:	e8 7a c3 ff ff       	call   8010223e <dirlink>
80105ec4:	83 c4 10             	add    $0x10,%esp
80105ec7:	85 c0                	test   %eax,%eax
80105ec9:	79 0d                	jns    80105ed8 <create+0x195>
      panic("create dots");
80105ecb:	83 ec 0c             	sub    $0xc,%esp
80105ece:	68 db 89 10 80       	push   $0x801089db
80105ed3:	e8 a3 a6 ff ff       	call   8010057b <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105edb:	8b 40 04             	mov    0x4(%eax),%eax
80105ede:	83 ec 04             	sub    $0x4,%esp
80105ee1:	50                   	push   %eax
80105ee2:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ee5:	50                   	push   %eax
80105ee6:	ff 75 f4             	pushl  -0xc(%ebp)
80105ee9:	e8 50 c3 ff ff       	call   8010223e <dirlink>
80105eee:	83 c4 10             	add    $0x10,%esp
80105ef1:	85 c0                	test   %eax,%eax
80105ef3:	79 0d                	jns    80105f02 <create+0x1bf>
    panic("create: dirlink");
80105ef5:	83 ec 0c             	sub    $0xc,%esp
80105ef8:	68 e7 89 10 80       	push   $0x801089e7
80105efd:	e8 79 a6 ff ff       	call   8010057b <panic>

  iunlockput(dp);
80105f02:	83 ec 0c             	sub    $0xc,%esp
80105f05:	ff 75 f4             	pushl  -0xc(%ebp)
80105f08:	e8 d8 bc ff ff       	call   80101be5 <iunlockput>
80105f0d:	83 c4 10             	add    $0x10,%esp

  return ip;
80105f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105f13:	c9                   	leave  
80105f14:	c3                   	ret    

80105f15 <sys_open>:

int
sys_open(void)
{
80105f15:	55                   	push   %ebp
80105f16:	89 e5                	mov    %esp,%ebp
80105f18:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f1b:	83 ec 08             	sub    $0x8,%esp
80105f1e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105f21:	50                   	push   %eax
80105f22:	6a 00                	push   $0x0
80105f24:	e8 bd f6 ff ff       	call   801055e6 <argstr>
80105f29:	83 c4 10             	add    $0x10,%esp
80105f2c:	85 c0                	test   %eax,%eax
80105f2e:	78 15                	js     80105f45 <sys_open+0x30>
80105f30:	83 ec 08             	sub    $0x8,%esp
80105f33:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f36:	50                   	push   %eax
80105f37:	6a 01                	push   $0x1
80105f39:	e8 23 f6 ff ff       	call   80105561 <argint>
80105f3e:	83 c4 10             	add    $0x10,%esp
80105f41:	85 c0                	test   %eax,%eax
80105f43:	79 0a                	jns    80105f4f <sys_open+0x3a>
    return -1;
80105f45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f4a:	e9 4d 01 00 00       	jmp    8010609c <sys_open+0x187>
  if(omode & O_CREATE){
80105f4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f52:	25 00 02 00 00       	and    $0x200,%eax
80105f57:	85 c0                	test   %eax,%eax
80105f59:	74 2f                	je     80105f8a <sys_open+0x75>
    begin_trans();
80105f5b:	e8 4b d3 ff ff       	call   801032ab <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105f60:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f63:	6a 00                	push   $0x0
80105f65:	6a 00                	push   $0x0
80105f67:	6a 02                	push   $0x2
80105f69:	50                   	push   %eax
80105f6a:	e8 d4 fd ff ff       	call   80105d43 <create>
80105f6f:	83 c4 10             	add    $0x10,%esp
80105f72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105f75:	e8 84 d3 ff ff       	call   801032fe <commit_trans>
    if(ip == 0)
80105f7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f7e:	75 66                	jne    80105fe6 <sys_open+0xd1>
      return -1;
80105f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f85:	e9 12 01 00 00       	jmp    8010609c <sys_open+0x187>
  } else {
    if((ip = namei(path)) == 0)
80105f8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f8d:	83 ec 0c             	sub    $0xc,%esp
80105f90:	50                   	push   %eax
80105f91:	e8 40 c5 ff ff       	call   801024d6 <namei>
80105f96:	83 c4 10             	add    $0x10,%esp
80105f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fa0:	75 0a                	jne    80105fac <sys_open+0x97>
      return -1;
80105fa2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa7:	e9 f0 00 00 00       	jmp    8010609c <sys_open+0x187>
    ilock(ip);
80105fac:	83 ec 0c             	sub    $0xc,%esp
80105faf:	ff 75 f4             	pushl  -0xc(%ebp)
80105fb2:	e8 74 b9 ff ff       	call   8010192b <ilock>
80105fb7:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fbd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105fc1:	66 83 f8 01          	cmp    $0x1,%ax
80105fc5:	75 1f                	jne    80105fe6 <sys_open+0xd1>
80105fc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fca:	85 c0                	test   %eax,%eax
80105fcc:	74 18                	je     80105fe6 <sys_open+0xd1>
      iunlockput(ip);
80105fce:	83 ec 0c             	sub    $0xc,%esp
80105fd1:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd4:	e8 0c bc ff ff       	call   80101be5 <iunlockput>
80105fd9:	83 c4 10             	add    $0x10,%esp
      return -1;
80105fdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe1:	e9 b6 00 00 00       	jmp    8010609c <sys_open+0x187>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105fe6:	e8 ad af ff ff       	call   80100f98 <filealloc>
80105feb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ff2:	74 17                	je     8010600b <sys_open+0xf6>
80105ff4:	83 ec 0c             	sub    $0xc,%esp
80105ff7:	ff 75 f0             	pushl  -0x10(%ebp)
80105ffa:	e8 48 f7 ff ff       	call   80105747 <fdalloc>
80105fff:	83 c4 10             	add    $0x10,%esp
80106002:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106005:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106009:	79 29                	jns    80106034 <sys_open+0x11f>
    if(f)
8010600b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010600f:	74 0e                	je     8010601f <sys_open+0x10a>
      fileclose(f);
80106011:	83 ec 0c             	sub    $0xc,%esp
80106014:	ff 75 f0             	pushl  -0x10(%ebp)
80106017:	e8 3a b0 ff ff       	call   80101056 <fileclose>
8010601c:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010601f:	83 ec 0c             	sub    $0xc,%esp
80106022:	ff 75 f4             	pushl  -0xc(%ebp)
80106025:	e8 bb bb ff ff       	call   80101be5 <iunlockput>
8010602a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010602d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106032:	eb 68                	jmp    8010609c <sys_open+0x187>
  }
  iunlock(ip);
80106034:	83 ec 0c             	sub    $0xc,%esp
80106037:	ff 75 f4             	pushl  -0xc(%ebp)
8010603a:	e8 44 ba ff ff       	call   80101a83 <iunlock>
8010603f:	83 c4 10             	add    $0x10,%esp

  f->type = FD_INODE;
80106042:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106045:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010604b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010604e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106051:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106054:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106057:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010605e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106061:	83 e0 01             	and    $0x1,%eax
80106064:	85 c0                	test   %eax,%eax
80106066:	0f 94 c0             	sete   %al
80106069:	89 c2                	mov    %eax,%edx
8010606b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010606e:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106074:	83 e0 01             	and    $0x1,%eax
80106077:	85 c0                	test   %eax,%eax
80106079:	75 0a                	jne    80106085 <sys_open+0x170>
8010607b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010607e:	83 e0 02             	and    $0x2,%eax
80106081:	85 c0                	test   %eax,%eax
80106083:	74 07                	je     8010608c <sys_open+0x177>
80106085:	b8 01 00 00 00       	mov    $0x1,%eax
8010608a:	eb 05                	jmp    80106091 <sys_open+0x17c>
8010608c:	b8 00 00 00 00       	mov    $0x0,%eax
80106091:	89 c2                	mov    %eax,%edx
80106093:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106096:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106099:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010609c:	c9                   	leave  
8010609d:	c3                   	ret    

8010609e <sys_mkdir>:

int
sys_mkdir(void)
{
8010609e:	55                   	push   %ebp
8010609f:	89 e5                	mov    %esp,%ebp
801060a1:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_trans();
801060a4:	e8 02 d2 ff ff       	call   801032ab <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801060a9:	83 ec 08             	sub    $0x8,%esp
801060ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060af:	50                   	push   %eax
801060b0:	6a 00                	push   $0x0
801060b2:	e8 2f f5 ff ff       	call   801055e6 <argstr>
801060b7:	83 c4 10             	add    $0x10,%esp
801060ba:	85 c0                	test   %eax,%eax
801060bc:	78 1b                	js     801060d9 <sys_mkdir+0x3b>
801060be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060c1:	6a 00                	push   $0x0
801060c3:	6a 00                	push   $0x0
801060c5:	6a 01                	push   $0x1
801060c7:	50                   	push   %eax
801060c8:	e8 76 fc ff ff       	call   80105d43 <create>
801060cd:	83 c4 10             	add    $0x10,%esp
801060d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060d7:	75 0c                	jne    801060e5 <sys_mkdir+0x47>
    commit_trans();
801060d9:	e8 20 d2 ff ff       	call   801032fe <commit_trans>
    return -1;
801060de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e3:	eb 18                	jmp    801060fd <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801060e5:	83 ec 0c             	sub    $0xc,%esp
801060e8:	ff 75 f4             	pushl  -0xc(%ebp)
801060eb:	e8 f5 ba ff ff       	call   80101be5 <iunlockput>
801060f0:	83 c4 10             	add    $0x10,%esp
  commit_trans();
801060f3:	e8 06 d2 ff ff       	call   801032fe <commit_trans>
  return 0;
801060f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060fd:	c9                   	leave  
801060fe:	c3                   	ret    

801060ff <sys_mknod>:

int
sys_mknod(void)
{
801060ff:	55                   	push   %ebp
80106100:	89 e5                	mov    %esp,%ebp
80106102:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80106105:	e8 a1 d1 ff ff       	call   801032ab <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
8010610a:	83 ec 08             	sub    $0x8,%esp
8010610d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106110:	50                   	push   %eax
80106111:	6a 00                	push   $0x0
80106113:	e8 ce f4 ff ff       	call   801055e6 <argstr>
80106118:	83 c4 10             	add    $0x10,%esp
8010611b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010611e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106122:	78 4f                	js     80106173 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80106124:	83 ec 08             	sub    $0x8,%esp
80106127:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010612a:	50                   	push   %eax
8010612b:	6a 01                	push   $0x1
8010612d:	e8 2f f4 ff ff       	call   80105561 <argint>
80106132:	83 c4 10             	add    $0x10,%esp
  if((len=argstr(0, &path)) < 0 ||
80106135:	85 c0                	test   %eax,%eax
80106137:	78 3a                	js     80106173 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
80106139:	83 ec 08             	sub    $0x8,%esp
8010613c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010613f:	50                   	push   %eax
80106140:	6a 02                	push   $0x2
80106142:	e8 1a f4 ff ff       	call   80105561 <argint>
80106147:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
8010614a:	85 c0                	test   %eax,%eax
8010614c:	78 25                	js     80106173 <sys_mknod+0x74>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010614e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106151:	0f bf c8             	movswl %ax,%ecx
80106154:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106157:	0f bf d0             	movswl %ax,%edx
8010615a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010615d:	51                   	push   %ecx
8010615e:	52                   	push   %edx
8010615f:	6a 03                	push   $0x3
80106161:	50                   	push   %eax
80106162:	e8 dc fb ff ff       	call   80105d43 <create>
80106167:	83 c4 10             	add    $0x10,%esp
8010616a:	89 45 f0             	mov    %eax,-0x10(%ebp)
     argint(2, &minor) < 0 ||
8010616d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106171:	75 0c                	jne    8010617f <sys_mknod+0x80>
    commit_trans();
80106173:	e8 86 d1 ff ff       	call   801032fe <commit_trans>
    return -1;
80106178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010617d:	eb 18                	jmp    80106197 <sys_mknod+0x98>
  }
  iunlockput(ip);
8010617f:	83 ec 0c             	sub    $0xc,%esp
80106182:	ff 75 f0             	pushl  -0x10(%ebp)
80106185:	e8 5b ba ff ff       	call   80101be5 <iunlockput>
8010618a:	83 c4 10             	add    $0x10,%esp
  commit_trans();
8010618d:	e8 6c d1 ff ff       	call   801032fe <commit_trans>
  return 0;
80106192:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106197:	c9                   	leave  
80106198:	c3                   	ret    

80106199 <sys_chdir>:

int
sys_chdir(void)
{
80106199:	55                   	push   %ebp
8010619a:	89 e5                	mov    %esp,%ebp
8010619c:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
8010619f:	83 ec 08             	sub    $0x8,%esp
801061a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061a5:	50                   	push   %eax
801061a6:	6a 00                	push   $0x0
801061a8:	e8 39 f4 ff ff       	call   801055e6 <argstr>
801061ad:	83 c4 10             	add    $0x10,%esp
801061b0:	85 c0                	test   %eax,%eax
801061b2:	78 18                	js     801061cc <sys_chdir+0x33>
801061b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061b7:	83 ec 0c             	sub    $0xc,%esp
801061ba:	50                   	push   %eax
801061bb:	e8 16 c3 ff ff       	call   801024d6 <namei>
801061c0:	83 c4 10             	add    $0x10,%esp
801061c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061ca:	75 07                	jne    801061d3 <sys_chdir+0x3a>
    return -1;
801061cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061d1:	eb 64                	jmp    80106237 <sys_chdir+0x9e>
  ilock(ip);
801061d3:	83 ec 0c             	sub    $0xc,%esp
801061d6:	ff 75 f4             	pushl  -0xc(%ebp)
801061d9:	e8 4d b7 ff ff       	call   8010192b <ilock>
801061de:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801061e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061e8:	66 83 f8 01          	cmp    $0x1,%ax
801061ec:	74 15                	je     80106203 <sys_chdir+0x6a>
    iunlockput(ip);
801061ee:	83 ec 0c             	sub    $0xc,%esp
801061f1:	ff 75 f4             	pushl  -0xc(%ebp)
801061f4:	e8 ec b9 ff ff       	call   80101be5 <iunlockput>
801061f9:	83 c4 10             	add    $0x10,%esp
    return -1;
801061fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106201:	eb 34                	jmp    80106237 <sys_chdir+0x9e>
  }
  iunlock(ip);
80106203:	83 ec 0c             	sub    $0xc,%esp
80106206:	ff 75 f4             	pushl  -0xc(%ebp)
80106209:	e8 75 b8 ff ff       	call   80101a83 <iunlock>
8010620e:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106211:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106217:	8b 40 68             	mov    0x68(%eax),%eax
8010621a:	83 ec 0c             	sub    $0xc,%esp
8010621d:	50                   	push   %eax
8010621e:	e8 d2 b8 ff ff       	call   80101af5 <iput>
80106223:	83 c4 10             	add    $0x10,%esp
  proc->cwd = ip;
80106226:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010622c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010622f:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106232:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106237:	c9                   	leave  
80106238:	c3                   	ret    

80106239 <sys_exec>:

int
sys_exec(void)
{
80106239:	55                   	push   %ebp
8010623a:	89 e5                	mov    %esp,%ebp
8010623c:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106242:	83 ec 08             	sub    $0x8,%esp
80106245:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106248:	50                   	push   %eax
80106249:	6a 00                	push   $0x0
8010624b:	e8 96 f3 ff ff       	call   801055e6 <argstr>
80106250:	83 c4 10             	add    $0x10,%esp
80106253:	85 c0                	test   %eax,%eax
80106255:	78 18                	js     8010626f <sys_exec+0x36>
80106257:	83 ec 08             	sub    $0x8,%esp
8010625a:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106260:	50                   	push   %eax
80106261:	6a 01                	push   $0x1
80106263:	e8 f9 f2 ff ff       	call   80105561 <argint>
80106268:	83 c4 10             	add    $0x10,%esp
8010626b:	85 c0                	test   %eax,%eax
8010626d:	79 0a                	jns    80106279 <sys_exec+0x40>
    return -1;
8010626f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106274:	e9 c6 00 00 00       	jmp    8010633f <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106279:	83 ec 04             	sub    $0x4,%esp
8010627c:	68 80 00 00 00       	push   $0x80
80106281:	6a 00                	push   $0x0
80106283:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106289:	50                   	push   %eax
8010628a:	e8 af ef ff ff       	call   8010523e <memset>
8010628f:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106292:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106299:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010629c:	83 f8 1f             	cmp    $0x1f,%eax
8010629f:	76 0a                	jbe    801062ab <sys_exec+0x72>
      return -1;
801062a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062a6:	e9 94 00 00 00       	jmp    8010633f <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801062ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ae:	c1 e0 02             	shl    $0x2,%eax
801062b1:	89 c2                	mov    %eax,%edx
801062b3:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801062b9:	01 c2                	add    %eax,%edx
801062bb:	83 ec 08             	sub    $0x8,%esp
801062be:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801062c4:	50                   	push   %eax
801062c5:	52                   	push   %edx
801062c6:	e8 fc f1 ff ff       	call   801054c7 <fetchint>
801062cb:	83 c4 10             	add    $0x10,%esp
801062ce:	85 c0                	test   %eax,%eax
801062d0:	79 07                	jns    801062d9 <sys_exec+0xa0>
      return -1;
801062d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062d7:	eb 66                	jmp    8010633f <sys_exec+0x106>
    if(uarg == 0){
801062d9:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801062df:	85 c0                	test   %eax,%eax
801062e1:	75 27                	jne    8010630a <sys_exec+0xd1>
      argv[i] = 0;
801062e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e6:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801062ed:	00 00 00 00 
      break;
801062f1:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801062f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f5:	83 ec 08             	sub    $0x8,%esp
801062f8:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801062fe:	52                   	push   %edx
801062ff:	50                   	push   %eax
80106300:	e8 7a a8 ff ff       	call   80100b7f <exec>
80106305:	83 c4 10             	add    $0x10,%esp
80106308:	eb 35                	jmp    8010633f <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
8010630a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106313:	c1 e0 02             	shl    $0x2,%eax
80106316:	01 c2                	add    %eax,%edx
80106318:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010631e:	83 ec 08             	sub    $0x8,%esp
80106321:	52                   	push   %edx
80106322:	50                   	push   %eax
80106323:	e8 d9 f1 ff ff       	call   80105501 <fetchstr>
80106328:	83 c4 10             	add    $0x10,%esp
8010632b:	85 c0                	test   %eax,%eax
8010632d:	79 07                	jns    80106336 <sys_exec+0xfd>
      return -1;
8010632f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106334:	eb 09                	jmp    8010633f <sys_exec+0x106>
  for(i=0;; i++){
80106336:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
8010633a:	e9 5a ff ff ff       	jmp    80106299 <sys_exec+0x60>
}
8010633f:	c9                   	leave  
80106340:	c3                   	ret    

80106341 <sys_pipe>:

int
sys_pipe(void)
{
80106341:	55                   	push   %ebp
80106342:	89 e5                	mov    %esp,%ebp
80106344:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106347:	83 ec 04             	sub    $0x4,%esp
8010634a:	6a 08                	push   $0x8
8010634c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010634f:	50                   	push   %eax
80106350:	6a 00                	push   $0x0
80106352:	e8 32 f2 ff ff       	call   80105589 <argptr>
80106357:	83 c4 10             	add    $0x10,%esp
8010635a:	85 c0                	test   %eax,%eax
8010635c:	79 0a                	jns    80106368 <sys_pipe+0x27>
    return -1;
8010635e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106363:	e9 af 00 00 00       	jmp    80106417 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106368:	83 ec 08             	sub    $0x8,%esp
8010636b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010636e:	50                   	push   %eax
8010636f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106372:	50                   	push   %eax
80106373:	e8 26 d9 ff ff       	call   80103c9e <pipealloc>
80106378:	83 c4 10             	add    $0x10,%esp
8010637b:	85 c0                	test   %eax,%eax
8010637d:	79 0a                	jns    80106389 <sys_pipe+0x48>
    return -1;
8010637f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106384:	e9 8e 00 00 00       	jmp    80106417 <sys_pipe+0xd6>
  fd0 = -1;
80106389:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106390:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106393:	83 ec 0c             	sub    $0xc,%esp
80106396:	50                   	push   %eax
80106397:	e8 ab f3 ff ff       	call   80105747 <fdalloc>
8010639c:	83 c4 10             	add    $0x10,%esp
8010639f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063a6:	78 18                	js     801063c0 <sys_pipe+0x7f>
801063a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063ab:	83 ec 0c             	sub    $0xc,%esp
801063ae:	50                   	push   %eax
801063af:	e8 93 f3 ff ff       	call   80105747 <fdalloc>
801063b4:	83 c4 10             	add    $0x10,%esp
801063b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063be:	79 3f                	jns    801063ff <sys_pipe+0xbe>
    if(fd0 >= 0)
801063c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063c4:	78 14                	js     801063da <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
801063c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063cf:	83 c2 08             	add    $0x8,%edx
801063d2:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801063d9:	00 
    fileclose(rf);
801063da:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063dd:	83 ec 0c             	sub    $0xc,%esp
801063e0:	50                   	push   %eax
801063e1:	e8 70 ac ff ff       	call   80101056 <fileclose>
801063e6:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801063e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063ec:	83 ec 0c             	sub    $0xc,%esp
801063ef:	50                   	push   %eax
801063f0:	e8 61 ac ff ff       	call   80101056 <fileclose>
801063f5:	83 c4 10             	add    $0x10,%esp
    return -1;
801063f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063fd:	eb 18                	jmp    80106417 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801063ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106402:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106405:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106407:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010640a:	8d 50 04             	lea    0x4(%eax),%edx
8010640d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106410:	89 02                	mov    %eax,(%edx)
  return 0;
80106412:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106417:	c9                   	leave  
80106418:	c3                   	ret    

80106419 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106419:	55                   	push   %ebp
8010641a:	89 e5                	mov    %esp,%ebp
8010641c:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010641f:	e8 b5 df ff ff       	call   801043d9 <fork>
}
80106424:	c9                   	leave  
80106425:	c3                   	ret    

80106426 <sys_exit>:

int
sys_exit(void)
{
80106426:	55                   	push   %ebp
80106427:	89 e5                	mov    %esp,%ebp
80106429:	83 ec 08             	sub    $0x8,%esp
  exit();
8010642c:	e8 15 e1 ff ff       	call   80104546 <exit>
  return 0;  // not reached
80106431:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106436:	c9                   	leave  
80106437:	c3                   	ret    

80106438 <sys_wait>:

int
sys_wait(void)
{
80106438:	55                   	push   %ebp
80106439:	89 e5                	mov    %esp,%ebp
8010643b:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010643e:	e8 82 e2 ff ff       	call   801046c5 <wait>
}
80106443:	c9                   	leave  
80106444:	c3                   	ret    

80106445 <sys_kill>:

int
sys_kill(void)
{
80106445:	55                   	push   %ebp
80106446:	89 e5                	mov    %esp,%ebp
80106448:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010644b:	83 ec 08             	sub    $0x8,%esp
8010644e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106451:	50                   	push   %eax
80106452:	6a 00                	push   $0x0
80106454:	e8 08 f1 ff ff       	call   80105561 <argint>
80106459:	83 c4 10             	add    $0x10,%esp
8010645c:	85 c0                	test   %eax,%eax
8010645e:	79 07                	jns    80106467 <sys_kill+0x22>
    return -1;
80106460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106465:	eb 0f                	jmp    80106476 <sys_kill+0x31>
  return kill(pid);
80106467:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010646a:	83 ec 0c             	sub    $0xc,%esp
8010646d:	50                   	push   %eax
8010646e:	e8 6f e6 ff ff       	call   80104ae2 <kill>
80106473:	83 c4 10             	add    $0x10,%esp
}
80106476:	c9                   	leave  
80106477:	c3                   	ret    

80106478 <sys_getpid>:

int
sys_getpid(void)
{
80106478:	55                   	push   %ebp
80106479:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010647b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106481:	8b 40 10             	mov    0x10(%eax),%eax
}
80106484:	5d                   	pop    %ebp
80106485:	c3                   	ret    

80106486 <sys_sbrk>:

int
sys_sbrk(void)
{
80106486:	55                   	push   %ebp
80106487:	89 e5                	mov    %esp,%ebp
80106489:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010648c:	83 ec 08             	sub    $0x8,%esp
8010648f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106492:	50                   	push   %eax
80106493:	6a 00                	push   $0x0
80106495:	e8 c7 f0 ff ff       	call   80105561 <argint>
8010649a:	83 c4 10             	add    $0x10,%esp
8010649d:	85 c0                	test   %eax,%eax
8010649f:	79 07                	jns    801064a8 <sys_sbrk+0x22>
    return -1;
801064a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064a6:	eb 28                	jmp    801064d0 <sys_sbrk+0x4a>
  addr = proc->sz;
801064a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064ae:	8b 00                	mov    (%eax),%eax
801064b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801064b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064b6:	83 ec 0c             	sub    $0xc,%esp
801064b9:	50                   	push   %eax
801064ba:	e8 77 de ff ff       	call   80104336 <growproc>
801064bf:	83 c4 10             	add    $0x10,%esp
801064c2:	85 c0                	test   %eax,%eax
801064c4:	79 07                	jns    801064cd <sys_sbrk+0x47>
    return -1;
801064c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064cb:	eb 03                	jmp    801064d0 <sys_sbrk+0x4a>
  return addr;
801064cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801064d0:	c9                   	leave  
801064d1:	c3                   	ret    

801064d2 <sys_sleep>:

int
sys_sleep(void)
{
801064d2:	55                   	push   %ebp
801064d3:	89 e5                	mov    %esp,%ebp
801064d5:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801064d8:	83 ec 08             	sub    $0x8,%esp
801064db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064de:	50                   	push   %eax
801064df:	6a 00                	push   $0x0
801064e1:	e8 7b f0 ff ff       	call   80105561 <argint>
801064e6:	83 c4 10             	add    $0x10,%esp
801064e9:	85 c0                	test   %eax,%eax
801064eb:	79 07                	jns    801064f4 <sys_sleep+0x22>
    return -1;
801064ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064f2:	eb 77                	jmp    8010656b <sys_sleep+0x99>
  acquire(&tickslock);
801064f4:	83 ec 0c             	sub    $0xc,%esp
801064f7:	68 40 2b 11 80       	push   $0x80112b40
801064fc:	e8 da ea ff ff       	call   80104fdb <acquire>
80106501:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106504:	a1 74 2b 11 80       	mov    0x80112b74,%eax
80106509:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010650c:	eb 39                	jmp    80106547 <sys_sleep+0x75>
    if(proc->killed){
8010650e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106514:	8b 40 24             	mov    0x24(%eax),%eax
80106517:	85 c0                	test   %eax,%eax
80106519:	74 17                	je     80106532 <sys_sleep+0x60>
      release(&tickslock);
8010651b:	83 ec 0c             	sub    $0xc,%esp
8010651e:	68 40 2b 11 80       	push   $0x80112b40
80106523:	e8 1a eb ff ff       	call   80105042 <release>
80106528:	83 c4 10             	add    $0x10,%esp
      return -1;
8010652b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106530:	eb 39                	jmp    8010656b <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106532:	83 ec 08             	sub    $0x8,%esp
80106535:	68 40 2b 11 80       	push   $0x80112b40
8010653a:	68 74 2b 11 80       	push   $0x80112b74
8010653f:	e8 78 e4 ff ff       	call   801049bc <sleep>
80106544:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80106547:	a1 74 2b 11 80       	mov    0x80112b74,%eax
8010654c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010654f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106552:	39 d0                	cmp    %edx,%eax
80106554:	72 b8                	jb     8010650e <sys_sleep+0x3c>
  }
  release(&tickslock);
80106556:	83 ec 0c             	sub    $0xc,%esp
80106559:	68 40 2b 11 80       	push   $0x80112b40
8010655e:	e8 df ea ff ff       	call   80105042 <release>
80106563:	83 c4 10             	add    $0x10,%esp
  return 0;
80106566:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010656b:	c9                   	leave  
8010656c:	c3                   	ret    

8010656d <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010656d:	55                   	push   %ebp
8010656e:	89 e5                	mov    %esp,%ebp
80106570:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
80106573:	83 ec 0c             	sub    $0xc,%esp
80106576:	68 40 2b 11 80       	push   $0x80112b40
8010657b:	e8 5b ea ff ff       	call   80104fdb <acquire>
80106580:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106583:	a1 74 2b 11 80       	mov    0x80112b74,%eax
80106588:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010658b:	83 ec 0c             	sub    $0xc,%esp
8010658e:	68 40 2b 11 80       	push   $0x80112b40
80106593:	e8 aa ea ff ff       	call   80105042 <release>
80106598:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010659b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010659e:	c9                   	leave  
8010659f:	c3                   	ret    

801065a0 <sys_sem_alloc>:
#include "types.h"
#include "defs.h"
#include "param.h"

int sys_sem_alloc(void){
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	83 ec 08             	sub    $0x8,%esp
	return sem_alloc();
801065a6:	e8 f9 e6 ff ff       	call   80104ca4 <sem_alloc>
}
801065ab:	c9                   	leave  
801065ac:	c3                   	ret    

801065ad <sys_sem_destroy>:

int sys_sem_destroy(int sem){
801065ad:	55                   	push   %ebp
801065ae:	89 e5                	mov    %esp,%ebp
801065b0:	83 ec 08             	sub    $0x8,%esp
	argint(0, &sem);
801065b3:	83 ec 08             	sub    $0x8,%esp
801065b6:	8d 45 08             	lea    0x8(%ebp),%eax
801065b9:	50                   	push   %eax
801065ba:	6a 00                	push   $0x0
801065bc:	e8 a0 ef ff ff       	call   80105561 <argint>
801065c1:	83 c4 10             	add    $0x10,%esp
	return sem_destroy(sem);
801065c4:	8b 45 08             	mov    0x8(%ebp),%eax
801065c7:	83 ec 0c             	sub    $0xc,%esp
801065ca:	50                   	push   %eax
801065cb:	e8 5e e7 ff ff       	call   80104d2e <sem_destroy>
801065d0:	83 c4 10             	add    $0x10,%esp
}
801065d3:	c9                   	leave  
801065d4:	c3                   	ret    

801065d5 <sys_sem_init>:

int sys_sem_init(int sem, int count){
801065d5:	55                   	push   %ebp
801065d6:	89 e5                	mov    %esp,%ebp
801065d8:	83 ec 08             	sub    $0x8,%esp
	argint(0, &sem);
801065db:	83 ec 08             	sub    $0x8,%esp
801065de:	8d 45 08             	lea    0x8(%ebp),%eax
801065e1:	50                   	push   %eax
801065e2:	6a 00                	push   $0x0
801065e4:	e8 78 ef ff ff       	call   80105561 <argint>
801065e9:	83 c4 10             	add    $0x10,%esp
	argint(1, &count);
801065ec:	83 ec 08             	sub    $0x8,%esp
801065ef:	8d 45 0c             	lea    0xc(%ebp),%eax
801065f2:	50                   	push   %eax
801065f3:	6a 01                	push   $0x1
801065f5:	e8 67 ef ff ff       	call   80105561 <argint>
801065fa:	83 c4 10             	add    $0x10,%esp
	return sem_init(sem, count);
801065fd:	8b 55 0c             	mov    0xc(%ebp),%edx
80106600:	8b 45 08             	mov    0x8(%ebp),%eax
80106603:	83 ec 08             	sub    $0x8,%esp
80106606:	52                   	push   %edx
80106607:	50                   	push   %eax
80106608:	e8 a6 e7 ff ff       	call   80104db3 <sem_init>
8010660d:	83 c4 10             	add    $0x10,%esp
}
80106610:	c9                   	leave  
80106611:	c3                   	ret    

80106612 <sys_sem_post>:

int sys_sem_post(int sem){
80106612:	55                   	push   %ebp
80106613:	89 e5                	mov    %esp,%ebp
80106615:	83 ec 08             	sub    $0x8,%esp
	argint(0, &sem);	
80106618:	83 ec 08             	sub    $0x8,%esp
8010661b:	8d 45 08             	lea    0x8(%ebp),%eax
8010661e:	50                   	push   %eax
8010661f:	6a 00                	push   $0x0
80106621:	e8 3b ef ff ff       	call   80105561 <argint>
80106626:	83 c4 10             	add    $0x10,%esp
	return sem_post(sem);
80106629:	8b 45 08             	mov    0x8(%ebp),%eax
8010662c:	83 ec 0c             	sub    $0xc,%esp
8010662f:	50                   	push   %eax
80106630:	e8 a6 e8 ff ff       	call   80104edb <sem_post>
80106635:	83 c4 10             	add    $0x10,%esp
}
80106638:	c9                   	leave  
80106639:	c3                   	ret    

8010663a <sys_sem_wait>:

int sys_sem_wait(int sem){
8010663a:	55                   	push   %ebp
8010663b:	89 e5                	mov    %esp,%ebp
8010663d:	83 ec 08             	sub    $0x8,%esp
	argint(0, &sem);	
80106640:	83 ec 08             	sub    $0x8,%esp
80106643:	8d 45 08             	lea    0x8(%ebp),%eax
80106646:	50                   	push   %eax
80106647:	6a 00                	push   $0x0
80106649:	e8 13 ef ff ff       	call   80105561 <argint>
8010664e:	83 c4 10             	add    $0x10,%esp
	return sem_wait(sem);
80106651:	8b 45 08             	mov    0x8(%ebp),%eax
80106654:	83 ec 0c             	sub    $0xc,%esp
80106657:	50                   	push   %eax
80106658:	e8 cd e7 ff ff       	call   80104e2a <sem_wait>
8010665d:	83 c4 10             	add    $0x10,%esp
}
80106660:	c9                   	leave  
80106661:	c3                   	ret    

80106662 <outb>:
{
80106662:	55                   	push   %ebp
80106663:	89 e5                	mov    %esp,%ebp
80106665:	83 ec 08             	sub    $0x8,%esp
80106668:	8b 45 08             	mov    0x8(%ebp),%eax
8010666b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010666e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106672:	89 d0                	mov    %edx,%eax
80106674:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106677:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010667b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010667f:	ee                   	out    %al,(%dx)
}
80106680:	90                   	nop
80106681:	c9                   	leave  
80106682:	c3                   	ret    

80106683 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106683:	55                   	push   %ebp
80106684:	89 e5                	mov    %esp,%ebp
80106686:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106689:	6a 34                	push   $0x34
8010668b:	6a 43                	push   $0x43
8010668d:	e8 d0 ff ff ff       	call   80106662 <outb>
80106692:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106695:	68 9c 00 00 00       	push   $0x9c
8010669a:	6a 40                	push   $0x40
8010669c:	e8 c1 ff ff ff       	call   80106662 <outb>
801066a1:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801066a4:	6a 2e                	push   $0x2e
801066a6:	6a 40                	push   $0x40
801066a8:	e8 b5 ff ff ff       	call   80106662 <outb>
801066ad:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
801066b0:	83 ec 0c             	sub    $0xc,%esp
801066b3:	6a 00                	push   $0x0
801066b5:	e8 ce d4 ff ff       	call   80103b88 <picenable>
801066ba:	83 c4 10             	add    $0x10,%esp
}
801066bd:	90                   	nop
801066be:	c9                   	leave  
801066bf:	c3                   	ret    

801066c0 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801066c0:	1e                   	push   %ds
  pushl %es
801066c1:	06                   	push   %es
  pushl %fs
801066c2:	0f a0                	push   %fs
  pushl %gs
801066c4:	0f a8                	push   %gs
  pushal
801066c6:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801066c7:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801066cb:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801066cd:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801066cf:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801066d3:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801066d5:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801066d7:	54                   	push   %esp
  call trap
801066d8:	e8 d7 01 00 00       	call   801068b4 <trap>
  addl $4, %esp
801066dd:	83 c4 04             	add    $0x4,%esp

801066e0 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801066e0:	61                   	popa   
  popl %gs
801066e1:	0f a9                	pop    %gs
  popl %fs
801066e3:	0f a1                	pop    %fs
  popl %es
801066e5:	07                   	pop    %es
  popl %ds
801066e6:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801066e7:	83 c4 08             	add    $0x8,%esp
  iret
801066ea:	cf                   	iret   

801066eb <lidt>:
{
801066eb:	55                   	push   %ebp
801066ec:	89 e5                	mov    %esp,%ebp
801066ee:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801066f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801066f4:	83 e8 01             	sub    $0x1,%eax
801066f7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801066fb:	8b 45 08             	mov    0x8(%ebp),%eax
801066fe:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106702:	8b 45 08             	mov    0x8(%ebp),%eax
80106705:	c1 e8 10             	shr    $0x10,%eax
80106708:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010670c:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010670f:	0f 01 18             	lidtl  (%eax)
}
80106712:	90                   	nop
80106713:	c9                   	leave  
80106714:	c3                   	ret    

80106715 <rcr2>:

static inline uint
rcr2(void)
{
80106715:	55                   	push   %ebp
80106716:	89 e5                	mov    %esp,%ebp
80106718:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010671b:	0f 20 d0             	mov    %cr2,%eax
8010671e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106721:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106724:	c9                   	leave  
80106725:	c3                   	ret    

80106726 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106726:	55                   	push   %ebp
80106727:	89 e5                	mov    %esp,%ebp
80106729:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
8010672c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106733:	e9 c3 00 00 00       	jmp    801067fb <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010673b:	8b 04 85 ac b0 10 80 	mov    -0x7fef4f54(,%eax,4),%eax
80106742:	89 c2                	mov    %eax,%edx
80106744:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106747:	66 89 14 c5 40 23 11 	mov    %dx,-0x7feedcc0(,%eax,8)
8010674e:	80 
8010674f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106752:	66 c7 04 c5 42 23 11 	movw   $0x8,-0x7feedcbe(,%eax,8)
80106759:	80 08 00 
8010675c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010675f:	0f b6 14 c5 44 23 11 	movzbl -0x7feedcbc(,%eax,8),%edx
80106766:	80 
80106767:	83 e2 e0             	and    $0xffffffe0,%edx
8010676a:	88 14 c5 44 23 11 80 	mov    %dl,-0x7feedcbc(,%eax,8)
80106771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106774:	0f b6 14 c5 44 23 11 	movzbl -0x7feedcbc(,%eax,8),%edx
8010677b:	80 
8010677c:	83 e2 1f             	and    $0x1f,%edx
8010677f:	88 14 c5 44 23 11 80 	mov    %dl,-0x7feedcbc(,%eax,8)
80106786:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106789:	0f b6 14 c5 45 23 11 	movzbl -0x7feedcbb(,%eax,8),%edx
80106790:	80 
80106791:	83 e2 f0             	and    $0xfffffff0,%edx
80106794:	83 ca 0e             	or     $0xe,%edx
80106797:	88 14 c5 45 23 11 80 	mov    %dl,-0x7feedcbb(,%eax,8)
8010679e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067a1:	0f b6 14 c5 45 23 11 	movzbl -0x7feedcbb(,%eax,8),%edx
801067a8:	80 
801067a9:	83 e2 ef             	and    $0xffffffef,%edx
801067ac:	88 14 c5 45 23 11 80 	mov    %dl,-0x7feedcbb(,%eax,8)
801067b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067b6:	0f b6 14 c5 45 23 11 	movzbl -0x7feedcbb(,%eax,8),%edx
801067bd:	80 
801067be:	83 e2 9f             	and    $0xffffff9f,%edx
801067c1:	88 14 c5 45 23 11 80 	mov    %dl,-0x7feedcbb(,%eax,8)
801067c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067cb:	0f b6 14 c5 45 23 11 	movzbl -0x7feedcbb(,%eax,8),%edx
801067d2:	80 
801067d3:	83 ca 80             	or     $0xffffff80,%edx
801067d6:	88 14 c5 45 23 11 80 	mov    %dl,-0x7feedcbb(,%eax,8)
801067dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067e0:	8b 04 85 ac b0 10 80 	mov    -0x7fef4f54(,%eax,4),%eax
801067e7:	c1 e8 10             	shr    $0x10,%eax
801067ea:	89 c2                	mov    %eax,%edx
801067ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ef:	66 89 14 c5 46 23 11 	mov    %dx,-0x7feedcba(,%eax,8)
801067f6:	80 
  for(i = 0; i < 256; i++)
801067f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801067fb:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106802:	0f 8e 30 ff ff ff    	jle    80106738 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106808:	a1 ac b1 10 80       	mov    0x8010b1ac,%eax
8010680d:	66 a3 40 25 11 80    	mov    %ax,0x80112540
80106813:	66 c7 05 42 25 11 80 	movw   $0x8,0x80112542
8010681a:	08 00 
8010681c:	0f b6 05 44 25 11 80 	movzbl 0x80112544,%eax
80106823:	83 e0 e0             	and    $0xffffffe0,%eax
80106826:	a2 44 25 11 80       	mov    %al,0x80112544
8010682b:	0f b6 05 44 25 11 80 	movzbl 0x80112544,%eax
80106832:	83 e0 1f             	and    $0x1f,%eax
80106835:	a2 44 25 11 80       	mov    %al,0x80112544
8010683a:	0f b6 05 45 25 11 80 	movzbl 0x80112545,%eax
80106841:	83 c8 0f             	or     $0xf,%eax
80106844:	a2 45 25 11 80       	mov    %al,0x80112545
80106849:	0f b6 05 45 25 11 80 	movzbl 0x80112545,%eax
80106850:	83 e0 ef             	and    $0xffffffef,%eax
80106853:	a2 45 25 11 80       	mov    %al,0x80112545
80106858:	0f b6 05 45 25 11 80 	movzbl 0x80112545,%eax
8010685f:	83 c8 60             	or     $0x60,%eax
80106862:	a2 45 25 11 80       	mov    %al,0x80112545
80106867:	0f b6 05 45 25 11 80 	movzbl 0x80112545,%eax
8010686e:	83 c8 80             	or     $0xffffff80,%eax
80106871:	a2 45 25 11 80       	mov    %al,0x80112545
80106876:	a1 ac b1 10 80       	mov    0x8010b1ac,%eax
8010687b:	c1 e8 10             	shr    $0x10,%eax
8010687e:	66 a3 46 25 11 80    	mov    %ax,0x80112546
  
  initlock(&tickslock, "time");
80106884:	83 ec 08             	sub    $0x8,%esp
80106887:	68 f8 89 10 80       	push   $0x801089f8
8010688c:	68 40 2b 11 80       	push   $0x80112b40
80106891:	e8 23 e7 ff ff       	call   80104fb9 <initlock>
80106896:	83 c4 10             	add    $0x10,%esp
}
80106899:	90                   	nop
8010689a:	c9                   	leave  
8010689b:	c3                   	ret    

8010689c <idtinit>:

void
idtinit(void)
{
8010689c:	55                   	push   %ebp
8010689d:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010689f:	68 00 08 00 00       	push   $0x800
801068a4:	68 40 23 11 80       	push   $0x80112340
801068a9:	e8 3d fe ff ff       	call   801066eb <lidt>
801068ae:	83 c4 08             	add    $0x8,%esp
}
801068b1:	90                   	nop
801068b2:	c9                   	leave  
801068b3:	c3                   	ret    

801068b4 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801068b4:	55                   	push   %ebp
801068b5:	89 e5                	mov    %esp,%ebp
801068b7:	57                   	push   %edi
801068b8:	56                   	push   %esi
801068b9:	53                   	push   %ebx
801068ba:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801068bd:	8b 45 08             	mov    0x8(%ebp),%eax
801068c0:	8b 40 30             	mov    0x30(%eax),%eax
801068c3:	83 f8 40             	cmp    $0x40,%eax
801068c6:	75 3e                	jne    80106906 <trap+0x52>
    if(proc->killed)
801068c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068ce:	8b 40 24             	mov    0x24(%eax),%eax
801068d1:	85 c0                	test   %eax,%eax
801068d3:	74 05                	je     801068da <trap+0x26>
      exit();
801068d5:	e8 6c dc ff ff       	call   80104546 <exit>
    proc->tf = tf;
801068da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068e0:	8b 55 08             	mov    0x8(%ebp),%edx
801068e3:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801068e6:	e8 2c ed ff ff       	call   80105617 <syscall>
    if(proc->killed)
801068eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068f1:	8b 40 24             	mov    0x24(%eax),%eax
801068f4:	85 c0                	test   %eax,%eax
801068f6:	0f 84 1c 02 00 00    	je     80106b18 <trap+0x264>
      exit();
801068fc:	e8 45 dc ff ff       	call   80104546 <exit>
    return;
80106901:	e9 12 02 00 00       	jmp    80106b18 <trap+0x264>
  }

  switch(tf->trapno){
80106906:	8b 45 08             	mov    0x8(%ebp),%eax
80106909:	8b 40 30             	mov    0x30(%eax),%eax
8010690c:	83 e8 20             	sub    $0x20,%eax
8010690f:	83 f8 1f             	cmp    $0x1f,%eax
80106912:	0f 87 c0 00 00 00    	ja     801069d8 <trap+0x124>
80106918:	8b 04 85 a0 8a 10 80 	mov    -0x7fef7560(,%eax,4),%eax
8010691f:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106921:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106927:	0f b6 00             	movzbl (%eax),%eax
8010692a:	84 c0                	test   %al,%al
8010692c:	75 3d                	jne    8010696b <trap+0xb7>
      acquire(&tickslock);
8010692e:	83 ec 0c             	sub    $0xc,%esp
80106931:	68 40 2b 11 80       	push   $0x80112b40
80106936:	e8 a0 e6 ff ff       	call   80104fdb <acquire>
8010693b:	83 c4 10             	add    $0x10,%esp
      ticks++;
8010693e:	a1 74 2b 11 80       	mov    0x80112b74,%eax
80106943:	83 c0 01             	add    $0x1,%eax
80106946:	a3 74 2b 11 80       	mov    %eax,0x80112b74
      wakeup(&ticks);
8010694b:	83 ec 0c             	sub    $0xc,%esp
8010694e:	68 74 2b 11 80       	push   $0x80112b74
80106953:	e8 53 e1 ff ff       	call   80104aab <wakeup>
80106958:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
8010695b:	83 ec 0c             	sub    $0xc,%esp
8010695e:	68 40 2b 11 80       	push   $0x80112b40
80106963:	e8 da e6 ff ff       	call   80105042 <release>
80106968:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
8010696b:	e8 11 c6 ff ff       	call   80102f81 <lapiceoi>
    break;
80106970:	e9 1d 01 00 00       	jmp    80106a92 <trap+0x1de>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106975:	e8 32 be ff ff       	call   801027ac <ideintr>
    lapiceoi();
8010697a:	e8 02 c6 ff ff       	call   80102f81 <lapiceoi>
    break;
8010697f:	e9 0e 01 00 00       	jmp    80106a92 <trap+0x1de>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106984:	e8 13 c4 ff ff       	call   80102d9c <kbdintr>
    lapiceoi();
80106989:	e8 f3 c5 ff ff       	call   80102f81 <lapiceoi>
    break;
8010698e:	e9 ff 00 00 00       	jmp    80106a92 <trap+0x1de>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106993:	e8 63 03 00 00       	call   80106cfb <uartintr>
    lapiceoi();
80106998:	e8 e4 c5 ff ff       	call   80102f81 <lapiceoi>
    break;
8010699d:	e9 f0 00 00 00       	jmp    80106a92 <trap+0x1de>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069a2:	8b 45 08             	mov    0x8(%ebp),%eax
801069a5:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801069a8:	8b 45 08             	mov    0x8(%ebp),%eax
801069ab:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069af:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801069b2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801069b8:	0f b6 00             	movzbl (%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069bb:	0f b6 c0             	movzbl %al,%eax
801069be:	51                   	push   %ecx
801069bf:	52                   	push   %edx
801069c0:	50                   	push   %eax
801069c1:	68 00 8a 10 80       	push   $0x80108a00
801069c6:	e8 fb 99 ff ff       	call   801003c6 <cprintf>
801069cb:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801069ce:	e8 ae c5 ff ff       	call   80102f81 <lapiceoi>
    break;
801069d3:	e9 ba 00 00 00       	jmp    80106a92 <trap+0x1de>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801069d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069de:	85 c0                	test   %eax,%eax
801069e0:	74 11                	je     801069f3 <trap+0x13f>
801069e2:	8b 45 08             	mov    0x8(%ebp),%eax
801069e5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801069e9:	0f b7 c0             	movzwl %ax,%eax
801069ec:	83 e0 03             	and    $0x3,%eax
801069ef:	85 c0                	test   %eax,%eax
801069f1:	75 3f                	jne    80106a32 <trap+0x17e>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801069f3:	e8 1d fd ff ff       	call   80106715 <rcr2>
801069f8:	8b 55 08             	mov    0x8(%ebp),%edx
801069fb:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
801069fe:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106a05:	0f b6 12             	movzbl (%edx),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106a08:	0f b6 ca             	movzbl %dl,%ecx
80106a0b:	8b 55 08             	mov    0x8(%ebp),%edx
80106a0e:	8b 52 30             	mov    0x30(%edx),%edx
80106a11:	83 ec 0c             	sub    $0xc,%esp
80106a14:	50                   	push   %eax
80106a15:	53                   	push   %ebx
80106a16:	51                   	push   %ecx
80106a17:	52                   	push   %edx
80106a18:	68 24 8a 10 80       	push   $0x80108a24
80106a1d:	e8 a4 99 ff ff       	call   801003c6 <cprintf>
80106a22:	83 c4 20             	add    $0x20,%esp
      panic("trap");
80106a25:	83 ec 0c             	sub    $0xc,%esp
80106a28:	68 56 8a 10 80       	push   $0x80108a56
80106a2d:	e8 49 9b ff ff       	call   8010057b <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a32:	e8 de fc ff ff       	call   80106715 <rcr2>
80106a37:	89 c2                	mov    %eax,%edx
80106a39:	8b 45 08             	mov    0x8(%ebp),%eax
80106a3c:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106a3f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a45:	0f b6 00             	movzbl (%eax),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a48:	0f b6 f0             	movzbl %al,%esi
80106a4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a4e:	8b 58 34             	mov    0x34(%eax),%ebx
80106a51:	8b 45 08             	mov    0x8(%ebp),%eax
80106a54:	8b 48 30             	mov    0x30(%eax),%ecx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106a57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a5d:	83 c0 6c             	add    $0x6c,%eax
80106a60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a69:	8b 40 10             	mov    0x10(%eax),%eax
80106a6c:	52                   	push   %edx
80106a6d:	57                   	push   %edi
80106a6e:	56                   	push   %esi
80106a6f:	53                   	push   %ebx
80106a70:	51                   	push   %ecx
80106a71:	ff 75 e4             	pushl  -0x1c(%ebp)
80106a74:	50                   	push   %eax
80106a75:	68 5c 8a 10 80       	push   $0x80108a5c
80106a7a:	e8 47 99 ff ff       	call   801003c6 <cprintf>
80106a7f:	83 c4 20             	add    $0x20,%esp
            rcr2());
    proc->killed = 1;
80106a82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a88:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106a8f:	eb 01                	jmp    80106a92 <trap+0x1de>
    break;
80106a91:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106a92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a98:	85 c0                	test   %eax,%eax
80106a9a:	74 24                	je     80106ac0 <trap+0x20c>
80106a9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106aa2:	8b 40 24             	mov    0x24(%eax),%eax
80106aa5:	85 c0                	test   %eax,%eax
80106aa7:	74 17                	je     80106ac0 <trap+0x20c>
80106aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80106aac:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106ab0:	0f b7 c0             	movzwl %ax,%eax
80106ab3:	83 e0 03             	and    $0x3,%eax
80106ab6:	83 f8 03             	cmp    $0x3,%eax
80106ab9:	75 05                	jne    80106ac0 <trap+0x20c>
    exit();
80106abb:	e8 86 da ff ff       	call   80104546 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106ac0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ac6:	85 c0                	test   %eax,%eax
80106ac8:	74 1e                	je     80106ae8 <trap+0x234>
80106aca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ad0:	8b 40 0c             	mov    0xc(%eax),%eax
80106ad3:	83 f8 04             	cmp    $0x4,%eax
80106ad6:	75 10                	jne    80106ae8 <trap+0x234>
80106ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80106adb:	8b 40 30             	mov    0x30(%eax),%eax
80106ade:	83 f8 20             	cmp    $0x20,%eax
80106ae1:	75 05                	jne    80106ae8 <trap+0x234>
    yield();
80106ae3:	e8 68 de ff ff       	call   80104950 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106ae8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106aee:	85 c0                	test   %eax,%eax
80106af0:	74 27                	je     80106b19 <trap+0x265>
80106af2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106af8:	8b 40 24             	mov    0x24(%eax),%eax
80106afb:	85 c0                	test   %eax,%eax
80106afd:	74 1a                	je     80106b19 <trap+0x265>
80106aff:	8b 45 08             	mov    0x8(%ebp),%eax
80106b02:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106b06:	0f b7 c0             	movzwl %ax,%eax
80106b09:	83 e0 03             	and    $0x3,%eax
80106b0c:	83 f8 03             	cmp    $0x3,%eax
80106b0f:	75 08                	jne    80106b19 <trap+0x265>
    exit();
80106b11:	e8 30 da ff ff       	call   80104546 <exit>
80106b16:	eb 01                	jmp    80106b19 <trap+0x265>
    return;
80106b18:	90                   	nop
}
80106b19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b1c:	5b                   	pop    %ebx
80106b1d:	5e                   	pop    %esi
80106b1e:	5f                   	pop    %edi
80106b1f:	5d                   	pop    %ebp
80106b20:	c3                   	ret    

80106b21 <inb>:
{
80106b21:	55                   	push   %ebp
80106b22:	89 e5                	mov    %esp,%ebp
80106b24:	83 ec 14             	sub    $0x14,%esp
80106b27:	8b 45 08             	mov    0x8(%ebp),%eax
80106b2a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b2e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106b32:	89 c2                	mov    %eax,%edx
80106b34:	ec                   	in     (%dx),%al
80106b35:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106b38:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106b3c:	c9                   	leave  
80106b3d:	c3                   	ret    

80106b3e <outb>:
{
80106b3e:	55                   	push   %ebp
80106b3f:	89 e5                	mov    %esp,%ebp
80106b41:	83 ec 08             	sub    $0x8,%esp
80106b44:	8b 45 08             	mov    0x8(%ebp),%eax
80106b47:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b4a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106b4e:	89 d0                	mov    %edx,%eax
80106b50:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b53:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106b57:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106b5b:	ee                   	out    %al,(%dx)
}
80106b5c:	90                   	nop
80106b5d:	c9                   	leave  
80106b5e:	c3                   	ret    

80106b5f <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106b5f:	55                   	push   %ebp
80106b60:	89 e5                	mov    %esp,%ebp
80106b62:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106b65:	6a 00                	push   $0x0
80106b67:	68 fa 03 00 00       	push   $0x3fa
80106b6c:	e8 cd ff ff ff       	call   80106b3e <outb>
80106b71:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106b74:	68 80 00 00 00       	push   $0x80
80106b79:	68 fb 03 00 00       	push   $0x3fb
80106b7e:	e8 bb ff ff ff       	call   80106b3e <outb>
80106b83:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106b86:	6a 0c                	push   $0xc
80106b88:	68 f8 03 00 00       	push   $0x3f8
80106b8d:	e8 ac ff ff ff       	call   80106b3e <outb>
80106b92:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106b95:	6a 00                	push   $0x0
80106b97:	68 f9 03 00 00       	push   $0x3f9
80106b9c:	e8 9d ff ff ff       	call   80106b3e <outb>
80106ba1:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106ba4:	6a 03                	push   $0x3
80106ba6:	68 fb 03 00 00       	push   $0x3fb
80106bab:	e8 8e ff ff ff       	call   80106b3e <outb>
80106bb0:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106bb3:	6a 00                	push   $0x0
80106bb5:	68 fc 03 00 00       	push   $0x3fc
80106bba:	e8 7f ff ff ff       	call   80106b3e <outb>
80106bbf:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106bc2:	6a 01                	push   $0x1
80106bc4:	68 f9 03 00 00       	push   $0x3f9
80106bc9:	e8 70 ff ff ff       	call   80106b3e <outb>
80106bce:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106bd1:	68 fd 03 00 00       	push   $0x3fd
80106bd6:	e8 46 ff ff ff       	call   80106b21 <inb>
80106bdb:	83 c4 04             	add    $0x4,%esp
80106bde:	3c ff                	cmp    $0xff,%al
80106be0:	74 6e                	je     80106c50 <uartinit+0xf1>
    return;
  uart = 1;
80106be2:	c7 05 78 2b 11 80 01 	movl   $0x1,0x80112b78
80106be9:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106bec:	68 fa 03 00 00       	push   $0x3fa
80106bf1:	e8 2b ff ff ff       	call   80106b21 <inb>
80106bf6:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106bf9:	68 f8 03 00 00       	push   $0x3f8
80106bfe:	e8 1e ff ff ff       	call   80106b21 <inb>
80106c03:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106c06:	83 ec 0c             	sub    $0xc,%esp
80106c09:	6a 04                	push   $0x4
80106c0b:	e8 78 cf ff ff       	call   80103b88 <picenable>
80106c10:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106c13:	83 ec 08             	sub    $0x8,%esp
80106c16:	6a 00                	push   $0x0
80106c18:	6a 04                	push   $0x4
80106c1a:	e8 2f be ff ff       	call   80102a4e <ioapicenable>
80106c1f:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106c22:	c7 45 f4 20 8b 10 80 	movl   $0x80108b20,-0xc(%ebp)
80106c29:	eb 19                	jmp    80106c44 <uartinit+0xe5>
    uartputc(*p);
80106c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c2e:	0f b6 00             	movzbl (%eax),%eax
80106c31:	0f be c0             	movsbl %al,%eax
80106c34:	83 ec 0c             	sub    $0xc,%esp
80106c37:	50                   	push   %eax
80106c38:	e8 16 00 00 00       	call   80106c53 <uartputc>
80106c3d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106c40:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c47:	0f b6 00             	movzbl (%eax),%eax
80106c4a:	84 c0                	test   %al,%al
80106c4c:	75 dd                	jne    80106c2b <uartinit+0xcc>
80106c4e:	eb 01                	jmp    80106c51 <uartinit+0xf2>
    return;
80106c50:	90                   	nop
}
80106c51:	c9                   	leave  
80106c52:	c3                   	ret    

80106c53 <uartputc>:

void
uartputc(int c)
{
80106c53:	55                   	push   %ebp
80106c54:	89 e5                	mov    %esp,%ebp
80106c56:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106c59:	a1 78 2b 11 80       	mov    0x80112b78,%eax
80106c5e:	85 c0                	test   %eax,%eax
80106c60:	74 53                	je     80106cb5 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106c69:	eb 11                	jmp    80106c7c <uartputc+0x29>
    microdelay(10);
80106c6b:	83 ec 0c             	sub    $0xc,%esp
80106c6e:	6a 0a                	push   $0xa
80106c70:	e8 27 c3 ff ff       	call   80102f9c <microdelay>
80106c75:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c78:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c7c:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106c80:	7f 1a                	jg     80106c9c <uartputc+0x49>
80106c82:	83 ec 0c             	sub    $0xc,%esp
80106c85:	68 fd 03 00 00       	push   $0x3fd
80106c8a:	e8 92 fe ff ff       	call   80106b21 <inb>
80106c8f:	83 c4 10             	add    $0x10,%esp
80106c92:	0f b6 c0             	movzbl %al,%eax
80106c95:	83 e0 20             	and    $0x20,%eax
80106c98:	85 c0                	test   %eax,%eax
80106c9a:	74 cf                	je     80106c6b <uartputc+0x18>
  outb(COM1+0, c);
80106c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c9f:	0f b6 c0             	movzbl %al,%eax
80106ca2:	83 ec 08             	sub    $0x8,%esp
80106ca5:	50                   	push   %eax
80106ca6:	68 f8 03 00 00       	push   $0x3f8
80106cab:	e8 8e fe ff ff       	call   80106b3e <outb>
80106cb0:	83 c4 10             	add    $0x10,%esp
80106cb3:	eb 01                	jmp    80106cb6 <uartputc+0x63>
    return;
80106cb5:	90                   	nop
}
80106cb6:	c9                   	leave  
80106cb7:	c3                   	ret    

80106cb8 <uartgetc>:

static int
uartgetc(void)
{
80106cb8:	55                   	push   %ebp
80106cb9:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106cbb:	a1 78 2b 11 80       	mov    0x80112b78,%eax
80106cc0:	85 c0                	test   %eax,%eax
80106cc2:	75 07                	jne    80106ccb <uartgetc+0x13>
    return -1;
80106cc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cc9:	eb 2e                	jmp    80106cf9 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106ccb:	68 fd 03 00 00       	push   $0x3fd
80106cd0:	e8 4c fe ff ff       	call   80106b21 <inb>
80106cd5:	83 c4 04             	add    $0x4,%esp
80106cd8:	0f b6 c0             	movzbl %al,%eax
80106cdb:	83 e0 01             	and    $0x1,%eax
80106cde:	85 c0                	test   %eax,%eax
80106ce0:	75 07                	jne    80106ce9 <uartgetc+0x31>
    return -1;
80106ce2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ce7:	eb 10                	jmp    80106cf9 <uartgetc+0x41>
  return inb(COM1+0);
80106ce9:	68 f8 03 00 00       	push   $0x3f8
80106cee:	e8 2e fe ff ff       	call   80106b21 <inb>
80106cf3:	83 c4 04             	add    $0x4,%esp
80106cf6:	0f b6 c0             	movzbl %al,%eax
}
80106cf9:	c9                   	leave  
80106cfa:	c3                   	ret    

80106cfb <uartintr>:

void
uartintr(void)
{
80106cfb:	55                   	push   %ebp
80106cfc:	89 e5                	mov    %esp,%ebp
80106cfe:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106d01:	83 ec 0c             	sub    $0xc,%esp
80106d04:	68 b8 6c 10 80       	push   $0x80106cb8
80106d09:	e8 f2 9a ff ff       	call   80100800 <consoleintr>
80106d0e:	83 c4 10             	add    $0x10,%esp
}
80106d11:	90                   	nop
80106d12:	c9                   	leave  
80106d13:	c3                   	ret    

80106d14 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106d14:	6a 00                	push   $0x0
  pushl $0
80106d16:	6a 00                	push   $0x0
  jmp alltraps
80106d18:	e9 a3 f9 ff ff       	jmp    801066c0 <alltraps>

80106d1d <vector1>:
.globl vector1
vector1:
  pushl $0
80106d1d:	6a 00                	push   $0x0
  pushl $1
80106d1f:	6a 01                	push   $0x1
  jmp alltraps
80106d21:	e9 9a f9 ff ff       	jmp    801066c0 <alltraps>

80106d26 <vector2>:
.globl vector2
vector2:
  pushl $0
80106d26:	6a 00                	push   $0x0
  pushl $2
80106d28:	6a 02                	push   $0x2
  jmp alltraps
80106d2a:	e9 91 f9 ff ff       	jmp    801066c0 <alltraps>

80106d2f <vector3>:
.globl vector3
vector3:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $3
80106d31:	6a 03                	push   $0x3
  jmp alltraps
80106d33:	e9 88 f9 ff ff       	jmp    801066c0 <alltraps>

80106d38 <vector4>:
.globl vector4
vector4:
  pushl $0
80106d38:	6a 00                	push   $0x0
  pushl $4
80106d3a:	6a 04                	push   $0x4
  jmp alltraps
80106d3c:	e9 7f f9 ff ff       	jmp    801066c0 <alltraps>

80106d41 <vector5>:
.globl vector5
vector5:
  pushl $0
80106d41:	6a 00                	push   $0x0
  pushl $5
80106d43:	6a 05                	push   $0x5
  jmp alltraps
80106d45:	e9 76 f9 ff ff       	jmp    801066c0 <alltraps>

80106d4a <vector6>:
.globl vector6
vector6:
  pushl $0
80106d4a:	6a 00                	push   $0x0
  pushl $6
80106d4c:	6a 06                	push   $0x6
  jmp alltraps
80106d4e:	e9 6d f9 ff ff       	jmp    801066c0 <alltraps>

80106d53 <vector7>:
.globl vector7
vector7:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $7
80106d55:	6a 07                	push   $0x7
  jmp alltraps
80106d57:	e9 64 f9 ff ff       	jmp    801066c0 <alltraps>

80106d5c <vector8>:
.globl vector8
vector8:
  pushl $8
80106d5c:	6a 08                	push   $0x8
  jmp alltraps
80106d5e:	e9 5d f9 ff ff       	jmp    801066c0 <alltraps>

80106d63 <vector9>:
.globl vector9
vector9:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $9
80106d65:	6a 09                	push   $0x9
  jmp alltraps
80106d67:	e9 54 f9 ff ff       	jmp    801066c0 <alltraps>

80106d6c <vector10>:
.globl vector10
vector10:
  pushl $10
80106d6c:	6a 0a                	push   $0xa
  jmp alltraps
80106d6e:	e9 4d f9 ff ff       	jmp    801066c0 <alltraps>

80106d73 <vector11>:
.globl vector11
vector11:
  pushl $11
80106d73:	6a 0b                	push   $0xb
  jmp alltraps
80106d75:	e9 46 f9 ff ff       	jmp    801066c0 <alltraps>

80106d7a <vector12>:
.globl vector12
vector12:
  pushl $12
80106d7a:	6a 0c                	push   $0xc
  jmp alltraps
80106d7c:	e9 3f f9 ff ff       	jmp    801066c0 <alltraps>

80106d81 <vector13>:
.globl vector13
vector13:
  pushl $13
80106d81:	6a 0d                	push   $0xd
  jmp alltraps
80106d83:	e9 38 f9 ff ff       	jmp    801066c0 <alltraps>

80106d88 <vector14>:
.globl vector14
vector14:
  pushl $14
80106d88:	6a 0e                	push   $0xe
  jmp alltraps
80106d8a:	e9 31 f9 ff ff       	jmp    801066c0 <alltraps>

80106d8f <vector15>:
.globl vector15
vector15:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $15
80106d91:	6a 0f                	push   $0xf
  jmp alltraps
80106d93:	e9 28 f9 ff ff       	jmp    801066c0 <alltraps>

80106d98 <vector16>:
.globl vector16
vector16:
  pushl $0
80106d98:	6a 00                	push   $0x0
  pushl $16
80106d9a:	6a 10                	push   $0x10
  jmp alltraps
80106d9c:	e9 1f f9 ff ff       	jmp    801066c0 <alltraps>

80106da1 <vector17>:
.globl vector17
vector17:
  pushl $17
80106da1:	6a 11                	push   $0x11
  jmp alltraps
80106da3:	e9 18 f9 ff ff       	jmp    801066c0 <alltraps>

80106da8 <vector18>:
.globl vector18
vector18:
  pushl $0
80106da8:	6a 00                	push   $0x0
  pushl $18
80106daa:	6a 12                	push   $0x12
  jmp alltraps
80106dac:	e9 0f f9 ff ff       	jmp    801066c0 <alltraps>

80106db1 <vector19>:
.globl vector19
vector19:
  pushl $0
80106db1:	6a 00                	push   $0x0
  pushl $19
80106db3:	6a 13                	push   $0x13
  jmp alltraps
80106db5:	e9 06 f9 ff ff       	jmp    801066c0 <alltraps>

80106dba <vector20>:
.globl vector20
vector20:
  pushl $0
80106dba:	6a 00                	push   $0x0
  pushl $20
80106dbc:	6a 14                	push   $0x14
  jmp alltraps
80106dbe:	e9 fd f8 ff ff       	jmp    801066c0 <alltraps>

80106dc3 <vector21>:
.globl vector21
vector21:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $21
80106dc5:	6a 15                	push   $0x15
  jmp alltraps
80106dc7:	e9 f4 f8 ff ff       	jmp    801066c0 <alltraps>

80106dcc <vector22>:
.globl vector22
vector22:
  pushl $0
80106dcc:	6a 00                	push   $0x0
  pushl $22
80106dce:	6a 16                	push   $0x16
  jmp alltraps
80106dd0:	e9 eb f8 ff ff       	jmp    801066c0 <alltraps>

80106dd5 <vector23>:
.globl vector23
vector23:
  pushl $0
80106dd5:	6a 00                	push   $0x0
  pushl $23
80106dd7:	6a 17                	push   $0x17
  jmp alltraps
80106dd9:	e9 e2 f8 ff ff       	jmp    801066c0 <alltraps>

80106dde <vector24>:
.globl vector24
vector24:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $24
80106de0:	6a 18                	push   $0x18
  jmp alltraps
80106de2:	e9 d9 f8 ff ff       	jmp    801066c0 <alltraps>

80106de7 <vector25>:
.globl vector25
vector25:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $25
80106de9:	6a 19                	push   $0x19
  jmp alltraps
80106deb:	e9 d0 f8 ff ff       	jmp    801066c0 <alltraps>

80106df0 <vector26>:
.globl vector26
vector26:
  pushl $0
80106df0:	6a 00                	push   $0x0
  pushl $26
80106df2:	6a 1a                	push   $0x1a
  jmp alltraps
80106df4:	e9 c7 f8 ff ff       	jmp    801066c0 <alltraps>

80106df9 <vector27>:
.globl vector27
vector27:
  pushl $0
80106df9:	6a 00                	push   $0x0
  pushl $27
80106dfb:	6a 1b                	push   $0x1b
  jmp alltraps
80106dfd:	e9 be f8 ff ff       	jmp    801066c0 <alltraps>

80106e02 <vector28>:
.globl vector28
vector28:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $28
80106e04:	6a 1c                	push   $0x1c
  jmp alltraps
80106e06:	e9 b5 f8 ff ff       	jmp    801066c0 <alltraps>

80106e0b <vector29>:
.globl vector29
vector29:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $29
80106e0d:	6a 1d                	push   $0x1d
  jmp alltraps
80106e0f:	e9 ac f8 ff ff       	jmp    801066c0 <alltraps>

80106e14 <vector30>:
.globl vector30
vector30:
  pushl $0
80106e14:	6a 00                	push   $0x0
  pushl $30
80106e16:	6a 1e                	push   $0x1e
  jmp alltraps
80106e18:	e9 a3 f8 ff ff       	jmp    801066c0 <alltraps>

80106e1d <vector31>:
.globl vector31
vector31:
  pushl $0
80106e1d:	6a 00                	push   $0x0
  pushl $31
80106e1f:	6a 1f                	push   $0x1f
  jmp alltraps
80106e21:	e9 9a f8 ff ff       	jmp    801066c0 <alltraps>

80106e26 <vector32>:
.globl vector32
vector32:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $32
80106e28:	6a 20                	push   $0x20
  jmp alltraps
80106e2a:	e9 91 f8 ff ff       	jmp    801066c0 <alltraps>

80106e2f <vector33>:
.globl vector33
vector33:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $33
80106e31:	6a 21                	push   $0x21
  jmp alltraps
80106e33:	e9 88 f8 ff ff       	jmp    801066c0 <alltraps>

80106e38 <vector34>:
.globl vector34
vector34:
  pushl $0
80106e38:	6a 00                	push   $0x0
  pushl $34
80106e3a:	6a 22                	push   $0x22
  jmp alltraps
80106e3c:	e9 7f f8 ff ff       	jmp    801066c0 <alltraps>

80106e41 <vector35>:
.globl vector35
vector35:
  pushl $0
80106e41:	6a 00                	push   $0x0
  pushl $35
80106e43:	6a 23                	push   $0x23
  jmp alltraps
80106e45:	e9 76 f8 ff ff       	jmp    801066c0 <alltraps>

80106e4a <vector36>:
.globl vector36
vector36:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $36
80106e4c:	6a 24                	push   $0x24
  jmp alltraps
80106e4e:	e9 6d f8 ff ff       	jmp    801066c0 <alltraps>

80106e53 <vector37>:
.globl vector37
vector37:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $37
80106e55:	6a 25                	push   $0x25
  jmp alltraps
80106e57:	e9 64 f8 ff ff       	jmp    801066c0 <alltraps>

80106e5c <vector38>:
.globl vector38
vector38:
  pushl $0
80106e5c:	6a 00                	push   $0x0
  pushl $38
80106e5e:	6a 26                	push   $0x26
  jmp alltraps
80106e60:	e9 5b f8 ff ff       	jmp    801066c0 <alltraps>

80106e65 <vector39>:
.globl vector39
vector39:
  pushl $0
80106e65:	6a 00                	push   $0x0
  pushl $39
80106e67:	6a 27                	push   $0x27
  jmp alltraps
80106e69:	e9 52 f8 ff ff       	jmp    801066c0 <alltraps>

80106e6e <vector40>:
.globl vector40
vector40:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $40
80106e70:	6a 28                	push   $0x28
  jmp alltraps
80106e72:	e9 49 f8 ff ff       	jmp    801066c0 <alltraps>

80106e77 <vector41>:
.globl vector41
vector41:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $41
80106e79:	6a 29                	push   $0x29
  jmp alltraps
80106e7b:	e9 40 f8 ff ff       	jmp    801066c0 <alltraps>

80106e80 <vector42>:
.globl vector42
vector42:
  pushl $0
80106e80:	6a 00                	push   $0x0
  pushl $42
80106e82:	6a 2a                	push   $0x2a
  jmp alltraps
80106e84:	e9 37 f8 ff ff       	jmp    801066c0 <alltraps>

80106e89 <vector43>:
.globl vector43
vector43:
  pushl $0
80106e89:	6a 00                	push   $0x0
  pushl $43
80106e8b:	6a 2b                	push   $0x2b
  jmp alltraps
80106e8d:	e9 2e f8 ff ff       	jmp    801066c0 <alltraps>

80106e92 <vector44>:
.globl vector44
vector44:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $44
80106e94:	6a 2c                	push   $0x2c
  jmp alltraps
80106e96:	e9 25 f8 ff ff       	jmp    801066c0 <alltraps>

80106e9b <vector45>:
.globl vector45
vector45:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $45
80106e9d:	6a 2d                	push   $0x2d
  jmp alltraps
80106e9f:	e9 1c f8 ff ff       	jmp    801066c0 <alltraps>

80106ea4 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ea4:	6a 00                	push   $0x0
  pushl $46
80106ea6:	6a 2e                	push   $0x2e
  jmp alltraps
80106ea8:	e9 13 f8 ff ff       	jmp    801066c0 <alltraps>

80106ead <vector47>:
.globl vector47
vector47:
  pushl $0
80106ead:	6a 00                	push   $0x0
  pushl $47
80106eaf:	6a 2f                	push   $0x2f
  jmp alltraps
80106eb1:	e9 0a f8 ff ff       	jmp    801066c0 <alltraps>

80106eb6 <vector48>:
.globl vector48
vector48:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $48
80106eb8:	6a 30                	push   $0x30
  jmp alltraps
80106eba:	e9 01 f8 ff ff       	jmp    801066c0 <alltraps>

80106ebf <vector49>:
.globl vector49
vector49:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $49
80106ec1:	6a 31                	push   $0x31
  jmp alltraps
80106ec3:	e9 f8 f7 ff ff       	jmp    801066c0 <alltraps>

80106ec8 <vector50>:
.globl vector50
vector50:
  pushl $0
80106ec8:	6a 00                	push   $0x0
  pushl $50
80106eca:	6a 32                	push   $0x32
  jmp alltraps
80106ecc:	e9 ef f7 ff ff       	jmp    801066c0 <alltraps>

80106ed1 <vector51>:
.globl vector51
vector51:
  pushl $0
80106ed1:	6a 00                	push   $0x0
  pushl $51
80106ed3:	6a 33                	push   $0x33
  jmp alltraps
80106ed5:	e9 e6 f7 ff ff       	jmp    801066c0 <alltraps>

80106eda <vector52>:
.globl vector52
vector52:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $52
80106edc:	6a 34                	push   $0x34
  jmp alltraps
80106ede:	e9 dd f7 ff ff       	jmp    801066c0 <alltraps>

80106ee3 <vector53>:
.globl vector53
vector53:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $53
80106ee5:	6a 35                	push   $0x35
  jmp alltraps
80106ee7:	e9 d4 f7 ff ff       	jmp    801066c0 <alltraps>

80106eec <vector54>:
.globl vector54
vector54:
  pushl $0
80106eec:	6a 00                	push   $0x0
  pushl $54
80106eee:	6a 36                	push   $0x36
  jmp alltraps
80106ef0:	e9 cb f7 ff ff       	jmp    801066c0 <alltraps>

80106ef5 <vector55>:
.globl vector55
vector55:
  pushl $0
80106ef5:	6a 00                	push   $0x0
  pushl $55
80106ef7:	6a 37                	push   $0x37
  jmp alltraps
80106ef9:	e9 c2 f7 ff ff       	jmp    801066c0 <alltraps>

80106efe <vector56>:
.globl vector56
vector56:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $56
80106f00:	6a 38                	push   $0x38
  jmp alltraps
80106f02:	e9 b9 f7 ff ff       	jmp    801066c0 <alltraps>

80106f07 <vector57>:
.globl vector57
vector57:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $57
80106f09:	6a 39                	push   $0x39
  jmp alltraps
80106f0b:	e9 b0 f7 ff ff       	jmp    801066c0 <alltraps>

80106f10 <vector58>:
.globl vector58
vector58:
  pushl $0
80106f10:	6a 00                	push   $0x0
  pushl $58
80106f12:	6a 3a                	push   $0x3a
  jmp alltraps
80106f14:	e9 a7 f7 ff ff       	jmp    801066c0 <alltraps>

80106f19 <vector59>:
.globl vector59
vector59:
  pushl $0
80106f19:	6a 00                	push   $0x0
  pushl $59
80106f1b:	6a 3b                	push   $0x3b
  jmp alltraps
80106f1d:	e9 9e f7 ff ff       	jmp    801066c0 <alltraps>

80106f22 <vector60>:
.globl vector60
vector60:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $60
80106f24:	6a 3c                	push   $0x3c
  jmp alltraps
80106f26:	e9 95 f7 ff ff       	jmp    801066c0 <alltraps>

80106f2b <vector61>:
.globl vector61
vector61:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $61
80106f2d:	6a 3d                	push   $0x3d
  jmp alltraps
80106f2f:	e9 8c f7 ff ff       	jmp    801066c0 <alltraps>

80106f34 <vector62>:
.globl vector62
vector62:
  pushl $0
80106f34:	6a 00                	push   $0x0
  pushl $62
80106f36:	6a 3e                	push   $0x3e
  jmp alltraps
80106f38:	e9 83 f7 ff ff       	jmp    801066c0 <alltraps>

80106f3d <vector63>:
.globl vector63
vector63:
  pushl $0
80106f3d:	6a 00                	push   $0x0
  pushl $63
80106f3f:	6a 3f                	push   $0x3f
  jmp alltraps
80106f41:	e9 7a f7 ff ff       	jmp    801066c0 <alltraps>

80106f46 <vector64>:
.globl vector64
vector64:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $64
80106f48:	6a 40                	push   $0x40
  jmp alltraps
80106f4a:	e9 71 f7 ff ff       	jmp    801066c0 <alltraps>

80106f4f <vector65>:
.globl vector65
vector65:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $65
80106f51:	6a 41                	push   $0x41
  jmp alltraps
80106f53:	e9 68 f7 ff ff       	jmp    801066c0 <alltraps>

80106f58 <vector66>:
.globl vector66
vector66:
  pushl $0
80106f58:	6a 00                	push   $0x0
  pushl $66
80106f5a:	6a 42                	push   $0x42
  jmp alltraps
80106f5c:	e9 5f f7 ff ff       	jmp    801066c0 <alltraps>

80106f61 <vector67>:
.globl vector67
vector67:
  pushl $0
80106f61:	6a 00                	push   $0x0
  pushl $67
80106f63:	6a 43                	push   $0x43
  jmp alltraps
80106f65:	e9 56 f7 ff ff       	jmp    801066c0 <alltraps>

80106f6a <vector68>:
.globl vector68
vector68:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $68
80106f6c:	6a 44                	push   $0x44
  jmp alltraps
80106f6e:	e9 4d f7 ff ff       	jmp    801066c0 <alltraps>

80106f73 <vector69>:
.globl vector69
vector69:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $69
80106f75:	6a 45                	push   $0x45
  jmp alltraps
80106f77:	e9 44 f7 ff ff       	jmp    801066c0 <alltraps>

80106f7c <vector70>:
.globl vector70
vector70:
  pushl $0
80106f7c:	6a 00                	push   $0x0
  pushl $70
80106f7e:	6a 46                	push   $0x46
  jmp alltraps
80106f80:	e9 3b f7 ff ff       	jmp    801066c0 <alltraps>

80106f85 <vector71>:
.globl vector71
vector71:
  pushl $0
80106f85:	6a 00                	push   $0x0
  pushl $71
80106f87:	6a 47                	push   $0x47
  jmp alltraps
80106f89:	e9 32 f7 ff ff       	jmp    801066c0 <alltraps>

80106f8e <vector72>:
.globl vector72
vector72:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $72
80106f90:	6a 48                	push   $0x48
  jmp alltraps
80106f92:	e9 29 f7 ff ff       	jmp    801066c0 <alltraps>

80106f97 <vector73>:
.globl vector73
vector73:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $73
80106f99:	6a 49                	push   $0x49
  jmp alltraps
80106f9b:	e9 20 f7 ff ff       	jmp    801066c0 <alltraps>

80106fa0 <vector74>:
.globl vector74
vector74:
  pushl $0
80106fa0:	6a 00                	push   $0x0
  pushl $74
80106fa2:	6a 4a                	push   $0x4a
  jmp alltraps
80106fa4:	e9 17 f7 ff ff       	jmp    801066c0 <alltraps>

80106fa9 <vector75>:
.globl vector75
vector75:
  pushl $0
80106fa9:	6a 00                	push   $0x0
  pushl $75
80106fab:	6a 4b                	push   $0x4b
  jmp alltraps
80106fad:	e9 0e f7 ff ff       	jmp    801066c0 <alltraps>

80106fb2 <vector76>:
.globl vector76
vector76:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $76
80106fb4:	6a 4c                	push   $0x4c
  jmp alltraps
80106fb6:	e9 05 f7 ff ff       	jmp    801066c0 <alltraps>

80106fbb <vector77>:
.globl vector77
vector77:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $77
80106fbd:	6a 4d                	push   $0x4d
  jmp alltraps
80106fbf:	e9 fc f6 ff ff       	jmp    801066c0 <alltraps>

80106fc4 <vector78>:
.globl vector78
vector78:
  pushl $0
80106fc4:	6a 00                	push   $0x0
  pushl $78
80106fc6:	6a 4e                	push   $0x4e
  jmp alltraps
80106fc8:	e9 f3 f6 ff ff       	jmp    801066c0 <alltraps>

80106fcd <vector79>:
.globl vector79
vector79:
  pushl $0
80106fcd:	6a 00                	push   $0x0
  pushl $79
80106fcf:	6a 4f                	push   $0x4f
  jmp alltraps
80106fd1:	e9 ea f6 ff ff       	jmp    801066c0 <alltraps>

80106fd6 <vector80>:
.globl vector80
vector80:
  pushl $0
80106fd6:	6a 00                	push   $0x0
  pushl $80
80106fd8:	6a 50                	push   $0x50
  jmp alltraps
80106fda:	e9 e1 f6 ff ff       	jmp    801066c0 <alltraps>

80106fdf <vector81>:
.globl vector81
vector81:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $81
80106fe1:	6a 51                	push   $0x51
  jmp alltraps
80106fe3:	e9 d8 f6 ff ff       	jmp    801066c0 <alltraps>

80106fe8 <vector82>:
.globl vector82
vector82:
  pushl $0
80106fe8:	6a 00                	push   $0x0
  pushl $82
80106fea:	6a 52                	push   $0x52
  jmp alltraps
80106fec:	e9 cf f6 ff ff       	jmp    801066c0 <alltraps>

80106ff1 <vector83>:
.globl vector83
vector83:
  pushl $0
80106ff1:	6a 00                	push   $0x0
  pushl $83
80106ff3:	6a 53                	push   $0x53
  jmp alltraps
80106ff5:	e9 c6 f6 ff ff       	jmp    801066c0 <alltraps>

80106ffa <vector84>:
.globl vector84
vector84:
  pushl $0
80106ffa:	6a 00                	push   $0x0
  pushl $84
80106ffc:	6a 54                	push   $0x54
  jmp alltraps
80106ffe:	e9 bd f6 ff ff       	jmp    801066c0 <alltraps>

80107003 <vector85>:
.globl vector85
vector85:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $85
80107005:	6a 55                	push   $0x55
  jmp alltraps
80107007:	e9 b4 f6 ff ff       	jmp    801066c0 <alltraps>

8010700c <vector86>:
.globl vector86
vector86:
  pushl $0
8010700c:	6a 00                	push   $0x0
  pushl $86
8010700e:	6a 56                	push   $0x56
  jmp alltraps
80107010:	e9 ab f6 ff ff       	jmp    801066c0 <alltraps>

80107015 <vector87>:
.globl vector87
vector87:
  pushl $0
80107015:	6a 00                	push   $0x0
  pushl $87
80107017:	6a 57                	push   $0x57
  jmp alltraps
80107019:	e9 a2 f6 ff ff       	jmp    801066c0 <alltraps>

8010701e <vector88>:
.globl vector88
vector88:
  pushl $0
8010701e:	6a 00                	push   $0x0
  pushl $88
80107020:	6a 58                	push   $0x58
  jmp alltraps
80107022:	e9 99 f6 ff ff       	jmp    801066c0 <alltraps>

80107027 <vector89>:
.globl vector89
vector89:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $89
80107029:	6a 59                	push   $0x59
  jmp alltraps
8010702b:	e9 90 f6 ff ff       	jmp    801066c0 <alltraps>

80107030 <vector90>:
.globl vector90
vector90:
  pushl $0
80107030:	6a 00                	push   $0x0
  pushl $90
80107032:	6a 5a                	push   $0x5a
  jmp alltraps
80107034:	e9 87 f6 ff ff       	jmp    801066c0 <alltraps>

80107039 <vector91>:
.globl vector91
vector91:
  pushl $0
80107039:	6a 00                	push   $0x0
  pushl $91
8010703b:	6a 5b                	push   $0x5b
  jmp alltraps
8010703d:	e9 7e f6 ff ff       	jmp    801066c0 <alltraps>

80107042 <vector92>:
.globl vector92
vector92:
  pushl $0
80107042:	6a 00                	push   $0x0
  pushl $92
80107044:	6a 5c                	push   $0x5c
  jmp alltraps
80107046:	e9 75 f6 ff ff       	jmp    801066c0 <alltraps>

8010704b <vector93>:
.globl vector93
vector93:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $93
8010704d:	6a 5d                	push   $0x5d
  jmp alltraps
8010704f:	e9 6c f6 ff ff       	jmp    801066c0 <alltraps>

80107054 <vector94>:
.globl vector94
vector94:
  pushl $0
80107054:	6a 00                	push   $0x0
  pushl $94
80107056:	6a 5e                	push   $0x5e
  jmp alltraps
80107058:	e9 63 f6 ff ff       	jmp    801066c0 <alltraps>

8010705d <vector95>:
.globl vector95
vector95:
  pushl $0
8010705d:	6a 00                	push   $0x0
  pushl $95
8010705f:	6a 5f                	push   $0x5f
  jmp alltraps
80107061:	e9 5a f6 ff ff       	jmp    801066c0 <alltraps>

80107066 <vector96>:
.globl vector96
vector96:
  pushl $0
80107066:	6a 00                	push   $0x0
  pushl $96
80107068:	6a 60                	push   $0x60
  jmp alltraps
8010706a:	e9 51 f6 ff ff       	jmp    801066c0 <alltraps>

8010706f <vector97>:
.globl vector97
vector97:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $97
80107071:	6a 61                	push   $0x61
  jmp alltraps
80107073:	e9 48 f6 ff ff       	jmp    801066c0 <alltraps>

80107078 <vector98>:
.globl vector98
vector98:
  pushl $0
80107078:	6a 00                	push   $0x0
  pushl $98
8010707a:	6a 62                	push   $0x62
  jmp alltraps
8010707c:	e9 3f f6 ff ff       	jmp    801066c0 <alltraps>

80107081 <vector99>:
.globl vector99
vector99:
  pushl $0
80107081:	6a 00                	push   $0x0
  pushl $99
80107083:	6a 63                	push   $0x63
  jmp alltraps
80107085:	e9 36 f6 ff ff       	jmp    801066c0 <alltraps>

8010708a <vector100>:
.globl vector100
vector100:
  pushl $0
8010708a:	6a 00                	push   $0x0
  pushl $100
8010708c:	6a 64                	push   $0x64
  jmp alltraps
8010708e:	e9 2d f6 ff ff       	jmp    801066c0 <alltraps>

80107093 <vector101>:
.globl vector101
vector101:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $101
80107095:	6a 65                	push   $0x65
  jmp alltraps
80107097:	e9 24 f6 ff ff       	jmp    801066c0 <alltraps>

8010709c <vector102>:
.globl vector102
vector102:
  pushl $0
8010709c:	6a 00                	push   $0x0
  pushl $102
8010709e:	6a 66                	push   $0x66
  jmp alltraps
801070a0:	e9 1b f6 ff ff       	jmp    801066c0 <alltraps>

801070a5 <vector103>:
.globl vector103
vector103:
  pushl $0
801070a5:	6a 00                	push   $0x0
  pushl $103
801070a7:	6a 67                	push   $0x67
  jmp alltraps
801070a9:	e9 12 f6 ff ff       	jmp    801066c0 <alltraps>

801070ae <vector104>:
.globl vector104
vector104:
  pushl $0
801070ae:	6a 00                	push   $0x0
  pushl $104
801070b0:	6a 68                	push   $0x68
  jmp alltraps
801070b2:	e9 09 f6 ff ff       	jmp    801066c0 <alltraps>

801070b7 <vector105>:
.globl vector105
vector105:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $105
801070b9:	6a 69                	push   $0x69
  jmp alltraps
801070bb:	e9 00 f6 ff ff       	jmp    801066c0 <alltraps>

801070c0 <vector106>:
.globl vector106
vector106:
  pushl $0
801070c0:	6a 00                	push   $0x0
  pushl $106
801070c2:	6a 6a                	push   $0x6a
  jmp alltraps
801070c4:	e9 f7 f5 ff ff       	jmp    801066c0 <alltraps>

801070c9 <vector107>:
.globl vector107
vector107:
  pushl $0
801070c9:	6a 00                	push   $0x0
  pushl $107
801070cb:	6a 6b                	push   $0x6b
  jmp alltraps
801070cd:	e9 ee f5 ff ff       	jmp    801066c0 <alltraps>

801070d2 <vector108>:
.globl vector108
vector108:
  pushl $0
801070d2:	6a 00                	push   $0x0
  pushl $108
801070d4:	6a 6c                	push   $0x6c
  jmp alltraps
801070d6:	e9 e5 f5 ff ff       	jmp    801066c0 <alltraps>

801070db <vector109>:
.globl vector109
vector109:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $109
801070dd:	6a 6d                	push   $0x6d
  jmp alltraps
801070df:	e9 dc f5 ff ff       	jmp    801066c0 <alltraps>

801070e4 <vector110>:
.globl vector110
vector110:
  pushl $0
801070e4:	6a 00                	push   $0x0
  pushl $110
801070e6:	6a 6e                	push   $0x6e
  jmp alltraps
801070e8:	e9 d3 f5 ff ff       	jmp    801066c0 <alltraps>

801070ed <vector111>:
.globl vector111
vector111:
  pushl $0
801070ed:	6a 00                	push   $0x0
  pushl $111
801070ef:	6a 6f                	push   $0x6f
  jmp alltraps
801070f1:	e9 ca f5 ff ff       	jmp    801066c0 <alltraps>

801070f6 <vector112>:
.globl vector112
vector112:
  pushl $0
801070f6:	6a 00                	push   $0x0
  pushl $112
801070f8:	6a 70                	push   $0x70
  jmp alltraps
801070fa:	e9 c1 f5 ff ff       	jmp    801066c0 <alltraps>

801070ff <vector113>:
.globl vector113
vector113:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $113
80107101:	6a 71                	push   $0x71
  jmp alltraps
80107103:	e9 b8 f5 ff ff       	jmp    801066c0 <alltraps>

80107108 <vector114>:
.globl vector114
vector114:
  pushl $0
80107108:	6a 00                	push   $0x0
  pushl $114
8010710a:	6a 72                	push   $0x72
  jmp alltraps
8010710c:	e9 af f5 ff ff       	jmp    801066c0 <alltraps>

80107111 <vector115>:
.globl vector115
vector115:
  pushl $0
80107111:	6a 00                	push   $0x0
  pushl $115
80107113:	6a 73                	push   $0x73
  jmp alltraps
80107115:	e9 a6 f5 ff ff       	jmp    801066c0 <alltraps>

8010711a <vector116>:
.globl vector116
vector116:
  pushl $0
8010711a:	6a 00                	push   $0x0
  pushl $116
8010711c:	6a 74                	push   $0x74
  jmp alltraps
8010711e:	e9 9d f5 ff ff       	jmp    801066c0 <alltraps>

80107123 <vector117>:
.globl vector117
vector117:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $117
80107125:	6a 75                	push   $0x75
  jmp alltraps
80107127:	e9 94 f5 ff ff       	jmp    801066c0 <alltraps>

8010712c <vector118>:
.globl vector118
vector118:
  pushl $0
8010712c:	6a 00                	push   $0x0
  pushl $118
8010712e:	6a 76                	push   $0x76
  jmp alltraps
80107130:	e9 8b f5 ff ff       	jmp    801066c0 <alltraps>

80107135 <vector119>:
.globl vector119
vector119:
  pushl $0
80107135:	6a 00                	push   $0x0
  pushl $119
80107137:	6a 77                	push   $0x77
  jmp alltraps
80107139:	e9 82 f5 ff ff       	jmp    801066c0 <alltraps>

8010713e <vector120>:
.globl vector120
vector120:
  pushl $0
8010713e:	6a 00                	push   $0x0
  pushl $120
80107140:	6a 78                	push   $0x78
  jmp alltraps
80107142:	e9 79 f5 ff ff       	jmp    801066c0 <alltraps>

80107147 <vector121>:
.globl vector121
vector121:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $121
80107149:	6a 79                	push   $0x79
  jmp alltraps
8010714b:	e9 70 f5 ff ff       	jmp    801066c0 <alltraps>

80107150 <vector122>:
.globl vector122
vector122:
  pushl $0
80107150:	6a 00                	push   $0x0
  pushl $122
80107152:	6a 7a                	push   $0x7a
  jmp alltraps
80107154:	e9 67 f5 ff ff       	jmp    801066c0 <alltraps>

80107159 <vector123>:
.globl vector123
vector123:
  pushl $0
80107159:	6a 00                	push   $0x0
  pushl $123
8010715b:	6a 7b                	push   $0x7b
  jmp alltraps
8010715d:	e9 5e f5 ff ff       	jmp    801066c0 <alltraps>

80107162 <vector124>:
.globl vector124
vector124:
  pushl $0
80107162:	6a 00                	push   $0x0
  pushl $124
80107164:	6a 7c                	push   $0x7c
  jmp alltraps
80107166:	e9 55 f5 ff ff       	jmp    801066c0 <alltraps>

8010716b <vector125>:
.globl vector125
vector125:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $125
8010716d:	6a 7d                	push   $0x7d
  jmp alltraps
8010716f:	e9 4c f5 ff ff       	jmp    801066c0 <alltraps>

80107174 <vector126>:
.globl vector126
vector126:
  pushl $0
80107174:	6a 00                	push   $0x0
  pushl $126
80107176:	6a 7e                	push   $0x7e
  jmp alltraps
80107178:	e9 43 f5 ff ff       	jmp    801066c0 <alltraps>

8010717d <vector127>:
.globl vector127
vector127:
  pushl $0
8010717d:	6a 00                	push   $0x0
  pushl $127
8010717f:	6a 7f                	push   $0x7f
  jmp alltraps
80107181:	e9 3a f5 ff ff       	jmp    801066c0 <alltraps>

80107186 <vector128>:
.globl vector128
vector128:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $128
80107188:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010718d:	e9 2e f5 ff ff       	jmp    801066c0 <alltraps>

80107192 <vector129>:
.globl vector129
vector129:
  pushl $0
80107192:	6a 00                	push   $0x0
  pushl $129
80107194:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107199:	e9 22 f5 ff ff       	jmp    801066c0 <alltraps>

8010719e <vector130>:
.globl vector130
vector130:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $130
801071a0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801071a5:	e9 16 f5 ff ff       	jmp    801066c0 <alltraps>

801071aa <vector131>:
.globl vector131
vector131:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $131
801071ac:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801071b1:	e9 0a f5 ff ff       	jmp    801066c0 <alltraps>

801071b6 <vector132>:
.globl vector132
vector132:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $132
801071b8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801071bd:	e9 fe f4 ff ff       	jmp    801066c0 <alltraps>

801071c2 <vector133>:
.globl vector133
vector133:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $133
801071c4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801071c9:	e9 f2 f4 ff ff       	jmp    801066c0 <alltraps>

801071ce <vector134>:
.globl vector134
vector134:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $134
801071d0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801071d5:	e9 e6 f4 ff ff       	jmp    801066c0 <alltraps>

801071da <vector135>:
.globl vector135
vector135:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $135
801071dc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801071e1:	e9 da f4 ff ff       	jmp    801066c0 <alltraps>

801071e6 <vector136>:
.globl vector136
vector136:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $136
801071e8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801071ed:	e9 ce f4 ff ff       	jmp    801066c0 <alltraps>

801071f2 <vector137>:
.globl vector137
vector137:
  pushl $0
801071f2:	6a 00                	push   $0x0
  pushl $137
801071f4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801071f9:	e9 c2 f4 ff ff       	jmp    801066c0 <alltraps>

801071fe <vector138>:
.globl vector138
vector138:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $138
80107200:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107205:	e9 b6 f4 ff ff       	jmp    801066c0 <alltraps>

8010720a <vector139>:
.globl vector139
vector139:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $139
8010720c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107211:	e9 aa f4 ff ff       	jmp    801066c0 <alltraps>

80107216 <vector140>:
.globl vector140
vector140:
  pushl $0
80107216:	6a 00                	push   $0x0
  pushl $140
80107218:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010721d:	e9 9e f4 ff ff       	jmp    801066c0 <alltraps>

80107222 <vector141>:
.globl vector141
vector141:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $141
80107224:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107229:	e9 92 f4 ff ff       	jmp    801066c0 <alltraps>

8010722e <vector142>:
.globl vector142
vector142:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $142
80107230:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107235:	e9 86 f4 ff ff       	jmp    801066c0 <alltraps>

8010723a <vector143>:
.globl vector143
vector143:
  pushl $0
8010723a:	6a 00                	push   $0x0
  pushl $143
8010723c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107241:	e9 7a f4 ff ff       	jmp    801066c0 <alltraps>

80107246 <vector144>:
.globl vector144
vector144:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $144
80107248:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010724d:	e9 6e f4 ff ff       	jmp    801066c0 <alltraps>

80107252 <vector145>:
.globl vector145
vector145:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $145
80107254:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107259:	e9 62 f4 ff ff       	jmp    801066c0 <alltraps>

8010725e <vector146>:
.globl vector146
vector146:
  pushl $0
8010725e:	6a 00                	push   $0x0
  pushl $146
80107260:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107265:	e9 56 f4 ff ff       	jmp    801066c0 <alltraps>

8010726a <vector147>:
.globl vector147
vector147:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $147
8010726c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107271:	e9 4a f4 ff ff       	jmp    801066c0 <alltraps>

80107276 <vector148>:
.globl vector148
vector148:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $148
80107278:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010727d:	e9 3e f4 ff ff       	jmp    801066c0 <alltraps>

80107282 <vector149>:
.globl vector149
vector149:
  pushl $0
80107282:	6a 00                	push   $0x0
  pushl $149
80107284:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107289:	e9 32 f4 ff ff       	jmp    801066c0 <alltraps>

8010728e <vector150>:
.globl vector150
vector150:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $150
80107290:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107295:	e9 26 f4 ff ff       	jmp    801066c0 <alltraps>

8010729a <vector151>:
.globl vector151
vector151:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $151
8010729c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801072a1:	e9 1a f4 ff ff       	jmp    801066c0 <alltraps>

801072a6 <vector152>:
.globl vector152
vector152:
  pushl $0
801072a6:	6a 00                	push   $0x0
  pushl $152
801072a8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801072ad:	e9 0e f4 ff ff       	jmp    801066c0 <alltraps>

801072b2 <vector153>:
.globl vector153
vector153:
  pushl $0
801072b2:	6a 00                	push   $0x0
  pushl $153
801072b4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801072b9:	e9 02 f4 ff ff       	jmp    801066c0 <alltraps>

801072be <vector154>:
.globl vector154
vector154:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $154
801072c0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801072c5:	e9 f6 f3 ff ff       	jmp    801066c0 <alltraps>

801072ca <vector155>:
.globl vector155
vector155:
  pushl $0
801072ca:	6a 00                	push   $0x0
  pushl $155
801072cc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801072d1:	e9 ea f3 ff ff       	jmp    801066c0 <alltraps>

801072d6 <vector156>:
.globl vector156
vector156:
  pushl $0
801072d6:	6a 00                	push   $0x0
  pushl $156
801072d8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801072dd:	e9 de f3 ff ff       	jmp    801066c0 <alltraps>

801072e2 <vector157>:
.globl vector157
vector157:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $157
801072e4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801072e9:	e9 d2 f3 ff ff       	jmp    801066c0 <alltraps>

801072ee <vector158>:
.globl vector158
vector158:
  pushl $0
801072ee:	6a 00                	push   $0x0
  pushl $158
801072f0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801072f5:	e9 c6 f3 ff ff       	jmp    801066c0 <alltraps>

801072fa <vector159>:
.globl vector159
vector159:
  pushl $0
801072fa:	6a 00                	push   $0x0
  pushl $159
801072fc:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107301:	e9 ba f3 ff ff       	jmp    801066c0 <alltraps>

80107306 <vector160>:
.globl vector160
vector160:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $160
80107308:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010730d:	e9 ae f3 ff ff       	jmp    801066c0 <alltraps>

80107312 <vector161>:
.globl vector161
vector161:
  pushl $0
80107312:	6a 00                	push   $0x0
  pushl $161
80107314:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107319:	e9 a2 f3 ff ff       	jmp    801066c0 <alltraps>

8010731e <vector162>:
.globl vector162
vector162:
  pushl $0
8010731e:	6a 00                	push   $0x0
  pushl $162
80107320:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107325:	e9 96 f3 ff ff       	jmp    801066c0 <alltraps>

8010732a <vector163>:
.globl vector163
vector163:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $163
8010732c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107331:	e9 8a f3 ff ff       	jmp    801066c0 <alltraps>

80107336 <vector164>:
.globl vector164
vector164:
  pushl $0
80107336:	6a 00                	push   $0x0
  pushl $164
80107338:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010733d:	e9 7e f3 ff ff       	jmp    801066c0 <alltraps>

80107342 <vector165>:
.globl vector165
vector165:
  pushl $0
80107342:	6a 00                	push   $0x0
  pushl $165
80107344:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107349:	e9 72 f3 ff ff       	jmp    801066c0 <alltraps>

8010734e <vector166>:
.globl vector166
vector166:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $166
80107350:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107355:	e9 66 f3 ff ff       	jmp    801066c0 <alltraps>

8010735a <vector167>:
.globl vector167
vector167:
  pushl $0
8010735a:	6a 00                	push   $0x0
  pushl $167
8010735c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107361:	e9 5a f3 ff ff       	jmp    801066c0 <alltraps>

80107366 <vector168>:
.globl vector168
vector168:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $168
80107368:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010736d:	e9 4e f3 ff ff       	jmp    801066c0 <alltraps>

80107372 <vector169>:
.globl vector169
vector169:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $169
80107374:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107379:	e9 42 f3 ff ff       	jmp    801066c0 <alltraps>

8010737e <vector170>:
.globl vector170
vector170:
  pushl $0
8010737e:	6a 00                	push   $0x0
  pushl $170
80107380:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107385:	e9 36 f3 ff ff       	jmp    801066c0 <alltraps>

8010738a <vector171>:
.globl vector171
vector171:
  pushl $0
8010738a:	6a 00                	push   $0x0
  pushl $171
8010738c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107391:	e9 2a f3 ff ff       	jmp    801066c0 <alltraps>

80107396 <vector172>:
.globl vector172
vector172:
  pushl $0
80107396:	6a 00                	push   $0x0
  pushl $172
80107398:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010739d:	e9 1e f3 ff ff       	jmp    801066c0 <alltraps>

801073a2 <vector173>:
.globl vector173
vector173:
  pushl $0
801073a2:	6a 00                	push   $0x0
  pushl $173
801073a4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801073a9:	e9 12 f3 ff ff       	jmp    801066c0 <alltraps>

801073ae <vector174>:
.globl vector174
vector174:
  pushl $0
801073ae:	6a 00                	push   $0x0
  pushl $174
801073b0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801073b5:	e9 06 f3 ff ff       	jmp    801066c0 <alltraps>

801073ba <vector175>:
.globl vector175
vector175:
  pushl $0
801073ba:	6a 00                	push   $0x0
  pushl $175
801073bc:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801073c1:	e9 fa f2 ff ff       	jmp    801066c0 <alltraps>

801073c6 <vector176>:
.globl vector176
vector176:
  pushl $0
801073c6:	6a 00                	push   $0x0
  pushl $176
801073c8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801073cd:	e9 ee f2 ff ff       	jmp    801066c0 <alltraps>

801073d2 <vector177>:
.globl vector177
vector177:
  pushl $0
801073d2:	6a 00                	push   $0x0
  pushl $177
801073d4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801073d9:	e9 e2 f2 ff ff       	jmp    801066c0 <alltraps>

801073de <vector178>:
.globl vector178
vector178:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $178
801073e0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801073e5:	e9 d6 f2 ff ff       	jmp    801066c0 <alltraps>

801073ea <vector179>:
.globl vector179
vector179:
  pushl $0
801073ea:	6a 00                	push   $0x0
  pushl $179
801073ec:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801073f1:	e9 ca f2 ff ff       	jmp    801066c0 <alltraps>

801073f6 <vector180>:
.globl vector180
vector180:
  pushl $0
801073f6:	6a 00                	push   $0x0
  pushl $180
801073f8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801073fd:	e9 be f2 ff ff       	jmp    801066c0 <alltraps>

80107402 <vector181>:
.globl vector181
vector181:
  pushl $0
80107402:	6a 00                	push   $0x0
  pushl $181
80107404:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107409:	e9 b2 f2 ff ff       	jmp    801066c0 <alltraps>

8010740e <vector182>:
.globl vector182
vector182:
  pushl $0
8010740e:	6a 00                	push   $0x0
  pushl $182
80107410:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107415:	e9 a6 f2 ff ff       	jmp    801066c0 <alltraps>

8010741a <vector183>:
.globl vector183
vector183:
  pushl $0
8010741a:	6a 00                	push   $0x0
  pushl $183
8010741c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107421:	e9 9a f2 ff ff       	jmp    801066c0 <alltraps>

80107426 <vector184>:
.globl vector184
vector184:
  pushl $0
80107426:	6a 00                	push   $0x0
  pushl $184
80107428:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010742d:	e9 8e f2 ff ff       	jmp    801066c0 <alltraps>

80107432 <vector185>:
.globl vector185
vector185:
  pushl $0
80107432:	6a 00                	push   $0x0
  pushl $185
80107434:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107439:	e9 82 f2 ff ff       	jmp    801066c0 <alltraps>

8010743e <vector186>:
.globl vector186
vector186:
  pushl $0
8010743e:	6a 00                	push   $0x0
  pushl $186
80107440:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107445:	e9 76 f2 ff ff       	jmp    801066c0 <alltraps>

8010744a <vector187>:
.globl vector187
vector187:
  pushl $0
8010744a:	6a 00                	push   $0x0
  pushl $187
8010744c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107451:	e9 6a f2 ff ff       	jmp    801066c0 <alltraps>

80107456 <vector188>:
.globl vector188
vector188:
  pushl $0
80107456:	6a 00                	push   $0x0
  pushl $188
80107458:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010745d:	e9 5e f2 ff ff       	jmp    801066c0 <alltraps>

80107462 <vector189>:
.globl vector189
vector189:
  pushl $0
80107462:	6a 00                	push   $0x0
  pushl $189
80107464:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107469:	e9 52 f2 ff ff       	jmp    801066c0 <alltraps>

8010746e <vector190>:
.globl vector190
vector190:
  pushl $0
8010746e:	6a 00                	push   $0x0
  pushl $190
80107470:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107475:	e9 46 f2 ff ff       	jmp    801066c0 <alltraps>

8010747a <vector191>:
.globl vector191
vector191:
  pushl $0
8010747a:	6a 00                	push   $0x0
  pushl $191
8010747c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107481:	e9 3a f2 ff ff       	jmp    801066c0 <alltraps>

80107486 <vector192>:
.globl vector192
vector192:
  pushl $0
80107486:	6a 00                	push   $0x0
  pushl $192
80107488:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010748d:	e9 2e f2 ff ff       	jmp    801066c0 <alltraps>

80107492 <vector193>:
.globl vector193
vector193:
  pushl $0
80107492:	6a 00                	push   $0x0
  pushl $193
80107494:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107499:	e9 22 f2 ff ff       	jmp    801066c0 <alltraps>

8010749e <vector194>:
.globl vector194
vector194:
  pushl $0
8010749e:	6a 00                	push   $0x0
  pushl $194
801074a0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801074a5:	e9 16 f2 ff ff       	jmp    801066c0 <alltraps>

801074aa <vector195>:
.globl vector195
vector195:
  pushl $0
801074aa:	6a 00                	push   $0x0
  pushl $195
801074ac:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801074b1:	e9 0a f2 ff ff       	jmp    801066c0 <alltraps>

801074b6 <vector196>:
.globl vector196
vector196:
  pushl $0
801074b6:	6a 00                	push   $0x0
  pushl $196
801074b8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801074bd:	e9 fe f1 ff ff       	jmp    801066c0 <alltraps>

801074c2 <vector197>:
.globl vector197
vector197:
  pushl $0
801074c2:	6a 00                	push   $0x0
  pushl $197
801074c4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801074c9:	e9 f2 f1 ff ff       	jmp    801066c0 <alltraps>

801074ce <vector198>:
.globl vector198
vector198:
  pushl $0
801074ce:	6a 00                	push   $0x0
  pushl $198
801074d0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801074d5:	e9 e6 f1 ff ff       	jmp    801066c0 <alltraps>

801074da <vector199>:
.globl vector199
vector199:
  pushl $0
801074da:	6a 00                	push   $0x0
  pushl $199
801074dc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801074e1:	e9 da f1 ff ff       	jmp    801066c0 <alltraps>

801074e6 <vector200>:
.globl vector200
vector200:
  pushl $0
801074e6:	6a 00                	push   $0x0
  pushl $200
801074e8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801074ed:	e9 ce f1 ff ff       	jmp    801066c0 <alltraps>

801074f2 <vector201>:
.globl vector201
vector201:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $201
801074f4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801074f9:	e9 c2 f1 ff ff       	jmp    801066c0 <alltraps>

801074fe <vector202>:
.globl vector202
vector202:
  pushl $0
801074fe:	6a 00                	push   $0x0
  pushl $202
80107500:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107505:	e9 b6 f1 ff ff       	jmp    801066c0 <alltraps>

8010750a <vector203>:
.globl vector203
vector203:
  pushl $0
8010750a:	6a 00                	push   $0x0
  pushl $203
8010750c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107511:	e9 aa f1 ff ff       	jmp    801066c0 <alltraps>

80107516 <vector204>:
.globl vector204
vector204:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $204
80107518:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010751d:	e9 9e f1 ff ff       	jmp    801066c0 <alltraps>

80107522 <vector205>:
.globl vector205
vector205:
  pushl $0
80107522:	6a 00                	push   $0x0
  pushl $205
80107524:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107529:	e9 92 f1 ff ff       	jmp    801066c0 <alltraps>

8010752e <vector206>:
.globl vector206
vector206:
  pushl $0
8010752e:	6a 00                	push   $0x0
  pushl $206
80107530:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107535:	e9 86 f1 ff ff       	jmp    801066c0 <alltraps>

8010753a <vector207>:
.globl vector207
vector207:
  pushl $0
8010753a:	6a 00                	push   $0x0
  pushl $207
8010753c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107541:	e9 7a f1 ff ff       	jmp    801066c0 <alltraps>

80107546 <vector208>:
.globl vector208
vector208:
  pushl $0
80107546:	6a 00                	push   $0x0
  pushl $208
80107548:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010754d:	e9 6e f1 ff ff       	jmp    801066c0 <alltraps>

80107552 <vector209>:
.globl vector209
vector209:
  pushl $0
80107552:	6a 00                	push   $0x0
  pushl $209
80107554:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107559:	e9 62 f1 ff ff       	jmp    801066c0 <alltraps>

8010755e <vector210>:
.globl vector210
vector210:
  pushl $0
8010755e:	6a 00                	push   $0x0
  pushl $210
80107560:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107565:	e9 56 f1 ff ff       	jmp    801066c0 <alltraps>

8010756a <vector211>:
.globl vector211
vector211:
  pushl $0
8010756a:	6a 00                	push   $0x0
  pushl $211
8010756c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107571:	e9 4a f1 ff ff       	jmp    801066c0 <alltraps>

80107576 <vector212>:
.globl vector212
vector212:
  pushl $0
80107576:	6a 00                	push   $0x0
  pushl $212
80107578:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010757d:	e9 3e f1 ff ff       	jmp    801066c0 <alltraps>

80107582 <vector213>:
.globl vector213
vector213:
  pushl $0
80107582:	6a 00                	push   $0x0
  pushl $213
80107584:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107589:	e9 32 f1 ff ff       	jmp    801066c0 <alltraps>

8010758e <vector214>:
.globl vector214
vector214:
  pushl $0
8010758e:	6a 00                	push   $0x0
  pushl $214
80107590:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107595:	e9 26 f1 ff ff       	jmp    801066c0 <alltraps>

8010759a <vector215>:
.globl vector215
vector215:
  pushl $0
8010759a:	6a 00                	push   $0x0
  pushl $215
8010759c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801075a1:	e9 1a f1 ff ff       	jmp    801066c0 <alltraps>

801075a6 <vector216>:
.globl vector216
vector216:
  pushl $0
801075a6:	6a 00                	push   $0x0
  pushl $216
801075a8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801075ad:	e9 0e f1 ff ff       	jmp    801066c0 <alltraps>

801075b2 <vector217>:
.globl vector217
vector217:
  pushl $0
801075b2:	6a 00                	push   $0x0
  pushl $217
801075b4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801075b9:	e9 02 f1 ff ff       	jmp    801066c0 <alltraps>

801075be <vector218>:
.globl vector218
vector218:
  pushl $0
801075be:	6a 00                	push   $0x0
  pushl $218
801075c0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801075c5:	e9 f6 f0 ff ff       	jmp    801066c0 <alltraps>

801075ca <vector219>:
.globl vector219
vector219:
  pushl $0
801075ca:	6a 00                	push   $0x0
  pushl $219
801075cc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801075d1:	e9 ea f0 ff ff       	jmp    801066c0 <alltraps>

801075d6 <vector220>:
.globl vector220
vector220:
  pushl $0
801075d6:	6a 00                	push   $0x0
  pushl $220
801075d8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801075dd:	e9 de f0 ff ff       	jmp    801066c0 <alltraps>

801075e2 <vector221>:
.globl vector221
vector221:
  pushl $0
801075e2:	6a 00                	push   $0x0
  pushl $221
801075e4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801075e9:	e9 d2 f0 ff ff       	jmp    801066c0 <alltraps>

801075ee <vector222>:
.globl vector222
vector222:
  pushl $0
801075ee:	6a 00                	push   $0x0
  pushl $222
801075f0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801075f5:	e9 c6 f0 ff ff       	jmp    801066c0 <alltraps>

801075fa <vector223>:
.globl vector223
vector223:
  pushl $0
801075fa:	6a 00                	push   $0x0
  pushl $223
801075fc:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107601:	e9 ba f0 ff ff       	jmp    801066c0 <alltraps>

80107606 <vector224>:
.globl vector224
vector224:
  pushl $0
80107606:	6a 00                	push   $0x0
  pushl $224
80107608:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010760d:	e9 ae f0 ff ff       	jmp    801066c0 <alltraps>

80107612 <vector225>:
.globl vector225
vector225:
  pushl $0
80107612:	6a 00                	push   $0x0
  pushl $225
80107614:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107619:	e9 a2 f0 ff ff       	jmp    801066c0 <alltraps>

8010761e <vector226>:
.globl vector226
vector226:
  pushl $0
8010761e:	6a 00                	push   $0x0
  pushl $226
80107620:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107625:	e9 96 f0 ff ff       	jmp    801066c0 <alltraps>

8010762a <vector227>:
.globl vector227
vector227:
  pushl $0
8010762a:	6a 00                	push   $0x0
  pushl $227
8010762c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107631:	e9 8a f0 ff ff       	jmp    801066c0 <alltraps>

80107636 <vector228>:
.globl vector228
vector228:
  pushl $0
80107636:	6a 00                	push   $0x0
  pushl $228
80107638:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010763d:	e9 7e f0 ff ff       	jmp    801066c0 <alltraps>

80107642 <vector229>:
.globl vector229
vector229:
  pushl $0
80107642:	6a 00                	push   $0x0
  pushl $229
80107644:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107649:	e9 72 f0 ff ff       	jmp    801066c0 <alltraps>

8010764e <vector230>:
.globl vector230
vector230:
  pushl $0
8010764e:	6a 00                	push   $0x0
  pushl $230
80107650:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107655:	e9 66 f0 ff ff       	jmp    801066c0 <alltraps>

8010765a <vector231>:
.globl vector231
vector231:
  pushl $0
8010765a:	6a 00                	push   $0x0
  pushl $231
8010765c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107661:	e9 5a f0 ff ff       	jmp    801066c0 <alltraps>

80107666 <vector232>:
.globl vector232
vector232:
  pushl $0
80107666:	6a 00                	push   $0x0
  pushl $232
80107668:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010766d:	e9 4e f0 ff ff       	jmp    801066c0 <alltraps>

80107672 <vector233>:
.globl vector233
vector233:
  pushl $0
80107672:	6a 00                	push   $0x0
  pushl $233
80107674:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107679:	e9 42 f0 ff ff       	jmp    801066c0 <alltraps>

8010767e <vector234>:
.globl vector234
vector234:
  pushl $0
8010767e:	6a 00                	push   $0x0
  pushl $234
80107680:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107685:	e9 36 f0 ff ff       	jmp    801066c0 <alltraps>

8010768a <vector235>:
.globl vector235
vector235:
  pushl $0
8010768a:	6a 00                	push   $0x0
  pushl $235
8010768c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107691:	e9 2a f0 ff ff       	jmp    801066c0 <alltraps>

80107696 <vector236>:
.globl vector236
vector236:
  pushl $0
80107696:	6a 00                	push   $0x0
  pushl $236
80107698:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010769d:	e9 1e f0 ff ff       	jmp    801066c0 <alltraps>

801076a2 <vector237>:
.globl vector237
vector237:
  pushl $0
801076a2:	6a 00                	push   $0x0
  pushl $237
801076a4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801076a9:	e9 12 f0 ff ff       	jmp    801066c0 <alltraps>

801076ae <vector238>:
.globl vector238
vector238:
  pushl $0
801076ae:	6a 00                	push   $0x0
  pushl $238
801076b0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801076b5:	e9 06 f0 ff ff       	jmp    801066c0 <alltraps>

801076ba <vector239>:
.globl vector239
vector239:
  pushl $0
801076ba:	6a 00                	push   $0x0
  pushl $239
801076bc:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801076c1:	e9 fa ef ff ff       	jmp    801066c0 <alltraps>

801076c6 <vector240>:
.globl vector240
vector240:
  pushl $0
801076c6:	6a 00                	push   $0x0
  pushl $240
801076c8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801076cd:	e9 ee ef ff ff       	jmp    801066c0 <alltraps>

801076d2 <vector241>:
.globl vector241
vector241:
  pushl $0
801076d2:	6a 00                	push   $0x0
  pushl $241
801076d4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801076d9:	e9 e2 ef ff ff       	jmp    801066c0 <alltraps>

801076de <vector242>:
.globl vector242
vector242:
  pushl $0
801076de:	6a 00                	push   $0x0
  pushl $242
801076e0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801076e5:	e9 d6 ef ff ff       	jmp    801066c0 <alltraps>

801076ea <vector243>:
.globl vector243
vector243:
  pushl $0
801076ea:	6a 00                	push   $0x0
  pushl $243
801076ec:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801076f1:	e9 ca ef ff ff       	jmp    801066c0 <alltraps>

801076f6 <vector244>:
.globl vector244
vector244:
  pushl $0
801076f6:	6a 00                	push   $0x0
  pushl $244
801076f8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801076fd:	e9 be ef ff ff       	jmp    801066c0 <alltraps>

80107702 <vector245>:
.globl vector245
vector245:
  pushl $0
80107702:	6a 00                	push   $0x0
  pushl $245
80107704:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107709:	e9 b2 ef ff ff       	jmp    801066c0 <alltraps>

8010770e <vector246>:
.globl vector246
vector246:
  pushl $0
8010770e:	6a 00                	push   $0x0
  pushl $246
80107710:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107715:	e9 a6 ef ff ff       	jmp    801066c0 <alltraps>

8010771a <vector247>:
.globl vector247
vector247:
  pushl $0
8010771a:	6a 00                	push   $0x0
  pushl $247
8010771c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107721:	e9 9a ef ff ff       	jmp    801066c0 <alltraps>

80107726 <vector248>:
.globl vector248
vector248:
  pushl $0
80107726:	6a 00                	push   $0x0
  pushl $248
80107728:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010772d:	e9 8e ef ff ff       	jmp    801066c0 <alltraps>

80107732 <vector249>:
.globl vector249
vector249:
  pushl $0
80107732:	6a 00                	push   $0x0
  pushl $249
80107734:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107739:	e9 82 ef ff ff       	jmp    801066c0 <alltraps>

8010773e <vector250>:
.globl vector250
vector250:
  pushl $0
8010773e:	6a 00                	push   $0x0
  pushl $250
80107740:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107745:	e9 76 ef ff ff       	jmp    801066c0 <alltraps>

8010774a <vector251>:
.globl vector251
vector251:
  pushl $0
8010774a:	6a 00                	push   $0x0
  pushl $251
8010774c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107751:	e9 6a ef ff ff       	jmp    801066c0 <alltraps>

80107756 <vector252>:
.globl vector252
vector252:
  pushl $0
80107756:	6a 00                	push   $0x0
  pushl $252
80107758:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010775d:	e9 5e ef ff ff       	jmp    801066c0 <alltraps>

80107762 <vector253>:
.globl vector253
vector253:
  pushl $0
80107762:	6a 00                	push   $0x0
  pushl $253
80107764:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107769:	e9 52 ef ff ff       	jmp    801066c0 <alltraps>

8010776e <vector254>:
.globl vector254
vector254:
  pushl $0
8010776e:	6a 00                	push   $0x0
  pushl $254
80107770:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107775:	e9 46 ef ff ff       	jmp    801066c0 <alltraps>

8010777a <vector255>:
.globl vector255
vector255:
  pushl $0
8010777a:	6a 00                	push   $0x0
  pushl $255
8010777c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107781:	e9 3a ef ff ff       	jmp    801066c0 <alltraps>

80107786 <lgdt>:
{
80107786:	55                   	push   %ebp
80107787:	89 e5                	mov    %esp,%ebp
80107789:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010778c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010778f:	83 e8 01             	sub    $0x1,%eax
80107792:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107796:	8b 45 08             	mov    0x8(%ebp),%eax
80107799:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010779d:	8b 45 08             	mov    0x8(%ebp),%eax
801077a0:	c1 e8 10             	shr    $0x10,%eax
801077a3:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801077a7:	8d 45 fa             	lea    -0x6(%ebp),%eax
801077aa:	0f 01 10             	lgdtl  (%eax)
}
801077ad:	90                   	nop
801077ae:	c9                   	leave  
801077af:	c3                   	ret    

801077b0 <ltr>:
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	83 ec 04             	sub    $0x4,%esp
801077b6:	8b 45 08             	mov    0x8(%ebp),%eax
801077b9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801077bd:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801077c1:	0f 00 d8             	ltr    %ax
}
801077c4:	90                   	nop
801077c5:	c9                   	leave  
801077c6:	c3                   	ret    

801077c7 <loadgs>:
{
801077c7:	55                   	push   %ebp
801077c8:	89 e5                	mov    %esp,%ebp
801077ca:	83 ec 04             	sub    $0x4,%esp
801077cd:	8b 45 08             	mov    0x8(%ebp),%eax
801077d0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801077d4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801077d8:	8e e8                	mov    %eax,%gs
}
801077da:	90                   	nop
801077db:	c9                   	leave  
801077dc:	c3                   	ret    

801077dd <lcr3>:

static inline void
lcr3(uint val) 
{
801077dd:	55                   	push   %ebp
801077de:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077e0:	8b 45 08             	mov    0x8(%ebp),%eax
801077e3:	0f 22 d8             	mov    %eax,%cr3
}
801077e6:	90                   	nop
801077e7:	5d                   	pop    %ebp
801077e8:	c3                   	ret    

801077e9 <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801077e9:	55                   	push   %ebp
801077ea:	89 e5                	mov    %esp,%ebp
801077ec:	8b 45 08             	mov    0x8(%ebp),%eax
801077ef:	05 00 00 00 80       	add    $0x80000000,%eax
801077f4:	5d                   	pop    %ebp
801077f5:	c3                   	ret    

801077f6 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801077f6:	55                   	push   %ebp
801077f7:	89 e5                	mov    %esp,%ebp
801077f9:	8b 45 08             	mov    0x8(%ebp),%eax
801077fc:	05 00 00 00 80       	add    $0x80000000,%eax
80107801:	5d                   	pop    %ebp
80107802:	c3                   	ret    

80107803 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107803:	55                   	push   %ebp
80107804:	89 e5                	mov    %esp,%ebp
80107806:	53                   	push   %ebx
80107807:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010780a:	e8 19 b7 ff ff       	call   80102f28 <cpunum>
8010780f:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107815:	05 20 e9 10 80       	add    $0x8010e920,%eax
8010781a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010781d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107820:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107826:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107829:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010782f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107832:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107839:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010783d:	83 e2 f0             	and    $0xfffffff0,%edx
80107840:	83 ca 0a             	or     $0xa,%edx
80107843:	88 50 7d             	mov    %dl,0x7d(%eax)
80107846:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107849:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010784d:	83 ca 10             	or     $0x10,%edx
80107850:	88 50 7d             	mov    %dl,0x7d(%eax)
80107853:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107856:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010785a:	83 e2 9f             	and    $0xffffff9f,%edx
8010785d:	88 50 7d             	mov    %dl,0x7d(%eax)
80107860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107863:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107867:	83 ca 80             	or     $0xffffff80,%edx
8010786a:	88 50 7d             	mov    %dl,0x7d(%eax)
8010786d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107870:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107874:	83 ca 0f             	or     $0xf,%edx
80107877:	88 50 7e             	mov    %dl,0x7e(%eax)
8010787a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107881:	83 e2 ef             	and    $0xffffffef,%edx
80107884:	88 50 7e             	mov    %dl,0x7e(%eax)
80107887:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010788e:	83 e2 df             	and    $0xffffffdf,%edx
80107891:	88 50 7e             	mov    %dl,0x7e(%eax)
80107894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107897:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010789b:	83 ca 40             	or     $0x40,%edx
8010789e:	88 50 7e             	mov    %dl,0x7e(%eax)
801078a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a4:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801078a8:	83 ca 80             	or     $0xffffff80,%edx
801078ab:	88 50 7e             	mov    %dl,0x7e(%eax)
801078ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b1:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801078b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b8:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801078bf:	ff ff 
801078c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c4:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801078cb:	00 00 
801078cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d0:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801078d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078da:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078e1:	83 e2 f0             	and    $0xfffffff0,%edx
801078e4:	83 ca 02             	or     $0x2,%edx
801078e7:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f0:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078f7:	83 ca 10             	or     $0x10,%edx
801078fa:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107903:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010790a:	83 e2 9f             	and    $0xffffff9f,%edx
8010790d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107913:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107916:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010791d:	83 ca 80             	or     $0xffffff80,%edx
80107920:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107926:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107929:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107930:	83 ca 0f             	or     $0xf,%edx
80107933:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010793c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107943:	83 e2 ef             	and    $0xffffffef,%edx
80107946:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010794c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010794f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107956:	83 e2 df             	and    $0xffffffdf,%edx
80107959:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010795f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107962:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107969:	83 ca 40             	or     $0x40,%edx
8010796c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107972:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107975:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010797c:	83 ca 80             	or     $0xffffff80,%edx
8010797f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107985:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107988:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010798f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107992:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107999:	ff ff 
8010799b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010799e:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801079a5:	00 00 
801079a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079aa:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801079b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b4:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801079bb:	83 e2 f0             	and    $0xfffffff0,%edx
801079be:	83 ca 0a             	or     $0xa,%edx
801079c1:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801079c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ca:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801079d1:	83 ca 10             	or     $0x10,%edx
801079d4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801079da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079dd:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801079e4:	83 ca 60             	or     $0x60,%edx
801079e7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801079ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801079f7:	83 ca 80             	or     $0xffffff80,%edx
801079fa:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a03:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107a0a:	83 ca 0f             	or     $0xf,%edx
80107a0d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a16:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107a1d:	83 e2 ef             	and    $0xffffffef,%edx
80107a20:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a29:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107a30:	83 e2 df             	and    $0xffffffdf,%edx
80107a33:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a3c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107a43:	83 ca 40             	or     $0x40,%edx
80107a46:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107a56:	83 ca 80             	or     $0xffffff80,%edx
80107a59:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a62:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6c:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107a73:	ff ff 
80107a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a78:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107a7f:	00 00 
80107a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a84:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a95:	83 e2 f0             	and    $0xfffffff0,%edx
80107a98:	83 ca 02             	or     $0x2,%edx
80107a9b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa4:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107aab:	83 ca 10             	or     $0x10,%edx
80107aae:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab7:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107abe:	83 ca 60             	or     $0x60,%edx
80107ac1:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aca:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ad1:	83 ca 80             	or     $0xffffff80,%edx
80107ad4:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107add:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ae4:	83 ca 0f             	or     $0xf,%edx
80107ae7:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af0:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107af7:	83 e2 ef             	and    $0xffffffef,%edx
80107afa:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b03:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107b0a:	83 e2 df             	and    $0xffffffdf,%edx
80107b0d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b16:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107b1d:	83 ca 40             	or     $0x40,%edx
80107b20:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b29:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107b30:	83 ca 80             	or     $0xffffff80,%edx
80107b33:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3c:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b46:	05 b4 00 00 00       	add    $0xb4,%eax
80107b4b:	89 c3                	mov    %eax,%ebx
80107b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b50:	05 b4 00 00 00       	add    $0xb4,%eax
80107b55:	c1 e8 10             	shr    $0x10,%eax
80107b58:	89 c2                	mov    %eax,%edx
80107b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b5d:	05 b4 00 00 00       	add    $0xb4,%eax
80107b62:	c1 e8 18             	shr    $0x18,%eax
80107b65:	89 c1                	mov    %eax,%ecx
80107b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b6a:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107b71:	00 00 
80107b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b76:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b80:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b89:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107b90:	83 e2 f0             	and    $0xfffffff0,%edx
80107b93:	83 ca 02             	or     $0x2,%edx
80107b96:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b9f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107ba6:	83 ca 10             	or     $0x10,%edx
80107ba9:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb2:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107bb9:	83 e2 9f             	and    $0xffffff9f,%edx
80107bbc:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc5:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107bcc:	83 ca 80             	or     $0xffffff80,%edx
80107bcf:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd8:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107bdf:	83 e2 f0             	and    $0xfffffff0,%edx
80107be2:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107beb:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107bf2:	83 e2 ef             	and    $0xffffffef,%edx
80107bf5:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bfe:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107c05:	83 e2 df             	and    $0xffffffdf,%edx
80107c08:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c11:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107c18:	83 ca 40             	or     $0x40,%edx
80107c1b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c24:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107c2b:	83 ca 80             	or     $0xffffff80,%edx
80107c2e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c37:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c40:	83 c0 70             	add    $0x70,%eax
80107c43:	83 ec 08             	sub    $0x8,%esp
80107c46:	6a 38                	push   $0x38
80107c48:	50                   	push   %eax
80107c49:	e8 38 fb ff ff       	call   80107786 <lgdt>
80107c4e:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80107c51:	83 ec 0c             	sub    $0xc,%esp
80107c54:	6a 18                	push   $0x18
80107c56:	e8 6c fb ff ff       	call   801077c7 <loadgs>
80107c5b:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80107c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c61:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107c67:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107c6e:	00 00 00 00 
}
80107c72:	90                   	nop
80107c73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107c76:	c9                   	leave  
80107c77:	c3                   	ret    

80107c78 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107c78:	55                   	push   %ebp
80107c79:	89 e5                	mov    %esp,%ebp
80107c7b:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c81:	c1 e8 16             	shr    $0x16,%eax
80107c84:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107c8b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c8e:	01 d0                	add    %edx,%eax
80107c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c96:	8b 00                	mov    (%eax),%eax
80107c98:	83 e0 01             	and    $0x1,%eax
80107c9b:	85 c0                	test   %eax,%eax
80107c9d:	74 18                	je     80107cb7 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ca2:	8b 00                	mov    (%eax),%eax
80107ca4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ca9:	50                   	push   %eax
80107caa:	e8 47 fb ff ff       	call   801077f6 <p2v>
80107caf:	83 c4 04             	add    $0x4,%esp
80107cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107cb5:	eb 48                	jmp    80107cff <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107cb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107cbb:	74 0e                	je     80107ccb <walkpgdir+0x53>
80107cbd:	e8 19 af ff ff       	call   80102bdb <kalloc>
80107cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107cc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107cc9:	75 07                	jne    80107cd2 <walkpgdir+0x5a>
      return 0;
80107ccb:	b8 00 00 00 00       	mov    $0x0,%eax
80107cd0:	eb 44                	jmp    80107d16 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107cd2:	83 ec 04             	sub    $0x4,%esp
80107cd5:	68 00 10 00 00       	push   $0x1000
80107cda:	6a 00                	push   $0x0
80107cdc:	ff 75 f4             	pushl  -0xc(%ebp)
80107cdf:	e8 5a d5 ff ff       	call   8010523e <memset>
80107ce4:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107ce7:	83 ec 0c             	sub    $0xc,%esp
80107cea:	ff 75 f4             	pushl  -0xc(%ebp)
80107ced:	e8 f7 fa ff ff       	call   801077e9 <v2p>
80107cf2:	83 c4 10             	add    $0x10,%esp
80107cf5:	83 c8 07             	or     $0x7,%eax
80107cf8:	89 c2                	mov    %eax,%edx
80107cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cfd:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107cff:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d02:	c1 e8 0c             	shr    $0xc,%eax
80107d05:	25 ff 03 00 00       	and    $0x3ff,%eax
80107d0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d14:	01 d0                	add    %edx,%eax
}
80107d16:	c9                   	leave  
80107d17:	c3                   	ret    

80107d18 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107d18:	55                   	push   %ebp
80107d19:	89 e5                	mov    %esp,%ebp
80107d1b:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107d29:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d2c:	8b 45 10             	mov    0x10(%ebp),%eax
80107d2f:	01 d0                	add    %edx,%eax
80107d31:	83 e8 01             	sub    $0x1,%eax
80107d34:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107d3c:	83 ec 04             	sub    $0x4,%esp
80107d3f:	6a 01                	push   $0x1
80107d41:	ff 75 f4             	pushl  -0xc(%ebp)
80107d44:	ff 75 08             	pushl  0x8(%ebp)
80107d47:	e8 2c ff ff ff       	call   80107c78 <walkpgdir>
80107d4c:	83 c4 10             	add    $0x10,%esp
80107d4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107d52:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107d56:	75 07                	jne    80107d5f <mappages+0x47>
      return -1;
80107d58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d5d:	eb 47                	jmp    80107da6 <mappages+0x8e>
    if(*pte & PTE_P)
80107d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d62:	8b 00                	mov    (%eax),%eax
80107d64:	83 e0 01             	and    $0x1,%eax
80107d67:	85 c0                	test   %eax,%eax
80107d69:	74 0d                	je     80107d78 <mappages+0x60>
      panic("remap");
80107d6b:	83 ec 0c             	sub    $0xc,%esp
80107d6e:	68 28 8b 10 80       	push   $0x80108b28
80107d73:	e8 03 88 ff ff       	call   8010057b <panic>
    *pte = pa | perm | PTE_P;
80107d78:	8b 45 18             	mov    0x18(%ebp),%eax
80107d7b:	0b 45 14             	or     0x14(%ebp),%eax
80107d7e:	83 c8 01             	or     $0x1,%eax
80107d81:	89 c2                	mov    %eax,%edx
80107d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d86:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107d8e:	74 10                	je     80107da0 <mappages+0x88>
      break;
    a += PGSIZE;
80107d90:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107d97:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107d9e:	eb 9c                	jmp    80107d3c <mappages+0x24>
      break;
80107da0:	90                   	nop
  }
  return 0;
80107da1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107da6:	c9                   	leave  
80107da7:	c3                   	ret    

80107da8 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm()
{
80107da8:	55                   	push   %ebp
80107da9:	89 e5                	mov    %esp,%ebp
80107dab:	53                   	push   %ebx
80107dac:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107daf:	e8 27 ae ff ff       	call   80102bdb <kalloc>
80107db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107db7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107dbb:	75 0a                	jne    80107dc7 <setupkvm+0x1f>
    return 0;
80107dbd:	b8 00 00 00 00       	mov    $0x0,%eax
80107dc2:	e9 8e 00 00 00       	jmp    80107e55 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80107dc7:	83 ec 04             	sub    $0x4,%esp
80107dca:	68 00 10 00 00       	push   $0x1000
80107dcf:	6a 00                	push   $0x0
80107dd1:	ff 75 f0             	pushl  -0x10(%ebp)
80107dd4:	e8 65 d4 ff ff       	call   8010523e <memset>
80107dd9:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107ddc:	83 ec 0c             	sub    $0xc,%esp
80107ddf:	68 00 00 00 0e       	push   $0xe000000
80107de4:	e8 0d fa ff ff       	call   801077f6 <p2v>
80107de9:	83 c4 10             	add    $0x10,%esp
80107dec:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107df1:	76 0d                	jbe    80107e00 <setupkvm+0x58>
    panic("PHYSTOP too high");
80107df3:	83 ec 0c             	sub    $0xc,%esp
80107df6:	68 2e 8b 10 80       	push   $0x80108b2e
80107dfb:	e8 7b 87 ff ff       	call   8010057b <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e00:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80107e07:	eb 40                	jmp    80107e49 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0c:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80107e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e12:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e18:	8b 58 08             	mov    0x8(%eax),%ebx
80107e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1e:	8b 40 04             	mov    0x4(%eax),%eax
80107e21:	29 c3                	sub    %eax,%ebx
80107e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e26:	8b 00                	mov    (%eax),%eax
80107e28:	83 ec 0c             	sub    $0xc,%esp
80107e2b:	51                   	push   %ecx
80107e2c:	52                   	push   %edx
80107e2d:	53                   	push   %ebx
80107e2e:	50                   	push   %eax
80107e2f:	ff 75 f0             	pushl  -0x10(%ebp)
80107e32:	e8 e1 fe ff ff       	call   80107d18 <mappages>
80107e37:	83 c4 20             	add    $0x20,%esp
80107e3a:	85 c0                	test   %eax,%eax
80107e3c:	79 07                	jns    80107e45 <setupkvm+0x9d>
      return 0;
80107e3e:	b8 00 00 00 00       	mov    $0x0,%eax
80107e43:	eb 10                	jmp    80107e55 <setupkvm+0xad>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e45:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107e49:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80107e50:	72 b7                	jb     80107e09 <setupkvm+0x61>
  return pgdir;
80107e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107e55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107e58:	c9                   	leave  
80107e59:	c3                   	ret    

80107e5a <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107e5a:	55                   	push   %ebp
80107e5b:	89 e5                	mov    %esp,%ebp
80107e5d:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e60:	e8 43 ff ff ff       	call   80107da8 <setupkvm>
80107e65:	a3 80 2b 11 80       	mov    %eax,0x80112b80
  switchkvm();
80107e6a:	e8 03 00 00 00       	call   80107e72 <switchkvm>
}
80107e6f:	90                   	nop
80107e70:	c9                   	leave  
80107e71:	c3                   	ret    

80107e72 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107e72:	55                   	push   %ebp
80107e73:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107e75:	a1 80 2b 11 80       	mov    0x80112b80,%eax
80107e7a:	50                   	push   %eax
80107e7b:	e8 69 f9 ff ff       	call   801077e9 <v2p>
80107e80:	83 c4 04             	add    $0x4,%esp
80107e83:	50                   	push   %eax
80107e84:	e8 54 f9 ff ff       	call   801077dd <lcr3>
80107e89:	83 c4 04             	add    $0x4,%esp
}
80107e8c:	90                   	nop
80107e8d:	c9                   	leave  
80107e8e:	c3                   	ret    

80107e8f <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107e8f:	55                   	push   %ebp
80107e90:	89 e5                	mov    %esp,%ebp
80107e92:	56                   	push   %esi
80107e93:	53                   	push   %ebx
  pushcli();
80107e94:	e8 a0 d2 ff ff       	call   80105139 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107e99:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e9f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107ea6:	83 c2 08             	add    $0x8,%edx
80107ea9:	89 d6                	mov    %edx,%esi
80107eab:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107eb2:	83 c2 08             	add    $0x8,%edx
80107eb5:	c1 ea 10             	shr    $0x10,%edx
80107eb8:	89 d3                	mov    %edx,%ebx
80107eba:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107ec1:	83 c2 08             	add    $0x8,%edx
80107ec4:	c1 ea 18             	shr    $0x18,%edx
80107ec7:	89 d1                	mov    %edx,%ecx
80107ec9:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107ed0:	67 00 
80107ed2:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80107ed9:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107edf:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107ee6:	83 e2 f0             	and    $0xfffffff0,%edx
80107ee9:	83 ca 09             	or     $0x9,%edx
80107eec:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107ef2:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107ef9:	83 ca 10             	or     $0x10,%edx
80107efc:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107f02:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107f09:	83 e2 9f             	and    $0xffffff9f,%edx
80107f0c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107f12:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107f19:	83 ca 80             	or     $0xffffff80,%edx
80107f1c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107f22:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107f29:	83 e2 f0             	and    $0xfffffff0,%edx
80107f2c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107f32:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107f39:	83 e2 ef             	and    $0xffffffef,%edx
80107f3c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107f42:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107f49:	83 e2 df             	and    $0xffffffdf,%edx
80107f4c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107f52:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107f59:	83 ca 40             	or     $0x40,%edx
80107f5c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107f62:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107f69:	83 e2 7f             	and    $0x7f,%edx
80107f6c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107f72:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107f78:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f7e:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107f85:	83 e2 ef             	and    $0xffffffef,%edx
80107f88:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107f8e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f94:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107f9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107fa0:	8b 40 08             	mov    0x8(%eax),%eax
80107fa3:	89 c2                	mov    %eax,%edx
80107fa5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107fab:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107fb1:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107fb4:	83 ec 0c             	sub    $0xc,%esp
80107fb7:	6a 30                	push   $0x30
80107fb9:	e8 f2 f7 ff ff       	call   801077b0 <ltr>
80107fbe:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80107fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80107fc4:	8b 40 04             	mov    0x4(%eax),%eax
80107fc7:	85 c0                	test   %eax,%eax
80107fc9:	75 0d                	jne    80107fd8 <switchuvm+0x149>
    panic("switchuvm: no pgdir");
80107fcb:	83 ec 0c             	sub    $0xc,%esp
80107fce:	68 3f 8b 10 80       	push   $0x80108b3f
80107fd3:	e8 a3 85 ff ff       	call   8010057b <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80107fdb:	8b 40 04             	mov    0x4(%eax),%eax
80107fde:	83 ec 0c             	sub    $0xc,%esp
80107fe1:	50                   	push   %eax
80107fe2:	e8 02 f8 ff ff       	call   801077e9 <v2p>
80107fe7:	83 c4 10             	add    $0x10,%esp
80107fea:	83 ec 0c             	sub    $0xc,%esp
80107fed:	50                   	push   %eax
80107fee:	e8 ea f7 ff ff       	call   801077dd <lcr3>
80107ff3:	83 c4 10             	add    $0x10,%esp
  popcli();
80107ff6:	e8 82 d1 ff ff       	call   8010517d <popcli>
}
80107ffb:	90                   	nop
80107ffc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107fff:	5b                   	pop    %ebx
80108000:	5e                   	pop    %esi
80108001:	5d                   	pop    %ebp
80108002:	c3                   	ret    

80108003 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108003:	55                   	push   %ebp
80108004:	89 e5                	mov    %esp,%ebp
80108006:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108009:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108010:	76 0d                	jbe    8010801f <inituvm+0x1c>
    panic("inituvm: more than a page");
80108012:	83 ec 0c             	sub    $0xc,%esp
80108015:	68 53 8b 10 80       	push   $0x80108b53
8010801a:	e8 5c 85 ff ff       	call   8010057b <panic>
  mem = kalloc();
8010801f:	e8 b7 ab ff ff       	call   80102bdb <kalloc>
80108024:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108027:	83 ec 04             	sub    $0x4,%esp
8010802a:	68 00 10 00 00       	push   $0x1000
8010802f:	6a 00                	push   $0x0
80108031:	ff 75 f4             	pushl  -0xc(%ebp)
80108034:	e8 05 d2 ff ff       	call   8010523e <memset>
80108039:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010803c:	83 ec 0c             	sub    $0xc,%esp
8010803f:	ff 75 f4             	pushl  -0xc(%ebp)
80108042:	e8 a2 f7 ff ff       	call   801077e9 <v2p>
80108047:	83 c4 10             	add    $0x10,%esp
8010804a:	83 ec 0c             	sub    $0xc,%esp
8010804d:	6a 06                	push   $0x6
8010804f:	50                   	push   %eax
80108050:	68 00 10 00 00       	push   $0x1000
80108055:	6a 00                	push   $0x0
80108057:	ff 75 08             	pushl  0x8(%ebp)
8010805a:	e8 b9 fc ff ff       	call   80107d18 <mappages>
8010805f:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108062:	83 ec 04             	sub    $0x4,%esp
80108065:	ff 75 10             	pushl  0x10(%ebp)
80108068:	ff 75 0c             	pushl  0xc(%ebp)
8010806b:	ff 75 f4             	pushl  -0xc(%ebp)
8010806e:	e8 8a d2 ff ff       	call   801052fd <memmove>
80108073:	83 c4 10             	add    $0x10,%esp
}
80108076:	90                   	nop
80108077:	c9                   	leave  
80108078:	c3                   	ret    

80108079 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108079:	55                   	push   %ebp
8010807a:	89 e5                	mov    %esp,%ebp
8010807c:	53                   	push   %ebx
8010807d:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108080:	8b 45 0c             	mov    0xc(%ebp),%eax
80108083:	25 ff 0f 00 00       	and    $0xfff,%eax
80108088:	85 c0                	test   %eax,%eax
8010808a:	74 0d                	je     80108099 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
8010808c:	83 ec 0c             	sub    $0xc,%esp
8010808f:	68 70 8b 10 80       	push   $0x80108b70
80108094:	e8 e2 84 ff ff       	call   8010057b <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801080a0:	e9 95 00 00 00       	jmp    8010813a <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801080a5:	8b 55 0c             	mov    0xc(%ebp),%edx
801080a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ab:	01 d0                	add    %edx,%eax
801080ad:	83 ec 04             	sub    $0x4,%esp
801080b0:	6a 00                	push   $0x0
801080b2:	50                   	push   %eax
801080b3:	ff 75 08             	pushl  0x8(%ebp)
801080b6:	e8 bd fb ff ff       	call   80107c78 <walkpgdir>
801080bb:	83 c4 10             	add    $0x10,%esp
801080be:	89 45 ec             	mov    %eax,-0x14(%ebp)
801080c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801080c5:	75 0d                	jne    801080d4 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801080c7:	83 ec 0c             	sub    $0xc,%esp
801080ca:	68 93 8b 10 80       	push   $0x80108b93
801080cf:	e8 a7 84 ff ff       	call   8010057b <panic>
    pa = PTE_ADDR(*pte);
801080d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080d7:	8b 00                	mov    (%eax),%eax
801080d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080de:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801080e1:	8b 45 18             	mov    0x18(%ebp),%eax
801080e4:	2b 45 f4             	sub    -0xc(%ebp),%eax
801080e7:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801080ec:	77 0b                	ja     801080f9 <loaduvm+0x80>
      n = sz - i;
801080ee:	8b 45 18             	mov    0x18(%ebp),%eax
801080f1:	2b 45 f4             	sub    -0xc(%ebp),%eax
801080f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801080f7:	eb 07                	jmp    80108100 <loaduvm+0x87>
    else
      n = PGSIZE;
801080f9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108100:	8b 55 14             	mov    0x14(%ebp),%edx
80108103:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108106:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108109:	83 ec 0c             	sub    $0xc,%esp
8010810c:	ff 75 e8             	pushl  -0x18(%ebp)
8010810f:	e8 e2 f6 ff ff       	call   801077f6 <p2v>
80108114:	83 c4 10             	add    $0x10,%esp
80108117:	ff 75 f0             	pushl  -0x10(%ebp)
8010811a:	53                   	push   %ebx
8010811b:	50                   	push   %eax
8010811c:	ff 75 10             	pushl  0x10(%ebp)
8010811f:	e8 6a 9d ff ff       	call   80101e8e <readi>
80108124:	83 c4 10             	add    $0x10,%esp
80108127:	39 45 f0             	cmp    %eax,-0x10(%ebp)
8010812a:	74 07                	je     80108133 <loaduvm+0xba>
      return -1;
8010812c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108131:	eb 18                	jmp    8010814b <loaduvm+0xd2>
  for(i = 0; i < sz; i += PGSIZE){
80108133:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010813a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813d:	3b 45 18             	cmp    0x18(%ebp),%eax
80108140:	0f 82 5f ff ff ff    	jb     801080a5 <loaduvm+0x2c>
  }
  return 0;
80108146:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010814b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010814e:	c9                   	leave  
8010814f:	c3                   	ret    

80108150 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108150:	55                   	push   %ebp
80108151:	89 e5                	mov    %esp,%ebp
80108153:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108156:	8b 45 10             	mov    0x10(%ebp),%eax
80108159:	85 c0                	test   %eax,%eax
8010815b:	79 0a                	jns    80108167 <allocuvm+0x17>
    return 0;
8010815d:	b8 00 00 00 00       	mov    $0x0,%eax
80108162:	e9 ae 00 00 00       	jmp    80108215 <allocuvm+0xc5>
  if(newsz < oldsz)
80108167:	8b 45 10             	mov    0x10(%ebp),%eax
8010816a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010816d:	73 08                	jae    80108177 <allocuvm+0x27>
    return oldsz;
8010816f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108172:	e9 9e 00 00 00       	jmp    80108215 <allocuvm+0xc5>

  a = PGROUNDUP(oldsz);
80108177:	8b 45 0c             	mov    0xc(%ebp),%eax
8010817a:	05 ff 0f 00 00       	add    $0xfff,%eax
8010817f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108184:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108187:	eb 7d                	jmp    80108206 <allocuvm+0xb6>
    mem = kalloc();
80108189:	e8 4d aa ff ff       	call   80102bdb <kalloc>
8010818e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108191:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108195:	75 2b                	jne    801081c2 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108197:	83 ec 0c             	sub    $0xc,%esp
8010819a:	68 b1 8b 10 80       	push   $0x80108bb1
8010819f:	e8 22 82 ff ff       	call   801003c6 <cprintf>
801081a4:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801081a7:	83 ec 04             	sub    $0x4,%esp
801081aa:	ff 75 0c             	pushl  0xc(%ebp)
801081ad:	ff 75 10             	pushl  0x10(%ebp)
801081b0:	ff 75 08             	pushl  0x8(%ebp)
801081b3:	e8 5f 00 00 00       	call   80108217 <deallocuvm>
801081b8:	83 c4 10             	add    $0x10,%esp
      return 0;
801081bb:	b8 00 00 00 00       	mov    $0x0,%eax
801081c0:	eb 53                	jmp    80108215 <allocuvm+0xc5>
    }
    memset(mem, 0, PGSIZE);
801081c2:	83 ec 04             	sub    $0x4,%esp
801081c5:	68 00 10 00 00       	push   $0x1000
801081ca:	6a 00                	push   $0x0
801081cc:	ff 75 f0             	pushl  -0x10(%ebp)
801081cf:	e8 6a d0 ff ff       	call   8010523e <memset>
801081d4:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801081d7:	83 ec 0c             	sub    $0xc,%esp
801081da:	ff 75 f0             	pushl  -0x10(%ebp)
801081dd:	e8 07 f6 ff ff       	call   801077e9 <v2p>
801081e2:	83 c4 10             	add    $0x10,%esp
801081e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801081e8:	83 ec 0c             	sub    $0xc,%esp
801081eb:	6a 06                	push   $0x6
801081ed:	50                   	push   %eax
801081ee:	68 00 10 00 00       	push   $0x1000
801081f3:	52                   	push   %edx
801081f4:	ff 75 08             	pushl  0x8(%ebp)
801081f7:	e8 1c fb ff ff       	call   80107d18 <mappages>
801081fc:	83 c4 20             	add    $0x20,%esp
  for(; a < newsz; a += PGSIZE){
801081ff:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108206:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108209:	3b 45 10             	cmp    0x10(%ebp),%eax
8010820c:	0f 82 77 ff ff ff    	jb     80108189 <allocuvm+0x39>
  }
  return newsz;
80108212:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108215:	c9                   	leave  
80108216:	c3                   	ret    

80108217 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108217:	55                   	push   %ebp
80108218:	89 e5                	mov    %esp,%ebp
8010821a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010821d:	8b 45 10             	mov    0x10(%ebp),%eax
80108220:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108223:	72 08                	jb     8010822d <deallocuvm+0x16>
    return oldsz;
80108225:	8b 45 0c             	mov    0xc(%ebp),%eax
80108228:	e9 a5 00 00 00       	jmp    801082d2 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
8010822d:	8b 45 10             	mov    0x10(%ebp),%eax
80108230:	05 ff 0f 00 00       	add    $0xfff,%eax
80108235:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010823a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010823d:	e9 81 00 00 00       	jmp    801082c3 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108242:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108245:	83 ec 04             	sub    $0x4,%esp
80108248:	6a 00                	push   $0x0
8010824a:	50                   	push   %eax
8010824b:	ff 75 08             	pushl  0x8(%ebp)
8010824e:	e8 25 fa ff ff       	call   80107c78 <walkpgdir>
80108253:	83 c4 10             	add    $0x10,%esp
80108256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108259:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010825d:	75 09                	jne    80108268 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
8010825f:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108266:	eb 54                	jmp    801082bc <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108268:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010826b:	8b 00                	mov    (%eax),%eax
8010826d:	83 e0 01             	and    $0x1,%eax
80108270:	85 c0                	test   %eax,%eax
80108272:	74 48                	je     801082bc <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108274:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108277:	8b 00                	mov    (%eax),%eax
80108279:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010827e:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108281:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108285:	75 0d                	jne    80108294 <deallocuvm+0x7d>
        panic("kfree");
80108287:	83 ec 0c             	sub    $0xc,%esp
8010828a:	68 c9 8b 10 80       	push   $0x80108bc9
8010828f:	e8 e7 82 ff ff       	call   8010057b <panic>
      char *v = p2v(pa);
80108294:	83 ec 0c             	sub    $0xc,%esp
80108297:	ff 75 ec             	pushl  -0x14(%ebp)
8010829a:	e8 57 f5 ff ff       	call   801077f6 <p2v>
8010829f:	83 c4 10             	add    $0x10,%esp
801082a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801082a5:	83 ec 0c             	sub    $0xc,%esp
801082a8:	ff 75 e8             	pushl  -0x18(%ebp)
801082ab:	e8 8e a8 ff ff       	call   80102b3e <kfree>
801082b0:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801082b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801082bc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801082c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
801082c9:	0f 82 73 ff ff ff    	jb     80108242 <deallocuvm+0x2b>
    }
  }
  return newsz;
801082cf:	8b 45 10             	mov    0x10(%ebp),%eax
}
801082d2:	c9                   	leave  
801082d3:	c3                   	ret    

801082d4 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801082d4:	55                   	push   %ebp
801082d5:	89 e5                	mov    %esp,%ebp
801082d7:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801082da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801082de:	75 0d                	jne    801082ed <freevm+0x19>
    panic("freevm: no pgdir");
801082e0:	83 ec 0c             	sub    $0xc,%esp
801082e3:	68 cf 8b 10 80       	push   $0x80108bcf
801082e8:	e8 8e 82 ff ff       	call   8010057b <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801082ed:	83 ec 04             	sub    $0x4,%esp
801082f0:	6a 00                	push   $0x0
801082f2:	68 00 00 00 80       	push   $0x80000000
801082f7:	ff 75 08             	pushl  0x8(%ebp)
801082fa:	e8 18 ff ff ff       	call   80108217 <deallocuvm>
801082ff:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108302:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108309:	eb 4f                	jmp    8010835a <freevm+0x86>
    if(pgdir[i] & PTE_P){
8010830b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010830e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108315:	8b 45 08             	mov    0x8(%ebp),%eax
80108318:	01 d0                	add    %edx,%eax
8010831a:	8b 00                	mov    (%eax),%eax
8010831c:	83 e0 01             	and    $0x1,%eax
8010831f:	85 c0                	test   %eax,%eax
80108321:	74 33                	je     80108356 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108323:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108326:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010832d:	8b 45 08             	mov    0x8(%ebp),%eax
80108330:	01 d0                	add    %edx,%eax
80108332:	8b 00                	mov    (%eax),%eax
80108334:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108339:	83 ec 0c             	sub    $0xc,%esp
8010833c:	50                   	push   %eax
8010833d:	e8 b4 f4 ff ff       	call   801077f6 <p2v>
80108342:	83 c4 10             	add    $0x10,%esp
80108345:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108348:	83 ec 0c             	sub    $0xc,%esp
8010834b:	ff 75 f0             	pushl  -0x10(%ebp)
8010834e:	e8 eb a7 ff ff       	call   80102b3e <kfree>
80108353:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108356:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010835a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108361:	76 a8                	jbe    8010830b <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80108363:	83 ec 0c             	sub    $0xc,%esp
80108366:	ff 75 08             	pushl  0x8(%ebp)
80108369:	e8 d0 a7 ff ff       	call   80102b3e <kfree>
8010836e:	83 c4 10             	add    $0x10,%esp
}
80108371:	90                   	nop
80108372:	c9                   	leave  
80108373:	c3                   	ret    

80108374 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108374:	55                   	push   %ebp
80108375:	89 e5                	mov    %esp,%ebp
80108377:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010837a:	83 ec 04             	sub    $0x4,%esp
8010837d:	6a 00                	push   $0x0
8010837f:	ff 75 0c             	pushl  0xc(%ebp)
80108382:	ff 75 08             	pushl  0x8(%ebp)
80108385:	e8 ee f8 ff ff       	call   80107c78 <walkpgdir>
8010838a:	83 c4 10             	add    $0x10,%esp
8010838d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108394:	75 0d                	jne    801083a3 <clearpteu+0x2f>
    panic("clearpteu");
80108396:	83 ec 0c             	sub    $0xc,%esp
80108399:	68 e0 8b 10 80       	push   $0x80108be0
8010839e:	e8 d8 81 ff ff       	call   8010057b <panic>
  *pte &= ~PTE_U;
801083a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a6:	8b 00                	mov    (%eax),%eax
801083a8:	83 e0 fb             	and    $0xfffffffb,%eax
801083ab:	89 c2                	mov    %eax,%edx
801083ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b0:	89 10                	mov    %edx,(%eax)
}
801083b2:	90                   	nop
801083b3:	c9                   	leave  
801083b4:	c3                   	ret    

801083b5 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801083b5:	55                   	push   %ebp
801083b6:	89 e5                	mov    %esp,%ebp
801083b8:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
801083bb:	e8 e8 f9 ff ff       	call   80107da8 <setupkvm>
801083c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801083c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801083c7:	75 0a                	jne    801083d3 <copyuvm+0x1e>
    return 0;
801083c9:	b8 00 00 00 00       	mov    $0x0,%eax
801083ce:	e9 e7 00 00 00       	jmp    801084ba <copyuvm+0x105>
  for(i = 0; i < sz; i += PGSIZE){
801083d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801083da:	e9 b3 00 00 00       	jmp    80108492 <copyuvm+0xdd>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801083df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e2:	83 ec 04             	sub    $0x4,%esp
801083e5:	6a 00                	push   $0x0
801083e7:	50                   	push   %eax
801083e8:	ff 75 08             	pushl  0x8(%ebp)
801083eb:	e8 88 f8 ff ff       	call   80107c78 <walkpgdir>
801083f0:	83 c4 10             	add    $0x10,%esp
801083f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801083f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801083fa:	75 0d                	jne    80108409 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
801083fc:	83 ec 0c             	sub    $0xc,%esp
801083ff:	68 ea 8b 10 80       	push   $0x80108bea
80108404:	e8 72 81 ff ff       	call   8010057b <panic>
    if(!(*pte & PTE_P))
80108409:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010840c:	8b 00                	mov    (%eax),%eax
8010840e:	83 e0 01             	and    $0x1,%eax
80108411:	85 c0                	test   %eax,%eax
80108413:	75 0d                	jne    80108422 <copyuvm+0x6d>
      panic("copyuvm: page not present");
80108415:	83 ec 0c             	sub    $0xc,%esp
80108418:	68 04 8c 10 80       	push   $0x80108c04
8010841d:	e8 59 81 ff ff       	call   8010057b <panic>
    pa = PTE_ADDR(*pte);
80108422:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108425:	8b 00                	mov    (%eax),%eax
80108427:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010842c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if((mem = kalloc()) == 0)
8010842f:	e8 a7 a7 ff ff       	call   80102bdb <kalloc>
80108434:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108437:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010843b:	74 66                	je     801084a3 <copyuvm+0xee>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010843d:	83 ec 0c             	sub    $0xc,%esp
80108440:	ff 75 e8             	pushl  -0x18(%ebp)
80108443:	e8 ae f3 ff ff       	call   801077f6 <p2v>
80108448:	83 c4 10             	add    $0x10,%esp
8010844b:	83 ec 04             	sub    $0x4,%esp
8010844e:	68 00 10 00 00       	push   $0x1000
80108453:	50                   	push   %eax
80108454:	ff 75 e4             	pushl  -0x1c(%ebp)
80108457:	e8 a1 ce ff ff       	call   801052fd <memmove>
8010845c:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
8010845f:	83 ec 0c             	sub    $0xc,%esp
80108462:	ff 75 e4             	pushl  -0x1c(%ebp)
80108465:	e8 7f f3 ff ff       	call   801077e9 <v2p>
8010846a:	83 c4 10             	add    $0x10,%esp
8010846d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108470:	83 ec 0c             	sub    $0xc,%esp
80108473:	6a 06                	push   $0x6
80108475:	50                   	push   %eax
80108476:	68 00 10 00 00       	push   $0x1000
8010847b:	52                   	push   %edx
8010847c:	ff 75 f0             	pushl  -0x10(%ebp)
8010847f:	e8 94 f8 ff ff       	call   80107d18 <mappages>
80108484:	83 c4 20             	add    $0x20,%esp
80108487:	85 c0                	test   %eax,%eax
80108489:	78 1b                	js     801084a6 <copyuvm+0xf1>
  for(i = 0; i < sz; i += PGSIZE){
8010848b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108495:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108498:	0f 82 41 ff ff ff    	jb     801083df <copyuvm+0x2a>
      goto bad;
  }
  return d;
8010849e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084a1:	eb 17                	jmp    801084ba <copyuvm+0x105>
      goto bad;
801084a3:	90                   	nop
801084a4:	eb 01                	jmp    801084a7 <copyuvm+0xf2>
      goto bad;
801084a6:	90                   	nop

bad:
  freevm(d);
801084a7:	83 ec 0c             	sub    $0xc,%esp
801084aa:	ff 75 f0             	pushl  -0x10(%ebp)
801084ad:	e8 22 fe ff ff       	call   801082d4 <freevm>
801084b2:	83 c4 10             	add    $0x10,%esp
  return 0;
801084b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801084ba:	c9                   	leave  
801084bb:	c3                   	ret    

801084bc <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801084bc:	55                   	push   %ebp
801084bd:	89 e5                	mov    %esp,%ebp
801084bf:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801084c2:	83 ec 04             	sub    $0x4,%esp
801084c5:	6a 00                	push   $0x0
801084c7:	ff 75 0c             	pushl  0xc(%ebp)
801084ca:	ff 75 08             	pushl  0x8(%ebp)
801084cd:	e8 a6 f7 ff ff       	call   80107c78 <walkpgdir>
801084d2:	83 c4 10             	add    $0x10,%esp
801084d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801084d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084db:	8b 00                	mov    (%eax),%eax
801084dd:	83 e0 01             	and    $0x1,%eax
801084e0:	85 c0                	test   %eax,%eax
801084e2:	75 07                	jne    801084eb <uva2ka+0x2f>
    return 0;
801084e4:	b8 00 00 00 00       	mov    $0x0,%eax
801084e9:	eb 2a                	jmp    80108515 <uva2ka+0x59>
  if((*pte & PTE_U) == 0)
801084eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ee:	8b 00                	mov    (%eax),%eax
801084f0:	83 e0 04             	and    $0x4,%eax
801084f3:	85 c0                	test   %eax,%eax
801084f5:	75 07                	jne    801084fe <uva2ka+0x42>
    return 0;
801084f7:	b8 00 00 00 00       	mov    $0x0,%eax
801084fc:	eb 17                	jmp    80108515 <uva2ka+0x59>
  return (char*)p2v(PTE_ADDR(*pte));
801084fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108501:	8b 00                	mov    (%eax),%eax
80108503:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108508:	83 ec 0c             	sub    $0xc,%esp
8010850b:	50                   	push   %eax
8010850c:	e8 e5 f2 ff ff       	call   801077f6 <p2v>
80108511:	83 c4 10             	add    $0x10,%esp
80108514:	90                   	nop
}
80108515:	c9                   	leave  
80108516:	c3                   	ret    

80108517 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108517:	55                   	push   %ebp
80108518:	89 e5                	mov    %esp,%ebp
8010851a:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010851d:	8b 45 10             	mov    0x10(%ebp),%eax
80108520:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108523:	eb 7f                	jmp    801085a4 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108525:	8b 45 0c             	mov    0xc(%ebp),%eax
80108528:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010852d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108530:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108533:	83 ec 08             	sub    $0x8,%esp
80108536:	50                   	push   %eax
80108537:	ff 75 08             	pushl  0x8(%ebp)
8010853a:	e8 7d ff ff ff       	call   801084bc <uva2ka>
8010853f:	83 c4 10             	add    $0x10,%esp
80108542:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108545:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108549:	75 07                	jne    80108552 <copyout+0x3b>
      return -1;
8010854b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108550:	eb 61                	jmp    801085b3 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108552:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108555:	2b 45 0c             	sub    0xc(%ebp),%eax
80108558:	05 00 10 00 00       	add    $0x1000,%eax
8010855d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108560:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108563:	3b 45 14             	cmp    0x14(%ebp),%eax
80108566:	76 06                	jbe    8010856e <copyout+0x57>
      n = len;
80108568:	8b 45 14             	mov    0x14(%ebp),%eax
8010856b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010856e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108571:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108574:	89 c2                	mov    %eax,%edx
80108576:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108579:	01 d0                	add    %edx,%eax
8010857b:	83 ec 04             	sub    $0x4,%esp
8010857e:	ff 75 f0             	pushl  -0x10(%ebp)
80108581:	ff 75 f4             	pushl  -0xc(%ebp)
80108584:	50                   	push   %eax
80108585:	e8 73 cd ff ff       	call   801052fd <memmove>
8010858a:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010858d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108590:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108593:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108596:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108599:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010859c:	05 00 10 00 00       	add    $0x1000,%eax
801085a1:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
801085a4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801085a8:	0f 85 77 ff ff ff    	jne    80108525 <copyout+0xe>
  }
  return 0;
801085ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
801085b3:	c9                   	leave  
801085b4:	c3                   	ret    
