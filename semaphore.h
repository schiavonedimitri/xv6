//p
#define S_ALLOC 0x1
#define S_FREE 0x0

struct semaphore {
	int free;
	int count;
};
