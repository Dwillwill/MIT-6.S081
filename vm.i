# 1 "kernel/vm.c"
# 1 "/Users/apple/xv6-labs-2021//"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "kernel/vm.c"
# 1 "kernel/param.h" 1
# 2 "kernel/vm.c" 2
# 1 "kernel/types.h" 1
typedef unsigned int uint;
typedef unsigned short ushort;
typedef unsigned char uchar;

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef unsigned long uint64;

typedef uint64 pde_t;
# 3 "kernel/vm.c" 2
# 1 "kernel/memlayout.h" 1
# 4 "kernel/vm.c" 2
# 1 "kernel/elf.h" 1





struct elfhdr {
  uint magic;
  uchar elf[12];
  ushort type;
  ushort machine;
  uint version;
  uint64 entry;
  uint64 phoff;
  uint64 shoff;
  uint flags;
  ushort ehsize;
  ushort phentsize;
  ushort phnum;
  ushort shentsize;
  ushort shnum;
  ushort shstrndx;
};


struct proghdr {
  uint32 type;
  uint32 flags;
  uint64 off;
  uint64 vaddr;
  uint64 paddr;
  uint64 filesz;
  uint64 memsz;
  uint64 align;
};
# 5 "kernel/vm.c" 2
# 1 "kernel/riscv.h" 1

static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
  return x;
}
# 18 "kernel/riscv.h"
static inline uint64
r_mstatus()
{
  uint64 x;
  asm volatile("csrr %0, mstatus" : "=r" (x) );
  return x;
}

static inline void
w_mstatus(uint64 x)
{
  asm volatile("csrw mstatus, %0" : : "r" (x));
}




static inline void
w_mepc(uint64 x)
{
  asm volatile("csrw mepc, %0" : : "r" (x));
}
# 49 "kernel/riscv.h"
static inline uint64
r_sstatus()
{
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
  return x;
}

static inline void
w_sstatus(uint64 x)
{
  asm volatile("csrw sstatus, %0" : : "r" (x));
}


static inline uint64
r_sip()
{
  uint64 x;
  asm volatile("csrr %0, sip" : "=r" (x) );
  return x;
}

static inline void
w_sip(uint64 x)
{
  asm volatile("csrw sip, %0" : : "r" (x));
}





static inline uint64
r_sie()
{
  uint64 x;
  asm volatile("csrr %0, sie" : "=r" (x) );
  return x;
}

static inline void
w_sie(uint64 x)
{
  asm volatile("csrw sie, %0" : : "r" (x));
}





static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
  return x;
}

static inline void
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
}




static inline void
w_sepc(uint64 x)
{
  asm volatile("csrw sepc, %0" : : "r" (x));
}

static inline uint64
r_sepc()
{
  uint64 x;
  asm volatile("csrr %0, sepc" : "=r" (x) );
  return x;
}


static inline uint64
r_medeleg()
{
  uint64 x;
  asm volatile("csrr %0, medeleg" : "=r" (x) );
  return x;
}

static inline void
w_medeleg(uint64 x)
{
  asm volatile("csrw medeleg, %0" : : "r" (x));
}


static inline uint64
r_mideleg()
{
  uint64 x;
  asm volatile("csrr %0, mideleg" : "=r" (x) );
  return x;
}

static inline void
w_mideleg(uint64 x)
{
  asm volatile("csrw mideleg, %0" : : "r" (x));
}



static inline void
w_stvec(uint64 x)
{
  asm volatile("csrw stvec, %0" : : "r" (x));
}

static inline uint64
r_stvec()
{
  uint64 x;
  asm volatile("csrr %0, stvec" : "=r" (x) );
  return x;
}


static inline void
w_mtvec(uint64 x)
{
  asm volatile("csrw mtvec, %0" : : "r" (x));
}

static inline void
w_pmpcfg0(uint64 x)
{
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
}

static inline void
w_pmpaddr0(uint64 x)
{
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
}
# 203 "kernel/riscv.h"
static inline void
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
}

static inline uint64
r_satp()
{
  uint64 x;
  asm volatile("csrr %0, satp" : "=r" (x) );
  return x;
}


static inline void
w_sscratch(uint64 x)
{
  asm volatile("csrw sscratch, %0" : : "r" (x));
}

static inline void
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
}


static inline uint64
r_scause()
{
  uint64 x;
  asm volatile("csrr %0, scause" : "=r" (x) );
  return x;
}


