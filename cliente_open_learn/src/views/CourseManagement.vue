<script setup>
import { onMounted, ref, computed } from 'vue';
import { Modal } from "bootstrap";
import Swal from 'sweetalert2';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

let courses = ref([]);

// We get all the courses
async function getCourses() {
    try {
        fetch('http://localhost:8000/api/courses')
            .then(response => response.json())
            .then(data => courses.value = data);
    } catch (error) {
        alert(`Error al obtener datos: ${error.message}`);
    }
}
onMounted(getCourses);

// Function to delete a course;
function deleteCourse(course_id, course_title) {

    Swal.fire({
        title: "Are you sure you want to delete this course?",
        text: "All the resources that belongs to this course will be deleted too.",
        imageUrl: "/deleteCourse.png",
        imageWidth: 150,
        imageHeight: 150,
        showCancelButton: true,
        confirmButtonColor: "red",
        cancelButtonColor: "gray",
        confirmButtonText: "Delete"
    }).then((result) => {
        if (result.isConfirmed) {
            let timerInterval;
            Swal.fire({
                title: "Course deleted",
                text: "The course \"" + course_title + "\" has been deleted succesfully.",
                icon: "success",
                timer: 2000,
                timerProgressBar: true,
                didOpen: () => {
                    Swal.showLoading();
                    const timer = Swal.getPopup().querySelector("b");
                    timerInterval = setInterval(() => {
                        timer.textContent = `${Swal.getTimerLeft()}`;
                    }, 100);
                },
                willClose: () => {
                    clearInterval(timerInterval);
                }
            });
            fetch(`http://localhost:8000/api/courses/${course_id}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${props.userAuth}`,
                    'Accept': 'application/json',
                },
            })
                .then(response => response.json())
                .then(() => getCourses())
                .catch(error => console.error('Error:', error));
        }
    });
}

// Modal's logic

const teacherList = ref([]) // Get all the teachers
const teacherName = ref(null)

function getTeacher() {
    fetch('http://localhost:8000/api/users', {
        method: 'GET',
    })
        .then(response => response.json())
        .then(data => {
            teacherList.value = data.filter(teacher => teacher.rol === 'teacher');
            console.log(teacherList.value);
        })
        .catch(error => console.log('Error:', error));
}
getTeacher();

let modalAssign = null;
const selectedCourse = ref(null);

const updateCourse = ref({
    teacher_id: '',
    title: '',
    description: '',
    privacy: '',
    image: '',
    max_students: '',
    subject: '',
    duration: ''
});

onMounted(() => {
    const modalElement = document.getElementById("modalAssign");
    modalAssign = new Modal(modalElement);

})

function openModal(course_id) {
    selectedCourse.value = courses.value.find(course => course.id == course_id);

    if (selectedCourse.value) {
        const foundTeacher = teacherList.value.find(
            teacher => teacher.id == selectedCourse.value.teacher_id
        );
        teacherName.value = foundTeacher ? foundTeacher.name : 'Unknown';

        updateCourse.value.teacher_id = selectedCourse.value.id;
        updateCourse.value.title = selectedCourse.value.title;
        updateCourse.value.description = selectedCourse.value.description;
        updateCourse.value.privacy = selectedCourse.value.privacy;
        updateCourse.value.image = selectedCourse.value.image;
        updateCourse.value.max_students = selectedCourse.value.max_students;
        updateCourse.value.subject = selectedCourse.value.subject;
        updateCourse.value.duration = selectedCourse.value.duration;

        modalAssign.show();
    } else {
        console.error('Curso no encontrado para ID:', course_id);
    }
}

////////////////////////////////
////// Course pagination ///////
////////////////////////////////

let currentPage = ref(1);
let coursesPerPage = 5;
let totalPages = computed(() => Math.ceil(courses.value.length / coursesPerPage));

let paginatedCourses = computed(() => {
    const start = (currentPage.value - 1) * coursesPerPage;
    const end = start + coursesPerPage;
    return courses.value.slice(start, end);
})

