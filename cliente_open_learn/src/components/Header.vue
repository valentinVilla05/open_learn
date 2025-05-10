<script setup>
import { onMounted, onBeforeUnmount, ref } from 'vue';
import router from '@/router';
import { useRoute } from 'vue-router';
import Swal from 'sweetalert2'; // Import SweetAlert2 for confirmation messages

// Emit to close session
const emit = defineEmits(['session-closed']);

const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

// Check if the token is present and valid
async function validateToken() {
    if (!props.userAuth) return;

    try {
        const response = await fetch('http://localhost:8000/api/user', {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${props.userAuth}`,
                'Accept': 'application/json',
            },
        });

        if (!response.ok) {
            const errorData = await response.json();
            logOut(); // Define or import this function
            Swal.fire({
                icon: "error",
                title: "Oops...",
                text: "It seems that your session has expired.",
                confirmButtonText: 'Go to log in',
            }).then(() => {
                router.push('/login'); // Redirect to login page
            });
            throw new Error(errorData.message || 'Error fetching user data');
        }

        // Token is valid; you can proceed here if needed
    } catch (error) {
        console.error('Error fetching user:', error.message);
    }
}

// Periodic validation function
let validationInterval = null;

// Start validating the token on mount
onMounted(() => {
    validateToken();  // Validate once when the component is mounted
    // Set interval to validate token every 5 minutes (300,000 ms)
    validationInterval = setInterval(validateToken, 300000);
});

// Clean up the interval on component unmount
onBeforeUnmount(() => {
    if (validationInterval) {
        clearInterval(validationInterval);
    }
});


function logOut() {
    // Emit the event to close the session
    emit('session-closed', null);

    // Clear session storage
    sessionStorage.removeItem('acces_token');
    router.push('/'); // Redirect to home page
}

const route = useRoute();

const navItems = [
    { name: 'Home', path: '/' },
    { name: 'Catalog', path: '/catalog' },
    { name: 'My academy', path: '/my_academy' },
    { name: 'About', path: '/about' }
];

</script>
<template>
    <header class="text-white p-3">
        <div class="container d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center">
                <!-- Logo / Home button -->
                <RouterLink to="/"><img src="/logo.png" alt="Logo" class="img-fluid" style="max-width: 40px;">
                </RouterLink>
                <RouterLink to="/" class="text-decoration-none">
                    <h1 class="mb-0 ms-3 text-decoration-none">OpenLearn </h1>
                </RouterLink>
            </div>

            <!-- Navegation menu -->
            <nav class="navbar navbar-expand-md navbar-light">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                    <ul class="navbar-nav ms-auto text-center">
                        <li v-for="(item, i) in navItems" :key="i" class="nav-item position-relative">
                            <RouterLink :to="item.path"
                                class="nav-link nav-underline-link position-relative pb-1 fw-bold text-decoration-none ms-5 me-5"
                                :class="{ active: $route.path === item.path }">
                                {{ item.name }}
                            </RouterLink>
                        </li>
                        <li class="nav-item">
                            <RouterLink class="nav-link fs-6 fw-bold ms-5 border border-2 rounded-2" to="/login"
                                v-if="!userAuth">Log in</RouterLink>
                        </li>
                    </ul>

                    <!-- Profile menu -->
                    <div class="dropdown ms-3" v-if="userAuth">
                        <button class="btn btn-secondary dropdown-toggle d-flex align-items-center" type="button"
                            id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
                            <img src="/profile_icon.png" alt="Perfil" class="img-fluid me-2"
                                style="max-width: 50px; height: auto;">
                            <span class="visually-hidden">Open personal menu</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton1">
                            <li>
                                <RouterLink class="dropdown-item" to="/">My account</RouterLink>
                            </li>
                            <li>
                                <RouterLink class="dropdown-item" to="/controlPanel">Control Panel</RouterLink>
                            </li>
                            <li>
                                <a class="dropdown-item text-danger" @click="logOut">Log out</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </div>
    </header>

</template>
<style scoped>
header {
    background-color: #8EC8EC;
}

h1 {
    color: white;
}

.nav-link {
    color: white;
}

#dropdownMenuButton1 {
    border: 0;
    background-color: #8EC8EC;
    height: 4em;
}

/* Estilos del menú desplegable */
.dropdown-menu {
    font-size: 1.1rem;
    min-width: 180px;
}

.dropdown-item {
    padding: 0.625em;
}

.dropdown-item:hover {
    background-color: rgb(199, 231, 241);
    color: black;
}

.dropdown-item:active {
    background-color: lightgray;
    color: black;
}

.router-link-active.nav-link {
    position: relative;
    background-color: #7db0cf;
    border-radius: 0.5rem;
    transition: background-color 0.3s ease;

}

.nav-underline-link {
    color: white;
    transition: color 0.3s ease;
}

.router-link-active.nav-link {
    color: white;
}

.nav-underline-link::after {
    content: '';
    position: absolute;
    left: 0;
    bottom: 0px;
    width: 0%;
    height: 4px;
    background-color: white;
    transition: width 0.4s ease;
    border-radius: 2px;
}

.nav-underline-link.active::after {
    width: 100%;
}

.nav-underline-link:hover::after {
    width: 100%;
}
</style>