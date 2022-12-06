#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]){
    int p[2];
    char send[2] = "s";
    char receive[2];
    if(pipe(p) < 0){
        fprintf(2, "pipe");
        exit(1);
    }
    int pid = fork();
    if(pid == 0){
        if(read(p[0], receive, 1) != 1){
            fprintf(2, "failed to read in child\n");
			exit(1);
        }
        printf("%d: received ping\n", getpid());
        close(p[0]);
        if(write(p[1], send, 1) != 1){
            fprintf(2, "failed to write in child\n");
			exit(1);
        }
        close(p[1]);
        exit(0);
    }
    if(write(p[1], send, 1) != 1){
        fprintf(2, "failed to write in parent\n");
		exit(1);
    }
    close(p[1]);
    wait(0);
    if(read(p[0], receive, 1) != 1){
        fprintf(2, "failed to read in parent\n");
		exit(1);
    }
    printf("%d: received pong\n", getpid());
    close(p[0]);
    exit(0);
}