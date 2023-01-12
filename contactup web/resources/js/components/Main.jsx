import React, {Component} from 'react';
import ReactDOM from "react-dom/client";
import { BrowserRouter, Routes, Route } from "react-router-dom"; // importing the router's package
import 'bootstrap/dist/css/bootstrap.css'; // importing the css of bootstrap
import './styles.css'; // stylesheet fro the page

import Home from './contact_list/Home'; // imorting the Home page
import Favs from './contact_list/Favs'; // imorting the Favorites page
import Archs from './contact_list/Archs'; // imorting the Archive page
import About from './about_settings/About'; //importing the About page
import AddContact from './add_edit/AddContact'; // importing the AddContact page
import EditContact from './add_edit/EditContact'; // importing the EditContact page
import Settings from './about_settings/Settings';
import NavbarFooter from './layout/NavbarFooter';
import NotFound from './errors/NotFound404';


class Main extends Component {
  constructor(props) {
      super(props);
    this.state = {
    };
  }



  render() {
      return (
        // The list of all routes of the web app
        <BrowserRouter>
        <Routes>
            <Route path="/" element={<NavbarFooter />}>
                <Route index element={<Home />} />
                <Route path="/favs" element={<Favs />} />
                <Route path="/archs" element={<Archs />} />
                <Route path="/about" element={<About />} />
                <Route path="/settings" element={<Settings />} />
                <Route path="/addContact" element={<AddContact />} />
                <Route path="/edit/:conId" element={<EditContact />} />

                <Route path="*" element={<NotFound />} />
            </Route>


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
