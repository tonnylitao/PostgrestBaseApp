import axios from "axios";

import config from "./config.js";

const restAppId = process.env.REST_APP_ID;

const instance = axios.create({
  baseURL: config.apiHost,
  timeout: 180000,
  headers: {
    "X-App-Id": restAppId
  }
});

export default {
  post: {
    get: () => instance.get("/posts?order=id.desc"),
    getById: id => instance.get(`/posts?id=eq.${id}`)
  }
};
