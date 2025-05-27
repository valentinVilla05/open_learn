<script setup>
import { ref, reactive, watch, onMounted } from 'vue';
import { formatDate } from '@/utils/formatDate';
import Swal from 'sweetalert2';
import router from '@/router';
import { userAuth } from '@/utils/userAuth';

const props = defineProps({
    userAuth: {
        type: String,
        required: false,
    },
});

const loguedUser = ref(null);

async function getUser(token) {
    if (!token) {
        loguedUser.value = null;
        return;
    }

    try {
        const response = await fetch('http://localhost:8000/api/user', {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Accept': 'application/json',
            },
        });

        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.message || 'Error fetching user data');
        }

        const data = await response.json();
        loguedUser.value = data;

    } catch (error) {
        console.error('Error fetching user:', error.message);
        loguedUser.value = null;
    }
}
onMounted(async () => {
    const user = await userAuth(props.userAuth);
    if (user) {
        loguedUser.value = user;
    } else {
        router.push('/catalog');
    }

    getUser(props.userAuth);

});
</script>
<template>
    <div class="background w-100 d-flex justify-content-center align-items-center py-5">
        <div class="container w-25 h-75 border d-flex justify-content-center align-items-center flex-column mt-5"
            v-if="loguedUser">
            <h2>Personal information:</h2>

            <div class="input-group position-relative">
                <label class="input-group-text" for="name">Name: </label>
                <input type="text" name="name" class="form-control" :value="loguedUser.name" readonly />
            </div>

            <div class="input-group position-relative">
                <label class="input-group-text" for="email">Email: </label>
                <input type="text" name="email" class="form-control" :value="loguedUser.email" readonly>
            </div>

            <div class="input-group position-relative">
                <label class="input-group-text" for="rol">Rol: </label>
                <input type="text" name="rol" class="form-control" :value="loguedUser.rol" readonly>
            </div>

            <div class="input-group position-relative">
                <label class="input-group-text" for="register_date">You joined us the: </label>
                <input type="text" name="register_date" class="form-control"
                    :value="formatDate(loguedUser.register_date)" readonly>
            </div>
        </div>
    </div>
</template>
<style scoped>
.background {
    overflow: hidden;
    background: radial-gradient(circle at 0% 0%, #8EC8EC 80%, transparent 50%),
        radial-gradient(circle at 70% 70%, #DCFFC8 20%, transparent 50%),
        radial-gradient(circle at 80% 20%, #FF9FB2 20%, transparent 50%),
        radial-gradient(circle at 20% 80%, #FCDB77 20%, transparent 50%),
        radial-gradient(circle at 50% 50%, #6EB183 25%, transparent 50%);
    background-color: #8EC8EC;
    background-blend-mode: lighten;
}

.container {
    background-color: #fff;
    border-radius: 1em;
    padding: 2em;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.input-group {
    width: 20em;
    margin: 1em 0;
}
</style>