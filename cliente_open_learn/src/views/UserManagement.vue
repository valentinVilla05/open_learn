<script setup>
// Importamos todo lo necesario;
import { onMounted, ref, computed } from 'vue';
import { Modal } from "bootstrap";
import Swal from 'sweetalert2'; // Importamos SweetAlert2 para mostrar mensajes de confirmacion https://sweetalert2.github.io/;

//En caso de acceder sin estar logueado te redirige a Login;
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

// Declaramos la URL para la API para mostrar todos los usuarios
const API = "http://localhost:8000/api"
let users = ref([]);

// Conseguimos un array con los usuarios mediante un fetch;
async function getData() {
    try {
        const response = await fetch(API + "/users");

        if (!response.ok) {
            throw new Error("No tengo ni idea de lo que estoy haciendo;");
        }

        users.value = await response.json(); // Guardamos los datos en la variable global
    } catch (error) {
        alert(`Error al obtener datos: ${error.message}`);
    }
}

onMounted(getData); // Utilizamos onMounted para que cargue los datos una vez se haya cargado los componentes;

// Función para actualizar el Rol de un usuario;
function updateRol(id, rol) {
    fetch(`http://localhost:8000/api/users/users/${user_id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ rol: rol })
    })
        .then(response => response.json())
        .then(data => console.log('Respuesta:', data))
        .catch(error => console.error('Error:', error));

}

const selectedUser = ref(null); // Variable del usuario seleccionado que declaramos para manejarlo mediante el modal
let modalInstanceUser = null;  // Declaramos una variable para instanciar el modal

// Cargar el modal al montar el componente
onMounted(() => {
    modalInstanceUser = new Modal(document.getElementById("deleteModal"));
});

// Abrir el modal y asignar el usuario seleccionado
function openModal(user) {
    selectedUser.value = user;
    modalInstanceUser.show(); // Mostramos el modal
}

// Funcion para eliminar un usuario
function deleteUser(id) {
    fetch(`http://localhost:8000/api/users/usuarios?id=${id}`, {
        method: 'DELETE',
    })
        .then(() => getData()) // Llamar getData() solo cuando DELETE haya finalizado
        .catch(error => console.error('Error:', error));
    modalInstanceUser.hide();
}

////////////////////////////////
// Paginacion de los usuarios //
////////////////////////////////
let currentPage = ref(1);
let usersPerPage = 6;
let totalPages = computed(() => Math.ceil(users.value.length / usersPerPage)); // Calculamos el numero de paginas totales, lo hacemos computed para que se actulice automaticamente cuando el numero de usuarios cambie

let paginatedUsers = computed(() => {
    const start = (currentPage.value - 1) * usersPerPage; // Calculamos el inicio de los registros de la pagina
    const end = start + usersPerPage; // Al numero inicial le sumamos los 10 registros que queremos mostrar
    return users.value.slice(start, end); // Devolvemos los registros que queremos mostrar
})

function nextPage() {
    if (currentPage.value < Math.ceil(users.value.length / usersPerPage)) { // Comprobamos que no estemos en la utlima pagina
        currentPage.value++;
    }
}
function previousPage() {
    if (currentPage.value > 1) { // Comprobamos que no estamos en la primera pagina;
        currentPage.value--;
    }
}
</script>
<template>
    <div class="tab-pane fade show active table-responsive w-100 border shadow" id="home-tab-pane" role="tabpanel"
        aria-labelledby="home-tab" tabindex="0">
        <table class="table table-striped table-hover align-middle" id="userTable">
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
                <tr v-for="(user) in paginatedUsers" :key="user.id">
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
                    <td v-else><button type="button" @click="openModal(user)" class="deleteButton"><img src="/bin.png" alt="bin"></button></td>
                </tr>
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
                    <h5 class="modal-title" id="deleteModalLabel">¿Está seguro que quiere borrar este usuario?</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    El usuario <b>{{ selectedUser?.name }}</b> con el ID: <b>{{ selectedUser?.id }}</b> será eliminado
                    permanentemente.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" @click="deleteUser(selectedUser?.id)">Eliminar
                        usuario</button>
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
}

#userTable select {
    border: none;
}

.table-hover tbody tr:hover td,
.table-hover tbody tr:hover th {
    background-color: rgb(206, 247, 202) !important;
}

.table-hover tbody tr:hover {
    border: 1px solid black;
}
</style>