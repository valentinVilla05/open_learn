<script setup>
import { ref, onMounted, computed } from 'vue';
import { motion } from 'motion-v';

// Get the list of courses
const allCourses = ref([]);
const searchFilter = ref('');


function getAllCourses() {
    fetch('http://localhost:8000/api/courses', {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            allCourses.value = data
            // Filter the public courses
            allCourses.value = allCourses.value.filter(course => course.privacy === 'public');
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

    } catch (error) {
        console.error('Error fetching user:', error.message);
        loguedUser.value = null; // If there is an error, set the logged user to null
    }
}
getUser(props.userAuth); // Call the function to get the user

const filteredCourses = computed(() => {
    return allCourses.value.filter(course => 
        course.title.toLowerCase().includes(searchFilter.value.toLowerCase())
    )
})

////////////////////////////////
////// Course pagination ///////
////////////////////////////////

let currentPage = ref(1);
let coursesPerPage = 9;
let totalPages = computed(() => Math.ceil(filteredCourses.value.length / coursesPerPage));

let paginatedCourses = computed(() => {
    const start = (currentPage.value - 1) * coursesPerPage;
    const end = start + coursesPerPage;
    return filteredCourses.value.slice(start, end);
})

function nextPage() {
    if (currentPage.value < Math.ceil(filteredCourses.value.length / coursesPerPage)) {
        currentPage.value++;
    }
}
function previousPage() {
    if (currentPage.value > 1) {
        currentPage.value--;
    }
}

</script>

<template>
    <div class="container mt-5">
        <div class="d-flex justify-content-between">
            <h2>Choose what to learn:</h2>
            <div class="input-group mt-3 position-relative w-25">
                <p></p>
                <input type="text" v-model="searchFilter" placeholder="Search your interest" name="coursesFiltered" class="form-control w-75 rounded border-black">
                <button class="input-group-text"><img src="/lens.png" alt="len" style="height: 2em; width: 2em;"> </button>
            </div>
        </div>
        <hr class="w-100">
        <main class="row row-cols-1 row-cols-md-3 g-4">
            <div class="col" v-for="course in paginatedCourses" :key="course.id">
                <div class="card h-100 d-flex flex-column">
                    <img :src="course.image" class="card-img-top" alt="Course image">
                    <div class="card-body d-flex flex-column">
                        <div class="mb-2">
                            <h5 class="card-title fw-bold">{{ course.title }}</h5>
                            <p class="card-text">{{ course.description }}</p>
                            <p class="card-text">
                                <small class="text-body-secondary">Duration: {{ course.duration }}</small>
                            </p>
                        </div>
                        <!-- Push this div to the bottom of the card body -->
                        <div class="d-flex justify-content-center align-items-center mt-auto">
                            <motion.button class="goCourseButton" :whileHover="{ scale: 1.05 }"
                                :transition="{ duration: 0.5 }">
                                <RouterLink class="text-decoration-none text-white" v-if="loguedUser"
                                    :to="{ name: 'course', params: { course_id: course.id } }">Learn about this!
                                </RouterLink>
                                <RouterLink class="text-decoration-none text-white" v-else to="/login">Login to learn
                                    about this</RouterLink>
                            </motion.button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <div v-if="filteredCourses.length === 0">
            <img src="/noData.png" alt="no data" class="img-fluid mx-auto d-block mt-5" style="max-width: 50%;">
            <p class="text-center">No courses available at the moment.</p>
        </div>
        <nav aria-label="Paginación de usuarios" class="m-3" v-if="allCourses.length !== 0">
            <ul class="pagination justify-content-center">
                <li class="page-item" :class="{ disabled: currentPage === 1 }">
                    <a class="page-link" href="#" @click.prevent="previousPage">Previous</a>
                </li>
                <li class="page-item" v-for="page in totalPages" :key="page" :class="{ active: currentPage === page }">
                    <a class="page-link" href="#" @click.prevent="currentPage = page">{{ page }}</a>
                </li>
                <li class="page-item" :class="{ disabled: currentPage === totalPages }">
                    <a class="page-link" href="#" @click.prevent="nextPage">Next</a>
                </li>
            </ul>
        </nav>
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
    padding: 1em 1em;
    border-radius: 5px;
}

p {
    margin-block: 1lh;
}
</style>