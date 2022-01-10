import axios from "axios";
import { setInterceptors } from "./common/interceptors";

function createInstance() {
  const instance = axios.create({
    baseURL: "http://3.38.10.189:8000/",
  });
  return setInterceptors(instance);
}
const instance = createInstance();

function registerUser(userData) {
  return instance.post("auth-server/sign-up", userData);
}
function loginUser(userData) {
  return instance.post("auth-server/sign-in", userData);
}
export { registerUser, loginUser };
