#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void new_porc(const int p[2]){
    int prime;
    int temp;
    close(p[1]);
    if(read(p[0], &prime, 4) != 4){
        fprintf(2, "process failed to read from the pipe\n");
        exit(1);
    }
    printf("prime %d\n", prime);
    int flag = read(p[0], &temp, 4);
    if(flag){
        int new_pipe[2];
        if(pipe(new_pipe) < 0){
            fprintf(2, "new pipe");
            exit(1);
        }
        if(fork() == 0){
            new_porc(new_pipe);
        }else{
            close(new_pipe[0]);
            if(temp%prime){
                    if(write(new_pipe[1], &temp, 4) != 4){
                        fprintf(2, "process failed to write %d into the pipe\n", temp);
                        exit(1);
                    }
            }
            while(read(p[0], &temp, 4)){
                if(temp%prime){
                    if(write(new_pipe[1], &temp, 4) != 4){
                        fprintf(2, "process failed to write %d into the pipe\n", temp);
                        exit(1);
                    }
                }
            }
            close(p[0]);
            close(new_pipe[1]);
            wait(0);
        }
    }
    exit(0);
}

int main(int argc, char *argv[]){
    int p[2];
    if(pipe(p) < 0){
        fprintf(2, "pipe");
        exit(1);
    }
    if(fork() == 0){
        new_porc(p);
    }else{
        close(p[0]);
        for(int i = 2; i <= 35 ;i++){
            if(write(p[1], &i, 4) != 4){
                fprintf(2, "first process failed to write %d into the pipe\n", i);
                exit(1);
            }
        }
        close(p[1]);
        wait(0);
        exit(0);
    }
    return 0;
}