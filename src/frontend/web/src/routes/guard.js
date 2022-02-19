function loadGuard(router, store) {
  router.beforeEach((to, from, next) => {
    const isLogin = store.getters["user/getEmail"];
    if (to.meta.auth && !isLogin) {
      this.$swal.fire({
        title: "인증이 필요합니다.",
      });
      next("/login");
      return;
    }
    next();
  });
}

export { loadGuard };
