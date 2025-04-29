<script setup>
import { ref } from 'vue'

// Control to login/register animation
const isSignUp = ref(false)

const switchToSignUp = () => {
   isSignUp.value = true
}

const switchToSignIn = () => {
   isSignUp.value = false
}

</script>

<template>
   <div class="wrapper" :class="isSignUp ? 'animate signUp' : 'animate signIn'">
      <!-- Login Form -->
      <div class="form-wrapper sign-up">
         <form>
            <h2>Login</h2>
            <div class="input-group">
               <input type="text" name="email" required />
               <label for="email">Email</label>
            </div>
            <div class="input-group">
               <input type="password" name="password" required />
               <label for="password">Password</label>
            </div>
            <button type="submit" class="btn">Log in</button>
            <div class="signUp-link">
               <p>Don't have an account?
                  <a href="#" @click.prevent="switchToSignUp">Sign Up</a>
               </p>
            </div>
         </form>
      </div>

      <!-- Register Form -->
      <div class="form-wrapper sign-in">
         <form>
            <h2>Sign Up</h2>
            <div class="input-group">
               <input type="text" name="username" required />
               <label for="username">Username</label>
            </div>
            <div class="input-group">
               <input type="email" name="email" required />
               <label for="email">Email</label>
            </div>
            <div class="input-group">
               <input type="password" name="password" required />
               <label for="password">Password</label>
            </div>
            <button type="submit" class="btn">Register</button>
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
   position: relative;
   width: 25em;
   height: 31.25em;
}

.form-wrapper {
   position: absolute;
   top: 0;
   left: 0;
   display: flex;
   justify-content: center;
   align-items: center;
   width: 100%;
   height: 100%;
   background: #fff;
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
   font-size: 1.875em;
   color: #555;
   text-align: center;
}

.input-group {
   position: relative;
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
   position: relative;
   width: 100%;
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
</style>
