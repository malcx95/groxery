import React from "react";
import { createGrocery, createGroceryList, getGroceries } from './requests';

export class Home extends React.Component {

  constructor(props) {
    super(props);
    this.state = {currName: ''};

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
  }

  handleSubmit(event) {
    createGroceryList(this.state.currName).then(
      data => console.log(data)
    ).catch(
      error => {
        if (error.response.data === "listAlreadyExists") {
          alert("This list already exists!");
        } else {
          alert("An unknown error occurred!");
        }
      }
    );
    event.preventDefault();
  }

  handleChange(event) {
    this.setState({currName: event.target.value});
  }

  render() {
    return (
      <div>
        <h2>Home</h2>
        <p>Here are your grocery lists</p>

        <form onSubmit={this.handleSubmit}>
          <label>Name:
            <input
              type="text"
              name="name"
              value={this.state.currName}
              onChange={this.handleChange}/>
          </label>
          <input type="submit" value="Submit"/>
        </form>
      </div>
    );
  }
}
