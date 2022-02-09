function loadGuard(router, store) {
  router.beforeEach((to, from, next) => {
    /* if(to.params?.message==="resetStore"){
      if(to.params.type==="sessionOut"){
        next({name:"Login",params:{message:"logout"}})
      }
    } */
    const isLogin = store.getters["user/getEmail"];
    if (to.meta.auth && !isLogin) {
      alert("인증이 필요합니다.");
      next("/login");
      return;
    }
    next();
  });
}

export { loadGuard };
