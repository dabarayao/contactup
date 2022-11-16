// This is the about page to explain the app and his developer

import React from 'react';

import 'bootstrap/dist/css/bootstrap.css';
import Navbar from '../layout/Navbar';



function About() {
    return (
        <div className="contactUp">

            <Navbar />

            <div class="container">
                <div className="container">
                    <br />
                    <nav className="breadcrumb">
                        <a className="breadcrumb-item" href="#"><i className="fas fa-home"></i>A propos</a>
                        <span className="breadcrumb-item active" aria-current="page">A propos de nous</span>
                    </nav>

                    <h1>A propos de nous</h1>

                    {/* <img src="assets/images/contact_up.png" width="200" /> */}
                    <br />

                    <div class="row  align-items-center">
                        <div class="col-md-4"><img src="assets/images/contact_up.png" width="200" /></div>
                        <div class="col-md-4">
                            <h3>Informations sur le developpeur</h3>
                            <div class="d-flex">
                                <div class="flex-shrink-0">
                                    <img src="assets/images/dabyao.webp" alt="" width="100" />
                                </div>
                                <div class="flex-grow-1 ms-3">
                                    <h5 class="mt-0">Yao Dabara Mickael</h5>
                                    Tel: +2250779549937<br />
                                    email: dabarayao@gmail.com


                              </div>
                            </div>
                            <br />

                            Contact up est une application créé par le développeur Yao Dabara Mickael. Elle permet de sauvegarder ses contacts téléphonique sur un serveur distant.
                        </div>
                    </div>




                </div>


            </div>

        </div>
    );
}

export default About;
