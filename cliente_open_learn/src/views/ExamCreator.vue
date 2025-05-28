<script setup>
import { onMounted, ref } from 'vue';
import Swal from 'sweetalert2';
import { useRoute } from 'vue-router';
import { motion } from 'motion-v';
import { userAuth } from '@/utils/userAuth';
import router from '@/router';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});
const loguedUser = ref(null);
const route = useRoute();
const exam_id = ref(null);
const examExists = ref(false);
const courseData = ref(null)
const course_id = route.params.course_id;
const allQuestionList = ref([]);
const addedQuestions = ref([]);
const isExamActive = ref(false)


const updateExamData = ref({
    course_id: course_id,
    title: '',
    is_active: ''
})

const toggleSwitch = () => {
    if (addedQuestions.value.length === 0) {
        Swal.fire({
            icon: 'warning',
            title: 'You need to add questions',
            text: 'The exam cannot be activated without questions.',
        });
        return;
    }
    isExamActive.value = !isExamActive.value
    updateExamStatus(exam_id.value);
}

function checkExamExists() {
    fetch(`http://localhost:8000/api/exams/course/${course_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            examExists.value = data.some(exam => exam.course_id == course_id)
            if (!examExists.value) {
                createExam()
                isExamActive.value = false
            } else {
                exam_id.value = data.find(exam => exam.course_id == course_id)?.id;
                if (exam_id.value) {
                    updateExamData.value.title = data.find(exam => exam.course_id == course_id)?.title;
                    getAddedQuestion(exam_id.value);
                    isExamActive.value = data.find(exam => exam.course_id == course_id)?.is_active
                }
            }
        })
        .catch(error => console.log('Error:', error));
}

function getCourseName(course_id) {
    fetch(`http://localhost:8000/api/courses/${course_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            courseData.value = data;
        })
        .catch(error => console.log('Error:', error));
}

async function getQuestions() {
    try {
        const response = await fetch('http://localhost:8000/api/questions');
        const data = await response.json();
        allQuestionList.value = data.filter(question => question.exam_id == null);
    } catch (error) {
        console.log('Error:', error);
    }
}

async function getAddedQuestion(exam_id) {
    try {
        const response = await fetch(`http://localhost:8000/api/questions/exam/${exam_id}`);
        const data = await response.json();
        addedQuestions.value = data;
    } catch (error) {
        console.log('Error:', error);
    }
}

async function addQuestion(question_id) {
    const updatedQuestion = {
        exam_id: exam_id.value
    };

    try {
        await fetch(`http://localhost:8000/api/questions/${question_id}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${props.userAuth}`,
                'Accept': 'application/json',
            },
            body: JSON.stringify(updatedQuestion)
        });
        // Wait for the updated arrays
        await getAddedQuestion(exam_id.value);
        await getQuestions();

    } catch (error) {
        console.error('Error:', error);
    }
}

async function removeQuestion(question_id) {
    const updatedQuestion = {
        exam_id: null
    };

    try {
        await fetch(`http://localhost:8000/api/questions/${question_id}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${props.userAuth}`,
                'Accept': 'application/json',
            },
            body: JSON.stringify(updatedQuestion)
        });

        // Wait for the updated arrays
        await getAddedQuestion(exam_id.value);
        await getQuestions();

        // After verify the status, we update 
        if (addedQuestions.value.length === 0) {
            isExamActive.value = false;
            await updateExamStatus(exam_id.value);

            Swal.fire({
                icon: 'warning',
                title: 'You need to add questions',
                text: 'The exam cannot be activated without questions.',
            });
        }

    } catch (error) {
        console.error('Error:', error);
    }
}


function createExam() {
    const newExam = {
        'course_id': course_id,
        'title': '',
        'is_active': false
    };
    newExam.title = "FinalHoot " + courseData?.value.title
    fetch('http://localhost:8000/api/exams', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${props.userAuth}`,
            'Accept': 'application/json',
        },
        body: JSON.stringify(newExam)
    })
        .then(response => response.json())
        .then(data => exam_id.value = data.id)
        .catch(error => console.error('Error:', error));
}

function updateExamStatus(exam_id) {
    if (addedQuestions.value.length == 0) {
        isExamActive.value = false
    }
    const examStatus = {
        'is_active': isExamActive.value
    };
    fetch(`http://localhost:8000/api/exams/${exam_id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${props.userAuth}`,
            'Accept': 'application/json',
        },
        body: JSON.stringify(examStatus)
    })
        .then(response => response.json())
        .then(data => console.log('Response:', data))
        .catch(error => console.error('Error:', error));
}