static inline uint64
r_stval()
{
  uint64 x;
  asm volatile("csrr %0, stval" : "=r" (x) );
  return x;
}


static inline void
w_mcounteren(uint64 x)
{
  asm volatile("csrw mcounteren, %0" : : "r" (x));
}

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
  return x;
}


static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
  return x;
}


static inline void
intr_on()
{
  w_sstatus(r_sstatus() | (1L << 1));
}


static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~(1L << 1));
}


static inline int
intr_get()
{
  uint64 x = r_sstatus();
  return (x & (1L << 1)) != 0;
}

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
  return x;
}



static inline uint64
r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
  return x;
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
}

static inline uint64
r_ra()
{
  uint64 x;
  asm volatile("mv %0, ra" : "=r" (x) );
  return x;
}


static inline void
sfence_vma()
{

  asm volatile("sfence.vma zero, zero");
}
# 365 "kernel/riscv.h"
typedef uint64 pte_t;
typedef uint64 *pagetable_t;
# 6 "kernel/vm.c" 2
# 1 "kernel/defs.h" 1
struct buf;
struct context;
struct file;
struct inode;
struct pipe;
struct proc;
struct spinlock;
struct sleeplock;
struct stat;
struct superblock;


void binit(void);
struct buf* bread(uint, uint);
void brelse(struct buf*);
void bwrite(struct buf*);
void bpin(struct buf*);
void bunpin(struct buf*);


void consoleinit(void);
void consoleintr(int);
void consputc(int);


int exec(char*, char**);


struct file* filealloc(void);
void fileclose(struct file*);
struct file* filedup(struct file*);
void fileinit(void);
int fileread(struct file*, uint64, int n);
int filestat(struct file*, uint64 addr);
int filewrite(struct file*, uint64, int n);


void fsinit(int);
int dirlink(struct inode*, char*, uint);
struct inode* dirlookup(struct inode*, char*, uint*);
struct inode* ialloc(uint, short);
struct inode* idup(struct inode*);
void iinit();
void ilock(struct inode*);
void iput(struct inode*);
void iunlock(struct inode*);
void iunlockput(struct inode*);
void iupdate(struct inode*);
int namecmp(const char*, const char*);
struct inode* namei(char*);
struct inode* nameiparent(char*, char*);
int readi(struct inode*, int, uint64, uint, uint);
void stati(struct inode*, struct stat*);
int writei(struct inode*, int, uint64, uint, uint);
void itrunc(struct inode*);


void ramdiskinit(void);
void ramdiskintr(void);
void ramdiskrw(struct buf*);


void* kalloc(void);
void kfree(void *);
void kinit(void);
uint64 freemem(void);


void initlog(int, struct superblock*);
void log_write(struct buf*);
void begin_op(void);
void end_op(void);


int pipealloc(struct file**, struct file**);
void pipeclose(struct pipe*, int);
int piperead(struct pipe*, uint64, int);
int pipewrite(struct pipe*, uint64, int);


void printf(char*, ...);
void panic(char*) __attribute__((noreturn));
void printfinit(void);


int cpuid(void);
void exit(int);
int fork(void);
int growproc(int);
void proc_mapstacks(pagetable_t);
pagetable_t proc_pagetable(struct proc *);
void proc_freepagetable(pagetable_t, uint64);
int kill(int);
struct cpu* mycpu(void);
struct cpu* getmycpu(void);
struct proc* myproc();
void procinit(void);
void scheduler(void) __attribute__((noreturn));
void sched(void);
void sleep(void*, struct spinlock*);
void userinit(void);
int wait(uint64);
void wakeup(void*);
void yield(void);
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len);
int either_copyin(void *dst, int user_src, uint64 src, uint64 len);
void procdump(void);
int unused_proc(void);


void swtch(struct context*, struct context*);


void acquire(struct spinlock*);
int holding(struct spinlock*);
void initlock(struct spinlock*, char*);
void release(struct spinlock*);
void push_off(void);
void pop_off(void);


void acquiresleep(struct sleeplock*);
void releasesleep(struct sleeplock*);
int holdingsleep(struct sleeplock*);
void initsleeplock(struct sleeplock*, char*);


int memcmp(const void*, const void*, uint);
void* memmove(void*, const void*, uint);
void* memset(void*, int, uint);
char* safestrcpy(char*, const char*, int);
int strlen(const char*);
int strncmp(const char*, const char*, uint);
char* strncpy(char*, const char*, int);


