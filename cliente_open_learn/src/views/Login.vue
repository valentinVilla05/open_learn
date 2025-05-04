<script setup>
import { ref } from 'vue'
import { owlPasswordImages } from './images'
import router from '@/router'
import Swal from 'sweetalert2'

// Control to login/register animation
const isSignUp = ref(false)

const switchToSignUp = () => {
   isSignUp.value = true
}

const switchToSignIn = () => {
   isSignUp.value = false
}

// Control to password animation
const image = ref(owlPasswordImages[0]);

const handlePasswordFocus = () => {
   setTimeout(() => {
      image.value = owlPasswordImages[0];
   }, 150);
   setTimeout(() => {
      image.value = owlPasswordImages[1];
   }, 300);
   setTimeout(() => {
      image.value = owlPasswordImages[2];
   }, 400);
};

const handlePasswordBlur = () => {
   setTimeout(() => {
      image.value = owlPasswordImages[2];
   }, 150);
   setTimeout(() => {
      image.value = owlPasswordImages[1];
   }, 250);
   setTimeout(() => {
      image.value = owlPasswordImages[0];
   }, 300);
};

const emailLogin = ref("");
const passwordLogin = ref("");
const loguedUser = ref(null);
const wrongLoginData = ref(false);
const validData = ref(false);
const error_login_message = ref("");
const emailRegEx = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/


// Function to validate the form data
function validateData() {
   if (emailLogin.value.length === 0 || passwordLogin.value.length === 0) {
      error_login_message.value = "The fields cannot be empty";
      wrongLoginData.value = true;
      validData.value = false;
   } else if (!emailRegEx.test(emailLogin.value)) {
      error_login_message.value = "That's not a valid email";
      wrongLoginData.value = true;
      validData.value = false;
   } else {
      error_login_message.value = "";
      wrongLoginData.value = false;
      validData.value = true;
   }
}

// Function to get the user information
function getUser(token) {
   fetch('http://localhost:8000/api/user', {
      method: 'GET',
      headers: {
         'Authorization': `Bearer ${token}`,
         'Accept': 'application/json'
      }
   })
      .then(async response => {
         if (!response.ok) {
            const error = await response.json();
            throw new Error(error.message || "Error fetching user data");
         }
         const data = await response.json();
         console.log(data);
         loguedUser.value = data;
      })
      .catch(error => {
         console.error('Error fetching user:', error.message);
         error_login_message.value = "Unable to get user data.";
         wrongLoginData.value = true;
      });
}

const emit = defineEmits(["sessionStarted"]) // Declare the emit of log in

// Function to log in the user
async function login() {
   const loginData = {
      email: emailLogin.value,
      password: passwordLogin.value,
   };

   try {
      const response = await fetch('http://localhost:8000/api/login', {
         method: 'POST',
         headers: {
            'Content-Type': 'application/json',
         },
         body: JSON.stringify(loginData),
      });

      const data = await response.json();

      if (data.access_token) {
         // Save the token session
         await getUser(data.access_token); // Wait for the user data to be fetched

         emit("sessionStarted", data.access_token);

         router.push('/'); // Redirect to the home page

         const Toast = Swal.mixin({
            toast: true,
            position: "top-end",
            showConfirmButton: false,
            timer: 1500,
            timerProgressBar: true,
            didOpen: (toast) => {
               toast.onmouseenter = Swal.stopTimer;
               toast.onmouseleave = Swal.resumeTimer;
            },
         });

         Toast.fire({
            icon: "success",
            title: loguedUser.value ? `Welcome ${loguedUser.value.name}!` : "Welcome!",
         });
      } else {
         // Show an error message
         error_login_message.value = "Invalid email or password";
         wrongLoginData.value = true;
      }
   } catch (error) {
      console.error('Error:', error);
   }
}

// Logic to sign up the user

const nameUserSignUp = ref("");
const emailUserSignUp = ref("");
const passwordUserSignUp = ref("");
const wrongSignUpData = ref(false);
const errorSignUpmessage = ref("");
const validDataSignUp = ref(false);

const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#?!$%^&*\-+_]).{8,}$/;

