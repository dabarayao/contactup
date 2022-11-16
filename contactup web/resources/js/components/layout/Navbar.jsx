import React from 'react';
import { NavLink } from "react-router-dom";


function Navbar() {
    return (
        <nav className="navbar navbar-expand-sm navbar-light bg-light">
            <div className="container">
                <a className="navbar-brand" href="#"><img src="assets/images/contact_up.png" className="img-fluid rounded-top" width="60" height="60" alt="" /></a>
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
                            <i className="fad fa-home"></i> Accueil
                        </NavLink>
                        <NavLink
                            className="nav-link"
                            to="/favs"
                        >
                            <i className="fad fa-stars"></i> Mes favoris
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
                            <i className="fad fa-info-circle"></i> A propos
                        </NavLink>
                        <li className="nav-item">
                            <a className="nav-link" href="#"><i className="fad fa-cog"></i> Paramètres</a>
                        </li>
                    </ul>
                    <form className="d-flex my-2 my-lg-0">
                        {/* <input className="form-control me-sm-2" type="text" placeholder="Search" /> */}
                        <button className="btn btn-outline-success my-2 my-sm-0"><i class="fas fa-plus fa-lg"></i> </button>
                    </form>
                </div>
            </div>
        </nav>);
}

export default Navbar;