function updateAndExit() {
    updateExamStatus(exam_id.value)
    Swal.fire({
        title: "Exam registered",
        text: "Your exam has been created and registered, you can edit it in any moment",
        icon: "success"
    });
}

onMounted(async () => {
    const user = await userAuth(props.userAuth);
    if (user) {
        loguedUser.value = user
        if (loguedUser.value && loguedUser.value.rol != 'teacher') {
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

    getQuestions()
    getCourseName(course_id)
    checkExamExists();
});

</script>
<template>
    <div class="w-75 text-start ms-1 mt-2">
        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="mt-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <RouterLink to="/catalog" class="text-decoration-none text-">Catalog</RouterLink>
                </li>
                <li class="breadcrumb-item" aria-current="page">
                    <RouterLink :to="{ name: 'course', params: { course_id: courseData?.id } }"
                        class="text-decoration-none">{{ courseData?.title }}</RouterLink>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    Exam Creator
                </li>
            </ol>
        </nav>
    </div>
    <h2 class="text-center">Create a new exam:</h2>
    <div class="container shadow rounded w-100 border d-flex justify-content-center align-items-center flex-column">
        <div class="input-group py-3">
            <label class="input-group-text" for="title">Title:</label>
            <input type="text" name="title" :placeholder="'FinalHoot ' + (courseData?.title || '')" class="form-control"
                v-model="updateExamData.title" />
        </div>
    </div>
    <h3 class="text-center m-3">Add or remove questions from the exam</h3>
    <div class="container w-50 d-flex">
        <div class="questionList w-100 overflow-auto rounded border shadow-sm p-2">
            <p v-if="addedQuestions.length == 0" class="text-muted text-center fs-6 ">This exam doesn't have any
                question
                added yet.</p>
            <div v-for="questionAdded in addedQuestions" class=" d-flex m-3 border rounded">
                <p class="w-100 ms-2">{{ questionAdded.statement }} </p>
                <button class="remove ms-auto px-2 bg-danger-emphasis"
                    @click="removeQuestion(questionAdded.id)">Remove</button>
            </div>
        </div>
        <div class="questionList w-100 overflow-auto rounded border shadow-sm p-2">
            <p v-if="allQuestionList.length == 0" class="text-muted text-center fs-6">There aren't any question
                available yet. Go to create some questions now.</p>
            <div v-for="question in allQuestionList" class=" d-flex m-3 border rounded">
                <p class="w-100 ms-2">{{ question.statement }} </p>
                <button class="add ms-auto px-2" @click="addQuestion(question.id)">Add</button>
            </div>
        </div>
    </div>
    <div v-if="addedQuestions.length != 0" class="d-flex justify-content-center align-items-center w-50">
        <p class="m-3 w-50" v-if="!isExamActive">Right now your exam is<strong class="text-warning"> inactive</strong>
        </p>
        <p class="m-3 w-50" v-else>Your exam is <strong class="text-warning">active</strong> and your students will see
            it!</p>
        <button class="border border-1" :class="['toggle-container', isExamActive ? 'inactive' : 'active']"
            @click="toggleSwitch">
            <motion.div :data-state="isExamActive" class="toggle-handle" layout :transition="{
                type: 'spring',
                visualDuration: 0.3,
                bounce: 0.2
            }" />
        </button>
    </div>
    <div v-else>
        <p class="text-danger">The exam will stay inactive if there is no answers added in it.</p>
    </div>
    <button class="btn buttonCreate p-2 m-2" @click="updateAndExit()">
        Finish Exam
    </button>
    <small class="text-muted">Make sure your exam is active before leaving, otherwise students won’t be able to see
        it.</small>
</template>
<style scoped>
.questionList {
    height: 25em !important;
}

p {
    margin-block: 1lh;
}

.remove {
    background-color: #FF708D;
    border: none;
}

.add {
    background-color: #DCFFC8;
    border: none;
}

.toggle-container {
    width: 70px;
    height: 35px;
    background-color: var(--hue-3-transparent);
    border-radius: 35px;
    cursor: pointer;
    display: flex;
    padding: 1.25px;
}

.toggle-container.active {
    justify-content: flex-start;
    background-color: crimson;
}

.toggle-container.inactive {
    justify-content: flex-end;
    background-color: #DCFFC8;
}

.toggle-handle {
    width: 28px;
    height: 28px;
    background-color: lightgray;
    border: 1px solid black;
    border-radius: 50%;
}
</style>