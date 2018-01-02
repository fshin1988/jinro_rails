<template>
  <span id="timer">
    <i class="fa fa-hourglass-2 hourglass-with-timer"></i>
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
      if(this.timerId == 0) {
        this.startTimer()
      }
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
      } else {
        this.remainingTime = this.remainingTime - 1
      }
    }
  }
}
</script>
