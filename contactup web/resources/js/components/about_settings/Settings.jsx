// This is the about page to explain the app and his developer

import React from 'react';

import 'bootstrap/dist/css/bootstrap.css';
import Navbar from '../layout/Navbar';
import axios from 'axios';
import Swal from 'sweetalert2';

import './settings.css';



function Settings() {

    const chTheme =  async(e) => {

        var formData = new FormData();
        formData.append("appTheme", e.target.value);

            try {
                const response = await axios.post("/contact/theme",
                    formData,
                    {
                        headers: {
                        'Content-Type': 'multipart/form-data'
                        },
                        timeout: 1000
                    }
                );
            } catch (error) {
                Swal.fire({
                    title: 'Server error !',
                    text: 'Vérifier votre connexion internet.',
                    icon: 'error',
                    confirmButtonText: 'Ok'
                });
            }
    }

    return (
        <div className="contactUp">

            <Navbar />

            <div className="container">
                <br />
                    <nav className="breadcrumb">
                        <a className="breadcrumb-item" href="#"><i className="fas fa-home"></i>Accueil</a>
                        <span className="breadcrumb-item active" aria-current="page">Paramètres</span>
                    </nav>

                    <h1>Paramètres</h1>

                    {/* <img src="assets/images/contact_up.png" width="200" /> */}
                <br />

                <div className="d-flex align-items-start justify-content-center">
                    <div className="nav flex-column nav-pills me-3" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                        <button className="nav-link active" id="v-pills-home-tab" data-bs-toggle="pill" data-bs-target="#v-pills-home" type="button" role="tab" aria-controls="v-pills-home" aria-selected="true">Langue</button>
                        <button className="nav-link" id="v-pills-profile-tab" data-bs-toggle="pill" data-bs-target="#v-pills-profile" type="button" role="tab" aria-controls="v-pills-profile" aria-selected="false">Thème</button>
                    </div>
                    <div className="tab-content" id="v-pills-tabContent">
                            <div className="tab-pane fade show active" id="v-pills-home" role="tabpanel" aria-labelledby="v-pills-home-tab">
                                <h4>Choisissez une langue  </h4>

                                <div className="mb-3">
                                    <select className="form-select form-select-sm" name="" id="">
                                        <option defaultValue>Français</option>
                                        <option value="">Anglais</option>
                                    </select>
                                </div>
                            </div>
                        <div className="tab-pane fade" id="v-pills-profile" role="tabpanel" aria-labelledby="v-pills-profile-tab">
                            <h4>Choisissez un thème  </h4>

                                <div className="mb-3">
                                    <select onChange={(e) => chTheme(e)} className="form-select form-select-sm" name="ad">
                                        <option defaultValue value="0">Thème clair</option>
                                        <option value="1">Thème foncé</option>
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
