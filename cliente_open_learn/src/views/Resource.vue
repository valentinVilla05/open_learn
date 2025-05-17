<script setup>
import { ref, computed } from 'vue';
import { useRoute } from 'vue-router';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

const route = useRoute();
const courseId = route.params.course_id;
const resourceId = route.params.resource_id;
const resourceData = ref(null);
const courseData = ref(null);

// Get the resource data
function getResourceData() {
    fetch(' http://localhost:8000/api/resources ', {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            resourceData.value = data;
            resourceData.value = resourceData.value.find(resource => resource.id == resourceId);
            console.log(resourceData.value)
        })
        .catch(error => console.log('Error:', error));
}

function getCourseName(course_id) {
    fetch(`http://localhost:8000/api/courses/${course_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            courseData.value = data;
        })
        .catch(error => console.log('Error:', error));
}

getResourceData();
getCourseName(courseId)

</script>
<template>
    <div class="w-75 text-start ms-1 mt-2">
        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="mt-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <RouterLink to="/catalog" class="text-decoration-none text-">Catalog</RouterLink>
                </li>
                <li class="breadcrumb-item" aria-current="page">
                    <RouterLink :to="{ name: 'course', params: { course_id: courseData?.id } }"
                        class="text-decoration-none">{{ courseData?.title }}</RouterLink>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    {{ resourceData?.name }}
                </li>
            </ol>
        </nav>
    </div>
    <main class="container shadow border rounded w-100 m-3">
        <h2 class="my-3">{{ resourceData?.name }}</h2>
        <p>{{ resourceData?.description }}</p>
        <div v-if="resourceData?.type == 'video'">
            <p class="">Link to resource: <a :href="resourceData?.url" target="_blank">{{ resourceData?.url }}</a></p>
            <iframe class="w-100" style="height: 30em;" :src="resourceData?.url" title="YouTube video player"
                frameborder="0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
        </div>
        <div v-else>
            <p class="">Link to resource: <a :href="resourceData?.url" target="_blank">{{ resourceData?.url }}</a></p>
            <div class="ratio ratio-4x3">
                <iframe :src="resourceData?.url" type="application/pdf" />
            </div>
        </div>

        <div class="m-3">
            <RouterLink :to="{ name: 'course', params: { course_id: courseId } }" class="btn">Go back to course
            </RouterLink>
        </div>
    </main>
</template>
<style scoped>
p {
    margin-block: 1lh;
}

.btn {
    background-color: #FCDB77;
}

.btn:hover {
    background-color: #ffe8a2;
    color: black;
}
</style>
