<template>
  <div
    class="paddle"
    :class="position"
    v-bind:style="{ bottom: y + 'px' }">
  </div>
</template>

<script>
export default {
  name: 'paddle',
  props: {
    position: String
  },
  data () {
    return {
      y: 200
    }
  }
}
</script>

<style scoped>
  .paddle {
    background-color: #fff;
    position: absolute;
    width: 15px;
    height: 80px;
  }

  .paddle.left {
    margin-left: 30px;
  }

  .paddle.right {
    margin-right: 30px;
    right: 0;
  }
</style>
