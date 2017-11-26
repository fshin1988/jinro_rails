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
      remainingTime: this.initialRemainingTime,
      timerId: 0
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
      console.log("start timer")
      console.log("child initialRemainingTime is " + this.initialRemainingTime)
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