// We get the users from teh db to validate if the email is already in use

const emailList = ref([]);

async function getUsers() {
   fetch('http://localhost:8000/api/users', {
      method: 'GET',
   }).then(reponse => reponse.json())
      .then(data => emailList.value = data)
      .catch(error => console.log('Error:', error));
}
getUsers();

function validateSignUpData() {
   if (nameUserSignUp.value.length === 0 || emailUserSignUp.value.length === 0 || passwordUserSignUp.value.length === 0) {
      errorSignUpmessage.value = "The fields cannot be empty";
      wrongSignUpData.value = true;
      validDataSignUp.value = false;
   } else if (!emailRegEx.test(emailUserSignUp.value)) {
      errorSignUpmessage.value = "That's not a valid email";
      wrongSignUpData.value = true;
      validDataSignUp.value = false;
   } else if (emailList.value.some(user => user.email === emailUserSignUp.value)) {
      errorSignUpmessage.value = "That email is already in use";
      wrongSignUpData.value = true;
      validDataSignUp.value = false;
   } else if (!passwordRegex.test(passwordUserSignUp.value)) {
      errorSignUpmessage.value = "Password must have at least 8 characters, one uppercase letter, one lowercase letter, one number and one special character(@#?!$%^&*-+_)";
      wrongSignUpData.value = true;
      validDataSignUp.value = false;
   } else {
      errorSignUpmessage.value = "";
      wrongSignUpData.value = false;
      validDataSignUp.value = true;
   }
}

async function signUp() {
   const userData = {
      name: nameUserSignUp.value,
      email: emailUserSignUp.value,
      password: passwordUserSignUp.value,
   }

   fetch('http://localhost:8000/api/register', {
      method: 'POST',
      headers: {
         'Content-Type': 'application/json'
      },
      body: JSON.stringify(userData)
   })
      .then(response => response.json())
      .then(data => {
         // Show a success message
         Swal.fire({
            icon: 'success',
            title: 'User created successfully!',
            text: 'You can now log in.',
         });

         // Switch to the login form
         switchToSignIn();
      })
      .catch(error => console.error('Error:', error));
}
</script>

<template>
   <div class="wrapper position-relative" :class="isSignUp ? 'animate signUp' : 'animate signIn'">
      <!-- Login Form -->
      <div class="form-wrapper sign-up position-absolute d-flex justify-content-center align-items-center w-100 h-100">
         <form>
            <h2 class="text-center fw-bold mb-4">Welcome back!</h2>
            <img class="logoLogin img-fluid mx-auto d-block mb-3" :src="image" alt="Logo" />
            <div class="input-group position-relative">
               <input type="email" v-model="emailLogin" @input="validateData" name="email" required />
               <label for="email">Email</label>
            </div>
            <div class="input-group position-relative">
               <input type="password" name="password" required @focus="handlePasswordFocus" @blur="handlePasswordBlur"
                  v-model="passwordLogin" @input="validateData" />
               <label for="password">Password</label>
            </div>
            <p style="color: red;" v-if="wrongLoginData">{{ error_login_message }}</p>
            <button type="submit" class="btn position-relative w-100" :disabled="!validData" @click.prevent="login">Log
               in</button>
            <div class="signUp-link">
               <p>Don't have an account?
                  <a href="#" @click.prevent="switchToSignUp">Sign Up</a>
               </p>
            </div>
         </form>
      </div>

      <!-- Register Form -->
      <div class="form-wrapper sign-in position-absolute d-flex justify-content-center align-items-center w-100 h-100">
         <form>
            <h2>Sign Up</h2>
            <img class="logoSignUp img-fluid mx-auto d-block mb-3" src="/signup.png" alt="Logo" />
            <div class="input-group position-relative">
               <input type="text" name="username" v-model="nameUserSignUp" @input="validateSignUpData" required />
               <label for="username">Username</label>
            </div>
            <div class="input-group position-relative">
               <input type="email" name="email" v-model="emailUserSignUp" @input="validateSignUpData" required />
               <label for="email">Email</label>
            </div>
            <div class="input-group position-relative">
               <input type="password" name="password" v-model="passwordUserSignUp" @input="validateSignUpData"
                  required />
               <label for="password">Password</label>
            </div>
            <div class="input-group position-relative">
               <p style="color: red; font-size: small*1.25" class="me-3 ms-3" v-if="wrongSignUpData">{{
                  errorSignUpmessage }}</p>
            </div>
            <button type="submit" class="btn position-relative w-100" :disabled="!validDataSignUp"
               @click.prevent="signUp">Register</button>
            <div class="signIn-link">
               <p>Already have an account?
                  <a href="#" @click.prevent="switchToSignIn">Sign In</a>
               </p>
            </div>
         </form>
      </div>
   </div>
