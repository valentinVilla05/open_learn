<script setup>
import { ref, onMounted } from 'vue';
import { motion } from 'motion-v';
import { RouterLink } from 'vue-router';

const props = defineProps({
    course_id: {
        type: String,
    },
    user_id: {
        type: Number
    },
    teacherAssigned: {
        type: Boolean
    }
});

const courseExam = ref(null);
const calificationsMap = ref({});
const graduated = ref(false)

// Get all the exams of this course
function getExams(course_id) {
    fetch(`https://apiopenlearn.onrender.com/api/exams/course/${course_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            courseExam.value = data
            console.log(courseExam.value)
        })
        .catch(error => console.log('Error:', error));
}
// Get the user's califications
function loadUserCalifications(user_id) {
    fetch(`https://apiopenlearn.onrender.com/api/califications/user/${user_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            // Take the califications where exam_id => calification
            const map = {};
            data.forEach(calif => {
                map[calif.exam_id] = calif.calification;
            });
            calificationsMap.value = map;
        })
        .catch(error => console.log('Error:', error));
}

// To control de style of the calification div
function getCalificationClass(calification) {
    if (calification === undefined || calification === null) return '';
    const score = parseFloat(calification);
    if (score < 5) return 'bg-danger text-white px-2 rounded';
    if (score === 5) return 'bg-warning text-dark px-2 rounded';
    if (score > 5) {
        graduated.value = true
        return 'bg-success text-white px-2 rounded';
    }
    return '';
}

onMounted(() => {
    loadUserCalifications(props.user_id);
    getExams(props.course_id);
});

</script>
<template>
    <div class="mx-2 my-4 w-100 d-flex flex-column align-items-center justify-content-center">
        <div class="w-75 fs-5 text-center">
            <p class="mb-1">Course's exam:</p>
            <hr class="my-1">
        </div>
        <div v-if="courseExam?.length && courseExam?.some(exam => exam.is_active)">
            <p class="mx-4">You can try the FinalHoot when you feel prepared, remember there's no hurry</p>
            <section v-for="exam in courseExam" :key="exam.id"
                class="d-flex flex-column justify-content-center align-items-center">
                <motion.div class="exam w-75 m-2 d-flex flex-row border shadow rounded align-items-center"
                    :while-hover="{ scale: 1.05 }">
                    <div class="d-flex align-items-center justify-content-center border-end border-3 w-25">
                        <img class="mx-1" style="min-height: fit-content; min-width: 2em;" src="/exam.png" alt="link">
                    </div>
                    <RouterLink v-if="calificationsMap[exam.id] < 5 || !calificationsMap[exam.id]"
                        :to="{ name: 'exam', params: { course_id: props.course_id, exam_id: exam.id } }"
                        class="m-3 w-50 fw-bold text-decoration-none text-black">{{ exam.title }}</RouterLink>
                    <p v-else class="m-3 w-50 fw-bold text-decoration-none text-black">{{ exam.title }}</p>
                    <div
                        class="w-25 d-flex flex-column align-items-center justify-content-center border-start text-center">
                        <section>
                            <p class="fw-bold">Calification</p>
                            <p :class="getCalificationClass(calificationsMap[exam.id])">
                                {{ calificationsMap[exam.id] !== undefined ? calificationsMap[exam.id] : "Not done" }}
                            </p>
                        </section>
                    </div>
                </motion.div>
                <div v-if="teacherAssigned" class="m-3 d-flex flex-column align-items-center justify-content-center">
                    <RouterLink :to="{ name: 'examCreator', params: { course_id: course_id } }" class="btn">Edit Exam
                    </RouterLink>
                </div>
                <div v-if="graduated" class="d-flex flex-column justify-content-center align-items-center">
                    <small>You did it, congratulations!!</small>
                    <img src="/home_page.png" alt="aprobe image" style="width: 12em; height: 8em;">
                </div>
            </section>
        </div>
        <div class="mx-3 d-flex flex-column align-items-center justify-content-center"
            v-else-if="teacherAssigned && courseExam?.length && !courseExam?.some(exam => exam.is_active)">
            <p>You already started creating an exam</p>
            <RouterLink :to="{ name: 'examCreator', params: { course_id: course_id } }" class="btn">Continue creating
                exam</RouterLink>
        </div>
        <div class="mx-3 d-flex flex-column align-items-center justify-content-center"
            v-else-if="teacherAssigned && !courseExam?.length">
            <p>Create an exam now.</p>
            <RouterLink :to="{ name: 'examCreator', params: { course_id: course_id } }" class="btn">Create exam
            </RouterLink>
        </div>
        <div v-else class="mx-3 d-flex flex-column align-items-center justify-content-center">
            <p>The FinalHoot is not prepared yet. Keep getting yourself ready for when it comes</p>
        </div>
    </div>
</template>
<style scoped></style>