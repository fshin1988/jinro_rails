<template>
  <span id="timer">
    <span>{{ remainingMin }}分</span>
    <span>{{ remainingSec }}秒</span>
  </span>
</template>

<script>
export default {
  props: ['initialRemainingTime'],
  data: function() {
    return {
      remainingTime: 0,
      timerId: 0
    }
  },
  watch: {
    initialRemainingTime: function() {
      this.remainingTime = this.initialRemainingTime
      this.startTimer()
    }
  },
  computed: {
    remainingMin: function() {
      return Math.floor(this.remainingTime / 60)
    },
    remainingSec: function() {
      return this.remainingTime % 60
    }
  },
  methods: {
    startTimer: function() {
      this.timerId = setInterval(this.countDown, 1000)
    },
    countDown: function() {
      if(this.remainingTime <= 0) {
        clearInterval(this.timerId)
        this.emitFinish()
      } else {
        this.remainingTime = this.remainingTime - 1
      }
    },
    emitFinish: function() {
      this.$emit('finish')
    },
  }
}
</script>
