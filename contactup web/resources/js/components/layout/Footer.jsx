import React from 'react';
import { NavLink } from "react-router-dom";

import Logo from '../../img/contact_up.png';
import "./Footer.css";

var langui = localStorage.getItem("language");
var theme = localStorage.getItem("theme");


function Footer() {
    return (

        <div className="container my-5">

            <footer className="text-center text-lg-start" style={{backgroundColor: "#4DB6BC"}}>
                <div className="context container d-flex justify-content-center py-4">
                <button type="button" className="btn btn-lg btn-floating mx-2" style={{backgroundColor: "#F3C061"}}>
                    <i className="fab fa-facebook-f"></i>
                </button>
                <button type="button" className="btn btn-lg btn-floating mx-2" style={{backgroundColor: "#F3C061"}}>
                    <i className="fab fa-youtube"></i>
                </button>
                <button type="button" className="btn btn-lg btn-floating mx-2" style={{backgroundColor: "#F3C061"}}>
                    <i className="fab fa-instagram"></i>
                </button>
                <button type="button" className="btn btn-lg btn-floating mx-2" style={{backgroundColor: "#F3C061"}}>
                    <i className="fab fa-twitter"></i>
                </button>
                </div>

                <div className="area text-center text-white p-3" style={{backgroundColor: "rgba(0, 0, 0, 0.2)", fontSize: "17px"}}>
                © 2022 Contact Up: by Yao Dabara
                </div>
            </footer>

        </div>
    );
}

export default Footer;
