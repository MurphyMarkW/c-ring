#include <ring.h>

static struct ring * init(size_t size) {
    // Ringifies a buffer.
    struct ring * ring = (struct ring *)malloc(sizeof(struct ring));
        ring->head = 0;
        ring->tail = 0;
        
        *(size_t *)&ring->size = size;
        
        ring->loop = false;
        
        pthread_mutex_init(&(ring->lock), NULL);

    return ring;
}

static size_t head(struct ring * ring) {
    pthread_mutex_lock(&(ring->lock));
    if(ring->head == ring->size && ! ring->loop) {
        ring->head = 0;
        ring->loop = true;
    }
    size_t head = ring->head;
    pthread_mutex_unlock(&(ring->lock));
    return head;
}

static size_t tail(struct ring * ring) {
    pthread_mutex_lock(&(ring->lock));
    if(ring->tail == ring->size && ring->loop) {
        ring->tail = 0;
        ring->loop = false;
    }
    size_t tail = ring->tail;
    pthread_mutex_unlock(&(ring->lock));
    return tail;
}

static size_t hsize(struct ring * ring) {
    pthread_mutex_lock(&(ring->lock));
    size_t size = (ring->loop ? ring->tail : ring->size) - ring->head;
    pthread_mutex_unlock(&(ring->lock));
    return size;
}

static size_t tsize(struct ring * ring) {
    pthread_mutex_lock(&(ring->lock));
    size_t size = (ring->loop ? ring->size : ring->head) - ring->tail;
    pthread_mutex_unlock(&(ring->lock));
    return size;
}

static void hmove(struct ring * ring, size_t len) {
    pthread_mutex_lock(&(ring->lock));
    ring->head += len;
    pthread_mutex_unlock(&(ring->lock));
    return;
}

static void tmove(struct ring * ring, size_t len) {
    pthread_mutex_lock(&(ring->lock));
    ring->tail += len;
    pthread_mutex_unlock(&(ring->lock));
    return;
}

ring_namespace const ring = {
    init,
    head,
    tail,
    hsize,
    tsize,
    hmove,
    tmove,
};
