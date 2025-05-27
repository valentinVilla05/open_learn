<script setup>
import { computed, ref, watch, watchEffect, onMounted } from 'vue';
import Swal from 'sweetalert2';
import router from '@/router';
import { userAuth } from '@/utils/userAuth';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

const loguedUser = ref(null);
const newQuestion = ref({
    'exam_id': null,
    'statement': '',
    'correct_answer': '',
    'incorrect_answer_1': '',
    'incorrect_answer_2': '',
    'incorrect_answer_3': ''
});
const validStatement = ref(false);
const validCorrectAnswer = ref(null);
const validIncorrectAnswer1 = ref(false);
const validForm = ref(false);

function cleanForm() {
    newQuestion.value.statement = '';
    newQuestion.value.correct_answer = '';
    newQuestion.value.incorrect_answer_1 = '';
    newQuestion.value.incorrect_answer_2 = '';
    newQuestion.value.incorrect_answer_3 = '';
}
function createQuestion() {
    fetch('http://localhost:8000/api/questions', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${props.userAuth}`,
            'Accept': 'application/json',
        },
        body: JSON.stringify(newQuestion.value)
    })
        .then(response => response.json())
        .then(data => {
            Swal.fire({
                title: "Question created",
                text: "The question has been added to the pool!",
                icon: "success"
            });
            cleanForm()
        })
        .catch(error => console.error('Error:', error));
}




watchEffect(() => {
    newQuestion.value.statement.trim() != '' ? validStatement.value = true : validStatement.value = false
    newQuestion.value.correct_answer.trim() != '' ? validCorrectAnswer.value = true : validCorrectAnswer.value = false
    newQuestion.value.incorrect_answer_1.trim() != '' ? validIncorrectAnswer1.value = true : validIncorrectAnswer1.value = false

    if (validCorrectAnswer.value && validStatement.value && validIncorrectAnswer1.value) {
        validForm.value = true
    } else validForm.value = false
});

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

});
</script>
<template>
    <div class="w-75 text-start ms-5">
        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="mt-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <RouterLink to="/" class="text-decoration-none">Home</RouterLink>
                </li>
                <li class="breadcrumb-item">
                    <RouterLink to="/controlPanel" class="text-decoration-none text-">Control Panel</RouterLink>
                </li>
                <li class="breadcrumb-item active" aria-current="page">Question Creator</li>
            </ol>
        </nav>
    </div>
    <div class="container">
        <h2 class="text-center">Create a new question:</h2>
        <div
            class="container shadow rounded w-50 h-75 border d-flex justify-content-center align-items-center flex-column mt-3">
            <div class="input-group mt-3 position-relative">
                <label class="input-group-text" for="statement">Statement:*</label>
                <input type="text" name="statement" placeholder="How many paws has a dog?" class="form-control"
                    v-model="newQuestion.statement" />
            </div>

            <div class="input-group mt-3 position-relative h-auto">
                <label class="input-group-text" for="correct_answer">Correct answer:*</label>
                <input type="text" name="correct_answer" placeholder="4" class="form-control"
                    v-model="newQuestion.correct_answer" />
            </div>

            <div class="input-group mt-3 position-relative">
                <label class="input-group-text" for="incorrect_answer_1">Incorrect answer 1:*</label>
                <input type="text" name="incorrect_answer_1" class="form-control" placeholder="2"
                    v-model="newQuestion.incorrect_answer_1" />
            </div>

            <div class="input-group mt-3 position-relative">
                <label class="input-group-text" for="incorrect_answer_2">Incorrect answer 2:</label>
                <input type="text" min="1" name="incorrect_answer_2" class="form-control" placeholder="3"
                    v-model="newQuestion.incorrect_answer_2">
            </div>
            <div class="input-group mt-3 position-relative">
                <label class="input-group-text" for="incorrect_answer_3">Incorrect answer 3:</label>
                <input type="text" min="1" name="incorrect_answer_3" class="form-control" placeholder="1"
                    v-model="newQuestion.incorrect_answer_3">
            </div>
            <div class="w-100 m-3 d-flex justify-content-between">
                <button class="btn buttonClean p-2 m-2" @click="cleanForm">
                    Clean data
                </button>
                <button class="btn buttonCreate p-2 m-2" @click="createQuestion" :disabled="!validForm">
                    Create
                </button>
            </div>
        </div>
    </div>
</template>
<style scoped>
.imageContainer {
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 1em;
    background-color: #f8f9fa;
    margin-bottom: 1em;
    width: 100%;
    max-width: 500px;
}


.image {
    width: 50%;
    height: 20em;
    object-fit: cover;
}

.buttonClean {
    background-color: #FCDB77;
}

.buttonClean:hover {
    background-color: #ffe8a2;
}

.buttonCreate {
    background-color: #6EB183;
}

.buttonCreate:hover {
    background-color: #97cea8;
}
</style>