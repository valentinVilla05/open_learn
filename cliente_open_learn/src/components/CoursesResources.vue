<script setup>
import { onMounted, ref } from 'vue';
import { motion } from 'motion-v';
import { Modal } from 'bootstrap';
import Swal from 'sweetalert2';

const props = defineProps({
    userAuth: {
        type: String
    },
    course_id: {
        type: String,
    },
    teacherAssigned: {
        type: Boolean
    }
});

const resources = ref(null);
let modalUpdate = null;
const selectedResource = ref(null);
const addResouce = ref(false);

const resourceUpdatedData = ref({
    name: '',
    description: '',
    limit_date: '',
    url: ''
})

const newResourceData = ref({
    course_id: '',
    type: '',
    name: '',
    description: '',
    limit_date: '',
    url: ''
})


function getResources(course_id) {
    fetch(`http://localhost:8000/api/resources/${course_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            resources.value = data
            
        })
        .catch(error => console.log('Error:', error));
}

function createResource() {
    newResourceData.value.course_id = props.course_id;
    fetch('http://localhost:8000/api/resources', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${props.userAuth}`,
            'Accept': 'application/json',
        },
        body: JSON.stringify(newResourceData.value)
    })
        .then(response => response.json())
        .then(data => {
            Swal.fire({
                imageUrl: "/addResource.png",
                imageWidth: "15em",
                title: "Resource created!",
                text: "The resource was added to the course!",
            });
            getResources(props.course_id)
        })
        .catch(error => console.error('Error:', error));
}

function updateResource(resource_id) {
    fetch(`http://localhost:8000/api/resources/${resource_id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${props.userAuth}`,
            'Accept': 'application/json',
        },
        body: JSON.stringify(resourceUpdatedData.value)
    })
        .then(response => response.json())
        .then(data => {
            getResources(props.course_id);
            Swal.fire({
                title: "Resource updated!",
                text: "The information has been updated succesfully!",
                icon: "success"
            });
        })
}

function deleteResource(resource_id) {
    Swal.fire({
        title: "Are you sure?",
        text: "You won't be able to revert this!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, delete it!"
    }).then((result) => {
        if (result.isConfirmed) {
            fetch(`http://localhost:8000/api/resources/${resource_id}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${props.userAuth}`,
                    'Accept': 'application/json',
                },
            })
                .then(response => response.json())
                .then(data => {
                    Swal.fire({
                        title: "Deleted!",
                        text: "The resource has been deleted.",
                        icon: "success"
                    })
                    getResources(props.course_id);
                }

                )
                .catch(error => Swal.fire({
                    icon: "error",
                    title: "Oops...",
                    text: "Something went wrong deleting this resource!",
                    footer: 'Check your connection and try again later'
                }));
        }
    });
}

function cleanForm() {
    resourceUpdatedData.value.name = '';
    resourceUpdatedData.value.description = '';
    resourceUpdatedData.value.url = '';
    resourceUpdatedData.value.limit_date = '';

    newResourceData.value.course_id = '';
    newResourceData.value.name = '';
    newResourceData.value.type = '';
    newResourceData.value.description = '';
    newResourceData.value.limit_date = '';
    newResourceData.value.url = '';
}

function openModal(resource_id) {
    selectedResource.value = resource_id
    resourceUpdatedData.value.name = resources.value.find(resource => resource.id === resource_id).name;
    resourceUpdatedData.value.description = resources.value.find(resource => resource.id === resource_id).description;
    resourceUpdatedData.value.url = resources.value.find(resource => resource.id === resource_id).url;
    modalUpdate.show();
}

onMounted(() => {
    const modalElement = document.getElementById("editResourceModal");
    modalUpdate = new Modal(modalElement);
    getResources(props.course_id)

})

