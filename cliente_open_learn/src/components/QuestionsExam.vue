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
const exam_id = route.params.exam_id;
const questionsList = ref({});
const loguedUser = ref(props.loguedUser)
const currentQuestion = ref(0);
const answered = ref(false);
const userAnswer = ref(null);
const answerState = ref(null);
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
  // Si la pregunta actual ya ha sido respondida, no hacer nada
  if (answered.value) {
    return;
  }
  answered.value = true; // Marcar la pregunta actual como respondida

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
      userAnswer.value = { user_answer: answer };

      // Mostrar estado inmediato mientras se corrige después
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
        answerState.value = "correct"
      } else {
        answerState.value = "incorrect"
      }
    })
    .catch(error => {
      console.log('Error:', error);
      return false;
    });
}

function checkQuestion(answer_id) {
  if (answered.value && answer_id) {
    correctAnswer(answer_id);
  }
}

async function hasAnswered(user_id, exam_id, question_id) {
  try {
    fetch(`http://localhost:8000/api/answers/${user_id}/${exam_id}/${question_id}`, {
      method: 'GET',
    }).then(response => response.json())
      .then(data => {
        if (data) {
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

// Watch para reiniciar el estado al cambiar de pregunta
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
  <div class="container d-flex flex-row p-4 justify-content-center align-items-center">
    <section id="questionPanel" class="flex-grow-1 shadow-sm border rounded p-4 bg-white"
      v-if="questionsList.length && questionsList[currentQuestion]">
      <h4 class="mb-4">Pregunta {{ currentQuestion + 1 }}</h4>
      <p class="fs-5 mb-4">{{ questionsList[currentQuestion].statement }}</p>

      <div class="w-100 d-flex flex-wrap justify-content-between">
        <motion.div v-for="(answer, index) in shuffledAnswers" :key="index"
          @click="createAnswer(answer, questionsList[currentQuestion].id)" :class="[
            'answer',
            answer === userAnswer?.user_answer && answerState === 'correct' ? 'correctAnswer' : '',
            answer === userAnswer?.user_answer && answerState === 'incorrect' ? 'incorrectAnswer' : '',
            answered ? 'disabled-click' : '' // Aplica disabled-click si la pregunta ya fue respondida
          ]" :whilehover="{ scale: 1.05 }" class="text-center w-50 mb-3 p-3 border rounded cursor-pointer">
          {{ answer }}
        </motion.div>
      </div>
      <div class="d-flex justify-content-between">
        <button class="btn border border-0" @click="currentQuestion -= 1" :disabled="currentQuestion == 0">
          Previous Question
        </button>
        <button class="btn border border-0" @click="currentQuestion += 1;"
          :disabled="currentQuestion == questionsList.length - 1">
          Next Question
        </button>
      </div>
    </section>

    <aside id="questionList" class="shadow-sm border rounded p-4" v-if="questionsList.length">
      <h6 class="mb-3">Listado de Preguntas</h6>
      <ul class="list-unstyled">
        <li v-for="(question, index) in questionsList" :key="index" class="mb-2">
          <div class="questionBoxUnanswered rounded fs-6 text-center btn-sm w-100" @click="currentQuestion = index">
            Pregunta {{ index + 1 }}
          </div>
        </li>
      </ul>
    </aside>
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

/* La clase neutralAnswer ya no se aplicará dinámicamente en esta versión */
/* .neutralAnswer{
    background-color: rgb(203, 203, 203);
} */

/* Clase para deshabilitar clicks */
.disabled-click {
  pointer-events: none;
  /* Evita eventos de clic */
  opacity: 0.7;
  /* Opcional: hace que se vea un poco atenuado */
  cursor: not-allowed;
  /* Cambia el cursor para indicar que no es clickeable */
}

.questionBoxUnanswered {
  background-color: rgb(211, 211, 211);
}

.questionBoxCorrect {
  background-color: #6EB183;
}

.questionBoxIncorrect {
  background-color: crimson;
}
</style>
