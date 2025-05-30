<script setup>
import { ref, watch, onMounted } from 'vue';
import router from '@/router';
import { motion } from 'motion-v';
import { userAuth } from '@/utils/userAuth';

const emit = defineEmits(['session-closed']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false
    }
});

const loguedUser = ref(null);

// Watch the prop: when userAuth changes, fetch the user data again
watch(() => props.userAuth,
    async (user) => {
        if (user) {
            try {
                loguedUser.value = await userAuth(user);
            } catch {
                loguedUser.value = null;
            }
        } else {
            loguedUser.value = null;
        }
    },
    { immediate: true } // run once on component mount

);

function logOut() {
    emit('session-closed', null);
    sessionStorage.removeItem('sessionID');
    router.push('/');
}

</script>

<template>
    <header class="text-white p-3 bg-custom">
        <div class="container-fluid d-flex flex-column flex-md-row align-items-center justify-content-between">
            <div class="d-flex align-items-center mb-3 mb-md-0">
                <RouterLink to="/" class="d-flex align-items-center text-decoration-none">
                    <img src="/logo.png" alt="Logo" class="img-fluid" style="max-width: 40px; height: auto;" />
                    <h1 class="mb-0 ms-2 fs-4 d-none d-sm-block text-white">OpenLearn</h1>
                </RouterLink>
            </div>

            <nav class="navbar navbar-light w-100 w-md-auto">
                <div class="d-flex flex-column flex-md-row justify-content-end align-items-center w-100" id="navbarNav">
                    <ul class="navbar-nav text-center flex-column flex-md-row justify-content-center">
                        <li class="nav-item">
                            <RouterLink v-if="loguedUser" to="/" class="nav-link fw-bold text-white mx-2 bar-effect">Home
                            </RouterLink>
                        </li>
                        <li class="nav-item">
                            <RouterLink to="/catalog" class="nav-link fw-bold text-white mx-2 bar-effect">Catalog</RouterLink>
                        </li>
                        <li class="nav-item">
                            <RouterLink v-if="loguedUser" to="/my_academy" class="nav-link fw-bold text-white mx-2 bar-effect">My
                                Academy</RouterLink>
                        </li>
                        <li class="nav-item">
                            <RouterLink to="/about" class="nav-link fw-bold text-white mx-2 bar-effect">About</RouterLink>
                        </li>
                        <li class="nav-item">
                            <RouterLink to="/faq" class="nav-link fw-bold text-white mx-2 bar-effect">FAQ</RouterLink>
                        </li>
                        <li class="nav-item">
                            <RouterLink class="nav-link fw-bold border rounded px-2 ms-2 text-white" to="/login"
                                v-if="!loguedUser">Log in</RouterLink>
                        </li>
                    </ul>

                    <div class="dropdown ms-3 d-flex justify-content-center" v-if="loguedUser">
                        <button class="profile-btn dropdown-toggle d-flex align-items-center" type="button"
                            data-bs-toggle="dropdown" aria-expanded="false">
                            <img src="/profile_icon.png" alt="Profile" class="profile-icon me-2" />
                            <span class="visually-hidden">Open personal menu</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <RouterLink class="dropdown-item" to="/myAccount">My account</RouterLink>
                            </li>
                            <li>
                                <RouterLink class="dropdown-item" to="/controlPanel"
                                    v-if="loguedUser?.rol === 'admin' || loguedUser?.rol === 'teacher'">Control Panel
                                </RouterLink>
                            </li>
                            <li><a class="dropdown-item text-danger" @click="logOut">Log out</a></li>
                        </ul>
                    </div>
                </div>
            </nav>
        </div>
    </header>
</template>

<style scoped>
.bg-custom {
    background-color: #8EC8EC;
}

h1 {
    color: white;
}

.nav-link {
    padding: 0.5em 1em;
    color: white;
    transition: background-color 0.3s ease;
}

.nav-link:hover {
    background-color: #73BBE7;
    border-radius: 5px;
}

.router-link-active.nav-link {
    background-color: #62B2E4;
    border-radius: 0.5rem;
}

.bar-effect {
    position: relative; 
    overflow: hidden;
}

.bar-effect::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 0.25em; 
    background-color: white; 
    transform: translateX(-100%); 
    transition: transform 0.3s ease-out; 
}

.bar-effect:hover::after {
    transform: translateX(0);
}


.dropdown-menu {
    font-size: 1rem;
}

.dropdown-item {
    padding: 0.5rem 1rem;
}

.dropdown-item:hover {
    background-color: rgb(199, 231, 241);
    color: black;
}

.dropdown-item:active {
    background-color: lightgray;
    color: black;
}

.profile-btn {
    border: none;
    background: transparent;
}

.profile-icon {
    width: 3em;
    height: 3em;
    object-fit: contain;
}
</style>