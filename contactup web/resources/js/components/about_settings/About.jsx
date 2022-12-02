// This is the about page to explain the app and his developer

import React from 'react';

import 'bootstrap/dist/css/bootstrap.css';
import Navbar from '../layout/Navbar';
import Footer from '../layout/Footer';

import dabPic from '../../img/dabyao.webp';
import Logo from '../../img/contact_up.png';

var langui = localStorage.getItem("language");

function About() {
    document.title = langui == 1 ? "Contact up - About" : "Contact up - A propos";  // editing the title of page

    return (
        <div className="contactUp">

            <Navbar />

            <div className="container">
                    <br />
                    <nav className="breadcrumb">
                        <a className="breadcrumb-item" style={{textDecoration: "none"}} href="#"><i className="fas fa-home"></i>{ langui == 1 ? " Home" :  " Accueil"}</a>
                        <span className="breadcrumb-item active" aria-current="page">{ langui == 1 ? "About us" :  "A propos de nous"}</span>
                    </nav>

                    <h1>{ langui == 1 ? "About us" :  "A propos de nous"}</h1>

                    {/* <img src="assets/images/contact_up.png" width="200" /> */}
                    <br />

                    <div className="row  align-items-center">
                        <div className="col-md-4"><img src={Logo} width="200" /></div>
                        <div className="col-md-4">
                            <h3>{ langui == 1 ? "Developer information" :  "Informations sur le developpeur"} </h3>
                            <div className="d-flex">
                                <div className="flex-shrink-0">
                                    <img src={dabPic} alt="" width="100" />
                                </div>
                                <div className="flex-grow-1 ms-3">
                                    <h5 className="mt-0">Yao Dabara Mickael</h5>
                                    Tel: +2250779549937<br />
                                    email: dabarayao@gmail.com


                              </div>
                            </div>
                            <br />
                            { langui == 1 ? "Contact up is an application created by the developer Yao Dabara Mickael. It allows you to save your phone contacts on a remote server." :  "Contact up est une application créé par le développeur Yao Dabara Mickael. Elle permet de sauvegarder ses contacts téléphonique sur un serveur distant."}
                            </div>
                    </div>





            </div>

           <Footer />
        </div>
    );
}

export default About;
