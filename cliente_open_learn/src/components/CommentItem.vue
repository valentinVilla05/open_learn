<script setup>
import { ref } from 'vue';
import { formatDate } from '@/utils/formatDate';
const props = defineProps({
    userAuth: {
        type: String
    },
    comment: {
        type: Object
    },
    resource_id: {
        type: String
    },
    loguedUser: {
        type: Object
    },
    getUserName: {
        type: Function
    },
    postComment: {
        type: Function
    },
    deleteComment: {
        type: Function
    },
    level: {
        type: Number,
        default: 1
    }
});

const showReply = ref(false);
const newReply = ref({
    user_id: '',
    resource_id: '',
    response_id: '',
    comment: ''
});


function handleReply() {
    if (!newReply.value.comment.trim()) return;

    newReply.value.user_id = props.loguedUser.id;
    newReply.value.resource_id = props.resource_id;
    newReply.value.response_id = props.comment.id

    props.postComment(newReply.value);

    showReply.value = false;
}
</script>

<template>
    <div class="border rounded w-90 m-2">
        <p class="fw-bold ms-3 mt-3">
            {{ getUserName(comment.user_id) }}
            <small v-if="comment.user_id === loguedUser.id" class="text-muted">(You)</small>
            <br>
            <small class="text-muted ms-3">{{ formatDate(comment.created_at) }}</small>
        </p>

        <p class="ms-3">{{ comment.comment }}</p>

        <div class="d-flex">
            <button class="buttonControls btn-sm text-info ms-auto m-3" @click="showReply = !showReply" v-if="level <= 3">Reply</button>
            <button class="buttonControls btn-sm text-danger m-3" v-if="comment.user_id === loguedUser.id"
                @click="deleteComment(comment.id)">
                Delete
            </button>
        </div>

        <div v-if="showReply" class="mt-2">
            <textarea v-model="newReply.comment" class="form-control" placeholder="Write your reply here..."></textarea>
            <button class="btn btn-sm mt-1" @click="handleReply">Post Reply</button>
        </div>

        <div class="ms-4 mt-3" v-if="comment.replies && comment.replies.length">
            <CommentItem v-for="reply in comment.replies" :key="reply.id" :userAuth="userAuth" :comment="reply"
                :resource_id="resource_id" :loguedUser="loguedUser" :getUserName="getUserName"
                :postComment="postComment" :deleteComment="deleteComment" :level="level + 1"/>
        </div>
    </div>
</template>
<style scoped>
.buttonControls {
    background-color: white;
    border: none;
}
</style>
