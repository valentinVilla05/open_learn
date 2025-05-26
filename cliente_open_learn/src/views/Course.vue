<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { userAuth } from '@/utils/userAuth';
import { motion } from 'motion-v';
import Swal from 'sweetalert2';
import CoursesResources from '@/components/CoursesResources.vue';
import CoursesExam from '@/components/CoursesExam.vue';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

const loguedUser = ref(null);

// Get the actual course
const route = useRoute();
const courseId = route.params.course_id;
const course = ref(null); // Variable to store the course data
const userCoursesList = ref([]);
const isEnrrolled = ref(false);
const capacityCompleted = ref(false);
const teacherList = ref([]) // Get all the teachers
const teacherName = ref(null);
const teacherAssigned = ref(null);

const newInscription = ref({
    user_id: '',
    course_id: ''
})

// Get the course data
function getCourse(courseId) {
    return fetch(`http://localhost:8000/api/courses/${courseId}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => course.value = data)
        .catch(error => console.log('Error:', error));
}

function getInscriptions(user_id) {
    return fetch(`http://localhost:8000/api/inscriptions/user/${user_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => userCoursesList.value = data)
        .catch(error => console.log('Error:', error));
}

async function getTeacher() {
    return fetch('http://localhost:8000/api/users', {
        method: 'GET',
    })
        .then(response => response.json())
        .then(data => {
            teacherList.value = data.filter(teacher => teacher.rol === 'teacher'); // Filter the users by rol == teacher
        })
        .catch(error => console.log('Error:', error));
}

async function checkCapacity(course_id) {
    const usersEnrolled = ref(null);

    await fetch(`http://localhost:8000/api/inscriptions/course/${course_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            usersEnrolled.value = data;
            if ((usersEnrolled.value).length + 1 <= course.value.max_students) {
                capacityCompleted.value = false;
            } else capacityCompleted.value = true;
        }
        )
        .catch(error => console.log('Error:', error));
}

// Create an inscription
function enrrollUser(course_id, user_id) {
    // Check if the capacity is now completed
    if (!capacityCompleted.value) {
        newInscription.value.user_id = user_id;
        newInscription.value.course_id = course_id;

        fetch('http://localhost:8000/api/inscriptions', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${props.userAuth}`,
                'Accept': 'application/json',
            },
            body: JSON.stringify(newInscription.value)
        })
            .then(response => response.json())
            .then(data => {
                isEnrrolled.value = true;
                Swal.fire({
                    title: "Inscription registered!",
                    text: "Enjoy with all the content!",
                    icon: "success"
                });
            })
            .catch(error => console.error('Error:', error));
    } else console.log("WUAAAAAAAAAAAAAAAA")
}


onMounted(async () => {
    await getTeacher()
    const user = await userAuth(props.userAuth);
    if (user) {
        loguedUser.value = user;
        await getInscriptions(user.id); // Wait for inscription
    }
    await getCourse(courseId); // Wait for course

    if (loguedUser.value && course.value) {
        isEnrrolled.value = userCoursesList.value.some(
            inscription => inscription.course_id == course.value.id
        );
    }
    teacherName.value = teacherList.value.find(teacher => String(teacher.id) === String(course.value.teacher_id));
    teacherAssigned.value = String(course.value.teacher_id) === String(loguedUser.value.id);
    checkCapacity(courseId)

});

</script>
<template>
    <div class="w-75 text-start ms-1 mt-2">
        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="mt-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <RouterLink to="/catalog" class="text-decoration-none text-">Catalog</RouterLink>
                </li>
                <li class="breadcrumb-item active" aria-current="page">{{ course?.title }}</li>
            </ol>
        </nav>
    </div>
    <main
        class="container d-flex flex-column flex-md-row justify-content-between align-items-start mt-2 shadow-lg p-4 rounded text-black">
        <!-- Main Section -->
        <div v-if="course" class="content w-75 w-md-75">
            <!-- Image with background title -->
            <div class="banner h-auto d-flex flex-column align-items-center justify-content-center text-white rounded"
                :style="{
                    backgroundImage: `linear-gradient(to right, rgba(0, 0, 0, 1), rgba(0, 0, 0, 0.0)), url(${course.image})`,
                    backgroundSize: 'cover',
                    backgroundPosition: 'center',
                    backgroundRepeat: 'no-repeat',
                    minHeight: '20em'
                }">
                <div class="courseTittle w-100 p-3 rounded-5 text-shadow text-start">
                    <h1>{{ course.title }}</h1>
                    <p class="mt-2 fs-6">
                        {{ course?.description }}
                    </p>
                    <p class="mt-4 fs-6"><img src="/clock.png"></img> <small>{{ course?.duration }}</small></p>
                    <div class="mx-2 d-flex justify-content-between align-content-center">
                        <p v-if="teacherAssigned" class="text-success mt-2">
                            You are assigned to this course.
                        </p>
                        <p v-else-if="isEnrrolled" class="text-success mt-2">
                            You're already enrolled in this course
                        </p>
                        <p v-else-if="capacityCompleted">
                            Sorry, this course is already completed.
                        </p>
                        <button v-else-if="loguedUser && !isEnrrolled" class="enrollButton rounded p-2 border border-0"
                            @click="enrrollUser(course.id, loguedUser.id)">
                            Enroll
                        </button>
                        <RouterLink v-else-if="!loguedUser" to="/login" class="btn">Log in to acces to
                            all the content!</RouterLink>
                    </div>

                </div>
            </div>
            <CoursesResources v-if="isEnrrolled || teacherAssigned" :userAuth="props.userAuth" :course_id="courseId" :teacherAssigned="teacherAssigned">
            </CoursesResources>
            <div v-else>
                <!-- Maybe blur the content or just an image -->
            </div>

        </div>
        <!-- Aside -->
        <aside v-if="course">
            <div class="sidebar p-4 shadow rounded w-45 w-md-35 h-auto d-flex flex-column">
                <h4 class="">Additional information:</h4>
                <ul class="list-unstyled">
                    <li class="mb-3 fs-6 text-muted"><strong>Teacher for this course:</strong> {{ teacherName?.name }}
                    </li>
                    <li class="mb-3 fs-6 text-muted"><strong>Max. students:</strong> {{ course?.max_students }}</li>
                    <li class="mb-3 fs-6 text-muted"><strong>Subject of this course:</strong> {{ course?.subject }}</li>
                    <li class="mb-3 fs-6 text-muted"><strong>Course's privacy:</strong> {{ course?.privacy }}</li>
                    <li class="mb-3 fs-6 text-muted"><strong>Need information?</strong> Contact us!</li>
                </ul>
            </div>
            <CoursesExam :course_id="courseId" :user_id="loguedUser.id" :teacherAssigned="teacherAssigned" v-if="isEnrrolled"></CoursesExam>
        </aside>


        <!-- Message if there is no data -->
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
    margin-block: 1lh
}

.exam {
    background-color: rgb(231, 231, 231);
}

.courseTittle {
    color: white;
    backdrop-filter: blur(8px);
}

.container {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 2.5em;
    border-radius: 8px;
}


.enrollButton {
    background-color: #6EB183;
}
</style>