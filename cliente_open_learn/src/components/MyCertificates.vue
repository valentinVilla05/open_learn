<script setup>
import { ref, onMounted } from 'vue';
import { userAuth } from '@/utils/userAuth';

const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

const loguedUser = ref(null);
const certificates = ref(null);
const courses = ref(null)

function getCertificates(user_id) {
    fetch(`http://localhost:8000/api/certificates/user/${user_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => certificates.value = data)
        .catch(error => console.log('Error:', error));
}
function getCourses() {
    fetch('http://localhost:8000/api/courses', {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            courses.value = data
        })
        .catch(error => console.log('Error:', error));
}

function seeCertificate(user_id, course_id) {
    fetch(`http://localhost:8000/api/certificates/${user_id}/${course_id}`, {
        method: 'GET',
    })
        .then(response => {
            if (response.headers.get('content-type') === 'application/pdf') {
                return response.blob();
            }
            return response.json(); // fallback in case it's JSON
        })
        .then(data => {
            if (data instanceof Blob) {
                const blobUrl = URL.createObjectURL(data);
                window.open(blobUrl, '_blank');
            } else {
                console.log('Certificates:', data); // in case it's not a PDF
            }
        })
        .catch(error => console.log('Error:', error));
}

onMounted(async () => {
    const user = await userAuth(props.userAuth);
    if (user) {
        loguedUser.value = user;
        getCourses();
        getCertificates(loguedUser.value.id)
        console.log(certificates.value)
    }
});
</script>
<template>
    <main class="container mt-4">
        <div class="row justify-content-center g-4">
            <div v-if="certificates && certificates.length" v-for="certificate in certificates" :key="certificate.id"
                class="col-12 col-sm-6 col-md-4 col-lg-3">
                <div class="frame p-3 d-flex align-items-center justify-content-center border shadow rounded h-100">
                    <div class="card border-0 w-100 h-100">
                        <img :src="courses?.find(course => course.id == certificate.course_id)?.image"
                            class="card-img-top img-fluid rounded-top imageCourse" alt="Course image" />
                        <div class="card-body text-center">
                            <h5 class="card-title mb-3">
                                {{courses?.find(course => course.id == certificate.course_id)?.title}}
                            </h5>
                            <button class="btn"
                                @click="seeCertificate(certificate.user_id, certificate.course_id)">
                                🎓 See Certificate
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <p v-else class="text-muted text-center mt-4">No certificates available yet.</p>
        </div>
    </main>
</template>
<style scoped>
.imageCourse {
    width: 100%;
    height: 12em;
    object-fit: cover;
    border-radius: 10px;
}
</style>