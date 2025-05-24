<script setup>
import { motion } from 'motion-v';
</script>
<template>
    <div class="container w-100 h-100 d-flex flex-row justify-content-evenly mt-5">
        <motion.div class="card w-50 ms-5 me-5 shadow" :while-hover="{ scale: 1.10 }">
            <img src="/exam_creator.png" class="card-img-top" alt="User management">
            <div class="card-body">
                <h5 class="card-title">Exams Management</h5>
                <p class="card-text">Manage the exams from your courses.</p>
                <div class="text-end me-3">
                    <RouterLink to="/controlPanel/examManagement" class="btn border">Go manage</RouterLink>
                </div>
            </div>
        </motion.div>

        <motion.div class="card w-50 ms-5 me-5 shadow" :while-hover="{ scale: 1.10 }">
            <img src="/question_creator.png" class="card-img-top" alt="User management">
            <div class="card-body">
                <h5 class="card-title">Question Creator</h5>
                <p class="card-text">Create questions for your future exams.</p>
                <div class="text-end me-3">
                    <RouterLink to="/controlPanel/questionCreator" class="btn border">Go manage</RouterLink>
                </div>
            </div>
        </motion.div>
    </div>
    <div class="container w-100 h-100 d-flex flex-row justify-content-evenly mt-5">
        <motion.div class="card w-50 ms-5 me-5 shadow" :while-hover="{ scale: 1.10 }">
            <img src="/question_management.png" class="card-img-top" alt="Course creator">
            <div class="card-body">
                <h5 class="card-title">Question pool</h5>
                <p class="card-text">Manage all your questions created.</p>
                <div class="text-end me-3">
                    <RouterLink to="/controlPanel/questionManagement" class="btn border">Go manage</RouterLink>
                </div>
            </div>
        </motion.div>
    </div>
</template>
<style scoped>
p {
    margin-block: 1lh;
}

.card img {
    height: 18em;
    object-fit: cover;
    object-position: center;
    background-color: #DCFFC8;
}</style>