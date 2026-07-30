const InfiniteScroll = {
    mounted() {
        this.loading = false
        this.observer = new IntersectionObserver(([entry]) => {
            if (entry.isIntersecting && !this.loading) {
                this.loading = true
                this.pushEvent("load-more", {})
            }
        })

        this.observer.observe(this.el)
    },

    updated() {
        this.loading = false
    },

    destroyed() {
        this.observer.disconnect()
    }
}

export default InfiniteScroll;