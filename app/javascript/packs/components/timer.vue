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
    }
  },
  computed: {
    remainingMin: function() {
      return Math.floor(this.remainingTime / 60)
    },
    remainingSec: function() {
      return this.remainingTime % 60
    }
  }
}
</script>
