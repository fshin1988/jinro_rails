<template>
  <i class="fa fa-exchange fa-switch pull-left" v-on:click="emitSwitch"></i>
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
