import axios from 'axios';
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
      get: query => axios.get('/api/comments', { query }),
      post: data => axios.post('/api/comments', data),
      patch: data => axios.patch('/api/comments', data),
      delete: id => axios.delete('/api/comments?id=${id}')
    },
    follows: {
      get: query => axios.get('/api/follows', { query }),
      post: data => axios.post('/api/follows', data),
      delete: id => axios.delete('/api/follows?id=${id}')
    },
    groups: {
      get: query => axios.get('/api/groups', { query }),
      post: data => axios.post('/api/groups', data),
      patch: data => axios.patch('/api/groups', data),
      delete: id => axios.delete('/api/groups?id=${id}')
    },
    messages: {
      get: query => axios.get('/api/messages', { query }),
      post: data => axios.post('/api/messages', data),
      delete: id => axios.delete('/api/messages?id=${id}')
    },
    posts: {
      get: query => axios.get('/api/posts', { query }),
      post: data => axios.post('/api/posts', data),
      patch: data => axios.patch('/api/posts', data),
      delete: id => axios.delete('/api/posts?id=${id}')
    },
    stars: {
      get: query => axios.get('/api/stars', { query }),
      post: data => axios.post('/api/stars', data),
      delete: id => axios.delete('/api/stars?id=${id}')
    },
    me: {
      get: query => axios.get('/api/me', { query }),
      patch: data => axios.patch('/api/me', data)
    },
    usergroups: {
      get: query => axios.get('/api/usergroups', { query }),
      post: data => axios.post('/api/usergroups', data),
      delete: id => axios.delete('/api/usergroups?id=${id}')
    }
  },
  ecommerce: {
    addresses: {
      get: query => axios.get('/api/addresses', { query }),
      post: data => axios.post('/api/addresses', data)
    },
    store_orders: {
      get: query => axios.get('/api/store_orders', { query }),
      patch: data => axios.patch('/api/store_orders', data)
    },
    payments: {
      post: data => axios.post('/api/payments', data)
    },
    products: {
      get: query => axios.get('/api/products', { query }),
      post: data => axios.post('/api/products', data),
      patch: data => axios.patch('/api/products', data)
    },
    stores: {
      get: query => axios.get('/api/stores', { query }),
      post: data => axios.post('/api/stores', data),
      patch: data => axios.patch('/api/stores', data)
    }
  }
}