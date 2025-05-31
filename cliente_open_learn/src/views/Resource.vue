<script setup>
import CommentSection from '@/components/CommentSection.vue';
import { ref, computed, Comment, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import router from '@/router';
import { userAuth } from '@/utils/userAuth';
import Swal from 'sweetalert2';

const emit = defineEmits(['sessionStarted']);
const props = defineProps({
    userAuth: {
        type: String,
        required: false // Optional
    }
});

const loguedUser = ref(null);
const route = useRoute();
const courseId = route.params.course_id;
const resourceId = route.params.resource_id;
const resourceData = ref(null);
const courseData = ref(null);

// Get the resource data
function getResourceData() {
    fetch('https://apiopenlearn.onrender.com/api/resources ', {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            resourceData.value = data;
            resourceData.value = resourceData.value.find(resource => resource.id == resourceId);
        })
        .catch(error => console.log('Error:', error));
}

function getCourseName(course_id) {
    fetch(`https://apiopenlearn.onrender.com/api/courses/${course_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            courseData.value = data;
        })
        .catch(error => console.log('Error:', error));
}

function getInscriptions(user_id) {
    return fetch(`https://apiopenlearn.onrender.com/api/inscriptions/user/${user_id}`, {
        method: 'GET',
    }).then(response => response.json())
        .then(data => {
            if (!data.value.some(inscription => inscription.user_id === loguedUser.value.id && inscription.course_id === courseId)) {
                Swal.fire({
                    icon: "error",
                    title: "You are not enrolled in this course.",
                    text: "Please enroll to access the resources.",
                }).then(() => router.push(`/course/${courseId}`));
                return;
            }
        })
        .catch(error => console.log('Error:', error));
}

function isImage(url) {
  return /\.(jpeg|jpg|gif|png)$/i.test(url)
}

////////////////
/// IA Chat ////
////////////////
const responseLlama = ref('');
const prompt = ref('');
const loading = ref(false);

async function sendPrompt() {
    loading.value = true;
    responseLlama.value = '';

    const response = await fetch('http://localhost:11434/api/generate', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            model: 'llama3.2', // Specify the model we are gonna use
            prompt: prompt.value // Message to send
        })
    });

    if (!response.ok || !response.body) { // If there is an error with the fecth or the reposnse is empty 
        console.error("Error al obtener respuesta de la API:", response.statusText);
        return;
    }

    const reader = response.body.getReader(); // Read the data from the response 
    const decoder = new TextDecoder('utf-8'); // Transfotm the data from binary to text
    let fullText = ''; // Varuable to staorage the responde

    while (true) { // Inifinite loop until the response is finised
        const { done, value } = await reader.read(); // value is a piece of the response of the server
        if (done) break; // Break the loop when the response is done

        const chunk = decoder.decode(value, { stream: true });  // Transform the value to legible text

        // Ollama return a JSON line for each piece of text generated;
        const lines = chunk.split('\n').filter(line => line.trim() !== '');  // Filter the lines to remove empty ones

        for (const line of lines) {  // Convert each line to JSON 
            try {
                const parsed = JSON.parse(line);
                if (parsed.response) { // If it is a part of the response, then add to the "accumulator"
                    fullText += parsed.response;
                    responseLlama.value = fullText;
                }
            } catch (e) {
                console.warn('Línea no JSON válida:', line);
            } finally {
                loading.value = false;
                prompt.value = '';
            }
        }
    }
    prompt.value = ''; // Clear the input
}

onMounted(async () => {
    const user = await userAuth(props.userAuth);
    if (user) {
        loguedUser.value = user;
        await getInscriptions(loguedUser.value.id); // Wait for inscription
    } else {
        Swal.fire({
            icon: "error",
            title: "You need to log in to access here.",
            text: "Please log in to continue.",
        });
        router.push('/'); // Redirect to login if user is not logged in
    }
    getResourceData();
    getCourseName(courseId)
});
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
        <div>
            <h2 class="my-3">{{ resourceData?.name }}</h2>
            <p>{{ resourceData?.description }}</p>

            <p>
                Link to resource:
                <a :href="resourceData?.url" target="_blank" rel="noopener noreferrer">
                    {{ resourceData?.url }}
                </a>
            </p>

            <!-- Video -->
            <div v-if="resourceData?.type === 'video'">
                <iframe class="w-100" style="height: 30em;" :src="resourceData.url" frameborder="0"
                    allowfullscreen></iframe>
            </div>

            <!-- Document (PDF, Word, etc.) or Image -->
            <div v-else-if="resourceData?.type === 'document'">
                <img v-if="isImage(resourceData.url)" :src="resourceData.url" alt="Uploaded Image"
                    style="max-width: 100%; max-height: 30em;" />

                <div v-else class="ratio ratio-4x3">
                    <iframe :src="resourceData.url" style="width: 100%; height: 100%; border: none;"
                        frameborder="0"></iframe>
                </div>
            </div>
        </div>
        <div class="container m-3">
            <h3>Any doubts about the topic? Ask it to Owl-IA</h3>
            <p class="m-0">Write your thoughts:</p>
            <div class="d-flex">
                <input class="w-100 rounded border-1 m-2" type="text" v-model="prompt"
                    placeholder="Tell me about..." :disabled="loading" />
                <button class="p-1 btn text-black" @click="sendPrompt" :disabled="loading">
                    {{ loading ? 'Sending...' : 'Send prompt' }}</button>
            </div>

            <p class="m-0">Owl-IA response:</p>
            <pre class="w-100 p-2 border rounded bg-light" style="max-height: 300px; overflow-y: auto;">
              {{ responseLlama }}
            </pre>
        </div>

        <div class="m-3">
            <RouterLink :to="{ name: 'course', params: { course_id: courseId } }" class="btn">Go back to course
            </RouterLink>
        </div>
    </main>
    <CommentSection :courseId="courseId" :resourceId="resourceId" :userAuth="props.userAuth"></CommentSection>
</template>
<style scoped>
p {
    margin-block: 1lh;
}

input,
textarea {
    margin: 10px 0;
    padding: 10px;
    font-family: monospace;
}

button {
    padding: 10px 15px;
    background-color: #007BFF;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover {
    background-color: #0056b3;
}
</style>
