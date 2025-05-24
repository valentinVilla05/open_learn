<script setup>
import { motion } from 'motion-v';
</script>
<template>
    <div class="container w-100 h-100 d-flex flex-row justify-content-evenly mt-5">
        <motion.div class="card w-50 ms-5 me-5 shadow" :while-hover="{ scale: 1.10 }">
            <img src="/courseManagement.png" class="card-img-top" alt="User management">
            <div class="card-body">
                <h5 class="card-title">Courses Management</h5>
                <p class="card-text">Manage the registered courses.</p>
                <div class="text-end me-3">
                    <RouterLink to="/controlPanel/courseManagement" class="btn border">Go manage</RouterLink>
                </div>
            </div>
        </motion.div>

        <motion.div class="card w-50 ms-5 me-5 shadow" :while-hover="{ scale: 1.10 }">
            <img src="/userManagement.png" class="card-img-top" alt="User management">
            <div class="card-body">
                <h5 class="card-title">User Management</h5>
                <p class="card-text">Manage the registered users rol or delete users.</p>
                <div class="text-end me-3">
                    <RouterLink to="/controlPanel/userManagement" class="btn border">Go manage</RouterLink>
                </div>
            </div>
        </motion.div>
    </div>
    <div class="container w-100 h-100 d-flex flex-row justify-content-evenly mt-5">
        <motion.div class="card w-50 ms-5 me-5 shadow" :while-hover="{ scale: 1.10 }">
            <img src="/courseCreator.png" class="card-img-top" alt="Course creator">
            <div class="card-body">
                <h5 class="card-title">Course creator</h5>
                <p class="card-text">Create new courses and expand the limits of the knowledge.</p>
                <div class="text-end me-3">
                    <RouterLink to="/controlPanel/courseCreator" class="btn border">Go manage</RouterLink>
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
}
</style>