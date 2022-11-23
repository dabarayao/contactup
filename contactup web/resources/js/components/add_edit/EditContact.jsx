
import React, { useState, useEffect } from 'react';
import { NavLink, useNavigate, useParams } from 'react-router-dom';
import { useDropzone } from 'react-dropzone';
import Swal from 'sweetalert2';


import Navbar from '../layout/Navbar';
import Footer from '../layout/Footer';
import Form, {
  ButtonItem,
  GroupItem,
  SimpleItem,
  Label,
  CompareRule,
  EmailRule,
  PatternRule,
  RangeRule,
  RequiredRule,
  StringLengthRule,
  AsyncRule,
} from 'devextreme-react/form';


import axios from 'axios';

import "./AddContact.css";

var langui = localStorage.getItem("language");
var formData = new FormData();

const contacts = {
  Nom: '',
  Prenoms: '',
  Phone: '',
    Email: '',
  Photo: null,
  Accepted: false,
};

 var  buttonOptions = {
     text: 'Enregistrer',
     useSubmitBehavior: true,
    };


function sendRequest(value) {
  return new Promise((resolve) => {
      resolve(value != "");
  });
}

function asyncValidation(params) {
  return sendRequest(params.value);
}

const thumbsContainer = {
  display: 'flex',
  flexDirection: 'row',
  flexWrap: 'wrap',
  marginTop: 16
};

const img = {
  display: 'block',
  verticalAlign: 'middle',
  width: '120px',
  height: '120px',
  borderRadius: '50%'
};





