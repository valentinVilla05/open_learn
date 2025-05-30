<script setup>
import { ref, onMounted } from 'vue';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
  userAuth: {
    type: String,
    required: false // Optional
  }
});

</script>
<template>
  <div class="w-100 parag d-flex justify-content-center align-items-center">
    <div class=" w-25 d-flex justify-content-center align-items-center">
      <img src="/about.png" alt="about" class="w-75 ">
    </div>
    <div class="w-50">
      <h2>About us</h2>
      <p>At OpenLearn, we believe that learning should be accessible, engaging, and built around your
        lifestyle.
        We are an online education platform created for curious minds, professionals, and lifelong learners who want to
        grow their skills from anywhere in the world. Whether you're starting from scratch, switching careers, or simply
        expanding your knowledge, we’re here to support your journey every step of the way.</p>
    </div>
  </div>
  <hr class="w-75">
  <div class="w-100 parag d-flex justify-content-center align-items-center">
    <div class="w-50">
      <h2>What we offer</h2>
      <ul>
        <li>🎓 Expert Instructors – Learn from experienced professionals and industry leaders.</li>
        <li>💡 Practical Learning – Courses designed with real-world applications in mind.</li>
        <li>🌎 Anytime Access – Study at your own pace, from any device.</li>
        <li>🌱 Constant Growth – New content added regularly to keep you up-to-date.</li>
      </ul>
    </div>
    <div class=" w-25 d-flex justify-content-center align-items-center">
      <img src="/teacher_owl.png" alt="about" class="w-75">
    </div>
  </div>
  <hr class="w-75">
  <div class="w-100 parag d-flex justify-content-center align-items-center">
    <div class=" w-25 d-flex justify-content-center align-items-center">
      <img src="/home_page.png" alt="about" class="w-100">
    </div>
    <div class="w-50">
      <h2>Why Learn With Us?</h2>
      <p>Because we care about how you learn, not just what you learn.
We’ve built a platform that prioritizes clarity, interaction, and progress tracking — so you can see how far you’ve come and where you’re headed next.

Join thousands of learners who have already taken the next step toward their goals.
Your journey starts here.</p>
    </div>
  </div>
</template>

<style scoped>
.parag {
  height: 30em;
}
</style>
