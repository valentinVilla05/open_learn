<script setup>
import { ref, onMounted } from 'vue';
import { userAuth } from '@/utils/userAuth';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

const loguedUser = ref(null);
const coursesAssigned = ref([]);

// Get all the courses
function getCourses() {
    fetch('http://localhost:8000/api/courses', {
        method: 'GET',
    }).then(response => response.json())
        .then(data =>
            coursesAssigned.value = data.filter(course => course.teacher_id === loguedUser.value.id)
        )
        .catch(error => console.log('Error:', error));
}

onMounted(async () => {
    const user = await userAuth(props.userAuth);
    if (user) {
        loguedUser.value = user;
        getCourses();
    }
});
</script>
<template>
    <main v-if="coursesAssigned.length > 0" class="row row-cols-1 row-cols-md-3 g-4">
        <div class="card mb-2 w-50" v-for="course in coursesAssigned" style="height: auto;">
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
                    </div>
                </div>
            </div>
        </div>
    </main>
    <main v-else>
        <h3>You don't have any course assigned</h3>
        <p>If should be appear any, talk to the administrator.</p>
    </main>

</template>
<style scoped></style>º