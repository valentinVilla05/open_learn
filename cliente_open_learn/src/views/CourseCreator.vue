<script setup>
import { ref, watch, watchEffect, onMounted } from 'vue';
import Swal from 'sweetalert2';
import { userAuth } from '@/utils/userAuth';
import router from '@/router';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});
const loguedUser = ref(null);
const courseData = ref({
    teacher_id: '',
    title: '',
    description: '',
    privacy: '',
    image: '',
    max_students: '',
    subject: '',
    duration: ''
});

function cleanForm() {
    courseData.value.title = '';
    courseData.value.description = '';
    courseData.value.teacher_id = '';
    courseData.value.privacy = '';
    courseData.value.image = '';
    courseData.value.max_students = '';
    courseData.value.subject = onMounted(async () => {
        const user = await userAuth(props.userAuth);
        if (user) {
            loguedUser.value = user;
            if (loguedUser.value.rol !== 'admin' || loguedUser.value.rol !== 'teacher') {
                Swal.fire({
                    icon: "error",
                    title: "Access Denied",
                    text: "You do not have permission to access this control panel.",
                });
                router.push('/');
            }
        } else {
            Swal.fire({
                icon: "error",
                title: "You need to log in to be able to see this course",
                text: "Please log in to continue.",
            });
            router.push('/'); // Redirect to login if user is not logged in
        }
    });
}
const teacherList = ref([]) // Get all the teachers

function getTeacher() {
    fetch('https://apiopenlearn.onrender.com/api/users', {
        method: 'GET',
    })
        .then(response => response.json())
        .then(data => {
            teacherList.value = data.filter(teacher => teacher.rol === 'teacher');
            console.log(teacherList.value);
        })
        .catch(error => console.log('Error:', error));
}
getTeacher();

