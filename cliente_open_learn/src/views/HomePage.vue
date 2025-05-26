<script setup>
import { motion } from 'motion-v';
import { ref, watch, onMounted } from 'vue';
import { Toast } from 'bootstrap';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
  userAuth: {
    type: String,
    required: false // Optional
  }
});

// Variable to contain the logged-in user
const loguedUser = ref(null);

// We get the data of the user logged
async function getUser(token) {
  if (!token) {
    loguedUser.value = null; // If there is no token, there is no logged user
    return;
  }

  try {
    const response = await fetch('http://localhost:8000/api/user', {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json',
      },
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.message || 'Error fetching user data');
    }

    const data = await response.json();
    loguedUser.value = data; // Update the logged user with the data received

    // We get the courses of the logged user
    getCoursesFromUser(loguedUser.value.id); // Call getCourses with the user id
  } catch (error) {
    loguedUser.value = null; // If there is an error, set the logged user to null
  }
}

// Get the list of all courses;
const allCourses = ref([]); // Variable to store all courses

function getAllCourses() {
  fetch('http://localhost:8000/api/courses', {
    method: 'GET',
  }).then(response => response.json())
    .then(data => {
      allCourses.value = data
    })
    .catch(error => console.log('Error:', error));
}

// Call getUser when the token changes 
watch(
  () => props.userAuth,
  (newToken) => {
    getUser(newToken); // Call getUser every time the token changes
  },
  { immediate: true } // Ejecuta inmediatamente al montar el componente
);

// Get the courses of the logged user
const userCourses = ref([]); // Variable to store the courses of the logged user

function getCoursesFromUser(user_id) {
  fetch(`http://localhost:8000/api/inscriptions/user/${user_id}`, {
    method: 'GET',
  }).then(response => response.json())
    .then(data => {
      userCourses.value = data
      // Get the information from that courses
      const coursesIdsFromUser = userCourses.value.map(course => course.course_id); // Get the ids of the courses
      // Now filter the courses with that ids
      userCourses.value = allCourses.value.filter(course => coursesIdsFromUser.includes(course.id)); // Filter the courses
    })
    .catch(error => console.log('Error:', error));

}
getAllCourses(); // Call getAllCourses when the component is mounted
onMounted(() => {
  const toastEl = document.querySelector('.toast');
  if (toastEl) {
    const bsToast = new Toast(toastEl);
    bsToast.show(); // Esto no es obligatorio si ya tienes `.show` en el HTML, pero es útil si quieres controlarlo por JS
  }
});
</script>

<template>
  <div v-if="loguedUser">
    <h2 class="mt-5">Hey {{ loguedUser.name }}, are you ready to keep learning?</h2>
    <main class="container border p-3 mb-5 bg-body rounded h-100">
      <!-- Carrousel with the user's courses -->
      <div v-if="userCourses.length > 0" id="carouselExampleAutoplaying" class="carousel slide " data-bs-ride="carousel"
        data-bs-interval="2000">
        <div class="carousel-inner w-100 overflow-hidden">
          <div class="carousel-item active">
            <div class="h-100 d-flex flex-column justify-content-center align-items-center">
              <!-- Default card  -->
              <div class="card mb-3 border-0">
                <div class="row g-0">
                  <div class="col-md-8">
                    <div class="card-body">
                      <h5 class="card-title">Keep learning in OpenLearn!</h5>
                      <p class="card-text">You have a lot of things to learn yet, keep it up!</p>
                    </div>
                  </div>
                  <div class="col-md-4">
                    <motion.img src="/home_page.png" class="img-fluid rounded-start w-100" alt="Keep it up!"
                      :whileHover="{ scale: 1.05 }" :transition="{ duration: 0.5 }" />
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="carousel-item w-100" v-for="(course, index) in userCourses" :key="index">
            <!-- Card with course information -->
            <div class="card mb-3 border-0">
              <div class="row g-0">
                <div class="col-md-8">
                  <div class="card-body">
                    <h5 class="card-title">{{ course.title }}</h5>
                    <p class="card-text">{{ course.description }}</p>
                    <p class="card-text"><small class="text-body-secondary">Duracion: {{ course.duration }}</small></p>
                  </div>
                </div>
                <div class="col-md-4">
                  <motion.img :src="course.image" class="img-fluid rounded-start w-100" alt="Course Image"
                    :whileHover="{ scale: 1.05 }" :transition="{ duration: 0.5 }" />
                </div>
              </div>
            </div>

          </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleAutoplaying"
          data-bs-slide="prev">
          <span class="carousel-control-prev-icon" aria-hidden="true"></span>
          <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleAutoplaying"
          data-bs-slide="next">
          <span class="carousel-control-next-icon" aria-hidden="true"></span>
          <span class="visually-hidden">Next</span>
        </button>
      </div>

      <div v-else>
        <h4>You haven't started any course yet.</h4>
        <p>Explore our wide catalog and learn about every topic you want!</p>
      </div>
    </main>
  </div>

  <div v-else>
    <h2 class="mt-5">Log in to enjoy all the content from OpenLearn!</h2>
  </div>

  
</template>

<style scoped>
.card {
  overflow: hidden;
  height: 20em;
}

</style>