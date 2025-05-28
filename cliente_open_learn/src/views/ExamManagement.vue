<script setup>
import { onMounted, ref, computed } from 'vue';
import { userAuth } from '@/utils/userAuth';
import router from '@/router';
import Swal from 'sweetalert2';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

const teacherLogued = ref(null);
const examList = ref([]);
const coursesList = ref([]);

function getCourses() { // We need to filter the courses that teaches the teacher loggued
    fetch('http://localhost:8000/api/courses', {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            coursesList.value = data.filter(course => course.teacher_id == teacherLogued.value.id);
            console.log(coursesList.value);
        })
        .catch(error => console.log('Error:', error));
}

function getExamsTeacher() {
    fetch('http://localhost:8000/api/exams', {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            examList.value = data.filter(exam => coursesList.value.some(course => course.id === exam.course_id));
            console.log(examList.value)
        })
        .catch(error => console.log('Error:', error));
}

function deleteExam(examId) {
    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
        if (result.isConfirmed) {
            fetch(`http://localhost:8000/api/exams/${examId}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${props.userAuth}`,
                    'Accept': 'application/json',
                },
            })
                .then(response => {
                    if (response.ok) {
                        Swal.fire(
                            'Deleted!',
                            'Your exam has been deleted.',
                            'success'
                        );
                        getExamsTeacher(); // Refresh the exam list
                    } else {
                        Swal.fire(
                            'Error!',
                            'There was an error deleting the exam.',
                            'error'
                        );
                    }
                })
        }
    });
}


////////////////////////////////
////// Exam pagination   ///////
////////////////////////////////

let currentPage = ref(1);
let examPerPage = 5;
let totalPages = computed(() => Math.ceil(examList.value.length / examPerPage));

let paginatedExam = computed(() => {
    const start = (currentPage.value - 1) * examPerPage;
    const end = start + examPerPage;
    return examList.value.slice(start, end);
})

function nextPage() {
    if (currentPage.value < Math.ceil(examList.value.length / examPerPage)) {
        currentPage.value++;
    }
}
function previousPage() {
    if (currentPage.value > 1) {
        currentPage.value--;
    }
}

onMounted(async () => {
    const user = await userAuth(props.userAuth);
    if (user) {
        teacherLogued.value = user
        if (teacherLogued.value && teacherLogued.value.rol != 'teacher') {
            Swal.fire({
                icon: "error",
                title: "Oops...",
                text: "You don't have permission to access this page.",
                confirmButtonText: 'Go to home',
            })
            router.push('/'); // Redirect to home page
        }
    } else {
        Swal.fire({
            icon: "error",
            title: "You need to log in to access here.",
            text: "Please log in to continue.",
        });
        router.push('/'); // Redirect to login if user is not logged in
    }

    getCourses()
    getExamsTeacher()
});

</script>
<template>
    <div class="w-75 text-start ms-5">
        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="mt-5">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <RouterLink to="/" class="text-decoration-none">Home</RouterLink>
                </li>
                <li class="breadcrumb-item">
                    <RouterLink to="/controlPanel" class="text-decoration-none text-">Control Panel</RouterLink>
                </li>
                <li class="breadcrumb-item active" aria-current="page">Exam Management</li>
            </ol>
        </nav>
    </div>
    <main class="container rounded shadow p-3 m-4 border">
        <h2 class="w-75 text-start text-muted">Your exams:</h2>
        <div class="card mb-5" v-for="exam in paginatedExam" :key="exam.id">
            <div class="row g-2 w-100">
                <div class="col-12 col-md-9 w-100">
                    <div class="w-100 card-body infoExam">
                        <div>
                            <h2 class="card-title">Exam title: {{ exam.title }}</h2>
                            <h5>Course: {{coursesList.find(course => course.id == exam.course_id)?.title}}</h5>
                        </div>
                        <div class="w-100 btn-group mt-3 d-flex flex-wrap">
                            <RouterLink :to="{ name: 'examCreator', params: { course_id: exam.course_id } }"
                                class="w-50 manageExamButton text-decoration-none text-center text-black" id="editExam">
                                Edit Exam
                            </RouterLink>
                            <button class="w-50 manageExamButton" id="deleteExam" @click="deleteExam(exam.id)">Delete
                                exam</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <nav aria-label="Paginación de usuarios">
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
    </main>
</template>
<style scoped>
.col-12 .image {
    display: flex;
    align-items: center;
    justify-content: center;
}

.card-body {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    height: 100%;
}

.manageExamButton {
    border: none;
    padding: 0.5em 1em;
    cursor: pointer;
    transition: ease-in 0.25s;
    margin: 0.2em;
    flex: 1 1 30%;
}

#editExam {
    background-color: #FCDB77;
}

#deleteExam {
    background-color: rgb(249, 55, 55);
}

.badge {
    background: linear-gradient(rgb(220, 255, 200), rgba(110, 177, 131, 0.7), rgb(220, 255, 200)) !important;
}
</style>