function createCourse() {
    courseData.value.max_students = Number(courseData.value.max_students);
    courseData.value.duration = String(courseData.value.duration) + " hours";
    if (courseData.value.image === '') {
        courseData.value.image = null;
    }
    fetch('https://apiopenlearn.onrender.com/api/courses', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${props.userAuth}`,
            'Accept': 'application/json',
        },
        body: JSON.stringify(courseData.value)
    })
        .then(response => response.json())
        .then(data => {
            Swal.fire({
                title: "Course created!",
                text: "The course has been created!",
                icon: "success"
            }).then(() => {
                cleanForm(); // Clean the inputs
            });
        })
        .catch(error => console.error('Error:', error));

}

// Input validation
const validPrivacy = ref(false);
const validTeacher = ref(false);
const validImage = ref(null);
const validForm = ref(null);


// Image Validation
async function isImageUrl(url) {
    // Try a fetch to the image url
    try {
        const response = await fetch(url, { method: 'HEAD' });
        const contentType = response.headers.get('Content-Type');
        const isValid = contentType && contentType.startsWith('image/');
        validImage.value = isValid;
        return isValid; // If the url is a valid image, return valid
    } catch (error) {
        validImage.value = false;
        return false;
    }
}

// Control the state of the image url everytime
watch(() => courseData.value.image, (newUrl) => {
    if (newUrl) {
        isImageUrl(newUrl);
    } else {
        validImage.value = null;
    }
});

watchEffect(() => {
    validPrivacy.value = courseData.value.privacy === 'public' || courseData.value.privacy === 'private';
    validTeacher.value = teacherList.value.some(teacher => teacher.id === courseData.value.teacher_id);

    const allFieldsFilled = courseData.value.title.trim() !== '' &&
        courseData.value.description.trim() !== '' &&
        courseData.value.subject.trim() !== '' &&
        courseData.value.max_students !== '' &&
        !isNaN(courseData.value.max_students) &&
        Number(courseData.value.max_students) > 0;

    validForm.value = validPrivacy.value && validTeacher.value && allFieldsFilled;
});


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
});

</script>
<template>
    <div class="w-75 text-start ms-5">
        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="mt-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <RouterLink to="/" class="text-decoration-none">Home</RouterLink>
                </li>
                <li class="breadcrumb-item">
                    <RouterLink to="/controlPanel" class="text-decoration-none text-">Control Panel</RouterLink>
                </li>
                <li class="breadcrumb-item active" aria-current="page">Course Creator</li>
            </ol>
        </nav>
    </div>
    <div class="container">
        <h2 class="text-center">Create a new course:</h2>
        <div
            class="container shadow rounded w-50 h-75 border d-flex justify-content-center align-items-center flex-column mt-3">
            <div class="input-group mt-3 position-relative">
                <label class="input-group-text" for="title">Title:<span style="color: red;">*</span></label>
                <input type="text" name="title" placeholder="Example: HTML5 & CSS3" class="form-control"
                    v-model="courseData.title" />
            </div>

            <div class="input-group mt-3 position-relative">
                <label class="input-group-text" for="teacher">Teacher:<span style="color: red;">*</span></label>
                <select name="teacher" class="form-control" v-model="courseData.teacher_id">
                    <option v-for="teacher in teacherList" :key="teacher.id" :value="teacher.id">{{ teacher.name }}
                    </option>
                </select>
            </div>

            <div class="input-group mt-3 position-relative h-auto">
                <label class="input-group-text" for="description">Description:<span style="color: red;">*</span></label>
                <textarea type="text" name="description" placeholder="Learn everything about..." class="form-control"
                    v-model="courseData.description" />
            </div>

            <div class="input-group mt-3 mb-3 position-relative">
                <label class="input-group-text" for="privacy">Privacy:<span style="color: red;">*</span></label>
                <select name="privacy" class="form-control" v-model="courseData.privacy">
                    <option value="public">Public</option>
                    <option value="private">Private</option>
                </select>
            </div>
            <div class="w-100 d-flex flex-column align-items-center justify-content-center">
                <div class="imageContainer w-100 d-flex justify-content-center">

                    <!-- Valid image -->
                    <img v-if="validImage" :src="courseData.image" class="image w-100" alt="Course image" />

                    <!-- Empty/Invalid image -->
                    <div v-if="validImage === false || !courseData.image"
                        class="w-100 mt-3 d-flex flex-column align-items-center">
                        <img src="/lens.png" style="max-width: 2.5em;" alt="select an image" />
                        <p class="text-muted">
                            {{ courseData.image && !validImage ? 'Invalid image URL' : 'Write an image URL below' }}
                        </p>
                    </div>
                </div>

                <div class="input-group position-relative mt-3">
                    <label class="input-group-text" for="image">Image: </label>
                    <input type="url" name="image" id="image" v-model="courseData.image"
                        placeholder="https://example.com/image.jpg" class="form-control" />
                </div>
            </div>
            <div class="input-group mt-3 position-relative">
                <label class="input-group-text" for="max_students">Max. Students:<span style="color: red;">*</span></label>
                <input type="number" min="1" name="max_students" class="form-control" v-model="courseData.max_students">
            </div>
            <div class="input-group mt-3 position-relative">
                <label class="input-group-text" for="subject">Subject:<span style="color: red;">*</span></label>
                <input type="text" name="subject" placeholder="Example: Frontend" class="form-control"
                    v-model="courseData.subject">
            </div>
            <div class="input-group mt-3 mb-3 position-relative">
                <label class="input-group-text" for="max_students">Duration: </label>
                <input type="number" name="duration" class="form-control" v-model="courseData.duration">
                <input class="form-control" value="hours" readonly>
            </div>
            <div class="w-100 d-flex justify-content-between">
                <button class="btn buttonClean p-2 m-2" @click="cleanForm">
                    Clean data
                </button>
                <button class="btn buttonCreate p-2 m-2" @click="createCourse" :disabled="!validForm">
                    Create
                </button>
            </div>
        </div>
    </div>
</template>
<style scoped>
.imageContainer {
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 1em;
    background-color: #f8f9fa;
    margin-bottom: 1em;
    width: 100%;
    max-width: 500px;
}


.image {
    width: 50%;
    height: 20em;
    object-fit: cover;
}

.buttonClean {
    background-color: #FCDB77;
}

.buttonClean:hover {
    background-color: #ffe8a2;
}

.buttonCreate {
    background-color: #6EB183;
}

.buttonCreate:hover {
    background-color: #97cea8;
}
</style>