</script>
<template>
    <div class="w-100 fs-5 mt-2">
        <div class="d-flex justify-content-between align-items-center px-3">
            <div class="flex-grow-1 text-center">
                <p class="mb-0">Content</p>
            </div>
            <a v-if="teacherAssigned" class="fs-6 px-3 py-2 border-0 rounded btn" href="#resourceAdder"
                @click="addResouce = !addResouce"> Add resource
            </a>
        </div>
        <hr class="my-1">
    </div>



    <section>
        <motion.div class="resource w-100 m-2 d-flex flex-row border rounded" v-for="resource in resources"
            :while-hover="{ scale: 1.05 }">
            <div class="d-flex align-items-center border-end border-2">
                <img v-if="resource.type === 'link'" class="mx-2" style="min-height: fit-content; min-width: 2em;"
                    src="/link_icon.png" alt="link">
                <img v-if="resource.type === 'document'" class="mx-2" style="min-height: fit-content; min-width: 2em;"
                    src="/document_icon.png" alt="document">
                <img v-if="resource.type === 'video'" class="mx-2" style="min-height: fit-content; min-width: 2em;"
                    src="/video_icon.png" alt="video">
            </div>
            <p v-if="resource.type === 'link'"><a :href="resource.url" target="_blank"
                    class="text-black fw-bold m-3 text-decoration-none">{{ resource.name }}</a></p>
            <RouterLink v-else :to="{ name: 'resource', params: { course_id: course_id, resource_id: resource.id } }"
                class="text-black fw-bold m-3 text-decoration-none">{{ resource.name }}</RouterLink>
            <div class="dropdown d-flex justify-content-center align-items-center ms-auto me-2"
                v-if="props.teacherAssigned">
                <img src="/dots.png" alt="menu" class="dropdown-toggle" data-bs-toggle="dropdown"
                    data-bs-auto-close="true" aria-expanded="false">
                </img>
                <ul class="dropdown-menu">
                    <li><button class="dropdown-item" @click="openModal(resource.id)">Edit resource</button></li>
                    <li><button class="dropdown-item" @click="deleteResource(resource.id)">Delete Resource</button></li>
                </ul>
            </div>
        </motion.div>
    </section>

    <div id="resourceAdder" v-if="addResouce">
        <div
            class="container shadow rounded w-100 border d-flex justify-content-center align-items-center flex-column my-5">
            <h2>Create a new Resource</h2>
            <div class="input-group my-3 position-relative">
                <label class="input-group-text" for="name">Name:*</label>
                <input type="text" name="name" placeholder="Unit 5..." class="form-control"
                    v-model="newResourceData.name" />
            </div>
            <div class="input-group my-3 position-relative">
                <label class="input-group-text" for="type">Type:*</label>
                <select name="type" placeholder="document, url..." class="form-control" v-model="newResourceData.type">
                    <option value="document">Document</option>
                    <option value="url">URL</option>
                    <option value="video">Video</option>
                </select>
            </div>
            <div class="input-group my-3 position-relative">
                <label class="input-group-text" for="description">Description:</label>
                <input type="text" name="description" placeholder="Explanation above..." class="form-control"
                    v-model="newResourceData.description" />
            </div>
            <div class="input-group my-3 position-relative">
                <label class="input-group-text" for="url">URL:*</label>
                <input type="text" name="url" placeholder="Write an url to the content" class="form-control"
                    v-model="newResourceData.url" />
            </div>
        </div>
        <div class="w-100 d-flex justify-content-between">
            <button type="button" class="btn cancelButton" data-bs-dismiss="modal"
                @click="cleanForm(); addResouce = !addResouce">Close</button>
            <button type="button" class="btn" @click="createResource()">Create resource</button>
        </div>
    </div>

    <!-- Modal update resource -->
    <div class="modal fade" id="editResourceModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="exampleModalLabel">Update resource:</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div
                        class="container shadow rounded w-100 border d-flex justify-content-center align-items-center flex-column my-3">
                        <div class="input-group my-3 position-relative">
                            <label class="input-group-text" for="name">Name:*</label>
                            <input type="text" name="name" placeholder="" class="form-control"
                                v-model="resourceUpdatedData.name" />
                        </div>
                        <div class="input-group my-3 position-relative">
                            <label class="input-group-text" for="description">Description:*</label>
                            <input type="text" name="description" placeholder="" class="form-control"
                                v-model="resourceUpdatedData.description" />
                        </div>
                        <div class="input-group my-3 position-relative">
                            <label class="input-group-text" for="url">URL:*</label>
                            <input type="text" name="url" placeholder="" class="form-control"
                                v-model="resourceUpdatedData.url" />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn" data-bs-dismiss="modal" @click="cleanForm()">Close</button>
                        <button type="button" class="btn" @click="updateResource(selectedResource)">Save
                            changes</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<style scoped>
p {
    margin-block: 1lh
}

.resource {
    background-color: rgb(231, 231, 231);
}

.cancelButton {
    background-color: #96CCED !important;
}
</style>