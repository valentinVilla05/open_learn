<script setup>
import { ref } from 'vue';
import { motion } from 'motion-v';

const props = defineProps({
    course_id: {
        type: String,
    }
});

const resources = ref(null);

function getResources(course_id) {
    fetch(`http://localhost:8000/api/resources/${course_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            resources.value = data
            console.log(resources.value)
        })
        .catch(error => console.log('Error:', error));
}
getResources(props.course_id)
</script>
<template>
    <div class="w-100 fs-5 text-center mt-2">
        <p class="mb-1">Content</p>
        <hr class="my-1">
    </div>
    <section>
        <motion.div class="resource w-100 m-2 d-flex flex-row border rounded" v-for="resource in resources"  :while-hover="{ scale: 1.05 }">
            <div class="d-flex align-items-center border-end border-2">
                <img v-if="resource.type === 'link'" class="mx-2" style="min-height: fit-content; min-width: 2em;" src="/link_icon.png" alt="link">
                <img v-if="resource.type === 'document'" class="mx-2" style="min-height: fit-content; min-width: 2em;" src="/document_icon.png" alt="document">
                <img v-if="resource.type === 'video'" class="mx-2" style="min-height: fit-content; min-width: 2em;" src="/video_icon.png" alt="video">
            </div>
            <RouterLink :to="{ name: 'resource', params: { course_id: course_id, resource_id: resource.id } }"  class="text-black fw-bold m-3 text-decoration-none">{{ resource.name }}</RouterLink>
        </motion.div>
    </section>
</template>
<style scoped>
p{
    margin-block: 1lh
}   
.resource{
    background-color: rgb(231, 231, 231);
}
</style>