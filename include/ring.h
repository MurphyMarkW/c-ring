#ifndef __C_RING_H__
#define __C_RING_H__


#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <pthread.h>


struct ring {
    size_t size;
    size_t head;
    size_t tail;

    bool loop;

    pthread_mutex_t lock;
};


typedef struct {

    struct ring * (* const init)(size_t size);

    size_t (* const head)(struct ring * ring);
    size_t (* const tail)(struct ring * ring);

    size_t (* const open)(struct ring * ring);
    size_t (* const used)(struct ring * ring);

} ring_namespace;
extern ring_namespace const ring;


#endif//__C_RING_H__
