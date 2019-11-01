import axios from 'axios';

const instance = axios.create({
  baseURL: 'http://localhost:8000',
  timeout: 1000
});

export function createGrocery(name) {
  return instance.post('/api/grocery', name);
}

export function getGroceries() {
  return instance.get('/api/groceries');
}

export function createGroceryList(name) {
  return instance.post('/api/grocerylist/new', name);
}

