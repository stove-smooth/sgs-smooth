import axios from "axios";
import { setInterceptors } from "./interceptors";
export default function axiosInstance() {
  const instance = axios.create({
    baseURL: process.env.VUE_APP_BASE_URL,
  });
  return setInterceptors(instance);
}
