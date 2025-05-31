<script setup>
import { onMounted, ref, computed, watchEffect } from 'vue';
import { userAuth } from '@/utils/userAuth';
import { Modal } from 'bootstrap';
import Swal from 'sweetalert2';
import router from '@/router';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

const teacherLogued = ref(null);
const examList = ref([]);
const questionsList = ref([]);
const coursesList = ref([]);

const updateQuestion = ref({
    'exam_id': '',
    'statement': '',
    'correct_answer': '',
    'incorrect_answer_1': '',
    'incorrect_answer_2': '',
    'incorrect_answer_3': ''
});

function getCourses() { // We need to filter the courses that teaches the teacher loggued
    fetch('https://apiopenlearn.onrender.com/api/courses', {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            coursesList.value = data.filter(course => course.teacher_id == teacherLogued.value.id);
            console.log(coursesList.value);
        })
        .catch(error => console.log('Error:', error));
}

function getExamsTeacher() {
    fetch('https://apiopenlearn.onrender.com/api/exams', {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            examList.value = data.filter(exam => coursesList.value.some(course => course.id === exam.course_id));
            console.log(examList.value)
        })
        .catch(error => console.log('Error:', error));
}

function getQuestions() {
    fetch('https://apiopenlearn.onrender.com/api/questions', {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            questionsList.value = data.filter(question => {
                return question.exam_id === null ||
                    examList.value.some(exam => exam.id === question.exam_id);
            });
        })
        .catch(error => console.log('Error:', error));
}

function editQuestion(question_id) {
    fetch(`https://apiopenlearn.onrender.com/api/questions/${question_id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${props.userAuth}`,
            'Accept': 'application/json',
        },
        body: JSON.stringify(updateQuestion.value)
    })
        .then(response => response.json())
        .then(data => console.log('Response:', data))
        .catch(error => console.error('Error:', error));
}

function deleteQuestion(question_id) {
    if(questionsList.value.find(question => question.id == question_id).exam_id != null) {
        Swal.fire({
            icon: 'error',
            title: 'This question is associated to an exam',
            text: 'Remove from the exam to delete it'
        })
        return;
    }

    Swal.fire({
        title: "Are you sure?",
        text: "The question will be deleted permanently",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, delete it!"
    }).then((result) => {
        if (result.isConfirmed) {
            fetch(`https://apiopenlearn.onrender.com/api/questions/${question_id}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${props.userAuth}`,
                    'Accept': 'application/json',
                },
            })
                .then(response => response.json())
                .then(data => {
                    Swal.fire({
                        title: "Question deleted!",
                        text: "Your question has been deleted succesfully!",
                        icon: "success"
                    });
                    getCourses();
                    getExamsTeacher();
                    getQuestions();
                })
                .catch(error => console.error('Error:', error));
        }
    });
}

function cleanForm() {
    updateQuestion.value.statement = '';
    updateQuestion.value.correct_answer = '';
    updateQuestion.value.incorrect_answer_1 = '';
    updateQuestion.value.incorrect_answer_2 = '';
    updateQuestion.value.incorrect_answer_3 = '';
}

const validStatement = ref(false);
const validCorrectAnswer = ref(null);
const validIncorrectAnswer1 = ref(false);
const validForm = ref(false);


watchEffect(() => {
    updateQuestion.value.statement.trim() != '' ? validStatement.value = true : validStatement.value = false
    updateQuestion.value.correct_answer.trim() != '' ? validCorrectAnswer.value = true : validCorrectAnswer.value = false
    updateQuestion.value.incorrect_answer_1.trim() != '' ? validIncorrectAnswer1.value = true : validIncorrectAnswer1.value = false

    if (validCorrectAnswer.value && validStatement.value && validIncorrectAnswer1.value) {
        validForm.value = true
    } else validForm.value = false
});

let modalUpdate = null;
const selectedQuestion = ref(null);

function openModal(question_id) {
    selectedQuestion.value = questionsList.value.find(question => question.id === question_id)

    if (selectedQuestion.value) {
        updateQuestion.value.statement = selectedQuestion.value.statement;
        updateQuestion.value.correct_answer = selectedQuestion.value.correct_answer;
        updateQuestion.value.incorrect_answer_1 = selectedQuestion.value.incorrect_answer_1;
        updateQuestion.value.incorrect_answer_2 = selectedQuestion.value.incorrect_answer_2;
        updateQuestion.value.incorrect_answer_3 = selectedQuestion.value.incorrect_answer_3;

        modalUpdate.show();
    } else {
        console.error('Curso no encontrado para ID:', course_id);
    }
}


////////////////////////////////
///// Question pagination //////
////////////////////////////////

let currentPage = ref(1);
let questionPerPage = 5;
let totalPages = computed(() => Math.ceil(questionsList.value.length / questionPerPage));

