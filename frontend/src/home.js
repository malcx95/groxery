import React from "react";
import TextField from '@material-ui/core/TextField';
import Button from "@material-ui/core/Button";
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import { createGrocery, createGroceryList, getGroceryLists } from './requests';

function NewGroceryListDialog(props) {

  const [open, setOpen] = React.useState(false);

  const handleOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const handleSubmit = () => {
    setOpen(false);
    props.onSubmit(name);
  };

  let name = '';
  const handleChange = (event) => {
    name = event.target.value;
  };

  return (
    <div>
      <Button variant="contained" onClick={handleOpen}>
        New grocery list...
      </Button>
      <Dialog open={open} onClose={handleClose} aria-labelledby="form-dialog-title">
        <DialogTitle id="form-dialog-title">Enter a name for the list</DialogTitle>
        <DialogContent>
          <TextField
            autoFocus
            margin="dense"
            id="name"
            label="Name"
            fullWidth
            onChange={handleChange}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>
            Cancel
          </Button>
          <Button onClick={handleSubmit} color="primary">
            Create
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}

export class Home extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      currName: '',
      newGroceryListName: ''
    };

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.fetchGroceryLists = this.fetchGroceryLists.bind(this);

    this.fetchGroceryLists();
  }

  handleSubmit(name) {
    createGroceryList(name).then(
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
  }

  handleChange(event) {
    this.setState({currName: event.target.value});
  }

  fetchGroceryLists() {
    getGroceryLists().then(
      data => console.log(data)
    ).catch(
      error => console.error(error)
    );
  }

  render() {
    return (
      <div>
        <h2>Grocery lists</h2>
        <NewGroceryListDialog
          onSubmit={this.handleSubmit}
          name={this.state.newGroceryListName}
        />
      </div>
    );
  }
}

