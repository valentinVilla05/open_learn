import { ref } from 'vue';

const validUser = ref(null);
const loguedUser = ref(null);

async function userAuth(token) {
    if (!token) {
        loguedUser.value = null; // If there is no token, there is no logged user
        return;
    }

    try {
        const response = await fetch('http://localhost:8000/api/user', {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Accept': 'application/json',
            },
        });

        if (!response.ok) {
            const error = await response.json();
            validUser.value = false; // If the response is not ok, set validUser to null
            return validUser.value;
        } else {
            validUser.value = true; // If the response is ok, set validUser to true
            loguedUser.value = await response.json(); // Store the logged user data
            console.log(loguedUser.value);
            return loguedUser.value;
        }
    } catch (error) {
        validUser.value = false; // If the response is not ok, set validUser to null
        return validUser.value;
    }
}
export { userAuth };
