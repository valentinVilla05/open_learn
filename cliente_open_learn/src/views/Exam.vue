<script setup>
import { ref, onMounted } from 'vue';
import { userAuth } from '@/utils/userAuth';
import { useRoute } from 'vue-router';
import QuestionsExam from '@/components/QuestionsExam.vue';
import Swal from 'sweetalert2';


const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

const route = useRoute();
const exam_id = route.params.exam_id;
const loguedUser = ref(null);
const startedExam = ref(false);
const loadingDiv = ref(false)
const doingExam = ref(false)
let countdownStarted = false; // bandera para evitar múltiples intervalos

function startExam() {
    startedExam.value = true;
    if (typeof localStorage !== 'undefined') {
        localStorage.setItem('exam_status', 'loading');
    }
    loadQuestions();
    deleteAnswer(loguedUser.value.id, exam_id)
}

function loadQuestions() {
    if (countdownStarted) return;
    countdownStarted = true;

    let counter = 5;

    loadingDiv.value = true;

    const interval = setInterval(() => {
        counter--;
        if (counter <= 0) {
            doingExam.value = true;
            loadingDiv.value = false;
            localStorage.setItem('exam_status', 'loaded');
            clearInterval(interval);
        }
    }, 1000);
}

// Before start the exam, we delete every answer that the user has made
function deleteAnswer(user_id, exam_id) {
    fetch(`https://apiopenlearn.onrender.com/api/answers/${user_id}/${exam_id}`, {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${props.userAuth}`,
            'Accept': 'application/json',
        },
    })
        .then(response => response.json())
        .then(data => console.log(data))
        .catch(error => console.error('Error:', error));
}

onMounted(async () => {
    const user = await userAuth(props.userAuth);
    if (user) {
        loguedUser.value = user;
    } else {
        Swal.fire({
            icon: "error",
            title: "Who are you?",
            text: "You must be logued in to do an exam",
        });
    }

    const status = localStorage.getItem('exam_status');
    if (status === 'loading') {
        startedExam.value = true;
        loadingDiv.value = true;
        loadQuestions();
    } else if (status === 'loaded') {
        startedExam.value = true;
        loadingDiv.value = false;
        doingExam.value = true;
    }
});
</script>
<template>
    <main class="container py-5 d-flex justify-content-center align-items-center">
        <!-- Alert before exam -->
        <div v-if="!startedExam" class="card shadow-lg p-4 text-center w-50">
            <img src="/alert_exam.png" alt="alert" class="mx-auto mb-3" style="width: 6em;">
            <h2 class="mb-4">Before you start the exam, remember:</h2>
            <ul class="text-start mb-4 px-3">
                <li class="mb-2">If you quit the exam before finishing it, unanswered questions will be marked as wrong.
                </li>
                <li class="mb-2">You can retake the exam multiple times.</li>
                <li class="mb-2">Don't cheat — the only one who loses is you.</li>
                <li class="mb-2">We highly recommend you to log in again before try the exam to avoid any session
                    problem.</li>
            </ul>
            <button class="btn px-4 py-2" @click="startExam">
                Start the Exam
            </button>
        </div>
        <!-- Loading screen  -->
        <div v-if="loadingDiv" id="loadingDiv"
            class="text-center d-flex flex-column align-items-center justify-content-center w-50">
            <h4 class="mb-3">Loading the questions...</h4>
            <div class="spinner-border text-primary mb-3" role="status"></div>
            <p class="text-muted">Focus and good luck — make Gilbert proud!</p>
        </div>

        <QuestionsExam v-if="doingExam" :loguedUser="loguedUser" :userAuth="props.userAuth"></QuestionsExam>

    </main>

</template>
<style scoped></style>