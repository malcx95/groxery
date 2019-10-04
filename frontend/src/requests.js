import axios from 'axios';

const instance = axios.create({
  baseURL: 'http://localhost:8000',
  timeout: 1000
});

export function createGrocery(name) {
  instance.post('/api/grocery', {
    name: name
  }).then(response => {
    console.log(response);
  }).catch(err => {
    console.error(err);
  });
}

export function getGroceries() {
  instance.get('/api/groceries').then(
    groceries => {
      console.log(groceries);
    }
  );
}

