<script setup>
import Header from '@/components/Header.vue';
import Footer from '@/components/Footer.vue';
import router from '@/router';
import { ref } from 'vue';

const session = ref(sessionStorage.getItem('sessionID') || null);

function updateDataSession(user) {
  session.value = user;
  if (user) {
    sessionStorage.setItem('sessionID', JSON.stringify(user));
    router.push("/home");
  } else {
    sessionStorage.removeItem('sessionID');
  }
}

</script>

<template>
  <div class="layout">
    <Header :userAuth="session" @session-closed="updateDataSession" />

    <main class="content">
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
  /* Oculta cualquier desbordamiento lateral */
  height: 100%;
  /* Asegura que el body tenga altura completa */
}

.content {
  flex: 1;
  overflow: hidden;
  /* Evita que Vue cree un scroll dentro del div */
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  /* El contenedor ocupa toda la altura de la pantalla */
}

footer {
  background-color: #8EC8EC;
  color: white;
  text-align: center;
  padding: 10px;
  width: 100%;
}
</style>
