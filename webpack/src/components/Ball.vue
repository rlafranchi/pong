<template>
  <div
    class="ball"
    v-bind:style="{ bottom: y + 'px', left: x + 'px' }">
  </div>
</template>

<script>
export default {
  name: 'ball',
  data () {
    return {
      x: 500,
      y: 400
    }
  }
}
</script>

<style scoped>
.ball {
  background-color: #fff;
  position: absolute;
  width: 15px;
  height: 15px;
}
</style>