let paginatedQuestion = computed(() => {
    const start = (currentPage.value - 1) * questionPerPage;
    const end = start + questionPerPage;
    return questionsList.value.slice(start, end);
})

function nextPage() {
    if (currentPage.value < Math.ceil(questionsList.value.length / questionPerPage)) {
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

    const modalElement = document.getElementById("modalUpdate");
    modalUpdate = new Modal(modalElement);

    await getCourses(); // Wait for load the course
    await getExamsTeacher(); // Wait for load the exams
    getQuestions(); // Filter the questions
})
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
                <li class="breadcrumb-item active" aria-current="page">Question Management</li>
            </ol>
        </nav>
    </div>
    <main class="container rounded shadow p-3 m-4 border">
        <h2 class="w-75 text-start text-muted">Your questions:</h2>
        <div v-if="paginatedQuestion.length === 0">
            <img src="/noData.png" alt="no data" class="img-fluid mx-auto d-block mt-5" style="width: 15em;">
            <p class="text-center">You haven't created any question yet.</p>
        </div>
        <div class="card mb-4 shadow-sm border-0" v-for="question in paginatedQuestion" :key="question.id">
            <div class="card-body">
                <h5 class="card-title fw-bold mb-3">Statement: {{ question.statement }}</h5>

                <ul class="list-unstyled mb-3">
                    <li><strong>Exam:</strong> {{examList.find(exam => exam.id == question.exam_id)?.title}}</li>
                    <li><strong>Correct answer:</strong> {{ question.correct_answer }}</li>
                    <li><strong>Incorrect 1:</strong> {{ question.incorrect_answer_1 }}</li>
                    <li><strong>Incorrect 2:</strong> {{ question.incorrect_answer_2 }}</li>
                    <li><strong>Incorrect 3:</strong> {{ question.incorrect_answer_3 }}</li>
                </ul>
                <p v-if="question.exam_id != null"><img src="/warning.png" alt="warning">This question is
                    associated to an exam, remove it To manage it.</p>

                <div class="w-100 btn-group mt-4 d-flex flex-wrap">
                    <button class="w-50 manageQuestionButton text-decoration-none text-center " id="editQuestion"
                        @click="openModal(question.id)">
                        Edit question
                    </button>
                    <button class="w-50 manageQuestionButton" id="deleteQuestion" :disabled="question.exam_id != null"
                        @click="deleteQuestion(question.id)">Delete question</button>
                </div>
            </div>
        </div>

        <nav v-if="paginatedQuestion.length !== 0" aria-label="Paginación de usuarios">
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
    <div class="modal fade" id="modalUpdate" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content w-100">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="exampleModalLabel">Edit question information</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body w-100">
                    <h2 class="text-center">Edit question:</h2>

                    <div class="input-group mt-4 position-relative">
                        <label class="input-group-text" for="statement">Statement:*</label>
                        <input type="text" name="statement" placeholder="How many paws has a dog?" class="form-control"
                            v-model="updateQuestion.statement" />
                    </div>

                    <div class="input-group mt-4 position-relative h-auto">
                        <label class="input-group-text" for="correct_answer">Correct answer:*</label>
                        <input type="text" name="correct_answer" placeholder="4" class="form-control"
                            v-model="updateQuestion.correct_answer" />
                    </div>

                    <div class="input-group mt-4 position-relative">
                        <label class="input-group-text" for="incorrect_answer_1">Incorrect answer 1:*</label>
                        <input type="text" name="incorrect_answer_1" class="form-control" placeholder="2"
                            v-model="updateQuestion.incorrect_answer_1" />
                    </div>

                    <div class="input-group mt-4 position-relative">
                        <label class="input-group-text" for="incorrect_answer_2">Incorrect answer 2:</label>
                        <input type="text" min="1" name="incorrect_answer_2" class="form-control" placeholder="3"
                            v-model="updateQuestion.incorrect_answer_2">
                    </div>
                    <div class="input-group mt-4 position-relative">
                        <label class="input-group-text" for="incorrect_answer_3">Incorrect answer 3:</label>
                        <input type="text" min="1" name="incorrect_answer_3" class="form-control" placeholder="1"
                            v-model="updateQuestion.incorrect_answer_3">
                    </div>
                    <div class="w-100 m-1 d-flex justify-content-between">
                        <button class="btn buttonClean p-2 m-2" @click="cleanForm">
                            Clean data
                        </button>
                        <button class="btn buttonCreate p-2 m-2" @click="editQuestion(selectedQuestion.id)"
                            :disabled="!validForm">
                            Update
                        </button>
                    </div>

                </div>
            </div>
        </div>
    </div>
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

.manageQuestionButton {
    border: none;
    padding: 0.5em 1em;
    cursor: pointer;
    transition: ease-in 0.25s;
    margin: 0.2em;
    flex: 1 1 30%;
}

#editQuestion {
    background-color: #FCDB77;
}

#deleteQuestion {
    background-color: rgb(249, 55, 55);
}
</style>