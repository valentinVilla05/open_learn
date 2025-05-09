<script setup>
import { ref, onMounted } from 'vue';
import { motion } from 'motion-v';

// Get the list of courses
const allCourses = ref([]);

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

getAllCourses(); // Call the function to get all courses

// We need to know if the user is logged in to make de redirections in the courses
const loguedUser = ref(null); // Variable to store the logged-in user
const props = defineProps({
    userAuth: {
        type: String,
        required: false,
    },
});
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
        console.log('Logged user:', loguedUser.value); // Log the logged user

    } catch (error) {
        console.error('Error fetching user:', error.message);
        loguedUser.value = null; // If there is an error, set the logged user to null
    }
}
getUser(props.userAuth); // Call the function to get the user


</script>

<template>
    <div class="container mt-5">
        <!-- Main container with the courses list -->
        <main class="row row-cols-1 row-cols-md-3 g-4">
            <!-- Every course is a card -->
            <div class="col" v-for="course in allCourses" :key="course.id">
                <div class="card h-100">
                    <img :src="course.image" class="card-img-top" alt="Course image">
                    <div class="card-body">
                        <h5 class="card-title">{{ course.title }}</h5>
                        <p class="card-text">{{ course.description }}</p>
                        <p class="card-text"><small class="text-body-secondary">Duración: {{ course.duration }}</small>
                        </p>
                        <motion.button class="goCourseButton" :whileHover="{ scale: 1.05 }" :transition="{ duration: 0.5 }">
                            <RouterLink class="text-decoration-none text-white" v-if="loguedUser" :to="{ name: 'course', params: { course_id: course.id } }">Learn about this!</RouterLink>
                            <RouterLink class="text-decoration-none text-white" v-else to="/login">Login to learn about this</RouterLink>
                        </motion.button>
                    </div>
                </div>
            </div>
        </main>
        <!-- Aside with filters -->
        <aside>
            <!-- Future filters could be added here -->
        </aside>
    </div>
</template>

<style scoped>
.card {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card img {
    height: 15em;
    object-fit: cover;
    object-position: center;
}

.card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}
.goCourseButton {
    background-color: #6EB183;
    color: white;
    border: none;
    padding: 1em 1em ;
    border-radius: 5px;
}
</style>