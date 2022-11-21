import React, {Component} from 'react';
import ReactDOM from "react-dom/client";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import 'bootstrap/dist/css/bootstrap.css';
import './styles.css';

import Home from './contact_list/Home';
import Favs from './contact_list/Favs';
import Archs from './contact_list/Archs';
import About from './about_settings/About';
import AddContact from './add_edit/AddContact';
import EditContact from './add_edit/EditContact';
import Settings from './about_settings/Settings';




class Main extends Component {
  constructor(props) {
      super(props);
    this.state = {
    };
  }



  render() {
      return (
    <BrowserRouter>
      <Routes>
            <Route index element={<Home />} />
            <Route path="/favs" element={<Favs />} />
            <Route path="/archs" element={<Archs />} />
            <Route path="/about" element={<About />} />
            <Route path="/settings" element={<Settings />} />
            <Route path="/addContact" element={<AddContact />} />
            <Route path="/edit/:conId" element={<EditContact />} />

      </Routes>
    </BrowserRouter>
    );
  }
}

export default Main;

if (document.getElementById('main')) {
    const root = ReactDOM.createRoot(document.getElementById("main"));
    root.render(
    <React.StrictMode>
        <Main />
    </React.StrictMode>
    );
}
