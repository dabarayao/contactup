import React from 'react';
import { NavLink } from "react-router-dom"; // importing the nav link package

import Logo from '../../img/contact_up.png'; // importing contact up logo
import "./Footer.css";

var langui = localStorage.getItem("language"); // get the language write on local file
var theme = localStorage.getItem("theme"); // get the theme write on local file


function Footer() {
    return (
        <>

            <div style={{marginTop: 80}}>&nbsp;</div>
            <div className="container-fluid my-5">

                <footer className="text-center text-lg-start" style={{backgroundColor: "#4DB6BC"}}>
                    <div className="context container d-flex justify-content-center py-2">
                        <a role="button" href="https://twitter.com/yioxreborn2048" target="_blank" className="btn btn-lg btn-floating mx-2" style={{backgroundColor: "#F3C061", color: "#333"}}>
                            <i className="fab fa-twitter"></i>
                        </a>
                        <a role="button" href="https://www.youtube.com/@yaodabara" target="_blank" className="btn btn-lg btn-floating mx-2" style={{backgroundColor: "#F3C061", color: "#333"}}>
                            <i className="fab fa-linkedin"></i>
                        </a>
                        <a role="button" href="https://www.linkedin.com/in/dabarayao" target="_blank" className="btn btn-lg btn-floating mx-2" style={{backgroundColor: "#F3C061", color: "#333"}}>
                            <i className="fab fa-youtube"></i>
                        </a>
                        <a role="button" href="https://linktr.ee/dabarayao" target="_blank" className="btn btn-lg btn-floating mx-2" style={{backgroundColor: "#F3C061", color: "#333"}}>
                            <i className="fas fa-link"></i>
                        </a>
                    </div>

                    <div className="area text-center text-white p-1" style={{backgroundColor: "rgba(0, 0, 0, 0.2)", fontSize: "17px"}}>
                    © 2022 Contact Up: by Yao Dabara
                    </div>
                </footer>

            </div>
        </>
    );
}

export default Footer;
