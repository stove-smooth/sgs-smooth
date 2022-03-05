import store from "../../store/index";
import axios from "axios";

async function logoutUser() {
  await store.dispatch("user/logout");
  const stompSocketClient = await store.getters("utils/stompSocketClient");
  stompSocketClient.disconnect();
  window.location = process.env.VUE_APP_MAIN_URL;
}

export function setInterceptors(instance) {
  // Add a request interceptor
  instance.interceptors.request.use(
    function (config) {
      const accesstoken = store.getters["user/getAccessToken"];
      // Do something before request is sent
      if (accesstoken) {
        config.headers.Authorization = accesstoken;
      }
      return config;
    },
    function (error) {
      // Do something with request error
      return Promise.reject(error);
    }
  );

  // Add a response interceptor
  instance.interceptors.response.use(
    function (response) {
      // Any status code that lie within the range of 2xx cause this function to trigger
      // Do something with response data
      return response;
    },
    async function (error) {
      // Any status codes that falls outside the range of 2xx cause this function to trigger
      // Do something with response error
      if (
        error.response?.status === 401 &&
        window.location.pathname !== "/login" &&
        window.location.pathname != "/register"
      ) {
        const accesstoken = store.getters["user/getAccessToken"];
        const refreshtoken = store.getters["user/getRefreshToken"];
        axios
          .post(process.env.VUE_APP_BASE_URL + "auth-server/refresh", {
            headers: {
              AUTHORIZATION: accesstoken,
              "REFRESH-TOKEN": refreshtoken,
            },
          })
          .then(function (response) {
            console.log("응답", response);
          })
          .catch((error) => {
            console.log("error : ", error.response);
            logoutUser();
          });
      }
      return Promise.reject(error);
    }
  );
  return instance;
}
