
kernel:     file format elf32-i386


Disassembly of section .text:

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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 32 10 80       	mov    $0x80103210,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 77 10 80       	push   $0x801077c0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 b5 47 00 00       	call   80104810 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 77 10 80       	push   $0x801077c7
80100097:	50                   	push   %eax
80100098:	e8 43 46 00 00       	call   801046e0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 87 48 00 00       	call   80104970 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 b9 48 00 00       	call   80104a20 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 45 00 00       	call   80104720 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 1d 23 00 00       	call   801024a0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 77 10 80       	push   $0x801077ce
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 0d 46 00 00       	call   801047c0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 d7 22 00 00       	jmp    801024a0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 77 10 80       	push   $0x801077df
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 cc 45 00 00       	call   801047c0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 45 00 00       	call   80104780 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 60 47 00 00       	call   80104970 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 bf 47 00 00       	jmp    80104a20 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 77 10 80       	push   $0x801077e6
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 7b 18 00 00       	call   80101b00 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 df 46 00 00       	call   80104970 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002a6:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 a0 0f 11 80       	push   $0x80110fa0
801002bd:	e8 6e 3e 00 00       	call   80104130 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 89 38 00 00       	call   80103b60 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 35 47 00 00       	call   80104a20 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 2d 17 00 00       	call   80101a20 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 b5 10 80       	push   $0x8010b520
80100346:	e8 d5 46 00 00       	call   80104a20 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 cd 16 00 00       	call   80101a20 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 12 27 00 00       	call   80102aa0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 ed 77 10 80       	push   $0x801077ed
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 fa 7d 10 80 	movl   $0x80107dfa,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 73 44 00 00       	call   80104830 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 01 78 10 80       	push   $0x80107801
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 f1 5e 00 00       	call   80106310 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 38 5e 00 00       	call   80106310 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 2c 5e 00 00       	call   80106310 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 20 5e 00 00       	call   80106310 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 07 46 00 00       	call   80104b20 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 42 45 00 00       	call   80104a70 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 05 78 10 80       	push   $0x80107805
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 30 78 10 80 	movzbl -0x7fef87d0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 ec 14 00 00       	call   80101b00 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 50 43 00 00       	call   80104970 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 d4 43 00 00       	call   80104a20 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 cb 13 00 00       	call   80101a20 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 b5 10 80       	push   $0x8010b520
8010070d:	e8 0e 43 00 00       	call   80104a20 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 18 78 10 80       	mov    $0x80107818,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 b5 10 80       	push   $0x8010b520
801007c8:	e8 a3 41 00 00       	call   80104970 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 1f 78 10 80       	push   $0x8010781f
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 68 41 00 00       	call   80104970 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100836:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 b3 41 00 00       	call   80104a20 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
801008f1:	68 a0 0f 11 80       	push   $0x80110fa0
801008f6:	e8 f5 39 00 00       	call   801042f0 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010090d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100934:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 64 3a 00 00       	jmp    801043e0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 28 78 10 80       	push   $0x80107828
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 5b 3e 00 00       	call   80104810 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 72 1c 00 00       	call   80102650 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 5f 31 00 00       	call   80103b60 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 f4 24 00 00       	call   80102f00 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 59 18 00 00       	call   80102270 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 f3 0f 00 00       	call   80101a20 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 c2 12 00 00       	call   80101d00 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 61 12 00 00       	call   80101cb0 <iunlockput>
    end_op();
80100a4f:	e8 1c 25 00 00       	call   80102f70 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 27 6a 00 00       	call   801074a0 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 33 12 00 00       	call   80101d00 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 e7 67 00 00       	call   801072f0 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 f1 66 00 00       	call   80107230 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 c2 68 00 00       	call   80107420 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 41 11 00 00       	call   80101cb0 <iunlockput>
  end_op();
80100b6f:	e8 fc 23 00 00       	call   80102f70 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 56 67 00 00       	call   801072f0 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 6f 68 00 00       	call   80107420 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 ad 23 00 00       	call   80102f70 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 41 78 10 80       	push   $0x80107841
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 4a 69 00 00       	call   80107540 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 7e 40 00 00       	call   80104cb0 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 6b 40 00 00       	call   80104cb0 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 5a 6a 00 00       	call   801076b0 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 f0 69 00 00       	call   801076b0 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 6c             	add    $0x6c,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 6b 3f 00 00       	call   80104c70 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 18             	mov    0x18(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 18             	mov    0x18(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 6f 63 00 00       	call   801070a0 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 e7 66 00 00       	call   80107420 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100d50 <exec2>:
  return -1;
}

int
exec2(char *path, char **argv,int stacksize)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	57                   	push   %edi
80100d54:	56                   	push   %esi
80100d55:	53                   	push   %ebx
80100d56:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100d5c:	e8 ff 2d 00 00       	call   80103b60 <myproc>
80100d61:	89 c7                	mov    %eax,%edi

  begin_op();
80100d63:	e8 98 21 00 00       	call   80102f00 <begin_op>
  if(myproc()->mode==0)
80100d68:	e8 f3 2d 00 00       	call   80103b60 <myproc>
80100d6d:	8b 48 7c             	mov    0x7c(%eax),%ecx
80100d70:	85 c9                	test   %ecx,%ecx
80100d72:	0f 84 cd 00 00 00    	je     80100e45 <exec2+0xf5>
    return -1;
  if(stacksize<1 || stacksize>100)
80100d78:	8b 45 10             	mov    0x10(%ebp),%eax
80100d7b:	83 e8 01             	sub    $0x1,%eax
80100d7e:	83 f8 63             	cmp    $0x63,%eax
80100d81:	0f 87 be 00 00 00    	ja     80100e45 <exec2+0xf5>
    return -1;


  if((ip = namei(path)) == 0){
80100d87:	83 ec 0c             	sub    $0xc,%esp
80100d8a:	ff 75 08             	pushl  0x8(%ebp)
80100d8d:	e8 de 14 00 00       	call   80102270 <namei>
80100d92:	83 c4 10             	add    $0x10,%esp
80100d95:	85 c0                	test   %eax,%eax
80100d97:	89 c3                	mov    %eax,%ebx
80100d99:	0f 84 c7 01 00 00    	je     80100f66 <exec2+0x216>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100d9f:	83 ec 0c             	sub    $0xc,%esp
80100da2:	50                   	push   %eax
80100da3:	e8 78 0c 00 00       	call   80101a20 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100da8:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100dae:	6a 34                	push   $0x34
80100db0:	6a 00                	push   $0x0
80100db2:	50                   	push   %eax
80100db3:	53                   	push   %ebx
80100db4:	e8 47 0f 00 00       	call   80101d00 <readi>
80100db9:	83 c4 20             	add    $0x20,%esp
80100dbc:	83 f8 34             	cmp    $0x34,%eax
80100dbf:	0f 84 93 00 00 00    	je     80100e58 <exec2+0x108>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100dc5:	83 ec 0c             	sub    $0xc,%esp
80100dc8:	53                   	push   %ebx
80100dc9:	e8 e2 0e 00 00       	call   80101cb0 <iunlockput>
    end_op();
80100dce:	e8 9d 21 00 00       	call   80102f70 <end_op>
80100dd3:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100dd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ddb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100dde:	5b                   	pop    %ebx
80100ddf:	5e                   	pop    %esi
80100de0:	5f                   	pop    %edi
80100de1:	5d                   	pop    %ebp
80100de2:	c3                   	ret    
80100de3:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	53                   	push   %ebx
80100ded:	e8 be 0e 00 00       	call   80101cb0 <iunlockput>
  end_op();
80100df2:	e8 79 21 00 00       	call   80102f70 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + (PGSIZE * (stacksize+1)))) == 0)
80100df7:	8b 55 10             	mov    0x10(%ebp),%edx
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100dfa:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + (PGSIZE * (stacksize+1)))) == 0)
80100e00:	83 c4 0c             	add    $0xc,%esp
80100e03:	8d 5a 01             	lea    0x1(%edx),%ebx
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100e06:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + (PGSIZE * (stacksize+1)))) == 0)
80100e10:	c1 e3 0c             	shl    $0xc,%ebx
80100e13:	8d 14 18             	lea    (%eax,%ebx,1),%edx
80100e16:	52                   	push   %edx
80100e17:	50                   	push   %eax
80100e18:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e1e:	e8 cd 64 00 00       	call   801072f0 <allocuvm>
80100e23:	83 c4 10             	add    $0x10,%esp
80100e26:	85 c0                	test   %eax,%eax
80100e28:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100e2e:	0f 85 4c 01 00 00    	jne    80100f80 <exec2+0x230>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100e34:	83 ec 0c             	sub    $0xc,%esp
80100e37:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e3d:	e8 de 65 00 00       	call   80107420 <freevm>
80100e42:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100e45:	8d 65 f4             	lea    -0xc(%ebp),%esp


  if((ip = namei(path)) == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
80100e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100e4d:	5b                   	pop    %ebx
80100e4e:	5e                   	pop    %esi
80100e4f:	5f                   	pop    %edi
80100e50:	5d                   	pop    %ebp
80100e51:	c3                   	ret    
80100e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100e58:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100e5f:	45 4c 46 
80100e62:	0f 85 5d ff ff ff    	jne    80100dc5 <exec2+0x75>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100e68:	e8 33 66 00 00       	call   801074a0 <setupkvm>
80100e6d:	85 c0                	test   %eax,%eax
80100e6f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100e75:	0f 84 4a ff ff ff    	je     80100dc5 <exec2+0x75>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e7b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100e82:	00 
80100e83:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100e89:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e90:	00 00 00 
80100e93:	0f 84 50 ff ff ff    	je     80100de9 <exec2+0x99>
80100e99:	31 c0                	xor    %eax,%eax
80100e9b:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100ea1:	89 c7                	mov    %eax,%edi
80100ea3:	eb 18                	jmp    80100ebd <exec2+0x16d>
80100ea5:	8d 76 00             	lea    0x0(%esi),%esi
80100ea8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100eaf:	83 c7 01             	add    $0x1,%edi
80100eb2:	83 c6 20             	add    $0x20,%esi
80100eb5:	39 f8                	cmp    %edi,%eax
80100eb7:	0f 8e 26 ff ff ff    	jle    80100de3 <exec2+0x93>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ebd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ec3:	6a 20                	push   $0x20
80100ec5:	56                   	push   %esi
80100ec6:	50                   	push   %eax
80100ec7:	53                   	push   %ebx
80100ec8:	e8 33 0e 00 00       	call   80101d00 <readi>
80100ecd:	83 c4 10             	add    $0x10,%esp
80100ed0:	83 f8 20             	cmp    $0x20,%eax
80100ed3:	75 7b                	jne    80100f50 <exec2+0x200>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ed5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100edc:	75 ca                	jne    80100ea8 <exec2+0x158>
      continue;
    if(ph.memsz < ph.filesz)
80100ede:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ee4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100eea:	72 64                	jb     80100f50 <exec2+0x200>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100eec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ef2:	72 5c                	jb     80100f50 <exec2+0x200>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ef4:	83 ec 04             	sub    $0x4,%esp
80100ef7:	50                   	push   %eax
80100ef8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100efe:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f04:	e8 e7 63 00 00       	call   801072f0 <allocuvm>
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 c0                	test   %eax,%eax
80100f0e:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100f14:	74 3a                	je     80100f50 <exec2+0x200>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100f16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100f1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100f21:	75 2d                	jne    80100f50 <exec2+0x200>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100f23:	83 ec 0c             	sub    $0xc,%esp
80100f26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100f2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100f32:	53                   	push   %ebx
80100f33:	50                   	push   %eax
80100f34:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f3a:	e8 f1 62 00 00       	call   80107230 <loaduvm>
80100f3f:	83 c4 20             	add    $0x20,%esp
80100f42:	85 c0                	test   %eax,%eax
80100f44:	0f 89 5e ff ff ff    	jns    80100ea8 <exec2+0x158>
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100f50:	83 ec 0c             	sub    $0xc,%esp
80100f53:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f59:	e8 c2 64 00 00       	call   80107420 <freevm>
80100f5e:	83 c4 10             	add    $0x10,%esp
80100f61:	e9 5f fe ff ff       	jmp    80100dc5 <exec2+0x75>
  if(stacksize<1 || stacksize>100)
    return -1;


  if((ip = namei(path)) == 0){
    end_op();
80100f66:	e8 05 20 00 00       	call   80102f70 <end_op>
    cprintf("exec: fail\n");
80100f6b:	83 ec 0c             	sub    $0xc,%esp
80100f6e:	68 41 78 10 80       	push   $0x80107841
80100f73:	e8 e8 f6 ff ff       	call   80100660 <cprintf>
    return -1;
80100f78:	83 c4 10             	add    $0x10,%esp
80100f7b:	e9 c5 fe ff ff       	jmp    80100e45 <exec2+0xf5>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + (PGSIZE * (stacksize+1)))) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - (PGSIZE * (stacksize+1))));
80100f80:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100f86:	83 ec 08             	sub    $0x8,%esp
80100f89:	89 f0                	mov    %esi,%eax
80100f8b:	29 d8                	sub    %ebx,%eax
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f8d:	89 f3                	mov    %esi,%ebx
80100f8f:	31 f6                	xor    %esi,%esi
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + (PGSIZE * (stacksize+1)))) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - (PGSIZE * (stacksize+1))));
80100f91:	50                   	push   %eax
80100f92:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f98:	e8 a3 65 00 00       	call   80107540 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fa0:	83 c4 10             	add    $0x10,%esp
80100fa3:	8b 00                	mov    (%eax),%eax
80100fa5:	85 c0                	test   %eax,%eax
80100fa7:	0f 84 4f 01 00 00    	je     801010fc <exec2+0x3ac>
80100fad:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100fb3:	89 f7                	mov    %esi,%edi
80100fb5:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100fbb:	eb 0c                	jmp    80100fc9 <exec2+0x279>
80100fbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(argc >= MAXARG)
80100fc0:	83 ff 20             	cmp    $0x20,%edi
80100fc3:	0f 84 6b fe ff ff    	je     80100e34 <exec2+0xe4>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fc9:	83 ec 0c             	sub    $0xc,%esp
80100fcc:	50                   	push   %eax
80100fcd:	e8 de 3c 00 00       	call   80104cb0 <strlen>
80100fd2:	f7 d0                	not    %eax
80100fd4:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fd9:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fda:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fdd:	ff 34 b8             	pushl  (%eax,%edi,4)
80100fe0:	e8 cb 3c 00 00       	call   80104cb0 <strlen>
80100fe5:	83 c0 01             	add    $0x1,%eax
80100fe8:	50                   	push   %eax
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	ff 34 b8             	pushl  (%eax,%edi,4)
80100fef:	53                   	push   %ebx
80100ff0:	56                   	push   %esi
80100ff1:	e8 ba 66 00 00       	call   801076b0 <copyout>
80100ff6:	83 c4 20             	add    $0x20,%esp
80100ff9:	85 c0                	test   %eax,%eax
80100ffb:	0f 88 33 fe ff ff    	js     80100e34 <exec2+0xe4>
    goto bad;
  clearpteu(pgdir, (char*)(sz - (PGSIZE * (stacksize+1))));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101001:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80101004:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - (PGSIZE * (stacksize+1))));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
8010100b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
8010100e:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    goto bad;
  clearpteu(pgdir, (char*)(sz - (PGSIZE * (stacksize+1))));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101014:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101017:	85 c0                	test   %eax,%eax
80101019:	75 a5                	jne    80100fc0 <exec2+0x270>
8010101b:	89 fe                	mov    %edi,%esi
8010101d:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101023:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
8010102a:	89 da                	mov    %ebx,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
8010102c:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80101033:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80101037:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010103e:	ff ff ff 
  ustack[1] = argc;
80101041:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101047:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4; 
80101049:	83 c0 0c             	add    $0xc,%eax
8010104c:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010104e:	50                   	push   %eax
8010104f:	51                   	push   %ecx
80101050:	53                   	push   %ebx
80101051:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101057:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4; 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010105d:	e8 4e 66 00 00       	call   801076b0 <copyout>
80101062:	83 c4 10             	add    $0x10,%esp
80101065:	85 c0                	test   %eax,%eax
80101067:	0f 88 c7 fd ff ff    	js     80100e34 <exec2+0xe4>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
8010106d:	8b 45 08             	mov    0x8(%ebp),%eax
80101070:	0f b6 10             	movzbl (%eax),%edx
80101073:	84 d2                	test   %dl,%dl
80101075:	74 19                	je     80101090 <exec2+0x340>
80101077:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
8010107a:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4; 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
8010107d:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80101080:	89 c1                	mov    %eax,%ecx
80101082:	0f 45 4d 08          	cmovne 0x8(%ebp),%ecx
80101086:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4; 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101089:	84 d2                	test   %dl,%dl
    if(*s == '/')
      last = s+1;
8010108b:	89 4d 08             	mov    %ecx,0x8(%ebp)
  sp -= (3+argc+1) * 4; 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
8010108e:	75 ea                	jne    8010107a <exec2+0x32a>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101090:	50                   	push   %eax
80101091:	8d 47 6c             	lea    0x6c(%edi),%eax
80101094:	6a 10                	push   $0x10
80101096:	ff 75 08             	pushl  0x8(%ebp)
80101099:	50                   	push   %eax
8010109a:	e8 d1 3b 00 00       	call   80104c70 <safestrcpy>


  // Commit to the user image.
  oldpgdir = curproc->pgdir;
8010109f:	8b 47 04             	mov    0x4(%edi),%eax
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->mlimit=0;
  curproc->mode=0;
  curproc->tf->eip = elf.entry;  // main
801010a2:	8b 57 18             	mov    0x18(%edi),%edx

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->mlimit=0;
801010a5:	c7 87 80 00 00 00 00 	movl   $0x0,0x80(%edi)
801010ac:	00 00 00 
  curproc->mode=0;
801010af:	c7 47 7c 00 00 00 00 	movl   $0x0,0x7c(%edi)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));


  // Commit to the user image.
  oldpgdir = curproc->pgdir;
801010b6:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  curproc->pgdir = pgdir;
801010bc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
801010c2:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
801010c5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
801010cb:	89 07                	mov    %eax,(%edi)
  curproc->mlimit=0;
  curproc->mode=0;
  curproc->tf->eip = elf.entry;  // main
801010cd:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
801010d3:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
801010d6:	8b 57 18             	mov    0x18(%edi),%edx
801010d9:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(curproc);
801010dc:	89 3c 24             	mov    %edi,(%esp)
801010df:	e8 bc 5f 00 00       	call   801070a0 <switchuvm>
  freevm(oldpgdir);
801010e4:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
801010ea:	89 04 24             	mov    %eax,(%esp)
801010ed:	e8 2e 63 00 00       	call   80107420 <freevm>
  return 0;
801010f2:	83 c4 10             	add    $0x10,%esp
801010f5:	31 c0                	xor    %eax,%eax
801010f7:	e9 df fc ff ff       	jmp    80100ddb <exec2+0x8b>
    goto bad;
  clearpteu(pgdir, (char*)(sz - (PGSIZE * (stacksize+1))));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
801010fc:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80101102:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80101108:	e9 16 ff ff ff       	jmp    80101023 <exec2+0x2d3>
8010110d:	66 90                	xchg   %ax,%ax
8010110f:	90                   	nop

80101110 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101116:	68 4d 78 10 80       	push   $0x8010784d
8010111b:	68 c0 0f 11 80       	push   $0x80110fc0
80101120:	e8 eb 36 00 00       	call   80104810 <initlock>
}
80101125:	83 c4 10             	add    $0x10,%esp
80101128:	c9                   	leave  
80101129:	c3                   	ret    
8010112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101130 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101134:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80101139:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
8010113c:	68 c0 0f 11 80       	push   $0x80110fc0
80101141:	e8 2a 38 00 00       	call   80104970 <acquire>
80101146:	83 c4 10             	add    $0x10,%esp
80101149:	eb 10                	jmp    8010115b <filealloc+0x2b>
8010114b:	90                   	nop
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101150:	83 c3 18             	add    $0x18,%ebx
80101153:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80101159:	74 25                	je     80101180 <filealloc+0x50>
    if(f->ref == 0){
8010115b:	8b 43 04             	mov    0x4(%ebx),%eax
8010115e:	85 c0                	test   %eax,%eax
80101160:	75 ee                	jne    80101150 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101162:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80101165:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010116c:	68 c0 0f 11 80       	push   $0x80110fc0
80101171:	e8 aa 38 00 00       	call   80104a20 <release>
      return f;
80101176:	89 d8                	mov    %ebx,%eax
80101178:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
8010117b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010117e:	c9                   	leave  
8010117f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101180:	83 ec 0c             	sub    $0xc,%esp
80101183:	68 c0 0f 11 80       	push   $0x80110fc0
80101188:	e8 93 38 00 00       	call   80104a20 <release>
  return 0;
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	31 c0                	xor    %eax,%eax
}
80101192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101195:	c9                   	leave  
80101196:	c3                   	ret    
80101197:	89 f6                	mov    %esi,%esi
80101199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801011a0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	53                   	push   %ebx
801011a4:	83 ec 10             	sub    $0x10,%esp
801011a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801011aa:	68 c0 0f 11 80       	push   $0x80110fc0
801011af:	e8 bc 37 00 00       	call   80104970 <acquire>
  if(f->ref < 1)
801011b4:	8b 43 04             	mov    0x4(%ebx),%eax
801011b7:	83 c4 10             	add    $0x10,%esp
801011ba:	85 c0                	test   %eax,%eax
801011bc:	7e 1a                	jle    801011d8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801011be:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801011c1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
801011c4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801011c7:	68 c0 0f 11 80       	push   $0x80110fc0
801011cc:	e8 4f 38 00 00       	call   80104a20 <release>
  return f;
}
801011d1:	89 d8                	mov    %ebx,%eax
801011d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011d6:	c9                   	leave  
801011d7:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
801011d8:	83 ec 0c             	sub    $0xc,%esp
801011db:	68 54 78 10 80       	push   $0x80107854
801011e0:	e8 8b f1 ff ff       	call   80100370 <panic>
801011e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801011f0 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	57                   	push   %edi
801011f4:	56                   	push   %esi
801011f5:	53                   	push   %ebx
801011f6:	83 ec 28             	sub    $0x28,%esp
801011f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
801011fc:	68 c0 0f 11 80       	push   $0x80110fc0
80101201:	e8 6a 37 00 00       	call   80104970 <acquire>
  if(f->ref < 1)
80101206:	8b 47 04             	mov    0x4(%edi),%eax
80101209:	83 c4 10             	add    $0x10,%esp
8010120c:	85 c0                	test   %eax,%eax
8010120e:	0f 8e 9b 00 00 00    	jle    801012af <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101214:	83 e8 01             	sub    $0x1,%eax
80101217:	85 c0                	test   %eax,%eax
80101219:	89 47 04             	mov    %eax,0x4(%edi)
8010121c:	74 1a                	je     80101238 <fileclose+0x48>
    release(&ftable.lock);
8010121e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101225:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101228:	5b                   	pop    %ebx
80101229:	5e                   	pop    %esi
8010122a:	5f                   	pop    %edi
8010122b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
8010122c:	e9 ef 37 00 00       	jmp    80104a20 <release>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80101238:	0f b6 47 09          	movzbl 0x9(%edi),%eax
8010123c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
8010123e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101241:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80101244:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010124a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010124d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101250:	68 c0 0f 11 80       	push   $0x80110fc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101255:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101258:	e8 c3 37 00 00       	call   80104a20 <release>

  if(ff.type == FD_PIPE)
8010125d:	83 c4 10             	add    $0x10,%esp
80101260:	83 fb 01             	cmp    $0x1,%ebx
80101263:	74 13                	je     80101278 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101265:	83 fb 02             	cmp    $0x2,%ebx
80101268:	74 26                	je     80101290 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126d:	5b                   	pop    %ebx
8010126e:	5e                   	pop    %esi
8010126f:	5f                   	pop    %edi
80101270:	5d                   	pop    %ebp
80101271:	c3                   	ret    
80101272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80101278:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010127c:	83 ec 08             	sub    $0x8,%esp
8010127f:	53                   	push   %ebx
80101280:	56                   	push   %esi
80101281:	e8 1a 24 00 00       	call   801036a0 <pipeclose>
80101286:	83 c4 10             	add    $0x10,%esp
80101289:	eb df                	jmp    8010126a <fileclose+0x7a>
8010128b:	90                   	nop
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80101290:	e8 6b 1c 00 00       	call   80102f00 <begin_op>
    iput(ff.ip);
80101295:	83 ec 0c             	sub    $0xc,%esp
80101298:	ff 75 e0             	pushl  -0x20(%ebp)
8010129b:	e8 b0 08 00 00       	call   80101b50 <iput>
    end_op();
801012a0:	83 c4 10             	add    $0x10,%esp
  }
}
801012a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012a6:	5b                   	pop    %ebx
801012a7:	5e                   	pop    %esi
801012a8:	5f                   	pop    %edi
801012a9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
801012aa:	e9 c1 1c 00 00       	jmp    80102f70 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
801012af:	83 ec 0c             	sub    $0xc,%esp
801012b2:	68 5c 78 10 80       	push   $0x8010785c
801012b7:	e8 b4 f0 ff ff       	call   80100370 <panic>
801012bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012c0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	53                   	push   %ebx
801012c4:	83 ec 04             	sub    $0x4,%esp
801012c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801012ca:	83 3b 02             	cmpl   $0x2,(%ebx)
801012cd:	75 31                	jne    80101300 <filestat+0x40>
    ilock(f->ip);
801012cf:	83 ec 0c             	sub    $0xc,%esp
801012d2:	ff 73 10             	pushl  0x10(%ebx)
801012d5:	e8 46 07 00 00       	call   80101a20 <ilock>
    stati(f->ip, st);
801012da:	58                   	pop    %eax
801012db:	5a                   	pop    %edx
801012dc:	ff 75 0c             	pushl  0xc(%ebp)
801012df:	ff 73 10             	pushl  0x10(%ebx)
801012e2:	e8 e9 09 00 00       	call   80101cd0 <stati>
    iunlock(f->ip);
801012e7:	59                   	pop    %ecx
801012e8:	ff 73 10             	pushl  0x10(%ebx)
801012eb:	e8 10 08 00 00       	call   80101b00 <iunlock>
    return 0;
801012f0:	83 c4 10             	add    $0x10,%esp
801012f3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
801012f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012f8:	c9                   	leave  
801012f9:	c3                   	ret    
801012fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80101300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101308:	c9                   	leave  
80101309:	c3                   	ret    
8010130a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101310 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	57                   	push   %edi
80101314:	56                   	push   %esi
80101315:	53                   	push   %ebx
80101316:	83 ec 0c             	sub    $0xc,%esp
80101319:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010131c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010131f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101322:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101326:	74 60                	je     80101388 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101328:	8b 03                	mov    (%ebx),%eax
8010132a:	83 f8 01             	cmp    $0x1,%eax
8010132d:	74 41                	je     80101370 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010132f:	83 f8 02             	cmp    $0x2,%eax
80101332:	75 5b                	jne    8010138f <fileread+0x7f>
    ilock(f->ip);
80101334:	83 ec 0c             	sub    $0xc,%esp
80101337:	ff 73 10             	pushl  0x10(%ebx)
8010133a:	e8 e1 06 00 00       	call   80101a20 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010133f:	57                   	push   %edi
80101340:	ff 73 14             	pushl  0x14(%ebx)
80101343:	56                   	push   %esi
80101344:	ff 73 10             	pushl  0x10(%ebx)
80101347:	e8 b4 09 00 00       	call   80101d00 <readi>
8010134c:	83 c4 20             	add    $0x20,%esp
8010134f:	85 c0                	test   %eax,%eax
80101351:	89 c6                	mov    %eax,%esi
80101353:	7e 03                	jle    80101358 <fileread+0x48>
      f->off += r;
80101355:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101358:	83 ec 0c             	sub    $0xc,%esp
8010135b:	ff 73 10             	pushl  0x10(%ebx)
8010135e:	e8 9d 07 00 00       	call   80101b00 <iunlock>
    return r;
80101363:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101366:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101368:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010136b:	5b                   	pop    %ebx
8010136c:	5e                   	pop    %esi
8010136d:	5f                   	pop    %edi
8010136e:	5d                   	pop    %ebp
8010136f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80101370:	8b 43 0c             	mov    0xc(%ebx),%eax
80101373:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101376:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101379:	5b                   	pop    %ebx
8010137a:	5e                   	pop    %esi
8010137b:	5f                   	pop    %edi
8010137c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
8010137d:	e9 be 24 00 00       	jmp    80103840 <piperead>
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80101388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010138d:	eb d9                	jmp    80101368 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
8010138f:	83 ec 0c             	sub    $0xc,%esp
80101392:	68 66 78 10 80       	push   $0x80107866
80101397:	e8 d4 ef ff ff       	call   80100370 <panic>
8010139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	56                   	push   %esi
801013a5:	53                   	push   %ebx
801013a6:	83 ec 1c             	sub    $0x1c,%esp
801013a9:	8b 75 08             	mov    0x8(%ebp),%esi
801013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801013af:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801013b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801013b6:	8b 45 10             	mov    0x10(%ebp),%eax
801013b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
801013bc:	0f 84 aa 00 00 00    	je     8010146c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801013c2:	8b 06                	mov    (%esi),%eax
801013c4:	83 f8 01             	cmp    $0x1,%eax
801013c7:	0f 84 c2 00 00 00    	je     8010148f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013cd:	83 f8 02             	cmp    $0x2,%eax
801013d0:	0f 85 d8 00 00 00    	jne    801014ae <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801013d9:	31 ff                	xor    %edi,%edi
801013db:	85 c0                	test   %eax,%eax
801013dd:	7f 34                	jg     80101413 <filewrite+0x73>
801013df:	e9 9c 00 00 00       	jmp    80101480 <filewrite+0xe0>
801013e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801013e8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801013eb:	83 ec 0c             	sub    $0xc,%esp
801013ee:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801013f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801013f4:	e8 07 07 00 00       	call   80101b00 <iunlock>
      end_op();
801013f9:	e8 72 1b 00 00       	call   80102f70 <end_op>
801013fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101401:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101404:	39 d8                	cmp    %ebx,%eax
80101406:	0f 85 95 00 00 00    	jne    801014a1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010140c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010140e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101411:	7e 6d                	jle    80101480 <filewrite+0xe0>
      int n1 = n - i;
80101413:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101416:	b8 00 06 00 00       	mov    $0x600,%eax
8010141b:	29 fb                	sub    %edi,%ebx
8010141d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101423:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101426:	e8 d5 1a 00 00       	call   80102f00 <begin_op>
      ilock(f->ip);
8010142b:	83 ec 0c             	sub    $0xc,%esp
8010142e:	ff 76 10             	pushl  0x10(%esi)
80101431:	e8 ea 05 00 00       	call   80101a20 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101436:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101439:	53                   	push   %ebx
8010143a:	ff 76 14             	pushl  0x14(%esi)
8010143d:	01 f8                	add    %edi,%eax
8010143f:	50                   	push   %eax
80101440:	ff 76 10             	pushl  0x10(%esi)
80101443:	e8 b8 09 00 00       	call   80101e00 <writei>
80101448:	83 c4 20             	add    $0x20,%esp
8010144b:	85 c0                	test   %eax,%eax
8010144d:	7f 99                	jg     801013e8 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010144f:	83 ec 0c             	sub    $0xc,%esp
80101452:	ff 76 10             	pushl  0x10(%esi)
80101455:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101458:	e8 a3 06 00 00       	call   80101b00 <iunlock>
      end_op();
8010145d:	e8 0e 1b 00 00       	call   80102f70 <end_op>

      if(r < 0)
80101462:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101465:	83 c4 10             	add    $0x10,%esp
80101468:	85 c0                	test   %eax,%eax
8010146a:	74 98                	je     80101404 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010146c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010146f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101474:	5b                   	pop    %ebx
80101475:	5e                   	pop    %esi
80101476:	5f                   	pop    %edi
80101477:	5d                   	pop    %ebp
80101478:	c3                   	ret    
80101479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101480:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101483:	75 e7                	jne    8010146c <filewrite+0xcc>
  }
  panic("filewrite");
}
80101485:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101488:	89 f8                	mov    %edi,%eax
8010148a:	5b                   	pop    %ebx
8010148b:	5e                   	pop    %esi
8010148c:	5f                   	pop    %edi
8010148d:	5d                   	pop    %ebp
8010148e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010148f:	8b 46 0c             	mov    0xc(%esi),%eax
80101492:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101495:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101498:	5b                   	pop    %ebx
80101499:	5e                   	pop    %esi
8010149a:	5f                   	pop    %edi
8010149b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010149c:	e9 9f 22 00 00       	jmp    80103740 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801014a1:	83 ec 0c             	sub    $0xc,%esp
801014a4:	68 6f 78 10 80       	push   $0x8010786f
801014a9:	e8 c2 ee ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801014ae:	83 ec 0c             	sub    $0xc,%esp
801014b1:	68 75 78 10 80       	push   $0x80107875
801014b6:	e8 b5 ee ff ff       	call   80100370 <panic>
801014bb:	66 90                	xchg   %ax,%ax
801014bd:	66 90                	xchg   %ax,%ax
801014bf:	90                   	nop

801014c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	56                   	push   %esi
801014c4:	53                   	push   %ebx
801014c5:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801014c7:	c1 ea 0c             	shr    $0xc,%edx
801014ca:	03 15 d8 19 11 80    	add    0x801119d8,%edx
801014d0:	83 ec 08             	sub    $0x8,%esp
801014d3:	52                   	push   %edx
801014d4:	50                   	push   %eax
801014d5:	e8 f6 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801014da:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014dc:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801014e2:	ba 01 00 00 00       	mov    $0x1,%edx
801014e7:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ea:	c1 fb 03             	sar    $0x3,%ebx
801014ed:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801014f0:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014f2:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014f7:	85 d1                	test   %edx,%ecx
801014f9:	74 27                	je     80101522 <bfree+0x62>
801014fb:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801014fd:	f7 d2                	not    %edx
801014ff:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101501:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101504:	21 d0                	and    %edx,%eax
80101506:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010150a:	56                   	push   %esi
8010150b:	e8 d0 1b 00 00       	call   801030e0 <log_write>
  brelse(bp);
80101510:	89 34 24             	mov    %esi,(%esp)
80101513:	e8 c8 ec ff ff       	call   801001e0 <brelse>
}
80101518:	83 c4 10             	add    $0x10,%esp
8010151b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010151e:	5b                   	pop    %ebx
8010151f:	5e                   	pop    %esi
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101522:	83 ec 0c             	sub    $0xc,%esp
80101525:	68 7f 78 10 80       	push   $0x8010787f
8010152a:	e8 41 ee ff ff       	call   80100370 <panic>
8010152f:	90                   	nop

80101530 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101539:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010153f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101542:	85 c9                	test   %ecx,%ecx
80101544:	0f 84 85 00 00 00    	je     801015cf <balloc+0x9f>
8010154a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101551:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101554:	83 ec 08             	sub    $0x8,%esp
80101557:	89 f0                	mov    %esi,%eax
80101559:	c1 f8 0c             	sar    $0xc,%eax
8010155c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101562:	50                   	push   %eax
80101563:	ff 75 d8             	pushl  -0x28(%ebp)
80101566:	e8 65 eb ff ff       	call   801000d0 <bread>
8010156b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010156e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101573:	83 c4 10             	add    $0x10,%esp
80101576:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101579:	31 c0                	xor    %eax,%eax
8010157b:	eb 2d                	jmp    801015aa <balloc+0x7a>
8010157d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101580:	89 c1                	mov    %eax,%ecx
80101582:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101587:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010158a:	83 e1 07             	and    $0x7,%ecx
8010158d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010158f:	89 c1                	mov    %eax,%ecx
80101591:	c1 f9 03             	sar    $0x3,%ecx
80101594:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101599:	85 d7                	test   %edx,%edi
8010159b:	74 43                	je     801015e0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010159d:	83 c0 01             	add    $0x1,%eax
801015a0:	83 c6 01             	add    $0x1,%esi
801015a3:	3d 00 10 00 00       	cmp    $0x1000,%eax
801015a8:	74 05                	je     801015af <balloc+0x7f>
801015aa:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801015ad:	72 d1                	jb     80101580 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015af:	83 ec 0c             	sub    $0xc,%esp
801015b2:	ff 75 e4             	pushl  -0x1c(%ebp)
801015b5:	e8 26 ec ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015ba:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801015c1:	83 c4 10             	add    $0x10,%esp
801015c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801015c7:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801015cd:	77 82                	ja     80101551 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801015cf:	83 ec 0c             	sub    $0xc,%esp
801015d2:	68 92 78 10 80       	push   $0x80107892
801015d7:	e8 94 ed ff ff       	call   80100370 <panic>
801015dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801015e0:	09 fa                	or     %edi,%edx
801015e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801015e5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801015e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801015ec:	57                   	push   %edi
801015ed:	e8 ee 1a 00 00       	call   801030e0 <log_write>
        brelse(bp);
801015f2:	89 3c 24             	mov    %edi,(%esp)
801015f5:	e8 e6 eb ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801015fa:	58                   	pop    %eax
801015fb:	5a                   	pop    %edx
801015fc:	56                   	push   %esi
801015fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101600:	e8 cb ea ff ff       	call   801000d0 <bread>
80101605:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101607:	8d 40 5c             	lea    0x5c(%eax),%eax
8010160a:	83 c4 0c             	add    $0xc,%esp
8010160d:	68 00 02 00 00       	push   $0x200
80101612:	6a 00                	push   $0x0
80101614:	50                   	push   %eax
80101615:	e8 56 34 00 00       	call   80104a70 <memset>
  log_write(bp);
8010161a:	89 1c 24             	mov    %ebx,(%esp)
8010161d:	e8 be 1a 00 00       	call   801030e0 <log_write>
  brelse(bp);
80101622:	89 1c 24             	mov    %ebx,(%esp)
80101625:	e8 b6 eb ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010162a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010162d:	89 f0                	mov    %esi,%eax
8010162f:	5b                   	pop    %ebx
80101630:	5e                   	pop    %esi
80101631:	5f                   	pop    %edi
80101632:	5d                   	pop    %ebp
80101633:	c3                   	ret    
80101634:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010163a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101640 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	57                   	push   %edi
80101644:	56                   	push   %esi
80101645:	53                   	push   %ebx
80101646:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101648:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010164a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010164f:	83 ec 28             	sub    $0x28,%esp
80101652:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101655:	68 e0 19 11 80       	push   $0x801119e0
8010165a:	e8 11 33 00 00       	call   80104970 <acquire>
8010165f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101662:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101665:	eb 1b                	jmp    80101682 <iget+0x42>
80101667:	89 f6                	mov    %esi,%esi
80101669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101670:	85 f6                	test   %esi,%esi
80101672:	74 44                	je     801016b8 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101674:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010167a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101680:	74 4e                	je     801016d0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101682:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101685:	85 c9                	test   %ecx,%ecx
80101687:	7e e7                	jle    80101670 <iget+0x30>
80101689:	39 3b                	cmp    %edi,(%ebx)
8010168b:	75 e3                	jne    80101670 <iget+0x30>
8010168d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101690:	75 de                	jne    80101670 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101692:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101695:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101698:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010169a:	68 e0 19 11 80       	push   $0x801119e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010169f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801016a2:	e8 79 33 00 00       	call   80104a20 <release>
      return ip;
801016a7:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801016aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ad:	89 f0                	mov    %esi,%eax
801016af:	5b                   	pop    %ebx
801016b0:	5e                   	pop    %esi
801016b1:	5f                   	pop    %edi
801016b2:	5d                   	pop    %ebp
801016b3:	c3                   	ret    
801016b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801016b8:	85 c9                	test   %ecx,%ecx
801016ba:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016bd:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016c3:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801016c9:	75 b7                	jne    80101682 <iget+0x42>
801016cb:	90                   	nop
801016cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801016d0:	85 f6                	test   %esi,%esi
801016d2:	74 2d                	je     80101701 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801016d4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801016d7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801016d9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801016dc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801016e3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801016ea:	68 e0 19 11 80       	push   $0x801119e0
801016ef:	e8 2c 33 00 00       	call   80104a20 <release>

  return ip;
801016f4:	83 c4 10             	add    $0x10,%esp
}
801016f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016fa:	89 f0                	mov    %esi,%eax
801016fc:	5b                   	pop    %ebx
801016fd:	5e                   	pop    %esi
801016fe:	5f                   	pop    %edi
801016ff:	5d                   	pop    %ebp
80101700:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101701:	83 ec 0c             	sub    $0xc,%esp
80101704:	68 a8 78 10 80       	push   $0x801078a8
80101709:	e8 62 ec ff ff       	call   80100370 <panic>
8010170e:	66 90                	xchg   %ax,%ax

80101710 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	57                   	push   %edi
80101714:	56                   	push   %esi
80101715:	53                   	push   %ebx
80101716:	89 c6                	mov    %eax,%esi
80101718:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010171b:	83 fa 0b             	cmp    $0xb,%edx
8010171e:	77 18                	ja     80101738 <bmap+0x28>
80101720:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101723:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101726:	85 c0                	test   %eax,%eax
80101728:	74 76                	je     801017a0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010172a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010172d:	5b                   	pop    %ebx
8010172e:	5e                   	pop    %esi
8010172f:	5f                   	pop    %edi
80101730:	5d                   	pop    %ebp
80101731:	c3                   	ret    
80101732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101738:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010173b:	83 fb 7f             	cmp    $0x7f,%ebx
8010173e:	0f 87 83 00 00 00    	ja     801017c7 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101744:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010174a:	85 c0                	test   %eax,%eax
8010174c:	74 6a                	je     801017b8 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010174e:	83 ec 08             	sub    $0x8,%esp
80101751:	50                   	push   %eax
80101752:	ff 36                	pushl  (%esi)
80101754:	e8 77 e9 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101759:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010175d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101760:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101762:	8b 1a                	mov    (%edx),%ebx
80101764:	85 db                	test   %ebx,%ebx
80101766:	75 1d                	jne    80101785 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101768:	8b 06                	mov    (%esi),%eax
8010176a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010176d:	e8 be fd ff ff       	call   80101530 <balloc>
80101772:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101775:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101778:	89 c3                	mov    %eax,%ebx
8010177a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010177c:	57                   	push   %edi
8010177d:	e8 5e 19 00 00       	call   801030e0 <log_write>
80101782:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101785:	83 ec 0c             	sub    $0xc,%esp
80101788:	57                   	push   %edi
80101789:	e8 52 ea ff ff       	call   801001e0 <brelse>
8010178e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101791:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101794:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101796:	5b                   	pop    %ebx
80101797:	5e                   	pop    %esi
80101798:	5f                   	pop    %edi
80101799:	5d                   	pop    %ebp
8010179a:	c3                   	ret    
8010179b:	90                   	nop
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801017a0:	8b 06                	mov    (%esi),%eax
801017a2:	e8 89 fd ff ff       	call   80101530 <balloc>
801017a7:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801017aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ad:	5b                   	pop    %ebx
801017ae:	5e                   	pop    %esi
801017af:	5f                   	pop    %edi
801017b0:	5d                   	pop    %ebp
801017b1:	c3                   	ret    
801017b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801017b8:	8b 06                	mov    (%esi),%eax
801017ba:	e8 71 fd ff ff       	call   80101530 <balloc>
801017bf:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801017c5:	eb 87                	jmp    8010174e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801017c7:	83 ec 0c             	sub    $0xc,%esp
801017ca:	68 b8 78 10 80       	push   $0x801078b8
801017cf:	e8 9c eb ff ff       	call   80100370 <panic>
801017d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017e0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801017e8:	83 ec 08             	sub    $0x8,%esp
801017eb:	6a 01                	push   $0x1
801017ed:	ff 75 08             	pushl  0x8(%ebp)
801017f0:	e8 db e8 ff ff       	call   801000d0 <bread>
801017f5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801017f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801017fa:	83 c4 0c             	add    $0xc,%esp
801017fd:	6a 1c                	push   $0x1c
801017ff:	50                   	push   %eax
80101800:	56                   	push   %esi
80101801:	e8 1a 33 00 00       	call   80104b20 <memmove>
  brelse(bp);
80101806:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101809:	83 c4 10             	add    $0x10,%esp
}
8010180c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010180f:	5b                   	pop    %ebx
80101810:	5e                   	pop    %esi
80101811:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101812:	e9 c9 e9 ff ff       	jmp    801001e0 <brelse>
80101817:	89 f6                	mov    %esi,%esi
80101819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101820 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	53                   	push   %ebx
80101824:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101829:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010182c:	68 cb 78 10 80       	push   $0x801078cb
80101831:	68 e0 19 11 80       	push   $0x801119e0
80101836:	e8 d5 2f 00 00       	call   80104810 <initlock>
8010183b:	83 c4 10             	add    $0x10,%esp
8010183e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101840:	83 ec 08             	sub    $0x8,%esp
80101843:	68 d2 78 10 80       	push   $0x801078d2
80101848:	53                   	push   %ebx
80101849:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010184f:	e8 8c 2e 00 00       	call   801046e0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101854:	83 c4 10             	add    $0x10,%esp
80101857:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
8010185d:	75 e1                	jne    80101840 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010185f:	83 ec 08             	sub    $0x8,%esp
80101862:	68 c0 19 11 80       	push   $0x801119c0
80101867:	ff 75 08             	pushl  0x8(%ebp)
8010186a:	e8 71 ff ff ff       	call   801017e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010186f:	ff 35 d8 19 11 80    	pushl  0x801119d8
80101875:	ff 35 d4 19 11 80    	pushl  0x801119d4
8010187b:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101881:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101887:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010188d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101893:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101899:	68 38 79 10 80       	push   $0x80107938
8010189e:	e8 bd ed ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801018a3:	83 c4 30             	add    $0x30,%esp
801018a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018a9:	c9                   	leave  
801018aa:	c3                   	ret    
801018ab:	90                   	nop
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018b0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018b9:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801018c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801018c3:	8b 75 08             	mov    0x8(%ebp),%esi
801018c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018c9:	0f 86 91 00 00 00    	jbe    80101960 <ialloc+0xb0>
801018cf:	bb 01 00 00 00       	mov    $0x1,%ebx
801018d4:	eb 21                	jmp    801018f7 <ialloc+0x47>
801018d6:	8d 76 00             	lea    0x0(%esi),%esi
801018d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801018e0:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018e3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801018e6:	57                   	push   %edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018ec:	83 c4 10             	add    $0x10,%esp
801018ef:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
801018f5:	76 69                	jbe    80101960 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801018f7:	89 d8                	mov    %ebx,%eax
801018f9:	83 ec 08             	sub    $0x8,%esp
801018fc:	c1 e8 03             	shr    $0x3,%eax
801018ff:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101905:	50                   	push   %eax
80101906:	56                   	push   %esi
80101907:	e8 c4 e7 ff ff       	call   801000d0 <bread>
8010190c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010190e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101910:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101913:	83 e0 07             	and    $0x7,%eax
80101916:	c1 e0 06             	shl    $0x6,%eax
80101919:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010191d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101921:	75 bd                	jne    801018e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101923:	83 ec 04             	sub    $0x4,%esp
80101926:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101929:	6a 40                	push   $0x40
8010192b:	6a 00                	push   $0x0
8010192d:	51                   	push   %ecx
8010192e:	e8 3d 31 00 00       	call   80104a70 <memset>
      dip->type = type;
80101933:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101937:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010193a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010193d:	89 3c 24             	mov    %edi,(%esp)
80101940:	e8 9b 17 00 00       	call   801030e0 <log_write>
      brelse(bp);
80101945:	89 3c 24             	mov    %edi,(%esp)
80101948:	e8 93 e8 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010194d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101950:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101953:	89 da                	mov    %ebx,%edx
80101955:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101957:	5b                   	pop    %ebx
80101958:	5e                   	pop    %esi
80101959:	5f                   	pop    %edi
8010195a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010195b:	e9 e0 fc ff ff       	jmp    80101640 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101960:	83 ec 0c             	sub    $0xc,%esp
80101963:	68 d8 78 10 80       	push   $0x801078d8
80101968:	e8 03 ea ff ff       	call   80100370 <panic>
8010196d:	8d 76 00             	lea    0x0(%esi),%esi

80101970 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	56                   	push   %esi
80101974:	53                   	push   %ebx
80101975:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101978:	83 ec 08             	sub    $0x8,%esp
8010197b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010197e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101981:	c1 e8 03             	shr    $0x3,%eax
80101984:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010198a:	50                   	push   %eax
8010198b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101995:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101998:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010199c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010199f:	83 e0 07             	and    $0x7,%eax
801019a2:	c1 e0 06             	shl    $0x6,%eax
801019a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801019a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801019ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019b0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801019b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801019b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801019bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801019bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801019c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801019c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801019ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019cd:	6a 34                	push   $0x34
801019cf:	53                   	push   %ebx
801019d0:	50                   	push   %eax
801019d1:	e8 4a 31 00 00       	call   80104b20 <memmove>
  log_write(bp);
801019d6:	89 34 24             	mov    %esi,(%esp)
801019d9:	e8 02 17 00 00       	call   801030e0 <log_write>
  brelse(bp);
801019de:	89 75 08             	mov    %esi,0x8(%ebp)
801019e1:	83 c4 10             	add    $0x10,%esp
}
801019e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019e7:	5b                   	pop    %ebx
801019e8:	5e                   	pop    %esi
801019e9:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801019ea:	e9 f1 e7 ff ff       	jmp    801001e0 <brelse>
801019ef:	90                   	nop

801019f0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	53                   	push   %ebx
801019f4:	83 ec 10             	sub    $0x10,%esp
801019f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801019fa:	68 e0 19 11 80       	push   $0x801119e0
801019ff:	e8 6c 2f 00 00       	call   80104970 <acquire>
  ip->ref++;
80101a04:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a08:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101a0f:	e8 0c 30 00 00       	call   80104a20 <release>
  return ip;
}
80101a14:	89 d8                	mov    %ebx,%eax
80101a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a19:	c9                   	leave  
80101a1a:	c3                   	ret    
80101a1b:	90                   	nop
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a20 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a28:	85 db                	test   %ebx,%ebx
80101a2a:	0f 84 b7 00 00 00    	je     80101ae7 <ilock+0xc7>
80101a30:	8b 53 08             	mov    0x8(%ebx),%edx
80101a33:	85 d2                	test   %edx,%edx
80101a35:	0f 8e ac 00 00 00    	jle    80101ae7 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
80101a3b:	8d 43 0c             	lea    0xc(%ebx),%eax
80101a3e:	83 ec 0c             	sub    $0xc,%esp
80101a41:	50                   	push   %eax
80101a42:	e8 d9 2c 00 00       	call   80104720 <acquiresleep>

  if(ip->valid == 0){
80101a47:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101a4a:	83 c4 10             	add    $0x10,%esp
80101a4d:	85 c0                	test   %eax,%eax
80101a4f:	74 0f                	je     80101a60 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101a51:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a54:	5b                   	pop    %ebx
80101a55:	5e                   	pop    %esi
80101a56:	5d                   	pop    %ebp
80101a57:	c3                   	ret    
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a60:	8b 43 04             	mov    0x4(%ebx),%eax
80101a63:	83 ec 08             	sub    $0x8,%esp
80101a66:	c1 e8 03             	shr    $0x3,%eax
80101a69:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101a6f:	50                   	push   %eax
80101a70:	ff 33                	pushl  (%ebx)
80101a72:	e8 59 e6 ff ff       	call   801000d0 <bread>
80101a77:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a79:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a7c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a7f:	83 e0 07             	and    $0x7,%eax
80101a82:	c1 e0 06             	shl    $0x6,%eax
80101a85:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101a89:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a8c:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101a8f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101a93:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101a97:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101a9b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101a9f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101aa3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101aa7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101aab:	8b 50 fc             	mov    -0x4(%eax),%edx
80101aae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ab1:	6a 34                	push   $0x34
80101ab3:	50                   	push   %eax
80101ab4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101ab7:	50                   	push   %eax
80101ab8:	e8 63 30 00 00       	call   80104b20 <memmove>
    brelse(bp);
80101abd:	89 34 24             	mov    %esi,(%esp)
80101ac0:	e8 1b e7 ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101ac5:	83 c4 10             	add    $0x10,%esp
80101ac8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
80101acd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101ad4:	0f 85 77 ff ff ff    	jne    80101a51 <ilock+0x31>
      panic("ilock: no type");
80101ada:	83 ec 0c             	sub    $0xc,%esp
80101add:	68 f0 78 10 80       	push   $0x801078f0
80101ae2:	e8 89 e8 ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101ae7:	83 ec 0c             	sub    $0xc,%esp
80101aea:	68 ea 78 10 80       	push   $0x801078ea
80101aef:	e8 7c e8 ff ff       	call   80100370 <panic>
80101af4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101afa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101b00 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	56                   	push   %esi
80101b04:	53                   	push   %ebx
80101b05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b08:	85 db                	test   %ebx,%ebx
80101b0a:	74 28                	je     80101b34 <iunlock+0x34>
80101b0c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b0f:	83 ec 0c             	sub    $0xc,%esp
80101b12:	56                   	push   %esi
80101b13:	e8 a8 2c 00 00       	call   801047c0 <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 15                	je     80101b34 <iunlock+0x34>
80101b1f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b22:	85 c0                	test   %eax,%eax
80101b24:	7e 0e                	jle    80101b34 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101b26:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101b29:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b2c:	5b                   	pop    %ebx
80101b2d:	5e                   	pop    %esi
80101b2e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
80101b2f:	e9 4c 2c 00 00       	jmp    80104780 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101b34:	83 ec 0c             	sub    $0xc,%esp
80101b37:	68 ff 78 10 80       	push   $0x801078ff
80101b3c:	e8 2f e8 ff ff       	call   80100370 <panic>
80101b41:	eb 0d                	jmp    80101b50 <iput>
80101b43:	90                   	nop
80101b44:	90                   	nop
80101b45:	90                   	nop
80101b46:	90                   	nop
80101b47:	90                   	nop
80101b48:	90                   	nop
80101b49:	90                   	nop
80101b4a:	90                   	nop
80101b4b:	90                   	nop
80101b4c:	90                   	nop
80101b4d:	90                   	nop
80101b4e:	90                   	nop
80101b4f:	90                   	nop

80101b50 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	57                   	push   %edi
80101b54:	56                   	push   %esi
80101b55:	53                   	push   %ebx
80101b56:	83 ec 28             	sub    $0x28,%esp
80101b59:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
80101b5c:	8d 7e 0c             	lea    0xc(%esi),%edi
80101b5f:	57                   	push   %edi
80101b60:	e8 bb 2b 00 00       	call   80104720 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101b65:	8b 56 4c             	mov    0x4c(%esi),%edx
80101b68:	83 c4 10             	add    $0x10,%esp
80101b6b:	85 d2                	test   %edx,%edx
80101b6d:	74 07                	je     80101b76 <iput+0x26>
80101b6f:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101b74:	74 32                	je     80101ba8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101b76:	83 ec 0c             	sub    $0xc,%esp
80101b79:	57                   	push   %edi
80101b7a:	e8 01 2c 00 00       	call   80104780 <releasesleep>

  acquire(&icache.lock);
80101b7f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101b86:	e8 e5 2d 00 00       	call   80104970 <acquire>
  ip->ref--;
80101b8b:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
80101b8f:	83 c4 10             	add    $0x10,%esp
80101b92:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101b99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9c:	5b                   	pop    %ebx
80101b9d:	5e                   	pop    %esi
80101b9e:	5f                   	pop    %edi
80101b9f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101ba0:	e9 7b 2e 00 00       	jmp    80104a20 <release>
80101ba5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101ba8:	83 ec 0c             	sub    $0xc,%esp
80101bab:	68 e0 19 11 80       	push   $0x801119e0
80101bb0:	e8 bb 2d 00 00       	call   80104970 <acquire>
    int r = ip->ref;
80101bb5:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101bb8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101bbf:	e8 5c 2e 00 00       	call   80104a20 <release>
    if(r == 1){
80101bc4:	83 c4 10             	add    $0x10,%esp
80101bc7:	83 fb 01             	cmp    $0x1,%ebx
80101bca:	75 aa                	jne    80101b76 <iput+0x26>
80101bcc:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101bd2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101bd5:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101bd8:	89 cf                	mov    %ecx,%edi
80101bda:	eb 0b                	jmp    80101be7 <iput+0x97>
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101be0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101be3:	39 fb                	cmp    %edi,%ebx
80101be5:	74 19                	je     80101c00 <iput+0xb0>
    if(ip->addrs[i]){
80101be7:	8b 13                	mov    (%ebx),%edx
80101be9:	85 d2                	test   %edx,%edx
80101beb:	74 f3                	je     80101be0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101bed:	8b 06                	mov    (%esi),%eax
80101bef:	e8 cc f8 ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
80101bf4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80101bfa:	eb e4                	jmp    80101be0 <iput+0x90>
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101c00:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101c06:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c09:	85 c0                	test   %eax,%eax
80101c0b:	75 33                	jne    80101c40 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101c0d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101c10:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101c17:	56                   	push   %esi
80101c18:	e8 53 fd ff ff       	call   80101970 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
80101c1d:	31 c0                	xor    %eax,%eax
80101c1f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101c23:	89 34 24             	mov    %esi,(%esp)
80101c26:	e8 45 fd ff ff       	call   80101970 <iupdate>
      ip->valid = 0;
80101c2b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101c32:	83 c4 10             	add    $0x10,%esp
80101c35:	e9 3c ff ff ff       	jmp    80101b76 <iput+0x26>
80101c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c40:	83 ec 08             	sub    $0x8,%esp
80101c43:	50                   	push   %eax
80101c44:	ff 36                	pushl  (%esi)
80101c46:	e8 85 e4 ff ff       	call   801000d0 <bread>
80101c4b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101c51:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101c57:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101c5a:	83 c4 10             	add    $0x10,%esp
80101c5d:	89 cf                	mov    %ecx,%edi
80101c5f:	eb 0e                	jmp    80101c6f <iput+0x11f>
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c68:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101c6b:	39 fb                	cmp    %edi,%ebx
80101c6d:	74 0f                	je     80101c7e <iput+0x12e>
      if(a[j])
80101c6f:	8b 13                	mov    (%ebx),%edx
80101c71:	85 d2                	test   %edx,%edx
80101c73:	74 f3                	je     80101c68 <iput+0x118>
        bfree(ip->dev, a[j]);
80101c75:	8b 06                	mov    (%esi),%eax
80101c77:	e8 44 f8 ff ff       	call   801014c0 <bfree>
80101c7c:	eb ea                	jmp    80101c68 <iput+0x118>
    }
    brelse(bp);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
80101c81:	ff 75 e4             	pushl  -0x1c(%ebp)
80101c84:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c87:	e8 54 e5 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101c8c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101c92:	8b 06                	mov    (%esi),%eax
80101c94:	e8 27 f8 ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101c99:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101ca0:	00 00 00 
80101ca3:	83 c4 10             	add    $0x10,%esp
80101ca6:	e9 62 ff ff ff       	jmp    80101c0d <iput+0xbd>
80101cab:	90                   	nop
80101cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	53                   	push   %ebx
80101cb4:	83 ec 10             	sub    $0x10,%esp
80101cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101cba:	53                   	push   %ebx
80101cbb:	e8 40 fe ff ff       	call   80101b00 <iunlock>
  iput(ip);
80101cc0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101cc3:	83 c4 10             	add    $0x10,%esp
}
80101cc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101cc9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101cca:	e9 81 fe ff ff       	jmp    80101b50 <iput>
80101ccf:	90                   	nop

80101cd0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	8b 55 08             	mov    0x8(%ebp),%edx
80101cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101cd9:	8b 0a                	mov    (%edx),%ecx
80101cdb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101cde:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ce1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ce4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ce8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101ceb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101cef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101cf3:	8b 52 58             	mov    0x58(%edx),%edx
80101cf6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101cf9:	5d                   	pop    %ebp
80101cfa:	c3                   	ret    
80101cfb:	90                   	nop
80101cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	83 ec 1c             	sub    $0x1c,%esp
80101d09:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101d0f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d17:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101d1a:	8b 7d 14             	mov    0x14(%ebp),%edi
80101d1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d23:	0f 84 a7 00 00 00    	je     80101dd0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101d29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d2c:	8b 40 58             	mov    0x58(%eax),%eax
80101d2f:	39 f0                	cmp    %esi,%eax
80101d31:	0f 82 c1 00 00 00    	jb     80101df8 <readi+0xf8>
80101d37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d3a:	89 fa                	mov    %edi,%edx
80101d3c:	01 f2                	add    %esi,%edx
80101d3e:	0f 82 b4 00 00 00    	jb     80101df8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d44:	89 c1                	mov    %eax,%ecx
80101d46:	29 f1                	sub    %esi,%ecx
80101d48:	39 d0                	cmp    %edx,%eax
80101d4a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d4d:	31 ff                	xor    %edi,%edi
80101d4f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d51:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d54:	74 6d                	je     80101dc3 <readi+0xc3>
80101d56:	8d 76 00             	lea    0x0(%esi),%esi
80101d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101d63:	89 f2                	mov    %esi,%edx
80101d65:	c1 ea 09             	shr    $0x9,%edx
80101d68:	89 d8                	mov    %ebx,%eax
80101d6a:	e8 a1 f9 ff ff       	call   80101710 <bmap>
80101d6f:	83 ec 08             	sub    $0x8,%esp
80101d72:	50                   	push   %eax
80101d73:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101d75:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d7a:	e8 51 e3 ff ff       	call   801000d0 <bread>
80101d7f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d84:	89 f1                	mov    %esi,%ecx
80101d86:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101d8c:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101d92:	29 cb                	sub    %ecx,%ebx
80101d94:	29 f8                	sub    %edi,%eax
80101d96:	39 c3                	cmp    %eax,%ebx
80101d98:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d9b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101d9f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101da0:	01 df                	add    %ebx,%edi
80101da2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101da4:	50                   	push   %eax
80101da5:	ff 75 e0             	pushl  -0x20(%ebp)
80101da8:	e8 73 2d 00 00       	call   80104b20 <memmove>
    brelse(bp);
80101dad:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101db0:	89 14 24             	mov    %edx,(%esp)
80101db3:	e8 28 e4 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101db8:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101dbb:	83 c4 10             	add    $0x10,%esp
80101dbe:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101dc1:	77 9d                	ja     80101d60 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc9:	5b                   	pop    %ebx
80101dca:	5e                   	pop    %esi
80101dcb:	5f                   	pop    %edi
80101dcc:	5d                   	pop    %ebp
80101dcd:	c3                   	ret    
80101dce:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101dd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101dd4:	66 83 f8 09          	cmp    $0x9,%ax
80101dd8:	77 1e                	ja     80101df8 <readi+0xf8>
80101dda:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101de1:	85 c0                	test   %eax,%eax
80101de3:	74 13                	je     80101df8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101de5:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101def:	ff e0                	jmp    *%eax
80101df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dfd:	eb c7                	jmp    80101dc6 <readi+0xc6>
80101dff:	90                   	nop

80101e00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 1c             	sub    $0x1c,%esp
80101e09:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101e0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101e17:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101e1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101e20:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e23:	0f 84 b7 00 00 00    	je     80101ee0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101e29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e2c:	39 70 58             	cmp    %esi,0x58(%eax)
80101e2f:	0f 82 eb 00 00 00    	jb     80101f20 <writei+0x120>
80101e35:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e38:	89 f8                	mov    %edi,%eax
80101e3a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101e3c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101e41:	0f 87 d9 00 00 00    	ja     80101f20 <writei+0x120>
80101e47:	39 c6                	cmp    %eax,%esi
80101e49:	0f 87 d1 00 00 00    	ja     80101f20 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e4f:	85 ff                	test   %edi,%edi
80101e51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101e58:	74 78                	je     80101ed2 <writei+0xd2>
80101e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e60:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101e63:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101e65:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e6a:	c1 ea 09             	shr    $0x9,%edx
80101e6d:	89 f8                	mov    %edi,%eax
80101e6f:	e8 9c f8 ff ff       	call   80101710 <bmap>
80101e74:	83 ec 08             	sub    $0x8,%esp
80101e77:	50                   	push   %eax
80101e78:	ff 37                	pushl  (%edi)
80101e7a:	e8 51 e2 ff ff       	call   801000d0 <bread>
80101e7f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101e81:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e84:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101e87:	89 f1                	mov    %esi,%ecx
80101e89:	83 c4 0c             	add    $0xc,%esp
80101e8c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101e92:	29 cb                	sub    %ecx,%ebx
80101e94:	39 c3                	cmp    %eax,%ebx
80101e96:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101e99:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101e9d:	53                   	push   %ebx
80101e9e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ea1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ea3:	50                   	push   %eax
80101ea4:	e8 77 2c 00 00       	call   80104b20 <memmove>
    log_write(bp);
80101ea9:	89 3c 24             	mov    %edi,(%esp)
80101eac:	e8 2f 12 00 00       	call   801030e0 <log_write>
    brelse(bp);
80101eb1:	89 3c 24             	mov    %edi,(%esp)
80101eb4:	e8 27 e3 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101eb9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ebc:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ebf:	83 c4 10             	add    $0x10,%esp
80101ec2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ec5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101ec8:	77 96                	ja     80101e60 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101eca:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ecd:	3b 70 58             	cmp    0x58(%eax),%esi
80101ed0:	77 36                	ja     80101f08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ed2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ed5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ed8:	5b                   	pop    %ebx
80101ed9:	5e                   	pop    %esi
80101eda:	5f                   	pop    %edi
80101edb:	5d                   	pop    %ebp
80101edc:	c3                   	ret    
80101edd:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ee0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ee4:	66 83 f8 09          	cmp    $0x9,%ax
80101ee8:	77 36                	ja     80101f20 <writei+0x120>
80101eea:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101ef1:	85 c0                	test   %eax,%eax
80101ef3:	74 2b                	je     80101f20 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101ef5:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101ef8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efb:	5b                   	pop    %ebx
80101efc:	5e                   	pop    %esi
80101efd:	5f                   	pop    %edi
80101efe:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101eff:	ff e0                	jmp    *%eax
80101f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101f08:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101f0b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101f0e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101f11:	50                   	push   %eax
80101f12:	e8 59 fa ff ff       	call   80101970 <iupdate>
80101f17:	83 c4 10             	add    $0x10,%esp
80101f1a:	eb b6                	jmp    80101ed2 <writei+0xd2>
80101f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f25:	eb ae                	jmp    80101ed5 <writei+0xd5>
80101f27:	89 f6                	mov    %esi,%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101f36:	6a 0e                	push   $0xe
80101f38:	ff 75 0c             	pushl  0xc(%ebp)
80101f3b:	ff 75 08             	pushl  0x8(%ebp)
80101f3e:	e8 5d 2c 00 00       	call   80104ba0 <strncmp>
}
80101f43:	c9                   	leave  
80101f44:	c3                   	ret    
80101f45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	57                   	push   %edi
80101f54:	56                   	push   %esi
80101f55:	53                   	push   %ebx
80101f56:	83 ec 1c             	sub    $0x1c,%esp
80101f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101f5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101f61:	0f 85 80 00 00 00    	jne    80101fe7 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101f67:	8b 53 58             	mov    0x58(%ebx),%edx
80101f6a:	31 ff                	xor    %edi,%edi
80101f6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f6f:	85 d2                	test   %edx,%edx
80101f71:	75 0d                	jne    80101f80 <dirlookup+0x30>
80101f73:	eb 5b                	jmp    80101fd0 <dirlookup+0x80>
80101f75:	8d 76 00             	lea    0x0(%esi),%esi
80101f78:	83 c7 10             	add    $0x10,%edi
80101f7b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101f7e:	76 50                	jbe    80101fd0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f80:	6a 10                	push   $0x10
80101f82:	57                   	push   %edi
80101f83:	56                   	push   %esi
80101f84:	53                   	push   %ebx
80101f85:	e8 76 fd ff ff       	call   80101d00 <readi>
80101f8a:	83 c4 10             	add    $0x10,%esp
80101f8d:	83 f8 10             	cmp    $0x10,%eax
80101f90:	75 48                	jne    80101fda <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101f92:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f97:	74 df                	je     80101f78 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101f99:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f9c:	83 ec 04             	sub    $0x4,%esp
80101f9f:	6a 0e                	push   $0xe
80101fa1:	50                   	push   %eax
80101fa2:	ff 75 0c             	pushl  0xc(%ebp)
80101fa5:	e8 f6 2b 00 00       	call   80104ba0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101faa:	83 c4 10             	add    $0x10,%esp
80101fad:	85 c0                	test   %eax,%eax
80101faf:	75 c7                	jne    80101f78 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101fb1:	8b 45 10             	mov    0x10(%ebp),%eax
80101fb4:	85 c0                	test   %eax,%eax
80101fb6:	74 05                	je     80101fbd <dirlookup+0x6d>
        *poff = off;
80101fb8:	8b 45 10             	mov    0x10(%ebp),%eax
80101fbb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101fbd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101fc1:	8b 03                	mov    (%ebx),%eax
80101fc3:	e8 78 f6 ff ff       	call   80101640 <iget>
    }
  }

  return 0;
}
80101fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5f                   	pop    %edi
80101fce:	5d                   	pop    %ebp
80101fcf:	c3                   	ret    
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101fd3:	31 c0                	xor    %eax,%eax
}
80101fd5:	5b                   	pop    %ebx
80101fd6:	5e                   	pop    %esi
80101fd7:	5f                   	pop    %edi
80101fd8:	5d                   	pop    %ebp
80101fd9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101fda:	83 ec 0c             	sub    $0xc,%esp
80101fdd:	68 19 79 10 80       	push   $0x80107919
80101fe2:	e8 89 e3 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101fe7:	83 ec 0c             	sub    $0xc,%esp
80101fea:	68 07 79 10 80       	push   $0x80107907
80101fef:	e8 7c e3 ff ff       	call   80100370 <panic>
80101ff4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ffa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102000 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	89 cf                	mov    %ecx,%edi
80102008:	89 c3                	mov    %eax,%ebx
8010200a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010200d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102010:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80102013:	0f 84 53 01 00 00    	je     8010216c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102019:	e8 42 1b 00 00       	call   80103b60 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
8010201e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102021:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80102024:	68 e0 19 11 80       	push   $0x801119e0
80102029:	e8 42 29 00 00       	call   80104970 <acquire>
  ip->ref++;
8010202e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102032:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80102039:	e8 e2 29 00 00       	call   80104a20 <release>
8010203e:	83 c4 10             	add    $0x10,%esp
80102041:	eb 08                	jmp    8010204b <namex+0x4b>
80102043:	90                   	nop
80102044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80102048:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010204b:	0f b6 03             	movzbl (%ebx),%eax
8010204e:	3c 2f                	cmp    $0x2f,%al
80102050:	74 f6                	je     80102048 <namex+0x48>
    path++;
  if(*path == 0)
80102052:	84 c0                	test   %al,%al
80102054:	0f 84 e3 00 00 00    	je     8010213d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010205a:	0f b6 03             	movzbl (%ebx),%eax
8010205d:	89 da                	mov    %ebx,%edx
8010205f:	84 c0                	test   %al,%al
80102061:	0f 84 ac 00 00 00    	je     80102113 <namex+0x113>
80102067:	3c 2f                	cmp    $0x2f,%al
80102069:	75 09                	jne    80102074 <namex+0x74>
8010206b:	e9 a3 00 00 00       	jmp    80102113 <namex+0x113>
80102070:	84 c0                	test   %al,%al
80102072:	74 0a                	je     8010207e <namex+0x7e>
    path++;
80102074:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102077:	0f b6 02             	movzbl (%edx),%eax
8010207a:	3c 2f                	cmp    $0x2f,%al
8010207c:	75 f2                	jne    80102070 <namex+0x70>
8010207e:	89 d1                	mov    %edx,%ecx
80102080:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80102082:	83 f9 0d             	cmp    $0xd,%ecx
80102085:	0f 8e 8d 00 00 00    	jle    80102118 <namex+0x118>
    memmove(name, s, DIRSIZ);
8010208b:	83 ec 04             	sub    $0x4,%esp
8010208e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102091:	6a 0e                	push   $0xe
80102093:	53                   	push   %ebx
80102094:	57                   	push   %edi
80102095:	e8 86 2a 00 00       	call   80104b20 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
8010209a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
8010209d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
801020a0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801020a2:	80 3a 2f             	cmpb   $0x2f,(%edx)
801020a5:	75 11                	jne    801020b8 <namex+0xb8>
801020a7:	89 f6                	mov    %esi,%esi
801020a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
801020b0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801020b3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801020b6:	74 f8                	je     801020b0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	56                   	push   %esi
801020bc:	e8 5f f9 ff ff       	call   80101a20 <ilock>
    if(ip->type != T_DIR){
801020c1:	83 c4 10             	add    $0x10,%esp
801020c4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801020c9:	0f 85 7f 00 00 00    	jne    8010214e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801020cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
801020d2:	85 d2                	test   %edx,%edx
801020d4:	74 09                	je     801020df <namex+0xdf>
801020d6:	80 3b 00             	cmpb   $0x0,(%ebx)
801020d9:	0f 84 a3 00 00 00    	je     80102182 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801020df:	83 ec 04             	sub    $0x4,%esp
801020e2:	6a 00                	push   $0x0
801020e4:	57                   	push   %edi
801020e5:	56                   	push   %esi
801020e6:	e8 65 fe ff ff       	call   80101f50 <dirlookup>
801020eb:	83 c4 10             	add    $0x10,%esp
801020ee:	85 c0                	test   %eax,%eax
801020f0:	74 5c                	je     8010214e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
801020f2:	83 ec 0c             	sub    $0xc,%esp
801020f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801020f8:	56                   	push   %esi
801020f9:	e8 02 fa ff ff       	call   80101b00 <iunlock>
  iput(ip);
801020fe:	89 34 24             	mov    %esi,(%esp)
80102101:	e8 4a fa ff ff       	call   80101b50 <iput>
80102106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102109:	83 c4 10             	add    $0x10,%esp
8010210c:	89 c6                	mov    %eax,%esi
8010210e:	e9 38 ff ff ff       	jmp    8010204b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102113:	31 c9                	xor    %ecx,%ecx
80102115:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102118:	83 ec 04             	sub    $0x4,%esp
8010211b:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010211e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102121:	51                   	push   %ecx
80102122:	53                   	push   %ebx
80102123:	57                   	push   %edi
80102124:	e8 f7 29 00 00       	call   80104b20 <memmove>
    name[len] = 0;
80102129:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010212c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010212f:	83 c4 10             	add    $0x10,%esp
80102132:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80102136:	89 d3                	mov    %edx,%ebx
80102138:	e9 65 ff ff ff       	jmp    801020a2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010213d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102140:	85 c0                	test   %eax,%eax
80102142:	75 54                	jne    80102198 <namex+0x198>
80102144:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80102146:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102149:	5b                   	pop    %ebx
8010214a:	5e                   	pop    %esi
8010214b:	5f                   	pop    %edi
8010214c:	5d                   	pop    %ebp
8010214d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
8010214e:	83 ec 0c             	sub    $0xc,%esp
80102151:	56                   	push   %esi
80102152:	e8 a9 f9 ff ff       	call   80101b00 <iunlock>
  iput(ip);
80102157:	89 34 24             	mov    %esi,(%esp)
8010215a:	e8 f1 f9 ff ff       	call   80101b50 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
8010215f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102162:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80102165:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102167:	5b                   	pop    %ebx
80102168:	5e                   	pop    %esi
80102169:	5f                   	pop    %edi
8010216a:	5d                   	pop    %ebp
8010216b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
8010216c:	ba 01 00 00 00       	mov    $0x1,%edx
80102171:	b8 01 00 00 00       	mov    $0x1,%eax
80102176:	e8 c5 f4 ff ff       	call   80101640 <iget>
8010217b:	89 c6                	mov    %eax,%esi
8010217d:	e9 c9 fe ff ff       	jmp    8010204b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80102182:	83 ec 0c             	sub    $0xc,%esp
80102185:	56                   	push   %esi
80102186:	e8 75 f9 ff ff       	call   80101b00 <iunlock>
      return ip;
8010218b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
8010218e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80102191:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	56                   	push   %esi
8010219c:	e8 af f9 ff ff       	call   80101b50 <iput>
    return 0;
801021a1:	83 c4 10             	add    $0x10,%esp
801021a4:	31 c0                	xor    %eax,%eax
801021a6:	eb 9e                	jmp    80102146 <namex+0x146>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021b0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021b0:	55                   	push   %ebp
801021b1:	89 e5                	mov    %esp,%ebp
801021b3:	57                   	push   %edi
801021b4:	56                   	push   %esi
801021b5:	53                   	push   %ebx
801021b6:	83 ec 20             	sub    $0x20,%esp
801021b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021bc:	6a 00                	push   $0x0
801021be:	ff 75 0c             	pushl  0xc(%ebp)
801021c1:	53                   	push   %ebx
801021c2:	e8 89 fd ff ff       	call   80101f50 <dirlookup>
801021c7:	83 c4 10             	add    $0x10,%esp
801021ca:	85 c0                	test   %eax,%eax
801021cc:	75 67                	jne    80102235 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021ce:	8b 7b 58             	mov    0x58(%ebx),%edi
801021d1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021d4:	85 ff                	test   %edi,%edi
801021d6:	74 29                	je     80102201 <dirlink+0x51>
801021d8:	31 ff                	xor    %edi,%edi
801021da:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021dd:	eb 09                	jmp    801021e8 <dirlink+0x38>
801021df:	90                   	nop
801021e0:	83 c7 10             	add    $0x10,%edi
801021e3:	39 7b 58             	cmp    %edi,0x58(%ebx)
801021e6:	76 19                	jbe    80102201 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021e8:	6a 10                	push   $0x10
801021ea:	57                   	push   %edi
801021eb:	56                   	push   %esi
801021ec:	53                   	push   %ebx
801021ed:	e8 0e fb ff ff       	call   80101d00 <readi>
801021f2:	83 c4 10             	add    $0x10,%esp
801021f5:	83 f8 10             	cmp    $0x10,%eax
801021f8:	75 4e                	jne    80102248 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
801021fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801021ff:	75 df                	jne    801021e0 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102201:	8d 45 da             	lea    -0x26(%ebp),%eax
80102204:	83 ec 04             	sub    $0x4,%esp
80102207:	6a 0e                	push   $0xe
80102209:	ff 75 0c             	pushl  0xc(%ebp)
8010220c:	50                   	push   %eax
8010220d:	e8 fe 29 00 00       	call   80104c10 <strncpy>
  de.inum = inum;
80102212:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102215:	6a 10                	push   $0x10
80102217:	57                   	push   %edi
80102218:	56                   	push   %esi
80102219:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
8010221a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010221e:	e8 dd fb ff ff       	call   80101e00 <writei>
80102223:	83 c4 20             	add    $0x20,%esp
80102226:	83 f8 10             	cmp    $0x10,%eax
80102229:	75 2a                	jne    80102255 <dirlink+0xa5>
    panic("dirlink");

  return 0;
8010222b:	31 c0                	xor    %eax,%eax
}
8010222d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102230:	5b                   	pop    %ebx
80102231:	5e                   	pop    %esi
80102232:	5f                   	pop    %edi
80102233:	5d                   	pop    %ebp
80102234:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80102235:	83 ec 0c             	sub    $0xc,%esp
80102238:	50                   	push   %eax
80102239:	e8 12 f9 ff ff       	call   80101b50 <iput>
    return -1;
8010223e:	83 c4 10             	add    $0x10,%esp
80102241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102246:	eb e5                	jmp    8010222d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80102248:	83 ec 0c             	sub    $0xc,%esp
8010224b:	68 28 79 10 80       	push   $0x80107928
80102250:	e8 1b e1 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80102255:	83 ec 0c             	sub    $0xc,%esp
80102258:	68 5a 7f 10 80       	push   $0x80107f5a
8010225d:	e8 0e e1 ff ff       	call   80100370 <panic>
80102262:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102270 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80102270:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102271:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80102273:	89 e5                	mov    %esp,%ebp
80102275:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102278:	8b 45 08             	mov    0x8(%ebp),%eax
8010227b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010227e:	e8 7d fd ff ff       	call   80102000 <namex>
}
80102283:	c9                   	leave  
80102284:	c3                   	ret    
80102285:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102290 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102290:	55                   	push   %ebp
  return namex(path, 1, name);
80102291:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80102296:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102298:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010229b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010229e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010229f:	e9 5c fd ff ff       	jmp    80102000 <namex>
801022a4:	66 90                	xchg   %ax,%ax
801022a6:	66 90                	xchg   %ax,%ax
801022a8:	66 90                	xchg   %ax,%ax
801022aa:	66 90                	xchg   %ax,%ax
801022ac:	66 90                	xchg   %ax,%ax
801022ae:	66 90                	xchg   %ax,%ax

801022b0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022b0:	55                   	push   %ebp
  if(b == 0)
801022b1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022b3:	89 e5                	mov    %esp,%ebp
801022b5:	56                   	push   %esi
801022b6:	53                   	push   %ebx
  if(b == 0)
801022b7:	0f 84 ad 00 00 00    	je     8010236a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022bd:	8b 58 08             	mov    0x8(%eax),%ebx
801022c0:	89 c1                	mov    %eax,%ecx
801022c2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801022c8:	0f 87 8f 00 00 00    	ja     8010235d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022ce:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022d3:	90                   	nop
801022d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022d8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022d9:	83 e0 c0             	and    $0xffffffc0,%eax
801022dc:	3c 40                	cmp    $0x40,%al
801022de:	75 f8                	jne    801022d8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022e0:	31 f6                	xor    %esi,%esi
801022e2:	ba f6 03 00 00       	mov    $0x3f6,%edx
801022e7:	89 f0                	mov    %esi,%eax
801022e9:	ee                   	out    %al,(%dx)
801022ea:	ba f2 01 00 00       	mov    $0x1f2,%edx
801022ef:	b8 01 00 00 00       	mov    $0x1,%eax
801022f4:	ee                   	out    %al,(%dx)
801022f5:	ba f3 01 00 00       	mov    $0x1f3,%edx
801022fa:	89 d8                	mov    %ebx,%eax
801022fc:	ee                   	out    %al,(%dx)
801022fd:	89 d8                	mov    %ebx,%eax
801022ff:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102304:	c1 f8 08             	sar    $0x8,%eax
80102307:	ee                   	out    %al,(%dx)
80102308:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010230d:	89 f0                	mov    %esi,%eax
8010230f:	ee                   	out    %al,(%dx)
80102310:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102314:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102319:	83 e0 01             	and    $0x1,%eax
8010231c:	c1 e0 04             	shl    $0x4,%eax
8010231f:	83 c8 e0             	or     $0xffffffe0,%eax
80102322:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102323:	f6 01 04             	testb  $0x4,(%ecx)
80102326:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010232b:	75 13                	jne    80102340 <idestart+0x90>
8010232d:	b8 20 00 00 00       	mov    $0x20,%eax
80102332:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102333:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102336:	5b                   	pop    %ebx
80102337:	5e                   	pop    %esi
80102338:	5d                   	pop    %ebp
80102339:	c3                   	ret    
8010233a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102340:	b8 30 00 00 00       	mov    $0x30,%eax
80102345:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102346:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010234b:	8d 71 5c             	lea    0x5c(%ecx),%esi
8010234e:	b9 80 00 00 00       	mov    $0x80,%ecx
80102353:	fc                   	cld    
80102354:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102356:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102359:	5b                   	pop    %ebx
8010235a:	5e                   	pop    %esi
8010235b:	5d                   	pop    %ebp
8010235c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010235d:	83 ec 0c             	sub    $0xc,%esp
80102360:	68 94 79 10 80       	push   $0x80107994
80102365:	e8 06 e0 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010236a:	83 ec 0c             	sub    $0xc,%esp
8010236d:	68 8b 79 10 80       	push   $0x8010798b
80102372:	e8 f9 df ff ff       	call   80100370 <panic>
80102377:	89 f6                	mov    %esi,%esi
80102379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102380 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80102386:	68 a6 79 10 80       	push   $0x801079a6
8010238b:	68 80 b5 10 80       	push   $0x8010b580
80102390:	e8 7b 24 00 00       	call   80104810 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102395:	58                   	pop    %eax
80102396:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010239b:	5a                   	pop    %edx
8010239c:	83 e8 01             	sub    $0x1,%eax
8010239f:	50                   	push   %eax
801023a0:	6a 0e                	push   $0xe
801023a2:	e8 a9 02 00 00       	call   80102650 <ioapicenable>
801023a7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023aa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023af:	90                   	nop
801023b0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023b1:	83 e0 c0             	and    $0xffffffc0,%eax
801023b4:	3c 40                	cmp    $0x40,%al
801023b6:	75 f8                	jne    801023b0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023b8:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023bd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023c2:	ee                   	out    %al,(%dx)
801023c3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023c8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023cd:	eb 06                	jmp    801023d5 <ideinit+0x55>
801023cf:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801023d0:	83 e9 01             	sub    $0x1,%ecx
801023d3:	74 0f                	je     801023e4 <ideinit+0x64>
801023d5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023d6:	84 c0                	test   %al,%al
801023d8:	74 f6                	je     801023d0 <ideinit+0x50>
      havedisk1 = 1;
801023da:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801023e1:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023e4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023e9:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801023ee:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801023ef:	c9                   	leave  
801023f0:	c3                   	ret    
801023f1:	eb 0d                	jmp    80102400 <ideintr>
801023f3:	90                   	nop
801023f4:	90                   	nop
801023f5:	90                   	nop
801023f6:	90                   	nop
801023f7:	90                   	nop
801023f8:	90                   	nop
801023f9:	90                   	nop
801023fa:	90                   	nop
801023fb:	90                   	nop
801023fc:	90                   	nop
801023fd:	90                   	nop
801023fe:	90                   	nop
801023ff:	90                   	nop

80102400 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	57                   	push   %edi
80102404:	56                   	push   %esi
80102405:	53                   	push   %ebx
80102406:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102409:	68 80 b5 10 80       	push   $0x8010b580
8010240e:	e8 5d 25 00 00       	call   80104970 <acquire>

  if((b = idequeue) == 0){
80102413:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102419:	83 c4 10             	add    $0x10,%esp
8010241c:	85 db                	test   %ebx,%ebx
8010241e:	74 34                	je     80102454 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102420:	8b 43 58             	mov    0x58(%ebx),%eax
80102423:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102428:	8b 33                	mov    (%ebx),%esi
8010242a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102430:	74 3e                	je     80102470 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102432:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102435:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102438:	83 ce 02             	or     $0x2,%esi
8010243b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010243d:	53                   	push   %ebx
8010243e:	e8 ad 1e 00 00       	call   801042f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102443:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102448:	83 c4 10             	add    $0x10,%esp
8010244b:	85 c0                	test   %eax,%eax
8010244d:	74 05                	je     80102454 <ideintr+0x54>
    idestart(idequeue);
8010244f:	e8 5c fe ff ff       	call   801022b0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102454:	83 ec 0c             	sub    $0xc,%esp
80102457:	68 80 b5 10 80       	push   $0x8010b580
8010245c:	e8 bf 25 00 00       	call   80104a20 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102461:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102464:	5b                   	pop    %ebx
80102465:	5e                   	pop    %esi
80102466:	5f                   	pop    %edi
80102467:	5d                   	pop    %ebp
80102468:	c3                   	ret    
80102469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102470:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102475:	8d 76 00             	lea    0x0(%esi),%esi
80102478:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102479:	89 c1                	mov    %eax,%ecx
8010247b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010247e:	80 f9 40             	cmp    $0x40,%cl
80102481:	75 f5                	jne    80102478 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102483:	a8 21                	test   $0x21,%al
80102485:	75 ab                	jne    80102432 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102487:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010248a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010248f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102494:	fc                   	cld    
80102495:	f3 6d                	rep insl (%dx),%es:(%edi)
80102497:	8b 33                	mov    (%ebx),%esi
80102499:	eb 97                	jmp    80102432 <ideintr+0x32>
8010249b:	90                   	nop
8010249c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 10             	sub    $0x10,%esp
801024a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801024aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801024ad:	50                   	push   %eax
801024ae:	e8 0d 23 00 00       	call   801047c0 <holdingsleep>
801024b3:	83 c4 10             	add    $0x10,%esp
801024b6:	85 c0                	test   %eax,%eax
801024b8:	0f 84 ad 00 00 00    	je     8010256b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024be:	8b 03                	mov    (%ebx),%eax
801024c0:	83 e0 06             	and    $0x6,%eax
801024c3:	83 f8 02             	cmp    $0x2,%eax
801024c6:	0f 84 b9 00 00 00    	je     80102585 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024cc:	8b 53 04             	mov    0x4(%ebx),%edx
801024cf:	85 d2                	test   %edx,%edx
801024d1:	74 0d                	je     801024e0 <iderw+0x40>
801024d3:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801024d8:	85 c0                	test   %eax,%eax
801024da:	0f 84 98 00 00 00    	je     80102578 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801024e0:	83 ec 0c             	sub    $0xc,%esp
801024e3:	68 80 b5 10 80       	push   $0x8010b580
801024e8:	e8 83 24 00 00       	call   80104970 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024ed:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801024f3:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801024f6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024fd:	85 d2                	test   %edx,%edx
801024ff:	75 09                	jne    8010250a <iderw+0x6a>
80102501:	eb 58                	jmp    8010255b <iderw+0xbb>
80102503:	90                   	nop
80102504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102508:	89 c2                	mov    %eax,%edx
8010250a:	8b 42 58             	mov    0x58(%edx),%eax
8010250d:	85 c0                	test   %eax,%eax
8010250f:	75 f7                	jne    80102508 <iderw+0x68>
80102511:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102514:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102516:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
8010251c:	74 44                	je     80102562 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010251e:	8b 03                	mov    (%ebx),%eax
80102520:	83 e0 06             	and    $0x6,%eax
80102523:	83 f8 02             	cmp    $0x2,%eax
80102526:	74 23                	je     8010254b <iderw+0xab>
80102528:	90                   	nop
80102529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102530:	83 ec 08             	sub    $0x8,%esp
80102533:	68 80 b5 10 80       	push   $0x8010b580
80102538:	53                   	push   %ebx
80102539:	e8 f2 1b 00 00       	call   80104130 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010253e:	8b 03                	mov    (%ebx),%eax
80102540:	83 c4 10             	add    $0x10,%esp
80102543:	83 e0 06             	and    $0x6,%eax
80102546:	83 f8 02             	cmp    $0x2,%eax
80102549:	75 e5                	jne    80102530 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010254b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102552:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102555:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102556:	e9 c5 24 00 00       	jmp    80104a20 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010255b:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102560:	eb b2                	jmp    80102514 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102562:	89 d8                	mov    %ebx,%eax
80102564:	e8 47 fd ff ff       	call   801022b0 <idestart>
80102569:	eb b3                	jmp    8010251e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010256b:	83 ec 0c             	sub    $0xc,%esp
8010256e:	68 aa 79 10 80       	push   $0x801079aa
80102573:	e8 f8 dd ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102578:	83 ec 0c             	sub    $0xc,%esp
8010257b:	68 d5 79 10 80       	push   $0x801079d5
80102580:	e8 eb dd ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102585:	83 ec 0c             	sub    $0xc,%esp
80102588:	68 c0 79 10 80       	push   $0x801079c0
8010258d:	e8 de dd ff ff       	call   80100370 <panic>
80102592:	66 90                	xchg   %ax,%ax
80102594:	66 90                	xchg   %ax,%ax
80102596:	66 90                	xchg   %ax,%ax
80102598:	66 90                	xchg   %ax,%ax
8010259a:	66 90                	xchg   %ax,%ax
8010259c:	66 90                	xchg   %ax,%ax
8010259e:	66 90                	xchg   %ax,%ax

801025a0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025a0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025a1:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801025a8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025ab:	89 e5                	mov    %esp,%ebp
801025ad:	56                   	push   %esi
801025ae:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801025af:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025b6:	00 00 00 
  return ioapic->data;
801025b9:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801025bf:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801025c2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801025c8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025ce:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025d5:	89 f0                	mov    %esi,%eax
801025d7:	c1 e8 10             	shr    $0x10,%eax
801025da:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801025dd:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025e0:	c1 e8 18             	shr    $0x18,%eax
801025e3:	39 d0                	cmp    %edx,%eax
801025e5:	74 16                	je     801025fd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025e7:	83 ec 0c             	sub    $0xc,%esp
801025ea:	68 f4 79 10 80       	push   $0x801079f4
801025ef:	e8 6c e0 ff ff       	call   80100660 <cprintf>
801025f4:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801025fa:	83 c4 10             	add    $0x10,%esp
801025fd:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102600:	ba 10 00 00 00       	mov    $0x10,%edx
80102605:	b8 20 00 00 00       	mov    $0x20,%eax
8010260a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102610:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102612:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102618:	89 c3                	mov    %eax,%ebx
8010261a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102620:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102623:	89 59 10             	mov    %ebx,0x10(%ecx)
80102626:	8d 5a 01             	lea    0x1(%edx),%ebx
80102629:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010262c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010262e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102630:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102636:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010263d:	75 d1                	jne    80102610 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010263f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102642:	5b                   	pop    %ebx
80102643:	5e                   	pop    %esi
80102644:	5d                   	pop    %ebp
80102645:	c3                   	ret    
80102646:	8d 76 00             	lea    0x0(%esi),%esi
80102649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102650 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102650:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102651:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102657:	89 e5                	mov    %esp,%ebp
80102659:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010265c:	8d 50 20             	lea    0x20(%eax),%edx
8010265f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102663:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102665:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010266b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010266e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102671:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102674:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102676:	a1 34 36 11 80       	mov    0x80113634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010267b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010267e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102681:	5d                   	pop    %ebp
80102682:	c3                   	ret    
80102683:	66 90                	xchg   %ax,%ax
80102685:	66 90                	xchg   %ax,%ax
80102687:	66 90                	xchg   %ax,%ax
80102689:	66 90                	xchg   %ax,%ax
8010268b:	66 90                	xchg   %ax,%ax
8010268d:	66 90                	xchg   %ax,%ax
8010268f:	90                   	nop

80102690 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	53                   	push   %ebx
80102694:	83 ec 04             	sub    $0x4,%esp
80102697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010269a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801026a0:	75 70                	jne    80102712 <kfree+0x82>
801026a2:	81 fb a8 68 11 80    	cmp    $0x801168a8,%ebx
801026a8:	72 68                	jb     80102712 <kfree+0x82>
801026aa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026b0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026b5:	77 5b                	ja     80102712 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026b7:	83 ec 04             	sub    $0x4,%esp
801026ba:	68 00 10 00 00       	push   $0x1000
801026bf:	6a 01                	push   $0x1
801026c1:	53                   	push   %ebx
801026c2:	e8 a9 23 00 00       	call   80104a70 <memset>

  if(kmem.use_lock)
801026c7:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801026cd:	83 c4 10             	add    $0x10,%esp
801026d0:	85 d2                	test   %edx,%edx
801026d2:	75 2c                	jne    80102700 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026d4:	a1 78 36 11 80       	mov    0x80113678,%eax
801026d9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026db:	a1 74 36 11 80       	mov    0x80113674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801026e0:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801026e6:	85 c0                	test   %eax,%eax
801026e8:	75 06                	jne    801026f0 <kfree+0x60>
    release(&kmem.lock);
}
801026ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026ed:	c9                   	leave  
801026ee:	c3                   	ret    
801026ef:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801026f0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801026f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026fa:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801026fb:	e9 20 23 00 00       	jmp    80104a20 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102700:	83 ec 0c             	sub    $0xc,%esp
80102703:	68 40 36 11 80       	push   $0x80113640
80102708:	e8 63 22 00 00       	call   80104970 <acquire>
8010270d:	83 c4 10             	add    $0x10,%esp
80102710:	eb c2                	jmp    801026d4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102712:	83 ec 0c             	sub    $0xc,%esp
80102715:	68 26 7a 10 80       	push   $0x80107a26
8010271a:	e8 51 dc ff ff       	call   80100370 <panic>
8010271f:	90                   	nop

80102720 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	56                   	push   %esi
80102724:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102725:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102728:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010272b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102731:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102737:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010273d:	39 de                	cmp    %ebx,%esi
8010273f:	72 23                	jb     80102764 <freerange+0x44>
80102741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102748:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010274e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102751:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102757:	50                   	push   %eax
80102758:	e8 33 ff ff ff       	call   80102690 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010275d:	83 c4 10             	add    $0x10,%esp
80102760:	39 f3                	cmp    %esi,%ebx
80102762:	76 e4                	jbe    80102748 <freerange+0x28>
    kfree(p);
}
80102764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102767:	5b                   	pop    %ebx
80102768:	5e                   	pop    %esi
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	56                   	push   %esi
80102774:	53                   	push   %ebx
80102775:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102778:	83 ec 08             	sub    $0x8,%esp
8010277b:	68 2c 7a 10 80       	push   $0x80107a2c
80102780:	68 40 36 11 80       	push   $0x80113640
80102785:	e8 86 20 00 00       	call   80104810 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010278a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010278d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102790:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102797:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010279a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027ac:	39 de                	cmp    %ebx,%esi
801027ae:	72 1c                	jb     801027cc <kinit1+0x5c>
    kfree(p);
801027b0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027b6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027bf:	50                   	push   %eax
801027c0:	e8 cb fe ff ff       	call   80102690 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c5:	83 c4 10             	add    $0x10,%esp
801027c8:	39 de                	cmp    %ebx,%esi
801027ca:	73 e4                	jae    801027b0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801027cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027cf:	5b                   	pop    %ebx
801027d0:	5e                   	pop    %esi
801027d1:	5d                   	pop    %ebp
801027d2:	c3                   	ret    
801027d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027e0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	56                   	push   %esi
801027e4:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027e5:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801027e8:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027fd:	39 de                	cmp    %ebx,%esi
801027ff:	72 23                	jb     80102824 <kinit2+0x44>
80102801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102808:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010280e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102811:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102817:	50                   	push   %eax
80102818:	e8 73 fe ff ff       	call   80102690 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010281d:	83 c4 10             	add    $0x10,%esp
80102820:	39 de                	cmp    %ebx,%esi
80102822:	73 e4                	jae    80102808 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102824:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010282b:	00 00 00 
}
8010282e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102831:	5b                   	pop    %ebx
80102832:	5e                   	pop    %esi
80102833:	5d                   	pop    %ebp
80102834:	c3                   	ret    
80102835:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102840 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102840:	55                   	push   %ebp
80102841:	89 e5                	mov    %esp,%ebp
80102843:	53                   	push   %ebx
80102844:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102847:	a1 74 36 11 80       	mov    0x80113674,%eax
8010284c:	85 c0                	test   %eax,%eax
8010284e:	75 30                	jne    80102880 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102850:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
80102856:	85 db                	test   %ebx,%ebx
80102858:	74 1c                	je     80102876 <kalloc+0x36>
    kmem.freelist = r->next;
8010285a:	8b 13                	mov    (%ebx),%edx
8010285c:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
80102862:	85 c0                	test   %eax,%eax
80102864:	74 10                	je     80102876 <kalloc+0x36>
    release(&kmem.lock);
80102866:	83 ec 0c             	sub    $0xc,%esp
80102869:	68 40 36 11 80       	push   $0x80113640
8010286e:	e8 ad 21 00 00       	call   80104a20 <release>
80102873:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102876:	89 d8                	mov    %ebx,%eax
80102878:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010287b:	c9                   	leave  
8010287c:	c3                   	ret    
8010287d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102880:	83 ec 0c             	sub    $0xc,%esp
80102883:	68 40 36 11 80       	push   $0x80113640
80102888:	e8 e3 20 00 00       	call   80104970 <acquire>
  r = kmem.freelist;
8010288d:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
80102893:	83 c4 10             	add    $0x10,%esp
80102896:	a1 74 36 11 80       	mov    0x80113674,%eax
8010289b:	85 db                	test   %ebx,%ebx
8010289d:	75 bb                	jne    8010285a <kalloc+0x1a>
8010289f:	eb c1                	jmp    80102862 <kalloc+0x22>
801028a1:	66 90                	xchg   %ax,%ax
801028a3:	66 90                	xchg   %ax,%ax
801028a5:	66 90                	xchg   %ax,%ax
801028a7:	66 90                	xchg   %ax,%ax
801028a9:	66 90                	xchg   %ax,%ax
801028ab:	66 90                	xchg   %ax,%ax
801028ad:	66 90                	xchg   %ax,%ax
801028af:	90                   	nop

801028b0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801028b0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b1:	ba 64 00 00 00       	mov    $0x64,%edx
801028b6:	89 e5                	mov    %esp,%ebp
801028b8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028b9:	a8 01                	test   $0x1,%al
801028bb:	0f 84 af 00 00 00    	je     80102970 <kbdgetc+0xc0>
801028c1:	ba 60 00 00 00       	mov    $0x60,%edx
801028c6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801028c7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801028ca:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801028d0:	74 7e                	je     80102950 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028d2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028d4:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028da:	79 24                	jns    80102900 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028dc:	f6 c1 40             	test   $0x40,%cl
801028df:	75 05                	jne    801028e6 <kbdgetc+0x36>
801028e1:	89 c2                	mov    %eax,%edx
801028e3:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801028e6:	0f b6 82 60 7b 10 80 	movzbl -0x7fef84a0(%edx),%eax
801028ed:	83 c8 40             	or     $0x40,%eax
801028f0:	0f b6 c0             	movzbl %al,%eax
801028f3:	f7 d0                	not    %eax
801028f5:	21 c8                	and    %ecx,%eax
801028f7:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
801028fc:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801028fe:	5d                   	pop    %ebp
801028ff:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102900:	f6 c1 40             	test   $0x40,%cl
80102903:	74 09                	je     8010290e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102905:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102908:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010290b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010290e:	0f b6 82 60 7b 10 80 	movzbl -0x7fef84a0(%edx),%eax
80102915:	09 c1                	or     %eax,%ecx
80102917:	0f b6 82 60 7a 10 80 	movzbl -0x7fef85a0(%edx),%eax
8010291e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102920:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102922:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102928:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010292b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010292e:	8b 04 85 40 7a 10 80 	mov    -0x7fef85c0(,%eax,4),%eax
80102935:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102939:	74 c3                	je     801028fe <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010293b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010293e:	83 fa 19             	cmp    $0x19,%edx
80102941:	77 1d                	ja     80102960 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102943:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102946:	5d                   	pop    %ebp
80102947:	c3                   	ret    
80102948:	90                   	nop
80102949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102950:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102952:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102959:	5d                   	pop    %ebp
8010295a:	c3                   	ret    
8010295b:	90                   	nop
8010295c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102960:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102963:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102966:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102967:	83 f9 19             	cmp    $0x19,%ecx
8010296a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010296d:	c3                   	ret    
8010296e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102975:	5d                   	pop    %ebp
80102976:	c3                   	ret    
80102977:	89 f6                	mov    %esi,%esi
80102979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102980 <kbdintr>:

void
kbdintr(void)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102986:	68 b0 28 10 80       	push   $0x801028b0
8010298b:	e8 60 de ff ff       	call   801007f0 <consoleintr>
}
80102990:	83 c4 10             	add    $0x10,%esp
80102993:	c9                   	leave  
80102994:	c3                   	ret    
80102995:	66 90                	xchg   %ax,%ax
80102997:	66 90                	xchg   %ax,%ax
80102999:	66 90                	xchg   %ax,%ax
8010299b:	66 90                	xchg   %ax,%ax
8010299d:	66 90                	xchg   %ax,%ax
8010299f:	90                   	nop

801029a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029a0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801029a5:	55                   	push   %ebp
801029a6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029a8:	85 c0                	test   %eax,%eax
801029aa:	0f 84 c8 00 00 00    	je     80102a78 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029b0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029b7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ba:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029bd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029ca:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029d1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029d4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029d7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029de:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029e1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029e4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029eb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ee:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029f1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029fe:	8b 50 30             	mov    0x30(%eax),%edx
80102a01:	c1 ea 10             	shr    $0x10,%edx
80102a04:	80 fa 03             	cmp    $0x3,%dl
80102a07:	77 77                	ja     80102a80 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a09:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a10:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a13:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a16:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a1d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a20:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a23:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a2a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a30:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a37:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a3d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a47:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a4a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a51:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a54:	8b 50 20             	mov    0x20(%eax),%edx
80102a57:	89 f6                	mov    %esi,%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a60:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a66:	80 e6 10             	and    $0x10,%dh
80102a69:	75 f5                	jne    80102a60 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a6b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a72:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a75:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a78:	5d                   	pop    %ebp
80102a79:	c3                   	ret    
80102a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a80:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a87:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8a:	8b 50 20             	mov    0x20(%eax),%edx
80102a8d:	e9 77 ff ff ff       	jmp    80102a09 <lapicinit+0x69>
80102a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102aa0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102aa0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102aa5:	55                   	push   %ebp
80102aa6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102aa8:	85 c0                	test   %eax,%eax
80102aaa:	74 0c                	je     80102ab8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102aac:	8b 40 20             	mov    0x20(%eax),%eax
}
80102aaf:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102ab0:	c1 e8 18             	shr    $0x18,%eax
}
80102ab3:	c3                   	ret    
80102ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102ab8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
80102aba:	5d                   	pop    %ebp
80102abb:	c3                   	ret    
80102abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ac0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ac0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ac5:	55                   	push   %ebp
80102ac6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ac8:	85 c0                	test   %eax,%eax
80102aca:	74 0d                	je     80102ad9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102acc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ad3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102ad9:	5d                   	pop    %ebp
80102ada:	c3                   	ret    
80102adb:	90                   	nop
80102adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ae0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
}
80102ae3:	5d                   	pop    %ebp
80102ae4:	c3                   	ret    
80102ae5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102af0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102af0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af1:	ba 70 00 00 00       	mov    $0x70,%edx
80102af6:	b8 0f 00 00 00       	mov    $0xf,%eax
80102afb:	89 e5                	mov    %esp,%ebp
80102afd:	53                   	push   %ebx
80102afe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b04:	ee                   	out    %al,(%dx)
80102b05:	ba 71 00 00 00       	mov    $0x71,%edx
80102b0a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b0f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b10:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b12:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b15:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b1b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b1d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b20:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b23:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b25:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b28:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b2e:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102b33:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b39:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b3c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b43:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b46:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b49:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b50:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b53:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b56:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b5c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b5f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b65:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b68:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b6e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b71:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b77:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102b7a:	5b                   	pop    %ebx
80102b7b:	5d                   	pop    %ebp
80102b7c:	c3                   	ret    
80102b7d:	8d 76 00             	lea    0x0(%esi),%esi

80102b80 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b80:	55                   	push   %ebp
80102b81:	ba 70 00 00 00       	mov    $0x70,%edx
80102b86:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b8b:	89 e5                	mov    %esp,%ebp
80102b8d:	57                   	push   %edi
80102b8e:	56                   	push   %esi
80102b8f:	53                   	push   %ebx
80102b90:	83 ec 4c             	sub    $0x4c,%esp
80102b93:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b94:	ba 71 00 00 00       	mov    $0x71,%edx
80102b99:	ec                   	in     (%dx),%al
80102b9a:	83 e0 04             	and    $0x4,%eax
80102b9d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba0:	31 db                	xor    %ebx,%ebx
80102ba2:	88 45 b7             	mov    %al,-0x49(%ebp)
80102ba5:	bf 70 00 00 00       	mov    $0x70,%edi
80102baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bb0:	89 d8                	mov    %ebx,%eax
80102bb2:	89 fa                	mov    %edi,%edx
80102bb4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bba:	89 ca                	mov    %ecx,%edx
80102bbc:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102bbd:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc0:	89 fa                	mov    %edi,%edx
80102bc2:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102bc5:	b8 02 00 00 00       	mov    $0x2,%eax
80102bca:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcb:	89 ca                	mov    %ecx,%edx
80102bcd:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102bce:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd1:	89 fa                	mov    %edi,%edx
80102bd3:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102bd6:	b8 04 00 00 00       	mov    $0x4,%eax
80102bdb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdc:	89 ca                	mov    %ecx,%edx
80102bde:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102bdf:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be2:	89 fa                	mov    %edi,%edx
80102be4:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102be7:	b8 07 00 00 00       	mov    $0x7,%eax
80102bec:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bed:	89 ca                	mov    %ecx,%edx
80102bef:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102bf0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf3:	89 fa                	mov    %edi,%edx
80102bf5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102bf8:	b8 08 00 00 00       	mov    $0x8,%eax
80102bfd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfe:	89 ca                	mov    %ecx,%edx
80102c00:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102c01:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c04:	89 fa                	mov    %edi,%edx
80102c06:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102c09:	b8 09 00 00 00       	mov    $0x9,%eax
80102c0e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0f:	89 ca                	mov    %ecx,%edx
80102c11:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102c12:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c15:	89 fa                	mov    %edi,%edx
80102c17:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102c1a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c1f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c20:	89 ca                	mov    %ecx,%edx
80102c22:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c23:	84 c0                	test   %al,%al
80102c25:	78 89                	js     80102bb0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c27:	89 d8                	mov    %ebx,%eax
80102c29:	89 fa                	mov    %edi,%edx
80102c2b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2c:	89 ca                	mov    %ecx,%edx
80102c2e:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102c2f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c32:	89 fa                	mov    %edi,%edx
80102c34:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c37:	b8 02 00 00 00       	mov    $0x2,%eax
80102c3c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3d:	89 ca                	mov    %ecx,%edx
80102c3f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102c40:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c43:	89 fa                	mov    %edi,%edx
80102c45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c48:	b8 04 00 00 00       	mov    $0x4,%eax
80102c4d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4e:	89 ca                	mov    %ecx,%edx
80102c50:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102c51:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c54:	89 fa                	mov    %edi,%edx
80102c56:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c59:	b8 07 00 00 00       	mov    $0x7,%eax
80102c5e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5f:	89 ca                	mov    %ecx,%edx
80102c61:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102c62:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c65:	89 fa                	mov    %edi,%edx
80102c67:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c6a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c6f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c70:	89 ca                	mov    %ecx,%edx
80102c72:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102c73:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c76:	89 fa                	mov    %edi,%edx
80102c78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c7b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c80:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c81:	89 ca                	mov    %ecx,%edx
80102c83:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102c84:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c87:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102c8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c8d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c90:	6a 18                	push   $0x18
80102c92:	56                   	push   %esi
80102c93:	50                   	push   %eax
80102c94:	e8 27 1e 00 00       	call   80104ac0 <memcmp>
80102c99:	83 c4 10             	add    $0x10,%esp
80102c9c:	85 c0                	test   %eax,%eax
80102c9e:	0f 85 0c ff ff ff    	jne    80102bb0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102ca4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102ca8:	75 78                	jne    80102d22 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102caa:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cad:	89 c2                	mov    %eax,%edx
80102caf:	83 e0 0f             	and    $0xf,%eax
80102cb2:	c1 ea 04             	shr    $0x4,%edx
80102cb5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cb8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cbb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cbe:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cc1:	89 c2                	mov    %eax,%edx
80102cc3:	83 e0 0f             	and    $0xf,%eax
80102cc6:	c1 ea 04             	shr    $0x4,%edx
80102cc9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ccc:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ccf:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102cd2:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cd5:	89 c2                	mov    %eax,%edx
80102cd7:	83 e0 0f             	and    $0xf,%eax
80102cda:	c1 ea 04             	shr    $0x4,%edx
80102cdd:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ce0:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ce3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ce6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ce9:	89 c2                	mov    %eax,%edx
80102ceb:	83 e0 0f             	and    $0xf,%eax
80102cee:	c1 ea 04             	shr    $0x4,%edx
80102cf1:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cf4:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cf7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102cfa:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cfd:	89 c2                	mov    %eax,%edx
80102cff:	83 e0 0f             	and    $0xf,%eax
80102d02:	c1 ea 04             	shr    $0x4,%edx
80102d05:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d08:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d0b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d11:	89 c2                	mov    %eax,%edx
80102d13:	83 e0 0f             	and    $0xf,%eax
80102d16:	c1 ea 04             	shr    $0x4,%edx
80102d19:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d1c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d1f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d22:	8b 75 08             	mov    0x8(%ebp),%esi
80102d25:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d28:	89 06                	mov    %eax,(%esi)
80102d2a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d2d:	89 46 04             	mov    %eax,0x4(%esi)
80102d30:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d33:	89 46 08             	mov    %eax,0x8(%esi)
80102d36:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d39:	89 46 0c             	mov    %eax,0xc(%esi)
80102d3c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d3f:	89 46 10             	mov    %eax,0x10(%esi)
80102d42:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d45:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d48:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d52:	5b                   	pop    %ebx
80102d53:	5e                   	pop    %esi
80102d54:	5f                   	pop    %edi
80102d55:	5d                   	pop    %ebp
80102d56:	c3                   	ret    
80102d57:	66 90                	xchg   %ax,%ax
80102d59:	66 90                	xchg   %ax,%ax
80102d5b:	66 90                	xchg   %ax,%ax
80102d5d:	66 90                	xchg   %ax,%ax
80102d5f:	90                   	nop

80102d60 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d60:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102d66:	85 c9                	test   %ecx,%ecx
80102d68:	0f 8e 85 00 00 00    	jle    80102df3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102d6e:	55                   	push   %ebp
80102d6f:	89 e5                	mov    %esp,%ebp
80102d71:	57                   	push   %edi
80102d72:	56                   	push   %esi
80102d73:	53                   	push   %ebx
80102d74:	31 db                	xor    %ebx,%ebx
80102d76:	83 ec 0c             	sub    $0xc,%esp
80102d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d80:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102d85:	83 ec 08             	sub    $0x8,%esp
80102d88:	01 d8                	add    %ebx,%eax
80102d8a:	83 c0 01             	add    $0x1,%eax
80102d8d:	50                   	push   %eax
80102d8e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102d94:	e8 37 d3 ff ff       	call   801000d0 <bread>
80102d99:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d9b:	58                   	pop    %eax
80102d9c:	5a                   	pop    %edx
80102d9d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102da4:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102daa:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dad:	e8 1e d3 ff ff       	call   801000d0 <bread>
80102db2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102db4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102db7:	83 c4 0c             	add    $0xc,%esp
80102dba:	68 00 02 00 00       	push   $0x200
80102dbf:	50                   	push   %eax
80102dc0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dc3:	50                   	push   %eax
80102dc4:	e8 57 1d 00 00       	call   80104b20 <memmove>
    bwrite(dbuf);  // write dst to disk
80102dc9:	89 34 24             	mov    %esi,(%esp)
80102dcc:	e8 cf d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102dd1:	89 3c 24             	mov    %edi,(%esp)
80102dd4:	e8 07 d4 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102dd9:	89 34 24             	mov    %esi,(%esp)
80102ddc:	e8 ff d3 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102de1:	83 c4 10             	add    $0x10,%esp
80102de4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102dea:	7f 94                	jg     80102d80 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102def:	5b                   	pop    %ebx
80102df0:	5e                   	pop    %esi
80102df1:	5f                   	pop    %edi
80102df2:	5d                   	pop    %ebp
80102df3:	f3 c3                	repz ret 
80102df5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e00 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
80102e04:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e07:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102e0d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e13:	e8 b8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e18:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e1e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e21:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e23:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e25:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e28:	7e 1f                	jle    80102e49 <write_head+0x49>
80102e2a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102e31:	31 d2                	xor    %edx,%edx
80102e33:	90                   	nop
80102e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102e38:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102e3e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102e42:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e45:	39 c2                	cmp    %eax,%edx
80102e47:	75 ef                	jne    80102e38 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102e49:	83 ec 0c             	sub    $0xc,%esp
80102e4c:	53                   	push   %ebx
80102e4d:	e8 4e d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102e52:	89 1c 24             	mov    %ebx,(%esp)
80102e55:	e8 86 d3 ff ff       	call   801001e0 <brelse>
}
80102e5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e5d:	c9                   	leave  
80102e5e:	c3                   	ret    
80102e5f:	90                   	nop

80102e60 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	53                   	push   %ebx
80102e64:	83 ec 2c             	sub    $0x2c,%esp
80102e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102e6a:	68 60 7c 10 80       	push   $0x80107c60
80102e6f:	68 80 36 11 80       	push   $0x80113680
80102e74:	e8 97 19 00 00       	call   80104810 <initlock>
  readsb(dev, &sb);
80102e79:	58                   	pop    %eax
80102e7a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e7d:	5a                   	pop    %edx
80102e7e:	50                   	push   %eax
80102e7f:	53                   	push   %ebx
80102e80:	e8 5b e9 ff ff       	call   801017e0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102e85:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102e88:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e8b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102e8c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102e92:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102e98:	a3 b4 36 11 80       	mov    %eax,0x801136b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e9d:	5a                   	pop    %edx
80102e9e:	50                   	push   %eax
80102e9f:	53                   	push   %ebx
80102ea0:	e8 2b d2 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ea5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ea8:	83 c4 10             	add    $0x10,%esp
80102eab:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ead:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102eb3:	7e 1c                	jle    80102ed1 <initlog+0x71>
80102eb5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102ebc:	31 d2                	xor    %edx,%edx
80102ebe:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ec0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ec4:	83 c2 04             	add    $0x4,%edx
80102ec7:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ecd:	39 da                	cmp    %ebx,%edx
80102ecf:	75 ef                	jne    80102ec0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102ed1:	83 ec 0c             	sub    $0xc,%esp
80102ed4:	50                   	push   %eax
80102ed5:	e8 06 d3 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102eda:	e8 81 fe ff ff       	call   80102d60 <install_trans>
  log.lh.n = 0;
80102edf:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ee6:	00 00 00 
  write_head(); // clear the log
80102ee9:	e8 12 ff ff ff       	call   80102e00 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102eee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ef1:	c9                   	leave  
80102ef2:	c3                   	ret    
80102ef3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f00 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f06:	68 80 36 11 80       	push   $0x80113680
80102f0b:	e8 60 1a 00 00       	call   80104970 <acquire>
80102f10:	83 c4 10             	add    $0x10,%esp
80102f13:	eb 18                	jmp    80102f2d <begin_op+0x2d>
80102f15:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f18:	83 ec 08             	sub    $0x8,%esp
80102f1b:	68 80 36 11 80       	push   $0x80113680
80102f20:	68 80 36 11 80       	push   $0x80113680
80102f25:	e8 06 12 00 00       	call   80104130 <sleep>
80102f2a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102f2d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102f32:	85 c0                	test   %eax,%eax
80102f34:	75 e2                	jne    80102f18 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f36:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f3b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f41:	83 c0 01             	add    $0x1,%eax
80102f44:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f47:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f4a:	83 fa 1e             	cmp    $0x1e,%edx
80102f4d:	7f c9                	jg     80102f18 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f4f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102f52:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102f57:	68 80 36 11 80       	push   $0x80113680
80102f5c:	e8 bf 1a 00 00       	call   80104a20 <release>
      break;
    }
  }
}
80102f61:	83 c4 10             	add    $0x10,%esp
80102f64:	c9                   	leave  
80102f65:	c3                   	ret    
80102f66:	8d 76 00             	lea    0x0(%esi),%esi
80102f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f70 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	57                   	push   %edi
80102f74:	56                   	push   %esi
80102f75:	53                   	push   %ebx
80102f76:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f79:	68 80 36 11 80       	push   $0x80113680
80102f7e:	e8 ed 19 00 00       	call   80104970 <acquire>
  log.outstanding -= 1;
80102f83:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102f88:	8b 1d c0 36 11 80    	mov    0x801136c0,%ebx
80102f8e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102f91:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102f94:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102f96:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  if(log.committing)
80102f9b:	0f 85 23 01 00 00    	jne    801030c4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fa1:	85 c0                	test   %eax,%eax
80102fa3:	0f 85 f7 00 00 00    	jne    801030a0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fa9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102fac:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102fb3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fb6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fb8:	68 80 36 11 80       	push   $0x80113680
80102fbd:	e8 5e 1a 00 00       	call   80104a20 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fc2:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102fc8:	83 c4 10             	add    $0x10,%esp
80102fcb:	85 c9                	test   %ecx,%ecx
80102fcd:	0f 8e 8a 00 00 00    	jle    8010305d <end_op+0xed>
80102fd3:	90                   	nop
80102fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fd8:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102fdd:	83 ec 08             	sub    $0x8,%esp
80102fe0:	01 d8                	add    %ebx,%eax
80102fe2:	83 c0 01             	add    $0x1,%eax
80102fe5:	50                   	push   %eax
80102fe6:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102fec:	e8 df d0 ff ff       	call   801000d0 <bread>
80102ff1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ff3:	58                   	pop    %eax
80102ff4:	5a                   	pop    %edx
80102ff5:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102ffc:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103002:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103005:	e8 c6 d0 ff ff       	call   801000d0 <bread>
8010300a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
8010300c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010300f:	83 c4 0c             	add    $0xc,%esp
80103012:	68 00 02 00 00       	push   $0x200
80103017:	50                   	push   %eax
80103018:	8d 46 5c             	lea    0x5c(%esi),%eax
8010301b:	50                   	push   %eax
8010301c:	e8 ff 1a 00 00       	call   80104b20 <memmove>
    bwrite(to);  // write the log
80103021:	89 34 24             	mov    %esi,(%esp)
80103024:	e8 77 d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103029:	89 3c 24             	mov    %edi,(%esp)
8010302c:	e8 af d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
80103031:	89 34 24             	mov    %esi,(%esp)
80103034:	e8 a7 d1 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103039:	83 c4 10             	add    $0x10,%esp
8010303c:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80103042:	7c 94                	jl     80102fd8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80103044:	e8 b7 fd ff ff       	call   80102e00 <write_head>
    install_trans(); // Now install writes to home locations
80103049:	e8 12 fd ff ff       	call   80102d60 <install_trans>
    log.lh.n = 0;
8010304e:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80103055:	00 00 00 
    write_head();    // Erase the transaction from the log
80103058:	e8 a3 fd ff ff       	call   80102e00 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
8010305d:	83 ec 0c             	sub    $0xc,%esp
80103060:	68 80 36 11 80       	push   $0x80113680
80103065:	e8 06 19 00 00       	call   80104970 <acquire>
    log.committing = 0;
    wakeup(&log);
8010306a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80103071:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80103078:	00 00 00 
    wakeup(&log);
8010307b:	e8 70 12 00 00       	call   801042f0 <wakeup>
    release(&log.lock);
80103080:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103087:	e8 94 19 00 00       	call   80104a20 <release>
8010308c:	83 c4 10             	add    $0x10,%esp
  }
}
8010308f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103092:	5b                   	pop    %ebx
80103093:	5e                   	pop    %esi
80103094:	5f                   	pop    %edi
80103095:	5d                   	pop    %ebp
80103096:	c3                   	ret    
80103097:	89 f6                	mov    %esi,%esi
80103099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801030a0:	83 ec 0c             	sub    $0xc,%esp
801030a3:	68 80 36 11 80       	push   $0x80113680
801030a8:	e8 43 12 00 00       	call   801042f0 <wakeup>
  }
  release(&log.lock);
801030ad:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801030b4:	e8 67 19 00 00       	call   80104a20 <release>
801030b9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
801030bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030bf:	5b                   	pop    %ebx
801030c0:	5e                   	pop    %esi
801030c1:	5f                   	pop    %edi
801030c2:	5d                   	pop    %ebp
801030c3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
801030c4:	83 ec 0c             	sub    $0xc,%esp
801030c7:	68 64 7c 10 80       	push   $0x80107c64
801030cc:	e8 9f d2 ff ff       	call   80100370 <panic>
801030d1:	eb 0d                	jmp    801030e0 <log_write>
801030d3:	90                   	nop
801030d4:	90                   	nop
801030d5:	90                   	nop
801030d6:	90                   	nop
801030d7:	90                   	nop
801030d8:	90                   	nop
801030d9:	90                   	nop
801030da:	90                   	nop
801030db:	90                   	nop
801030dc:	90                   	nop
801030dd:	90                   	nop
801030de:	90                   	nop
801030df:	90                   	nop

801030e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	53                   	push   %ebx
801030e4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030e7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030f0:	83 fa 1d             	cmp    $0x1d,%edx
801030f3:	0f 8f 97 00 00 00    	jg     80103190 <log_write+0xb0>
801030f9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
801030fe:	83 e8 01             	sub    $0x1,%eax
80103101:	39 c2                	cmp    %eax,%edx
80103103:	0f 8d 87 00 00 00    	jge    80103190 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103109:	a1 bc 36 11 80       	mov    0x801136bc,%eax
8010310e:	85 c0                	test   %eax,%eax
80103110:	0f 8e 87 00 00 00    	jle    8010319d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103116:	83 ec 0c             	sub    $0xc,%esp
80103119:	68 80 36 11 80       	push   $0x80113680
8010311e:	e8 4d 18 00 00       	call   80104970 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103123:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80103129:	83 c4 10             	add    $0x10,%esp
8010312c:	83 fa 00             	cmp    $0x0,%edx
8010312f:	7e 50                	jle    80103181 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103131:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103134:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103136:	3b 0d cc 36 11 80    	cmp    0x801136cc,%ecx
8010313c:	75 0b                	jne    80103149 <log_write+0x69>
8010313e:	eb 38                	jmp    80103178 <log_write+0x98>
80103140:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80103147:	74 2f                	je     80103178 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103149:	83 c0 01             	add    $0x1,%eax
8010314c:	39 d0                	cmp    %edx,%eax
8010314e:	75 f0                	jne    80103140 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103150:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103157:	83 c2 01             	add    $0x1,%edx
8010315a:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80103160:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103163:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
8010316a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010316d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
8010316e:	e9 ad 18 00 00       	jmp    80104a20 <release>
80103173:	90                   	nop
80103174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103178:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
8010317f:	eb df                	jmp    80103160 <log_write+0x80>
80103181:	8b 43 08             	mov    0x8(%ebx),%eax
80103184:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80103189:	75 d5                	jne    80103160 <log_write+0x80>
8010318b:	eb ca                	jmp    80103157 <log_write+0x77>
8010318d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80103190:	83 ec 0c             	sub    $0xc,%esp
80103193:	68 73 7c 10 80       	push   $0x80107c73
80103198:	e8 d3 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
8010319d:	83 ec 0c             	sub    $0xc,%esp
801031a0:	68 89 7c 10 80       	push   $0x80107c89
801031a5:	e8 c6 d1 ff ff       	call   80100370 <panic>
801031aa:	66 90                	xchg   %ax,%ax
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	53                   	push   %ebx
801031b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031b7:	e8 84 09 00 00       	call   80103b40 <cpuid>
801031bc:	89 c3                	mov    %eax,%ebx
801031be:	e8 7d 09 00 00       	call   80103b40 <cpuid>
801031c3:	83 ec 04             	sub    $0x4,%esp
801031c6:	53                   	push   %ebx
801031c7:	50                   	push   %eax
801031c8:	68 a4 7c 10 80       	push   $0x80107ca4
801031cd:	e8 8e d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801031d2:	e8 89 2d 00 00       	call   80105f60 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031d7:	e8 e4 08 00 00       	call   80103ac0 <mycpu>
801031dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031de:	b8 01 00 00 00       	mov    $0x1,%eax
801031e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031ea:	e8 51 0c 00 00       	call   80103e40 <scheduler>
801031ef:	90                   	nop

801031f0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031f6:	e8 85 3e 00 00       	call   80107080 <switchkvm>
  seginit();
801031fb:	e8 80 3d 00 00       	call   80106f80 <seginit>
  lapicinit();
80103200:	e8 9b f7 ff ff       	call   801029a0 <lapicinit>
  mpmain();
80103205:	e8 a6 ff ff ff       	call   801031b0 <mpmain>
8010320a:	66 90                	xchg   %ax,%ax
8010320c:	66 90                	xchg   %ax,%ax
8010320e:	66 90                	xchg   %ax,%ax

80103210 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103210:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103214:	83 e4 f0             	and    $0xfffffff0,%esp
80103217:	ff 71 fc             	pushl  -0x4(%ecx)
8010321a:	55                   	push   %ebp
8010321b:	89 e5                	mov    %esp,%ebp
8010321d:	53                   	push   %ebx
8010321e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010321f:	bb 80 37 11 80       	mov    $0x80113780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103224:	83 ec 08             	sub    $0x8,%esp
80103227:	68 00 00 40 80       	push   $0x80400000
8010322c:	68 a8 68 11 80       	push   $0x801168a8
80103231:	e8 3a f5 ff ff       	call   80102770 <kinit1>
  kvmalloc();      // kernel page table
80103236:	e8 e5 42 00 00       	call   80107520 <kvmalloc>
  mpinit();        // detect other processors
8010323b:	e8 70 01 00 00       	call   801033b0 <mpinit>
  lapicinit();     // interrupt controller
80103240:	e8 5b f7 ff ff       	call   801029a0 <lapicinit>
  seginit();       // segment descriptors
80103245:	e8 36 3d 00 00       	call   80106f80 <seginit>
  picinit();       // disable pic
8010324a:	e8 31 03 00 00       	call   80103580 <picinit>
  ioapicinit();    // another interrupt controller
8010324f:	e8 4c f3 ff ff       	call   801025a0 <ioapicinit>
  consoleinit();   // console hardware
80103254:	e8 47 d7 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103259:	e8 f2 2f 00 00       	call   80106250 <uartinit>
  pinit();         // process table
8010325e:	e8 3d 08 00 00       	call   80103aa0 <pinit>
  tvinit();        // trap vectors
80103263:	e8 58 2c 00 00       	call   80105ec0 <tvinit>
  binit();         // buffer cache
80103268:	e8 d3 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010326d:	e8 9e de ff ff       	call   80101110 <fileinit>
  ideinit();       // disk 
80103272:	e8 09 f1 ff ff       	call   80102380 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103277:	83 c4 0c             	add    $0xc,%esp
8010327a:	68 8a 00 00 00       	push   $0x8a
8010327f:	68 8c b4 10 80       	push   $0x8010b48c
80103284:	68 00 70 00 80       	push   $0x80007000
80103289:	e8 92 18 00 00       	call   80104b20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010328e:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103295:	00 00 00 
80103298:	83 c4 10             	add    $0x10,%esp
8010329b:	05 80 37 11 80       	add    $0x80113780,%eax
801032a0:	39 d8                	cmp    %ebx,%eax
801032a2:	76 6f                	jbe    80103313 <main+0x103>
801032a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
801032a8:	e8 13 08 00 00       	call   80103ac0 <mycpu>
801032ad:	39 d8                	cmp    %ebx,%eax
801032af:	74 49                	je     801032fa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032b1:	e8 8a f5 ff ff       	call   80102840 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801032b6:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801032bb:	c7 05 f8 6f 00 80 f0 	movl   $0x801031f0,0x80006ff8
801032c2:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032c5:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801032cc:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
801032cf:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032d4:	0f b6 03             	movzbl (%ebx),%eax
801032d7:	83 ec 08             	sub    $0x8,%esp
801032da:	68 00 70 00 00       	push   $0x7000
801032df:	50                   	push   %eax
801032e0:	e8 0b f8 ff ff       	call   80102af0 <lapicstartap>
801032e5:	83 c4 10             	add    $0x10,%esp
801032e8:	90                   	nop
801032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032f6:	85 c0                	test   %eax,%eax
801032f8:	74 f6                	je     801032f0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801032fa:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103301:	00 00 00 
80103304:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010330a:	05 80 37 11 80       	add    $0x80113780,%eax
8010330f:	39 c3                	cmp    %eax,%ebx
80103311:	72 95                	jb     801032a8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103313:	83 ec 08             	sub    $0x8,%esp
80103316:	68 00 00 00 8e       	push   $0x8e000000
8010331b:	68 00 00 40 80       	push   $0x80400000
80103320:	e8 bb f4 ff ff       	call   801027e0 <kinit2>
  userinit();      // first user process
80103325:	e8 66 08 00 00       	call   80103b90 <userinit>
  mpmain();        // finish this processor's setup
8010332a:	e8 81 fe ff ff       	call   801031b0 <mpmain>
8010332f:	90                   	nop

80103330 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	57                   	push   %edi
80103334:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103335:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010333b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010333c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010333f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103342:	39 de                	cmp    %ebx,%esi
80103344:	73 48                	jae    8010338e <mpsearch1+0x5e>
80103346:	8d 76 00             	lea    0x0(%esi),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103350:	83 ec 04             	sub    $0x4,%esp
80103353:	8d 7e 10             	lea    0x10(%esi),%edi
80103356:	6a 04                	push   $0x4
80103358:	68 b8 7c 10 80       	push   $0x80107cb8
8010335d:	56                   	push   %esi
8010335e:	e8 5d 17 00 00       	call   80104ac0 <memcmp>
80103363:	83 c4 10             	add    $0x10,%esp
80103366:	85 c0                	test   %eax,%eax
80103368:	75 1e                	jne    80103388 <mpsearch1+0x58>
8010336a:	8d 7e 10             	lea    0x10(%esi),%edi
8010336d:	89 f2                	mov    %esi,%edx
8010336f:	31 c9                	xor    %ecx,%ecx
80103371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103378:	0f b6 02             	movzbl (%edx),%eax
8010337b:	83 c2 01             	add    $0x1,%edx
8010337e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103380:	39 fa                	cmp    %edi,%edx
80103382:	75 f4                	jne    80103378 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103384:	84 c9                	test   %cl,%cl
80103386:	74 10                	je     80103398 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103388:	39 fb                	cmp    %edi,%ebx
8010338a:	89 fe                	mov    %edi,%esi
8010338c:	77 c2                	ja     80103350 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010338e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103391:	31 c0                	xor    %eax,%eax
}
80103393:	5b                   	pop    %ebx
80103394:	5e                   	pop    %esi
80103395:	5f                   	pop    %edi
80103396:	5d                   	pop    %ebp
80103397:	c3                   	ret    
80103398:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010339b:	89 f0                	mov    %esi,%eax
8010339d:	5b                   	pop    %ebx
8010339e:	5e                   	pop    %esi
8010339f:	5f                   	pop    %edi
801033a0:	5d                   	pop    %ebp
801033a1:	c3                   	ret    
801033a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	57                   	push   %edi
801033b4:	56                   	push   %esi
801033b5:	53                   	push   %ebx
801033b6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033c7:	c1 e0 08             	shl    $0x8,%eax
801033ca:	09 d0                	or     %edx,%eax
801033cc:	c1 e0 04             	shl    $0x4,%eax
801033cf:	85 c0                	test   %eax,%eax
801033d1:	75 1b                	jne    801033ee <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801033d3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033da:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033e1:	c1 e0 08             	shl    $0x8,%eax
801033e4:	09 d0                	or     %edx,%eax
801033e6:	c1 e0 0a             	shl    $0xa,%eax
801033e9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801033ee:	ba 00 04 00 00       	mov    $0x400,%edx
801033f3:	e8 38 ff ff ff       	call   80103330 <mpsearch1>
801033f8:	85 c0                	test   %eax,%eax
801033fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801033fd:	0f 84 37 01 00 00    	je     8010353a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103406:	8b 58 04             	mov    0x4(%eax),%ebx
80103409:	85 db                	test   %ebx,%ebx
8010340b:	0f 84 43 01 00 00    	je     80103554 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103411:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103417:	83 ec 04             	sub    $0x4,%esp
8010341a:	6a 04                	push   $0x4
8010341c:	68 bd 7c 10 80       	push   $0x80107cbd
80103421:	56                   	push   %esi
80103422:	e8 99 16 00 00       	call   80104ac0 <memcmp>
80103427:	83 c4 10             	add    $0x10,%esp
8010342a:	85 c0                	test   %eax,%eax
8010342c:	0f 85 22 01 00 00    	jne    80103554 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103432:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103439:	3c 01                	cmp    $0x1,%al
8010343b:	74 08                	je     80103445 <mpinit+0x95>
8010343d:	3c 04                	cmp    $0x4,%al
8010343f:	0f 85 0f 01 00 00    	jne    80103554 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103445:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010344c:	85 ff                	test   %edi,%edi
8010344e:	74 21                	je     80103471 <mpinit+0xc1>
80103450:	31 d2                	xor    %edx,%edx
80103452:	31 c0                	xor    %eax,%eax
80103454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103458:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010345f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103460:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103463:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103465:	39 c7                	cmp    %eax,%edi
80103467:	75 ef                	jne    80103458 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103469:	84 d2                	test   %dl,%dl
8010346b:	0f 85 e3 00 00 00    	jne    80103554 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103471:	85 f6                	test   %esi,%esi
80103473:	0f 84 db 00 00 00    	je     80103554 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103479:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010347f:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103484:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010348b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103491:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103496:	01 d6                	add    %edx,%esi
80103498:	90                   	nop
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034a0:	39 c6                	cmp    %eax,%esi
801034a2:	76 23                	jbe    801034c7 <mpinit+0x117>
801034a4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801034a7:	80 fa 04             	cmp    $0x4,%dl
801034aa:	0f 87 c0 00 00 00    	ja     80103570 <mpinit+0x1c0>
801034b0:	ff 24 95 fc 7c 10 80 	jmp    *-0x7fef8304(,%edx,4)
801034b7:	89 f6                	mov    %esi,%esi
801034b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034c0:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034c3:	39 c6                	cmp    %eax,%esi
801034c5:	77 dd                	ja     801034a4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034c7:	85 db                	test   %ebx,%ebx
801034c9:	0f 84 92 00 00 00    	je     80103561 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034d2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801034d6:	74 15                	je     801034ed <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034d8:	ba 22 00 00 00       	mov    $0x22,%edx
801034dd:	b8 70 00 00 00       	mov    $0x70,%eax
801034e2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034e3:	ba 23 00 00 00       	mov    $0x23,%edx
801034e8:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034e9:	83 c8 01             	or     $0x1,%eax
801034ec:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801034ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034f0:	5b                   	pop    %ebx
801034f1:	5e                   	pop    %esi
801034f2:	5f                   	pop    %edi
801034f3:	5d                   	pop    %ebp
801034f4:	c3                   	ret    
801034f5:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801034f8:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801034fe:	83 f9 07             	cmp    $0x7,%ecx
80103501:	7f 19                	jg     8010351c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103503:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103507:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010350d:	83 c1 01             	add    $0x1,%ecx
80103510:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103516:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010351c:	83 c0 14             	add    $0x14,%eax
      continue;
8010351f:	e9 7c ff ff ff       	jmp    801034a0 <mpinit+0xf0>
80103524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103528:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010352c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010352f:	88 15 60 37 11 80    	mov    %dl,0x80113760
      p += sizeof(struct mpioapic);
      continue;
80103535:	e9 66 ff ff ff       	jmp    801034a0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010353a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010353f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103544:	e8 e7 fd ff ff       	call   80103330 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103549:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010354b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010354e:	0f 85 af fe ff ff    	jne    80103403 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103554:	83 ec 0c             	sub    $0xc,%esp
80103557:	68 c2 7c 10 80       	push   $0x80107cc2
8010355c:	e8 0f ce ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103561:	83 ec 0c             	sub    $0xc,%esp
80103564:	68 dc 7c 10 80       	push   $0x80107cdc
80103569:	e8 02 ce ff ff       	call   80100370 <panic>
8010356e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103570:	31 db                	xor    %ebx,%ebx
80103572:	e9 30 ff ff ff       	jmp    801034a7 <mpinit+0xf7>
80103577:	66 90                	xchg   %ax,%ax
80103579:	66 90                	xchg   %ax,%ax
8010357b:	66 90                	xchg   %ax,%ax
8010357d:	66 90                	xchg   %ax,%ax
8010357f:	90                   	nop

80103580 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103580:	55                   	push   %ebp
80103581:	ba 21 00 00 00       	mov    $0x21,%edx
80103586:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010358b:	89 e5                	mov    %esp,%ebp
8010358d:	ee                   	out    %al,(%dx)
8010358e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103593:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103594:	5d                   	pop    %ebp
80103595:	c3                   	ret    
80103596:	66 90                	xchg   %ax,%ax
80103598:	66 90                	xchg   %ax,%ax
8010359a:	66 90                	xchg   %ax,%ax
8010359c:	66 90                	xchg   %ax,%ax
8010359e:	66 90                	xchg   %ax,%ax

801035a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	57                   	push   %edi
801035a4:	56                   	push   %esi
801035a5:	53                   	push   %ebx
801035a6:	83 ec 0c             	sub    $0xc,%esp
801035a9:	8b 75 08             	mov    0x8(%ebp),%esi
801035ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801035b5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035bb:	e8 70 db ff ff       	call   80101130 <filealloc>
801035c0:	85 c0                	test   %eax,%eax
801035c2:	89 06                	mov    %eax,(%esi)
801035c4:	0f 84 a8 00 00 00    	je     80103672 <pipealloc+0xd2>
801035ca:	e8 61 db ff ff       	call   80101130 <filealloc>
801035cf:	85 c0                	test   %eax,%eax
801035d1:	89 03                	mov    %eax,(%ebx)
801035d3:	0f 84 87 00 00 00    	je     80103660 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035d9:	e8 62 f2 ff ff       	call   80102840 <kalloc>
801035de:	85 c0                	test   %eax,%eax
801035e0:	89 c7                	mov    %eax,%edi
801035e2:	0f 84 b0 00 00 00    	je     80103698 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035e8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801035eb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035f2:	00 00 00 
  p->writeopen = 1;
801035f5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035fc:	00 00 00 
  p->nwrite = 0;
801035ff:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103606:	00 00 00 
  p->nread = 0;
80103609:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103610:	00 00 00 
  initlock(&p->lock, "pipe");
80103613:	68 10 7d 10 80       	push   $0x80107d10
80103618:	50                   	push   %eax
80103619:	e8 f2 11 00 00       	call   80104810 <initlock>
  (*f0)->type = FD_PIPE;
8010361e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103620:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103623:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103629:	8b 06                	mov    (%esi),%eax
8010362b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010362f:	8b 06                	mov    (%esi),%eax
80103631:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103635:	8b 06                	mov    (%esi),%eax
80103637:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010363a:	8b 03                	mov    (%ebx),%eax
8010363c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103642:	8b 03                	mov    (%ebx),%eax
80103644:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103648:	8b 03                	mov    (%ebx),%eax
8010364a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010364e:	8b 03                	mov    (%ebx),%eax
80103650:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103653:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103656:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103658:	5b                   	pop    %ebx
80103659:	5e                   	pop    %esi
8010365a:	5f                   	pop    %edi
8010365b:	5d                   	pop    %ebp
8010365c:	c3                   	ret    
8010365d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103660:	8b 06                	mov    (%esi),%eax
80103662:	85 c0                	test   %eax,%eax
80103664:	74 1e                	je     80103684 <pipealloc+0xe4>
    fileclose(*f0);
80103666:	83 ec 0c             	sub    $0xc,%esp
80103669:	50                   	push   %eax
8010366a:	e8 81 db ff ff       	call   801011f0 <fileclose>
8010366f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103672:	8b 03                	mov    (%ebx),%eax
80103674:	85 c0                	test   %eax,%eax
80103676:	74 0c                	je     80103684 <pipealloc+0xe4>
    fileclose(*f1);
80103678:	83 ec 0c             	sub    $0xc,%esp
8010367b:	50                   	push   %eax
8010367c:	e8 6f db ff ff       	call   801011f0 <fileclose>
80103681:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103684:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103687:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010368c:	5b                   	pop    %ebx
8010368d:	5e                   	pop    %esi
8010368e:	5f                   	pop    %edi
8010368f:	5d                   	pop    %ebp
80103690:	c3                   	ret    
80103691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103698:	8b 06                	mov    (%esi),%eax
8010369a:	85 c0                	test   %eax,%eax
8010369c:	75 c8                	jne    80103666 <pipealloc+0xc6>
8010369e:	eb d2                	jmp    80103672 <pipealloc+0xd2>

801036a0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	56                   	push   %esi
801036a4:	53                   	push   %ebx
801036a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036ab:	83 ec 0c             	sub    $0xc,%esp
801036ae:	53                   	push   %ebx
801036af:	e8 bc 12 00 00       	call   80104970 <acquire>
  if(writable){
801036b4:	83 c4 10             	add    $0x10,%esp
801036b7:	85 f6                	test   %esi,%esi
801036b9:	74 45                	je     80103700 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801036bb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036c1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801036c4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036cb:	00 00 00 
    wakeup(&p->nread);
801036ce:	50                   	push   %eax
801036cf:	e8 1c 0c 00 00       	call   801042f0 <wakeup>
801036d4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036d7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036dd:	85 d2                	test   %edx,%edx
801036df:	75 0a                	jne    801036eb <pipeclose+0x4b>
801036e1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036e7:	85 c0                	test   %eax,%eax
801036e9:	74 35                	je     80103720 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036eb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036f1:	5b                   	pop    %ebx
801036f2:	5e                   	pop    %esi
801036f3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036f4:	e9 27 13 00 00       	jmp    80104a20 <release>
801036f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103700:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103706:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103709:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103710:	00 00 00 
    wakeup(&p->nwrite);
80103713:	50                   	push   %eax
80103714:	e8 d7 0b 00 00       	call   801042f0 <wakeup>
80103719:	83 c4 10             	add    $0x10,%esp
8010371c:	eb b9                	jmp    801036d7 <pipeclose+0x37>
8010371e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103720:	83 ec 0c             	sub    $0xc,%esp
80103723:	53                   	push   %ebx
80103724:	e8 f7 12 00 00       	call   80104a20 <release>
    kfree((char*)p);
80103729:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010372c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010372f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103732:	5b                   	pop    %ebx
80103733:	5e                   	pop    %esi
80103734:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103735:	e9 56 ef ff ff       	jmp    80102690 <kfree>
8010373a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103740 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	57                   	push   %edi
80103744:	56                   	push   %esi
80103745:	53                   	push   %ebx
80103746:	83 ec 28             	sub    $0x28,%esp
80103749:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010374c:	53                   	push   %ebx
8010374d:	e8 1e 12 00 00       	call   80104970 <acquire>
  for(i = 0; i < n; i++){
80103752:	8b 45 10             	mov    0x10(%ebp),%eax
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	85 c0                	test   %eax,%eax
8010375a:	0f 8e b9 00 00 00    	jle    80103819 <pipewrite+0xd9>
80103760:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103763:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103769:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010376f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103775:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103778:	03 4d 10             	add    0x10(%ebp),%ecx
8010377b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010377e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103784:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010378a:	39 d0                	cmp    %edx,%eax
8010378c:	74 38                	je     801037c6 <pipewrite+0x86>
8010378e:	eb 59                	jmp    801037e9 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103790:	e8 cb 03 00 00       	call   80103b60 <myproc>
80103795:	8b 48 24             	mov    0x24(%eax),%ecx
80103798:	85 c9                	test   %ecx,%ecx
8010379a:	75 34                	jne    801037d0 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010379c:	83 ec 0c             	sub    $0xc,%esp
8010379f:	57                   	push   %edi
801037a0:	e8 4b 0b 00 00       	call   801042f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037a5:	58                   	pop    %eax
801037a6:	5a                   	pop    %edx
801037a7:	53                   	push   %ebx
801037a8:	56                   	push   %esi
801037a9:	e8 82 09 00 00       	call   80104130 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037ae:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037b4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037ba:	83 c4 10             	add    $0x10,%esp
801037bd:	05 00 02 00 00       	add    $0x200,%eax
801037c2:	39 c2                	cmp    %eax,%edx
801037c4:	75 2a                	jne    801037f0 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
801037c6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037cc:	85 c0                	test   %eax,%eax
801037ce:	75 c0                	jne    80103790 <pipewrite+0x50>
        release(&p->lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
801037d3:	53                   	push   %ebx
801037d4:	e8 47 12 00 00       	call   80104a20 <release>
        return -1;
801037d9:	83 c4 10             	add    $0x10,%esp
801037dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e4:	5b                   	pop    %ebx
801037e5:	5e                   	pop    %esi
801037e6:	5f                   	pop    %edi
801037e7:	5d                   	pop    %ebp
801037e8:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037e9:	89 c2                	mov    %eax,%edx
801037eb:	90                   	nop
801037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801037f3:	8d 42 01             	lea    0x1(%edx),%eax
801037f6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801037fa:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103800:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103806:	0f b6 09             	movzbl (%ecx),%ecx
80103809:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010380d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103810:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103813:	0f 85 65 ff ff ff    	jne    8010377e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103819:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010381f:	83 ec 0c             	sub    $0xc,%esp
80103822:	50                   	push   %eax
80103823:	e8 c8 0a 00 00       	call   801042f0 <wakeup>
  release(&p->lock);
80103828:	89 1c 24             	mov    %ebx,(%esp)
8010382b:	e8 f0 11 00 00       	call   80104a20 <release>
  return n;
80103830:	83 c4 10             	add    $0x10,%esp
80103833:	8b 45 10             	mov    0x10(%ebp),%eax
80103836:	eb a9                	jmp    801037e1 <pipewrite+0xa1>
80103838:	90                   	nop
80103839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103840 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	57                   	push   %edi
80103844:	56                   	push   %esi
80103845:	53                   	push   %ebx
80103846:	83 ec 18             	sub    $0x18,%esp
80103849:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010384c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010384f:	53                   	push   %ebx
80103850:	e8 1b 11 00 00       	call   80104970 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103855:	83 c4 10             	add    $0x10,%esp
80103858:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010385e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103864:	75 6a                	jne    801038d0 <piperead+0x90>
80103866:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010386c:	85 f6                	test   %esi,%esi
8010386e:	0f 84 cc 00 00 00    	je     80103940 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103874:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010387a:	eb 2d                	jmp    801038a9 <piperead+0x69>
8010387c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103880:	83 ec 08             	sub    $0x8,%esp
80103883:	53                   	push   %ebx
80103884:	56                   	push   %esi
80103885:	e8 a6 08 00 00       	call   80104130 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010388a:	83 c4 10             	add    $0x10,%esp
8010388d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103893:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103899:	75 35                	jne    801038d0 <piperead+0x90>
8010389b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801038a1:	85 d2                	test   %edx,%edx
801038a3:	0f 84 97 00 00 00    	je     80103940 <piperead+0x100>
    if(myproc()->killed){
801038a9:	e8 b2 02 00 00       	call   80103b60 <myproc>
801038ae:	8b 48 24             	mov    0x24(%eax),%ecx
801038b1:	85 c9                	test   %ecx,%ecx
801038b3:	74 cb                	je     80103880 <piperead+0x40>
      release(&p->lock);
801038b5:	83 ec 0c             	sub    $0xc,%esp
801038b8:	53                   	push   %ebx
801038b9:	e8 62 11 00 00       	call   80104a20 <release>
      return -1;
801038be:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038c1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801038c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038c9:	5b                   	pop    %ebx
801038ca:	5e                   	pop    %esi
801038cb:	5f                   	pop    %edi
801038cc:	5d                   	pop    %ebp
801038cd:	c3                   	ret    
801038ce:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038d0:	8b 45 10             	mov    0x10(%ebp),%eax
801038d3:	85 c0                	test   %eax,%eax
801038d5:	7e 69                	jle    80103940 <piperead+0x100>
    if(p->nread == p->nwrite)
801038d7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038dd:	31 c9                	xor    %ecx,%ecx
801038df:	eb 15                	jmp    801038f6 <piperead+0xb6>
801038e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038e8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038ee:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801038f4:	74 5a                	je     80103950 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038f6:	8d 70 01             	lea    0x1(%eax),%esi
801038f9:	25 ff 01 00 00       	and    $0x1ff,%eax
801038fe:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103904:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103909:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010390c:	83 c1 01             	add    $0x1,%ecx
8010390f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103912:	75 d4                	jne    801038e8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103914:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010391a:	83 ec 0c             	sub    $0xc,%esp
8010391d:	50                   	push   %eax
8010391e:	e8 cd 09 00 00       	call   801042f0 <wakeup>
  release(&p->lock);
80103923:	89 1c 24             	mov    %ebx,(%esp)
80103926:	e8 f5 10 00 00       	call   80104a20 <release>
  return i;
8010392b:	8b 45 10             	mov    0x10(%ebp),%eax
8010392e:	83 c4 10             	add    $0x10,%esp
}
80103931:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103934:	5b                   	pop    %ebx
80103935:	5e                   	pop    %esi
80103936:	5f                   	pop    %edi
80103937:	5d                   	pop    %ebp
80103938:	c3                   	ret    
80103939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103940:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103947:	eb cb                	jmp    80103914 <piperead+0xd4>
80103949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103950:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103953:	eb bf                	jmp    80103914 <piperead+0xd4>
80103955:	66 90                	xchg   %ax,%ax
80103957:	66 90                	xchg   %ax,%ax
80103959:	66 90                	xchg   %ax,%ax
8010395b:	66 90                	xchg   %ax,%ax
8010395d:	66 90                	xchg   %ax,%ax
8010395f:	90                   	nop

80103960 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103964:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103969:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010396c:	68 20 3d 11 80       	push   $0x80113d20
80103971:	e8 fa 0f 00 00       	call   80104970 <acquire>
80103976:	83 c4 10             	add    $0x10,%esp
80103979:	eb 17                	jmp    80103992 <allocproc+0x32>
8010397b:	90                   	nop
8010397c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103980:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103986:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
8010398c:	0f 84 96 00 00 00    	je     80103a28 <allocproc+0xc8>
    if(p->state == UNUSED)
80103992:	8b 43 0c             	mov    0xc(%ebx),%eax
80103995:	85 c0                	test   %eax,%eax
80103997:	75 e7                	jne    80103980 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103999:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->mode = 0;
  p->mlimit = 0;
  p->ptime=ticks;

  release(&ptable.lock);
8010399e:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801039a1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
  p->mode = 0;
  p->mlimit = 0;
  p->ptime=ticks;

  release(&ptable.lock);
801039a8:	68 20 3d 11 80       	push   $0x80113d20
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->mode = 0;
801039ad:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->mlimit = 0;
801039b4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801039bb:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039be:	8d 50 01             	lea    0x1(%eax),%edx
801039c1:	89 43 10             	mov    %eax,0x10(%ebx)
  p->mode = 0;
  p->mlimit = 0;
  p->ptime=ticks;
801039c4:	a1 a0 68 11 80       	mov    0x801168a0,%eax
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039c9:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  p->mode = 0;
  p->mlimit = 0;
  p->ptime=ticks;
801039cf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)

  release(&ptable.lock);
801039d5:	e8 46 10 00 00       	call   80104a20 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039da:	e8 61 ee ff ff       	call   80102840 <kalloc>
801039df:	83 c4 10             	add    $0x10,%esp
801039e2:	85 c0                	test   %eax,%eax
801039e4:	89 43 08             	mov    %eax,0x8(%ebx)
801039e7:	74 56                	je     80103a3f <allocproc+0xdf>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039e9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039ef:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801039f2:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039f7:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801039fa:	c7 40 14 a9 5e 10 80 	movl   $0x80105ea9,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a01:	6a 14                	push   $0x14
80103a03:	6a 00                	push   $0x0
80103a05:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103a06:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a09:	e8 62 10 00 00       	call   80104a70 <memset>
  p->context->eip = (uint)forkret;
80103a0e:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a11:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103a14:	c7 40 10 50 3a 10 80 	movl   $0x80103a50,0x10(%eax)

  return p;
80103a1b:	89 d8                	mov    %ebx,%eax
}
80103a1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a20:	c9                   	leave  
80103a21:	c3                   	ret    
80103a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103a28:	83 ec 0c             	sub    $0xc,%esp
80103a2b:	68 20 3d 11 80       	push   $0x80113d20
80103a30:	e8 eb 0f 00 00       	call   80104a20 <release>
  return 0;
80103a35:	83 c4 10             	add    $0x10,%esp
80103a38:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a3d:	c9                   	leave  
80103a3e:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103a3f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a46:	eb d5                	jmp    80103a1d <allocproc+0xbd>
80103a48:	90                   	nop
80103a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a50 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a56:	68 20 3d 11 80       	push   $0x80113d20
80103a5b:	e8 c0 0f 00 00       	call   80104a20 <release>

  if (first) {
80103a60:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a65:	83 c4 10             	add    $0x10,%esp
80103a68:	85 c0                	test   %eax,%eax
80103a6a:	75 04                	jne    80103a70 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a6c:	c9                   	leave  
80103a6d:	c3                   	ret    
80103a6e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103a70:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103a73:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a7a:	00 00 00 
    iinit(ROOTDEV);
80103a7d:	6a 01                	push   $0x1
80103a7f:	e8 9c dd ff ff       	call   80101820 <iinit>
    initlog(ROOTDEV);
80103a84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a8b:	e8 d0 f3 ff ff       	call   80102e60 <initlog>
80103a90:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a93:	c9                   	leave  
80103a94:	c3                   	ret    
80103a95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103aa0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103aa6:	68 15 7d 10 80       	push   $0x80107d15
80103aab:	68 20 3d 11 80       	push   $0x80113d20
80103ab0:	e8 5b 0d 00 00       	call   80104810 <initlock>
}
80103ab5:	83 c4 10             	add    $0x10,%esp
80103ab8:	c9                   	leave  
80103ab9:	c3                   	ret    
80103aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ac0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ac5:	9c                   	pushf  
80103ac6:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103ac7:	f6 c4 02             	test   $0x2,%ah
80103aca:	75 5b                	jne    80103b27 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
80103acc:	e8 cf ef ff ff       	call   80102aa0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103ad1:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103ad7:	85 f6                	test   %esi,%esi
80103ad9:	7e 3f                	jle    80103b1a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103adb:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103ae2:	39 d0                	cmp    %edx,%eax
80103ae4:	74 30                	je     80103b16 <mycpu+0x56>
80103ae6:	b9 30 38 11 80       	mov    $0x80113830,%ecx
80103aeb:	31 d2                	xor    %edx,%edx
80103aed:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103af0:	83 c2 01             	add    $0x1,%edx
80103af3:	39 f2                	cmp    %esi,%edx
80103af5:	74 23                	je     80103b1a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103af7:	0f b6 19             	movzbl (%ecx),%ebx
80103afa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103b00:	39 d8                	cmp    %ebx,%eax
80103b02:	75 ec                	jne    80103af0 <mycpu+0x30>
      return &cpus[i];
80103b04:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
80103b0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b0d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103b0e:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
80103b13:	5e                   	pop    %esi
80103b14:	5d                   	pop    %ebp
80103b15:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b16:	31 d2                	xor    %edx,%edx
80103b18:	eb ea                	jmp    80103b04 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80103b1a:	83 ec 0c             	sub    $0xc,%esp
80103b1d:	68 1c 7d 10 80       	push   $0x80107d1c
80103b22:	e8 49 c8 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103b27:	83 ec 0c             	sub    $0xc,%esp
80103b2a:	68 28 7e 10 80       	push   $0x80107e28
80103b2f:	e8 3c c8 ff ff       	call   80100370 <panic>
80103b34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b40 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b46:	e8 75 ff ff ff       	call   80103ac0 <mycpu>
80103b4b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103b50:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103b51:	c1 f8 04             	sar    $0x4,%eax
80103b54:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b5a:	c3                   	ret    
80103b5b:	90                   	nop
80103b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b60 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	53                   	push   %ebx
80103b64:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b67:	e8 24 0d 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103b6c:	e8 4f ff ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103b71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b77:	e8 54 0d 00 00       	call   801048d0 <popcli>
  return p;
}
80103b7c:	83 c4 04             	add    $0x4,%esp
80103b7f:	89 d8                	mov    %ebx,%eax
80103b81:	5b                   	pop    %ebx
80103b82:	5d                   	pop    %ebp
80103b83:	c3                   	ret    
80103b84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b90 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	53                   	push   %ebx
80103b94:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103b97:	e8 c4 fd ff ff       	call   80103960 <allocproc>
80103b9c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103b9e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103ba3:	e8 f8 38 00 00       	call   801074a0 <setupkvm>
80103ba8:	85 c0                	test   %eax,%eax
80103baa:	89 43 04             	mov    %eax,0x4(%ebx)
80103bad:	0f 84 bd 00 00 00    	je     80103c70 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bb3:	83 ec 04             	sub    $0x4,%esp
80103bb6:	68 2c 00 00 00       	push   $0x2c
80103bbb:	68 60 b4 10 80       	push   $0x8010b460
80103bc0:	50                   	push   %eax
80103bc1:	e8 ea 35 00 00       	call   801071b0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103bc6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103bc9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bcf:	6a 4c                	push   $0x4c
80103bd1:	6a 00                	push   $0x0
80103bd3:	ff 73 18             	pushl  0x18(%ebx)
80103bd6:	e8 95 0e 00 00       	call   80104a70 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bdb:	8b 43 18             	mov    0x18(%ebx),%eax
80103bde:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103be3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103be8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103beb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bef:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bf6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bfd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c01:	8b 43 18             	mov    0x18(%ebx),%eax
80103c04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c16:	8b 43 18             	mov    0x18(%ebx),%eax
80103c19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c20:	8b 43 18             	mov    0x18(%ebx),%eax
80103c23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c2a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c2d:	6a 10                	push   $0x10
80103c2f:	68 45 7d 10 80       	push   $0x80107d45
80103c34:	50                   	push   %eax
80103c35:	e8 36 10 00 00       	call   80104c70 <safestrcpy>
  p->cwd = namei("/");
80103c3a:	c7 04 24 4e 7d 10 80 	movl   $0x80107d4e,(%esp)
80103c41:	e8 2a e6 ff ff       	call   80102270 <namei>
80103c46:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103c49:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c50:	e8 1b 0d 00 00       	call   80104970 <acquire>

  p->state = RUNNABLE;
80103c55:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103c5c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c63:	e8 b8 0d 00 00       	call   80104a20 <release>
}
80103c68:	83 c4 10             	add    $0x10,%esp
80103c6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c6e:	c9                   	leave  
80103c6f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103c70:	83 ec 0c             	sub    $0xc,%esp
80103c73:	68 2c 7d 10 80       	push   $0x80107d2c
80103c78:	e8 f3 c6 ff ff       	call   80100370 <panic>
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi

80103c80 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	56                   	push   %esi
80103c84:	53                   	push   %ebx
80103c85:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c88:	e8 03 0c 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103c8d:	e8 2e fe ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103c92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c98:	e8 33 0c 00 00       	call   801048d0 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
80103c9d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103ca0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ca2:	7e 3c                	jle    80103ce0 <growproc+0x60>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ca4:	83 ec 04             	sub    $0x4,%esp
80103ca7:	01 c6                	add    %eax,%esi
80103ca9:	56                   	push   %esi
80103caa:	50                   	push   %eax
80103cab:	ff 73 04             	pushl  0x4(%ebx)
80103cae:	e8 3d 36 00 00       	call   801072f0 <allocuvm>
80103cb3:	83 c4 10             	add    $0x10,%esp
80103cb6:	85 c0                	test   %eax,%eax
80103cb8:	74 46                	je     80103d00 <growproc+0x80>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  if(sz > curproc->mlimit && curproc->mlimit!=0)
80103cba:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
80103cc0:	85 d2                	test   %edx,%edx
80103cc2:	74 04                	je     80103cc8 <growproc+0x48>
80103cc4:	39 d0                	cmp    %edx,%eax
80103cc6:	77 38                	ja     80103d00 <growproc+0x80>
    return -1;
  curproc->sz = sz;
  switchuvm(curproc);
80103cc8:	83 ec 0c             	sub    $0xc,%esp
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  if(sz > curproc->mlimit && curproc->mlimit!=0)
    return -1;
  curproc->sz = sz;
80103ccb:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ccd:	53                   	push   %ebx
80103cce:	e8 cd 33 00 00       	call   801070a0 <switchuvm>
  return 0;
80103cd3:	83 c4 10             	add    $0x10,%esp
80103cd6:	31 c0                	xor    %eax,%eax
}
80103cd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cdb:	5b                   	pop    %ebx
80103cdc:	5e                   	pop    %esi
80103cdd:	5d                   	pop    %ebp
80103cde:	c3                   	ret    
80103cdf:	90                   	nop

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103ce0:	74 d8                	je     80103cba <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ce2:	83 ec 04             	sub    $0x4,%esp
80103ce5:	01 c6                	add    %eax,%esi
80103ce7:	56                   	push   %esi
80103ce8:	50                   	push   %eax
80103ce9:	ff 73 04             	pushl  0x4(%ebx)
80103cec:	e8 ff 36 00 00       	call   801073f0 <deallocuvm>
80103cf1:	83 c4 10             	add    $0x10,%esp
80103cf4:	85 c0                	test   %eax,%eax
80103cf6:	75 c2                	jne    80103cba <growproc+0x3a>
80103cf8:	90                   	nop
80103cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d05:	eb d1                	jmp    80103cd8 <growproc+0x58>
80103d07:	89 f6                	mov    %esi,%esi
80103d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d10 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	57                   	push   %edi
80103d14:	56                   	push   %esi
80103d15:	53                   	push   %ebx
80103d16:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d19:	e8 72 0b 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103d1e:	e8 9d fd ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103d23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d29:	e8 a2 0b 00 00       	call   801048d0 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103d2e:	e8 2d fc ff ff       	call   80103960 <allocproc>
80103d33:	85 c0                	test   %eax,%eax
80103d35:	89 c7                	mov    %eax,%edi
80103d37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d3a:	0f 84 cd 00 00 00    	je     80103e0d <fork+0xfd>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d40:	83 ec 08             	sub    $0x8,%esp
80103d43:	ff 33                	pushl  (%ebx)
80103d45:	ff 73 04             	pushl  0x4(%ebx)
80103d48:	e8 23 38 00 00       	call   80107570 <copyuvm>
80103d4d:	83 c4 10             	add    $0x10,%esp
80103d50:	85 c0                	test   %eax,%eax
80103d52:	89 47 04             	mov    %eax,0x4(%edi)
80103d55:	0f 84 b9 00 00 00    	je     80103e14 <fork+0x104>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103d5b:	8b 03                	mov    (%ebx),%eax
80103d5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d60:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103d62:	89 59 14             	mov    %ebx,0x14(%ecx)
  np->mlimit=curproc->mlimit;
80103d65:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  np->mode=curproc->mode;
  *np->tf = *curproc->tf;
80103d6b:	8b 79 18             	mov    0x18(%ecx),%edi
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  np->mlimit=curproc->mlimit;
80103d6e:	89 81 80 00 00 00    	mov    %eax,0x80(%ecx)
  np->mode=curproc->mode;
80103d74:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103d77:	89 41 7c             	mov    %eax,0x7c(%ecx)
  *np->tf = *curproc->tf;
80103d7a:	89 c8                	mov    %ecx,%eax
80103d7c:	8b 73 18             	mov    0x18(%ebx),%esi
80103d7f:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d84:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103d86:	31 f6                	xor    %esi,%esi
  np->mlimit=curproc->mlimit;
  np->mode=curproc->mode;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103d88:	8b 40 18             	mov    0x18(%eax),%eax
80103d8b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103d98:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d9c:	85 c0                	test   %eax,%eax
80103d9e:	74 13                	je     80103db3 <fork+0xa3>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103da0:	83 ec 0c             	sub    $0xc,%esp
80103da3:	50                   	push   %eax
80103da4:	e8 f7 d3 ff ff       	call   801011a0 <filedup>
80103da9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dac:	83 c4 10             	add    $0x10,%esp
80103daf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103db3:	83 c6 01             	add    $0x1,%esi
80103db6:	83 fe 10             	cmp    $0x10,%esi
80103db9:	75 dd                	jne    80103d98 <fork+0x88>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103dbb:	83 ec 0c             	sub    $0xc,%esp
80103dbe:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dc1:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103dc4:	e8 27 dc ff ff       	call   801019f0 <idup>
80103dc9:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dcc:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103dcf:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dd2:	8d 47 6c             	lea    0x6c(%edi),%eax
80103dd5:	6a 10                	push   $0x10
80103dd7:	53                   	push   %ebx
80103dd8:	50                   	push   %eax
80103dd9:	e8 92 0e 00 00       	call   80104c70 <safestrcpy>

  pid = np->pid;
80103dde:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103de1:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103de8:	e8 83 0b 00 00       	call   80104970 <acquire>

  np->state = RUNNABLE;
80103ded:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103df4:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103dfb:	e8 20 0c 00 00       	call   80104a20 <release>

  return pid;
80103e00:	83 c4 10             	add    $0x10,%esp
80103e03:	89 d8                	mov    %ebx,%eax
}
80103e05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e08:	5b                   	pop    %ebx
80103e09:	5e                   	pop    %esi
80103e0a:	5f                   	pop    %edi
80103e0b:	5d                   	pop    %ebp
80103e0c:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e12:	eb f1                	jmp    80103e05 <fork+0xf5>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103e14:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103e17:	83 ec 0c             	sub    $0xc,%esp
80103e1a:	ff 77 08             	pushl  0x8(%edi)
80103e1d:	e8 6e e8 ff ff       	call   80102690 <kfree>
    np->kstack = 0;
80103e22:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103e29:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103e30:	83 c4 10             	add    $0x10,%esp
80103e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e38:	eb cb                	jmp    80103e05 <fork+0xf5>
80103e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e40 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103e49:	e8 72 fc ff ff       	call   80103ac0 <mycpu>
80103e4e:	8d 78 04             	lea    0x4(%eax),%edi
80103e51:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e53:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e5a:	00 00 00 
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103e60:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103e61:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e64:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103e69:	68 20 3d 11 80       	push   $0x80113d20
80103e6e:	e8 fd 0a 00 00       	call   80104970 <acquire>
80103e73:	83 c4 10             	add    $0x10,%esp
80103e76:	eb 16                	jmp    80103e8e <scheduler+0x4e>
80103e78:	90                   	nop
80103e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e80:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103e86:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
80103e8c:	74 4a                	je     80103ed8 <scheduler+0x98>
      if(p->state != RUNNABLE)
80103e8e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e92:	75 ec                	jne    80103e80 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103e94:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103e97:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e9d:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e9e:	81 c3 8c 00 00 00    	add    $0x8c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103ea4:	e8 f7 31 00 00       	call   801070a0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103ea9:	58                   	pop    %eax
80103eaa:	5a                   	pop    %edx
80103eab:	ff 73 90             	pushl  -0x70(%ebx)
80103eae:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103eaf:	c7 43 80 04 00 00 00 	movl   $0x4,-0x80(%ebx)

      swtch(&(c->scheduler), p->context);
80103eb6:	e8 10 0e 00 00       	call   80104ccb <swtch>
      switchkvm();
80103ebb:	e8 c0 31 00 00       	call   80107080 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103ec0:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec3:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103ec9:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ed0:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed3:	75 b9                	jne    80103e8e <scheduler+0x4e>
80103ed5:	8d 76 00             	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103ed8:	83 ec 0c             	sub    $0xc,%esp
80103edb:	68 20 3d 11 80       	push   $0x80113d20
80103ee0:	e8 3b 0b 00 00       	call   80104a20 <release>

  }
80103ee5:	83 c4 10             	add    $0x10,%esp
80103ee8:	e9 73 ff ff ff       	jmp    80103e60 <scheduler+0x20>
80103eed:	8d 76 00             	lea    0x0(%esi),%esi

80103ef0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ef5:	e8 96 09 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103efa:	e8 c1 fb ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103eff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f05:	e8 c6 09 00 00       	call   801048d0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 20 3d 11 80       	push   $0x80113d20
80103f12:	e8 29 0a 00 00       	call   80104940 <holding>
80103f17:	83 c4 10             	add    $0x10,%esp
80103f1a:	85 c0                	test   %eax,%eax
80103f1c:	74 4f                	je     80103f6d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103f1e:	e8 9d fb ff ff       	call   80103ac0 <mycpu>
80103f23:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f2a:	75 68                	jne    80103f94 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103f2c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f30:	74 55                	je     80103f87 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f32:	9c                   	pushf  
80103f33:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103f34:	f6 c4 02             	test   $0x2,%ah
80103f37:	75 41                	jne    80103f7a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103f39:	e8 82 fb ff ff       	call   80103ac0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f3e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103f41:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f47:	e8 74 fb ff ff       	call   80103ac0 <mycpu>
80103f4c:	83 ec 08             	sub    $0x8,%esp
80103f4f:	ff 70 04             	pushl  0x4(%eax)
80103f52:	53                   	push   %ebx
80103f53:	e8 73 0d 00 00       	call   80104ccb <swtch>
  mycpu()->intena = intena;
80103f58:	e8 63 fb ff ff       	call   80103ac0 <mycpu>
}
80103f5d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103f60:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f69:	5b                   	pop    %ebx
80103f6a:	5e                   	pop    %esi
80103f6b:	5d                   	pop    %ebp
80103f6c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103f6d:	83 ec 0c             	sub    $0xc,%esp
80103f70:	68 50 7d 10 80       	push   $0x80107d50
80103f75:	e8 f6 c3 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103f7a:	83 ec 0c             	sub    $0xc,%esp
80103f7d:	68 7c 7d 10 80       	push   $0x80107d7c
80103f82:	e8 e9 c3 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103f87:	83 ec 0c             	sub    $0xc,%esp
80103f8a:	68 6e 7d 10 80       	push   $0x80107d6e
80103f8f:	e8 dc c3 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103f94:	83 ec 0c             	sub    $0xc,%esp
80103f97:	68 62 7d 10 80       	push   $0x80107d62
80103f9c:	e8 cf c3 ff ff       	call   80100370 <panic>
80103fa1:	eb 0d                	jmp    80103fb0 <exit>
80103fa3:	90                   	nop
80103fa4:	90                   	nop
80103fa5:	90                   	nop
80103fa6:	90                   	nop
80103fa7:	90                   	nop
80103fa8:	90                   	nop
80103fa9:	90                   	nop
80103faa:	90                   	nop
80103fab:	90                   	nop
80103fac:	90                   	nop
80103fad:	90                   	nop
80103fae:	90                   	nop
80103faf:	90                   	nop

80103fb0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	57                   	push   %edi
80103fb4:	56                   	push   %esi
80103fb5:	53                   	push   %ebx
80103fb6:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103fb9:	e8 d2 08 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103fbe:	e8 fd fa ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103fc3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fc9:	e8 02 09 00 00       	call   801048d0 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103fce:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103fd4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103fd7:	8d 7e 68             	lea    0x68(%esi),%edi
80103fda:	0f 84 f1 00 00 00    	je     801040d1 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103fe0:	8b 03                	mov    (%ebx),%eax
80103fe2:	85 c0                	test   %eax,%eax
80103fe4:	74 12                	je     80103ff8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103fe6:	83 ec 0c             	sub    $0xc,%esp
80103fe9:	50                   	push   %eax
80103fea:	e8 01 d2 ff ff       	call   801011f0 <fileclose>
      curproc->ofile[fd] = 0;
80103fef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103ff5:	83 c4 10             	add    $0x10,%esp
80103ff8:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103ffb:	39 df                	cmp    %ebx,%edi
80103ffd:	75 e1                	jne    80103fe0 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103fff:	e8 fc ee ff ff       	call   80102f00 <begin_op>
  iput(curproc->cwd);
80104004:	83 ec 0c             	sub    $0xc,%esp
80104007:	ff 76 68             	pushl  0x68(%esi)
8010400a:	e8 41 db ff ff       	call   80101b50 <iput>
  end_op();
8010400f:	e8 5c ef ff ff       	call   80102f70 <end_op>
  curproc->cwd = 0;
80104014:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
8010401b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104022:	e8 49 09 00 00       	call   80104970 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104027:	8b 56 14             	mov    0x14(%esi),%edx
8010402a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010402d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104032:	eb 10                	jmp    80104044 <exit+0x94>
80104034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104038:	05 8c 00 00 00       	add    $0x8c,%eax
8010403d:	3d 54 60 11 80       	cmp    $0x80116054,%eax
80104042:	74 1e                	je     80104062 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104044:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104048:	75 ee                	jne    80104038 <exit+0x88>
8010404a:	3b 50 20             	cmp    0x20(%eax),%edx
8010404d:	75 e9                	jne    80104038 <exit+0x88>
      p->state = RUNNABLE;
8010404f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104056:	05 8c 00 00 00       	add    $0x8c,%eax
8010405b:	3d 54 60 11 80       	cmp    $0x80116054,%eax
80104060:	75 e2                	jne    80104044 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104062:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80104068:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
8010406d:	eb 0f                	jmp    8010407e <exit+0xce>
8010406f:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104070:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80104076:	81 fa 54 60 11 80    	cmp    $0x80116054,%edx
8010407c:	74 3a                	je     801040b8 <exit+0x108>
    if(p->parent == curproc){
8010407e:	39 72 14             	cmp    %esi,0x14(%edx)
80104081:	75 ed                	jne    80104070 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80104083:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104087:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010408a:	75 e4                	jne    80104070 <exit+0xc0>
8010408c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104091:	eb 11                	jmp    801040a4 <exit+0xf4>
80104093:	90                   	nop
80104094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104098:	05 8c 00 00 00       	add    $0x8c,%eax
8010409d:	3d 54 60 11 80       	cmp    $0x80116054,%eax
801040a2:	74 cc                	je     80104070 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801040a4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040a8:	75 ee                	jne    80104098 <exit+0xe8>
801040aa:	3b 48 20             	cmp    0x20(%eax),%ecx
801040ad:	75 e9                	jne    80104098 <exit+0xe8>
      p->state = RUNNABLE;
801040af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040b6:	eb e0                	jmp    80104098 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
801040b8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801040bf:	e8 2c fe ff ff       	call   80103ef0 <sched>
  panic("zombie exit");
801040c4:	83 ec 0c             	sub    $0xc,%esp
801040c7:	68 9d 7d 10 80       	push   $0x80107d9d
801040cc:	e8 9f c2 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
801040d1:	83 ec 0c             	sub    $0xc,%esp
801040d4:	68 90 7d 10 80       	push   $0x80107d90
801040d9:	e8 92 c2 ff ff       	call   80100370 <panic>
801040de:	66 90                	xchg   %ax,%ax

801040e0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	53                   	push   %ebx
801040e4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040e7:	68 20 3d 11 80       	push   $0x80113d20
801040ec:	e8 7f 08 00 00       	call   80104970 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801040f1:	e8 9a 07 00 00       	call   80104890 <pushcli>
  c = mycpu();
801040f6:	e8 c5 f9 ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
801040fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104101:	e8 ca 07 00 00       	call   801048d0 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80104106:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010410d:	e8 de fd ff ff       	call   80103ef0 <sched>
  release(&ptable.lock);
80104112:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104119:	e8 02 09 00 00       	call   80104a20 <release>
}
8010411e:	83 c4 10             	add    $0x10,%esp
80104121:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104124:	c9                   	leave  
80104125:	c3                   	ret    
80104126:	8d 76 00             	lea    0x0(%esi),%esi
80104129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104130 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	57                   	push   %edi
80104134:	56                   	push   %esi
80104135:	53                   	push   %ebx
80104136:	83 ec 0c             	sub    $0xc,%esp
80104139:	8b 7d 08             	mov    0x8(%ebp),%edi
8010413c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010413f:	e8 4c 07 00 00       	call   80104890 <pushcli>
  c = mycpu();
80104144:	e8 77 f9 ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80104149:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010414f:	e8 7c 07 00 00       	call   801048d0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80104154:	85 db                	test   %ebx,%ebx
80104156:	0f 84 87 00 00 00    	je     801041e3 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
8010415c:	85 f6                	test   %esi,%esi
8010415e:	74 76                	je     801041d6 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104160:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80104166:	74 50                	je     801041b8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104168:	83 ec 0c             	sub    $0xc,%esp
8010416b:	68 20 3d 11 80       	push   $0x80113d20
80104170:	e8 fb 07 00 00       	call   80104970 <acquire>
    release(lk);
80104175:	89 34 24             	mov    %esi,(%esp)
80104178:	e8 a3 08 00 00       	call   80104a20 <release>
  }
  // Go to sleep.
  p->chan = chan;
8010417d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104180:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80104187:	e8 64 fd ff ff       	call   80103ef0 <sched>

  // Tidy up.
  p->chan = 0;
8010418c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80104193:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010419a:	e8 81 08 00 00       	call   80104a20 <release>
    acquire(lk);
8010419f:	89 75 08             	mov    %esi,0x8(%ebp)
801041a2:	83 c4 10             	add    $0x10,%esp
  }
}
801041a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041a8:	5b                   	pop    %ebx
801041a9:	5e                   	pop    %esi
801041aa:	5f                   	pop    %edi
801041ab:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
801041ac:	e9 bf 07 00 00       	jmp    80104970 <acquire>
801041b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
801041b8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041bb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
801041c2:	e8 29 fd ff ff       	call   80103ef0 <sched>

  // Tidy up.
  p->chan = 0;
801041c7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
801041ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041d1:	5b                   	pop    %ebx
801041d2:	5e                   	pop    %esi
801041d3:	5f                   	pop    %edi
801041d4:	5d                   	pop    %ebp
801041d5:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
801041d6:	83 ec 0c             	sub    $0xc,%esp
801041d9:	68 af 7d 10 80       	push   $0x80107daf
801041de:	e8 8d c1 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
801041e3:	83 ec 0c             	sub    $0xc,%esp
801041e6:	68 a9 7d 10 80       	push   $0x80107da9
801041eb:	e8 80 c1 ff ff       	call   80100370 <panic>

801041f0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	56                   	push   %esi
801041f4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801041f5:	e8 96 06 00 00       	call   80104890 <pushcli>
  c = mycpu();
801041fa:	e8 c1 f8 ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
801041ff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104205:	e8 c6 06 00 00       	call   801048d0 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
8010420a:	83 ec 0c             	sub    $0xc,%esp
8010420d:	68 20 3d 11 80       	push   $0x80113d20
80104212:	e8 59 07 00 00       	call   80104970 <acquire>
80104217:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010421a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010421c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104221:	eb 13                	jmp    80104236 <wait+0x46>
80104223:	90                   	nop
80104224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104228:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010422e:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
80104234:	74 22                	je     80104258 <wait+0x68>
      if(p->parent != curproc)
80104236:	39 73 14             	cmp    %esi,0x14(%ebx)
80104239:	75 ed                	jne    80104228 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010423b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010423f:	74 35                	je     80104276 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104241:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80104247:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010424c:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
80104252:	75 e2                	jne    80104236 <wait+0x46>
80104254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104258:	85 c0                	test   %eax,%eax
8010425a:	74 70                	je     801042cc <wait+0xdc>
8010425c:	8b 46 24             	mov    0x24(%esi),%eax
8010425f:	85 c0                	test   %eax,%eax
80104261:	75 69                	jne    801042cc <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104263:	83 ec 08             	sub    $0x8,%esp
80104266:	68 20 3d 11 80       	push   $0x80113d20
8010426b:	56                   	push   %esi
8010426c:	e8 bf fe ff ff       	call   80104130 <sleep>
  }
80104271:	83 c4 10             	add    $0x10,%esp
80104274:	eb a4                	jmp    8010421a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80104276:	83 ec 0c             	sub    $0xc,%esp
80104279:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
8010427c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010427f:	e8 0c e4 ff ff       	call   80102690 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80104284:	5a                   	pop    %edx
80104285:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80104288:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010428f:	e8 8c 31 00 00       	call   80107420 <freevm>
        p->pid = 0;
80104294:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010429b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801042a2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801042a6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042ad:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801042b4:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801042bb:	e8 60 07 00 00       	call   80104a20 <release>
        return pid;
801042c0:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801042c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
801042c6:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801042c8:	5b                   	pop    %ebx
801042c9:	5e                   	pop    %esi
801042ca:	5d                   	pop    %ebp
801042cb:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
801042cc:	83 ec 0c             	sub    $0xc,%esp
801042cf:	68 20 3d 11 80       	push   $0x80113d20
801042d4:	e8 47 07 00 00       	call   80104a20 <release>
      return -1;
801042d9:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801042dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
801042df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801042e4:	5b                   	pop    %ebx
801042e5:	5e                   	pop    %esi
801042e6:	5d                   	pop    %ebp
801042e7:	c3                   	ret    
801042e8:	90                   	nop
801042e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	53                   	push   %ebx
801042f4:	83 ec 10             	sub    $0x10,%esp
801042f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042fa:	68 20 3d 11 80       	push   $0x80113d20
801042ff:	e8 6c 06 00 00       	call   80104970 <acquire>
80104304:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104307:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010430c:	eb 0e                	jmp    8010431c <wakeup+0x2c>
8010430e:	66 90                	xchg   %ax,%ax
80104310:	05 8c 00 00 00       	add    $0x8c,%eax
80104315:	3d 54 60 11 80       	cmp    $0x80116054,%eax
8010431a:	74 1e                	je     8010433a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010431c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104320:	75 ee                	jne    80104310 <wakeup+0x20>
80104322:	3b 58 20             	cmp    0x20(%eax),%ebx
80104325:	75 e9                	jne    80104310 <wakeup+0x20>
      p->state = RUNNABLE;
80104327:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010432e:	05 8c 00 00 00       	add    $0x8c,%eax
80104333:	3d 54 60 11 80       	cmp    $0x80116054,%eax
80104338:	75 e2                	jne    8010431c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010433a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104341:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104344:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104345:	e9 d6 06 00 00       	jmp    80104a20 <release>
8010434a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104350 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 10             	sub    $0x10,%esp
80104357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010435a:	68 20 3d 11 80       	push   $0x80113d20
8010435f:	e8 0c 06 00 00       	call   80104970 <acquire>
80104364:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104367:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010436c:	eb 0e                	jmp    8010437c <kill+0x2c>
8010436e:	66 90                	xchg   %ax,%ax
80104370:	05 8c 00 00 00       	add    $0x8c,%eax
80104375:	3d 54 60 11 80       	cmp    $0x80116054,%eax
8010437a:	74 3c                	je     801043b8 <kill+0x68>
    if(p->pid == pid){
8010437c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010437f:	75 ef                	jne    80104370 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104381:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104385:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010438c:	74 1a                	je     801043a8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010438e:	83 ec 0c             	sub    $0xc,%esp
80104391:	68 20 3d 11 80       	push   $0x80113d20
80104396:	e8 85 06 00 00       	call   80104a20 <release>
      return 0;
8010439b:	83 c4 10             	add    $0x10,%esp
8010439e:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801043a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043a3:	c9                   	leave  
801043a4:	c3                   	ret    
801043a5:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801043a8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801043af:	eb dd                	jmp    8010438e <kill+0x3e>
801043b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801043b8:	83 ec 0c             	sub    $0xc,%esp
801043bb:	68 20 3d 11 80       	push   $0x80113d20
801043c0:	e8 5b 06 00 00       	call   80104a20 <release>
  return -1;
801043c5:	83 c4 10             	add    $0x10,%esp
801043c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043d0:	c9                   	leave  
801043d1:	c3                   	ret    
801043d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	57                   	push   %edi
801043e4:	56                   	push   %esi
801043e5:	53                   	push   %ebx
801043e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043e9:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801043ee:	83 ec 3c             	sub    $0x3c,%esp
801043f1:	eb 27                	jmp    8010441a <procdump+0x3a>
801043f3:	90                   	nop
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	68 fa 7d 10 80       	push   $0x80107dfa
80104400:	e8 5b c2 ff ff       	call   80100660 <cprintf>
80104405:	83 c4 10             	add    $0x10,%esp
80104408:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010440e:	81 fb c0 60 11 80    	cmp    $0x801160c0,%ebx
80104414:	0f 84 7e 00 00 00    	je     80104498 <procdump+0xb8>
    if(p->state == UNUSED)
8010441a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010441d:	85 c0                	test   %eax,%eax
8010441f:	74 e7                	je     80104408 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104421:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104424:	ba c0 7d 10 80       	mov    $0x80107dc0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104429:	77 11                	ja     8010443c <procdump+0x5c>
8010442b:	8b 14 85 50 7e 10 80 	mov    -0x7fef81b0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104432:	b8 c0 7d 10 80       	mov    $0x80107dc0,%eax
80104437:	85 d2                	test   %edx,%edx
80104439:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010443c:	53                   	push   %ebx
8010443d:	52                   	push   %edx
8010443e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104441:	68 c4 7d 10 80       	push   $0x80107dc4
80104446:	e8 15 c2 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010444b:	83 c4 10             	add    $0x10,%esp
8010444e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104452:	75 a4                	jne    801043f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104454:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104457:	83 ec 08             	sub    $0x8,%esp
8010445a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010445d:	50                   	push   %eax
8010445e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104461:	8b 40 0c             	mov    0xc(%eax),%eax
80104464:	83 c0 08             	add    $0x8,%eax
80104467:	50                   	push   %eax
80104468:	e8 c3 03 00 00       	call   80104830 <getcallerpcs>
8010446d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104470:	8b 17                	mov    (%edi),%edx
80104472:	85 d2                	test   %edx,%edx
80104474:	74 82                	je     801043f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104476:	83 ec 08             	sub    $0x8,%esp
80104479:	83 c7 04             	add    $0x4,%edi
8010447c:	52                   	push   %edx
8010447d:	68 01 78 10 80       	push   $0x80107801
80104482:	e8 d9 c1 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104487:	83 c4 10             	add    $0x10,%esp
8010448a:	39 f7                	cmp    %esi,%edi
8010448c:	75 e2                	jne    80104470 <procdump+0x90>
8010448e:	e9 65 ff ff ff       	jmp    801043f8 <procdump+0x18>
80104493:	90                   	nop
80104494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104498:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010449b:	5b                   	pop    %ebx
8010449c:	5e                   	pop    %esi
8010449d:	5f                   	pop    %edi
8010449e:	5d                   	pop    %ebp
8010449f:	c3                   	ret    

801044a0 <setmemorylimit>:


int 
setmemorylimit(int pid,int limit)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	56                   	push   %esi
801044a5:	53                   	push   %ebx
801044a6:	83 ec 0c             	sub    $0xc,%esp
801044a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801044af:	e8 dc 03 00 00       	call   80104890 <pushcli>
  c = mycpu();
801044b4:	e8 07 f6 ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
801044b9:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044bf:	e8 0c 04 00 00       	call   801048d0 <popcli>
setmemorylimit(int pid,int limit)
{
  struct proc *p;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
801044c4:	83 ec 0c             	sub    $0xc,%esp
801044c7:	68 20 3d 11 80       	push   $0x80113d20
801044cc:	e8 9f 04 00 00       	call   80104970 <acquire>
801044d1:	83 c4 10             	add    $0x10,%esp
  for(p=ptable.proc ; p < &ptable.proc[NPROC] ; p++){
801044d4:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801044d9:	eb 11                	jmp    801044ec <setmemorylimit+0x4c>
801044db:	90                   	nop
801044dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e0:	05 8c 00 00 00       	add    $0x8c,%eax
801044e5:	3d 54 60 11 80       	cmp    $0x80116054,%eax
801044ea:	74 34                	je     80104520 <setmemorylimit+0x80>
    if(p->pid ==pid && curproc->mode==1 && p->sz<limit){
801044ec:	39 58 10             	cmp    %ebx,0x10(%eax)
801044ef:	75 ef                	jne    801044e0 <setmemorylimit+0x40>
801044f1:	83 7e 7c 01          	cmpl   $0x1,0x7c(%esi)
801044f5:	75 e9                	jne    801044e0 <setmemorylimit+0x40>
801044f7:	39 38                	cmp    %edi,(%eax)
801044f9:	73 e5                	jae    801044e0 <setmemorylimit+0x40>
      p->mlimit=limit;
      release(&ptable.lock);
801044fb:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for(p=ptable.proc ; p < &ptable.proc[NPROC] ; p++){
    if(p->pid ==pid && curproc->mode==1 && p->sz<limit){
      p->mlimit=limit;
801044fe:	89 b8 80 00 00 00    	mov    %edi,0x80(%eax)
      release(&ptable.lock);
80104504:	68 20 3d 11 80       	push   $0x80113d20
80104509:	e8 12 05 00 00       	call   80104a20 <release>
      return 0;
8010450e:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
}
80104511:	8d 65 f4             	lea    -0xc(%ebp),%esp
  acquire(&ptable.lock);
  for(p=ptable.proc ; p < &ptable.proc[NPROC] ; p++){
    if(p->pid ==pid && curproc->mode==1 && p->sz<limit){
      p->mlimit=limit;
      release(&ptable.lock);
      return 0;
80104514:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104516:	5b                   	pop    %ebx
80104517:	5e                   	pop    %esi
80104518:	5f                   	pop    %edi
80104519:	5d                   	pop    %ebp
8010451a:	c3                   	ret    
8010451b:	90                   	nop
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p->mlimit=limit;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104520:	83 ec 0c             	sub    $0xc,%esp
80104523:	68 20 3d 11 80       	push   $0x80113d20
80104528:	e8 f3 04 00 00       	call   80104a20 <release>
  return -1;
8010452d:	83 c4 10             	add    $0x10,%esp
}
80104530:	8d 65 f4             	lea    -0xc(%ebp),%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80104533:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104538:	5b                   	pop    %ebx
80104539:	5e                   	pop    %esi
8010453a:	5f                   	pop    %edi
8010453b:	5d                   	pop    %ebp
8010453c:	c3                   	ret    
8010453d:	8d 76 00             	lea    0x0(%esi),%esi

80104540 <proclist>:

void 
proclist(void)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	56                   	push   %esi
80104545:	53                   	push   %ebx
80104546:	be c0 3d 11 80       	mov    $0x80113dc0,%esi
        count++;
      for(;;)
      {
        count++;
        if(ml/10 > 9){
          ml=ml/10;
8010454b:	bf 67 66 66 66       	mov    $0x66666667,%edi
  return -1;
}

void 
proclist(void)
{
80104550:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int count,ml;

  acquire(&ptable.lock);
80104553:	68 20 3d 11 80       	push   $0x80113d20
80104558:	e8 13 04 00 00       	call   80104970 <acquire>
8010455d:	83 c4 10             	add    $0x10,%esp
80104560:	eb 19                	jmp    8010457b <proclist+0x3b>
80104562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104568:	81 c6 8c 00 00 00    	add    $0x8c,%esi
  for(p=ptable.proc ; p < &ptable.proc[NPROC] ; p++){
8010456e:	b8 c0 60 11 80       	mov    $0x801160c0,%eax
80104573:	39 f0                	cmp    %esi,%eax
80104575:	0f 84 f1 00 00 00    	je     8010466c <proclist+0x12c>
    if(p->state != UNUSED){
8010457b:	8b 46 a0             	mov    -0x60(%esi),%eax
8010457e:	85 c0                	test   %eax,%eax
80104580:	74 e6                	je     80104568 <proclist+0x28>
      cprintf("%s\t\t",p->name);
80104582:	83 ec 08             	sub    $0x8,%esp
80104585:	56                   	push   %esi
80104586:	68 cd 7d 10 80       	push   $0x80107dcd
8010458b:	e8 d0 c0 ff ff       	call   80100660 <cprintf>
      if(strlen(p->name)<8)
80104590:	89 34 24             	mov    %esi,(%esp)
80104593:	e8 18 07 00 00       	call   80104cb0 <strlen>
80104598:	83 c4 10             	add    $0x10,%esp
8010459b:	83 f8 07             	cmp    $0x7,%eax
8010459e:	0f 8e ec 00 00 00    	jle    80104690 <proclist+0x150>
        cprintf("\t");
      cprintf("    %d\t  ",p->pid);
801045a4:	83 ec 08             	sub    $0x8,%esp
801045a7:	ff 76 a4             	pushl  -0x5c(%esi)
801045aa:	68 d2 7d 10 80       	push   $0x80107dd2
801045af:	e8 ac c0 ff ff       	call   80100660 <cprintf>
      cprintf(" %d\t   ",(ticks - p->ptime)*10); 
801045b4:	58                   	pop    %eax
801045b5:	a1 a0 68 11 80       	mov    0x801168a0,%eax
801045ba:	2b 46 18             	sub    0x18(%esi),%eax
801045bd:	5a                   	pop    %edx
801045be:	8d 04 80             	lea    (%eax,%eax,4),%eax
801045c1:	01 c0                	add    %eax,%eax
801045c3:	50                   	push   %eax
801045c4:	68 dc 7d 10 80       	push   $0x80107ddc
801045c9:	e8 92 c0 ff ff       	call   80100660 <cprintf>
      cprintf(" %d     ",p->sz);
801045ce:	59                   	pop    %ecx
801045cf:	5b                   	pop    %ebx
801045d0:	ff 76 94             	pushl  -0x6c(%esi)
801045d3:	68 e4 7d 10 80       	push   $0x80107de4
801045d8:	e8 83 c0 ff ff       	call   80100660 <cprintf>
      ml=p->mlimit;
801045dd:	8b 46 14             	mov    0x14(%esi),%eax
      count=1;
      if(ml>10)
801045e0:	83 c4 10             	add    $0x10,%esp
801045e3:	83 f8 0a             	cmp    $0xa,%eax
      if(strlen(p->name)<8)
        cprintf("\t");
      cprintf("    %d\t  ",p->pid);
      cprintf(" %d\t   ",(ticks - p->ptime)*10); 
      cprintf(" %d     ",p->sz);
      ml=p->mlimit;
801045e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      count=1;
      if(ml>10)
801045e9:	0f 8e 99 00 00 00    	jle    80104688 <proclist+0x148>
        count++;
      for(;;)
      {
        count++;
        if(ml/10 > 9){
801045ef:	83 f8 63             	cmp    $0x63,%eax
801045f2:	0f 8e b2 00 00 00    	jle    801046aa <proclist+0x16a>
801045f8:	89 c1                	mov    %eax,%ecx
801045fa:	bb 03 00 00 00       	mov    $0x3,%ebx
801045ff:	90                   	nop
          ml=ml/10;
80104600:	89 c8                	mov    %ecx,%eax
80104602:	c1 f9 1f             	sar    $0x1f,%ecx
      count=1;
      if(ml>10)
        count++;
      for(;;)
      {
        count++;
80104605:	83 c3 01             	add    $0x1,%ebx
        if(ml/10 > 9){
          ml=ml/10;
80104608:	f7 ef                	imul   %edi
8010460a:	c1 fa 02             	sar    $0x2,%edx
8010460d:	29 ca                	sub    %ecx,%edx
      if(ml>10)
        count++;
      for(;;)
      {
        count++;
        if(ml/10 > 9){
8010460f:	83 fa 63             	cmp    $0x63,%edx
          ml=ml/10;
80104612:	89 d1                	mov    %edx,%ecx
      if(ml>10)
        count++;
      for(;;)
      {
        count++;
        if(ml/10 > 9){
80104614:	7f ea                	jg     80104600 <proclist+0xc0>
          ml=ml/10;
        }
        else
          break;
      }
      for(int i=17-count;i>0;i--)
80104616:	b8 11 00 00 00       	mov    $0x11,%eax
8010461b:	29 d8                	sub    %ebx,%eax
8010461d:	85 c0                	test   %eax,%eax
8010461f:	89 c3                	mov    %eax,%ebx
80104621:	0f 8e 7e 00 00 00    	jle    801046a5 <proclist+0x165>
80104627:	89 f6                	mov    %esi,%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        cprintf(" ");
80104630:	83 ec 0c             	sub    $0xc,%esp
80104633:	68 da 7d 10 80       	push   $0x80107dda
80104638:	e8 23 c0 ff ff       	call   80100660 <cprintf>
          ml=ml/10;
        }
        else
          break;
      }
      for(int i=17-count;i>0;i--)
8010463d:	83 c4 10             	add    $0x10,%esp
80104640:	83 eb 01             	sub    $0x1,%ebx
80104643:	75 eb                	jne    80104630 <proclist+0xf0>
80104645:	8b 46 14             	mov    0x14(%esi),%eax
        cprintf(" ");
      cprintf(" %d\n",p->mlimit);
80104648:	83 ec 08             	sub    $0x8,%esp
8010464b:	81 c6 8c 00 00 00    	add    $0x8c,%esi
80104651:	50                   	push   %eax
80104652:	68 b3 7c 10 80       	push   $0x80107cb3
80104657:	e8 04 c0 ff ff       	call   80100660 <cprintf>
{
  struct proc *p;
  int count,ml;

  acquire(&ptable.lock);
  for(p=ptable.proc ; p < &ptable.proc[NPROC] ; p++){
8010465c:	b8 c0 60 11 80       	mov    $0x801160c0,%eax
        else
          break;
      }
      for(int i=17-count;i>0;i--)
        cprintf(" ");
      cprintf(" %d\n",p->mlimit);
80104661:	83 c4 10             	add    $0x10,%esp
{
  struct proc *p;
  int count,ml;

  acquire(&ptable.lock);
  for(p=ptable.proc ; p < &ptable.proc[NPROC] ; p++){
80104664:	39 f0                	cmp    %esi,%eax
80104666:	0f 85 0f ff ff ff    	jne    8010457b <proclist+0x3b>
      for(int i=17-count;i>0;i--)
        cprintf(" ");
      cprintf(" %d\n",p->mlimit);
    }
  }
  release(&ptable.lock);
8010466c:	83 ec 0c             	sub    $0xc,%esp
8010466f:	68 20 3d 11 80       	push   $0x80113d20
80104674:	e8 a7 03 00 00       	call   80104a20 <release>
}
80104679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010467c:	5b                   	pop    %ebx
8010467d:	5e                   	pop    %esi
8010467e:	5f                   	pop    %edi
8010467f:	5d                   	pop    %ebp
80104680:	c3                   	ret    
80104681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104688:	bb 0f 00 00 00       	mov    $0xf,%ebx
8010468d:	eb a1                	jmp    80104630 <proclist+0xf0>
8010468f:	90                   	nop
  acquire(&ptable.lock);
  for(p=ptable.proc ; p < &ptable.proc[NPROC] ; p++){
    if(p->state != UNUSED){
      cprintf("%s\t\t",p->name);
      if(strlen(p->name)<8)
        cprintf("\t");
80104690:	83 ec 0c             	sub    $0xc,%esp
80104693:	68 d0 7d 10 80       	push   $0x80107dd0
80104698:	e8 c3 bf ff ff       	call   80100660 <cprintf>
8010469d:	83 c4 10             	add    $0x10,%esp
801046a0:	e9 ff fe ff ff       	jmp    801045a4 <proclist+0x64>
          ml=ml/10;
        }
        else
          break;
      }
      for(int i=17-count;i>0;i--)
801046a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801046a8:	eb 9e                	jmp    80104648 <proclist+0x108>
      if(ml>10)
        count++;
      for(;;)
      {
        count++;
        if(ml/10 > 9){
801046aa:	bb 0e 00 00 00       	mov    $0xe,%ebx
801046af:	e9 7c ff ff ff       	jmp    80104630 <proclist+0xf0>
801046b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801046c0 <getshmem>:
  release(&ptable.lock);
}

char *
getshmem(int pid)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	83 ec 14             	sub    $0x14,%esp
  struct proc* p;

  acquire(&ptable.lock);
801046c6:	68 20 3d 11 80       	push   $0x80113d20
801046cb:	e8 a0 02 00 00       	call   80104970 <acquire>
      if(p->pid == pid){
       // return p->shmem;
      }
  }
  return "shmem failed!\n";
801046d0:	b8 ed 7d 10 80       	mov    $0x80107ded,%eax
801046d5:	c9                   	leave  
801046d6:	c3                   	ret    
801046d7:	66 90                	xchg   %ax,%ax
801046d9:	66 90                	xchg   %ax,%ax
801046db:	66 90                	xchg   %ax,%ax
801046dd:	66 90                	xchg   %ax,%ax
801046df:	90                   	nop

801046e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	53                   	push   %ebx
801046e4:	83 ec 0c             	sub    $0xc,%esp
801046e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801046ea:	68 68 7e 10 80       	push   $0x80107e68
801046ef:	8d 43 04             	lea    0x4(%ebx),%eax
801046f2:	50                   	push   %eax
801046f3:	e8 18 01 00 00       	call   80104810 <initlock>
  lk->name = name;
801046f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801046fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104701:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104704:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010470b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010470e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104711:	c9                   	leave  
80104712:	c3                   	ret    
80104713:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104720 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	56                   	push   %esi
80104724:	53                   	push   %ebx
80104725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104728:	83 ec 0c             	sub    $0xc,%esp
8010472b:	8d 73 04             	lea    0x4(%ebx),%esi
8010472e:	56                   	push   %esi
8010472f:	e8 3c 02 00 00       	call   80104970 <acquire>
  while (lk->locked) {
80104734:	8b 13                	mov    (%ebx),%edx
80104736:	83 c4 10             	add    $0x10,%esp
80104739:	85 d2                	test   %edx,%edx
8010473b:	74 16                	je     80104753 <acquiresleep+0x33>
8010473d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104740:	83 ec 08             	sub    $0x8,%esp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	e8 e6 f9 ff ff       	call   80104130 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010474a:	8b 03                	mov    (%ebx),%eax
8010474c:	83 c4 10             	add    $0x10,%esp
8010474f:	85 c0                	test   %eax,%eax
80104751:	75 ed                	jne    80104740 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104753:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104759:	e8 02 f4 ff ff       	call   80103b60 <myproc>
8010475e:	8b 40 10             	mov    0x10(%eax),%eax
80104761:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104764:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104767:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010476a:	5b                   	pop    %ebx
8010476b:	5e                   	pop    %esi
8010476c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010476d:	e9 ae 02 00 00       	jmp    80104a20 <release>
80104772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104780 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
80104785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104788:	83 ec 0c             	sub    $0xc,%esp
8010478b:	8d 73 04             	lea    0x4(%ebx),%esi
8010478e:	56                   	push   %esi
8010478f:	e8 dc 01 00 00       	call   80104970 <acquire>
  lk->locked = 0;
80104794:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010479a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801047a1:	89 1c 24             	mov    %ebx,(%esp)
801047a4:	e8 47 fb ff ff       	call   801042f0 <wakeup>
  release(&lk->lk);
801047a9:	89 75 08             	mov    %esi,0x8(%ebp)
801047ac:	83 c4 10             	add    $0x10,%esp
}
801047af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047b2:	5b                   	pop    %ebx
801047b3:	5e                   	pop    %esi
801047b4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801047b5:	e9 66 02 00 00       	jmp    80104a20 <release>
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047c0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	57                   	push   %edi
801047c4:	56                   	push   %esi
801047c5:	53                   	push   %ebx
801047c6:	31 ff                	xor    %edi,%edi
801047c8:	83 ec 18             	sub    $0x18,%esp
801047cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801047ce:	8d 73 04             	lea    0x4(%ebx),%esi
801047d1:	56                   	push   %esi
801047d2:	e8 99 01 00 00       	call   80104970 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801047d7:	8b 03                	mov    (%ebx),%eax
801047d9:	83 c4 10             	add    $0x10,%esp
801047dc:	85 c0                	test   %eax,%eax
801047de:	74 13                	je     801047f3 <holdingsleep+0x33>
801047e0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801047e3:	e8 78 f3 ff ff       	call   80103b60 <myproc>
801047e8:	39 58 10             	cmp    %ebx,0x10(%eax)
801047eb:	0f 94 c0             	sete   %al
801047ee:	0f b6 c0             	movzbl %al,%eax
801047f1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801047f3:	83 ec 0c             	sub    $0xc,%esp
801047f6:	56                   	push   %esi
801047f7:	e8 24 02 00 00       	call   80104a20 <release>
  return r;
}
801047fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047ff:	89 f8                	mov    %edi,%eax
80104801:	5b                   	pop    %ebx
80104802:	5e                   	pop    %esi
80104803:	5f                   	pop    %edi
80104804:	5d                   	pop    %ebp
80104805:	c3                   	ret    
80104806:	66 90                	xchg   %ax,%ax
80104808:	66 90                	xchg   %ax,%ax
8010480a:	66 90                	xchg   %ax,%ax
8010480c:	66 90                	xchg   %ax,%ax
8010480e:	66 90                	xchg   %ax,%ax

80104810 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104816:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010481f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104822:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104829:	5d                   	pop    %ebp
8010482a:	c3                   	ret    
8010482b:	90                   	nop
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104830 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104834:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104837:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010483a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010483d:	31 c0                	xor    %eax,%eax
8010483f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104840:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104846:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010484c:	77 1a                	ja     80104868 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010484e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104851:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104854:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104857:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104859:	83 f8 0a             	cmp    $0xa,%eax
8010485c:	75 e2                	jne    80104840 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010485e:	5b                   	pop    %ebx
8010485f:	5d                   	pop    %ebp
80104860:	c3                   	ret    
80104861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104868:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010486f:	83 c0 01             	add    $0x1,%eax
80104872:	83 f8 0a             	cmp    $0xa,%eax
80104875:	74 e7                	je     8010485e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104877:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010487e:	83 c0 01             	add    $0x1,%eax
80104881:	83 f8 0a             	cmp    $0xa,%eax
80104884:	75 e2                	jne    80104868 <getcallerpcs+0x38>
80104886:	eb d6                	jmp    8010485e <getcallerpcs+0x2e>
80104888:	90                   	nop
80104889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104890 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	53                   	push   %ebx
80104894:	83 ec 04             	sub    $0x4,%esp
80104897:	9c                   	pushf  
80104898:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104899:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010489a:	e8 21 f2 ff ff       	call   80103ac0 <mycpu>
8010489f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048a5:	85 c0                	test   %eax,%eax
801048a7:	75 11                	jne    801048ba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801048a9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801048af:	e8 0c f2 ff ff       	call   80103ac0 <mycpu>
801048b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801048ba:	e8 01 f2 ff ff       	call   80103ac0 <mycpu>
801048bf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801048c6:	83 c4 04             	add    $0x4,%esp
801048c9:	5b                   	pop    %ebx
801048ca:	5d                   	pop    %ebp
801048cb:	c3                   	ret    
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048d0 <popcli>:

void
popcli(void)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048d6:	9c                   	pushf  
801048d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048d8:	f6 c4 02             	test   $0x2,%ah
801048db:	75 52                	jne    8010492f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801048dd:	e8 de f1 ff ff       	call   80103ac0 <mycpu>
801048e2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801048e8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801048eb:	85 d2                	test   %edx,%edx
801048ed:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801048f3:	78 2d                	js     80104922 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048f5:	e8 c6 f1 ff ff       	call   80103ac0 <mycpu>
801048fa:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104900:	85 d2                	test   %edx,%edx
80104902:	74 0c                	je     80104910 <popcli+0x40>
    sti();
}
80104904:	c9                   	leave  
80104905:	c3                   	ret    
80104906:	8d 76 00             	lea    0x0(%esi),%esi
80104909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104910:	e8 ab f1 ff ff       	call   80103ac0 <mycpu>
80104915:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010491b:	85 c0                	test   %eax,%eax
8010491d:	74 e5                	je     80104904 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010491f:	fb                   	sti    
    sti();
}
80104920:	c9                   	leave  
80104921:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104922:	83 ec 0c             	sub    $0xc,%esp
80104925:	68 8a 7e 10 80       	push   $0x80107e8a
8010492a:	e8 41 ba ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010492f:	83 ec 0c             	sub    $0xc,%esp
80104932:	68 73 7e 10 80       	push   $0x80107e73
80104937:	e8 34 ba ff ff       	call   80100370 <panic>
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104940 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	8b 75 08             	mov    0x8(%ebp),%esi
80104948:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
8010494a:	e8 41 ff ff ff       	call   80104890 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010494f:	8b 06                	mov    (%esi),%eax
80104951:	85 c0                	test   %eax,%eax
80104953:	74 10                	je     80104965 <holding+0x25>
80104955:	8b 5e 08             	mov    0x8(%esi),%ebx
80104958:	e8 63 f1 ff ff       	call   80103ac0 <mycpu>
8010495d:	39 c3                	cmp    %eax,%ebx
8010495f:	0f 94 c3             	sete   %bl
80104962:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104965:	e8 66 ff ff ff       	call   801048d0 <popcli>
  return r;
}
8010496a:	89 d8                	mov    %ebx,%eax
8010496c:	5b                   	pop    %ebx
8010496d:	5e                   	pop    %esi
8010496e:	5d                   	pop    %ebp
8010496f:	c3                   	ret    

80104970 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104977:	e8 14 ff ff ff       	call   80104890 <pushcli>
  if(holding(lk))
8010497c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010497f:	83 ec 0c             	sub    $0xc,%esp
80104982:	53                   	push   %ebx
80104983:	e8 b8 ff ff ff       	call   80104940 <holding>
80104988:	83 c4 10             	add    $0x10,%esp
8010498b:	85 c0                	test   %eax,%eax
8010498d:	0f 85 7d 00 00 00    	jne    80104a10 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104993:	ba 01 00 00 00       	mov    $0x1,%edx
80104998:	eb 09                	jmp    801049a3 <acquire+0x33>
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049a3:	89 d0                	mov    %edx,%eax
801049a5:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801049a8:	85 c0                	test   %eax,%eax
801049aa:	75 f4                	jne    801049a0 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801049ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801049b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049b4:	e8 07 f1 ff ff       	call   80103ac0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801049b9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801049bb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801049be:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801049c1:	31 c0                	xor    %eax,%eax
801049c3:	90                   	nop
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049c8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801049ce:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801049d4:	77 1a                	ja     801049f0 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
801049d6:	8b 5a 04             	mov    0x4(%edx),%ebx
801049d9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801049dc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801049df:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801049e1:	83 f8 0a             	cmp    $0xa,%eax
801049e4:	75 e2                	jne    801049c8 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801049e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049e9:	c9                   	leave  
801049ea:	c3                   	ret    
801049eb:	90                   	nop
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801049f0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801049f7:	83 c0 01             	add    $0x1,%eax
801049fa:	83 f8 0a             	cmp    $0xa,%eax
801049fd:	74 e7                	je     801049e6 <acquire+0x76>
    pcs[i] = 0;
801049ff:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104a06:	83 c0 01             	add    $0x1,%eax
80104a09:	83 f8 0a             	cmp    $0xa,%eax
80104a0c:	75 e2                	jne    801049f0 <acquire+0x80>
80104a0e:	eb d6                	jmp    801049e6 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104a10:	83 ec 0c             	sub    $0xc,%esp
80104a13:	68 91 7e 10 80       	push   $0x80107e91
80104a18:	e8 53 b9 ff ff       	call   80100370 <panic>
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi

80104a20 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	53                   	push   %ebx
80104a24:	83 ec 10             	sub    $0x10,%esp
80104a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104a2a:	53                   	push   %ebx
80104a2b:	e8 10 ff ff ff       	call   80104940 <holding>
80104a30:	83 c4 10             	add    $0x10,%esp
80104a33:	85 c0                	test   %eax,%eax
80104a35:	74 22                	je     80104a59 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104a37:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a3e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104a45:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a4a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104a50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a53:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104a54:	e9 77 fe ff ff       	jmp    801048d0 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104a59:	83 ec 0c             	sub    $0xc,%esp
80104a5c:	68 99 7e 10 80       	push   $0x80107e99
80104a61:	e8 0a b9 ff ff       	call   80100370 <panic>
80104a66:	66 90                	xchg   %ax,%ax
80104a68:	66 90                	xchg   %ax,%ax
80104a6a:	66 90                	xchg   %ax,%ax
80104a6c:	66 90                	xchg   %ax,%ax
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	53                   	push   %ebx
80104a75:	8b 55 08             	mov    0x8(%ebp),%edx
80104a78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104a7b:	f6 c2 03             	test   $0x3,%dl
80104a7e:	75 05                	jne    80104a85 <memset+0x15>
80104a80:	f6 c1 03             	test   $0x3,%cl
80104a83:	74 13                	je     80104a98 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104a85:	89 d7                	mov    %edx,%edi
80104a87:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a8a:	fc                   	cld    
80104a8b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a8d:	5b                   	pop    %ebx
80104a8e:	89 d0                	mov    %edx,%eax
80104a90:	5f                   	pop    %edi
80104a91:	5d                   	pop    %ebp
80104a92:	c3                   	ret    
80104a93:	90                   	nop
80104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104a98:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104a9c:	c1 e9 02             	shr    $0x2,%ecx
80104a9f:	89 fb                	mov    %edi,%ebx
80104aa1:	89 f8                	mov    %edi,%eax
80104aa3:	c1 e3 18             	shl    $0x18,%ebx
80104aa6:	c1 e0 10             	shl    $0x10,%eax
80104aa9:	09 d8                	or     %ebx,%eax
80104aab:	09 f8                	or     %edi,%eax
80104aad:	c1 e7 08             	shl    $0x8,%edi
80104ab0:	09 f8                	or     %edi,%eax
80104ab2:	89 d7                	mov    %edx,%edi
80104ab4:	fc                   	cld    
80104ab5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104ab7:	5b                   	pop    %ebx
80104ab8:	89 d0                	mov    %edx,%eax
80104aba:	5f                   	pop    %edi
80104abb:	5d                   	pop    %ebp
80104abc:	c3                   	ret    
80104abd:	8d 76 00             	lea    0x0(%esi),%esi

80104ac0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	8b 45 10             	mov    0x10(%ebp),%eax
80104ac8:	53                   	push   %ebx
80104ac9:	8b 75 0c             	mov    0xc(%ebp),%esi
80104acc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104acf:	85 c0                	test   %eax,%eax
80104ad1:	74 29                	je     80104afc <memcmp+0x3c>
    if(*s1 != *s2)
80104ad3:	0f b6 13             	movzbl (%ebx),%edx
80104ad6:	0f b6 0e             	movzbl (%esi),%ecx
80104ad9:	38 d1                	cmp    %dl,%cl
80104adb:	75 2b                	jne    80104b08 <memcmp+0x48>
80104add:	8d 78 ff             	lea    -0x1(%eax),%edi
80104ae0:	31 c0                	xor    %eax,%eax
80104ae2:	eb 14                	jmp    80104af8 <memcmp+0x38>
80104ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ae8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104aed:	83 c0 01             	add    $0x1,%eax
80104af0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104af4:	38 ca                	cmp    %cl,%dl
80104af6:	75 10                	jne    80104b08 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104af8:	39 f8                	cmp    %edi,%eax
80104afa:	75 ec                	jne    80104ae8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104afc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104afd:	31 c0                	xor    %eax,%eax
}
80104aff:	5e                   	pop    %esi
80104b00:	5f                   	pop    %edi
80104b01:	5d                   	pop    %ebp
80104b02:	c3                   	ret    
80104b03:	90                   	nop
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104b08:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104b0b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104b0c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104b0e:	5e                   	pop    %esi
80104b0f:	5f                   	pop    %edi
80104b10:	5d                   	pop    %ebp
80104b11:	c3                   	ret    
80104b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	8b 45 08             	mov    0x8(%ebp),%eax
80104b28:	8b 75 0c             	mov    0xc(%ebp),%esi
80104b2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b2e:	39 c6                	cmp    %eax,%esi
80104b30:	73 2e                	jae    80104b60 <memmove+0x40>
80104b32:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104b35:	39 c8                	cmp    %ecx,%eax
80104b37:	73 27                	jae    80104b60 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104b39:	85 db                	test   %ebx,%ebx
80104b3b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104b3e:	74 17                	je     80104b57 <memmove+0x37>
      *--d = *--s;
80104b40:	29 d9                	sub    %ebx,%ecx
80104b42:	89 cb                	mov    %ecx,%ebx
80104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b48:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b4c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104b4f:	83 ea 01             	sub    $0x1,%edx
80104b52:	83 fa ff             	cmp    $0xffffffff,%edx
80104b55:	75 f1                	jne    80104b48 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b57:	5b                   	pop    %ebx
80104b58:	5e                   	pop    %esi
80104b59:	5d                   	pop    %ebp
80104b5a:	c3                   	ret    
80104b5b:	90                   	nop
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104b60:	31 d2                	xor    %edx,%edx
80104b62:	85 db                	test   %ebx,%ebx
80104b64:	74 f1                	je     80104b57 <memmove+0x37>
80104b66:	8d 76 00             	lea    0x0(%esi),%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104b70:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104b74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b77:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104b7a:	39 d3                	cmp    %edx,%ebx
80104b7c:	75 f2                	jne    80104b70 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104b7e:	5b                   	pop    %ebx
80104b7f:	5e                   	pop    %esi
80104b80:	5d                   	pop    %ebp
80104b81:	c3                   	ret    
80104b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b90 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104b93:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104b94:	eb 8a                	jmp    80104b20 <memmove>
80104b96:	8d 76 00             	lea    0x0(%esi),%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ba0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	57                   	push   %edi
80104ba4:	56                   	push   %esi
80104ba5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ba8:	53                   	push   %ebx
80104ba9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104bac:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104baf:	85 c9                	test   %ecx,%ecx
80104bb1:	74 37                	je     80104bea <strncmp+0x4a>
80104bb3:	0f b6 17             	movzbl (%edi),%edx
80104bb6:	0f b6 1e             	movzbl (%esi),%ebx
80104bb9:	84 d2                	test   %dl,%dl
80104bbb:	74 3f                	je     80104bfc <strncmp+0x5c>
80104bbd:	38 d3                	cmp    %dl,%bl
80104bbf:	75 3b                	jne    80104bfc <strncmp+0x5c>
80104bc1:	8d 47 01             	lea    0x1(%edi),%eax
80104bc4:	01 cf                	add    %ecx,%edi
80104bc6:	eb 1b                	jmp    80104be3 <strncmp+0x43>
80104bc8:	90                   	nop
80104bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bd0:	0f b6 10             	movzbl (%eax),%edx
80104bd3:	84 d2                	test   %dl,%dl
80104bd5:	74 21                	je     80104bf8 <strncmp+0x58>
80104bd7:	0f b6 19             	movzbl (%ecx),%ebx
80104bda:	83 c0 01             	add    $0x1,%eax
80104bdd:	89 ce                	mov    %ecx,%esi
80104bdf:	38 da                	cmp    %bl,%dl
80104be1:	75 19                	jne    80104bfc <strncmp+0x5c>
80104be3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104be5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104be8:	75 e6                	jne    80104bd0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104bea:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104beb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104bed:	5e                   	pop    %esi
80104bee:	5f                   	pop    %edi
80104bef:	5d                   	pop    %ebp
80104bf0:	c3                   	ret    
80104bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bf8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104bfc:	0f b6 c2             	movzbl %dl,%eax
80104bff:	29 d8                	sub    %ebx,%eax
}
80104c01:	5b                   	pop    %ebx
80104c02:	5e                   	pop    %esi
80104c03:	5f                   	pop    %edi
80104c04:	5d                   	pop    %ebp
80104c05:	c3                   	ret    
80104c06:	8d 76 00             	lea    0x0(%esi),%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c10 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	53                   	push   %ebx
80104c15:	8b 45 08             	mov    0x8(%ebp),%eax
80104c18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104c1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104c1e:	89 c2                	mov    %eax,%edx
80104c20:	eb 19                	jmp    80104c3b <strncpy+0x2b>
80104c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c28:	83 c3 01             	add    $0x1,%ebx
80104c2b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104c2f:	83 c2 01             	add    $0x1,%edx
80104c32:	84 c9                	test   %cl,%cl
80104c34:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c37:	74 09                	je     80104c42 <strncpy+0x32>
80104c39:	89 f1                	mov    %esi,%ecx
80104c3b:	85 c9                	test   %ecx,%ecx
80104c3d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104c40:	7f e6                	jg     80104c28 <strncpy+0x18>
    ;
  while(n-- > 0)
80104c42:	31 c9                	xor    %ecx,%ecx
80104c44:	85 f6                	test   %esi,%esi
80104c46:	7e 17                	jle    80104c5f <strncpy+0x4f>
80104c48:	90                   	nop
80104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c50:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c54:	89 f3                	mov    %esi,%ebx
80104c56:	83 c1 01             	add    $0x1,%ecx
80104c59:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104c5b:	85 db                	test   %ebx,%ebx
80104c5d:	7f f1                	jg     80104c50 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104c5f:	5b                   	pop    %ebx
80104c60:	5e                   	pop    %esi
80104c61:	5d                   	pop    %ebp
80104c62:	c3                   	ret    
80104c63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
80104c75:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c78:	8b 45 08             	mov    0x8(%ebp),%eax
80104c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c7e:	85 c9                	test   %ecx,%ecx
80104c80:	7e 26                	jle    80104ca8 <safestrcpy+0x38>
80104c82:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104c86:	89 c1                	mov    %eax,%ecx
80104c88:	eb 17                	jmp    80104ca1 <safestrcpy+0x31>
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104c90:	83 c2 01             	add    $0x1,%edx
80104c93:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104c97:	83 c1 01             	add    $0x1,%ecx
80104c9a:	84 db                	test   %bl,%bl
80104c9c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104c9f:	74 04                	je     80104ca5 <safestrcpy+0x35>
80104ca1:	39 f2                	cmp    %esi,%edx
80104ca3:	75 eb                	jne    80104c90 <safestrcpy+0x20>
    ;
  *s = 0;
80104ca5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104ca8:	5b                   	pop    %ebx
80104ca9:	5e                   	pop    %esi
80104caa:	5d                   	pop    %ebp
80104cab:	c3                   	ret    
80104cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cb0 <strlen>:

int
strlen(const char *s)
{
80104cb0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104cb1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104cb3:	89 e5                	mov    %esp,%ebp
80104cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104cb8:	80 3a 00             	cmpb   $0x0,(%edx)
80104cbb:	74 0c                	je     80104cc9 <strlen+0x19>
80104cbd:	8d 76 00             	lea    0x0(%esi),%esi
80104cc0:	83 c0 01             	add    $0x1,%eax
80104cc3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104cc7:	75 f7                	jne    80104cc0 <strlen+0x10>
    ;
  return n;
}
80104cc9:	5d                   	pop    %ebp
80104cca:	c3                   	ret    

80104ccb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104ccb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104ccf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104cd3:	55                   	push   %ebp
  pushl %ebx
80104cd4:	53                   	push   %ebx
  pushl %esi
80104cd5:	56                   	push   %esi
  pushl %edi
80104cd6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104cd7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104cd9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104cdb:	5f                   	pop    %edi
  popl %esi
80104cdc:	5e                   	pop    %esi
  popl %ebx
80104cdd:	5b                   	pop    %ebx
  popl %ebp
80104cde:	5d                   	pop    %ebp
  ret
80104cdf:	c3                   	ret    

80104ce0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	53                   	push   %ebx
80104ce4:	83 ec 04             	sub    $0x4,%esp
80104ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104cea:	e8 71 ee ff ff       	call   80103b60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cef:	8b 00                	mov    (%eax),%eax
80104cf1:	39 d8                	cmp    %ebx,%eax
80104cf3:	76 1b                	jbe    80104d10 <fetchint+0x30>
80104cf5:	8d 53 04             	lea    0x4(%ebx),%edx
80104cf8:	39 d0                	cmp    %edx,%eax
80104cfa:	72 14                	jb     80104d10 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cff:	8b 13                	mov    (%ebx),%edx
80104d01:	89 10                	mov    %edx,(%eax)
  return 0;
80104d03:	31 c0                	xor    %eax,%eax
}
80104d05:	83 c4 04             	add    $0x4,%esp
80104d08:	5b                   	pop    %ebx
80104d09:	5d                   	pop    %ebp
80104d0a:	c3                   	ret    
80104d0b:	90                   	nop
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d15:	eb ee                	jmp    80104d05 <fetchint+0x25>
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	53                   	push   %ebx
80104d24:	83 ec 04             	sub    $0x4,%esp
80104d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d2a:	e8 31 ee ff ff       	call   80103b60 <myproc>

  if(addr >= curproc->sz)
80104d2f:	39 18                	cmp    %ebx,(%eax)
80104d31:	76 29                	jbe    80104d5c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104d33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104d36:	89 da                	mov    %ebx,%edx
80104d38:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104d3a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104d3c:	39 c3                	cmp    %eax,%ebx
80104d3e:	73 1c                	jae    80104d5c <fetchstr+0x3c>
    if(*s == 0)
80104d40:	80 3b 00             	cmpb   $0x0,(%ebx)
80104d43:	75 10                	jne    80104d55 <fetchstr+0x35>
80104d45:	eb 29                	jmp    80104d70 <fetchstr+0x50>
80104d47:	89 f6                	mov    %esi,%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d50:	80 3a 00             	cmpb   $0x0,(%edx)
80104d53:	74 1b                	je     80104d70 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104d55:	83 c2 01             	add    $0x1,%edx
80104d58:	39 d0                	cmp    %edx,%eax
80104d5a:	77 f4                	ja     80104d50 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104d5c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104d5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104d64:	5b                   	pop    %ebx
80104d65:	5d                   	pop    %ebp
80104d66:	c3                   	ret    
80104d67:	89 f6                	mov    %esi,%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d70:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104d73:	89 d0                	mov    %edx,%eax
80104d75:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104d77:	5b                   	pop    %ebx
80104d78:	5d                   	pop    %ebp
80104d79:	c3                   	ret    
80104d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d80 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d85:	e8 d6 ed ff ff       	call   80103b60 <myproc>
80104d8a:	8b 40 18             	mov    0x18(%eax),%eax
80104d8d:	8b 55 08             	mov    0x8(%ebp),%edx
80104d90:	8b 40 44             	mov    0x44(%eax),%eax
80104d93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104d96:	e8 c5 ed ff ff       	call   80103b60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d9b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d9d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104da0:	39 c6                	cmp    %eax,%esi
80104da2:	73 1c                	jae    80104dc0 <argint+0x40>
80104da4:	8d 53 08             	lea    0x8(%ebx),%edx
80104da7:	39 d0                	cmp    %edx,%eax
80104da9:	72 15                	jb     80104dc0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104dab:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dae:	8b 53 04             	mov    0x4(%ebx),%edx
80104db1:	89 10                	mov    %edx,(%eax)
  return 0;
80104db3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104db5:	5b                   	pop    %ebx
80104db6:	5e                   	pop    %esi
80104db7:	5d                   	pop    %ebp
80104db8:	c3                   	ret    
80104db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc5:	eb ee                	jmp    80104db5 <argint+0x35>
80104dc7:	89 f6                	mov    %esi,%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	53                   	push   %ebx
80104dd5:	83 ec 10             	sub    $0x10,%esp
80104dd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104ddb:	e8 80 ed ff ff       	call   80103b60 <myproc>
80104de0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104de2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104de5:	83 ec 08             	sub    $0x8,%esp
80104de8:	50                   	push   %eax
80104de9:	ff 75 08             	pushl  0x8(%ebp)
80104dec:	e8 8f ff ff ff       	call   80104d80 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104df1:	c1 e8 1f             	shr    $0x1f,%eax
80104df4:	83 c4 10             	add    $0x10,%esp
80104df7:	84 c0                	test   %al,%al
80104df9:	75 2d                	jne    80104e28 <argptr+0x58>
80104dfb:	89 d8                	mov    %ebx,%eax
80104dfd:	c1 e8 1f             	shr    $0x1f,%eax
80104e00:	84 c0                	test   %al,%al
80104e02:	75 24                	jne    80104e28 <argptr+0x58>
80104e04:	8b 16                	mov    (%esi),%edx
80104e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e09:	39 c2                	cmp    %eax,%edx
80104e0b:	76 1b                	jbe    80104e28 <argptr+0x58>
80104e0d:	01 c3                	add    %eax,%ebx
80104e0f:	39 da                	cmp    %ebx,%edx
80104e11:	72 15                	jb     80104e28 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104e13:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e16:	89 02                	mov    %eax,(%edx)
  return 0;
80104e18:	31 c0                	xor    %eax,%eax
}
80104e1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e1d:	5b                   	pop    %ebx
80104e1e:	5e                   	pop    %esi
80104e1f:	5d                   	pop    %ebp
80104e20:	c3                   	ret    
80104e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104e28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e2d:	eb eb                	jmp    80104e1a <argptr+0x4a>
80104e2f:	90                   	nop

80104e30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104e36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e39:	50                   	push   %eax
80104e3a:	ff 75 08             	pushl  0x8(%ebp)
80104e3d:	e8 3e ff ff ff       	call   80104d80 <argint>
80104e42:	83 c4 10             	add    $0x10,%esp
80104e45:	85 c0                	test   %eax,%eax
80104e47:	78 17                	js     80104e60 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104e49:	83 ec 08             	sub    $0x8,%esp
80104e4c:	ff 75 0c             	pushl  0xc(%ebp)
80104e4f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e52:	e8 c9 fe ff ff       	call   80104d20 <fetchstr>
80104e57:	83 c4 10             	add    $0x10,%esp
}
80104e5a:	c9                   	leave  
80104e5b:	c3                   	ret    
80104e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e70 <syscall>:
[SYS_getshmem] sys_getshmem,
};

void
syscall(void)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104e75:	e8 e6 ec ff ff       	call   80103b60 <myproc>

  num = curproc->tf->eax;
80104e7a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104e7d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104e7f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e82:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e85:	83 fa 1b             	cmp    $0x1b,%edx
80104e88:	77 1e                	ja     80104ea8 <syscall+0x38>
80104e8a:	8b 14 85 c0 7e 10 80 	mov    -0x7fef8140(,%eax,4),%edx
80104e91:	85 d2                	test   %edx,%edx
80104e93:	74 13                	je     80104ea8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104e95:	ff d2                	call   *%edx
80104e97:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e9d:	5b                   	pop    %ebx
80104e9e:	5e                   	pop    %esi
80104e9f:	5d                   	pop    %ebp
80104ea0:	c3                   	ret    
80104ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104ea8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ea9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104eac:	50                   	push   %eax
80104ead:	ff 73 10             	pushl  0x10(%ebx)
80104eb0:	68 a1 7e 10 80       	push   $0x80107ea1
80104eb5:	e8 a6 b7 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104eba:	8b 43 18             	mov    0x18(%ebx),%eax
80104ebd:	83 c4 10             	add    $0x10,%esp
80104ec0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104ec7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eca:	5b                   	pop    %ebx
80104ecb:	5e                   	pop    %esi
80104ecc:	5d                   	pop    %ebp
80104ecd:	c3                   	ret    
80104ece:	66 90                	xchg   %ax,%ax

80104ed0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	57                   	push   %edi
80104ed4:	56                   	push   %esi
80104ed5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ed6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ed9:	83 ec 34             	sub    $0x34,%esp
80104edc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104edf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ee2:	56                   	push   %esi
80104ee3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ee4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ee7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104eea:	e8 a1 d3 ff ff       	call   80102290 <nameiparent>
80104eef:	83 c4 10             	add    $0x10,%esp
80104ef2:	85 c0                	test   %eax,%eax
80104ef4:	0f 84 f6 00 00 00    	je     80104ff0 <create+0x120>
    return 0;
  ilock(dp);
80104efa:	83 ec 0c             	sub    $0xc,%esp
80104efd:	89 c7                	mov    %eax,%edi
80104eff:	50                   	push   %eax
80104f00:	e8 1b cb ff ff       	call   80101a20 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104f05:	83 c4 0c             	add    $0xc,%esp
80104f08:	6a 00                	push   $0x0
80104f0a:	56                   	push   %esi
80104f0b:	57                   	push   %edi
80104f0c:	e8 3f d0 ff ff       	call   80101f50 <dirlookup>
80104f11:	83 c4 10             	add    $0x10,%esp
80104f14:	85 c0                	test   %eax,%eax
80104f16:	89 c3                	mov    %eax,%ebx
80104f18:	74 56                	je     80104f70 <create+0xa0>
    iunlockput(dp);
80104f1a:	83 ec 0c             	sub    $0xc,%esp
80104f1d:	57                   	push   %edi
80104f1e:	e8 8d cd ff ff       	call   80101cb0 <iunlockput>
    ilock(ip);
80104f23:	89 1c 24             	mov    %ebx,(%esp)
80104f26:	e8 f5 ca ff ff       	call   80101a20 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f2b:	83 c4 10             	add    $0x10,%esp
80104f2e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104f33:	75 1b                	jne    80104f50 <create+0x80>
80104f35:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104f3a:	89 d8                	mov    %ebx,%eax
80104f3c:	75 12                	jne    80104f50 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f41:	5b                   	pop    %ebx
80104f42:	5e                   	pop    %esi
80104f43:	5f                   	pop    %edi
80104f44:	5d                   	pop    %ebp
80104f45:	c3                   	ret    
80104f46:	8d 76 00             	lea    0x0(%esi),%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104f50:	83 ec 0c             	sub    $0xc,%esp
80104f53:	53                   	push   %ebx
80104f54:	e8 57 cd ff ff       	call   80101cb0 <iunlockput>
    return 0;
80104f59:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104f5f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f61:	5b                   	pop    %ebx
80104f62:	5e                   	pop    %esi
80104f63:	5f                   	pop    %edi
80104f64:	5d                   	pop    %ebp
80104f65:	c3                   	ret    
80104f66:	8d 76 00             	lea    0x0(%esi),%esi
80104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104f70:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104f74:	83 ec 08             	sub    $0x8,%esp
80104f77:	50                   	push   %eax
80104f78:	ff 37                	pushl  (%edi)
80104f7a:	e8 31 c9 ff ff       	call   801018b0 <ialloc>
80104f7f:	83 c4 10             	add    $0x10,%esp
80104f82:	85 c0                	test   %eax,%eax
80104f84:	89 c3                	mov    %eax,%ebx
80104f86:	0f 84 cc 00 00 00    	je     80105058 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104f8c:	83 ec 0c             	sub    $0xc,%esp
80104f8f:	50                   	push   %eax
80104f90:	e8 8b ca ff ff       	call   80101a20 <ilock>
  ip->major = major;
80104f95:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104f99:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104f9d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104fa1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104fa5:	b8 01 00 00 00       	mov    $0x1,%eax
80104faa:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104fae:	89 1c 24             	mov    %ebx,(%esp)
80104fb1:	e8 ba c9 ff ff       	call   80101970 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104fb6:	83 c4 10             	add    $0x10,%esp
80104fb9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104fbe:	74 40                	je     80105000 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104fc0:	83 ec 04             	sub    $0x4,%esp
80104fc3:	ff 73 04             	pushl  0x4(%ebx)
80104fc6:	56                   	push   %esi
80104fc7:	57                   	push   %edi
80104fc8:	e8 e3 d1 ff ff       	call   801021b0 <dirlink>
80104fcd:	83 c4 10             	add    $0x10,%esp
80104fd0:	85 c0                	test   %eax,%eax
80104fd2:	78 77                	js     8010504b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104fd4:	83 ec 0c             	sub    $0xc,%esp
80104fd7:	57                   	push   %edi
80104fd8:	e8 d3 cc ff ff       	call   80101cb0 <iunlockput>

  return ip;
80104fdd:	83 c4 10             	add    $0x10,%esp
}
80104fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104fe3:	89 d8                	mov    %ebx,%eax
}
80104fe5:	5b                   	pop    %ebx
80104fe6:	5e                   	pop    %esi
80104fe7:	5f                   	pop    %edi
80104fe8:	5d                   	pop    %ebp
80104fe9:	c3                   	ret    
80104fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104ff0:	31 c0                	xor    %eax,%eax
80104ff2:	e9 47 ff ff ff       	jmp    80104f3e <create+0x6e>
80104ff7:	89 f6                	mov    %esi,%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105000:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80105005:	83 ec 0c             	sub    $0xc,%esp
80105008:	57                   	push   %edi
80105009:	e8 62 c9 ff ff       	call   80101970 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010500e:	83 c4 0c             	add    $0xc,%esp
80105011:	ff 73 04             	pushl  0x4(%ebx)
80105014:	68 50 7f 10 80       	push   $0x80107f50
80105019:	53                   	push   %ebx
8010501a:	e8 91 d1 ff ff       	call   801021b0 <dirlink>
8010501f:	83 c4 10             	add    $0x10,%esp
80105022:	85 c0                	test   %eax,%eax
80105024:	78 18                	js     8010503e <create+0x16e>
80105026:	83 ec 04             	sub    $0x4,%esp
80105029:	ff 77 04             	pushl  0x4(%edi)
8010502c:	68 4f 7f 10 80       	push   $0x80107f4f
80105031:	53                   	push   %ebx
80105032:	e8 79 d1 ff ff       	call   801021b0 <dirlink>
80105037:	83 c4 10             	add    $0x10,%esp
8010503a:	85 c0                	test   %eax,%eax
8010503c:	79 82                	jns    80104fc0 <create+0xf0>
      panic("create dots");
8010503e:	83 ec 0c             	sub    $0xc,%esp
80105041:	68 43 7f 10 80       	push   $0x80107f43
80105046:	e8 25 b3 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010504b:	83 ec 0c             	sub    $0xc,%esp
8010504e:	68 52 7f 10 80       	push   $0x80107f52
80105053:	e8 18 b3 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105058:	83 ec 0c             	sub    $0xc,%esp
8010505b:	68 34 7f 10 80       	push   $0x80107f34
80105060:	e8 0b b3 ff ff       	call   80100370 <panic>
80105065:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	56                   	push   %esi
80105074:	53                   	push   %ebx
80105075:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105077:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010507a:	89 d3                	mov    %edx,%ebx
8010507c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010507f:	50                   	push   %eax
80105080:	6a 00                	push   $0x0
80105082:	e8 f9 fc ff ff       	call   80104d80 <argint>
80105087:	83 c4 10             	add    $0x10,%esp
8010508a:	85 c0                	test   %eax,%eax
8010508c:	78 32                	js     801050c0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010508e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105092:	77 2c                	ja     801050c0 <argfd.constprop.0+0x50>
80105094:	e8 c7 ea ff ff       	call   80103b60 <myproc>
80105099:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010509c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801050a0:	85 c0                	test   %eax,%eax
801050a2:	74 1c                	je     801050c0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
801050a4:	85 f6                	test   %esi,%esi
801050a6:	74 02                	je     801050aa <argfd.constprop.0+0x3a>
    *pfd = fd;
801050a8:	89 16                	mov    %edx,(%esi)
  if(pf)
801050aa:	85 db                	test   %ebx,%ebx
801050ac:	74 22                	je     801050d0 <argfd.constprop.0+0x60>
    *pf = f;
801050ae:	89 03                	mov    %eax,(%ebx)
  return 0;
801050b0:	31 c0                	xor    %eax,%eax
}
801050b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050b5:	5b                   	pop    %ebx
801050b6:	5e                   	pop    %esi
801050b7:	5d                   	pop    %ebp
801050b8:	c3                   	ret    
801050b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
801050c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
801050c8:	5b                   	pop    %ebx
801050c9:	5e                   	pop    %esi
801050ca:	5d                   	pop    %ebp
801050cb:	c3                   	ret    
801050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801050d0:	31 c0                	xor    %eax,%eax
801050d2:	eb de                	jmp    801050b2 <argfd.constprop.0+0x42>
801050d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801050e0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801050e0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801050e1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801050e3:	89 e5                	mov    %esp,%ebp
801050e5:	56                   	push   %esi
801050e6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801050e7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
801050ea:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801050ed:	e8 7e ff ff ff       	call   80105070 <argfd.constprop.0>
801050f2:	85 c0                	test   %eax,%eax
801050f4:	78 1a                	js     80105110 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801050f6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
801050f8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801050fb:	e8 60 ea ff ff       	call   80103b60 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105100:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105104:	85 d2                	test   %edx,%edx
80105106:	74 18                	je     80105120 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105108:	83 c3 01             	add    $0x1,%ebx
8010510b:	83 fb 10             	cmp    $0x10,%ebx
8010510e:	75 f0                	jne    80105100 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105110:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105118:	5b                   	pop    %ebx
80105119:	5e                   	pop    %esi
8010511a:	5d                   	pop    %ebp
8010511b:	c3                   	ret    
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105120:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105124:	83 ec 0c             	sub    $0xc,%esp
80105127:	ff 75 f4             	pushl  -0xc(%ebp)
8010512a:	e8 71 c0 ff ff       	call   801011a0 <filedup>
  return fd;
8010512f:	83 c4 10             	add    $0x10,%esp
}
80105132:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105135:	89 d8                	mov    %ebx,%eax
}
80105137:	5b                   	pop    %ebx
80105138:	5e                   	pop    %esi
80105139:	5d                   	pop    %ebp
8010513a:	c3                   	ret    
8010513b:	90                   	nop
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105140 <sys_read>:

int
sys_read(void)
{
80105140:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105141:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105143:	89 e5                	mov    %esp,%ebp
80105145:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105148:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010514b:	e8 20 ff ff ff       	call   80105070 <argfd.constprop.0>
80105150:	85 c0                	test   %eax,%eax
80105152:	78 4c                	js     801051a0 <sys_read+0x60>
80105154:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105157:	83 ec 08             	sub    $0x8,%esp
8010515a:	50                   	push   %eax
8010515b:	6a 02                	push   $0x2
8010515d:	e8 1e fc ff ff       	call   80104d80 <argint>
80105162:	83 c4 10             	add    $0x10,%esp
80105165:	85 c0                	test   %eax,%eax
80105167:	78 37                	js     801051a0 <sys_read+0x60>
80105169:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010516c:	83 ec 04             	sub    $0x4,%esp
8010516f:	ff 75 f0             	pushl  -0x10(%ebp)
80105172:	50                   	push   %eax
80105173:	6a 01                	push   $0x1
80105175:	e8 56 fc ff ff       	call   80104dd0 <argptr>
8010517a:	83 c4 10             	add    $0x10,%esp
8010517d:	85 c0                	test   %eax,%eax
8010517f:	78 1f                	js     801051a0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105181:	83 ec 04             	sub    $0x4,%esp
80105184:	ff 75 f0             	pushl  -0x10(%ebp)
80105187:	ff 75 f4             	pushl  -0xc(%ebp)
8010518a:	ff 75 ec             	pushl  -0x14(%ebp)
8010518d:	e8 7e c1 ff ff       	call   80101310 <fileread>
80105192:	83 c4 10             	add    $0x10,%esp
}
80105195:	c9                   	leave  
80105196:	c3                   	ret    
80105197:	89 f6                	mov    %esi,%esi
80105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    
801051a7:	89 f6                	mov    %esi,%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051b0 <sys_write>:

int
sys_write(void)
{
801051b0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051b1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
801051b3:	89 e5                	mov    %esp,%ebp
801051b5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051bb:	e8 b0 fe ff ff       	call   80105070 <argfd.constprop.0>
801051c0:	85 c0                	test   %eax,%eax
801051c2:	78 4c                	js     80105210 <sys_write+0x60>
801051c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051c7:	83 ec 08             	sub    $0x8,%esp
801051ca:	50                   	push   %eax
801051cb:	6a 02                	push   $0x2
801051cd:	e8 ae fb ff ff       	call   80104d80 <argint>
801051d2:	83 c4 10             	add    $0x10,%esp
801051d5:	85 c0                	test   %eax,%eax
801051d7:	78 37                	js     80105210 <sys_write+0x60>
801051d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051dc:	83 ec 04             	sub    $0x4,%esp
801051df:	ff 75 f0             	pushl  -0x10(%ebp)
801051e2:	50                   	push   %eax
801051e3:	6a 01                	push   $0x1
801051e5:	e8 e6 fb ff ff       	call   80104dd0 <argptr>
801051ea:	83 c4 10             	add    $0x10,%esp
801051ed:	85 c0                	test   %eax,%eax
801051ef:	78 1f                	js     80105210 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801051f1:	83 ec 04             	sub    $0x4,%esp
801051f4:	ff 75 f0             	pushl  -0x10(%ebp)
801051f7:	ff 75 f4             	pushl  -0xc(%ebp)
801051fa:	ff 75 ec             	pushl  -0x14(%ebp)
801051fd:	e8 9e c1 ff ff       	call   801013a0 <filewrite>
80105202:	83 c4 10             	add    $0x10,%esp
}
80105205:	c9                   	leave  
80105206:	c3                   	ret    
80105207:	89 f6                	mov    %esi,%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105215:	c9                   	leave  
80105216:	c3                   	ret    
80105217:	89 f6                	mov    %esi,%esi
80105219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105220 <sys_close>:

int
sys_close(void)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105226:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105229:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010522c:	e8 3f fe ff ff       	call   80105070 <argfd.constprop.0>
80105231:	85 c0                	test   %eax,%eax
80105233:	78 2b                	js     80105260 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105235:	e8 26 e9 ff ff       	call   80103b60 <myproc>
8010523a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010523d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105240:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105247:	00 
  fileclose(f);
80105248:	ff 75 f4             	pushl  -0xc(%ebp)
8010524b:	e8 a0 bf ff ff       	call   801011f0 <fileclose>
  return 0;
80105250:	83 c4 10             	add    $0x10,%esp
80105253:	31 c0                	xor    %eax,%eax
}
80105255:	c9                   	leave  
80105256:	c3                   	ret    
80105257:	89 f6                	mov    %esi,%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105265:	c9                   	leave  
80105266:	c3                   	ret    
80105267:	89 f6                	mov    %esi,%esi
80105269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105270 <sys_fstat>:

int
sys_fstat(void)
{
80105270:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105271:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105273:	89 e5                	mov    %esp,%ebp
80105275:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105278:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010527b:	e8 f0 fd ff ff       	call   80105070 <argfd.constprop.0>
80105280:	85 c0                	test   %eax,%eax
80105282:	78 2c                	js     801052b0 <sys_fstat+0x40>
80105284:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105287:	83 ec 04             	sub    $0x4,%esp
8010528a:	6a 14                	push   $0x14
8010528c:	50                   	push   %eax
8010528d:	6a 01                	push   $0x1
8010528f:	e8 3c fb ff ff       	call   80104dd0 <argptr>
80105294:	83 c4 10             	add    $0x10,%esp
80105297:	85 c0                	test   %eax,%eax
80105299:	78 15                	js     801052b0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010529b:	83 ec 08             	sub    $0x8,%esp
8010529e:	ff 75 f4             	pushl  -0xc(%ebp)
801052a1:	ff 75 f0             	pushl  -0x10(%ebp)
801052a4:	e8 17 c0 ff ff       	call   801012c0 <filestat>
801052a9:	83 c4 10             	add    $0x10,%esp
}
801052ac:	c9                   	leave  
801052ad:	c3                   	ret    
801052ae:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
801052b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
801052b5:	c9                   	leave  
801052b6:	c3                   	ret    
801052b7:	89 f6                	mov    %esi,%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
801052c5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052c6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801052c9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052cc:	50                   	push   %eax
801052cd:	6a 00                	push   $0x0
801052cf:	e8 5c fb ff ff       	call   80104e30 <argstr>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	0f 88 fb 00 00 00    	js     801053da <sys_link+0x11a>
801052df:	8d 45 d0             	lea    -0x30(%ebp),%eax
801052e2:	83 ec 08             	sub    $0x8,%esp
801052e5:	50                   	push   %eax
801052e6:	6a 01                	push   $0x1
801052e8:	e8 43 fb ff ff       	call   80104e30 <argstr>
801052ed:	83 c4 10             	add    $0x10,%esp
801052f0:	85 c0                	test   %eax,%eax
801052f2:	0f 88 e2 00 00 00    	js     801053da <sys_link+0x11a>
    return -1;

  begin_op();
801052f8:	e8 03 dc ff ff       	call   80102f00 <begin_op>
  if((ip = namei(old)) == 0){
801052fd:	83 ec 0c             	sub    $0xc,%esp
80105300:	ff 75 d4             	pushl  -0x2c(%ebp)
80105303:	e8 68 cf ff ff       	call   80102270 <namei>
80105308:	83 c4 10             	add    $0x10,%esp
8010530b:	85 c0                	test   %eax,%eax
8010530d:	89 c3                	mov    %eax,%ebx
8010530f:	0f 84 f3 00 00 00    	je     80105408 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105315:	83 ec 0c             	sub    $0xc,%esp
80105318:	50                   	push   %eax
80105319:	e8 02 c7 ff ff       	call   80101a20 <ilock>
  if(ip->type == T_DIR){
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105326:	0f 84 c4 00 00 00    	je     801053f0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010532c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105331:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105334:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105337:	53                   	push   %ebx
80105338:	e8 33 c6 ff ff       	call   80101970 <iupdate>
  iunlock(ip);
8010533d:	89 1c 24             	mov    %ebx,(%esp)
80105340:	e8 bb c7 ff ff       	call   80101b00 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105345:	58                   	pop    %eax
80105346:	5a                   	pop    %edx
80105347:	57                   	push   %edi
80105348:	ff 75 d0             	pushl  -0x30(%ebp)
8010534b:	e8 40 cf ff ff       	call   80102290 <nameiparent>
80105350:	83 c4 10             	add    $0x10,%esp
80105353:	85 c0                	test   %eax,%eax
80105355:	89 c6                	mov    %eax,%esi
80105357:	74 5b                	je     801053b4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105359:	83 ec 0c             	sub    $0xc,%esp
8010535c:	50                   	push   %eax
8010535d:	e8 be c6 ff ff       	call   80101a20 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	8b 03                	mov    (%ebx),%eax
80105367:	39 06                	cmp    %eax,(%esi)
80105369:	75 3d                	jne    801053a8 <sys_link+0xe8>
8010536b:	83 ec 04             	sub    $0x4,%esp
8010536e:	ff 73 04             	pushl  0x4(%ebx)
80105371:	57                   	push   %edi
80105372:	56                   	push   %esi
80105373:	e8 38 ce ff ff       	call   801021b0 <dirlink>
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	85 c0                	test   %eax,%eax
8010537d:	78 29                	js     801053a8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010537f:	83 ec 0c             	sub    $0xc,%esp
80105382:	56                   	push   %esi
80105383:	e8 28 c9 ff ff       	call   80101cb0 <iunlockput>
  iput(ip);
80105388:	89 1c 24             	mov    %ebx,(%esp)
8010538b:	e8 c0 c7 ff ff       	call   80101b50 <iput>

  end_op();
80105390:	e8 db db ff ff       	call   80102f70 <end_op>

  return 0;
80105395:	83 c4 10             	add    $0x10,%esp
80105398:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010539a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010539d:	5b                   	pop    %ebx
8010539e:	5e                   	pop    %esi
8010539f:	5f                   	pop    %edi
801053a0:	5d                   	pop    %ebp
801053a1:	c3                   	ret    
801053a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
801053a8:	83 ec 0c             	sub    $0xc,%esp
801053ab:	56                   	push   %esi
801053ac:	e8 ff c8 ff ff       	call   80101cb0 <iunlockput>
    goto bad;
801053b1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
801053b4:	83 ec 0c             	sub    $0xc,%esp
801053b7:	53                   	push   %ebx
801053b8:	e8 63 c6 ff ff       	call   80101a20 <ilock>
  ip->nlink--;
801053bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053c2:	89 1c 24             	mov    %ebx,(%esp)
801053c5:	e8 a6 c5 ff ff       	call   80101970 <iupdate>
  iunlockput(ip);
801053ca:	89 1c 24             	mov    %ebx,(%esp)
801053cd:	e8 de c8 ff ff       	call   80101cb0 <iunlockput>
  end_op();
801053d2:	e8 99 db ff ff       	call   80102f70 <end_op>
  return -1;
801053d7:	83 c4 10             	add    $0x10,%esp
}
801053da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
801053dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053e2:	5b                   	pop    %ebx
801053e3:	5e                   	pop    %esi
801053e4:	5f                   	pop    %edi
801053e5:	5d                   	pop    %ebp
801053e6:	c3                   	ret    
801053e7:	89 f6                	mov    %esi,%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
801053f0:	83 ec 0c             	sub    $0xc,%esp
801053f3:	53                   	push   %ebx
801053f4:	e8 b7 c8 ff ff       	call   80101cb0 <iunlockput>
    end_op();
801053f9:	e8 72 db ff ff       	call   80102f70 <end_op>
    return -1;
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105406:	eb 92                	jmp    8010539a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105408:	e8 63 db ff ff       	call   80102f70 <end_op>
    return -1;
8010540d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105412:	eb 86                	jmp    8010539a <sys_link+0xda>
80105414:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010541a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105420 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	57                   	push   %edi
80105424:	56                   	push   %esi
80105425:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105426:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105429:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010542c:	50                   	push   %eax
8010542d:	6a 00                	push   $0x0
8010542f:	e8 fc f9 ff ff       	call   80104e30 <argstr>
80105434:	83 c4 10             	add    $0x10,%esp
80105437:	85 c0                	test   %eax,%eax
80105439:	0f 88 82 01 00 00    	js     801055c1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010543f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105442:	e8 b9 da ff ff       	call   80102f00 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105447:	83 ec 08             	sub    $0x8,%esp
8010544a:	53                   	push   %ebx
8010544b:	ff 75 c0             	pushl  -0x40(%ebp)
8010544e:	e8 3d ce ff ff       	call   80102290 <nameiparent>
80105453:	83 c4 10             	add    $0x10,%esp
80105456:	85 c0                	test   %eax,%eax
80105458:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010545b:	0f 84 6a 01 00 00    	je     801055cb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105461:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105464:	83 ec 0c             	sub    $0xc,%esp
80105467:	56                   	push   %esi
80105468:	e8 b3 c5 ff ff       	call   80101a20 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010546d:	58                   	pop    %eax
8010546e:	5a                   	pop    %edx
8010546f:	68 50 7f 10 80       	push   $0x80107f50
80105474:	53                   	push   %ebx
80105475:	e8 b6 ca ff ff       	call   80101f30 <namecmp>
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	85 c0                	test   %eax,%eax
8010547f:	0f 84 fc 00 00 00    	je     80105581 <sys_unlink+0x161>
80105485:	83 ec 08             	sub    $0x8,%esp
80105488:	68 4f 7f 10 80       	push   $0x80107f4f
8010548d:	53                   	push   %ebx
8010548e:	e8 9d ca ff ff       	call   80101f30 <namecmp>
80105493:	83 c4 10             	add    $0x10,%esp
80105496:	85 c0                	test   %eax,%eax
80105498:	0f 84 e3 00 00 00    	je     80105581 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010549e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801054a1:	83 ec 04             	sub    $0x4,%esp
801054a4:	50                   	push   %eax
801054a5:	53                   	push   %ebx
801054a6:	56                   	push   %esi
801054a7:	e8 a4 ca ff ff       	call   80101f50 <dirlookup>
801054ac:	83 c4 10             	add    $0x10,%esp
801054af:	85 c0                	test   %eax,%eax
801054b1:	89 c3                	mov    %eax,%ebx
801054b3:	0f 84 c8 00 00 00    	je     80105581 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
801054b9:	83 ec 0c             	sub    $0xc,%esp
801054bc:	50                   	push   %eax
801054bd:	e8 5e c5 ff ff       	call   80101a20 <ilock>

  if(ip->nlink < 1)
801054c2:	83 c4 10             	add    $0x10,%esp
801054c5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801054ca:	0f 8e 24 01 00 00    	jle    801055f4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801054d0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054d5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801054d8:	74 66                	je     80105540 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801054da:	83 ec 04             	sub    $0x4,%esp
801054dd:	6a 10                	push   $0x10
801054df:	6a 00                	push   $0x0
801054e1:	56                   	push   %esi
801054e2:	e8 89 f5 ff ff       	call   80104a70 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054e7:	6a 10                	push   $0x10
801054e9:	ff 75 c4             	pushl  -0x3c(%ebp)
801054ec:	56                   	push   %esi
801054ed:	ff 75 b4             	pushl  -0x4c(%ebp)
801054f0:	e8 0b c9 ff ff       	call   80101e00 <writei>
801054f5:	83 c4 20             	add    $0x20,%esp
801054f8:	83 f8 10             	cmp    $0x10,%eax
801054fb:	0f 85 e6 00 00 00    	jne    801055e7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105501:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105506:	0f 84 9c 00 00 00    	je     801055a8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010550c:	83 ec 0c             	sub    $0xc,%esp
8010550f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105512:	e8 99 c7 ff ff       	call   80101cb0 <iunlockput>

  ip->nlink--;
80105517:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010551c:	89 1c 24             	mov    %ebx,(%esp)
8010551f:	e8 4c c4 ff ff       	call   80101970 <iupdate>
  iunlockput(ip);
80105524:	89 1c 24             	mov    %ebx,(%esp)
80105527:	e8 84 c7 ff ff       	call   80101cb0 <iunlockput>

  end_op();
8010552c:	e8 3f da ff ff       	call   80102f70 <end_op>

  return 0;
80105531:	83 c4 10             	add    $0x10,%esp
80105534:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105536:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105539:	5b                   	pop    %ebx
8010553a:	5e                   	pop    %esi
8010553b:	5f                   	pop    %edi
8010553c:	5d                   	pop    %ebp
8010553d:	c3                   	ret    
8010553e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105540:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105544:	76 94                	jbe    801054da <sys_unlink+0xba>
80105546:	bf 20 00 00 00       	mov    $0x20,%edi
8010554b:	eb 0f                	jmp    8010555c <sys_unlink+0x13c>
8010554d:	8d 76 00             	lea    0x0(%esi),%esi
80105550:	83 c7 10             	add    $0x10,%edi
80105553:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105556:	0f 83 7e ff ff ff    	jae    801054da <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010555c:	6a 10                	push   $0x10
8010555e:	57                   	push   %edi
8010555f:	56                   	push   %esi
80105560:	53                   	push   %ebx
80105561:	e8 9a c7 ff ff       	call   80101d00 <readi>
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	83 f8 10             	cmp    $0x10,%eax
8010556c:	75 6c                	jne    801055da <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010556e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105573:	74 db                	je     80105550 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105575:	83 ec 0c             	sub    $0xc,%esp
80105578:	53                   	push   %ebx
80105579:	e8 32 c7 ff ff       	call   80101cb0 <iunlockput>
    goto bad;
8010557e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105581:	83 ec 0c             	sub    $0xc,%esp
80105584:	ff 75 b4             	pushl  -0x4c(%ebp)
80105587:	e8 24 c7 ff ff       	call   80101cb0 <iunlockput>
  end_op();
8010558c:	e8 df d9 ff ff       	call   80102f70 <end_op>
  return -1;
80105591:	83 c4 10             	add    $0x10,%esp
}
80105594:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105597:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010559c:	5b                   	pop    %ebx
8010559d:	5e                   	pop    %esi
8010559e:	5f                   	pop    %edi
8010559f:	5d                   	pop    %ebp
801055a0:	c3                   	ret    
801055a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801055a8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801055ab:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801055ae:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801055b3:	50                   	push   %eax
801055b4:	e8 b7 c3 ff ff       	call   80101970 <iupdate>
801055b9:	83 c4 10             	add    $0x10,%esp
801055bc:	e9 4b ff ff ff       	jmp    8010550c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
801055c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055c6:	e9 6b ff ff ff       	jmp    80105536 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
801055cb:	e8 a0 d9 ff ff       	call   80102f70 <end_op>
    return -1;
801055d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d5:	e9 5c ff ff ff       	jmp    80105536 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801055da:	83 ec 0c             	sub    $0xc,%esp
801055dd:	68 74 7f 10 80       	push   $0x80107f74
801055e2:	e8 89 ad ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801055e7:	83 ec 0c             	sub    $0xc,%esp
801055ea:	68 86 7f 10 80       	push   $0x80107f86
801055ef:	e8 7c ad ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801055f4:	83 ec 0c             	sub    $0xc,%esp
801055f7:	68 62 7f 10 80       	push   $0x80107f62
801055fc:	e8 6f ad ff ff       	call   80100370 <panic>
80105601:	eb 0d                	jmp    80105610 <sys_open>
80105603:	90                   	nop
80105604:	90                   	nop
80105605:	90                   	nop
80105606:	90                   	nop
80105607:	90                   	nop
80105608:	90                   	nop
80105609:	90                   	nop
8010560a:	90                   	nop
8010560b:	90                   	nop
8010560c:	90                   	nop
8010560d:	90                   	nop
8010560e:	90                   	nop
8010560f:	90                   	nop

80105610 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
80105615:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105616:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105619:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010561c:	50                   	push   %eax
8010561d:	6a 00                	push   $0x0
8010561f:	e8 0c f8 ff ff       	call   80104e30 <argstr>
80105624:	83 c4 10             	add    $0x10,%esp
80105627:	85 c0                	test   %eax,%eax
80105629:	0f 88 9e 00 00 00    	js     801056cd <sys_open+0xbd>
8010562f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105632:	83 ec 08             	sub    $0x8,%esp
80105635:	50                   	push   %eax
80105636:	6a 01                	push   $0x1
80105638:	e8 43 f7 ff ff       	call   80104d80 <argint>
8010563d:	83 c4 10             	add    $0x10,%esp
80105640:	85 c0                	test   %eax,%eax
80105642:	0f 88 85 00 00 00    	js     801056cd <sys_open+0xbd>
    return -1;

  begin_op();
80105648:	e8 b3 d8 ff ff       	call   80102f00 <begin_op>

  if(omode & O_CREATE){
8010564d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105651:	0f 85 89 00 00 00    	jne    801056e0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105657:	83 ec 0c             	sub    $0xc,%esp
8010565a:	ff 75 e0             	pushl  -0x20(%ebp)
8010565d:	e8 0e cc ff ff       	call   80102270 <namei>
80105662:	83 c4 10             	add    $0x10,%esp
80105665:	85 c0                	test   %eax,%eax
80105667:	89 c6                	mov    %eax,%esi
80105669:	0f 84 8e 00 00 00    	je     801056fd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010566f:	83 ec 0c             	sub    $0xc,%esp
80105672:	50                   	push   %eax
80105673:	e8 a8 c3 ff ff       	call   80101a20 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105680:	0f 84 d2 00 00 00    	je     80105758 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105686:	e8 a5 ba ff ff       	call   80101130 <filealloc>
8010568b:	85 c0                	test   %eax,%eax
8010568d:	89 c7                	mov    %eax,%edi
8010568f:	74 2b                	je     801056bc <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105691:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105693:	e8 c8 e4 ff ff       	call   80103b60 <myproc>
80105698:	90                   	nop
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801056a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801056a4:	85 d2                	test   %edx,%edx
801056a6:	74 68                	je     80105710 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801056a8:	83 c3 01             	add    $0x1,%ebx
801056ab:	83 fb 10             	cmp    $0x10,%ebx
801056ae:	75 f0                	jne    801056a0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801056b0:	83 ec 0c             	sub    $0xc,%esp
801056b3:	57                   	push   %edi
801056b4:	e8 37 bb ff ff       	call   801011f0 <fileclose>
801056b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801056bc:	83 ec 0c             	sub    $0xc,%esp
801056bf:	56                   	push   %esi
801056c0:	e8 eb c5 ff ff       	call   80101cb0 <iunlockput>
    end_op();
801056c5:	e8 a6 d8 ff ff       	call   80102f70 <end_op>
    return -1;
801056ca:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801056cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801056d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801056d5:	5b                   	pop    %ebx
801056d6:	5e                   	pop    %esi
801056d7:	5f                   	pop    %edi
801056d8:	5d                   	pop    %ebp
801056d9:	c3                   	ret    
801056da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801056e0:	83 ec 0c             	sub    $0xc,%esp
801056e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056e6:	31 c9                	xor    %ecx,%ecx
801056e8:	6a 00                	push   $0x0
801056ea:	ba 02 00 00 00       	mov    $0x2,%edx
801056ef:	e8 dc f7 ff ff       	call   80104ed0 <create>
    if(ip == 0){
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801056f9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801056fb:	75 89                	jne    80105686 <sys_open+0x76>
      end_op();
801056fd:	e8 6e d8 ff ff       	call   80102f70 <end_op>
      return -1;
80105702:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105707:	eb 43                	jmp    8010574c <sys_open+0x13c>
80105709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105710:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105713:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105717:	56                   	push   %esi
80105718:	e8 e3 c3 ff ff       	call   80101b00 <iunlock>
  end_op();
8010571d:	e8 4e d8 ff ff       	call   80102f70 <end_op>

  f->type = FD_INODE;
80105722:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105728:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010572b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010572e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105731:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105738:	89 d0                	mov    %edx,%eax
8010573a:	83 e0 01             	and    $0x1,%eax
8010573d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105740:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105743:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105746:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010574a:	89 d8                	mov    %ebx,%eax
}
8010574c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010574f:	5b                   	pop    %ebx
80105750:	5e                   	pop    %esi
80105751:	5f                   	pop    %edi
80105752:	5d                   	pop    %ebp
80105753:	c3                   	ret    
80105754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105758:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010575b:	85 c9                	test   %ecx,%ecx
8010575d:	0f 84 23 ff ff ff    	je     80105686 <sys_open+0x76>
80105763:	e9 54 ff ff ff       	jmp    801056bc <sys_open+0xac>
80105768:	90                   	nop
80105769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105770 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105776:	e8 85 d7 ff ff       	call   80102f00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010577b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010577e:	83 ec 08             	sub    $0x8,%esp
80105781:	50                   	push   %eax
80105782:	6a 00                	push   $0x0
80105784:	e8 a7 f6 ff ff       	call   80104e30 <argstr>
80105789:	83 c4 10             	add    $0x10,%esp
8010578c:	85 c0                	test   %eax,%eax
8010578e:	78 30                	js     801057c0 <sys_mkdir+0x50>
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105796:	31 c9                	xor    %ecx,%ecx
80105798:	6a 00                	push   $0x0
8010579a:	ba 01 00 00 00       	mov    $0x1,%edx
8010579f:	e8 2c f7 ff ff       	call   80104ed0 <create>
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	85 c0                	test   %eax,%eax
801057a9:	74 15                	je     801057c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057ab:	83 ec 0c             	sub    $0xc,%esp
801057ae:	50                   	push   %eax
801057af:	e8 fc c4 ff ff       	call   80101cb0 <iunlockput>
  end_op();
801057b4:	e8 b7 d7 ff ff       	call   80102f70 <end_op>
  return 0;
801057b9:	83 c4 10             	add    $0x10,%esp
801057bc:	31 c0                	xor    %eax,%eax
}
801057be:	c9                   	leave  
801057bf:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801057c0:	e8 ab d7 ff ff       	call   80102f70 <end_op>
    return -1;
801057c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801057ca:	c9                   	leave  
801057cb:	c3                   	ret    
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <sys_mknod>:

int
sys_mknod(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801057d6:	e8 25 d7 ff ff       	call   80102f00 <begin_op>
  if((argstr(0, &path)) < 0 ||
801057db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057de:	83 ec 08             	sub    $0x8,%esp
801057e1:	50                   	push   %eax
801057e2:	6a 00                	push   $0x0
801057e4:	e8 47 f6 ff ff       	call   80104e30 <argstr>
801057e9:	83 c4 10             	add    $0x10,%esp
801057ec:	85 c0                	test   %eax,%eax
801057ee:	78 60                	js     80105850 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801057f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057f3:	83 ec 08             	sub    $0x8,%esp
801057f6:	50                   	push   %eax
801057f7:	6a 01                	push   $0x1
801057f9:	e8 82 f5 ff ff       	call   80104d80 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801057fe:	83 c4 10             	add    $0x10,%esp
80105801:	85 c0                	test   %eax,%eax
80105803:	78 4b                	js     80105850 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105805:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105808:	83 ec 08             	sub    $0x8,%esp
8010580b:	50                   	push   %eax
8010580c:	6a 02                	push   $0x2
8010580e:	e8 6d f5 ff ff       	call   80104d80 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105813:	83 c4 10             	add    $0x10,%esp
80105816:	85 c0                	test   %eax,%eax
80105818:	78 36                	js     80105850 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010581a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010581e:	83 ec 0c             	sub    $0xc,%esp
80105821:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105825:	ba 03 00 00 00       	mov    $0x3,%edx
8010582a:	50                   	push   %eax
8010582b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010582e:	e8 9d f6 ff ff       	call   80104ed0 <create>
80105833:	83 c4 10             	add    $0x10,%esp
80105836:	85 c0                	test   %eax,%eax
80105838:	74 16                	je     80105850 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010583a:	83 ec 0c             	sub    $0xc,%esp
8010583d:	50                   	push   %eax
8010583e:	e8 6d c4 ff ff       	call   80101cb0 <iunlockput>
  end_op();
80105843:	e8 28 d7 ff ff       	call   80102f70 <end_op>
  return 0;
80105848:	83 c4 10             	add    $0x10,%esp
8010584b:	31 c0                	xor    %eax,%eax
}
8010584d:	c9                   	leave  
8010584e:	c3                   	ret    
8010584f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105850:	e8 1b d7 ff ff       	call   80102f70 <end_op>
    return -1;
80105855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010585a:	c9                   	leave  
8010585b:	c3                   	ret    
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105860 <sys_chdir>:

int
sys_chdir(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	56                   	push   %esi
80105864:	53                   	push   %ebx
80105865:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105868:	e8 f3 e2 ff ff       	call   80103b60 <myproc>
8010586d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010586f:	e8 8c d6 ff ff       	call   80102f00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105874:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105877:	83 ec 08             	sub    $0x8,%esp
8010587a:	50                   	push   %eax
8010587b:	6a 00                	push   $0x0
8010587d:	e8 ae f5 ff ff       	call   80104e30 <argstr>
80105882:	83 c4 10             	add    $0x10,%esp
80105885:	85 c0                	test   %eax,%eax
80105887:	78 77                	js     80105900 <sys_chdir+0xa0>
80105889:	83 ec 0c             	sub    $0xc,%esp
8010588c:	ff 75 f4             	pushl  -0xc(%ebp)
8010588f:	e8 dc c9 ff ff       	call   80102270 <namei>
80105894:	83 c4 10             	add    $0x10,%esp
80105897:	85 c0                	test   %eax,%eax
80105899:	89 c3                	mov    %eax,%ebx
8010589b:	74 63                	je     80105900 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010589d:	83 ec 0c             	sub    $0xc,%esp
801058a0:	50                   	push   %eax
801058a1:	e8 7a c1 ff ff       	call   80101a20 <ilock>
  if(ip->type != T_DIR){
801058a6:	83 c4 10             	add    $0x10,%esp
801058a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058ae:	75 30                	jne    801058e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058b0:	83 ec 0c             	sub    $0xc,%esp
801058b3:	53                   	push   %ebx
801058b4:	e8 47 c2 ff ff       	call   80101b00 <iunlock>
  iput(curproc->cwd);
801058b9:	58                   	pop    %eax
801058ba:	ff 76 68             	pushl  0x68(%esi)
801058bd:	e8 8e c2 ff ff       	call   80101b50 <iput>
  end_op();
801058c2:	e8 a9 d6 ff ff       	call   80102f70 <end_op>
  curproc->cwd = ip;
801058c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	31 c0                	xor    %eax,%eax
}
801058cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058d2:	5b                   	pop    %ebx
801058d3:	5e                   	pop    %esi
801058d4:	5d                   	pop    %ebp
801058d5:	c3                   	ret    
801058d6:	8d 76 00             	lea    0x0(%esi),%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	53                   	push   %ebx
801058e4:	e8 c7 c3 ff ff       	call   80101cb0 <iunlockput>
    end_op();
801058e9:	e8 82 d6 ff ff       	call   80102f70 <end_op>
    return -1;
801058ee:	83 c4 10             	add    $0x10,%esp
801058f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f6:	eb d7                	jmp    801058cf <sys_chdir+0x6f>
801058f8:	90                   	nop
801058f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105900:	e8 6b d6 ff ff       	call   80102f70 <end_op>
    return -1;
80105905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010590a:	eb c3                	jmp    801058cf <sys_chdir+0x6f>
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
80105915:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105916:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010591c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105922:	50                   	push   %eax
80105923:	6a 00                	push   $0x0
80105925:	e8 06 f5 ff ff       	call   80104e30 <argstr>
8010592a:	83 c4 10             	add    $0x10,%esp
8010592d:	85 c0                	test   %eax,%eax
8010592f:	78 7f                	js     801059b0 <sys_exec+0xa0>
80105931:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105937:	83 ec 08             	sub    $0x8,%esp
8010593a:	50                   	push   %eax
8010593b:	6a 01                	push   $0x1
8010593d:	e8 3e f4 ff ff       	call   80104d80 <argint>
80105942:	83 c4 10             	add    $0x10,%esp
80105945:	85 c0                	test   %eax,%eax
80105947:	78 67                	js     801059b0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105949:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010594f:	83 ec 04             	sub    $0x4,%esp
80105952:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105958:	68 80 00 00 00       	push   $0x80
8010595d:	6a 00                	push   $0x0
8010595f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105965:	50                   	push   %eax
80105966:	31 db                	xor    %ebx,%ebx
80105968:	e8 03 f1 ff ff       	call   80104a70 <memset>
8010596d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105970:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105976:	83 ec 08             	sub    $0x8,%esp
80105979:	57                   	push   %edi
8010597a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010597d:	50                   	push   %eax
8010597e:	e8 5d f3 ff ff       	call   80104ce0 <fetchint>
80105983:	83 c4 10             	add    $0x10,%esp
80105986:	85 c0                	test   %eax,%eax
80105988:	78 26                	js     801059b0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010598a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105990:	85 c0                	test   %eax,%eax
80105992:	74 2c                	je     801059c0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105994:	83 ec 08             	sub    $0x8,%esp
80105997:	56                   	push   %esi
80105998:	50                   	push   %eax
80105999:	e8 82 f3 ff ff       	call   80104d20 <fetchstr>
8010599e:	83 c4 10             	add    $0x10,%esp
801059a1:	85 c0                	test   %eax,%eax
801059a3:	78 0b                	js     801059b0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801059a5:	83 c3 01             	add    $0x1,%ebx
801059a8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801059ab:	83 fb 20             	cmp    $0x20,%ebx
801059ae:	75 c0                	jne    80105970 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801059b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801059b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801059b8:	5b                   	pop    %ebx
801059b9:	5e                   	pop    %esi
801059ba:	5f                   	pop    %edi
801059bb:	5d                   	pop    %ebp
801059bc:	c3                   	ret    
801059bd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801059c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801059c6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801059c9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801059d0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801059d4:	50                   	push   %eax
801059d5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801059db:	e8 10 b0 ff ff       	call   801009f0 <exec>
801059e0:	83 c4 10             	add    $0x10,%esp
}
801059e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059e6:	5b                   	pop    %ebx
801059e7:	5e                   	pop    %esi
801059e8:	5f                   	pop    %edi
801059e9:	5d                   	pop    %ebp
801059ea:	c3                   	ret    
801059eb:	90                   	nop
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_exec2>:

int 
sys_exec2(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i,stacksize;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
801059f6:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  return exec(path, argv);
}

int 
sys_exec2(void)
{
801059fc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i,stacksize;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
80105a02:	50                   	push   %eax
80105a03:	6a 00                	push   $0x0
80105a05:	e8 26 f4 ff ff       	call   80104e30 <argstr>
80105a0a:	83 c4 10             	add    $0x10,%esp
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	0f 88 9b 00 00 00    	js     80105ab0 <sys_exec2+0xc0>
80105a15:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a1b:	83 ec 08             	sub    $0x8,%esp
80105a1e:	50                   	push   %eax
80105a1f:	6a 01                	push   $0x1
80105a21:	e8 5a f3 ff ff       	call   80104d80 <argint>
80105a26:	83 c4 10             	add    $0x10,%esp
80105a29:	85 c0                	test   %eax,%eax
80105a2b:	0f 88 7f 00 00 00    	js     80105ab0 <sys_exec2+0xc0>
    return -1;
  if(argint(2,&stacksize)<0)
80105a31:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105a37:	83 ec 08             	sub    $0x8,%esp
80105a3a:	50                   	push   %eax
80105a3b:	6a 02                	push   $0x2
80105a3d:	e8 3e f3 ff ff       	call   80104d80 <argint>
80105a42:	83 c4 10             	add    $0x10,%esp
80105a45:	85 c0                	test   %eax,%eax
80105a47:	78 67                	js     80105ab0 <sys_exec2+0xc0>
    return -1;
  memset(argv, 0, sizeof(argv));
80105a49:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a4f:	83 ec 04             	sub    $0x4,%esp
80105a52:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105a58:	68 80 00 00 00       	push   $0x80
80105a5d:	6a 00                	push   $0x0
80105a5f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a65:	50                   	push   %eax
80105a66:	31 db                	xor    %ebx,%ebx
80105a68:	e8 03 f0 ff ff       	call   80104a70 <memset>
80105a6d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a70:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a76:	83 ec 08             	sub    $0x8,%esp
80105a79:	57                   	push   %edi
80105a7a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105a7d:	50                   	push   %eax
80105a7e:	e8 5d f2 ff ff       	call   80104ce0 <fetchint>
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	85 c0                	test   %eax,%eax
80105a88:	78 26                	js     80105ab0 <sys_exec2+0xc0>
      return -1;
    if(uarg == 0){
80105a8a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a90:	85 c0                	test   %eax,%eax
80105a92:	74 2c                	je     80105ac0 <sys_exec2+0xd0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a94:	83 ec 08             	sub    $0x8,%esp
80105a97:	56                   	push   %esi
80105a98:	50                   	push   %eax
80105a99:	e8 82 f2 ff ff       	call   80104d20 <fetchstr>
80105a9e:	83 c4 10             	add    $0x10,%esp
80105aa1:	85 c0                	test   %eax,%eax
80105aa3:	78 0b                	js     80105ab0 <sys_exec2+0xc0>
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  if(argint(2,&stacksize)<0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105aa5:	83 c3 01             	add    $0x1,%ebx
80105aa8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105aab:	83 fb 20             	cmp    $0x20,%ebx
80105aae:	75 c0                	jne    80105a70 <sys_exec2+0x80>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec2(path, argv,stacksize);
}
80105ab0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i,stacksize;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
80105ab3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec2(path, argv,stacksize);
}
80105ab8:	5b                   	pop    %ebx
80105ab9:	5e                   	pop    %esi
80105aba:	5f                   	pop    %edi
80105abb:	5d                   	pop    %ebp
80105abc:	c3                   	ret    
80105abd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec2(path, argv,stacksize);
80105ac0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ac6:	83 ec 04             	sub    $0x4,%esp
80105ac9:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105acf:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ad6:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec2(path, argv,stacksize);
80105ada:	50                   	push   %eax
80105adb:	ff b5 58 ff ff ff    	pushl  -0xa8(%ebp)
80105ae1:	e8 6a b2 ff ff       	call   80100d50 <exec2>
80105ae6:	83 c4 10             	add    $0x10,%esp
}
80105ae9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aec:	5b                   	pop    %ebx
80105aed:	5e                   	pop    %esi
80105aee:	5f                   	pop    %edi
80105aef:	5d                   	pop    %ebp
80105af0:	c3                   	ret    
80105af1:	eb 0d                	jmp    80105b00 <sys_pipe>
80105af3:	90                   	nop
80105af4:	90                   	nop
80105af5:	90                   	nop
80105af6:	90                   	nop
80105af7:	90                   	nop
80105af8:	90                   	nop
80105af9:	90                   	nop
80105afa:	90                   	nop
80105afb:	90                   	nop
80105afc:	90                   	nop
80105afd:	90                   	nop
80105afe:	90                   	nop
80105aff:	90                   	nop

80105b00 <sys_pipe>:

int
sys_pipe(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	56                   	push   %esi
80105b05:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b06:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec2(path, argv,stacksize);
}

int
sys_pipe(void)
{
80105b09:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b0c:	6a 08                	push   $0x8
80105b0e:	50                   	push   %eax
80105b0f:	6a 00                	push   $0x0
80105b11:	e8 ba f2 ff ff       	call   80104dd0 <argptr>
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	78 4a                	js     80105b67 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b1d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b20:	83 ec 08             	sub    $0x8,%esp
80105b23:	50                   	push   %eax
80105b24:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b27:	50                   	push   %eax
80105b28:	e8 73 da ff ff       	call   801035a0 <pipealloc>
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	85 c0                	test   %eax,%eax
80105b32:	78 33                	js     80105b67 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105b34:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b36:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105b39:	e8 22 e0 ff ff       	call   80103b60 <myproc>
80105b3e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105b40:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b44:	85 f6                	test   %esi,%esi
80105b46:	74 30                	je     80105b78 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105b48:	83 c3 01             	add    $0x1,%ebx
80105b4b:	83 fb 10             	cmp    $0x10,%ebx
80105b4e:	75 f0                	jne    80105b40 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105b50:	83 ec 0c             	sub    $0xc,%esp
80105b53:	ff 75 e0             	pushl  -0x20(%ebp)
80105b56:	e8 95 b6 ff ff       	call   801011f0 <fileclose>
    fileclose(wf);
80105b5b:	58                   	pop    %eax
80105b5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b5f:	e8 8c b6 ff ff       	call   801011f0 <fileclose>
    return -1;
80105b64:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105b67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105b6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105b6f:	5b                   	pop    %ebx
80105b70:	5e                   	pop    %esi
80105b71:	5f                   	pop    %edi
80105b72:	5d                   	pop    %ebp
80105b73:	c3                   	ret    
80105b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105b78:	8d 73 08             	lea    0x8(%ebx),%esi
80105b7b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b7f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105b82:	e8 d9 df ff ff       	call   80103b60 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105b87:	31 d2                	xor    %edx,%edx
80105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105b90:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b94:	85 c9                	test   %ecx,%ecx
80105b96:	74 18                	je     80105bb0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105b98:	83 c2 01             	add    $0x1,%edx
80105b9b:	83 fa 10             	cmp    $0x10,%edx
80105b9e:	75 f0                	jne    80105b90 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105ba0:	e8 bb df ff ff       	call   80103b60 <myproc>
80105ba5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105bac:	00 
80105bad:	eb a1                	jmp    80105b50 <sys_pipe+0x50>
80105baf:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105bb0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105bb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bb7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105bb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bbc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105bbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105bc2:	31 c0                	xor    %eax,%eax
}
80105bc4:	5b                   	pop    %ebx
80105bc5:	5e                   	pop    %esi
80105bc6:	5f                   	pop    %edi
80105bc7:	5d                   	pop    %ebp
80105bc8:	c3                   	ret    
80105bc9:	66 90                	xchg   %ax,%ax
80105bcb:	66 90                	xchg   %ax,%ax
80105bcd:	66 90                	xchg   %ax,%ax
80105bcf:	90                   	nop

80105bd0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105bd3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105bd4:	e9 37 e1 ff ff       	jmp    80103d10 <fork>
80105bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105be0 <sys_exit>:
}

int
sys_exit(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105be6:	e8 c5 e3 ff ff       	call   80103fb0 <exit>
  return 0;  // not reached
}
80105beb:	31 c0                	xor    %eax,%eax
80105bed:	c9                   	leave  
80105bee:	c3                   	ret    
80105bef:	90                   	nop

80105bf0 <sys_wait>:

int
sys_wait(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105bf3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105bf4:	e9 f7 e5 ff ff       	jmp    801041f0 <wait>
80105bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c00 <sys_kill>:
}

int
sys_kill(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c09:	50                   	push   %eax
80105c0a:	6a 00                	push   $0x0
80105c0c:	e8 6f f1 ff ff       	call   80104d80 <argint>
80105c11:	83 c4 10             	add    $0x10,%esp
80105c14:	85 c0                	test   %eax,%eax
80105c16:	78 18                	js     80105c30 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c18:	83 ec 0c             	sub    $0xc,%esp
80105c1b:	ff 75 f4             	pushl  -0xc(%ebp)
80105c1e:	e8 2d e7 ff ff       	call   80104350 <kill>
80105c23:	83 c4 10             	add    $0x10,%esp
}
80105c26:	c9                   	leave  
80105c27:	c3                   	ret    
80105c28:	90                   	nop
80105c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105c35:	c9                   	leave  
80105c36:	c3                   	ret    
80105c37:	89 f6                	mov    %esi,%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c40 <sys_getpid>:

int
sys_getpid(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c46:	e8 15 df ff ff       	call   80103b60 <myproc>
80105c4b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c4e:	c9                   	leave  
80105c4f:	c3                   	ret    

80105c50 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105c57:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c5a:	50                   	push   %eax
80105c5b:	6a 00                	push   $0x0
80105c5d:	e8 1e f1 ff ff       	call   80104d80 <argint>
80105c62:	83 c4 10             	add    $0x10,%esp
80105c65:	85 c0                	test   %eax,%eax
80105c67:	78 27                	js     80105c90 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c69:	e8 f2 de ff ff       	call   80103b60 <myproc>
  if(growproc(n) < 0)
80105c6e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105c71:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c73:	ff 75 f4             	pushl  -0xc(%ebp)
80105c76:	e8 05 e0 ff ff       	call   80103c80 <growproc>
80105c7b:	83 c4 10             	add    $0x10,%esp
80105c7e:	85 c0                	test   %eax,%eax
80105c80:	78 0e                	js     80105c90 <sys_sbrk+0x40>
    return -1;
  return addr;
80105c82:	89 d8                	mov    %ebx,%eax
}
80105c84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c87:	c9                   	leave  
80105c88:	c3                   	ret    
80105c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c95:	eb ed                	jmp    80105c84 <sys_sbrk+0x34>
80105c97:	89 f6                	mov    %esi,%esi
80105c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ca0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ca4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105ca7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105caa:	50                   	push   %eax
80105cab:	6a 00                	push   $0x0
80105cad:	e8 ce f0 ff ff       	call   80104d80 <argint>
80105cb2:	83 c4 10             	add    $0x10,%esp
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	0f 88 8a 00 00 00    	js     80105d47 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105cbd:	83 ec 0c             	sub    $0xc,%esp
80105cc0:	68 60 60 11 80       	push   $0x80116060
80105cc5:	e8 a6 ec ff ff       	call   80104970 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105cca:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ccd:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105cd0:	8b 1d a0 68 11 80    	mov    0x801168a0,%ebx
  while(ticks - ticks0 < n){
80105cd6:	85 d2                	test   %edx,%edx
80105cd8:	75 27                	jne    80105d01 <sys_sleep+0x61>
80105cda:	eb 54                	jmp    80105d30 <sys_sleep+0x90>
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ce0:	83 ec 08             	sub    $0x8,%esp
80105ce3:	68 60 60 11 80       	push   $0x80116060
80105ce8:	68 a0 68 11 80       	push   $0x801168a0
80105ced:	e8 3e e4 ff ff       	call   80104130 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105cf2:	a1 a0 68 11 80       	mov    0x801168a0,%eax
80105cf7:	83 c4 10             	add    $0x10,%esp
80105cfa:	29 d8                	sub    %ebx,%eax
80105cfc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105cff:	73 2f                	jae    80105d30 <sys_sleep+0x90>
    if(myproc()->killed){
80105d01:	e8 5a de ff ff       	call   80103b60 <myproc>
80105d06:	8b 40 24             	mov    0x24(%eax),%eax
80105d09:	85 c0                	test   %eax,%eax
80105d0b:	74 d3                	je     80105ce0 <sys_sleep+0x40>
      release(&tickslock);
80105d0d:	83 ec 0c             	sub    $0xc,%esp
80105d10:	68 60 60 11 80       	push   $0x80116060
80105d15:	e8 06 ed ff ff       	call   80104a20 <release>
      return -1;
80105d1a:	83 c4 10             	add    $0x10,%esp
80105d1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105d22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d25:	c9                   	leave  
80105d26:	c3                   	ret    
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105d30:	83 ec 0c             	sub    $0xc,%esp
80105d33:	68 60 60 11 80       	push   $0x80116060
80105d38:	e8 e3 ec ff ff       	call   80104a20 <release>
  return 0;
80105d3d:	83 c4 10             	add    $0x10,%esp
80105d40:	31 c0                	xor    %eax,%eax
}
80105d42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d45:	c9                   	leave  
80105d46:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105d47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d4c:	eb d4                	jmp    80105d22 <sys_sleep+0x82>
80105d4e:	66 90                	xchg   %ax,%ax

80105d50 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	53                   	push   %ebx
80105d54:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d57:	68 60 60 11 80       	push   $0x80116060
80105d5c:	e8 0f ec ff ff       	call   80104970 <acquire>
  xticks = ticks;
80105d61:	8b 1d a0 68 11 80    	mov    0x801168a0,%ebx
  release(&tickslock);
80105d67:	c7 04 24 60 60 11 80 	movl   $0x80116060,(%esp)
80105d6e:	e8 ad ec ff ff       	call   80104a20 <release>
  return xticks;
}
80105d73:	89 d8                	mov    %ebx,%eax
80105d75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d78:	c9                   	leave  
80105d79:	c3                   	ret    
80105d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d80 <sys_getppid>:

int
sys_getppid(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	83 ec 08             	sub    $0x8,%esp
    return myproc()->parent->pid;
80105d86:	e8 d5 dd ff ff       	call   80103b60 <myproc>
80105d8b:	8b 40 14             	mov    0x14(%eax),%eax
80105d8e:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d91:	c9                   	leave  
80105d92:	c3                   	ret    
80105d93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105da0 <sys_getadmin>:


int
sys_getadmin(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	53                   	push   %ebx
    char * pwd;
    if(argstr(0,&pwd)<0)
80105da4:	8d 45 f4             	lea    -0xc(%ebp),%eax
}


int
sys_getadmin(void)
{
80105da7:	83 ec 1c             	sub    $0x1c,%esp
    char * pwd;
    if(argstr(0,&pwd)<0)
80105daa:	50                   	push   %eax
80105dab:	6a 00                	push   $0x0
80105dad:	e8 7e f0 ff ff       	call   80104e30 <argstr>
80105db2:	83 c4 10             	add    $0x10,%esp
80105db5:	85 c0                	test   %eax,%eax
80105db7:	78 37                	js     80105df0 <sys_getadmin+0x50>
      return -1;

    if(strncmp(pwd,"2016025678",10)==0){
80105db9:	83 ec 04             	sub    $0x4,%esp
80105dbc:	6a 0a                	push   $0xa
80105dbe:	68 95 7f 10 80       	push   $0x80107f95
80105dc3:	ff 75 f4             	pushl  -0xc(%ebp)
80105dc6:	e8 d5 ed ff ff       	call   80104ba0 <strncmp>
80105dcb:	83 c4 10             	add    $0x10,%esp
80105dce:	85 c0                	test   %eax,%eax
80105dd0:	89 c3                	mov    %eax,%ebx
80105dd2:	75 1c                	jne    80105df0 <sys_getadmin+0x50>
      myproc()->mode=1;
80105dd4:	e8 87 dd ff ff       	call   80103b60 <myproc>
80105dd9:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
      return 0;
    }
    else 
      return -1;
}
80105de0:	89 d8                	mov    %ebx,%eax
80105de2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105de5:	c9                   	leave  
80105de6:	c3                   	ret    
80105de7:	89 f6                	mov    %esi,%esi
80105de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
int
sys_getadmin(void)
{
    char * pwd;
    if(argstr(0,&pwd)<0)
      return -1;
80105df0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      myproc()->mode=1;
      return 0;
    }
    else 
      return -1;
}
80105df5:	89 d8                	mov    %ebx,%eax
80105df7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dfa:	c9                   	leave  
80105dfb:	c3                   	ret    
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e00 <sys_setmemorylimit>:

int 
sys_setmemorylimit(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	83 ec 20             	sub    $0x20,%esp
    int pid, limit;
    if(argint(0,&pid)<0 || argint(1,&limit)<0)
80105e06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e09:	50                   	push   %eax
80105e0a:	6a 00                	push   $0x0
80105e0c:	e8 6f ef ff ff       	call   80104d80 <argint>
80105e11:	83 c4 10             	add    $0x10,%esp
80105e14:	85 c0                	test   %eax,%eax
80105e16:	78 30                	js     80105e48 <sys_setmemorylimit+0x48>
80105e18:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e1b:	83 ec 08             	sub    $0x8,%esp
80105e1e:	50                   	push   %eax
80105e1f:	6a 01                	push   $0x1
80105e21:	e8 5a ef ff ff       	call   80104d80 <argint>
80105e26:	83 c4 10             	add    $0x10,%esp
80105e29:	85 c0                	test   %eax,%eax
80105e2b:	78 1b                	js     80105e48 <sys_setmemorylimit+0x48>
      return -1;
    if(limit<0)
80105e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e30:	85 c0                	test   %eax,%eax
80105e32:	78 14                	js     80105e48 <sys_setmemorylimit+0x48>
      return -1;
    else
      return setmemorylimit(pid,limit);
80105e34:	83 ec 08             	sub    $0x8,%esp
80105e37:	50                   	push   %eax
80105e38:	ff 75 f0             	pushl  -0x10(%ebp)
80105e3b:	e8 60 e6 ff ff       	call   801044a0 <setmemorylimit>
80105e40:	83 c4 10             	add    $0x10,%esp
}
80105e43:	c9                   	leave  
80105e44:	c3                   	ret    
80105e45:	8d 76 00             	lea    0x0(%esi),%esi
int 
sys_setmemorylimit(void)
{
    int pid, limit;
    if(argint(0,&pid)<0 || argint(1,&limit)<0)
      return -1;
80105e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(limit<0)
      return -1;
    else
      return setmemorylimit(pid,limit);
}
80105e4d:	c9                   	leave  
80105e4e:	c3                   	ret    
80105e4f:	90                   	nop

80105e50 <sys_proclist>:

int 
sys_proclist(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	83 ec 08             	sub    $0x8,%esp
  proclist();
80105e56:	e8 e5 e6 ff ff       	call   80104540 <proclist>
  return 0;
}
80105e5b:	31 c0                	xor    %eax,%eax
80105e5d:	c9                   	leave  
80105e5e:	c3                   	ret    
80105e5f:	90                   	nop

80105e60 <sys_getshmem>:

char*
sys_getshmem(void)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0,&pid)<0)
80105e66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e69:	50                   	push   %eax
80105e6a:	6a 00                	push   $0x0
80105e6c:	e8 0f ef ff ff       	call   80104d80 <argint>
80105e71:	83 c4 10             	add    $0x10,%esp
80105e74:	85 c0                	test   %eax,%eax
80105e76:	ba ed 7d 10 80       	mov    $0x80107ded,%edx
80105e7b:	78 10                	js     80105e8d <sys_getshmem+0x2d>
    return "shmem failed!\n";
  else
    return getshmem(pid);
80105e7d:	83 ec 0c             	sub    $0xc,%esp
80105e80:	ff 75 f4             	pushl  -0xc(%ebp)
80105e83:	e8 38 e8 ff ff       	call   801046c0 <getshmem>
80105e88:	83 c4 10             	add    $0x10,%esp
80105e8b:	89 c2                	mov    %eax,%edx
}  
80105e8d:	89 d0                	mov    %edx,%eax
80105e8f:	c9                   	leave  
80105e90:	c3                   	ret    

80105e91 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e91:	1e                   	push   %ds
  pushl %es
80105e92:	06                   	push   %es
  pushl %fs
80105e93:	0f a0                	push   %fs
  pushl %gs
80105e95:	0f a8                	push   %gs
  pushal
80105e97:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e98:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e9c:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e9e:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ea0:	54                   	push   %esp
  call trap
80105ea1:	e8 ea 00 00 00       	call   80105f90 <trap>
  addl $4, %esp
80105ea6:	83 c4 04             	add    $0x4,%esp

80105ea9 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ea9:	61                   	popa   
  popl %gs
80105eaa:	0f a9                	pop    %gs
  popl %fs
80105eac:	0f a1                	pop    %fs
  popl %es
80105eae:	07                   	pop    %es
  popl %ds
80105eaf:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105eb0:	83 c4 08             	add    $0x8,%esp
  iret
80105eb3:	cf                   	iret   
80105eb4:	66 90                	xchg   %ax,%ax
80105eb6:	66 90                	xchg   %ax,%ax
80105eb8:	66 90                	xchg   %ax,%ax
80105eba:	66 90                	xchg   %ax,%ax
80105ebc:	66 90                	xchg   %ax,%ax
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105ec0:	31 c0                	xor    %eax,%eax
80105ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ec8:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ecf:	b9 08 00 00 00       	mov    $0x8,%ecx
80105ed4:	c6 04 c5 a4 60 11 80 	movb   $0x0,-0x7fee9f5c(,%eax,8)
80105edb:	00 
80105edc:	66 89 0c c5 a2 60 11 	mov    %cx,-0x7fee9f5e(,%eax,8)
80105ee3:	80 
80105ee4:	c6 04 c5 a5 60 11 80 	movb   $0x8e,-0x7fee9f5b(,%eax,8)
80105eeb:	8e 
80105eec:	66 89 14 c5 a0 60 11 	mov    %dx,-0x7fee9f60(,%eax,8)
80105ef3:	80 
80105ef4:	c1 ea 10             	shr    $0x10,%edx
80105ef7:	66 89 14 c5 a6 60 11 	mov    %dx,-0x7fee9f5a(,%eax,8)
80105efe:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105eff:	83 c0 01             	add    $0x1,%eax
80105f02:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f07:	75 bf                	jne    80105ec8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f09:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f0a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f0f:	89 e5                	mov    %esp,%ebp
80105f11:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f14:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105f19:	68 a0 7f 10 80       	push   $0x80107fa0
80105f1e:	68 60 60 11 80       	push   $0x80116060
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f23:	66 89 15 a2 62 11 80 	mov    %dx,0x801162a2
80105f2a:	c6 05 a4 62 11 80 00 	movb   $0x0,0x801162a4
80105f31:	66 a3 a0 62 11 80    	mov    %ax,0x801162a0
80105f37:	c1 e8 10             	shr    $0x10,%eax
80105f3a:	c6 05 a5 62 11 80 ef 	movb   $0xef,0x801162a5
80105f41:	66 a3 a6 62 11 80    	mov    %ax,0x801162a6

  initlock(&tickslock, "time");
80105f47:	e8 c4 e8 ff ff       	call   80104810 <initlock>
}
80105f4c:	83 c4 10             	add    $0x10,%esp
80105f4f:	c9                   	leave  
80105f50:	c3                   	ret    
80105f51:	eb 0d                	jmp    80105f60 <idtinit>
80105f53:	90                   	nop
80105f54:	90                   	nop
80105f55:	90                   	nop
80105f56:	90                   	nop
80105f57:	90                   	nop
80105f58:	90                   	nop
80105f59:	90                   	nop
80105f5a:	90                   	nop
80105f5b:	90                   	nop
80105f5c:	90                   	nop
80105f5d:	90                   	nop
80105f5e:	90                   	nop
80105f5f:	90                   	nop

80105f60 <idtinit>:

void
idtinit(void)
{
80105f60:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105f61:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f66:	89 e5                	mov    %esp,%ebp
80105f68:	83 ec 10             	sub    $0x10,%esp
80105f6b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f6f:	b8 a0 60 11 80       	mov    $0x801160a0,%eax
80105f74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f78:	c1 e8 10             	shr    $0x10,%eax
80105f7b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105f7f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f82:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105f85:	c9                   	leave  
80105f86:	c3                   	ret    
80105f87:	89 f6                	mov    %esi,%esi
80105f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f90 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	57                   	push   %edi
80105f94:	56                   	push   %esi
80105f95:	53                   	push   %ebx
80105f96:	83 ec 1c             	sub    $0x1c,%esp
80105f99:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105f9c:	8b 47 30             	mov    0x30(%edi),%eax
80105f9f:	83 f8 40             	cmp    $0x40,%eax
80105fa2:	0f 84 88 01 00 00    	je     80106130 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105fa8:	83 e8 20             	sub    $0x20,%eax
80105fab:	83 f8 1f             	cmp    $0x1f,%eax
80105fae:	77 10                	ja     80105fc0 <trap+0x30>
80105fb0:	ff 24 85 48 80 10 80 	jmp    *-0x7fef7fb8(,%eax,4)
80105fb7:	89 f6                	mov    %esi,%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105fc0:	e8 9b db ff ff       	call   80103b60 <myproc>
80105fc5:	85 c0                	test   %eax,%eax
80105fc7:	0f 84 d7 01 00 00    	je     801061a4 <trap+0x214>
80105fcd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105fd1:	0f 84 cd 01 00 00    	je     801061a4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105fd7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fda:	8b 57 38             	mov    0x38(%edi),%edx
80105fdd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105fe0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105fe3:	e8 58 db ff ff       	call   80103b40 <cpuid>
80105fe8:	8b 77 34             	mov    0x34(%edi),%esi
80105feb:	8b 5f 30             	mov    0x30(%edi),%ebx
80105fee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105ff1:	e8 6a db ff ff       	call   80103b60 <myproc>
80105ff6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ff9:	e8 62 db ff ff       	call   80103b60 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ffe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106001:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106004:	51                   	push   %ecx
80106005:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106006:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106009:	ff 75 e4             	pushl  -0x1c(%ebp)
8010600c:	56                   	push   %esi
8010600d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010600e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106011:	52                   	push   %edx
80106012:	ff 70 10             	pushl  0x10(%eax)
80106015:	68 04 80 10 80       	push   $0x80108004
8010601a:	e8 41 a6 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010601f:	83 c4 20             	add    $0x20,%esp
80106022:	e8 39 db ff ff       	call   80103b60 <myproc>
80106027:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010602e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106030:	e8 2b db ff ff       	call   80103b60 <myproc>
80106035:	85 c0                	test   %eax,%eax
80106037:	74 0c                	je     80106045 <trap+0xb5>
80106039:	e8 22 db ff ff       	call   80103b60 <myproc>
8010603e:	8b 50 24             	mov    0x24(%eax),%edx
80106041:	85 d2                	test   %edx,%edx
80106043:	75 4b                	jne    80106090 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106045:	e8 16 db ff ff       	call   80103b60 <myproc>
8010604a:	85 c0                	test   %eax,%eax
8010604c:	74 0b                	je     80106059 <trap+0xc9>
8010604e:	e8 0d db ff ff       	call   80103b60 <myproc>
80106053:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106057:	74 4f                	je     801060a8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106059:	e8 02 db ff ff       	call   80103b60 <myproc>
8010605e:	85 c0                	test   %eax,%eax
80106060:	74 1d                	je     8010607f <trap+0xef>
80106062:	e8 f9 da ff ff       	call   80103b60 <myproc>
80106067:	8b 40 24             	mov    0x24(%eax),%eax
8010606a:	85 c0                	test   %eax,%eax
8010606c:	74 11                	je     8010607f <trap+0xef>
8010606e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106072:	83 e0 03             	and    $0x3,%eax
80106075:	66 83 f8 03          	cmp    $0x3,%ax
80106079:	0f 84 da 00 00 00    	je     80106159 <trap+0x1c9>
    exit();
}
8010607f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106082:	5b                   	pop    %ebx
80106083:	5e                   	pop    %esi
80106084:	5f                   	pop    %edi
80106085:	5d                   	pop    %ebp
80106086:	c3                   	ret    
80106087:	89 f6                	mov    %esi,%esi
80106089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106090:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106094:	83 e0 03             	and    $0x3,%eax
80106097:	66 83 f8 03          	cmp    $0x3,%ax
8010609b:	75 a8                	jne    80106045 <trap+0xb5>
    exit();
8010609d:	e8 0e df ff ff       	call   80103fb0 <exit>
801060a2:	eb a1                	jmp    80106045 <trap+0xb5>
801060a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801060a8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801060ac:	75 ab                	jne    80106059 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801060ae:	e8 2d e0 ff ff       	call   801040e0 <yield>
801060b3:	eb a4                	jmp    80106059 <trap+0xc9>
801060b5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801060b8:	e8 83 da ff ff       	call   80103b40 <cpuid>
801060bd:	85 c0                	test   %eax,%eax
801060bf:	0f 84 ab 00 00 00    	je     80106170 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801060c5:	e8 f6 c9 ff ff       	call   80102ac0 <lapiceoi>
    break;
801060ca:	e9 61 ff ff ff       	jmp    80106030 <trap+0xa0>
801060cf:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801060d0:	e8 ab c8 ff ff       	call   80102980 <kbdintr>
    lapiceoi();
801060d5:	e8 e6 c9 ff ff       	call   80102ac0 <lapiceoi>
    break;
801060da:	e9 51 ff ff ff       	jmp    80106030 <trap+0xa0>
801060df:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801060e0:	e8 5b 02 00 00       	call   80106340 <uartintr>
    lapiceoi();
801060e5:	e8 d6 c9 ff ff       	call   80102ac0 <lapiceoi>
    break;
801060ea:	e9 41 ff ff ff       	jmp    80106030 <trap+0xa0>
801060ef:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801060f0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801060f4:	8b 77 38             	mov    0x38(%edi),%esi
801060f7:	e8 44 da ff ff       	call   80103b40 <cpuid>
801060fc:	56                   	push   %esi
801060fd:	53                   	push   %ebx
801060fe:	50                   	push   %eax
801060ff:	68 ac 7f 10 80       	push   $0x80107fac
80106104:	e8 57 a5 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106109:	e8 b2 c9 ff ff       	call   80102ac0 <lapiceoi>
    break;
8010610e:	83 c4 10             	add    $0x10,%esp
80106111:	e9 1a ff ff ff       	jmp    80106030 <trap+0xa0>
80106116:	8d 76 00             	lea    0x0(%esi),%esi
80106119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106120:	e8 db c2 ff ff       	call   80102400 <ideintr>
80106125:	eb 9e                	jmp    801060c5 <trap+0x135>
80106127:	89 f6                	mov    %esi,%esi
80106129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106130:	e8 2b da ff ff       	call   80103b60 <myproc>
80106135:	8b 58 24             	mov    0x24(%eax),%ebx
80106138:	85 db                	test   %ebx,%ebx
8010613a:	75 2c                	jne    80106168 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
8010613c:	e8 1f da ff ff       	call   80103b60 <myproc>
80106141:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106144:	e8 27 ed ff ff       	call   80104e70 <syscall>
    if(myproc()->killed)
80106149:	e8 12 da ff ff       	call   80103b60 <myproc>
8010614e:	8b 48 24             	mov    0x24(%eax),%ecx
80106151:	85 c9                	test   %ecx,%ecx
80106153:	0f 84 26 ff ff ff    	je     8010607f <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106159:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010615c:	5b                   	pop    %ebx
8010615d:	5e                   	pop    %esi
8010615e:	5f                   	pop    %edi
8010615f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106160:	e9 4b de ff ff       	jmp    80103fb0 <exit>
80106165:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106168:	e8 43 de ff ff       	call   80103fb0 <exit>
8010616d:	eb cd                	jmp    8010613c <trap+0x1ac>
8010616f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80106170:	83 ec 0c             	sub    $0xc,%esp
80106173:	68 60 60 11 80       	push   $0x80116060
80106178:	e8 f3 e7 ff ff       	call   80104970 <acquire>
      ticks++;
      wakeup(&ticks);
8010617d:	c7 04 24 a0 68 11 80 	movl   $0x801168a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80106184:	83 05 a0 68 11 80 01 	addl   $0x1,0x801168a0
      wakeup(&ticks);
8010618b:	e8 60 e1 ff ff       	call   801042f0 <wakeup>
      release(&tickslock);
80106190:	c7 04 24 60 60 11 80 	movl   $0x80116060,(%esp)
80106197:	e8 84 e8 ff ff       	call   80104a20 <release>
8010619c:	83 c4 10             	add    $0x10,%esp
8010619f:	e9 21 ff ff ff       	jmp    801060c5 <trap+0x135>
801061a4:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801061a7:	8b 5f 38             	mov    0x38(%edi),%ebx
801061aa:	e8 91 d9 ff ff       	call   80103b40 <cpuid>
801061af:	83 ec 0c             	sub    $0xc,%esp
801061b2:	56                   	push   %esi
801061b3:	53                   	push   %ebx
801061b4:	50                   	push   %eax
801061b5:	ff 77 30             	pushl  0x30(%edi)
801061b8:	68 d0 7f 10 80       	push   $0x80107fd0
801061bd:	e8 9e a4 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801061c2:	83 c4 14             	add    $0x14,%esp
801061c5:	68 a5 7f 10 80       	push   $0x80107fa5
801061ca:	e8 a1 a1 ff ff       	call   80100370 <panic>
801061cf:	90                   	nop

801061d0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801061d0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801061d5:	55                   	push   %ebp
801061d6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801061d8:	85 c0                	test   %eax,%eax
801061da:	74 1c                	je     801061f8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061dc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061e1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801061e2:	a8 01                	test   $0x1,%al
801061e4:	74 12                	je     801061f8 <uartgetc+0x28>
801061e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061eb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801061ec:	0f b6 c0             	movzbl %al,%eax
}
801061ef:	5d                   	pop    %ebp
801061f0:	c3                   	ret    
801061f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
801061f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
801061fd:	5d                   	pop    %ebp
801061fe:	c3                   	ret    
801061ff:	90                   	nop

80106200 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106200:	55                   	push   %ebp
80106201:	89 e5                	mov    %esp,%ebp
80106203:	57                   	push   %edi
80106204:	56                   	push   %esi
80106205:	53                   	push   %ebx
80106206:	89 c7                	mov    %eax,%edi
80106208:	bb 80 00 00 00       	mov    $0x80,%ebx
8010620d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106212:	83 ec 0c             	sub    $0xc,%esp
80106215:	eb 1b                	jmp    80106232 <uartputc.part.0+0x32>
80106217:	89 f6                	mov    %esi,%esi
80106219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106220:	83 ec 0c             	sub    $0xc,%esp
80106223:	6a 0a                	push   $0xa
80106225:	e8 b6 c8 ff ff       	call   80102ae0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010622a:	83 c4 10             	add    $0x10,%esp
8010622d:	83 eb 01             	sub    $0x1,%ebx
80106230:	74 07                	je     80106239 <uartputc.part.0+0x39>
80106232:	89 f2                	mov    %esi,%edx
80106234:	ec                   	in     (%dx),%al
80106235:	a8 20                	test   $0x20,%al
80106237:	74 e7                	je     80106220 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106239:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010623e:	89 f8                	mov    %edi,%eax
80106240:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106241:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106244:	5b                   	pop    %ebx
80106245:	5e                   	pop    %esi
80106246:	5f                   	pop    %edi
80106247:	5d                   	pop    %ebp
80106248:	c3                   	ret    
80106249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106250 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106250:	55                   	push   %ebp
80106251:	31 c9                	xor    %ecx,%ecx
80106253:	89 c8                	mov    %ecx,%eax
80106255:	89 e5                	mov    %esp,%ebp
80106257:	57                   	push   %edi
80106258:	56                   	push   %esi
80106259:	53                   	push   %ebx
8010625a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010625f:	89 da                	mov    %ebx,%edx
80106261:	83 ec 0c             	sub    $0xc,%esp
80106264:	ee                   	out    %al,(%dx)
80106265:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010626a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010626f:	89 fa                	mov    %edi,%edx
80106271:	ee                   	out    %al,(%dx)
80106272:	b8 0c 00 00 00       	mov    $0xc,%eax
80106277:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010627c:	ee                   	out    %al,(%dx)
8010627d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106282:	89 c8                	mov    %ecx,%eax
80106284:	89 f2                	mov    %esi,%edx
80106286:	ee                   	out    %al,(%dx)
80106287:	b8 03 00 00 00       	mov    $0x3,%eax
8010628c:	89 fa                	mov    %edi,%edx
8010628e:	ee                   	out    %al,(%dx)
8010628f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106294:	89 c8                	mov    %ecx,%eax
80106296:	ee                   	out    %al,(%dx)
80106297:	b8 01 00 00 00       	mov    $0x1,%eax
8010629c:	89 f2                	mov    %esi,%edx
8010629e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010629f:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062a4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801062a5:	3c ff                	cmp    $0xff,%al
801062a7:	74 5a                	je     80106303 <uartinit+0xb3>
    return;
  uart = 1;
801062a9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801062b0:	00 00 00 
801062b3:	89 da                	mov    %ebx,%edx
801062b5:	ec                   	in     (%dx),%al
801062b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062bb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801062bc:	83 ec 08             	sub    $0x8,%esp
801062bf:	bb c8 80 10 80       	mov    $0x801080c8,%ebx
801062c4:	6a 00                	push   $0x0
801062c6:	6a 04                	push   $0x4
801062c8:	e8 83 c3 ff ff       	call   80102650 <ioapicenable>
801062cd:	83 c4 10             	add    $0x10,%esp
801062d0:	b8 78 00 00 00       	mov    $0x78,%eax
801062d5:	eb 13                	jmp    801062ea <uartinit+0x9a>
801062d7:	89 f6                	mov    %esi,%esi
801062d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801062e0:	83 c3 01             	add    $0x1,%ebx
801062e3:	0f be 03             	movsbl (%ebx),%eax
801062e6:	84 c0                	test   %al,%al
801062e8:	74 19                	je     80106303 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
801062ea:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801062f0:	85 d2                	test   %edx,%edx
801062f2:	74 ec                	je     801062e0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801062f4:	83 c3 01             	add    $0x1,%ebx
801062f7:	e8 04 ff ff ff       	call   80106200 <uartputc.part.0>
801062fc:	0f be 03             	movsbl (%ebx),%eax
801062ff:	84 c0                	test   %al,%al
80106301:	75 e7                	jne    801062ea <uartinit+0x9a>
    uartputc(*p);
}
80106303:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106306:	5b                   	pop    %ebx
80106307:	5e                   	pop    %esi
80106308:	5f                   	pop    %edi
80106309:	5d                   	pop    %ebp
8010630a:	c3                   	ret    
8010630b:	90                   	nop
8010630c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106310 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106310:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106316:	55                   	push   %ebp
80106317:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106319:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010631b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010631e:	74 10                	je     80106330 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106320:	5d                   	pop    %ebp
80106321:	e9 da fe ff ff       	jmp    80106200 <uartputc.part.0>
80106326:	8d 76 00             	lea    0x0(%esi),%esi
80106329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106330:	5d                   	pop    %ebp
80106331:	c3                   	ret    
80106332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106340 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106340:	55                   	push   %ebp
80106341:	89 e5                	mov    %esp,%ebp
80106343:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106346:	68 d0 61 10 80       	push   $0x801061d0
8010634b:	e8 a0 a4 ff ff       	call   801007f0 <consoleintr>
}
80106350:	83 c4 10             	add    $0x10,%esp
80106353:	c9                   	leave  
80106354:	c3                   	ret    

80106355 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106355:	6a 00                	push   $0x0
  pushl $0
80106357:	6a 00                	push   $0x0
  jmp alltraps
80106359:	e9 33 fb ff ff       	jmp    80105e91 <alltraps>

8010635e <vector1>:
.globl vector1
vector1:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $1
80106360:	6a 01                	push   $0x1
  jmp alltraps
80106362:	e9 2a fb ff ff       	jmp    80105e91 <alltraps>

80106367 <vector2>:
.globl vector2
vector2:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $2
80106369:	6a 02                	push   $0x2
  jmp alltraps
8010636b:	e9 21 fb ff ff       	jmp    80105e91 <alltraps>

80106370 <vector3>:
.globl vector3
vector3:
  pushl $0
80106370:	6a 00                	push   $0x0
  pushl $3
80106372:	6a 03                	push   $0x3
  jmp alltraps
80106374:	e9 18 fb ff ff       	jmp    80105e91 <alltraps>

80106379 <vector4>:
.globl vector4
vector4:
  pushl $0
80106379:	6a 00                	push   $0x0
  pushl $4
8010637b:	6a 04                	push   $0x4
  jmp alltraps
8010637d:	e9 0f fb ff ff       	jmp    80105e91 <alltraps>

80106382 <vector5>:
.globl vector5
vector5:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $5
80106384:	6a 05                	push   $0x5
  jmp alltraps
80106386:	e9 06 fb ff ff       	jmp    80105e91 <alltraps>

8010638b <vector6>:
.globl vector6
vector6:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $6
8010638d:	6a 06                	push   $0x6
  jmp alltraps
8010638f:	e9 fd fa ff ff       	jmp    80105e91 <alltraps>

80106394 <vector7>:
.globl vector7
vector7:
  pushl $0
80106394:	6a 00                	push   $0x0
  pushl $7
80106396:	6a 07                	push   $0x7
  jmp alltraps
80106398:	e9 f4 fa ff ff       	jmp    80105e91 <alltraps>

8010639d <vector8>:
.globl vector8
vector8:
  pushl $8
8010639d:	6a 08                	push   $0x8
  jmp alltraps
8010639f:	e9 ed fa ff ff       	jmp    80105e91 <alltraps>

801063a4 <vector9>:
.globl vector9
vector9:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $9
801063a6:	6a 09                	push   $0x9
  jmp alltraps
801063a8:	e9 e4 fa ff ff       	jmp    80105e91 <alltraps>

801063ad <vector10>:
.globl vector10
vector10:
  pushl $10
801063ad:	6a 0a                	push   $0xa
  jmp alltraps
801063af:	e9 dd fa ff ff       	jmp    80105e91 <alltraps>

801063b4 <vector11>:
.globl vector11
vector11:
  pushl $11
801063b4:	6a 0b                	push   $0xb
  jmp alltraps
801063b6:	e9 d6 fa ff ff       	jmp    80105e91 <alltraps>

801063bb <vector12>:
.globl vector12
vector12:
  pushl $12
801063bb:	6a 0c                	push   $0xc
  jmp alltraps
801063bd:	e9 cf fa ff ff       	jmp    80105e91 <alltraps>

801063c2 <vector13>:
.globl vector13
vector13:
  pushl $13
801063c2:	6a 0d                	push   $0xd
  jmp alltraps
801063c4:	e9 c8 fa ff ff       	jmp    80105e91 <alltraps>

801063c9 <vector14>:
.globl vector14
vector14:
  pushl $14
801063c9:	6a 0e                	push   $0xe
  jmp alltraps
801063cb:	e9 c1 fa ff ff       	jmp    80105e91 <alltraps>

801063d0 <vector15>:
.globl vector15
vector15:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $15
801063d2:	6a 0f                	push   $0xf
  jmp alltraps
801063d4:	e9 b8 fa ff ff       	jmp    80105e91 <alltraps>

801063d9 <vector16>:
.globl vector16
vector16:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $16
801063db:	6a 10                	push   $0x10
  jmp alltraps
801063dd:	e9 af fa ff ff       	jmp    80105e91 <alltraps>

801063e2 <vector17>:
.globl vector17
vector17:
  pushl $17
801063e2:	6a 11                	push   $0x11
  jmp alltraps
801063e4:	e9 a8 fa ff ff       	jmp    80105e91 <alltraps>

801063e9 <vector18>:
.globl vector18
vector18:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $18
801063eb:	6a 12                	push   $0x12
  jmp alltraps
801063ed:	e9 9f fa ff ff       	jmp    80105e91 <alltraps>

801063f2 <vector19>:
.globl vector19
vector19:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $19
801063f4:	6a 13                	push   $0x13
  jmp alltraps
801063f6:	e9 96 fa ff ff       	jmp    80105e91 <alltraps>

801063fb <vector20>:
.globl vector20
vector20:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $20
801063fd:	6a 14                	push   $0x14
  jmp alltraps
801063ff:	e9 8d fa ff ff       	jmp    80105e91 <alltraps>

80106404 <vector21>:
.globl vector21
vector21:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $21
80106406:	6a 15                	push   $0x15
  jmp alltraps
80106408:	e9 84 fa ff ff       	jmp    80105e91 <alltraps>

8010640d <vector22>:
.globl vector22
vector22:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $22
8010640f:	6a 16                	push   $0x16
  jmp alltraps
80106411:	e9 7b fa ff ff       	jmp    80105e91 <alltraps>

80106416 <vector23>:
.globl vector23
vector23:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $23
80106418:	6a 17                	push   $0x17
  jmp alltraps
8010641a:	e9 72 fa ff ff       	jmp    80105e91 <alltraps>

8010641f <vector24>:
.globl vector24
vector24:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $24
80106421:	6a 18                	push   $0x18
  jmp alltraps
80106423:	e9 69 fa ff ff       	jmp    80105e91 <alltraps>

80106428 <vector25>:
.globl vector25
vector25:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $25
8010642a:	6a 19                	push   $0x19
  jmp alltraps
8010642c:	e9 60 fa ff ff       	jmp    80105e91 <alltraps>

80106431 <vector26>:
.globl vector26
vector26:
  pushl $0
80106431:	6a 00                	push   $0x0
  pushl $26
80106433:	6a 1a                	push   $0x1a
  jmp alltraps
80106435:	e9 57 fa ff ff       	jmp    80105e91 <alltraps>

8010643a <vector27>:
.globl vector27
vector27:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $27
8010643c:	6a 1b                	push   $0x1b
  jmp alltraps
8010643e:	e9 4e fa ff ff       	jmp    80105e91 <alltraps>

80106443 <vector28>:
.globl vector28
vector28:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $28
80106445:	6a 1c                	push   $0x1c
  jmp alltraps
80106447:	e9 45 fa ff ff       	jmp    80105e91 <alltraps>

8010644c <vector29>:
.globl vector29
vector29:
  pushl $0
8010644c:	6a 00                	push   $0x0
  pushl $29
8010644e:	6a 1d                	push   $0x1d
  jmp alltraps
80106450:	e9 3c fa ff ff       	jmp    80105e91 <alltraps>

80106455 <vector30>:
.globl vector30
vector30:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $30
80106457:	6a 1e                	push   $0x1e
  jmp alltraps
80106459:	e9 33 fa ff ff       	jmp    80105e91 <alltraps>

8010645e <vector31>:
.globl vector31
vector31:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $31
80106460:	6a 1f                	push   $0x1f
  jmp alltraps
80106462:	e9 2a fa ff ff       	jmp    80105e91 <alltraps>

80106467 <vector32>:
.globl vector32
vector32:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $32
80106469:	6a 20                	push   $0x20
  jmp alltraps
8010646b:	e9 21 fa ff ff       	jmp    80105e91 <alltraps>

80106470 <vector33>:
.globl vector33
vector33:
  pushl $0
80106470:	6a 00                	push   $0x0
  pushl $33
80106472:	6a 21                	push   $0x21
  jmp alltraps
80106474:	e9 18 fa ff ff       	jmp    80105e91 <alltraps>

80106479 <vector34>:
.globl vector34
vector34:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $34
8010647b:	6a 22                	push   $0x22
  jmp alltraps
8010647d:	e9 0f fa ff ff       	jmp    80105e91 <alltraps>

80106482 <vector35>:
.globl vector35
vector35:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $35
80106484:	6a 23                	push   $0x23
  jmp alltraps
80106486:	e9 06 fa ff ff       	jmp    80105e91 <alltraps>

8010648b <vector36>:
.globl vector36
vector36:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $36
8010648d:	6a 24                	push   $0x24
  jmp alltraps
8010648f:	e9 fd f9 ff ff       	jmp    80105e91 <alltraps>

80106494 <vector37>:
.globl vector37
vector37:
  pushl $0
80106494:	6a 00                	push   $0x0
  pushl $37
80106496:	6a 25                	push   $0x25
  jmp alltraps
80106498:	e9 f4 f9 ff ff       	jmp    80105e91 <alltraps>

8010649d <vector38>:
.globl vector38
vector38:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $38
8010649f:	6a 26                	push   $0x26
  jmp alltraps
801064a1:	e9 eb f9 ff ff       	jmp    80105e91 <alltraps>

801064a6 <vector39>:
.globl vector39
vector39:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $39
801064a8:	6a 27                	push   $0x27
  jmp alltraps
801064aa:	e9 e2 f9 ff ff       	jmp    80105e91 <alltraps>

801064af <vector40>:
.globl vector40
vector40:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $40
801064b1:	6a 28                	push   $0x28
  jmp alltraps
801064b3:	e9 d9 f9 ff ff       	jmp    80105e91 <alltraps>

801064b8 <vector41>:
.globl vector41
vector41:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $41
801064ba:	6a 29                	push   $0x29
  jmp alltraps
801064bc:	e9 d0 f9 ff ff       	jmp    80105e91 <alltraps>

801064c1 <vector42>:
.globl vector42
vector42:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $42
801064c3:	6a 2a                	push   $0x2a
  jmp alltraps
801064c5:	e9 c7 f9 ff ff       	jmp    80105e91 <alltraps>

801064ca <vector43>:
.globl vector43
vector43:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $43
801064cc:	6a 2b                	push   $0x2b
  jmp alltraps
801064ce:	e9 be f9 ff ff       	jmp    80105e91 <alltraps>

801064d3 <vector44>:
.globl vector44
vector44:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $44
801064d5:	6a 2c                	push   $0x2c
  jmp alltraps
801064d7:	e9 b5 f9 ff ff       	jmp    80105e91 <alltraps>

801064dc <vector45>:
.globl vector45
vector45:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $45
801064de:	6a 2d                	push   $0x2d
  jmp alltraps
801064e0:	e9 ac f9 ff ff       	jmp    80105e91 <alltraps>

801064e5 <vector46>:
.globl vector46
vector46:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $46
801064e7:	6a 2e                	push   $0x2e
  jmp alltraps
801064e9:	e9 a3 f9 ff ff       	jmp    80105e91 <alltraps>

801064ee <vector47>:
.globl vector47
vector47:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $47
801064f0:	6a 2f                	push   $0x2f
  jmp alltraps
801064f2:	e9 9a f9 ff ff       	jmp    80105e91 <alltraps>

801064f7 <vector48>:
.globl vector48
vector48:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $48
801064f9:	6a 30                	push   $0x30
  jmp alltraps
801064fb:	e9 91 f9 ff ff       	jmp    80105e91 <alltraps>

80106500 <vector49>:
.globl vector49
vector49:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $49
80106502:	6a 31                	push   $0x31
  jmp alltraps
80106504:	e9 88 f9 ff ff       	jmp    80105e91 <alltraps>

80106509 <vector50>:
.globl vector50
vector50:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $50
8010650b:	6a 32                	push   $0x32
  jmp alltraps
8010650d:	e9 7f f9 ff ff       	jmp    80105e91 <alltraps>

80106512 <vector51>:
.globl vector51
vector51:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $51
80106514:	6a 33                	push   $0x33
  jmp alltraps
80106516:	e9 76 f9 ff ff       	jmp    80105e91 <alltraps>

8010651b <vector52>:
.globl vector52
vector52:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $52
8010651d:	6a 34                	push   $0x34
  jmp alltraps
8010651f:	e9 6d f9 ff ff       	jmp    80105e91 <alltraps>

80106524 <vector53>:
.globl vector53
vector53:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $53
80106526:	6a 35                	push   $0x35
  jmp alltraps
80106528:	e9 64 f9 ff ff       	jmp    80105e91 <alltraps>

8010652d <vector54>:
.globl vector54
vector54:
  pushl $0
8010652d:	6a 00                	push   $0x0
  pushl $54
8010652f:	6a 36                	push   $0x36
  jmp alltraps
80106531:	e9 5b f9 ff ff       	jmp    80105e91 <alltraps>

80106536 <vector55>:
.globl vector55
vector55:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $55
80106538:	6a 37                	push   $0x37
  jmp alltraps
8010653a:	e9 52 f9 ff ff       	jmp    80105e91 <alltraps>

8010653f <vector56>:
.globl vector56
vector56:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $56
80106541:	6a 38                	push   $0x38
  jmp alltraps
80106543:	e9 49 f9 ff ff       	jmp    80105e91 <alltraps>

80106548 <vector57>:
.globl vector57
vector57:
  pushl $0
80106548:	6a 00                	push   $0x0
  pushl $57
8010654a:	6a 39                	push   $0x39
  jmp alltraps
8010654c:	e9 40 f9 ff ff       	jmp    80105e91 <alltraps>

80106551 <vector58>:
.globl vector58
vector58:
  pushl $0
80106551:	6a 00                	push   $0x0
  pushl $58
80106553:	6a 3a                	push   $0x3a
  jmp alltraps
80106555:	e9 37 f9 ff ff       	jmp    80105e91 <alltraps>

8010655a <vector59>:
.globl vector59
vector59:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $59
8010655c:	6a 3b                	push   $0x3b
  jmp alltraps
8010655e:	e9 2e f9 ff ff       	jmp    80105e91 <alltraps>

80106563 <vector60>:
.globl vector60
vector60:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $60
80106565:	6a 3c                	push   $0x3c
  jmp alltraps
80106567:	e9 25 f9 ff ff       	jmp    80105e91 <alltraps>

8010656c <vector61>:
.globl vector61
vector61:
  pushl $0
8010656c:	6a 00                	push   $0x0
  pushl $61
8010656e:	6a 3d                	push   $0x3d
  jmp alltraps
80106570:	e9 1c f9 ff ff       	jmp    80105e91 <alltraps>

80106575 <vector62>:
.globl vector62
vector62:
  pushl $0
80106575:	6a 00                	push   $0x0
  pushl $62
80106577:	6a 3e                	push   $0x3e
  jmp alltraps
80106579:	e9 13 f9 ff ff       	jmp    80105e91 <alltraps>

8010657e <vector63>:
.globl vector63
vector63:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $63
80106580:	6a 3f                	push   $0x3f
  jmp alltraps
80106582:	e9 0a f9 ff ff       	jmp    80105e91 <alltraps>

80106587 <vector64>:
.globl vector64
vector64:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $64
80106589:	6a 40                	push   $0x40
  jmp alltraps
8010658b:	e9 01 f9 ff ff       	jmp    80105e91 <alltraps>

80106590 <vector65>:
.globl vector65
vector65:
  pushl $0
80106590:	6a 00                	push   $0x0
  pushl $65
80106592:	6a 41                	push   $0x41
  jmp alltraps
80106594:	e9 f8 f8 ff ff       	jmp    80105e91 <alltraps>

80106599 <vector66>:
.globl vector66
vector66:
  pushl $0
80106599:	6a 00                	push   $0x0
  pushl $66
8010659b:	6a 42                	push   $0x42
  jmp alltraps
8010659d:	e9 ef f8 ff ff       	jmp    80105e91 <alltraps>

801065a2 <vector67>:
.globl vector67
vector67:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $67
801065a4:	6a 43                	push   $0x43
  jmp alltraps
801065a6:	e9 e6 f8 ff ff       	jmp    80105e91 <alltraps>

801065ab <vector68>:
.globl vector68
vector68:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $68
801065ad:	6a 44                	push   $0x44
  jmp alltraps
801065af:	e9 dd f8 ff ff       	jmp    80105e91 <alltraps>

801065b4 <vector69>:
.globl vector69
vector69:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $69
801065b6:	6a 45                	push   $0x45
  jmp alltraps
801065b8:	e9 d4 f8 ff ff       	jmp    80105e91 <alltraps>

801065bd <vector70>:
.globl vector70
vector70:
  pushl $0
801065bd:	6a 00                	push   $0x0
  pushl $70
801065bf:	6a 46                	push   $0x46
  jmp alltraps
801065c1:	e9 cb f8 ff ff       	jmp    80105e91 <alltraps>

801065c6 <vector71>:
.globl vector71
vector71:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $71
801065c8:	6a 47                	push   $0x47
  jmp alltraps
801065ca:	e9 c2 f8 ff ff       	jmp    80105e91 <alltraps>

801065cf <vector72>:
.globl vector72
vector72:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $72
801065d1:	6a 48                	push   $0x48
  jmp alltraps
801065d3:	e9 b9 f8 ff ff       	jmp    80105e91 <alltraps>

801065d8 <vector73>:
.globl vector73
vector73:
  pushl $0
801065d8:	6a 00                	push   $0x0
  pushl $73
801065da:	6a 49                	push   $0x49
  jmp alltraps
801065dc:	e9 b0 f8 ff ff       	jmp    80105e91 <alltraps>

801065e1 <vector74>:
.globl vector74
vector74:
  pushl $0
801065e1:	6a 00                	push   $0x0
  pushl $74
801065e3:	6a 4a                	push   $0x4a
  jmp alltraps
801065e5:	e9 a7 f8 ff ff       	jmp    80105e91 <alltraps>

801065ea <vector75>:
.globl vector75
vector75:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $75
801065ec:	6a 4b                	push   $0x4b
  jmp alltraps
801065ee:	e9 9e f8 ff ff       	jmp    80105e91 <alltraps>

801065f3 <vector76>:
.globl vector76
vector76:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $76
801065f5:	6a 4c                	push   $0x4c
  jmp alltraps
801065f7:	e9 95 f8 ff ff       	jmp    80105e91 <alltraps>

801065fc <vector77>:
.globl vector77
vector77:
  pushl $0
801065fc:	6a 00                	push   $0x0
  pushl $77
801065fe:	6a 4d                	push   $0x4d
  jmp alltraps
80106600:	e9 8c f8 ff ff       	jmp    80105e91 <alltraps>

80106605 <vector78>:
.globl vector78
vector78:
  pushl $0
80106605:	6a 00                	push   $0x0
  pushl $78
80106607:	6a 4e                	push   $0x4e
  jmp alltraps
80106609:	e9 83 f8 ff ff       	jmp    80105e91 <alltraps>

8010660e <vector79>:
.globl vector79
vector79:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $79
80106610:	6a 4f                	push   $0x4f
  jmp alltraps
80106612:	e9 7a f8 ff ff       	jmp    80105e91 <alltraps>

80106617 <vector80>:
.globl vector80
vector80:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $80
80106619:	6a 50                	push   $0x50
  jmp alltraps
8010661b:	e9 71 f8 ff ff       	jmp    80105e91 <alltraps>

80106620 <vector81>:
.globl vector81
vector81:
  pushl $0
80106620:	6a 00                	push   $0x0
  pushl $81
80106622:	6a 51                	push   $0x51
  jmp alltraps
80106624:	e9 68 f8 ff ff       	jmp    80105e91 <alltraps>

80106629 <vector82>:
.globl vector82
vector82:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $82
8010662b:	6a 52                	push   $0x52
  jmp alltraps
8010662d:	e9 5f f8 ff ff       	jmp    80105e91 <alltraps>

80106632 <vector83>:
.globl vector83
vector83:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $83
80106634:	6a 53                	push   $0x53
  jmp alltraps
80106636:	e9 56 f8 ff ff       	jmp    80105e91 <alltraps>

8010663b <vector84>:
.globl vector84
vector84:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $84
8010663d:	6a 54                	push   $0x54
  jmp alltraps
8010663f:	e9 4d f8 ff ff       	jmp    80105e91 <alltraps>

80106644 <vector85>:
.globl vector85
vector85:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $85
80106646:	6a 55                	push   $0x55
  jmp alltraps
80106648:	e9 44 f8 ff ff       	jmp    80105e91 <alltraps>

8010664d <vector86>:
.globl vector86
vector86:
  pushl $0
8010664d:	6a 00                	push   $0x0
  pushl $86
8010664f:	6a 56                	push   $0x56
  jmp alltraps
80106651:	e9 3b f8 ff ff       	jmp    80105e91 <alltraps>

80106656 <vector87>:
.globl vector87
vector87:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $87
80106658:	6a 57                	push   $0x57
  jmp alltraps
8010665a:	e9 32 f8 ff ff       	jmp    80105e91 <alltraps>

8010665f <vector88>:
.globl vector88
vector88:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $88
80106661:	6a 58                	push   $0x58
  jmp alltraps
80106663:	e9 29 f8 ff ff       	jmp    80105e91 <alltraps>

80106668 <vector89>:
.globl vector89
vector89:
  pushl $0
80106668:	6a 00                	push   $0x0
  pushl $89
8010666a:	6a 59                	push   $0x59
  jmp alltraps
8010666c:	e9 20 f8 ff ff       	jmp    80105e91 <alltraps>

80106671 <vector90>:
.globl vector90
vector90:
  pushl $0
80106671:	6a 00                	push   $0x0
  pushl $90
80106673:	6a 5a                	push   $0x5a
  jmp alltraps
80106675:	e9 17 f8 ff ff       	jmp    80105e91 <alltraps>

8010667a <vector91>:
.globl vector91
vector91:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $91
8010667c:	6a 5b                	push   $0x5b
  jmp alltraps
8010667e:	e9 0e f8 ff ff       	jmp    80105e91 <alltraps>

80106683 <vector92>:
.globl vector92
vector92:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $92
80106685:	6a 5c                	push   $0x5c
  jmp alltraps
80106687:	e9 05 f8 ff ff       	jmp    80105e91 <alltraps>

8010668c <vector93>:
.globl vector93
vector93:
  pushl $0
8010668c:	6a 00                	push   $0x0
  pushl $93
8010668e:	6a 5d                	push   $0x5d
  jmp alltraps
80106690:	e9 fc f7 ff ff       	jmp    80105e91 <alltraps>

80106695 <vector94>:
.globl vector94
vector94:
  pushl $0
80106695:	6a 00                	push   $0x0
  pushl $94
80106697:	6a 5e                	push   $0x5e
  jmp alltraps
80106699:	e9 f3 f7 ff ff       	jmp    80105e91 <alltraps>

8010669e <vector95>:
.globl vector95
vector95:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $95
801066a0:	6a 5f                	push   $0x5f
  jmp alltraps
801066a2:	e9 ea f7 ff ff       	jmp    80105e91 <alltraps>

801066a7 <vector96>:
.globl vector96
vector96:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $96
801066a9:	6a 60                	push   $0x60
  jmp alltraps
801066ab:	e9 e1 f7 ff ff       	jmp    80105e91 <alltraps>

801066b0 <vector97>:
.globl vector97
vector97:
  pushl $0
801066b0:	6a 00                	push   $0x0
  pushl $97
801066b2:	6a 61                	push   $0x61
  jmp alltraps
801066b4:	e9 d8 f7 ff ff       	jmp    80105e91 <alltraps>

801066b9 <vector98>:
.globl vector98
vector98:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $98
801066bb:	6a 62                	push   $0x62
  jmp alltraps
801066bd:	e9 cf f7 ff ff       	jmp    80105e91 <alltraps>

801066c2 <vector99>:
.globl vector99
vector99:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $99
801066c4:	6a 63                	push   $0x63
  jmp alltraps
801066c6:	e9 c6 f7 ff ff       	jmp    80105e91 <alltraps>

801066cb <vector100>:
.globl vector100
vector100:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $100
801066cd:	6a 64                	push   $0x64
  jmp alltraps
801066cf:	e9 bd f7 ff ff       	jmp    80105e91 <alltraps>

801066d4 <vector101>:
.globl vector101
vector101:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $101
801066d6:	6a 65                	push   $0x65
  jmp alltraps
801066d8:	e9 b4 f7 ff ff       	jmp    80105e91 <alltraps>

801066dd <vector102>:
.globl vector102
vector102:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $102
801066df:	6a 66                	push   $0x66
  jmp alltraps
801066e1:	e9 ab f7 ff ff       	jmp    80105e91 <alltraps>

801066e6 <vector103>:
.globl vector103
vector103:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $103
801066e8:	6a 67                	push   $0x67
  jmp alltraps
801066ea:	e9 a2 f7 ff ff       	jmp    80105e91 <alltraps>

801066ef <vector104>:
.globl vector104
vector104:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $104
801066f1:	6a 68                	push   $0x68
  jmp alltraps
801066f3:	e9 99 f7 ff ff       	jmp    80105e91 <alltraps>

801066f8 <vector105>:
.globl vector105
vector105:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $105
801066fa:	6a 69                	push   $0x69
  jmp alltraps
801066fc:	e9 90 f7 ff ff       	jmp    80105e91 <alltraps>

80106701 <vector106>:
.globl vector106
vector106:
  pushl $0
80106701:	6a 00                	push   $0x0
  pushl $106
80106703:	6a 6a                	push   $0x6a
  jmp alltraps
80106705:	e9 87 f7 ff ff       	jmp    80105e91 <alltraps>

8010670a <vector107>:
.globl vector107
vector107:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $107
8010670c:	6a 6b                	push   $0x6b
  jmp alltraps
8010670e:	e9 7e f7 ff ff       	jmp    80105e91 <alltraps>

80106713 <vector108>:
.globl vector108
vector108:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $108
80106715:	6a 6c                	push   $0x6c
  jmp alltraps
80106717:	e9 75 f7 ff ff       	jmp    80105e91 <alltraps>

8010671c <vector109>:
.globl vector109
vector109:
  pushl $0
8010671c:	6a 00                	push   $0x0
  pushl $109
8010671e:	6a 6d                	push   $0x6d
  jmp alltraps
80106720:	e9 6c f7 ff ff       	jmp    80105e91 <alltraps>

80106725 <vector110>:
.globl vector110
vector110:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $110
80106727:	6a 6e                	push   $0x6e
  jmp alltraps
80106729:	e9 63 f7 ff ff       	jmp    80105e91 <alltraps>

8010672e <vector111>:
.globl vector111
vector111:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $111
80106730:	6a 6f                	push   $0x6f
  jmp alltraps
80106732:	e9 5a f7 ff ff       	jmp    80105e91 <alltraps>

80106737 <vector112>:
.globl vector112
vector112:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $112
80106739:	6a 70                	push   $0x70
  jmp alltraps
8010673b:	e9 51 f7 ff ff       	jmp    80105e91 <alltraps>

80106740 <vector113>:
.globl vector113
vector113:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $113
80106742:	6a 71                	push   $0x71
  jmp alltraps
80106744:	e9 48 f7 ff ff       	jmp    80105e91 <alltraps>

80106749 <vector114>:
.globl vector114
vector114:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $114
8010674b:	6a 72                	push   $0x72
  jmp alltraps
8010674d:	e9 3f f7 ff ff       	jmp    80105e91 <alltraps>

80106752 <vector115>:
.globl vector115
vector115:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $115
80106754:	6a 73                	push   $0x73
  jmp alltraps
80106756:	e9 36 f7 ff ff       	jmp    80105e91 <alltraps>

8010675b <vector116>:
.globl vector116
vector116:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $116
8010675d:	6a 74                	push   $0x74
  jmp alltraps
8010675f:	e9 2d f7 ff ff       	jmp    80105e91 <alltraps>

80106764 <vector117>:
.globl vector117
vector117:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $117
80106766:	6a 75                	push   $0x75
  jmp alltraps
80106768:	e9 24 f7 ff ff       	jmp    80105e91 <alltraps>

8010676d <vector118>:
.globl vector118
vector118:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $118
8010676f:	6a 76                	push   $0x76
  jmp alltraps
80106771:	e9 1b f7 ff ff       	jmp    80105e91 <alltraps>

80106776 <vector119>:
.globl vector119
vector119:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $119
80106778:	6a 77                	push   $0x77
  jmp alltraps
8010677a:	e9 12 f7 ff ff       	jmp    80105e91 <alltraps>

8010677f <vector120>:
.globl vector120
vector120:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $120
80106781:	6a 78                	push   $0x78
  jmp alltraps
80106783:	e9 09 f7 ff ff       	jmp    80105e91 <alltraps>

80106788 <vector121>:
.globl vector121
vector121:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $121
8010678a:	6a 79                	push   $0x79
  jmp alltraps
8010678c:	e9 00 f7 ff ff       	jmp    80105e91 <alltraps>

80106791 <vector122>:
.globl vector122
vector122:
  pushl $0
80106791:	6a 00                	push   $0x0
  pushl $122
80106793:	6a 7a                	push   $0x7a
  jmp alltraps
80106795:	e9 f7 f6 ff ff       	jmp    80105e91 <alltraps>

8010679a <vector123>:
.globl vector123
vector123:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $123
8010679c:	6a 7b                	push   $0x7b
  jmp alltraps
8010679e:	e9 ee f6 ff ff       	jmp    80105e91 <alltraps>

801067a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $124
801067a5:	6a 7c                	push   $0x7c
  jmp alltraps
801067a7:	e9 e5 f6 ff ff       	jmp    80105e91 <alltraps>

801067ac <vector125>:
.globl vector125
vector125:
  pushl $0
801067ac:	6a 00                	push   $0x0
  pushl $125
801067ae:	6a 7d                	push   $0x7d
  jmp alltraps
801067b0:	e9 dc f6 ff ff       	jmp    80105e91 <alltraps>

801067b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801067b5:	6a 00                	push   $0x0
  pushl $126
801067b7:	6a 7e                	push   $0x7e
  jmp alltraps
801067b9:	e9 d3 f6 ff ff       	jmp    80105e91 <alltraps>

801067be <vector127>:
.globl vector127
vector127:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $127
801067c0:	6a 7f                	push   $0x7f
  jmp alltraps
801067c2:	e9 ca f6 ff ff       	jmp    80105e91 <alltraps>

801067c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $128
801067c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801067ce:	e9 be f6 ff ff       	jmp    80105e91 <alltraps>

801067d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $129
801067d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801067da:	e9 b2 f6 ff ff       	jmp    80105e91 <alltraps>

801067df <vector130>:
.globl vector130
vector130:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $130
801067e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801067e6:	e9 a6 f6 ff ff       	jmp    80105e91 <alltraps>

801067eb <vector131>:
.globl vector131
vector131:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $131
801067ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801067f2:	e9 9a f6 ff ff       	jmp    80105e91 <alltraps>

801067f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $132
801067f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801067fe:	e9 8e f6 ff ff       	jmp    80105e91 <alltraps>

80106803 <vector133>:
.globl vector133
vector133:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $133
80106805:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010680a:	e9 82 f6 ff ff       	jmp    80105e91 <alltraps>

8010680f <vector134>:
.globl vector134
vector134:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $134
80106811:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106816:	e9 76 f6 ff ff       	jmp    80105e91 <alltraps>

8010681b <vector135>:
.globl vector135
vector135:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $135
8010681d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106822:	e9 6a f6 ff ff       	jmp    80105e91 <alltraps>

80106827 <vector136>:
.globl vector136
vector136:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $136
80106829:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010682e:	e9 5e f6 ff ff       	jmp    80105e91 <alltraps>

80106833 <vector137>:
.globl vector137
vector137:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $137
80106835:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010683a:	e9 52 f6 ff ff       	jmp    80105e91 <alltraps>

8010683f <vector138>:
.globl vector138
vector138:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $138
80106841:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106846:	e9 46 f6 ff ff       	jmp    80105e91 <alltraps>

8010684b <vector139>:
.globl vector139
vector139:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $139
8010684d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106852:	e9 3a f6 ff ff       	jmp    80105e91 <alltraps>

80106857 <vector140>:
.globl vector140
vector140:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $140
80106859:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010685e:	e9 2e f6 ff ff       	jmp    80105e91 <alltraps>

80106863 <vector141>:
.globl vector141
vector141:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $141
80106865:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010686a:	e9 22 f6 ff ff       	jmp    80105e91 <alltraps>

8010686f <vector142>:
.globl vector142
vector142:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $142
80106871:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106876:	e9 16 f6 ff ff       	jmp    80105e91 <alltraps>

8010687b <vector143>:
.globl vector143
vector143:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $143
8010687d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106882:	e9 0a f6 ff ff       	jmp    80105e91 <alltraps>

80106887 <vector144>:
.globl vector144
vector144:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $144
80106889:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010688e:	e9 fe f5 ff ff       	jmp    80105e91 <alltraps>

80106893 <vector145>:
.globl vector145
vector145:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $145
80106895:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010689a:	e9 f2 f5 ff ff       	jmp    80105e91 <alltraps>

8010689f <vector146>:
.globl vector146
vector146:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $146
801068a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801068a6:	e9 e6 f5 ff ff       	jmp    80105e91 <alltraps>

801068ab <vector147>:
.globl vector147
vector147:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $147
801068ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801068b2:	e9 da f5 ff ff       	jmp    80105e91 <alltraps>

801068b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $148
801068b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801068be:	e9 ce f5 ff ff       	jmp    80105e91 <alltraps>

801068c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $149
801068c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801068ca:	e9 c2 f5 ff ff       	jmp    80105e91 <alltraps>

801068cf <vector150>:
.globl vector150
vector150:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $150
801068d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801068d6:	e9 b6 f5 ff ff       	jmp    80105e91 <alltraps>

801068db <vector151>:
.globl vector151
vector151:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $151
801068dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801068e2:	e9 aa f5 ff ff       	jmp    80105e91 <alltraps>

801068e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $152
801068e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801068ee:	e9 9e f5 ff ff       	jmp    80105e91 <alltraps>

801068f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $153
801068f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801068fa:	e9 92 f5 ff ff       	jmp    80105e91 <alltraps>

801068ff <vector154>:
.globl vector154
vector154:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $154
80106901:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106906:	e9 86 f5 ff ff       	jmp    80105e91 <alltraps>

8010690b <vector155>:
.globl vector155
vector155:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $155
8010690d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106912:	e9 7a f5 ff ff       	jmp    80105e91 <alltraps>

80106917 <vector156>:
.globl vector156
vector156:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $156
80106919:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010691e:	e9 6e f5 ff ff       	jmp    80105e91 <alltraps>

80106923 <vector157>:
.globl vector157
vector157:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $157
80106925:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010692a:	e9 62 f5 ff ff       	jmp    80105e91 <alltraps>

8010692f <vector158>:
.globl vector158
vector158:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $158
80106931:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106936:	e9 56 f5 ff ff       	jmp    80105e91 <alltraps>

8010693b <vector159>:
.globl vector159
vector159:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $159
8010693d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106942:	e9 4a f5 ff ff       	jmp    80105e91 <alltraps>

80106947 <vector160>:
.globl vector160
vector160:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $160
80106949:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010694e:	e9 3e f5 ff ff       	jmp    80105e91 <alltraps>

80106953 <vector161>:
.globl vector161
vector161:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $161
80106955:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010695a:	e9 32 f5 ff ff       	jmp    80105e91 <alltraps>

8010695f <vector162>:
.globl vector162
vector162:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $162
80106961:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106966:	e9 26 f5 ff ff       	jmp    80105e91 <alltraps>

8010696b <vector163>:
.globl vector163
vector163:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $163
8010696d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106972:	e9 1a f5 ff ff       	jmp    80105e91 <alltraps>

80106977 <vector164>:
.globl vector164
vector164:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $164
80106979:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010697e:	e9 0e f5 ff ff       	jmp    80105e91 <alltraps>

80106983 <vector165>:
.globl vector165
vector165:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $165
80106985:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010698a:	e9 02 f5 ff ff       	jmp    80105e91 <alltraps>

8010698f <vector166>:
.globl vector166
vector166:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $166
80106991:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106996:	e9 f6 f4 ff ff       	jmp    80105e91 <alltraps>

8010699b <vector167>:
.globl vector167
vector167:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $167
8010699d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801069a2:	e9 ea f4 ff ff       	jmp    80105e91 <alltraps>

801069a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $168
801069a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801069ae:	e9 de f4 ff ff       	jmp    80105e91 <alltraps>

801069b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $169
801069b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801069ba:	e9 d2 f4 ff ff       	jmp    80105e91 <alltraps>

801069bf <vector170>:
.globl vector170
vector170:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $170
801069c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801069c6:	e9 c6 f4 ff ff       	jmp    80105e91 <alltraps>

801069cb <vector171>:
.globl vector171
vector171:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $171
801069cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801069d2:	e9 ba f4 ff ff       	jmp    80105e91 <alltraps>

801069d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $172
801069d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801069de:	e9 ae f4 ff ff       	jmp    80105e91 <alltraps>

801069e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $173
801069e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801069ea:	e9 a2 f4 ff ff       	jmp    80105e91 <alltraps>

801069ef <vector174>:
.globl vector174
vector174:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $174
801069f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801069f6:	e9 96 f4 ff ff       	jmp    80105e91 <alltraps>

801069fb <vector175>:
.globl vector175
vector175:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $175
801069fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106a02:	e9 8a f4 ff ff       	jmp    80105e91 <alltraps>

80106a07 <vector176>:
.globl vector176
vector176:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $176
80106a09:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106a0e:	e9 7e f4 ff ff       	jmp    80105e91 <alltraps>

80106a13 <vector177>:
.globl vector177
vector177:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $177
80106a15:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106a1a:	e9 72 f4 ff ff       	jmp    80105e91 <alltraps>

80106a1f <vector178>:
.globl vector178
vector178:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $178
80106a21:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106a26:	e9 66 f4 ff ff       	jmp    80105e91 <alltraps>

80106a2b <vector179>:
.globl vector179
vector179:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $179
80106a2d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106a32:	e9 5a f4 ff ff       	jmp    80105e91 <alltraps>

80106a37 <vector180>:
.globl vector180
vector180:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $180
80106a39:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106a3e:	e9 4e f4 ff ff       	jmp    80105e91 <alltraps>

80106a43 <vector181>:
.globl vector181
vector181:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $181
80106a45:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106a4a:	e9 42 f4 ff ff       	jmp    80105e91 <alltraps>

80106a4f <vector182>:
.globl vector182
vector182:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $182
80106a51:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106a56:	e9 36 f4 ff ff       	jmp    80105e91 <alltraps>

80106a5b <vector183>:
.globl vector183
vector183:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $183
80106a5d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106a62:	e9 2a f4 ff ff       	jmp    80105e91 <alltraps>

80106a67 <vector184>:
.globl vector184
vector184:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $184
80106a69:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106a6e:	e9 1e f4 ff ff       	jmp    80105e91 <alltraps>

80106a73 <vector185>:
.globl vector185
vector185:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $185
80106a75:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106a7a:	e9 12 f4 ff ff       	jmp    80105e91 <alltraps>

80106a7f <vector186>:
.globl vector186
vector186:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $186
80106a81:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106a86:	e9 06 f4 ff ff       	jmp    80105e91 <alltraps>

80106a8b <vector187>:
.globl vector187
vector187:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $187
80106a8d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106a92:	e9 fa f3 ff ff       	jmp    80105e91 <alltraps>

80106a97 <vector188>:
.globl vector188
vector188:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $188
80106a99:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106a9e:	e9 ee f3 ff ff       	jmp    80105e91 <alltraps>

80106aa3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $189
80106aa5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106aaa:	e9 e2 f3 ff ff       	jmp    80105e91 <alltraps>

80106aaf <vector190>:
.globl vector190
vector190:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $190
80106ab1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106ab6:	e9 d6 f3 ff ff       	jmp    80105e91 <alltraps>

80106abb <vector191>:
.globl vector191
vector191:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $191
80106abd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106ac2:	e9 ca f3 ff ff       	jmp    80105e91 <alltraps>

80106ac7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $192
80106ac9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106ace:	e9 be f3 ff ff       	jmp    80105e91 <alltraps>

80106ad3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $193
80106ad5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106ada:	e9 b2 f3 ff ff       	jmp    80105e91 <alltraps>

80106adf <vector194>:
.globl vector194
vector194:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $194
80106ae1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106ae6:	e9 a6 f3 ff ff       	jmp    80105e91 <alltraps>

80106aeb <vector195>:
.globl vector195
vector195:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $195
80106aed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106af2:	e9 9a f3 ff ff       	jmp    80105e91 <alltraps>

80106af7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $196
80106af9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106afe:	e9 8e f3 ff ff       	jmp    80105e91 <alltraps>

80106b03 <vector197>:
.globl vector197
vector197:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $197
80106b05:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106b0a:	e9 82 f3 ff ff       	jmp    80105e91 <alltraps>

80106b0f <vector198>:
.globl vector198
vector198:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $198
80106b11:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106b16:	e9 76 f3 ff ff       	jmp    80105e91 <alltraps>

80106b1b <vector199>:
.globl vector199
vector199:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $199
80106b1d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106b22:	e9 6a f3 ff ff       	jmp    80105e91 <alltraps>

80106b27 <vector200>:
.globl vector200
vector200:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $200
80106b29:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106b2e:	e9 5e f3 ff ff       	jmp    80105e91 <alltraps>

80106b33 <vector201>:
.globl vector201
vector201:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $201
80106b35:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106b3a:	e9 52 f3 ff ff       	jmp    80105e91 <alltraps>

80106b3f <vector202>:
.globl vector202
vector202:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $202
80106b41:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106b46:	e9 46 f3 ff ff       	jmp    80105e91 <alltraps>

80106b4b <vector203>:
.globl vector203
vector203:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $203
80106b4d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106b52:	e9 3a f3 ff ff       	jmp    80105e91 <alltraps>

80106b57 <vector204>:
.globl vector204
vector204:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $204
80106b59:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106b5e:	e9 2e f3 ff ff       	jmp    80105e91 <alltraps>

80106b63 <vector205>:
.globl vector205
vector205:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $205
80106b65:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106b6a:	e9 22 f3 ff ff       	jmp    80105e91 <alltraps>

80106b6f <vector206>:
.globl vector206
vector206:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $206
80106b71:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106b76:	e9 16 f3 ff ff       	jmp    80105e91 <alltraps>

80106b7b <vector207>:
.globl vector207
vector207:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $207
80106b7d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106b82:	e9 0a f3 ff ff       	jmp    80105e91 <alltraps>

80106b87 <vector208>:
.globl vector208
vector208:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $208
80106b89:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106b8e:	e9 fe f2 ff ff       	jmp    80105e91 <alltraps>

80106b93 <vector209>:
.globl vector209
vector209:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $209
80106b95:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106b9a:	e9 f2 f2 ff ff       	jmp    80105e91 <alltraps>

80106b9f <vector210>:
.globl vector210
vector210:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $210
80106ba1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ba6:	e9 e6 f2 ff ff       	jmp    80105e91 <alltraps>

80106bab <vector211>:
.globl vector211
vector211:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $211
80106bad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106bb2:	e9 da f2 ff ff       	jmp    80105e91 <alltraps>

80106bb7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $212
80106bb9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106bbe:	e9 ce f2 ff ff       	jmp    80105e91 <alltraps>

80106bc3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $213
80106bc5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106bca:	e9 c2 f2 ff ff       	jmp    80105e91 <alltraps>

80106bcf <vector214>:
.globl vector214
vector214:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $214
80106bd1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106bd6:	e9 b6 f2 ff ff       	jmp    80105e91 <alltraps>

80106bdb <vector215>:
.globl vector215
vector215:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $215
80106bdd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106be2:	e9 aa f2 ff ff       	jmp    80105e91 <alltraps>

80106be7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $216
80106be9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106bee:	e9 9e f2 ff ff       	jmp    80105e91 <alltraps>

80106bf3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $217
80106bf5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106bfa:	e9 92 f2 ff ff       	jmp    80105e91 <alltraps>

80106bff <vector218>:
.globl vector218
vector218:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $218
80106c01:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106c06:	e9 86 f2 ff ff       	jmp    80105e91 <alltraps>

80106c0b <vector219>:
.globl vector219
vector219:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $219
80106c0d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106c12:	e9 7a f2 ff ff       	jmp    80105e91 <alltraps>

80106c17 <vector220>:
.globl vector220
vector220:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $220
80106c19:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106c1e:	e9 6e f2 ff ff       	jmp    80105e91 <alltraps>

80106c23 <vector221>:
.globl vector221
vector221:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $221
80106c25:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106c2a:	e9 62 f2 ff ff       	jmp    80105e91 <alltraps>

80106c2f <vector222>:
.globl vector222
vector222:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $222
80106c31:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106c36:	e9 56 f2 ff ff       	jmp    80105e91 <alltraps>

80106c3b <vector223>:
.globl vector223
vector223:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $223
80106c3d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106c42:	e9 4a f2 ff ff       	jmp    80105e91 <alltraps>

80106c47 <vector224>:
.globl vector224
vector224:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $224
80106c49:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106c4e:	e9 3e f2 ff ff       	jmp    80105e91 <alltraps>

80106c53 <vector225>:
.globl vector225
vector225:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $225
80106c55:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106c5a:	e9 32 f2 ff ff       	jmp    80105e91 <alltraps>

80106c5f <vector226>:
.globl vector226
vector226:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $226
80106c61:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106c66:	e9 26 f2 ff ff       	jmp    80105e91 <alltraps>

80106c6b <vector227>:
.globl vector227
vector227:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $227
80106c6d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106c72:	e9 1a f2 ff ff       	jmp    80105e91 <alltraps>

80106c77 <vector228>:
.globl vector228
vector228:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $228
80106c79:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106c7e:	e9 0e f2 ff ff       	jmp    80105e91 <alltraps>

80106c83 <vector229>:
.globl vector229
vector229:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $229
80106c85:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106c8a:	e9 02 f2 ff ff       	jmp    80105e91 <alltraps>

80106c8f <vector230>:
.globl vector230
vector230:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $230
80106c91:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106c96:	e9 f6 f1 ff ff       	jmp    80105e91 <alltraps>

80106c9b <vector231>:
.globl vector231
vector231:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $231
80106c9d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ca2:	e9 ea f1 ff ff       	jmp    80105e91 <alltraps>

80106ca7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $232
80106ca9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106cae:	e9 de f1 ff ff       	jmp    80105e91 <alltraps>

80106cb3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $233
80106cb5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106cba:	e9 d2 f1 ff ff       	jmp    80105e91 <alltraps>

80106cbf <vector234>:
.globl vector234
vector234:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $234
80106cc1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106cc6:	e9 c6 f1 ff ff       	jmp    80105e91 <alltraps>

80106ccb <vector235>:
.globl vector235
vector235:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $235
80106ccd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106cd2:	e9 ba f1 ff ff       	jmp    80105e91 <alltraps>

80106cd7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $236
80106cd9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106cde:	e9 ae f1 ff ff       	jmp    80105e91 <alltraps>

80106ce3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $237
80106ce5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106cea:	e9 a2 f1 ff ff       	jmp    80105e91 <alltraps>

80106cef <vector238>:
.globl vector238
vector238:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $238
80106cf1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106cf6:	e9 96 f1 ff ff       	jmp    80105e91 <alltraps>

80106cfb <vector239>:
.globl vector239
vector239:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $239
80106cfd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106d02:	e9 8a f1 ff ff       	jmp    80105e91 <alltraps>

80106d07 <vector240>:
.globl vector240
vector240:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $240
80106d09:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106d0e:	e9 7e f1 ff ff       	jmp    80105e91 <alltraps>

80106d13 <vector241>:
.globl vector241
vector241:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $241
80106d15:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106d1a:	e9 72 f1 ff ff       	jmp    80105e91 <alltraps>

80106d1f <vector242>:
.globl vector242
vector242:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $242
80106d21:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106d26:	e9 66 f1 ff ff       	jmp    80105e91 <alltraps>

80106d2b <vector243>:
.globl vector243
vector243:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $243
80106d2d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106d32:	e9 5a f1 ff ff       	jmp    80105e91 <alltraps>

80106d37 <vector244>:
.globl vector244
vector244:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $244
80106d39:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106d3e:	e9 4e f1 ff ff       	jmp    80105e91 <alltraps>

80106d43 <vector245>:
.globl vector245
vector245:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $245
80106d45:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106d4a:	e9 42 f1 ff ff       	jmp    80105e91 <alltraps>

80106d4f <vector246>:
.globl vector246
vector246:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $246
80106d51:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106d56:	e9 36 f1 ff ff       	jmp    80105e91 <alltraps>

80106d5b <vector247>:
.globl vector247
vector247:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $247
80106d5d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106d62:	e9 2a f1 ff ff       	jmp    80105e91 <alltraps>

80106d67 <vector248>:
.globl vector248
vector248:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $248
80106d69:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106d6e:	e9 1e f1 ff ff       	jmp    80105e91 <alltraps>

80106d73 <vector249>:
.globl vector249
vector249:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $249
80106d75:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106d7a:	e9 12 f1 ff ff       	jmp    80105e91 <alltraps>

80106d7f <vector250>:
.globl vector250
vector250:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $250
80106d81:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106d86:	e9 06 f1 ff ff       	jmp    80105e91 <alltraps>

80106d8b <vector251>:
.globl vector251
vector251:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $251
80106d8d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106d92:	e9 fa f0 ff ff       	jmp    80105e91 <alltraps>

80106d97 <vector252>:
.globl vector252
vector252:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $252
80106d99:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106d9e:	e9 ee f0 ff ff       	jmp    80105e91 <alltraps>

80106da3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $253
80106da5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106daa:	e9 e2 f0 ff ff       	jmp    80105e91 <alltraps>

80106daf <vector254>:
.globl vector254
vector254:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $254
80106db1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106db6:	e9 d6 f0 ff ff       	jmp    80105e91 <alltraps>

80106dbb <vector255>:
.globl vector255
vector255:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $255
80106dbd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106dc2:	e9 ca f0 ff ff       	jmp    80105e91 <alltraps>
80106dc7:	66 90                	xchg   %ax,%ax
80106dc9:	66 90                	xchg   %ax,%ax
80106dcb:	66 90                	xchg   %ax,%ax
80106dcd:	66 90                	xchg   %ax,%ax
80106dcf:	90                   	nop

80106dd0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106dd8:	c1 ea 16             	shr    $0x16,%edx
80106ddb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106dde:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106de1:	8b 07                	mov    (%edi),%eax
80106de3:	a8 01                	test   $0x1,%al
80106de5:	74 29                	je     80106e10 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106de7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dec:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106df2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106df5:	c1 eb 0a             	shr    $0xa,%ebx
80106df8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106dfe:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106e01:	5b                   	pop    %ebx
80106e02:	5e                   	pop    %esi
80106e03:	5f                   	pop    %edi
80106e04:	5d                   	pop    %ebp
80106e05:	c3                   	ret    
80106e06:	8d 76 00             	lea    0x0(%esi),%esi
80106e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e10:	85 c9                	test   %ecx,%ecx
80106e12:	74 2c                	je     80106e40 <walkpgdir+0x70>
80106e14:	e8 27 ba ff ff       	call   80102840 <kalloc>
80106e19:	85 c0                	test   %eax,%eax
80106e1b:	89 c6                	mov    %eax,%esi
80106e1d:	74 21                	je     80106e40 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106e1f:	83 ec 04             	sub    $0x4,%esp
80106e22:	68 00 10 00 00       	push   $0x1000
80106e27:	6a 00                	push   $0x0
80106e29:	50                   	push   %eax
80106e2a:	e8 41 dc ff ff       	call   80104a70 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e2f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e35:	83 c4 10             	add    $0x10,%esp
80106e38:	83 c8 07             	or     $0x7,%eax
80106e3b:	89 07                	mov    %eax,(%edi)
80106e3d:	eb b3                	jmp    80106df2 <walkpgdir+0x22>
80106e3f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106e43:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106e45:	5b                   	pop    %ebx
80106e46:	5e                   	pop    %esi
80106e47:	5f                   	pop    %edi
80106e48:	5d                   	pop    %ebp
80106e49:	c3                   	ret    
80106e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e50 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106e56:	89 d3                	mov    %edx,%ebx
80106e58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106e5e:	83 ec 1c             	sub    $0x1c,%esp
80106e61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106e68:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e70:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106e73:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e76:	29 df                	sub    %ebx,%edi
80106e78:	83 c8 01             	or     $0x1,%eax
80106e7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106e7e:	eb 15                	jmp    80106e95 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106e80:	f6 00 01             	testb  $0x1,(%eax)
80106e83:	75 45                	jne    80106eca <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106e85:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106e88:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106e8b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106e8d:	74 31                	je     80106ec0 <mappages+0x70>
      break;
    a += PGSIZE;
80106e8f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e98:	b9 01 00 00 00       	mov    $0x1,%ecx
80106e9d:	89 da                	mov    %ebx,%edx
80106e9f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106ea2:	e8 29 ff ff ff       	call   80106dd0 <walkpgdir>
80106ea7:	85 c0                	test   %eax,%eax
80106ea9:	75 d5                	jne    80106e80 <mappages+0x30>
    a += PGSIZE;
    pa += PGSIZE;
  }
  
  return 0;
}
80106eab:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106eae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    a += PGSIZE;
    pa += PGSIZE;
  }
  
  return 0;
}
80106eb3:	5b                   	pop    %ebx
80106eb4:	5e                   	pop    %esi
80106eb5:	5f                   	pop    %edi
80106eb6:	5d                   	pop    %ebp
80106eb7:	c3                   	ret    
80106eb8:	90                   	nop
80106eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  
  return 0;
80106ec3:	31 c0                	xor    %eax,%eax
}
80106ec5:	5b                   	pop    %ebx
80106ec6:	5e                   	pop    %esi
80106ec7:	5f                   	pop    %edi
80106ec8:	5d                   	pop    %ebp
80106ec9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106eca:	83 ec 0c             	sub    $0xc,%esp
80106ecd:	68 d0 80 10 80       	push   $0x801080d0
80106ed2:	e8 99 94 ff ff       	call   80100370 <panic>
80106ed7:	89 f6                	mov    %esi,%esi
80106ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ee0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	57                   	push   %edi
80106ee4:	56                   	push   %esi
80106ee5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ee6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106eec:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106eee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ef4:	83 ec 1c             	sub    $0x1c,%esp
80106ef7:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106efa:	39 d3                	cmp    %edx,%ebx
80106efc:	73 66                	jae    80106f64 <deallocuvm.part.0+0x84>
80106efe:	89 d6                	mov    %edx,%esi
80106f00:	eb 3d                	jmp    80106f3f <deallocuvm.part.0+0x5f>
80106f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106f08:	8b 10                	mov    (%eax),%edx
80106f0a:	f6 c2 01             	test   $0x1,%dl
80106f0d:	74 26                	je     80106f35 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106f0f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106f15:	74 58                	je     80106f6f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106f17:	83 ec 0c             	sub    $0xc,%esp
80106f1a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106f20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f23:	52                   	push   %edx
80106f24:	e8 67 b7 ff ff       	call   80102690 <kfree>
      *pte = 0;
80106f29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f2c:	83 c4 10             	add    $0x10,%esp
80106f2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106f35:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f3b:	39 f3                	cmp    %esi,%ebx
80106f3d:	73 25                	jae    80106f64 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106f3f:	31 c9                	xor    %ecx,%ecx
80106f41:	89 da                	mov    %ebx,%edx
80106f43:	89 f8                	mov    %edi,%eax
80106f45:	e8 86 fe ff ff       	call   80106dd0 <walkpgdir>
    if(!pte)
80106f4a:	85 c0                	test   %eax,%eax
80106f4c:	75 ba                	jne    80106f08 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106f4e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106f54:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106f5a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f60:	39 f3                	cmp    %esi,%ebx
80106f62:	72 db                	jb     80106f3f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106f64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f6a:	5b                   	pop    %ebx
80106f6b:	5e                   	pop    %esi
80106f6c:	5f                   	pop    %edi
80106f6d:	5d                   	pop    %ebp
80106f6e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106f6f:	83 ec 0c             	sub    $0xc,%esp
80106f72:	68 26 7a 10 80       	push   $0x80107a26
80106f77:	e8 f4 93 ff ff       	call   80100370 <panic>
80106f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f80 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106f86:	e8 b5 cb ff ff       	call   80103b40 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f8b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106f91:	31 c9                	xor    %ecx,%ecx
80106f93:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106f98:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
80106f9f:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106fa6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106fab:	31 c9                	xor    %ecx,%ecx
80106fad:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106fb4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106fb9:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106fc0:	31 c9                	xor    %ecx,%ecx
80106fc2:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
80106fc9:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106fd0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106fd5:	31 c9                	xor    %ecx,%ecx
80106fd7:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106fde:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106fe5:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106fea:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
80106ff1:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
80106ff8:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106fff:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
80107006:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
8010700d:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
80107014:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010701b:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
80107022:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
80107029:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
80107030:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107037:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
8010703e:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
80107045:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
8010704c:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
80107053:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010705a:	05 f0 37 11 80       	add    $0x801137f0,%eax
8010705f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80107063:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107067:	c1 e8 10             	shr    $0x10,%eax
8010706a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010706e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107071:	0f 01 10             	lgdtl  (%eax)
}
80107074:	c9                   	leave  
80107075:	c3                   	ret    
80107076:	8d 76 00             	lea    0x0(%esi),%esi
80107079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107080 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107080:	a1 a4 68 11 80       	mov    0x801168a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107085:	55                   	push   %ebp
80107086:	89 e5                	mov    %esp,%ebp
80107088:	05 00 00 00 80       	add    $0x80000000,%eax
8010708d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80107090:	5d                   	pop    %ebp
80107091:	c3                   	ret    
80107092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070a0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	53                   	push   %ebx
801070a6:	83 ec 1c             	sub    $0x1c,%esp
801070a9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801070ac:	85 f6                	test   %esi,%esi
801070ae:	0f 84 cd 00 00 00    	je     80107181 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801070b4:	8b 46 08             	mov    0x8(%esi),%eax
801070b7:	85 c0                	test   %eax,%eax
801070b9:	0f 84 dc 00 00 00    	je     8010719b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801070bf:	8b 7e 04             	mov    0x4(%esi),%edi
801070c2:	85 ff                	test   %edi,%edi
801070c4:	0f 84 c4 00 00 00    	je     8010718e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
801070ca:	e8 c1 d7 ff ff       	call   80104890 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801070cf:	e8 ec c9 ff ff       	call   80103ac0 <mycpu>
801070d4:	89 c3                	mov    %eax,%ebx
801070d6:	e8 e5 c9 ff ff       	call   80103ac0 <mycpu>
801070db:	89 c7                	mov    %eax,%edi
801070dd:	e8 de c9 ff ff       	call   80103ac0 <mycpu>
801070e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070e5:	83 c7 08             	add    $0x8,%edi
801070e8:	e8 d3 c9 ff ff       	call   80103ac0 <mycpu>
801070ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801070f0:	83 c0 08             	add    $0x8,%eax
801070f3:	ba 67 00 00 00       	mov    $0x67,%edx
801070f8:	c1 e8 18             	shr    $0x18,%eax
801070fb:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107102:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107109:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107110:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80107117:	83 c1 08             	add    $0x8,%ecx
8010711a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107120:	c1 e9 10             	shr    $0x10,%ecx
80107123:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107129:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010712e:	e8 8d c9 ff ff       	call   80103ac0 <mycpu>
80107133:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010713a:	e8 81 c9 ff ff       	call   80103ac0 <mycpu>
8010713f:	b9 10 00 00 00       	mov    $0x10,%ecx
80107144:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107148:	e8 73 c9 ff ff       	call   80103ac0 <mycpu>
8010714d:	8b 56 08             	mov    0x8(%esi),%edx
80107150:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80107156:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107159:	e8 62 c9 ff ff       	call   80103ac0 <mycpu>
8010715e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107162:	b8 28 00 00 00       	mov    $0x28,%eax
80107167:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010716a:	8b 46 04             	mov    0x4(%esi),%eax
8010716d:	05 00 00 00 80       	add    $0x80000000,%eax
80107172:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107175:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107178:	5b                   	pop    %ebx
80107179:	5e                   	pop    %esi
8010717a:	5f                   	pop    %edi
8010717b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010717c:	e9 4f d7 ff ff       	jmp    801048d0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80107181:	83 ec 0c             	sub    $0xc,%esp
80107184:	68 d6 80 10 80       	push   $0x801080d6
80107189:	e8 e2 91 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010718e:	83 ec 0c             	sub    $0xc,%esp
80107191:	68 01 81 10 80       	push   $0x80108101
80107196:	e8 d5 91 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010719b:	83 ec 0c             	sub    $0xc,%esp
8010719e:	68 ec 80 10 80       	push   $0x801080ec
801071a3:	e8 c8 91 ff ff       	call   80100370 <panic>
801071a8:	90                   	nop
801071a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071b0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 1c             	sub    $0x1c,%esp
801071b9:	8b 75 10             	mov    0x10(%ebp),%esi
801071bc:	8b 45 08             	mov    0x8(%ebp),%eax
801071bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801071c2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801071c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801071cb:	77 49                	ja     80107216 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801071cd:	e8 6e b6 ff ff       	call   80102840 <kalloc>
  memset(mem, 0, PGSIZE);
801071d2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801071d5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801071d7:	68 00 10 00 00       	push   $0x1000
801071dc:	6a 00                	push   $0x0
801071de:	50                   	push   %eax
801071df:	e8 8c d8 ff ff       	call   80104a70 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801071e4:	58                   	pop    %eax
801071e5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071eb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071f0:	5a                   	pop    %edx
801071f1:	6a 06                	push   $0x6
801071f3:	50                   	push   %eax
801071f4:	31 d2                	xor    %edx,%edx
801071f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071f9:	e8 52 fc ff ff       	call   80106e50 <mappages>
  memmove(mem, init, sz);
801071fe:	89 75 10             	mov    %esi,0x10(%ebp)
80107201:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107204:	83 c4 10             	add    $0x10,%esp
80107207:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010720a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010720d:	5b                   	pop    %ebx
8010720e:	5e                   	pop    %esi
8010720f:	5f                   	pop    %edi
80107210:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107211:	e9 0a d9 ff ff       	jmp    80104b20 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107216:	83 ec 0c             	sub    $0xc,%esp
80107219:	68 15 81 10 80       	push   $0x80108115
8010721e:	e8 4d 91 ff ff       	call   80100370 <panic>
80107223:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107230 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	53                   	push   %ebx
80107236:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107239:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107240:	0f 85 91 00 00 00    	jne    801072d7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107246:	8b 75 18             	mov    0x18(%ebp),%esi
80107249:	31 db                	xor    %ebx,%ebx
8010724b:	85 f6                	test   %esi,%esi
8010724d:	75 1a                	jne    80107269 <loaduvm+0x39>
8010724f:	eb 6f                	jmp    801072c0 <loaduvm+0x90>
80107251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107258:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010725e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107264:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107267:	76 57                	jbe    801072c0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107269:	8b 55 0c             	mov    0xc(%ebp),%edx
8010726c:	8b 45 08             	mov    0x8(%ebp),%eax
8010726f:	31 c9                	xor    %ecx,%ecx
80107271:	01 da                	add    %ebx,%edx
80107273:	e8 58 fb ff ff       	call   80106dd0 <walkpgdir>
80107278:	85 c0                	test   %eax,%eax
8010727a:	74 4e                	je     801072ca <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010727c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010727e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107281:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107286:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010728b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107291:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107294:	01 d9                	add    %ebx,%ecx
80107296:	05 00 00 00 80       	add    $0x80000000,%eax
8010729b:	57                   	push   %edi
8010729c:	51                   	push   %ecx
8010729d:	50                   	push   %eax
8010729e:	ff 75 10             	pushl  0x10(%ebp)
801072a1:	e8 5a aa ff ff       	call   80101d00 <readi>
801072a6:	83 c4 10             	add    $0x10,%esp
801072a9:	39 c7                	cmp    %eax,%edi
801072ab:	74 ab                	je     80107258 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801072ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
801072b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801072b5:	5b                   	pop    %ebx
801072b6:	5e                   	pop    %esi
801072b7:	5f                   	pop    %edi
801072b8:	5d                   	pop    %ebp
801072b9:	c3                   	ret    
801072ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801072c3:	31 c0                	xor    %eax,%eax
}
801072c5:	5b                   	pop    %ebx
801072c6:	5e                   	pop    %esi
801072c7:	5f                   	pop    %edi
801072c8:	5d                   	pop    %ebp
801072c9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801072ca:	83 ec 0c             	sub    $0xc,%esp
801072cd:	68 2f 81 10 80       	push   $0x8010812f
801072d2:	e8 99 90 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801072d7:	83 ec 0c             	sub    $0xc,%esp
801072da:	68 d0 81 10 80       	push   $0x801081d0
801072df:	e8 8c 90 ff ff       	call   80100370 <panic>
801072e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801072f0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	57                   	push   %edi
801072f4:	56                   	push   %esi
801072f5:	53                   	push   %ebx
801072f6:	83 ec 0c             	sub    $0xc,%esp
801072f9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801072fc:	85 ff                	test   %edi,%edi
801072fe:	0f 88 ca 00 00 00    	js     801073ce <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107304:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107307:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010730a:	0f 82 82 00 00 00    	jb     80107392 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107310:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107316:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010731c:	39 df                	cmp    %ebx,%edi
8010731e:	77 43                	ja     80107363 <allocuvm+0x73>
80107320:	e9 bb 00 00 00       	jmp    801073e0 <allocuvm+0xf0>
80107325:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107328:	83 ec 04             	sub    $0x4,%esp
8010732b:	68 00 10 00 00       	push   $0x1000
80107330:	6a 00                	push   $0x0
80107332:	50                   	push   %eax
80107333:	e8 38 d7 ff ff       	call   80104a70 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107338:	58                   	pop    %eax
80107339:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010733f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107344:	5a                   	pop    %edx
80107345:	6a 06                	push   $0x6
80107347:	50                   	push   %eax
80107348:	89 da                	mov    %ebx,%edx
8010734a:	8b 45 08             	mov    0x8(%ebp),%eax
8010734d:	e8 fe fa ff ff       	call   80106e50 <mappages>
80107352:	83 c4 10             	add    $0x10,%esp
80107355:	85 c0                	test   %eax,%eax
80107357:	78 47                	js     801073a0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107359:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010735f:	39 df                	cmp    %ebx,%edi
80107361:	76 7d                	jbe    801073e0 <allocuvm+0xf0>
    mem = kalloc();
80107363:	e8 d8 b4 ff ff       	call   80102840 <kalloc>
    if(mem == 0){
80107368:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010736a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010736c:	75 ba                	jne    80107328 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010736e:	83 ec 0c             	sub    $0xc,%esp
80107371:	68 4d 81 10 80       	push   $0x8010814d
80107376:	e8 e5 92 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010737b:	83 c4 10             	add    $0x10,%esp
8010737e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107381:	76 4b                	jbe    801073ce <allocuvm+0xde>
80107383:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107386:	8b 45 08             	mov    0x8(%ebp),%eax
80107389:	89 fa                	mov    %edi,%edx
8010738b:	e8 50 fb ff ff       	call   80106ee0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107390:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107392:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107395:	5b                   	pop    %ebx
80107396:	5e                   	pop    %esi
80107397:	5f                   	pop    %edi
80107398:	5d                   	pop    %ebp
80107399:	c3                   	ret    
8010739a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801073a0:	83 ec 0c             	sub    $0xc,%esp
801073a3:	68 65 81 10 80       	push   $0x80108165
801073a8:	e8 b3 92 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801073ad:	83 c4 10             	add    $0x10,%esp
801073b0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801073b3:	76 0d                	jbe    801073c2 <allocuvm+0xd2>
801073b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073b8:	8b 45 08             	mov    0x8(%ebp),%eax
801073bb:	89 fa                	mov    %edi,%edx
801073bd:	e8 1e fb ff ff       	call   80106ee0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
801073c2:	83 ec 0c             	sub    $0xc,%esp
801073c5:	56                   	push   %esi
801073c6:	e8 c5 b2 ff ff       	call   80102690 <kfree>
      return 0;
801073cb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
801073ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
801073d1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
801073d3:	5b                   	pop    %ebx
801073d4:	5e                   	pop    %esi
801073d5:	5f                   	pop    %edi
801073d6:	5d                   	pop    %ebp
801073d7:	c3                   	ret    
801073d8:	90                   	nop
801073d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801073e3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801073e5:	5b                   	pop    %ebx
801073e6:	5e                   	pop    %esi
801073e7:	5f                   	pop    %edi
801073e8:	5d                   	pop    %ebp
801073e9:	c3                   	ret    
801073ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073f0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801073f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801073f9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801073fc:	39 d1                	cmp    %edx,%ecx
801073fe:	73 10                	jae    80107410 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107400:	5d                   	pop    %ebp
80107401:	e9 da fa ff ff       	jmp    80106ee0 <deallocuvm.part.0>
80107406:	8d 76 00             	lea    0x0(%esi),%esi
80107409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107410:	89 d0                	mov    %edx,%eax
80107412:	5d                   	pop    %ebp
80107413:	c3                   	ret    
80107414:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010741a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107420 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
80107426:	83 ec 0c             	sub    $0xc,%esp
80107429:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010742c:	85 f6                	test   %esi,%esi
8010742e:	74 59                	je     80107489 <freevm+0x69>
80107430:	31 c9                	xor    %ecx,%ecx
80107432:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107437:	89 f0                	mov    %esi,%eax
80107439:	e8 a2 fa ff ff       	call   80106ee0 <deallocuvm.part.0>
8010743e:	89 f3                	mov    %esi,%ebx
80107440:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107446:	eb 0f                	jmp    80107457 <freevm+0x37>
80107448:	90                   	nop
80107449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107450:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107453:	39 fb                	cmp    %edi,%ebx
80107455:	74 23                	je     8010747a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107457:	8b 03                	mov    (%ebx),%eax
80107459:	a8 01                	test   $0x1,%al
8010745b:	74 f3                	je     80107450 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
8010745d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107462:	83 ec 0c             	sub    $0xc,%esp
80107465:	83 c3 04             	add    $0x4,%ebx
80107468:	05 00 00 00 80       	add    $0x80000000,%eax
8010746d:	50                   	push   %eax
8010746e:	e8 1d b2 ff ff       	call   80102690 <kfree>
80107473:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107476:	39 fb                	cmp    %edi,%ebx
80107478:	75 dd                	jne    80107457 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010747a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010747d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107480:	5b                   	pop    %ebx
80107481:	5e                   	pop    %esi
80107482:	5f                   	pop    %edi
80107483:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107484:	e9 07 b2 ff ff       	jmp    80102690 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107489:	83 ec 0c             	sub    $0xc,%esp
8010748c:	68 81 81 10 80       	push   $0x80108181
80107491:	e8 da 8e ff ff       	call   80100370 <panic>
80107496:	8d 76 00             	lea    0x0(%esi),%esi
80107499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074a0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	56                   	push   %esi
801074a4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801074a5:	e8 96 b3 ff ff       	call   80102840 <kalloc>
801074aa:	85 c0                	test   %eax,%eax
801074ac:	74 6a                	je     80107518 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
801074ae:	83 ec 04             	sub    $0x4,%esp
801074b1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801074b3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
801074b8:	68 00 10 00 00       	push   $0x1000
801074bd:	6a 00                	push   $0x0
801074bf:	50                   	push   %eax
801074c0:	e8 ab d5 ff ff       	call   80104a70 <memset>
801074c5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801074c8:	8b 43 04             	mov    0x4(%ebx),%eax
801074cb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801074ce:	83 ec 08             	sub    $0x8,%esp
801074d1:	8b 13                	mov    (%ebx),%edx
801074d3:	ff 73 0c             	pushl  0xc(%ebx)
801074d6:	50                   	push   %eax
801074d7:	29 c1                	sub    %eax,%ecx
801074d9:	89 f0                	mov    %esi,%eax
801074db:	e8 70 f9 ff ff       	call   80106e50 <mappages>
801074e0:	83 c4 10             	add    $0x10,%esp
801074e3:	85 c0                	test   %eax,%eax
801074e5:	78 19                	js     80107500 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801074e7:	83 c3 10             	add    $0x10,%ebx
801074ea:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801074f0:	75 d6                	jne    801074c8 <setupkvm+0x28>
801074f2:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
801074f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074f7:	5b                   	pop    %ebx
801074f8:	5e                   	pop    %esi
801074f9:	5d                   	pop    %ebp
801074fa:	c3                   	ret    
801074fb:	90                   	nop
801074fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107500:	83 ec 0c             	sub    $0xc,%esp
80107503:	56                   	push   %esi
80107504:	e8 17 ff ff ff       	call   80107420 <freevm>
      return 0;
80107509:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010750c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010750f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107511:	5b                   	pop    %ebx
80107512:	5e                   	pop    %esi
80107513:	5d                   	pop    %ebp
80107514:	c3                   	ret    
80107515:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107518:	31 c0                	xor    %eax,%eax
8010751a:	eb d8                	jmp    801074f4 <setupkvm+0x54>
8010751c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107520 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107526:	e8 75 ff ff ff       	call   801074a0 <setupkvm>
8010752b:	a3 a4 68 11 80       	mov    %eax,0x801168a4
80107530:	05 00 00 00 80       	add    $0x80000000,%eax
80107535:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107538:	c9                   	leave  
80107539:	c3                   	ret    
8010753a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107540 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107540:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107541:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107543:	89 e5                	mov    %esp,%ebp
80107545:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107548:	8b 55 0c             	mov    0xc(%ebp),%edx
8010754b:	8b 45 08             	mov    0x8(%ebp),%eax
8010754e:	e8 7d f8 ff ff       	call   80106dd0 <walkpgdir>
  if(pte == 0)
80107553:	85 c0                	test   %eax,%eax
80107555:	74 05                	je     8010755c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107557:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010755a:	c9                   	leave  
8010755b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010755c:	83 ec 0c             	sub    $0xc,%esp
8010755f:	68 92 81 10 80       	push   $0x80108192
80107564:	e8 07 8e ff ff       	call   80100370 <panic>
80107569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107570 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	57                   	push   %edi
80107574:	56                   	push   %esi
80107575:	53                   	push   %ebx
80107576:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107579:	e8 22 ff ff ff       	call   801074a0 <setupkvm>
8010757e:	85 c0                	test   %eax,%eax
80107580:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107583:	0f 84 c5 00 00 00    	je     8010764e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107589:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010758c:	85 c9                	test   %ecx,%ecx
8010758e:	0f 84 9c 00 00 00    	je     80107630 <copyuvm+0xc0>
80107594:	31 ff                	xor    %edi,%edi
80107596:	eb 4a                	jmp    801075e2 <copyuvm+0x72>
80107598:	90                   	nop
80107599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801075a0:	83 ec 04             	sub    $0x4,%esp
801075a3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801075a9:	68 00 10 00 00       	push   $0x1000
801075ae:	53                   	push   %ebx
801075af:	50                   	push   %eax
801075b0:	e8 6b d5 ff ff       	call   80104b20 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801075b5:	58                   	pop    %eax
801075b6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801075bc:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075c1:	5a                   	pop    %edx
801075c2:	ff 75 e4             	pushl  -0x1c(%ebp)
801075c5:	50                   	push   %eax
801075c6:	89 fa                	mov    %edi,%edx
801075c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075cb:	e8 80 f8 ff ff       	call   80106e50 <mappages>
801075d0:	83 c4 10             	add    $0x10,%esp
801075d3:	85 c0                	test   %eax,%eax
801075d5:	78 69                	js     80107640 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801075d7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801075dd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801075e0:	76 4e                	jbe    80107630 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801075e2:	8b 45 08             	mov    0x8(%ebp),%eax
801075e5:	31 c9                	xor    %ecx,%ecx
801075e7:	89 fa                	mov    %edi,%edx
801075e9:	e8 e2 f7 ff ff       	call   80106dd0 <walkpgdir>
801075ee:	85 c0                	test   %eax,%eax
801075f0:	74 6d                	je     8010765f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801075f2:	8b 00                	mov    (%eax),%eax
801075f4:	a8 01                	test   $0x1,%al
801075f6:	74 5a                	je     80107652 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801075f8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801075fa:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801075ff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107605:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107608:	e8 33 b2 ff ff       	call   80102840 <kalloc>
8010760d:	85 c0                	test   %eax,%eax
8010760f:	89 c6                	mov    %eax,%esi
80107611:	75 8d                	jne    801075a0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107613:	83 ec 0c             	sub    $0xc,%esp
80107616:	ff 75 e0             	pushl  -0x20(%ebp)
80107619:	e8 02 fe ff ff       	call   80107420 <freevm>
  return 0;
8010761e:	83 c4 10             	add    $0x10,%esp
80107621:	31 c0                	xor    %eax,%eax
}
80107623:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107626:	5b                   	pop    %ebx
80107627:	5e                   	pop    %esi
80107628:	5f                   	pop    %edi
80107629:	5d                   	pop    %ebp
8010762a:	c3                   	ret    
8010762b:	90                   	nop
8010762c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107630:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107633:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107636:	5b                   	pop    %ebx
80107637:	5e                   	pop    %esi
80107638:	5f                   	pop    %edi
80107639:	5d                   	pop    %ebp
8010763a:	c3                   	ret    
8010763b:	90                   	nop
8010763c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80107640:	83 ec 0c             	sub    $0xc,%esp
80107643:	56                   	push   %esi
80107644:	e8 47 b0 ff ff       	call   80102690 <kfree>
      goto bad;
80107649:	83 c4 10             	add    $0x10,%esp
8010764c:	eb c5                	jmp    80107613 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010764e:	31 c0                	xor    %eax,%eax
80107650:	eb d1                	jmp    80107623 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80107652:	83 ec 0c             	sub    $0xc,%esp
80107655:	68 b6 81 10 80       	push   $0x801081b6
8010765a:	e8 11 8d ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010765f:	83 ec 0c             	sub    $0xc,%esp
80107662:	68 9c 81 10 80       	push   $0x8010819c
80107667:	e8 04 8d ff ff       	call   80100370 <panic>
8010766c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107670 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107670:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107671:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107673:	89 e5                	mov    %esp,%ebp
80107675:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107678:	8b 55 0c             	mov    0xc(%ebp),%edx
8010767b:	8b 45 08             	mov    0x8(%ebp),%eax
8010767e:	e8 4d f7 ff ff       	call   80106dd0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107683:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107685:	89 c2                	mov    %eax,%edx
80107687:	83 e2 05             	and    $0x5,%edx
8010768a:	83 fa 05             	cmp    $0x5,%edx
8010768d:	75 11                	jne    801076a0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010768f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107694:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107695:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010769a:	c3                   	ret    
8010769b:	90                   	nop
8010769c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801076a0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801076a2:	c9                   	leave  
801076a3:	c3                   	ret    
801076a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801076aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801076b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	57                   	push   %edi
801076b4:	56                   	push   %esi
801076b5:	53                   	push   %ebx
801076b6:	83 ec 1c             	sub    $0x1c,%esp
801076b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801076bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801076bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801076c2:	85 db                	test   %ebx,%ebx
801076c4:	75 40                	jne    80107706 <copyout+0x56>
801076c6:	eb 70                	jmp    80107738 <copyout+0x88>
801076c8:	90                   	nop
801076c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801076d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801076d3:	89 f1                	mov    %esi,%ecx
801076d5:	29 d1                	sub    %edx,%ecx
801076d7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801076dd:	39 d9                	cmp    %ebx,%ecx
801076df:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801076e2:	29 f2                	sub    %esi,%edx
801076e4:	83 ec 04             	sub    $0x4,%esp
801076e7:	01 d0                	add    %edx,%eax
801076e9:	51                   	push   %ecx
801076ea:	57                   	push   %edi
801076eb:	50                   	push   %eax
801076ec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801076ef:	e8 2c d4 ff ff       	call   80104b20 <memmove>
    len -= n;
    buf += n;
801076f4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801076f7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
801076fa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107700:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107702:	29 cb                	sub    %ecx,%ebx
80107704:	74 32                	je     80107738 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107706:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107708:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010770b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010770e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107714:	56                   	push   %esi
80107715:	ff 75 08             	pushl  0x8(%ebp)
80107718:	e8 53 ff ff ff       	call   80107670 <uva2ka>
    if(pa0 == 0)
8010771d:	83 c4 10             	add    $0x10,%esp
80107720:	85 c0                	test   %eax,%eax
80107722:	75 ac                	jne    801076d0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107724:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107727:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010772c:	5b                   	pop    %ebx
8010772d:	5e                   	pop    %esi
8010772e:	5f                   	pop    %edi
8010772f:	5d                   	pop    %ebp
80107730:	c3                   	ret    
80107731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107738:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010773b:	31 c0                	xor    %eax,%eax
}
8010773d:	5b                   	pop    %ebx
8010773e:	5e                   	pop    %esi
8010773f:	5f                   	pop    %edi
80107740:	5d                   	pop    %ebp
80107741:	c3                   	ret    
80107742:	66 90                	xchg   %ax,%ax
80107744:	66 90                	xchg   %ax,%ax
80107746:	66 90                	xchg   %ax,%ax
80107748:	66 90                	xchg   %ax,%ax
8010774a:	66 90                	xchg   %ax,%ax
8010774c:	66 90                	xchg   %ax,%ax
8010774e:	66 90                	xchg   %ax,%ax

80107750 <myfunction>:
#include "types.h"
#include "defs.h"

// Simple system call

int myfunction(char *str){
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	83 ec 10             	sub    $0x10,%esp
    cprintf("%s\n",str);
80107756:	ff 75 08             	pushl  0x8(%ebp)
80107759:	68 f4 81 10 80       	push   $0x801081f4
8010775e:	e8 fd 8e ff ff       	call   80100660 <cprintf>
    return 0XABCDABCD;
}
80107763:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
80107768:	c9                   	leave  
80107769:	c3                   	ret    
8010776a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107770 <sys_myfunction>:

//Wrapper for my_syscall

int sys_myfunction(void){
80107770:	55                   	push   %ebp
80107771:	89 e5                	mov    %esp,%ebp
80107773:	83 ec 20             	sub    $0x20,%esp
    char *str;
    //Decode argument using argstr
    if(argstr(0,&str) < 0)
80107776:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107779:	50                   	push   %eax
8010777a:	6a 00                	push   $0x0
8010777c:	e8 af d6 ff ff       	call   80104e30 <argstr>
80107781:	83 c4 10             	add    $0x10,%esp
80107784:	85 c0                	test   %eax,%eax
80107786:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010778b:	78 18                	js     801077a5 <sys_myfunction+0x35>
#include "defs.h"

// Simple system call

int myfunction(char *str){
    cprintf("%s\n",str);
8010778d:	83 ec 08             	sub    $0x8,%esp
80107790:	ff 75 f4             	pushl  -0xc(%ebp)
80107793:	68 f4 81 10 80       	push   $0x801081f4
80107798:	e8 c3 8e ff ff       	call   80100660 <cprintf>
int sys_myfunction(void){
    char *str;
    //Decode argument using argstr
    if(argstr(0,&str) < 0)
        return -1;
    return myfunction(str);
8010779d:	83 c4 10             	add    $0x10,%esp
801077a0:	ba cd ab cd ab       	mov    $0xabcdabcd,%edx
}
801077a5:	89 d0                	mov    %edx,%eax
801077a7:	c9                   	leave  
801077a8:	c3                   	ret    
