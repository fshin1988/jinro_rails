<template>
  <i class="fa fa-exchange fa-switch" v-on:click="emitSwitch"></i>
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
