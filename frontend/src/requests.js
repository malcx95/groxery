import axios from 'axios';

const instance = axios.create({
  baseURL: 'http://localhost:8000',
  timeout: 1000
});

export function createGrocery(name) {
  return instance.post('/api/grocery', {
    name: name
  });
}

export function getGroceries() {
  instance.get('/api/groceries').then(
    groceries => {
      console.log(groceries);
    }
  );
}

