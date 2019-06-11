//
// File descriptors
//

#include "types.h"
#include "defs.h"
#include "param.h"
#include "fs.h"
#include "file.h"
#include "spinlock.h"

struct devsw devsw[NDEV];
struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

struct {
	struct spinlock lock;
	struct semaphore semtab[NSEM];
} semtable;

void semaphore_init(void){
	initlock(&semtable.lock, "semtable");
	struct semaphore* sem;
	for(sem = semtable.semtab; sem < semtable.semtab + NSEM; sem++){
		sem->free = S_FREE;	
	}
	return;
}

int sem_alloc(){
		struct semaphore* sem;
		acquire(&semtable.lock);
		for(sem = semtable.semtab; sem < semtable.semtab + NSEM; sem++){
			if(sem->free == S_FREE){
				sem->free = S_ALLOC;
				sem_alloc_proctable(sem - semtable.semtab);
				release(&semtable.lock);
				return (sem - semtable.semtab);			
			}		
		}
		release(&semtable.lock);
		return -1;
}

int sem_destroy(int sem){
	struct semaphore* semph;
	acquire(&semtable.lock);
	semph = semtable.semtab + sem;
	if((semph < semtable.semtab) || (semph > semtable.semtab + NSEM) || (semph->free == S_FREE)){
		release(&semtable.lock);		
		return -1;
	} 
	while(semph->count < 0){
		wakeup(semph);
	}
	semph->free = S_FREE;
	release(&semtable.lock);
	return 0;	
}

int sem_init(int sem, int count){
	struct semaphore* semph;
	acquire(&semtable.lock);
	semph = semtable.semtab + sem;
	if((semph < semtable.semtab) || (semph > semtable.semtab + NSEM) || (semph->free == S_FREE)){
		release(&semtable.lock);
		return -1;
	}
	semph->count = count;
	release(&semtable.lock);
	return 0; 
}

int sem_wait(int sem){
	struct semaphore* semph;
	acquire(&semtable.lock);
	semph = semtable.semtab + sem;
	if((semph < semtable.semtab) || (semph > semtable.semtab + NSEM) || (semph->free == S_FREE)){
		release(&semtable.lock);		
		return -1;
	}
	if(--semph->count < 0){
		sleep(semph, &semtable.lock);
		release(&semtable.lock);		
		return 0;
	}
	release(&semtable.lock);
	return 0;
}

int sem_post(int sem){
	struct semaphore* semph;
	acquire(&semtable.lock);
	semph = semtable.semtab + sem;
	if((semph < semtable.semtab) || (semph > semtable.semtab + NSEM) || (semph->free == S_FREE)){
		release(&semtable.lock);		
		return -1;
	}
	if(semph->count++ < 0){
		wakeup(semph);
		release(&semtable.lock);		
		return 0;
	}
	release(&semtable.lock);
	return 0;
}

void
fileinit(void)
{
  initlock(&ftable.lock, "ftable");
}

// Allocate a file structure.
struct file*
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
  release(&ftable.lock);
  return f;
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_trans();
    iput(ff.ip);
    commit_trans();
  }
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
}

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
    // write a few blocks at a time to avoid exceeding
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_trans();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}

