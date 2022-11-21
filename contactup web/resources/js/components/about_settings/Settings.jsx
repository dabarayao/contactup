// This is the about page to explain the app and his developer

import React from 'react';

import 'bootstrap/dist/css/bootstrap.css';
import Navbar from '../layout/Navbar';

import './settings.css';


function Settings() {
    return (
        <div className="contactUp">

            <Navbar />

            <div className="container">
                <br />
                    <nav className="breadcrumb">
                        <a className="breadcrumb-item" href="#"><i className="fas fa-home"></i>Accueil</a>
                        <span className="breadcrumb-item active" aria-current="page">A propos de nous</span>
                    </nav>

                    <h1>A propos de nous</h1>

                    {/* <img src="assets/images/contact_up.png" width="200" /> */}
                <br />

                <div className="d-flex align-items-start justify-content-center">
                    <div className="nav flex-column nav-pills me-3" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                        <button className="nav-link active" id="v-pills-home-tab" data-bs-toggle="pill" data-bs-target="#v-pills-home" type="button" role="tab" aria-controls="v-pills-home" aria-selected="true">Langue</button>
                        <button className="nav-link" id="v-pills-profile-tab" data-bs-toggle="pill" data-bs-target="#v-pills-profile" type="button" role="tab" aria-controls="v-pills-profile" aria-selected="false">Thème</button>
                        <button className="nav-link" id="v-pills-messages-tab" data-bs-toggle="pill" data-bs-target="#v-pills-messages" type="button" role="tab" aria-controls="v-pills-messages" aria-selected="false">Tables</button>
                    </div>
                    <div className="tab-content" id="v-pills-tabContent">
                            <div className="tab-pane fade show active" id="v-pills-home" role="tabpanel" aria-labelledby="v-pills-home-tab">
                                <h4>Choisissez une langue  </h4>

                                <div class="mb-3">
                                    <select class="form-select form-select-sm" name="" id="">
                                        <option selected>Français</option>
                                        <option value="">Anglais</option>
                                    </select>
                                </div>
                            </div>
                        <div className="tab-pane fade" id="v-pills-profile" role="tabpanel" aria-labelledby="v-pills-profile-tab">
                            <h4>Choisissez un thème  </h4>

                                <div class="mb-3">
                                    <select class="form-select form-select-sm" name="" id="">
                                        <option selected>Thème clair</option>
                                        <option value="">Thème foncé</option>
                                    </select>
                                </div>
                        </div>
                        <div className="tab-pane fade" id="v-pills-messages" role="tabpanel" aria-labelledby="v-pills-messages-tab">
                            <h4>Paramètres des tables  </h4>

                                <div class="mb-3">
                                    <select class="form-select form-select-sm" name="" id="">
                                        <option selected>Thème clair</option>
                                        <option value="">Thème foncé</option>
                                    </select>
                                </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default Settings;
