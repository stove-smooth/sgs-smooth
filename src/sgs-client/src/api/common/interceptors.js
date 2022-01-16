import store from "../../store/index";
import axios from "axios";

async function logoutUser() {
  await this.$store.dispatch("LOGOUT");
  this.$router.push("/");
}

export function setInterceptors(instance) {
  // Add a request interceptor
  instance.interceptors.request.use(
    function (config) {
      // Do something before request is sent
      config.headers.Authorization = store.state.accesstoken;
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
        axios
          .post("http://52.79.229.100:8000/auth-server/refresh", {
            headers: {
              AUTHORIZATION: this.$store.state.accesstoken,
              "REFRESH-TOKEN": this.$store.state.refreshtoken,
            },
          })
          .then(function (response) {
            console.log("응답", response);
          })
          .catch((error) => {
            console.log("error : ", error.response);
            alert("로그아웃이 만료되었습니다.");
            logoutUser();
          });
      }
      return Promise.reject(error);
    }
  );
  return instance;
}
