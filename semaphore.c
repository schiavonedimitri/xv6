#include "types.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "semaphore.h"

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
