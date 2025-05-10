import { ref, onMounted, onBeforeUnmount } from 'vue';
import router from '@/router';
import Swal from 'sweetalert2';

export function validateToken(userAuth, onSessionClosed = () => { }) {
    const user = ref(null);
    let validationInterval = null;

    async function validateToken() {
        if (!userAuth.value) return;

        try {
            const response = await fetch('http://localhost:8000/api/user', {
                method: 'GET',
                headers: {
                    'Authorization': `Bearer ${userAuth.value}`,
                    'Accept': 'application/json',
                },
            });

            if (!response.ok) {
                await response.json(); // puedes capturar el mensaje si quieres mostrarlo
                logout();

                Swal.fire({
                    imageUrl: '/lost_connection.png',
                    title: "Oops...",
                    text: "It seems that your session has expired. Log in again to continue.",
                    confirmButtonText: 'Go to log in',
                }).then(() => {
                    router.push('/login');
                });

                return;
            }

            const data = await response.json();
            user.value = data;
        } catch (error) {
            console.error('Error validating token:', error.message);
        }
    }

    function logout() {
        sessionStorage.removeItem('acces_token');
        onSessionClosed(); // Este es el equivalente a emit
    }

    onMounted(() => {
        validateToken();
        validationInterval = setInterval(validateToken, 300000);
    });

    onBeforeUnmount(() => {
        if (validationInterval) clearInterval(validationInterval);
    });

    return {
        user,
        validateToken,
        logout,
    };
}