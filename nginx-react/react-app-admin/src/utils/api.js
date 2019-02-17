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
  community: {
    comments: {
      get: query => axios.get("/api/comments", { query }),
      delete: id => axios.delete("/api/comments?id=${id}")
    },
    groups: {
      get: query => axios.get("/api/groups", { query }),
      delete: id => axios.delete("/api/groups?id=${id}")
    },
    posts: {
      get: query => axios.get("/api/posts", { query }),
      delete: id => axios.delete("/api/posts?id=${id}")
    },
    stars: {
      get: query => axios.get("/api/stars", { query })
    },
    me: {
      get: query => axios.get("/api/me", { query }),
      patch: data => axios.patch("/api/me", data)
    },
    usergroups: {
      get: query => axios.get("/api/usergroups", { query })
    }
  },
  ecommerce: {
    products: {
      get: query => axios.get("/api/products", { query }),
      patch: data => axios.patch("/api/products", data)
    },
    stores: {
      get: query => axios.get("/api/stores", { query })
    }
  }
};
