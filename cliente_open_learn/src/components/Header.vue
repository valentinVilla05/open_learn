<script setup>

</script>
<template>
    <header class="text-white p-3">
        <div class="container d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center">
                <!-- Logo -->
                <img src="/logo.png" alt="Logo" class="img-fluid" style="max-width: 60px;">
                <h1 class="mb-0 ms-3">OpenLearn</h1>
            </div>

            <!-- Menú de Navegación -->
            <nav class="navbar navbar-expand-md navbar-light">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                    <ul class="navbar-nav ms-auto text-center">
                        <li class="nav-item">
                            <RouterLink class="nav-link" to="/sobreNosotros">Quienes Somos</RouterLink>
                        </li>
                        <li class="nav-item">
                            <RouterLink class="nav-link" to="/login" v-if="!userAuth">Iniciar Sesión</RouterLink>
                        </li>
                    </ul>

                    <!-- Menú de usuario -->
                    <div class="dropdown ms-3" v-if="userAuth">
                        <button class="btn btn-secondary dropdown-toggle d-flex align-items-center" type="button"
                            id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
                            <img src="/favicon.png" alt="Perfil" class="img-fluid me-2"
                                style="max-width: 60px; height: auto;">
                            <span class="visually-hidden">Abrir menú de usuario</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton1">
                            <li>
                                <RouterLink class="dropdown-item"></RouterLink>
                            </li>
                            <li ">
                                <RouterLink class=" dropdown-item">
                                </RouterLink>
                            </li>
                            <li>
                                <RouterLink class="dropdown-item" to="/cliente"></RouterLink>
                            </li>
                            <li>
                                <a class="dropdown-item text-danger" @click="logOut">Cerrar Sesión</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </div>
    </header>

</template>
<style scoped>
header {
    background-color: #8EC8EC;
}
</style>