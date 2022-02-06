import Vue from "vue";
import VueRouter from "vue-router";
import LoginPage from "../pages/LoginPage.vue";
import RegisterPage from "../pages/RegisterPage.vue";
import MyPage from "../pages/Mypage.vue";
import NotFoundPage from "../pages/NotFoundPage.vue";
import UserSettingPage from "../pages/UserSettingPage.vue";
import PrivateDMPage from "../pages/PrivateDMPage.vue";
import MainPage from "../pages/MainPage.vue";
import InvitePage from "../pages/InvitePage.vue";
import ServerWelcomePage from "../pages/ServerWelcomePage.vue";
import ServerPage from "../pages/ServerPage.vue";
Vue.use(VueRouter);

export const router = new VueRouter({
  mode: "history",
  routes: [
    {
      path: "/login",
      name: "LoginPage",
      component: LoginPage,
    },
    {
      path: "/register",
      name: "RegisterPage",
      component: RegisterPage,
    },
    {
      path: "/invite/:invitePath/:communityId",
      name: "InvitePage",
      component: InvitePage,
    },
    {
      path: "/",
      name: "MainPage",
      component: MainPage,
      children: [
        {
          path: "channels/@me/:id",
          name: "privateDmPage",
          component: PrivateDMPage,
          meta: { auth: true },
        },
        {
          path: "channels/@me",
          name: "MyPage",
          component: MyPage,
          meta: { auth: true },
        },
        {
          path: "settings",
          name: "UserSettingPage",
          component: UserSettingPage,
          meta: { auth: true },
        },
        {
          path: "channels/:serverid/:channelid",
          name: "ServerPage",
          component: ServerPage,
          meta: { auth: true },
        },
        {
          path: "channels/:serverid",
          name: "ServerWelcomePage",
          component: ServerWelcomePage,
          meta: { auth: true },
        },
      ],
    },
    {
      path: "*",
      component: NotFoundPage,
    },
  ],
});
