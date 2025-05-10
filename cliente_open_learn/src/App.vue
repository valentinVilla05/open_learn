<script setup>
import Header from '@/components/Header.vue';
import Footer from '@/components/Footer.vue';
import router from '@/router';
import { ref } from 'vue';

const session = ref(sessionStorage.getItem('sessionID') || null);

function updateDataSession(user) {
  session.value = user;
  if (user) {
    sessionStorage.setItem('sessionID', user);
    router.push("/");
  } else {
    sessionStorage.removeItem('sessionID');
  }
}

</script>

<template>
  <div class="layout">
    <Header :userAuth="session" @session-closed="updateDataSession" />

    <main class="content d-flex flex-column justify-content-start align-items-center">
      <RouterView @sessionStarted="updateDataSession" :userAuth="session" />
    </main>

    <Footer />
  </div>
</template>
<style scoped>
html,
body {
  font-family: 'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif;
  margin: 0;
  padding: 0;
  overflow-x: hidden;
  height: 100%;
}

.content {
  flex: 1;
  overflow: hidden;
  height: 100vh;
  
}

.layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

footer {
  background-color: #8EC8EC;
  color: white;
  text-align: center;
  padding: 10px;
  width: 100%;
}
</style>