function EditContact() {
    const [contactList, setContactList] = useState(null);


    const navigate = useNavigate();
    var { conId } = useParams();


    function Previews(props) {
        const [files, setFiles] = useState([]);
        const {getRootProps, getInputProps} = useDropzone({
            accept: {
            'image/*': []
            },
            multiple: false,
            onDrop: acceptedFiles => {


            formData.append("image", acceptedFiles[0]);
            setFiles(acceptedFiles.map(file => Object.assign(file, {
                preview: URL.createObjectURL(file)
            })));

            }
        });

        const thumbs = files.map(file => (
           contactList.Photo == null ?
            <img key={file.name}
            src={file.preview}
            // Revoke data uri after image is loaded
            style={img}
            onLoad={() => { URL.revokeObjectURL(file.preview) }}
                /> :
            <img key={file.name}
            src={contactList.Photo}
            // Revoke data uri after image is loaded
            style={img}
            onLoad={() => { URL.revokeObjectURL(file.preview) }}
            />
        ));





    useEffect(() => {
        // Make sure to revoke the data uris to avoid memory leaks, will run on unmount
        return () => files.forEach(file => URL.revokeObjectURL(file.preview));
    }, []);

    const fetchData = async () => {
        const response = await axios.get(`http://localhost:8000/contact/show/${conId}`);

                if (response.data.id == null) {
                   navigate('/');
        }


        contacts.Nom = response.data.nom;
        contacts.Prenoms= response.data.prenoms;
        contacts.Phone = response.data.phone;
        contacts.Email = response.data.email;
        contacts.Photo = response.data.photo;

        if (contacts.Photo != null) {
            setFiles([response.data.photo]);
        }


        setContactList(contacts);


    }

    useEffect(function () {
        fetchData();
    }, []);

    return (
        <section className="container">
            { files.length == 0 &&
                <div {...getRootProps({className: 'dropzone'})}>
                    <input {...getInputProps()} />
                    { langui == 1 ? "Add a photo" :  "Ajouter une photo"}
                </div>
            }
            {
                files.length > 0  &&
                <>
                <aside style={thumbsContainer} className="justify-content-center">
                        {thumbs}

                        <button type="button" onClick={() => {
                            setFiles([]);
                            formData.append('delImage', 1);
                        }} className="btn btn-link text-danger"><i className="fas fa-times fa-lg"></i></button>
                    </aside>
                </>

            }
        </section>
    );


    }





    const handleSubmit =  async(e) => {

        e.preventDefault();

        formData.append("nom", contacts.Nom);
        formData.append("prenoms", contacts.Prenoms);
        formData.append("email", contacts.Email);
        formData.append("phone", contacts.Phone);



         try {
            const response = await axios.post(`http://localhost:8000/contact/edit/${conId}`,
                formData,
                {
                    headers: {
                    'Content-Type': 'multipart/form-data'
                     },
                     timeout: 1000
                 }
            ).then(function (response) {
                if (response.status == 200 || response.status == 201) {


                   localStorage.setItem("contact_edit", "ok");

                   navigate('/');
                }
            });

        } catch  {
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
                    <a className="breadcrumb-item" style={{textDecoration: "none"}} href="#"><i className="fas fa-home"></i> { langui == 1 ? " Home" :  " Accueil"}</a>
                    <span className="breadcrumb-item active" aria-current="page">Modifier</span>
                </nav>
            </div>

            <div className="container">
                <h1>{ langui == 1 ? "Edit a contact" :  "Modifier un contact"}</h1>
            </div>

            <div className="container">

                <form onSubmit={handleSubmit}>
                    <div className="row justify-content-center">
                        {/* <div className="col-6">
                            <div className="mb-3">
                                <label htmlFor="exampleInputEmail1" className="form-label">Nom *</label>
                                <input type="text" className="form-control" id="nomField" onInput={(e) => setNomField(e.target.value)} placeholder="Entrez votre nom" />

                            </div>

                            <div className="mb-3">
                                <label htmlFor="exampleInputPassword1" className="form-label">Prénoms *</label>
                                <input type="text" className="form-control" id="prenomField" onInput={(e) => setPrenomField(e.target.value)}  placeholder="Entrez votre prénoms" />
                            </div>

                            <div className="mb-3">
                                <label htmlFor="exampleInputPassword1" className="form-label">Téléphone *</label>
                                <input type="tel" className="form-control" id="phoneField" onInput={(e) => setPhoneField(e.target.value)} placeholder="Numéro de téléphone" />
                            </div>

                            <div className="mb-3">
                                <label htmlFor="exampleInputPassword1" className="form-label">Email *</label>
                                <input type="email" className="form-control" id="emailField" onInput={(e) => setEmailField(e.target.value)} placeholder="Entrez votre email" />
                            </div>
                            <button type="submit" className="btn text-dark" style={{ background: "#f2b538" }}><i className="fas fa-plus"></i> Enregistrer</button>
                        </div> */}

                        <div className="col-6">

                            <Previews />
                            <br />

                            {contactList != null ?

                                <Form
                                    formData={contacts}
                                    readOnly={false}
                                    showColonAfterLabel={true}
                                    showValidationSummary={true}
                                    validationGroup="customerData"
                                >

                                       <SimpleItem dataField="Nom" editorType="dxTextBox">
                                        <Label text={ langui == 1 ? "Last name" :  "Nom"} />
                                        <RequiredRule message={ langui == 1 ? "Field is required" :  "Le champ nom est requis"}  />
                                        <AsyncRule
                                        message={langui == 1 ? "Last name isn't valid" : "Le nom n'est pas valide"}
                                        validationCallback={asyncValidation} />
                                    </SimpleItem>

                                    <SimpleItem dataField="Prenoms" editorType="dxTextBox">
                                        <Label text={ langui == 1 ? "First name" :  "Prénoms"} />
                                        <RequiredRule message={ langui == 1 ? "Field is required" :  "Le champ prénoms est requis"}  />
                                        <AsyncRule
                                        message={langui == 1 ? "First name isn't valid" : "Le prénoms n'est pas valide"}
                                        validationCallback={asyncValidation} />
                                    </SimpleItem>


                                    <SimpleItem dataField="Phone" editorType="dxTextBox">
                                        <Label text={ langui == 1 ? "Phone" :  "Téléphone"} />
                                        <RequiredRule message={ langui == 1 ? "Phone is required" :  "Le champ téléphone est requis"}  />
                                        <AsyncRule
                                        message={langui == 1 ? "Phone isn't valid" : "Le téléphone n'est pas valide"}
                                        validationCallback={asyncValidation} />
                                    </SimpleItem>

                                    <SimpleItem dataField="Email" editorType="dxTextBox">
                                        <RequiredRule message={ langui == 1 ? "Email field is required" :  "le champ email est requis"} />
                                    <EmailRule message={langui == 1 ? "Email is invalid" : "L'email est invalid"} />
                                        <AsyncRule
                                        message={langui == 1 ? "Email field is required" : "Le champ email est requis"}
                                        validationCallback={asyncValidation} />
                                    </SimpleItem>

                                    <ButtonItem cssClass="submitButton" horizontalAlignment="left"
                                        buttonOptions={buttonOptions}
                                    />
                                </Form>
                                : ""
                            }
                         </div>

                    </div>
                </form>

            </div>

            <Footer />
        </div>
    );
}



export default EditContact;