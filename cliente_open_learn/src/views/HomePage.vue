<script setup>
import { ref, watch, onMounted } from 'vue';

const props = defineProps({
  userAuth: {
    type: String,
    required: false,
  },
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
    console.error('Error fetching user:', error.message);
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
      console.log('All courses:', allCourses.value); // Log all courses
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
      console.log('Courses:', userCourses.value); // Log the courses of the logged user
      // Get the information from that courses
      const coursesIdsFromUser = userCourses.value.map(course => course.course_id); // Get the ids of the courses
      console.log('Courses ids:', coursesIdsFromUser); // Log the ids of the courses
      // Now filter the courses with that ids
      userCourses.value = allCourses.value.filter(course => coursesIdsFromUser.includes(course.id)); // Filter the courses
      console.log('Filtered courses:', userCourses.value); // Log the filtered courses
    })
    .catch(error => console.log('Error:', error));

}
getAllCourses(); // Call getAllCourses when the component is mounted
</script>

<template>
  <main>
    <h2 v-if="loguedUser">Welcome back {{ loguedUser.name }}!</h2>
    <h2 v-else>Log in to enjoy all the content from OpenLearn!</h2>
  </main>
</template>

<style scoped></style>