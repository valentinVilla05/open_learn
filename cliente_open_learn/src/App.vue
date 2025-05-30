<script setup>
import Header from '@/components/Header.vue';
import router from '@/router';
import { ref, onMounted } from 'vue';
import Swal from 'sweetalert2';
import { onBeforeUnmount } from 'vue';

const session = ref(sessionStorage.getItem('sessionID') || null);

function updateDataSession(user) {
  session.value = user;
  if (user) {
    sessionStorage.setItem('sessionID', user);
    router.push('/');
  } else {
    sessionStorage.removeItem('sessionID');
  }
}

let validationInterval = null; // Declare the variable for the interval

async function tryRefreshToken() {
  try {
    const response = await fetch('http://localhost:8000/api/refresh', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${session.value}`,
        'Accept': 'application/json',
      },
    });

    if (!response.ok) throw new Error('Refresh failed');

    const data = await response.json();
    updateDataSession(data.sessionID);
    return true;
  } catch {
    return false;
  }
}

async function validateToken() {
  // If there is no session, nothing happens
  if (!session.value) return;

  try {
    // Try to get the user with the actual token
    const response = await fetch('http://localhost:8000/api/user', {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${session.value}`, // Actual token
        'Accept': 'application/json',
      },
    });

    // If token not valid then try to refresh
    if (response.status === 401) {
      const refreshed = await tryRefreshToken();
      if (refreshed) return validateToken(); // retry
      else throw new Error('Session expired');
    }
    // If not is 401 then it supposed to be valid
  } catch (error) {
    // In case of error log out and show a message to send the user to login
    logOut();
    Swal.fire({
      imageUrl: '/lost_conecction.png',
      title: "Oops...",
      text: "It seems that your session has expired.",
      confirmButtonText: 'Go to log in',
    }).then(() => {
      router.push('/login');
    });
  }
}

// Funciton to call thge token validation and set the interval
function startTokenValidationInterval() {
  validateToken(); // Immediately on mount
  validationInterval = setInterval(validateToken, 180000); // Every 3 mins
}

function stopTokenValidationInterval() { // Stop the interval
  if (validationInterval) clearInterval(validationInterval);
}

function logOut() {
  stopTokenValidationInterval();
  updateDataSession(null);

}

onMounted(() => {
  startTokenValidationInterval(); // Start the interval

  // Logic for the toast (helper)
  const toastEl = document.querySelector('.toast');
  if (toastEl) {
    const toast = new bootstrap.Toast(toastEl, {
      autohide: false
    });
    toast.show();
  }
});

onBeforeUnmount(() => {
  stopTokenValidationInterval(); // Stops the interval before unmount
});

</script>

<template>
  <div class="layout">
    <Header :userAuth="session" @session-closed="updateDataSession" />

    <main class="content d-flex flex-column justify-content-start align-items-center">
      <RouterView v-slot="{ Component }">
        <component :is="Component" :userAuth="session" @sessionStarted="updateDataSession" />
      </RouterView>
    </main>

    <div class="toast show position-fixed bottom-0 end-0 mb-3 me-5 w-25 d-none d-sm-block" role="alert"
      aria-live="assertive" aria-atomic="true" data-bs-autohide="false">
      <div class="toast-header d-flex justify-content-end align-items-start">
        <button type="button" class="btn-close mt-2" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
      <div class="toast-body position-relative text-center">
        <span class="help rounded mx-auto w-50 toast-text d-block">Need help?</span>
        <RouterLink to="/faq" class="help rounded w-100 text-decoration-none position-relative" style="cursor: pointer;">
          Click me!</RouterLink>
        <img src="/help.png" class="w-100" alt="help" />

      </div>
    </div>
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

.toast {
  background-color: transparent !important;
  box-shadow: none !important;
  border: none !important;
  max-width: 15em;
  z-index: 1055;
}

.button {
  background-color: white;
}

.toast-header {
  background-color: transparent !important;
  border-bottom: none !important;
  padding-bottom: 0 !important;
}

.toast-body {
  padding: 0 !important;
}

.toast-text {
  display: block;
  margin-bottom: 0.5rem;
  color: black;
  font-size: 1.2em;
}
.help {
  background-color: rgb(229, 228, 228);
}

footer {
  background-color: #8EC8EC;
  color: white;
  text-align: center;
  padding: 10px;
  width: 100%;
}
</style>
