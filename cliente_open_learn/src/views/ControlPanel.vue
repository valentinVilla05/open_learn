<script setup>
import { motion } from 'motion-v';



</script>
<template>
    <div class="w-75 text-start ms-5">
        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="mt-5">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><RouterLink to="/" class="text-decoration-none text-">Home</RouterLink></li>
                <li class="breadcrumb-item active" aria-current="page" >Control Panel</li>
            </ol>
        </nav>
    </div>
    <div class="container w-100 h-100 d-flex flex-row justify-content-evenly mt-5">
        <motion.div class="card w-50 h-100 ms-5 me-5" :while-hover="{ scale: 1.15 }">
            <img src="..." class="card-img-top" alt="User management">
            <div class="card-body">
                <h5 class="card-title">User Management</h5>
                <p class="card-text">Manage the registered users rol or delete users.</p>
                <div class="text-end me-3">
                    <RouterLink to="/controlPanel/userManagement" class="btn border">Go manage</RouterLink>
                </div>
            </div>
        </motion.div>

        <motion.div class="card w-50 h-100 ms-5 me-5" :while-hover="{ scale: 1.15 }">
            <img src="..." class="card-img-top" alt="User management">
            <div class="card-body">
                <h5 class="card-title">Courses Management</h5>
                <p class="card-text">Manage the registered courses.</p>
                <div class="text-end me-3">
                    <RouterLink to="/controlPanel/courseManagement" class="btn border">Go manage</RouterLink>
                </div>
            </div>
        </motion.div>
    </div>
</template>
<style scoped>
p {
    margin-block: 1lh;
}
</style>