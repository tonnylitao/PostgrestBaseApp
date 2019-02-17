import axios from "axios";
import config from "./config.js";

const restAppId = process.env.REST_APP_ID;
const token = process.env.token;

const instance = axios.create({
  baseURL: config.apiHost,
  timeout: 180000,
  headers: {
    "X-App-Id": restAppId
  }
});

axios.interceptors.request.use(
  function(config) {
    config.headers.Authorization = `Bearer ${token}`;

    return config;
  },
  function(error) {
    return Promise.reject(error);
  }
);

export default {
  community: {
    comments: {
      get: params => instance.get("/comments", { params }),
      delete: id => instance.delete(`/comments?id=${id}`)
    },
    groups: {
      get: params => instance.get("/groups", { params }),
      delete: id => instance.delete(`/groups?id=${id}`)
    },
    posts: {
      get: params => instance.get("/posts", { params }),
      delete: id => instance.delete(`/posts?id=${id}`)
    },
    stars: {
      get: params => instance.get("/stars", { params })
    },
    me: {
      get: params => instance.get("/me", { params }),
      patch: data => instance.patch("/me", data)
    },
    usergroups: {
      get: params => instance.get("/usergroups", { params })
    }
  },
  ecommerce: {
    products: {
      get: params => instance.get("/products", { params }),
      patch: data => instance.patch("/products", data)
    },
    stores: {
      get: params => instance.get("/stores", { params })
    }
  }
};
