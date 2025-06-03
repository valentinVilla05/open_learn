# open_learn: E-learning web

This project is a monorepo that contains n e-learning app. Includes a strong backend developed in **Laravel** (PHP) and a dinamic frontend developed in **Vue.js**.  The app is designed to offer a fluid and comfortable experience to the user with a system to manage the content efficienly.

---

## Used technologies

### Backend (Laravel)
* **PHP:** Main language.
* **Laravel Framework:** To develop fast apps.
* **MySQL:** Relational database.
* **JWT (JSON Web Tokens):** For authentizaction.
* **CORS (Cross-Origin Resource Sharing):** Configures to allow the communication between the backend and frontend.

### Frontend (Vue.js)
* **Vue.js:** Framework to build user intefaces. 
* **Vue Router:** For the client's routing.
* **CSS/Bootstrap:** For the style.

### Deployment
* **Render:** For the depoloyment of the backend.
* **Railway** For the database.
* **Netlify:** For the frontend

---

## Main feautes.

* **User authentication:** Register, login and session management through JWT.
* **Data management:** CRUD of courses, users and more information.
* **Taking exams:** Users can take a course's exam
* **Comment Section:** Users can post comments on the course's resources.

---

## Configuration and local execution

Follow the steps below:

### 1. Backend configuration (Laravel)

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/valentinVilla05/open_learn.git](https://github.com/valentinVilla05/open_learn.git)
    cd open_learn
    ```
2.  **Go to backend directory:**
    ```bash
    cd backend 
    ```
3.  **Install composer dependencies:**
    ```bash
    composer install
    ```
4.  **Copy the env file:**
    ```bash
    cp .env.example .env
    ```
5.  **Generate your APP_KEY:**
    ```bash
    php artisan key:generate
    ```
6.  **Configure your database in you `.env` file:**
    Open the `.env` file and configure your credentials of your database.
    ```dotenv
    DB_CONNECTION=mysql
    DB_HOST=127.0.0.1
    DB_PORT=3306
    DB_DATABASE=open_learn_db # O el nombre de tu base de datos local
    DB_USERNAME=root
    DB_PASSWORD=
    ```
7.  **Run the migrations in your database:**
    ```bash
    php artisan migrate
    ```
   (Optional) Run the seeder to fill your database with example data
    ```bash
    php artisan db:seed
    ```
8.  **Generat the JWT key:**
    ```bash
    php artisan jwt:secret
    ```
    Make sure that "JWT_SECRET" appears in your '.env' file
    
9.  **Run youur backend server:**
    ```bash
    php artisan serve
    ```
    The backned will be available in `http://127.0.0.1:8000` (or the indeicated port).

### 2. Frontend configuration (Vue.js)

1.  **Go to the frontend directory:**
    ```bash
    cd frontend
    ```
2.  **Install the Node.js dependencies:**
    ```bash
    npm install 
    ```
3.  **Run the Vue server:**
    ```bash
    npm run dev 
    ```
    It wil be available in `http://localhost:5173`.

---

## App deployment

### Backend in Render

The backend in Laravel is deployed in [Render.com](https://render.com/).

* **Backend URL:** `https://apiopenlearn.onrender.com`
* **Configuration of the backend:**
    * **Enviroments variables:** Like database credentials, `APP_KEY`, y `JWT_SECRET` must be configured in the enviroments variables.
    * **Configure the docker files:** Render doesn't offer an option to choose PHP or Laravel so it has to be deployed through Docker. 
    * **Build commands:** Render executes the necessary commands (`composer install`, `php artisan migrate --force`, etc.) during the the deploy.
    * **CORS:** The `config/cors.php` file must be configured to allow request from (`https://open-learn-daw.netlify.app`).

### Frontend in Netlify

The frontend is deployed in [Netlify.app](https://www.netlify.com/).

* **Frontend URL:** `https://open-learn-daw.netlify.app`
* **Configuration in Netlify:**
    * **GitHub connection:** Automatic deployment with each `push` to the configured branch.
    * **Base directory:** `frontend` .
    * **Build command:** `npm run build`.
    * **Publication directory:** `dist`.
    * **Enviroment variabled:** `VUE_APP_API_URL` points to the backend in Render (`https://apiopenlearn.onrender.com`).
    * **SPA redirections:** The  `frontend/public/_redirects` file must be configured with `/* /index.html 200` to manage the routing in the client side.
