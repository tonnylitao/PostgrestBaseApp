import axios from 'axios';
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

axios.interceptors.request.use(function (config) {
  config.headers.Authorization = `Bearer ${token}`;

  return config;
}, function (error) {
  return Promise.reject(error);
});

export default {
  community: {
    comments: {
      get: params => instance.get('/comments', { params }),
      post: data => instance.post('/comments', data),
      patch: data => instance.patch('/comments', data),
      delete: id => instance.delete(`/comments?id=${id}`)
    },
    follows: {
      get: params => instance.get('/follows', { params }),
      post: data => instance.post('/follows', data),
      delete: id => instance.delete(`/follows?id=${id}`)
    },
    groups: {
      get: params => instance.get('/groups', { params }),
      post: data => instance.post('/groups', data),
      patch: data => instance.patch('/groups', data),
      delete: id => instance.delete(`/groups?id=${id}`)
    },
    messages: {
      get: params => instance.get('/messages', { params }),
      post: data => instance.post('/messages', data),
      delete: id => instance.delete(`/messages?id=${id}`)
    },
    posts: {
      get: params => instance.get('/posts', { params }),
      post: data => instance.post('/posts', data),
      patch: data => instance.patch('/posts', data),
      delete: id => instance.delete(`/posts?id=${id}`)
    },
    stars: {
      get: params => instance.get('/stars', { params }),
      post: data => instance.post('/stars', data),
      delete: id => instance.delete(`/stars?id=${id}`)
    },
    me: {
      get: params => instance.get('/me', { params }),
      patch: data => instance.patch('/me', data)
    },
    usergroups: {
      get: params => instance.get('/usergroups', { params }),
      post: data => instance.post('/usergroups', data),
      delete: id => instance.delete(`/usergroups?id=${id}`)
    }
  },
  ecommerce: {
    addresses: {
      get: params => instance.get('/addresses', { params }),
      post: data => instance.post('/addresses', data)
    },
    store_orders: {
      get: params => instance.get('/store_orders', { params }),
      patch: data => instance.patch('/store_orders', data)
    },
    payments: {
      post: data => instance.post('/payments', data)
    },
    products: {
      get: params => instance.get('/products', { params }),
      post: data => instance.post('/products', data),
      patch: data => instance.patch('/products', data)
    },
    stores: {
      get: params => instance.get('/stores', { params }),
      post: data => instance.post('/stores', data),
      patch: data => instance.patch('/stores', data)
    }
  }
}