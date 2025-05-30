<script setup>
import { ref, onMounted, computed, watch, nextTick } from 'vue';
import { useRoute } from 'vue-router';
import { motion } from 'motion-v';

const props = defineProps({
  loguedUser: {
    type: Object
  },
  userAuth: {
    type: String,
    required: false // Optional
  }
})

const route = useRoute();
const course_id = route.params.course_id
const exam_id = route.params.exam_id;
const questionsList = ref({});
const loguedUser = ref(props.loguedUser)
const currentQuestion = ref(0);
const answered = ref(false);
const userAnswer = ref(null);
const answerState = ref(null);
const calification = ref(null);
const showCalification = ref(null)

const newAnswer = ref({
  user_id: loguedUser?.value.id,
  question_id: '',
  exam_id: exam_id,
  user_answer: ''
});



// Get the questions of the exam
function getQuestions(exam_id) {
  fetch(`http://localhost:8000/api/questions/exam/${exam_id}`, {
    method: 'GET',
  }).then(response => response.json())
    .then(data => {
      questionsList.value = data;
      hasAnswered(loguedUser.value.id, exam_id, questionsList.value[currentQuestion.value].id)
    })
    .catch(error => console.log('Error:', error));
}

function createAnswer(answer, question_id) {
  // If the answer has been answered, do nothing
  if (answered.value) {
    return;
  }
  answered.value = true; // Mark the question as answered

  newAnswer.value.question_id = question_id
  newAnswer.value.user_answer = answer;

  fetch('http://localhost:8000/api/answers', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${props.userAuth}`,
      'Accept': 'application/json',
    },
    body: JSON.stringify(newAnswer.value)
  })
    .then(response => response.json())
    .then(data => {
      correctAnswer(data.answer.id)
      userAnswer.value = { user_answer: answer }; // Save the data answer

      // Change inmediately the class of the answer
      const correct = questionsList.value[currentQuestion.value].correct_answer;
      answerState.value = answer === correct ? 'correct' : 'incorrect';

      nextTick(() => checkQuestion(data.id));
    })
    .catch(error => console.error('Error:', error));
}

// Correct the answer
function correctAnswer(answer_id) {
  return fetch(`http://localhost:8000/api/answers/${answer_id}`, {
    method: 'GET',
  }).then(response => response.json())
    .then(data => {
      if (data.is_correct) {
        answerState.value = "correct" // Set the class as correct
      } else {
        answerState.value = "incorrect" // Set the class as incorrect
      }
    })
    .catch(error => {
      console.log('Error:', error);
      return false;
    });
}
// Function to control and call the function to check if the answer is correct
function checkQuestion(answer_id) {
  if (answered.value && answer_id) {
    correctAnswer(answer_id);
  }
}
// Function to check if the question has been answered by the user before
async function hasAnswered(user_id, exam_id, question_id) {
  try {
    fetch(`http://localhost:8000/api/answers/${user_id}/${exam_id}/${question_id}`, {
      method: 'GET',
    }).then(response => response.json())
      .then(data => {
        if (data) { // If is answered, then check it
          answered.value = true
          userAnswer.value = data.answer;
          checkQuestion(userAnswer.value.id);
        } else {
          answered.value = false
        }
      })
      .catch(error => {
        console.log('Error:', error);
        return false;
      });
  } catch {
    console.log("The user hasnt answered the question")
  }
}

// Function to randomize
const shuffleArray = (array) => {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
};
// Computed const to get the shuffle answers
const shuffledAnswers = computed(() => {
  if (questionsList.value.length && questionsList.value[currentQuestion.value]) {
    const question = questionsList.value[currentQuestion.value];
    const answers = [
      question.correct_answer,
      question.incorrect_answer_1,
      question.incorrect_answer_2,
      question.incorrect_answer_3
    ];
    return shuffleArray([...answers]); // Use a answers copy and dont modify the original only
  }
  return [];
});

function createCalification(user_id, exam_id, calification) {

  const newCalification = {
    user_id: user_id,
    exam_id: exam_id,
    calification: calification
  };

  fetch('http://localhost:8000/api/califications', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${props.userAuth}`,
      'Accept': 'application/json',
    },
    body: JSON.stringify(newCalification)
  })
    .then(response => response.json())
    .then(data => {
      console.log('Calification created', data);
      showCalification.value = true;
    })
    .catch(error => console.error('Error:', error));
}

function getCalification(user_id, exam_id) {
  localStorage.removeItem('exam_status')
  fetch(`http://localhost:8000/api/answers/score/${user_id}/${exam_id}`, {
    method: 'GET',
  }).then(response => response.json())
    .then(data => {
      isNaN(data) ? calification.value = 0 : calification.value = data;
      if (calification.value >= 5) {
        seeCertificate(loguedUser.id, course_id)
      }
      createCalification(loguedUser.value.id, exam_id, data)
    })
    .catch(error => console.log('Error:', error));
}

