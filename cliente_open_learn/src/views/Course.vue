<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { motion } from 'motion-v';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

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
    <div class="w-75 text-start ms-1 mt-2">
        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="mt-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <RouterLink to="/" class="text-decoration-none">Home</RouterLink>
                </li>
                <li class="breadcrumb-item">
                    <RouterLink to="/catalog" class="text-decoration-none text-">Catalog</RouterLink>
                </li>
                <li class="breadcrumb-item active" aria-current="page">{{ course?.title }}</li>
            </ol>
        </nav>
    </div>
    <main
        class="container d-flex flex-column flex-md-row justify-content-between align-items-start mt-2 shadow-lg p-4 rounded text-black">
        <!-- Sección principal -->
        <div v-if="course" class="content w-75 w-md-75">
            <!-- Imagen de fondo con título -->
            <div class="banner h-auto d-flex flex-column align-items-center justify-content-center text-white rounded"
                :style="{
                    backgroundImage: `linear-gradient(to right, rgba(0, 0, 0, 1), rgba(0, 0, 0, 0.0)), url(${course.image})`,
                    backgroundSize: 'cover',
                    backgroundPosition: 'center',
                    backgroundRepeat: 'no-repeat',
                    minHeight: '20em'
                }">
                <h1 class="courseTittle p-3 rounded-5 text-shadow text-center">{{ course.title }}</h1>
            </div>

            <!-- Description -->
            <p class="mt-2 fs-6">
                <strong class="fs-5 text-muted">Description:</strong> {{ course?.description }}
            </p>
            <p class="mt-4 fs-6">
                <strong class="fs-5 text-muted">Duration:</strong> {{ course?.duration }}
            </p>
        </div>

        <!-- Barra lateral (aside) -->
        <aside v-if="course" class="sidebar p-4 shadow rounded w-45 w-md-35 h-auto d-flex flex-column">
            <h4 class="">Additional information:</h4>
            <ul class="list-unstyled">
                <li class="mb-3 fs-6 text-muted"><strong>Active students:</strong> {{ course?.max_students }}</li>
                <li class="mb-3 fs-6 text-muted"><strong>Need information?</strong> Contact us!</li>
            </ul>
        </aside>

        <!-- Mensaje de carga mientras se obtienen los datos -->
        <div v-else class="text-center w-100">
            <img src="/noData.png" class="w-25" alt="no data">
            <p class="fs-3">This course doesn't exist yet.</p>
            <p>But you can enjoy many other courses</p>
            <RouterLink to="/catalog" class="btn">Go to catalog</RouterLink>
        </div>
    </main>
</template>
<style scoped>
p {
    margin-block: 1lh;
}

.courseTittle {
    color: white;
    backdrop-filter: blur(8px);
}
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

.btn {
    background-color: #FCDB77;
}

.btn:hover {
    background-color: #ffe8a2;
}
</style>