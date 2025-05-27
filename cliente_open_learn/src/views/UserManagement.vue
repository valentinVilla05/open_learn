<script setup>
// Importamos todo lo necesario;
import { onMounted, ref, computed } from 'vue';
import { Modal } from "bootstrap";
import Swal from 'sweetalert2';
import { motion } from 'motion-v';
import { userAuth } from '@/utils/userAuth';
import router from '@/router';

const emit = defineEmits(['sessionStarted']);

const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

// Get the user data;
const loguedUser = ref(null);
let users = ref([]);

// Conseguimos un array con los usuarios mediante un fetch;
async function getData() {
    try {
        const response = await fetch(`http://localhost:8000/api/users`);

        if (!response.ok) {
            throw new Error("Error fetching data");
        }

        users.value = await response.json(); // We save the users in the variable users;
    } catch (error) {
        console.log(`Error getting the data: ${error.message}`);
    }
}

onMounted(getData);

// Function to update the Rol
function updateRol(user_id, rol) {
    fetch(`http://localhost:8000/api/users/${user_id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${props.userAuth}`,
            'Accept': 'application/json',
        },
        body: JSON.stringify({ rol: rol }),
    })
        .then(response => response.json())
        .then(data => console.log('Response:', data))
        .catch(error => console.error('Error:', error));

}

const selectedUser = ref(null); // Variable to save the selected user for the modal
let modalInstanceUser = null;  // Declare the modal instance variable



// Open the modal and assign the selected user
function openModal(user) {
    selectedUser.value = user;
    modalInstanceUser.show(); // Mostramos el modal
}

// Function to delete the user
function deleteUser(user_id) {
    fetch(`http://localhost:8000/api/users/${user_id}`, {
        method: 'DELETE',
        headers: {
            'Authorization': `Bearer ${props.userAuth}`,
            'Accept': 'application/json',
        },
    })
        .then(() => {
            getData()
            Swal.fire({
                title: "User deleted!",
                text: "The user has been deleted successfully.",
                icon: "success"
            });
        }) // Call getData to refresh the user list
        .catch(error => console.error('Error:', error));
    modalInstanceUser.hide();
}

////////////////////////////////
/////// User Pagination ////////
////////////////////////////////
let currentPage = ref(1);
let usersPerPage = 10;
let totalPages = computed(() => Math.ceil(users.value.length / usersPerPage));

let paginatedUsers = computed(() => {
    const start = (currentPage.value - 1) * usersPerPage;
    const end = start + usersPerPage;
    return users.value.slice(start, end);
})

function nextPage() {
    if (currentPage.value < Math.ceil(users.value.length / usersPerPage)) { // Check if we are not on the last page;
        currentPage.value++;
    }
}
function previousPage() {
    if (currentPage.value > 1) { // Check if we are not on the first page;
        currentPage.value--;
    }
}


onMounted(async () => {
    const user = await userAuth(props.userAuth);
    if (user) {
        loguedUser.value = user
        if (loguedUser.value && loguedUser.value.rol != 'admin') {
        Swal.fire({
            icon: "error",
            title: "Oops...",
            text: "You don't have permission to access this page.",
            confirmButtonText: 'Go to home',
        })
        router.push('/'); // Redirect to home page
    }
    } else {
        Swal.fire({
            icon: "error",
            title: "You need to log in to access here.",
            text: "Please log in to continue.",
        });
        router.push('/'); // Redirect to login if user is not logged in
    }

    const modalElement = document.getElementById("modalUpdate");
    modalUpdate = new Modal(modalElement);
    modalInstanceUser = new Modal(document.getElementById("deleteModal"));
});
</script>
<template>
    <div class="w-75 text-start ms-5">
        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="mt-5">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <RouterLink to="/" class="text-decoration-none text-">Home</RouterLink>
                </li>
                <li class="breadcrumb-item">
                    <RouterLink to="/controlPanel" class="text-decoration-none text-">Control Panel</RouterLink>
                </li>
                <li class="breadcrumb-item active" aria-current="page">User Management</li>
            </ol>
        </nav>
    </div>
    <h2 class="w-75 text-start text-muted">Active users in OpenLearn <span class="badge text-bg-secondary rounded-5">{{
        users.length + 1 }}</span></h2>
    <div class="tab-pane fade show active table-responsive w-75 border shadow mt-3" id="home-tab-pane" role="tabpanel"
        aria-labelledby="home-tab" tabindex="0">
        <table class="table table-striped table-hover align-middle p-4" id="userTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Rol</th>
                    <th>Manage</th>
                </tr>
            </thead>
            <tbody>
                <motion.tr v-for="(user) in paginatedUsers" :key="user.id" class="border-none"
                    :whileHover="{ scale: 1.01 }" :transition="{ duration: 0.5 }">
                    <td>{{ user.id }}</td>
                    <td>{{ user.name }}</td>
                    <td>{{ user.email }}</td>
                    <td v-if="user.rol == 'admin'">
                        <p>Admin</p>
                    </td>
                    <td v-else>
                        <select v-model="user.rol" @change="updateRol(user.id, user.rol)" name="rol" id="userRol">
                            <option value="teacher">Teacher</option>
                            <option value="student">Student</option>
                        </select>
                    </td>
                    <td v-if="user.rol == 'admin'"><button type="button" disabled class="unavailable">No
                            disponible</button></td>
                    <td v-else><button type="button" @click="openModal(user)" class="deleteButton"><img src="/bin.png"
                                alt="bin"></button></td>
                </motion.tr>
            </tbody>
        </table>
        <nav aria-label="Paginacion de usuarios">
            <ul class="pagination justify-content-center">
                <li class="page-item" :class="{ disabled: currentPage === 1 }">
                    <a class="page-link" href="#" @click.prevent="previousPage">Previous</a>
                </li>
                <li class="page-item" v-for="page in totalPages" :key="page" :class="{ active: currentPage === page }">
                    <a class="page-link" href="#" @click.prevent="currentPage = page">{{ page }}</a>
                </li>
                <li class="page-item" :class="{ disabled: currentPage === totalPages }">
                    <a class="page-link" href="#" @click.prevent="nextPage">Next</a>
                </li>
            </ul>
        </nav>
    </div>
    <!-- Modal de confirmacion de eliminacion de usuario-->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Are you sure you want to erase this user?</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    The user <b>{{ selectedUser?.name }}</b> with ID: <b>{{ selectedUser?.id }}</b> will be erased
                    permanently.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" @click="deleteUser(selectedUser?.id)">Delete
                        user.</button>
                </div>
            </div>
        </div>
    </div>
</template>
<style scoped>
.deleteButton {
    border: none;
    background-color: transparent;
}

.deleteButton img {
    width: 35px;
    transition: ease-in 0.2s;
}

.deleteButton img:hover {
    width: 2.5em;
}

.unavailable {
    border: none;
}

#userTable {
    text-align: center;
    align-items: center;
    overflow-x: hidden !important;

}

#userTable select {
    border: none;
}

.table-hover tbody tr:hover td,
.table-hover tbody tr:hover th {
    background-color: #daf1ff !important;
}

.table-hover tbody tr:hover {
    border: 1px solid black;
}

.page-item.active .page-link {
    border: #73BBE7;
    background-color: #8EC8EC;
}

motion-tr {
    transform-origin: center;
}

.badge {
    background: linear-gradient(rgb(220, 255, 200), rgba(110, 177, 131, 0.7), rgb(220, 255, 200)) !important;
}
</style>