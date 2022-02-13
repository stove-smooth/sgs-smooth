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
import CommunityWelcomePage from "../pages/CommunityWelcomePage.vue";
import CommunityPage from "../pages/CommunityPage.vue";

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
    //초대링크로 들어올 경우 진입하는 page
    {
      path: "/invite/:invitePath/:communityId",
      name: "InvitePage",
      component: InvitePage,
    },
    //로그인시 MainPage로 이동한다.
    {
      path: "/",
      name: "MainPage",
      component: MainPage,
      meta: { auth: true },
      children: [
        //direct message page
        {
          path: "channels/@me/:id",
          name: "privateDmPage",
          component: PrivateDMPage,
        },
        //처음 MainPage 진입시 channels/@me로 이동시킨다.
        {
          path: "channels/@me",
          name: "MyPage",
          component: MyPage,
        },
        //커뮤니티 내 채널 page
        {
          path: "channels/:serverid/:channelid",
          name: "CommunityPage",
          component: CommunityPage,
        },
        //커뮤니티 page, 커뮤니티에 채팅 채널이 존재하지 않을 경우 이 페이지로 이동한다.
        {
          path: "channels/:serverid",
          name: "CommunityWelcomePage",
          component: CommunityWelcomePage,
        },
        //개인 정보 설정 page
        {
          path: "settings",
          name: "UserSettingPage",
          component: UserSettingPage,
        },
      ],
    },
    {
      path: "*",
      component: NotFoundPage,
    },
  ],
});
