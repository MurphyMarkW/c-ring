#ifndef __C_RING_H__
#define __C_RING_H__


#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <pthread.h>


struct ring {
    size_t head;
    size_t tail;
    const size_t size;

    bool loop;

    pthread_mutex_t lock;
};


typedef struct {

    struct ring * (* const init)(size_t size);

    size_t (* const head)(struct ring * ring);
    size_t (* const tail)(struct ring * ring);

    size_t (* const hsize)(struct ring * ring);
    size_t (* const tsize)(struct ring * ring);

    void (* const hmove)(struct ring * ring, size_t len);
    void (* const tmove)(struct ring * ring, size_t len);

} ring_namespace;
extern ring_namespace const ring;


#endif//__C_RING_H__
