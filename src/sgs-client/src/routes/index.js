import Vue from "vue";
import VueRouter from "vue-router";
import LoginPage from "../pages/LoginPage.vue";
import RegisterPage from "../pages/RegisterPage.vue";
import MyPage from "../pages/Mypage.vue";
import NotFoundPage from "../pages/NotFoundPage.vue";
import UserSettingPage from "../pages/UserSettingPage.vue";
import ServerPage from "../pages/ServerPage.vue";
import ServerWelcomePage from "../pages/ServerWelcomePage.vue";
import PrivateDMPage from "../pages/PrivateDMPage.vue";

import store from "../store/index";
Vue.use(VueRouter);

export const router = new VueRouter({
  mode: "history",
  routes: [
    {
      path: "/",
      redirect: () => {
        const isLogin = store.getters["user/getEmail"];
        if (!isLogin) {
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
      path: "/channels/@me/:id",
      name: "PrivateDMPage",
      component: PrivateDMPage,
      meta: { auth: true },
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
      path: "/channels/:serverid/:channelid",
      name: "ServerPage",
      component: ServerPage,
    },
    {
      path: "/channels/:serverid",
      name: "ServerWelcomePage",
      component: ServerWelcomePage,
    },
    {
      path: "*",
      component: NotFoundPage,
    },
  ],
});

router.beforeEach((to, from, next) => {
  const isLogin = store.getters["user/getEmail"];
  if (to.meta.auth && !isLogin) {
    alert("인증이 필요합니다.");
    next("/login");
    return;
  }
  next();
});
