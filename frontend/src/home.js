import React from "react";
import { createGrocery, getGroceries } from './requests';

export class Home extends React.Component {

  constructor(props) {
    super(props);
  }

  handleSubmit(event) {
    createGrocery('kebaben');
    event.preventDefault();
  }

  render() {
    return (
      <div>
        <h2>Home</h2>
        <p>Here are your grocery lists</p>

        <form onSubmit={this.handleSubmit}>
          <label>Name:
            <input type="text" name="name" />
          </label>
          <input type="submit" value="Submit"/>
        </form>
      </div>
    );
  }
}

