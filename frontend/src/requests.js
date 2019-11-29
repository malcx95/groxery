import axios from 'axios';

const instance = axios.create({
  baseURL: 'http://localhost:8000',
  timeout: 1000
});

export function createGrocery(name) {
  return instance.post('/api/grocery', name);
}

export function getGroceryLists() {
  return instance.get('/api/grocerylist/all');
}

export function createGroceryList(name) {
  return instance.post('/api/grocerylist/new', name);
}