function nextPage() {
    if (currentPage.value < Math.ceil(courses.value.length / coursesPerPage)) {
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
    <div class="w-75 text-start ms-5">
        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="mt-5">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <RouterLink to="/" class="text-decoration-none">Home</RouterLink>
                </li>
                <li class="breadcrumb-item">
                    <RouterLink to="/controlPanel" class="text-decoration-none text-">Control Panel</RouterLink>
                </li>
                <li class="breadcrumb-item active" aria-current="page">Courses Management</li>
            </ol>
        </nav>
    </div>

    <main class="container rounded shadow p-3">
        <div class="card mb-5" v-for="course in paginatedCourses" :key="course.id">
            <div class="row g-2">
                <div class="col-12 col-md-3 image d-flex align-items-center justify-content-center">
                    <img :src="course.image" class="img-fluid rounded-start imageCourse" :alt="course.title">
                </div>
                <div class="col-12 col-md-9">
                    <div class="card-body infoRoute">
                        <div>
                            <h2 class="card-title">{{ course.title }}</h2>
                            <h6 class="card-title">Duration: {{ course.duration }}</h6>
                            <h6 class="card-title">Teacher: {{ course.teacher_id }}</h6>
                            <p class="card-text">
                                {{ (course.description).slice(0, 75) }}...
                            </p>
                        </div>
                        <div class="btn-group mt-3 d-flex flex-wrap">
                            <button type="button" class="manageCoursesButton" id="asignCourse"
                                @click="openModal(course.id)">Edit
                                course information</button>
                            <button class="manageCoursesButton"
                                @click="deleteCourse(course.id, course.title, course.teacher_id)"
                                id="cancelCourse">Delete
                                course</button>
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

    <!-- Modal to edit course information -->
    <div class="modal fade" id="modalAssign" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="exampleModalLabel">Edit course information</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <h2>Course information:</h2>
                    <div class="container w-100 h-75 border d-flex justify-content-center align-items-center flex-column mt-3">
                        <div class="input-group mt-3 position-relative">
                            <label class="input-group-text" for="title">Title: </label>
                            <input type="text" name="title" class="form-control" v-model="updateCourse.title"
                             />
                        </div>

                        <div class="input-group mt-3 position-relative">
                            <label class="input-group-text" for="teacher">Teacher:</label>
                            <input type="text" name="teacher" class="form-control" :value="teacherName">
                            <input hidden type="text" name="teacher" class="form-control" v-model="updateCourse.teacher_id">
                        </div>

                        <div class="input-group mt-3 position-relative h-auto">
                            <label class="input-group-text" for="description">Description: </label>
                            <textarea type="text" name="description" class="form-control"
                                v-model="updateCourse.description"/>
                        </div>

                        <div class="input-group mt-3 position-relative">
                            <label class="input-group-text" for="privacy">Privacy: </label>
                            <select name="privacy" class="form-control"
                                v-model="updateCourse.privacy">
                                <option value="public">Public</option>
                                <option value="private">Private</option>
                            </select>   
                        </div>
                        <div class="input-group mt-3 position-relative">
                            <label class="input-group-text" for="image">Image: </label>
                            <input type="text" name="image" class="form-control"
                                v-model="updateCourse.image">
                        </div>
                        <div class="input-group mt-3 position-relative">
                            <label class="input-group-text" for="max_students">Max. Students: </label>
                            <input type="text" name="max_students" class="form-control"
                                v-model="updateCourse.max_students">
                        </div>
                        <div class="input-group mt-3 position-relative">
                            <label class="input-group-text" for="subject">Subject: </label>
                            <input type="text" name="subject" class="form-control"
                                v-model="updateCourse.subject">
                        </div>
                        <div class="input-group mt-3 mb-3 position-relative">
                            <label class="input-group-text" for="max_students">Duration: </label>
                            <input type="text" name="duration" class="form-control"
                                v-model="updateCourse.duration">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save changes</button>
                </div>
            </div>
        </div>
    </div>
</template>
<style scoped>
.imageCourse {
    width: 100%;
    height: 12em;
    object-fit: cover;
    border-radius: 10px;
}

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

.manageCoursesButton {
    border: none;
    padding: 0.5em 1em;
    cursor: pointer;
    transition: ease-in 0.25s;
    margin: 0.2em;
    flex: 1 1 30%;
}

#cancelCourse {
    background-color: rgb(249, 55, 55);
}

#asignCourse {
    background-color: #FCDB77;
}
</style>