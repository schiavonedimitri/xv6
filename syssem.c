#include "types.h"
#include "defs.h"
#include "param.h"

int sys_sem_alloc(void){
	return sem_alloc();
}

int sys_sem_destroy(int sem){
	argint(0, &sem);
	return sem_destroy(sem);
}

int sys_sem_init(int sem, int count){
	argint(0, &sem);
	argint(1, &count);
	return sem_init(sem, count);
}

int sys_sem_post(int sem){
	argint(0, &sem);	
	return sem_post(sem);
}

int sys_sem_wait(int sem){
	argint(0, &sem);	
	return sem_wait(sem);
}