function seeCertificate(user_id, course_id) {
  fetch(`http://localhost:8000/api/certificates/${user_id}/${course_id}`, {
    method: 'GET',
  })
    .then(response => {
      if (response.headers.get('content-type') === 'application/pdf') {
        return response.blob();
      }
      return response.json(); // fallback in case it's JSON
    })
    .then(data => {
      if (data instanceof Blob) {
        const blobUrl = URL.createObjectURL(data);
        window.open(blobUrl, '_blank');
      } else {
        console.log('Certificates:', data); // in case it's not a PDF
      }
    })
    .catch(error => console.log('Error:', error));
}

// Watch to reset the values when the question change
watch(currentQuestion, () => {
  userAnswer.value = null;
  answerState.value = null;
  answered.value = false;
  hasAnswered(loguedUser.value.id, exam_id, questionsList.value[currentQuestion.value].id)
});


onMounted(() => {
  getQuestions(exam_id);
})
</script>
<template>
  <!-- Main container -->
  <div v-if="!showCalification" class="container-fluid p-4">
    <div class="row g-4">
      <!-- Question panel -->
      <section
        id="questionPanel"
        class="col-12 col-lg-8 shadow-sm border rounded p-4"
        v-if="questionsList.length && questionsList[currentQuestion]"
      >
        <h4 class="mb-4">Pregunta {{ currentQuestion + 1 }}</h4>
        <p class="fs-5 mb-4">{{ questionsList[currentQuestion].statement }}</p>

        <div class="row g-3">
          <motion.div
            v-for="(answer, index) in shuffledAnswers"
            :key="index"
            @click="createAnswer(answer, questionsList[currentQuestion].id)"
            :class="[
              'answer',
              answer === userAnswer?.user_answer && answerState === 'correct' ? 'correctAnswer' : '',
              answer === userAnswer?.user_answer && answerState === 'incorrect' ? 'incorrectAnswer' : '',
              answered ? 'disabled-click' : ''
            ]"
            :whilehover="{ scale: 1.05 }"
            class="col-12 col-md-6 text-center p-3 border rounded"
          >
            {{ answer }}
          </motion.div>
        </div>

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mt-4 gap-2">
          <button
            v-if="currentQuestion > 0"
            class="btn "
            @click="currentQuestion -= 1"
            :disabled="currentQuestion == 0"
          >
            Previous Question
          </button>

          <button
            v-if="currentQuestion < questionsList.length - 1"
            class="btn"
            @click="currentQuestion += 1"
            :disabled="currentQuestion == questionsList.length - 1"
          >
            Next Question
          </button>

          <button
            v-if="currentQuestion >= questionsList.length - 1"
            class="btn getCalification"
            @click="getCalification(loguedUser.id, exam_id)"
          >
            Get Calification
          </button>
        </div>
      </section>

      <!-- Questions List -->
      <aside
        id="questionList"
        class="col-12 col-lg-4 shadow-sm border rounded p-4"
        v-if="questionsList.length"
      >
        <h6 class="mb-3">Listado de Preguntas</h6>
        <ul class="list-unstyled">
          <li v-for="(question, index) in questionsList" :key="index" class="mb-2">
            <div
              class="questionBoxUnanswered rounded fs-6 text-center btn-sm w-100"
              @click="currentQuestion = index"
            >
              Pregunta {{ index + 1 }}
            </div>
          </li>
        </ul>
      </aside>
    </div>
  </div>

  <!-- Calification viewer -->
  <div
    v-if="showCalification"
    class="container d-flex flex-column justify-content-center align-items-center p-4 bg-white shadow-lg rounded-4 position-relative"
  >
    <RouterLink to="/" class="btn position-absolute" style="top: 1rem; left: 1rem;">
      Go back Home
    </RouterLink>

    <img
      :src="calification >= 5 ? '/happy_gilbert.png' : '/dont_give_up_gilbert.png'"
      :alt="calification >= 5 ? 'approved' : 'try again'"
      class="mb-4 mt-3"
      style="max-width: 200px; height: auto;"
    />

    <h2 class="text-primary fw-bold mb-2">You got:</h2>
    <p class="fs-1 fw-bold text-dark">{{ calification || 0 }}</p>

    <p class="fs-5 text-center" :class="calification < 5 ? 'text-muted' : 'text-success'">
      {{ calification < 5 ? "Don't give up, you'll get it next time!" : "🎉 Congratulations! You got the certificate!" }}
    </p>

    <button
      v-if="calification >= 5"
      @click="seeCertificate(loguedUser.id, course_id)"
      class="btn mt-4 px-4 py-2 fw-semibold"
    >
      🎓 Click here to get it!
    </button>

    <small class="text-muted mt-3 text-center" v-if="calification >= 5">
      Once you click, it will appear in your certificates collection.
    </small>
  </div>
</template>

<style scoped>
.answer {
  background-color: rgb(203, 203, 203);
  cursor: pointer;
}

.answer:hover {
  scale: 1.05;
}

.correctAnswer {
  background-color: #6EB183;
}

.incorrectAnswer {
  background-color: crimson;
}

.disabled-click {
  pointer-events: none;
  opacity: 0.7;
  cursor: not-allowed;
}

.questionBoxUnanswered {
  background-color: rgb(211, 211, 211);
  cursor: pointer;
  padding: 0.5rem;
}

.getCalification {
  background-color: #FF9FB2 !important;
  border: none;
}
</style>
