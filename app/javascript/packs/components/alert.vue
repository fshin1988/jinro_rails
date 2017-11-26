<template>
  <div class="alert alert-danger">
    {{alertMessage}}
  </div>
</template>

<script>
export default {
  props: ['alertMessage']
}
</script>