int argint(int, int*);
int argstr(int, char*, int);
int argaddr(int, uint64 *);
int fetchstr(uint64, char*, int);
int fetchaddr(uint64, uint64*);
void syscall();


extern uint ticks;
void trapinit(void);
void trapinithart(void);
extern struct spinlock tickslock;
void usertrapret(void);


void uartinit(void);
void uartintr(void);
void uartputc(int);
void uartputc_sync(int);
int uartgetc(void);


void kvminit(void);
void kvminithart(void);
void kvmmap(pagetable_t, uint64, uint64, uint64, int);
int mappages(pagetable_t, uint64, uint64, uint64, int);
pagetable_t uvmcreate(void);
void uvminit(pagetable_t, uchar *, uint);
uint64 uvmalloc(pagetable_t, uint64, uint64);
uint64 uvmdealloc(pagetable_t, uint64, uint64);
int uvmcopy(pagetable_t, pagetable_t, uint64);
void uvmfree(pagetable_t, uint64);
void uvmunmap(pagetable_t, uint64, uint64, int);
void uvmclear(pagetable_t, uint64);
uint64 walkaddr(pagetable_t, uint64);
int copyout(pagetable_t, uint64, char *, uint64);
int copyin(pagetable_t, char *, uint64, uint64);
int copyinstr(pagetable_t, char *, uint64, uint64);


void plicinit(void);
void plicinithart(void);
int plic_claim(void);
void plic_complete(int);


void virtio_disk_init(void);
void virtio_disk_rw(struct buf *, int);
void virtio_disk_intr(void);
# 7 "kernel/vm.c" 2
# 1 "kernel/fs.h" 1
# 14 "kernel/fs.h"
struct superblock {
  uint magic;
  uint size;
  uint nblocks;
  uint ninodes;
  uint nlog;
  uint logstart;
  uint inodestart;
  uint bmapstart;
};
# 32 "kernel/fs.h"
struct dinode {
  short type;
  short major;
  short minor;
  short nlink;
  uint size;
  uint addrs[12 +1];
};
# 56 "kernel/fs.h"
struct dirent {
  ushort inum;
  char name[14];
};
# 8 "kernel/vm.c" 2




pagetable_t kernel_pagetable;

extern char etext[];

extern char trampoline[];


pagetable_t
kvmmake(void)
{
  pagetable_t kpgtbl;

  kpgtbl = (pagetable_t) kalloc();
  memset(kpgtbl, 0, 4096);


  kvmmap(kpgtbl, 0x10000000L, 0x10000000L, 4096, (1L << 1) | (1L << 2));


  kvmmap(kpgtbl, 0x10001000, 0x10001000, 4096, (1L << 1) | (1L << 2));


  kvmmap(kpgtbl, 0x0c000000L, 0x0c000000L, 0x400000, (1L << 1) | (1L << 2));


  kvmmap(kpgtbl, 0x80000000L, 0x80000000L, (uint64)etext-0x80000000L, (1L << 1) | (1L << 3));


  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, (0x80000000L + 128*1024*1024)-(uint64)etext, (1L << 1) | (1L << 2));



  kvmmap(kpgtbl, ((1L << (9 + 9 + 9 + 12 - 1)) - 4096), (uint64)trampoline, 4096, (1L << 1) | (1L << 3));


  proc_mapstacks(kpgtbl);

  return kpgtbl;
}


void
kvminit(void)
{
  kernel_pagetable = kvmmake();
}



void
kvminithart()
{
  w_satp(((8L << 60) | (((uint64)kernel_pagetable) >> 12)));
  sfence_vma();
}
# 80 "kernel/vm.c"
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
  if(va >= (1L << (9 + 9 + 9 + 12 - 1)))
    panic("walk");

  for(int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[((((uint64) (va)) >> (12 +(9*(level)))) & 0x1FF)];
    if(*pte & (1L << 0)) {
      pagetable = (pagetable_t)(((*pte) >> 10) << 12);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
        return 0;
      memset(pagetable, 0, 4096);
      *pte = ((((uint64)pagetable) >> 12) << 10) | (1L << 0);
    }
  }
  return &pagetable[((((uint64) (va)) >> (12 +(9*(0)))) & 0x1FF)];
}




uint64
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= (1L << (9 + 9 + 9 + 12 - 1)))
    return 0;

  pte = walk(pagetable, va, 0);
  if(pte == 0)
    return 0;
  if((*pte & (1L << 0)) == 0)
    return 0;
  if((*pte & (1L << 4)) == 0)
    return 0;
  pa = (((*pte) >> 10) << 12);
  return pa;
}




