import Vue from 'vue';
import VueRouter from 'vue-router';
import LoginPage from '../pages/LoginPage.vue';
import SignupPage from '../pages/SignupPage.vue';
import MyPage from '../pages/Mypage.vue';
import NotFoundPage from '../pages/NotFoundPage.vue';
Vue.use(VueRouter)

export const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/',
      redirect: '/login',
    },
    {
      path: '/login',
      name: 'login',
      component: LoginPage,
    },
    {
      path: '/signup',
      name: 'signupPage',
      component: SignupPage,
    },
    {
      path: '/channels/@me',
      name: 'MyPage',
      component: MyPage,
    },
    {
      path: '*',
      component: NotFoundPage,
    },
  ]
});
