<template>
  <div class="alert alert-info">
    <p v-for="info in infoMessages">
      {{info}}
    </p>
  </div>
</template>

<script>
export default {
  props: ['infoMessages']
}
</script>
