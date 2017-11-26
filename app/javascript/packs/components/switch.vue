<template>
  <button v-on:click="emitSwitch">切り替え</button>
</template>

<script>
export default {
  methods: {
    emitSwitch: function() {
      this.$emit('switch')
    }
  }
}
</script>
