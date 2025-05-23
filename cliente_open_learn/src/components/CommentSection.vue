<!-- CommentThread.vue -->
<script setup>
import { userAuth } from '@/utils/userAuth';
import { ref, onMounted } from 'vue';
import Swal from 'sweetalert2';
import CommentItem from './CommentItem.vue';

const props = defineProps({
    courseId: String,
    resourceId: String,
    userAuth: String
});

const loguedUser = ref(null);
const commentsList = ref([]);
const userList = ref([]);
const newComment = ref({
    user_id: '',
    resource_id: '',
    response_id: '',
    comment: ''
});

function getUsersName() {
    fetch('http://localhost:8000/api/users')
        .then(res => res.json())
        .then(data => userList.value = data)
        .catch(error => console.error('Error:', error));
}

function getUserName(user_id) {
    const user = userList.value.find(u => u.id === user_id);
    return user ? user.name : 'Unknown User';
}

function getComments() {
    fetch(`http://localhost:8000/api/comments/resource/${props.resourceId}`)
        .then(res => res.json())
        .then(data => commentsList.value = data)
        .catch(error => console.error('Error:', error));
}

function postComment(commentData) {
    fetch('http://localhost:8000/api/comments', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${props.userAuth}`,
            'Accept': 'application/json',
        },
        body: JSON.stringify(commentData)
    })
        .then(res => res.json())
        .then(() => {
            getComments();
        })
        .catch(error => console.error('Error:', error));
}

function deleteComment(comment_id) {
    fetch(`http://localhost:8000/api/comments/${comment_id}`, {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${props.userAuth}`,
            'Accept': 'application/json',
        },
    })
        .then(res => res.json())
        .then(() => {
            Swal.fire('Deleted!', 'Your comment has been deleted.', 'success');
            getComments();
        })
        .catch(error => console.error('Error:', error));
}

onMounted(async () => {
    const user = await userAuth(props.userAuth);
    if (user) loguedUser.value = user;
    getComments();
    getUsersName();
});
</script>

<template>
    <h2>Comment Section</h2>
    <p class="text-muted">Write any question about the topic here!</p>
    <div class="w-75 m-4 d-flex justify-content-center container">
        <textarea class="w-75 h-100 mx-3 border border-1" placeholder="Write your question here..."
            v-model="newComment.comment"></textarea>
        <button class="btn" @click="postComment({
            user_id: loguedUser.id,
            resource_id: props.resourceId,
            comment: newComment.comment
        }); newComment.comment = ''">
            Post comment
        </button>
    </div>
    <section class="container shadow border rounded w-100 m-3" v-if="commentsList.length > 0">
        <CommentItem v-for="comment in commentsList" :key="comment.id" :userAuth="props.userAuth" :comment="comment"
            :resource_id=resourceId :loguedUser="loguedUser" :getUserName="getUserName" :postComment="postComment"
            :deleteComment="deleteComment" />
    </section>
</template>

<style scoped>
.commentControl {
    border: none;
    background-color: white;
}
</style>
