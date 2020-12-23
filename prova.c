#include "types.h"
#include "user.h"

int main(int argc, char *argv[]){
    
    char *buf = malloc(1000000000*sizeof(char));
    char *buf2 = malloc(1000*sizeof(char));
    buf2[1] = 3;
    buf[0] = 2;
    printf(1, "%d\n%d\n", buf[0], buf2[1]);
    exit();
    
}
