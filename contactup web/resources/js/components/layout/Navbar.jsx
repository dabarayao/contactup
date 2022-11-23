import React from 'react';
import { NavLink } from "react-router-dom";

import Logo from '../../img/contact_up.png';


var langui = localStorage.getItem("language");
var theme = localStorage.getItem("theme");


function Navbar() {
    return (
        <nav className={theme == 1 ? "navbar navbar-expand-sm navbar-dark bg-dark" : "navbar navbar-expand-sm navbar-light bg-light" } >
            <div className="container" style={{fontSize: "16px"}}>
                <a className="navbar-brand" href="#"><img src={Logo} className="img-fluid rounded-top" width="60" height="60" alt="" /></a>
                <button className="navbar-toggler d-lg-none" type="button" data-bs-toggle="collapse" data-bs-target="#collapsibleNavId" aria-controls="collapsibleNavId"
                    aria-expanded="false" aria-label="Toggle navigation">
                    <span className="navbar-toggler-icon"></span>
                </button>
                <div className="collapse navbar-collapse" id="collapsibleNavId">
                    <ul className="navbar-nav me-auto mt-2 mt-lg-0">
                        <NavLink
                            className="nav-link"
                            to="/"
                        >
                            <i className="fad fa-home"></i> { langui == 1 ? "Home" :  "Accueil"}
                        </NavLink>
                        <NavLink
                            className="nav-link"
                            to="/favs"
                        >
                            <i className="fad fa-stars"></i> { langui == 1 ? "My favorites" :  "Mes favoris"}
                        </NavLink>
                        <NavLink
                            className="nav-link"
                            to="/archs"
                        >
                            <i className="fad fa-archive"></i> Archive
                        </NavLink>
                        <NavLink
                            className="nav-link"
                            to="/about"
                        >
                            <i className="fad fa-info-circle"></i> { langui == 1 ? "About" :  "A propos"}
                        </NavLink>
                        <NavLink
                            className="nav-link"
                            to="/settings"
                        >
                            <i className="fad fa-cog"></i> { langui == 1 ? "Settings" :  "Paramètres"}
                        </NavLink>
                    </ul>
                    <form className="d-flex my-2 my-lg-0">
                        {/* <input className="form-control me-sm-2" type="text" placeholder="Search" /> */}
                        <NavLink
                            className="nav-link"
                            to="/addContact"
                        >
                            <button className="btn btn-link  my-2 my-sm-0">{theme == 1 ? <i className="fas fa-plus text-light fa-lg"></i> : <i className="fas fa-plus text-dark fa-lg"></i>  } </button>
                        </NavLink>
                    </form>
                </div>
            </div>
        </nav>);
}

export default Navbar;
