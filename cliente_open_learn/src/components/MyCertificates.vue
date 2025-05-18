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
    <main class="container">
        <div class="card" style="width: 18rem;" v-for="certificate in certificates" v-if="certificates != null">
            <img :src="courses?.find(course => course.id == certificate.course_id)?.image" class="card-img-top"
                alt="Course image">
            <div class="card-body d-flex flex-column align-items-center justify-content-center">
                <h5 class="card-title">{{courses?.find(course => course.id == certificate.course_id)?.title}}</h5>
                <a class="btn" @click="seeCertificate(certificate.user_id, certificate.course_id)">See Certificate</a>
            </div>
        </div>
    </main>
</template>
<style scoped></style>