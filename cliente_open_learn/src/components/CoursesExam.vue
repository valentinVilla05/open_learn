<script setup>
import { ref, onMounted } from 'vue';
import { motion } from 'motion-v';

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
    fetch(`http://localhost:8000/api/exams/course/${course_id}`, {
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
    fetch(`http://localhost:8000/api/califications/user/${user_id}`, {
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
    console.log("course_id", props.course_id);
    console.log("user_id", props.user_id);
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
        <div v-if="courseExam?.length > 0">
            <p class="mx-4">You can try the FinalHoot when you feel prepared, remember there's no hurry</p>
            <section v-for="exam in courseExam" :key="exam.id" class="d-flex flex-column justify-content-center align-items-center">
                <motion.div class="exam w-75 m-2 d-flex flex-row border shadow rounded align-items-center"
                    :while-hover="{ scale: 1.05 }">
                    <div class="d-flex align-items-center justify-content-center border-end border-3 w-25">
                        <img class="mx-1" style="min-height: fit-content; min-width: 2em;" src="/exam.png" alt="link">
                    </div>
                    <p class="m-3 w-50 fw-bold">{{ exam.title }}</p>
                    <div
                        class="w-25 d-flex flex-column align-items-center justify-content-center border-start text-center">
                        <section>
                            <p class="fw-bold">Calification</p>
                            <p :class="getCalificationClass(calificationsMap[exam.id])">
                                {{ calificationsMap[exam.id] || "Not done" }}
                            </p>
                        </section>
                    </div>
                </motion.div>
                <div v-if="graduated" class="d-flex flex-column justify-content-center align-items-center">
                    <small>You did it, congratulations!!</small>
                    <img src="/home_page.png" alt="aprobe image" style="width: 12em; height: 8em;">
                </div>
            </section>
        </div>
        <div v-else class="mx-3">
        <p >The FinalHoot is not prepared yet. Keep getting yourself ready for when it comes</p>
        <button v-if="teacherAssigned" class="btn">Create exam</button>
        </div>
    </div>
</template>
<style scoped></style>