void
kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm)
{
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    panic("kvmmap");
}





int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    panic("mappages: size");

  a = (((va)) & ~(4096 -1));
  last = (((va + size - 1)) & ~(4096 -1));
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
      return -1;
    if(*pte & (1L << 0))
      panic("mappages: remap");
    *pte = ((((uint64)pa) >> 12) << 10) | perm | (1L << 0);
    if(a == last)
      break;
    a += 4096;
    pa += 4096;
  }
  return 0;
}




void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
  uint64 a;
  pte_t *pte;

  if((va % 4096) != 0)
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*4096; a += 4096){
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & (1L << 0)) == 0)
      panic("uvmunmap: not mapped");
    if(((*pte) & 0x3FF) == (1L << 0))
      panic("uvmunmap: not a leaf");
    if(do_free){
      uint64 pa = (((*pte) >> 10) << 12);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}



pagetable_t
uvmcreate()
{
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
  if(pagetable == 0)
    return 0;
  memset(pagetable, 0, 4096);
  return pagetable;
}




void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
  char *mem;

  if(sz >= 4096)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, 4096);
  mappages(pagetable, 0, 4096, (uint64)mem, (1L << 2)|(1L << 1)|(1L << 3)|(1L << 4));
  memmove(mem, src, sz);
}



uint64
uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  char *mem;
  uint64 a;

  if(newsz < oldsz)
    return oldsz;

  oldsz = (((oldsz)+4096 -1) & ~(4096 -1));
  for(a = oldsz; a < newsz; a += 4096){
    mem = kalloc();
    if(mem == 0){
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
    memset(mem, 0, 4096);
    if(mappages(pagetable, a, 4096, (uint64)mem, (1L << 2)|(1L << 3)|(1L << 1)|(1L << 4)) != 0){
      kfree(mem);
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
  }
  return newsz;
}





uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  if(newsz >= oldsz)
    return oldsz;

  if((((newsz)+4096 -1) & ~(4096 -1)) < (((oldsz)+4096 -1) & ~(4096 -1))){
    int npages = ((((oldsz)+4096 -1) & ~(4096 -1)) - (((newsz)+4096 -1) & ~(4096 -1))) / 4096;
    uvmunmap(pagetable, (((newsz)+4096 -1) & ~(4096 -1)), npages, 1);
  }

  return newsz;
}



void
freewalk(pagetable_t pagetable)
{

  for(int i = 0; i < 512; i++){
    pte_t pte = pagetable[i];
    if((pte & (1L << 0)) && (pte & ((1L << 1)|(1L << 2)|(1L << 3))) == 0){

      uint64 child = (((pte) >> 10) << 12);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & (1L << 0)){
      panic("freewalk: leaf");
    }
  }
  kfree((void*)pagetable);
}



void
uvmfree(pagetable_t pagetable, uint64 sz)
{
  if(sz > 0)
    uvmunmap(pagetable, 0, (((sz)+4096 -1) & ~(4096 -1))/4096, 1);
  freewalk(pagetable);
}







int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += 4096){
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    if((*pte & (1L << 0)) == 0)
      panic("uvmcopy: page not present");
    pa = (((*pte) >> 10) << 12);
    flags = ((*pte) & 0x3FF);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, 4096);
    if(mappages(new, i, 4096, (uint64)mem, flags) != 0){
      kfree(mem);
      goto err;
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / 4096, 1);
  return -1;
}



void
uvmclear(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;

  pte = walk(pagetable, va, 0);
  if(pte == 0)
    panic("uvmclear");
  *pte &= ~(1L << 4);
}




int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    va0 = (((dstva)) & ~(4096 -1));
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = 4096 - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);

    len -= n;
    src += n;
    dstva = va0 + 4096;
  }
  return 0;
}




int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    va0 = (((srcva)) & ~(4096 -1));
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = 4096 - (srcva - va0);
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);

    len -= n;
    dst += n;
    srcva = va0 + 4096;
  }
  return 0;
}





int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = (((srcva)) & ~(4096 -1));
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = 4096 - (srcva - va0);
    if(n > max)
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
        got_null = 1;
        break;
      } else {
        *dst = *p;
      }
      --n;
      --max;
      p++;
      dst++;
    }

    srcva = va0 + 4096;
  }
  if(got_null){
    return 0;
  } else {
    return -1;
  }
}
