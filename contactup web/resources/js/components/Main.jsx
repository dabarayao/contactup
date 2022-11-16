import React, {Component} from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter, Routes, Route } from "react-router-dom";
import 'bootstrap/dist/css/bootstrap.css';
import './styles.css';

import Home from './contact_list/Home';
import Favs from './contact_list/Favs';
import Archs from './contact_list/Archs';
import About from './about_settings/About';





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

      </Routes>
    </BrowserRouter>
    );
  }
}

export default Main;

if (document.getElementById('main')) {
    ReactDOM.render(<Main />, document.getElementById('main'));
}
