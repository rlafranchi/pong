<template>
  <rect :x="position === 'left' ? '30' : '605'" :y="paddle.y" width="15" height="80" fill="white"/>
</template>

<script>
export default {
  name: 'paddle',
  props: {
    position: String,
    paddle: Object
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
