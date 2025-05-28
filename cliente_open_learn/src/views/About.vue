<script setup>
import { ref } from 'vue';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
  userAuth: {
    type: String,
    required: false // Optional
  }
});

</script>

<template>
   
</template>

<style scoped>

</style>
