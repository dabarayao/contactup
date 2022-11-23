// This is the about page to explain the app and his developer

import React, {useRef} from 'react';

import 'bootstrap/dist/css/bootstrap.css';
import Navbar from '../layout/Navbar';
import Footer from '../layout/Footer';
import axios from 'axios';
import Swal from 'sweetalert2';

import './settings.css';

var themeColor = "";
var selApp = ";"

var theme = localStorage.getItem("theme");
var langui = localStorage.getItem("language");

if (theme == 1) {
    themeColor = {
        color: "white"
    }
    selApp = {
        background: "#212529",
        color: "white"
    }
} else {
    themeColor = {
        color: "#333"
    }
    selApp = {
        background: "transparent",
        color: "#333"
    }
}

const chLang =  (e) => {
    localStorage.setItem("language", e.target.value);
    location.reload();
}

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
            ).then((res) => {
                if (res.status == 200 || res.status == 201) {
                    localStorage.setItem("theme", e.target.value);
                    location.reload();

                }
            });
        } catch (error) {
            Swal.fire({
                title: 'Server error !',
                text: 'Vérifier votre connexion internet.',
                icon: 'error',
                confirmButtonText: 'Ok'
            });
        }
}

function Settings() {

    return (
        <div className="contactUp">

            <Navbar />

            <div className="container">
                <br />
                    <nav className="breadcrumb">
                        <a className="breadcrumb-item" style={{textDecoration: "none"}} href="#"><i className="fas fa-home"></i>{ langui == 1 ? " Home" :  " Accueil"}</a>
                        <span className="breadcrumb-item active" aria-current="page">{ langui == 1 ? "Settings" :  "Paramètres"}</span>
                    </nav>

                    <h1>{ langui == 1 ? "Settings" :  "Paramètres"}</h1>

                    {/* <img src="assets/images/contact_up.png" width="200" /> */}
                <br />

                <div className="d-flex align-items-start justify-content-center">
                    <div className="nav flex-column nav-pills me-3 text-light" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                        <button className="nav-link active" id="v-pills-home-tab" style={themeColor}  data-bs-toggle="pill" data-bs-target="#v-pills-home" type="button" role="tab" aria-controls="v-pills-home" aria-selected="true">{ langui == 1 ? "Language" :  "Langue"}</button>
                        <button className="nav-link" id="v-pills-profile-tab" style={themeColor} data-bs-toggle="pill" data-bs-target="#v-pills-profile" type="button" role="tab" aria-controls="v-pills-profile" aria-selected="false">{ langui == 1 ? "Theme" :  "Thème"}</button>
                    </div>
                    <div className="tab-content" id="v-pills-tabContent">
                            <div className="tab-pane fade show active" id="v-pills-home" role="tabpanel" aria-labelledby="v-pills-home-tab">
                                <h4>{ langui == 1 ? "Choose a language" :  "Choisissez une langue"}</h4>

                                <div className="mb-3">
                                    <select defaultValue={langui == 1 ? 1 : 0} onChange={(e) => chLang(e)} className="form-select form-select-sm" style={selApp} name="" id="">
                                        <option value="0" defaultValue>{ langui == 1 ? "French" :  "Français"}</option>
                                        <option value="1">{ langui == 1 ? "English" :  "Anglais"}</option>
                                    </select>
                                </div>
                            </div>
                        <div className="tab-pane fade" id="v-pills-profile" role="tabpanel" aria-labelledby="v-pills-profile-tab">
                            <h4>Choisissez un thème  </h4>

                                <div className="mb-3">
                                    <select defaultValue={theme == 1 ? 1 : 0}  onChange={(e) => chTheme(e)} className="form-select form-select-sm" style={selApp} name="ad">

                                        <option  value="0">{ langui == 1 ? "Light theme" :  "Thème clair"}</option>
                                        <option value="1">{ langui == 1 ? "Dark theme" :  "Thème foncé"}</option>
                                    </select>
                                </div>
                        </div>
                    </div>
                </div>
            </div>

            <Footer />
        </div>
    );
}

export default Settings;
