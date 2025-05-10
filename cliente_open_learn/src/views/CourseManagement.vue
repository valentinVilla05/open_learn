<script setup>
// Importamos todo lo necesario;
import { onMounted, ref, computed } from 'vue';
import { Modal } from "bootstrap";
import Swal from 'sweetalert2';

let courses = ref([]);

// Conseguimos todas las rutas disponibles;
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

// Funcion para eliminar una ruta;
function deleteCourse(course_id, course_title) {

    Swal.fire({
        title: "Are you sure you want to delete this course?",
        text: "All the resources that belongs to this course will be deleted too.",
        // imageUrl: "/", 
        // imageWidth: 150, 
        // imageHeight: 150,
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
            })
                .then(response => response.json())
                .then(data => getCourses())
                .catch(error => console.error('Error:', error));
        }
    });
}


////////////////////////////////
// Paginacion de los usuarios //
////////////////////////////////
let currentPage = ref(1);
let coursesPerPage = 5;
let totalPages = computed(() => Math.ceil(courses.value.length / coursesPerPage)); // Calculamos el numero de paginas totales, lo hacemos computed para que se actulice automaticamente cuando el numero de usuarios cambie

let paginatedCourses = computed(() => {
    const start = (currentPage.value - 1) * coursesPerPage; // Calculamos el inicio de los registros de la pagina
    const end = start + coursesPerPage; // Al numero inicial le sumamos los 10 registros que queremos mostrar
    return courses.value.slice(start, end); // Devolvemos los registros que queremos mostrar
})

function nextPage() {
    if (currentPage.value < Math.ceil(courses.value.length / coursesPerPage)) { // Comprobamos que no estemos en la utlima pagina
        currentPage.value++;
    }
}
function previousPage() {
    if (currentPage.value > 1) { // Comprobamos que no estamos en la primera pagina;
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
                <div class="col-12 col-md-3 image">
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
                            <button type="button" class="manageCoursesButton" id="asignCourse">Assign teacher</button>
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
    background-color: #7ac58a;
}
</style>