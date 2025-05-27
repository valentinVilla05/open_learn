<script setup>
import ControlPanelAdmin from '@/components/ControlPanelAdmin.vue';
import { motion } from 'motion-v';
import { ref, onMounted } from 'vue';
import { userAuth } from '@/utils/userAuth';
import ControlPanelTeacher from '@/components/ControlPanelTeacher.vue';
import Swal from 'sweetalert2';
import router from '@/router';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

const loguedUser = ref(null);

onMounted(async () => {
    const user = await userAuth(props.userAuth);
    if (user) {
        loguedUser.value = user;
        
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
        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="mt-5">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <RouterLink to="/" class="text-decoration-none text-">Home</RouterLink>
                </li>
                <li class="breadcrumb-item active" aria-current="page">Control Panel</li>
            </ol>
        </nav>
    </div>
    <ControlPanelAdmin :userAuth="props.userAuth" v-if="loguedUser?.rol === 'admin'"></ControlPanelAdmin>
    <ControlPanelTeacher :userAuth="props.userAuth" v-if="loguedUser?.rol === 'teacher'"></ControlPanelTeacher>
</template>
<style scoped></style>