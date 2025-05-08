<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { motion } from 'motion-v';



// Get the actual course
const route = useRoute();
const courseId = route.params.course_id;
const course = ref(null); // Variable to store the course data

// Get the course data
function getCourse(courseId) {
    fetch(`http://localhost:8000/api/courses/${courseId}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => course.value = data)
        .catch(error => console.log('Error:', error));
}

onMounted(() => {
    getCourse(courseId); // Call the function to get the course data
});
</script>
<template>
    <main class="container mt-5" v-if="course">
        <div class="row">
            <div class="col-md-12">
                <h1 class="text-center">{{ course.title }}</h1>
                <p class="text-center">{{ course.description }}</p>
                <img :src="course.image" alt="Course Image" class="img-fluid mx-auto d-block">
                <p class="text-center">Price: {{ course.price }}€</p>
                <p class="text-center">Duration: {{ course.duration }} hours</p>
            </div>
        </div>
    </main>
        <div class="container" v-else>
            <motion.div class="spinner" :animate="{ rotate: 360 }" :transition="{
                duration: 1.5,
                repeat: Infinity,
                ease: 'linear',
            }" />
        </div>
</template>
<style scoped>
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 40px;
  border-radius: 8px;
}

.spinner {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  border: 4px solid var(--divider);
  border-top-color: #ff0088;
  will-change: transform;
}
</style>