</template>
<style scoped>
* {
   margin: 0;
   padding: 0;
   box-sizing: border-box;
}

body {
   display: flex;
   justify-content: center;
   align-items: center;
   min-height: 100vh;
   background: linear-gradient(#2196f3, #e91e63);
   overflow: hidden;

}

.wrapper {
   width: 27em;
   min-height: 40em;
}

.form-wrapper {
   top: 0;
   left: 0;
   height: 40em;
   background: #fff;
   border-radius: 5px;
   box-shadow: 0 0 10px rgba(0, 0, 0, .2);
}

.wrapper.animate.signUp .form-wrapper.sign-in {
   transform: rotate(7deg);
   animation: animateRotate .7s ease-in-out forwards;
   animation-delay: .3s;
}

.wrapper.animate.signIn .form-wrapper.sign-in {
   animation: animateSignIn 1.5s ease-in-out forwards;
}

@keyframes animateSignIn {
   0% {
      transform: translateX(0);
   }

   50% {
      transform: translateX(-31.25em);
   }

   100% {
      transform: translateX(0) rotate(7deg)
   }
}

.wrapper .form-wrapper.sign-up {
   transform: rotate(7deg);
   animation-delay: .3s;
}

.wrapper.animate.signIn .form-wrapper.sign-up {
   animation: animateRotate .7s ease-in-out forwards;
   animation-delay: .3s;
}

@keyframes animateRotate {
   0% {
      transform: rotate(7deg)
   }

   100% {
      transform: rotate(0);
      z-index: 1;
   }
}

.wrapper.animate.signUp .form-wrapper.sign-up {
   animation: animateSignUp 1.5s ease-in-out forwards;
}

@keyframes animateSignUp {
   0% {
      transform: translateX(0);
      z-index: 1;
   }

   50% {
      transform: translateX(31.25em);
   }

   100% {
      transform: translateX(0) rotate(7deg)
   }
}

h2 {
   font-size: 2em;
   color: #555;
   text-align: center;
}

.input-group {

   width: 20em;
   margin: 1em 0;
}

.input-group label {
   position: absolute;
   top: 50%;
   left: 0.625em;
   transform: translateY(-50%);
   font-size: 1em;
   color: #333;
   padding: 0 0.313;
   pointer-events: none;
   transition: .5s;
}

.input-group input {
   width: 100%;
   height: 100%;
   font-size: 1em;
   color: #333;
   padding: 0.313em 0.625em;
   background: transparent;
   border: 1px solid #333;
   outline: none;
   border-radius: 5px;
}

.input-group input:focus~label,
.input-group input:valid~label {
   top: 0;
   font-size: 0.75em;
   background: #fff;
}

.btn {
   height: 2.5em;
   background: linear-gradient(to right, #8EC8EC, #6eb19b);
   box-shadow: 0 2px 10px rgba(0, 0, 0, .4);
   font-size: 1em;
   color: #fff;
   font-weight: 500;
   cursor: pointer;
   border-radius: 5px;
   border: none;
   outline: none;
   margin: 1em 0;
}

.sign-link {
   font-size: 0.875em;
   text-align: center;
   margin: 25px 0;
}

.sign-link p {
   color: #333;
}

.sign-link p a {
   color: #e91e63;
   text-decoration: none;
   font-weight: 600;
}

/* Logo */
.logoLogin {
   max-width: 15em;
}

.logoSignUp {
   max-width: 9em;
}
</style>
