import React, { useState, useEffect } from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import { useDropzone } from 'react-dropzone';
import Swal from 'sweetalert2';

import Navbar from '../layout/Navbar';
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
        <img key={file.name}
          src={file.preview}
          // Revoke data uri after image is loaded
          style={img}
          onLoad={() => { URL.revokeObjectURL(file.preview) }}
        />
  ));


  useEffect(() => {
    // Make sure to revoke the data uris to avoid memory leaks, will run on unmount
    return () => files.forEach(file => URL.revokeObjectURL(file.preview));
  }, []);

  return (
      <section className="container">
        { files.length == 0 &&
            <div {...getRootProps({className: 'dropzone'})}>
                <input {...getInputProps()} />
                Ajouter une photo
            </div>
          }
          {
              files.length > 0 &&
              <>
              <aside style={thumbsContainer} className="justify-content-center">
                      {thumbs}

                  <button type="button" onClick={() => setFiles([])} className="btn btn-link text-danger"><i className="fas fa-times fa-lg"></i></button>
                  </aside>
              </>

          }
    </section>
  );
}

function AddContact() {
    const navigate = useNavigate();


    useEffect(() => {
        contacts.Nom = "";
        contacts.Prenoms = "";
        contacts.Phone = "";
        contacts.Email = "";
    }, []);



    const handleSubmit =  async(e) => {

        e.preventDefault();
        formData.append("nom", contacts.Nom);
        formData.append("prenoms", contacts.Prenoms);
        formData.append("email", contacts.Email);
        formData.append("phone", contacts.Phone);


         try {
             const response = await axios.post(`http://localhost:8000/contact`,
                formData,
                 {
                    headers: {
                    'Content-Type': 'multipart/form-data'
                     },
                     timeout: 1000
                 }
            ).then(function (response) {
                if (response.status == 200 || response.status == 201) {


                   localStorage.setItem("contact_add", "ok");

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
                    <a className="breadcrumb-item" href="#"><i className="fas fa-home"></i> Accueil</a>
                    <span className="breadcrumb-item active" aria-current="page">Ajouter un contact</span>
                </nav>
            </div>

            <div className="container">
                <h1>Ajouter un contact</h1>
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

                            <Form
                                formData={contacts}
                                readOnly={false}
                                showColonAfterLabel={true}
                                showValidationSummary={true}
                                validationGroup="customerData"
                            >
                                <GroupItem caption="Formulaire de contact">
                                    <SimpleItem dataField="Nom" editorType="dxTextBox">
                                        <Label text="Nom" />
                                        <RequiredRule message="Le champ nom est requis" />
                                        <AsyncRule
                                        message="Le nom n'est pas valide"
                                        validationCallback={asyncValidation} />
                                    </SimpleItem>

                                    <SimpleItem dataField="Prenoms" editorType="dxTextBox">
                                        <Label text="Prénoms" />
                                        <RequiredRule message="Le champ prénoms est requis" />
                                        <AsyncRule
                                        message="Les prénoms de sont pas valides"
                                        validationCallback={asyncValidation} />
                                    </SimpleItem>


                                    <SimpleItem dataField="Phone" editorType="dxTextBox">
                                        <Label text="Téléphone" />
                                        <RequiredRule message="Le champ téléphone est requis" />
                                        <AsyncRule
                                        message="Le champ téléphone est requis"
                                        validationCallback={asyncValidation} />
                                    </SimpleItem>

                                    <SimpleItem dataField="Email" editorType="dxTextBox">
                                        <RequiredRule message="le champ email est requis" />
                                        <EmailRule message="L'email est invalid" />
                                        <AsyncRule
                                        message="Le champ email est requis"
                                        validationCallback={asyncValidation} />
                                    </SimpleItem>
                                </GroupItem>

                                 <ButtonItem cssClass="submitButton" horizontalAlignment="left"
                                buttonOptions={buttonOptions}
                                />
                            </Form>
                         </div>

                    </div>
                </form>

            </div>

        </div>
    );
}



export default AddContact;
