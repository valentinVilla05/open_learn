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
    fetch(`https://apiopenlearn.onrender.com/api/exams/course/${course_id}`, {
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
    fetch(`https://apiopenlearn.onrender.com/api/courses/${course_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            courseData.value = data;
        })
        .catch(error => console.log('Error:', error));
}

async function getQuestions() {
    try {
        const response = await fetch('https://apiopenlearn.onrender.com/api/questions');
        const data = await response.json();
        allQuestionList.value = data.filter(question => question.exam_id == null);
    } catch (error) {
        console.log('Error:', error);
    }
}

async function getAddedQuestion(exam_id) {
    try {
        const response = await fetch(`https://apiopenlearn.onrender.com/api/questions/exam/${exam_id}`);
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
        await fetch(`https://apiopenlearn.onrender.com/api/questions/${question_id}`, {
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
        await fetch(`https://apiopenlearn.onrender.com/api/questions/${question_id}`, {
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
    fetch('https://apiopenlearn.onrender.com/api/exams', {
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
    fetch(`https://apiopenlearn.onrender.com/api/exams/${exam_id}`, {
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
  <div class="container-fluid px-3">
    <!-- Breadcrumb -->
    <div class="text-start mt-2">
      <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="mt-4">
        <ol class="breadcrumb">
          <li class="breadcrumb-item">
            <RouterLink to="/catalog" class="text-decoration-none">Catalog</RouterLink>
          </li>
          <li class="breadcrumb-item">
            <RouterLink :to="{ name: 'course', params: { course_id: courseData?.id } }"
              class="text-decoration-none">{{ courseData?.title }}</RouterLink>
          </li>
          <li class="breadcrumb-item active" aria-current="page">Exam Creator</li>
        </ol>
      </nav>
    </div>

    <!-- Exam Title -->
    <h2 class="text-center">Create a new exam:</h2>
    <div class="container border shadow rounded p-4 mb-4">
      <div class="input-group">
        <label class="input-group-text" for="title">Title:</label>
        <input
          type="text"
          name="title"
          :placeholder="'FinalHoot ' + (courseData?.title || '')"
          class="form-control"
          v-model="updateExamData.title"
        />
      </div>
    </div>

    <!-- Questions -->
    <h3 class="text-center m-3">Add or remove questions from the exam</h3>
    <div class="row g-3 justify-content-center">
      <!-- Added Questions -->
      <div class="questionList col-12 col-md-6 border shadow-sm p-3 rounded">
        <p v-if="addedQuestions.length === 0" class="text-muted text-center fs-6">
          This exam doesn't have any question added yet.
        </p>
        <div v-for="questionAdded in addedQuestions" :key="questionAdded.id" class="d-flex align-items-center m-2 p-2 border rounded">
          <p class="flex-grow-1 ms-2 mb-0">{{ questionAdded.statement }}</p>
          <button class="remove ms-2 px-2" @click="removeQuestion(questionAdded.id)">Remove</button>
        </div>
      </div>

      <!-- Available Questions -->
      <div class="questionList col-12 col-md-6 border shadow-sm p-3 rounded">
        <p v-if="allQuestionList.length === 0" class="text-muted text-center fs-6">
          There aren't any questions available yet. Go create some now.
        </p>
        <div v-for="question in allQuestionList" :key="question.id" class="d-flex align-items-center m-2 p-2 border rounded">
          <p class="flex-grow-1 ms-2 mb-0">{{ question.statement }}</p>
          <button class="add ms-2 px-2" @click="addQuestion(question.id)">Add</button>
        </div>
      </div>
    </div>

    <!-- Toggle Exam Activation -->
    <div v-if="addedQuestions.length !== 0" class="d-flex flex-column flex-md-row justify-content-center align-items-center gap-3 mt-4 text-center">
      <p class="m-0" v-if="!isExamActive">
        Your exam is <strong class="text-warning">inactive</strong>.
      </p>
      <p class="m-0" v-else>
        Your exam is <strong class="text-success">active</strong> and students can see it!
      </p>
      <button
        class="toggle-container border-0"
        :class="isExamActive ? 'inactive' : 'active'"
        @click="toggleSwitch"
      >
        <motion.div :data-state="isExamActive" class="toggle-handle" layout :transition="{
          type: 'spring',
          visualDuration: 0.3,
          bounce: 0.2
        }" />
      </button>
    </div>

    <div v-else class="text-center mt-3">
      <p class="text-danger">The exam will remain inactive if no questions are added.</p>
    </div>

    <!-- Finish Button -->
    <div class="text-center mt-4">
      <button class="btn buttonCreate px-4 py-2" @click="updateAndExit()">Finish Exam</button>
      <div>
        <small class="text-muted">Make sure your exam is active before leaving so students can see it.</small>
      </div>
    </div>
  </div>
</template>

<style scoped>
.questionList {
  max-height: 25em;
  overflow-y: auto;
}

.remove {
  background-color: #FF708D;
  border: none;
  border-radius: 0.25rem;
}

.add {
  background-color: #DCFFC8;
  border: none;
  border-radius: 0.25rem;
}

.toggle-container {
  width: 70px;
  height: 35px;
  border-radius: 35px;
  cursor: pointer;
  display: flex;
  padding: 1.25px;
  transition: background-color 0.3s ease;
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
