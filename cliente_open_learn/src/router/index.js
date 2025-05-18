import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '@/views/HomePage.vue'
import Login from '../views/Login.vue'
import About from '../views/About.vue'
import Catalog from '@/views/Catalog.vue'
import Certificates from '@/views/Academy.vue'
import Course from '@/views/Course.vue'
import MyAccount from '@/views/MyAccount.vue'
import UserManagement from '@/views/UserManagement.vue'
import CourseManagement from '@/views/CourseManagement.vue'
import ControlPanel from '@/views/ControlPanel.vue'
import CourseCreator from '@/views/CourseCreator.vue'
import Faq from '@/views/Faq.vue'
import Resource from '@/views/Resource.vue'
import Exam from '@/views/Exam.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomePage,
    },
    {
      path: '/login',
      name: 'login',
      component: Login,
    },
    {
      path: '/catalog',
      name: 'courses',
      component: Catalog,
    },
    {
      path: '/course/:course_id',
      name: 'course',
      component: Course
    },
    {
      path: '/my_academy',
      name: 'academy',
      component: Certificates,
    },
    {
      path: '/course/:course_id/resource/:resource_id',
      name: 'resource',
      component: Resource
    },
    {
      path: '/course/:course_id/finalhoot/:exam_id',
      name: 'exam',
      component: Exam
    },
    {
      path: '/about',
      name: 'about',
      component: About,
    },
    {
      path: '/myaccount',
      name: 'myaccount',
      component: MyAccount,
    },
    {
      path: '/controlPanel',
      name: 'controlPanel',
      component: ControlPanel,
    },
    {
      path: '/controlPanel/userManagement',
      name: 'userManagement',
      component: UserManagement,
    },
    {
      path: '/controlPanel/courseManagement',
      name: 'courseManagement',
      component: CourseManagement,
    },
    {
      path: '/controlPanel/courseCreator',
      name: 'courseCreator',
      component: CourseCreator
    },
    {
      path: '/faq',
      name: 'frequentQuestion',
      component: Faq
    }
  ],
})

export default router
