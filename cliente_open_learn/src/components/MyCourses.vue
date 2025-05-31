<script setup>
import { computed, onMounted, ref } from 'vue';
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
const allCourses = ref(null);
const certificatesList = ref([]);
const userCoursesList = ref(null);

// Get all the courses
function getCourses() {
    fetch('http://localhost:8000/api/courses', {
        method: 'GET',
    }).then(response => response.json())
        .then(data => allCourses.value = data)
        .catch(error => console.log('Error:', error));
}
// Get all the courses from the user
function userCourses(user_id) {
    fetch(`http://localhost:8000/api/inscriptions/user/${user_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => userCoursesList.value = data)
        .catch(error => console.log('Error:', error));
}

const list = computed(() => {
    if (!userCoursesList.value || !allCourses.value) return [];

    return userCoursesList.value.map(inscription => allCourses.value.find(course => course.id === inscription.course_id)).filter(course => course !== undefined); // Get the information of the courses where the user in enrrolled
})

// Get the certificates from the user to know if the course is completed
function getCertificates(user_id) {
    fetch(`http://localhost:8000/api/certificates/user/${user_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            if (Array.isArray(data)) { // If the fetch return data, we save it in an array
                certificatesList.value = data;
            } else {
                certificatesList.value = []; // Else we stablish the certificateList as an empty array to avoid problems in the template
            }
        })
        .catch(error => {
            console.log('Error:', error)
            certificatesList.value = [];
        });
}

const selectedCourses = ref([]);

const filteredCourses = computed(() => {
    return list.value.filter(course => {
        const isFinished = certificatesList.value.some(c => c.course_id === course.id && c.user_id === loguedUser.value?.id);
        const status = isFinished ? 'Finished' : 'In progress';

        return selectedCourses.value.length === 0 || selectedCourses.value.includes(status);
    });
});

onMounted(async () => {
    const user = await userAuth(props.userAuth);
    if (user) {
        loguedUser.value = user;
        await getCertificates(user.id)
        await getCourses(); // Wait to get the courses
        await userCourses(user.id); // Get the list of the user's courses
    } else {
        router.push("/");
    }
});
</script>
<template>
    <div v-if="list.length != 0">
        <label class=" form-check-label m-2">
        <input type="checkbox" v-model="selectedCourses" value="Finished" class="form-check-input" />
        Finished
        </label>
        <label class="form-check-label m-3">
            <input type="checkbox" v-model="selectedCourses" value="In progress" class="form-check-input" />
            In progress
        </label>
    </div>
    <main v-if="list.length > 0" class="row row-cols-1 row-cols-md-3 g-4">
        <div class="card mb-2 w-50" v-for="course in filteredCourses" style="height: auto;">
            <div class="row g-1">
                <div class="col-md-4">
                    <img :src="course.image" class="img-fluid rounded-start h-100" alt="Course image"
                        style="object-fit: cover;" />
                </div>
                <div class="col-md-8">
                    <div class="card-body">
                        <RouterLink :to="{ name: 'course', params: { course_id: course.id } }"
                            class="card-title fs-4 fw-bold text-decoration-none">{{ course.title }}</RouterLink>
                        <p class="card-text text-muted fs-6 mt-3 mb-5">{{ (course.description).slice(0, 100) }}...</p>
                        <div class="h-100 d-flex align-items-end">
                            <p
                                v-if="certificatesList?.some(certificate => certificate.course_id == course.id && certificate.user_id == loguedUser.id)">
                                <img src="/graduated.png" class="me-2" alt="completed" style="max-width: 2em;">You have
                                completed this
                                course
                            </p>
                            <p v-else> <img src="/studying.png" class="me-2" alt="no_completed"
                                    style="max-width: 2.5em;">You still have
                                a lot of things to learn here! </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <main v-else>
        <h3>You don't have any course started</h3>
        <p>Explore our wide catalog and start learning right now!</p>
        <RouterLink class="btn" to="/catalog">Explore</RouterLink>
    </main>
</template>
<style scoped>
.btn {
    background-color: #FCDB77;
}

.btn:hover {
    background-color: #ffe8a2;
}
</style>