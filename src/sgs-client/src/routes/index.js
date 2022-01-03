import Vue from "vue";
import VueRouter from "vue-router";
import LoginPage from "../pages/LoginPage.vue";
import RegisterPage from "../pages/RegisterPage.vue";
import MyPage from "../pages/Mypage.vue";
import NotFoundPage from "../pages/NotFoundPage.vue";
import UserSettingPage from "../pages/UserSettingPage.vue";
import store from "../store/index";
Vue.use(VueRouter);

export const router = new VueRouter({
  mode: "history",
  routes: [
    {
      path: "/",
      redirect: () => {
        if (!store.getters.isLogin) {
          return "/login";
        } else {
          return "/channels/@me";
        }
      },
    },
    {
      path: "/login",
      name: "login",
      component: LoginPage,
    },
    {
      path: "/register",
      name: "registerPage",
      component: RegisterPage,
    },
    {
      path: "/channels/@me",
      name: "MyPage",
      component: MyPage,
      meta: { auth: true },
    },
    {
      path: "/settings",
      name: "UserSettingPage",
      component: UserSettingPage,
      meta: { auth: true },
    },
    {
      path: "*",
      component: NotFoundPage,
    },
  ],
});

router.beforeEach((to, from, next) => {
  if (to.meta.auth && !store.getters.isLogin) {
    alert("인증이 필요합니다.");
    next("/login");
    return;
  }
  next();
});
