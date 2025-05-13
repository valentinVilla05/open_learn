<script setup>
import { ref, onMounted } from 'vue';
import MyCertificates from '@/components/MyCertificates.vue';
import MyCourses from '@/components/MyCourses.vue';
import CoursesTeacher from '@/components/CoursesTeacher.vue';
import { userAuth } from '@/utils/userAuth';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

const loguedUser = ref(null);
const isTeacher = ref(false);

onMounted(async () => {
  const user = await userAuth(props.userAuth);
  loguedUser.value = user;

  if (user && user.rol) {
    user.rol === 'teacher' ? isTeacher.value = true : isTeacher.value = false
  }
});

</script>
<template>
    <main class="container">
        <ul class="nav nav-pills mt-4 mb-5" id="myTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="courses-tab" data-bs-toggle="pill" data-bs-target="#courses-pane"
                    type="button" role="tab" aria-controls="courses-pane" aria-selected="true">
                    My courses
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="certificates-tab" data-bs-toggle="pill" data-bs-target="#certificates-pane"
                    type="button" role="tab" aria-controls="certificates-pane" aria-selected="false">
                    Certificates
                </button>
            </li>
            <li class="nav-item" role="presentation" v-show="isTeacher">
                <button class="nav-link" id="courses-teacher-tab" data-bs-toggle="pill" data-bs-target="#courses-teacher-pane"
                    type="button" role="tab" aria-controls="courses-teacher-pane" aria-selected="false">
                    Courses you teach
                </button>
            </li>
        </ul>

        <div class="tab-content" id="myTabContent">
            <div class="tab-pane fade show active table-responsive w-100 border shadow p-3" id="courses-pane"
                role="tabpanel" aria-labelledby="courses-tab">
                <!-- Content for My Courses -->
                <MyCourses :userAuth="props.userAuth"></MyCourses>
            </div>
            <div class="tab-pane fade table-responsive w-100 border shadow p-3" id="certificates-pane" role="tabpanel"
                aria-labelledby="certificates-tab">
                <!-- Content for Certificates -->
                 <MyCertificates :userAuth="props.userAuth"></MyCertificates>
            </div>
            <div class="tab-pane fade table-responsive w-100 border shadow p-3" id="courses-teacher-pane" role="tabpanel"
                aria-labelledby="courses-teacher-tab" v-show="isTeacher">
                <!-- Content for Certificates -->
                 <CoursesTeacher :userAuth="props.userAuth"></CoursesTeacher>
            </div>
        </div>
    </main>
</template>


<style scoped>
.nav-pills .nav-link.active,
.nav-pills .show>.nav-link {
    background-color: lightgrey;
    color: black;
    font-weight: bold;
}

.nav-link {
    color: black;
}

.nav-link:hover {
    color: black;
    font-weight: bold;
}
</style>