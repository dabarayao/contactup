// This is the main page

import React, { Component } from 'react';
import { Link } from "react-router-dom"; // importing the link package

import 'bootstrap/dist/css/bootstrap.css';
import noInt from '../../img/no_internet.png'; // importing nointernet vector

import DataGrid, {
  Column, SearchPanel,
    Scrolling, Pager, Paging, Selection
} from 'devextreme-react/data-grid'; // importing the devextreme data-grid elements
import Swal from 'sweetalert2';


import axios from 'axios'; // importing the axios API

/*
Link of the documentation for devextreme data-grid
https://js.devexpress.com/Demos/WidgetsGallery/Demo/DataGrid/Overview/React/Light/
*/

var langui = localStorage.getItem("language"); // get the language write on local file

class Home extends Component {
    constructor(props) {
        super(props);
        this.dataGrid = null;
        this.state = {
            contacts: "",
            isInternet: null, // state varriable to check if there's internet connection
            showContactInfo: false, // state varriable to check of the contact info which is displayed by clicking on a table row
            // state varriables for the display contact
            detailId: "",
            detailImage: "",
            detailNom: "",
            detailPrenoms: "",
            detailEmail: "",
            detailPhone: "",
            detailArch: false,
            detailFav: false,
            isLoadingText: "",
            isLoading: false,
        };

        this.fetchData = this.fetchData.bind(this); // function to fecth the contacts on the server
        this.onSelectionChanged = this.onSelectionChanged.bind(this); // function to chnage the displayed contact by clicking on another row
        this.renderGridCell = this.renderGridCell.bind(this);
        this.updateFav = this.updateFav.bind(this); // function to swith favorite's state of a contact
        this.updateArch = this.updateArch.bind(this); // function to swith Archive's state of a contact
    }


    fetchData = async () => {
        try {
            const response = await axios.get("/contact/list", {
                headers: {"Access-Control-Allow-Origin": "*"}
            });
            var resPattern = response.data;

            resPattern.forEach((items) => {
                if (items.photo == null) {
                    items.photo = "https://placehold.co/300x300/f2b538/000000.png?text=" + items.nom[0] + items.prenoms[0];
                }
            });

            this.setState({ contacts: response.data });
            this.setState({ isInternet: true });
        } catch {
            this.setState({ isInternet: false });
        }
    }

    updateFav = async (contactId, is_fav) => {
        this.setState({
            isLoadingText: langui == 1 ? "...Editing" :"...Modification en cours"
        });
        try {
            const favContact = await axios.get(`/contact/show/${contactId}`, {
                headers: {"Access-Control-Allow-Origin": "*"}
            });

            const response = await axios.post(`/contact/edit/fav/${contactId}`,
                {
                    isFav: is_fav
                },
                { timeout: 60000 }
            );

            this.setState({ detailFav: !is_fav });
            this.setState({
                isLoadingText: ""
            });
        } catch {
            this.setState({
                isLoadingText: ""
            });
            Swal.fire({
                title: 'Server error !',
                text: 'Vérifier votre connexion internet.',
                icon: 'error',
                confirmButtonText: 'Ok'
            });
        }


    }

    updateArch = async (contactId, is_arch) => {
        this.setState({
            isLoadingText: langui == 1 ? "...Archiving" : "...Archivage en cours"
        });
        try {
            const response = await axios.post(`/contact/edit/arch/${contactId}`,
                {
                    isArch: is_arch
                },
                { timeout: 15000 }
            ).then(function (response) {
                if (response.status == 200 || response.status == 201) {
                    Swal.fire({
                        title: '<span style="color: white; font-weight: bold;">Contact archivé avec succès</span>',
                        icon: "success",
                        iconColor: 'white',
                        toast: true,
                        timer: 4000,
                        position: 'bottom-right',
                        background: '#4BB543',
                        showConfirmButton: true,
                        confirmButtonText: '&times;'
                    });
                }
            });
            this.setState({
                isLoadingText: ""
            });

            this.fetchData();
        } catch {
            this.setState({
                isLoadingText: ""
            });
            Swal.fire({
                title: 'Server error !',
                text: 'Vérifier votre connexion internet.',
                icon: 'error',
                confirmButtonText: 'Ok'
            });
        }


    }

    deleteContact = async (contactId) => {
        this.setState({
            isLoadingText: langui == 1 ? "...Deleting" : "...Suppression en cours"
        });

        try {
            const response = await axios.get(`/delcontact/${contactId}`,
                {
                    timeout: 15000,
                    headers: { "Access-Control-Allow-Origin": "*" }
                }
            ).then(function (response) {
                if (response.status == 200 || response.status == 201) {
                    Swal.fire({
                        title: '<span style="color: white; font-weight: bold;">Contact supprimé avec succès</span>',
                        icon: "success",
                        iconColor: 'white',
                        toast: true,
                        timer: 4000,
                        position: 'bottom-right',
                        background: '#4BB543',
                        showConfirmButton: false
                    });
                }
            });
            this.setState({
                isLoadingText: ""
            });
            this.fetchData();
        } catch {
            this.setState({
                isLoadingText: ""
            });
            Swal.fire({
                title: 'Server error !',
                text: 'Vérifier votre connexion internet.',
                icon: 'error',
                confirmButtonText: 'Ok'
            });
        }


    }


    renderGridCell(cellData) {
        return (<div><img className="thumbnail" width={80} src={cellData.value}></img></div>);
    }

    onSelectionChanged({ selectedRowsData }) {
    const data = selectedRowsData[0];

    this.setState({
        showContactInfo: !!data,
        detailId: data && data.id,
        detailImage: data && data.photo,
        detailNom: data && data.nom,
        detailPrenoms: data && data.prenoms,
        detailEmail: data && data.email,
        detailPhone: data && data.phone,
        detailArch: data && data.is_arch,
        detailFav: data && data.is_fav,
    });
  }


    componentDidMount() {

        document.title = langui == 1 ? "Contact up - Home" : "Contact up - Accueil"; // editing the title of page

        this.fetchData();

        if (localStorage.getItem("contact_add") == "ok") {

            Swal.fire({
                title: '<span style="color: white; font-weight: bold;">Contact ajouté avec succès</span>',
                icon: "success",
                iconColor: 'white',
                toast: true,
                timer: 4000,
                position: 'bottom-right',
                background: '#4BB543',
                showConfirmButton: false
            });

           localStorage.removeItem("contact_add");
        }

        if (localStorage.getItem("contact_edit") == "ok") {

            Swal.fire({
                title: '<span style="color: white; font-weight: bold;">Contact modifié avec succès</span>',
                icon: "success",
                iconColor: 'white',
                toast: true,
                timer: 4000,
                position: 'bottom-right',
                background: '#4BB543',
                showConfirmButton: false
            });

           localStorage.removeItem("contact_edit");
        }
    }



    render() {


      return (
      <div className="contactUp">
            <div className="container">
                <br />
                <nav className="breadcrumb">
                    <a className="breadcrumb-item" style={{textDecoration: "none"}} href="#"><i className="fas fa-home"></i>{ langui == 1 ? " Home" :  " Accueil"}</a>
                    <span className="breadcrumb-item active" aria-current="page">{ langui == 1 ? "List of contacts" :  "List des contacts"} </span>
                </nav>
            </div>

            <div className="container">
                <h1>{ langui == 1 ? "List of contacts" :  "List des contacts"}</h1>
            </div>

            <br />

            {
                this.state.showContactInfo
                && <div className="container">

                        <div className="d-flex">
                            <div className="flex-shrink-0">
                                <img src={this.state.detailImage} alt="" width="200" />
                            </div>
                            <div className="flex-grow-1 ms-3">
                                <h5 className="mt-0">{this.state.detailNom} {this.state.detailPrenoms}</h5>
                                  <p>Email: {this.state.detailEmail}</p>
                                <p>Téléphone: {this.state.detailPhone}</p>
                                    <p>
                                      {this.state.detailFav == true ? <button type="button" className="btn btn-link" onClick={() => this.updateFav(this.state.detailId, true)} data-bs-toggle="tooltip" title="Retirer des favoris"><i className="fas fa-star fa-lg" style={{ color: "#f2b538", }}></i></button> : <button type="button" className="btn btn-link" style={{color: "#337ab7"}} onClick={() => this.updateFav(this.state.detailId, false)}  data-bs-toggle="tooltip" title="Ajouter au favoris"><i className="fal fa-star fa-lg"></i></button>}
                                        <Link to={"/edit/" + this.state.detailId} >
                                            <button role="button" className="btn btn-link" style={{color: "#337ab7"}} data-bs-toggle="tooltip" title="Modifier le contact"><i className="fal fa-pen fa-lg"></i></button>
                                        </Link>
                                     </p>
                                <p>
                                    <button type="button" className="btn btn-link" style={{color: "#337ab7"}} onClick={() => this.updateArch(this.state.detailId, false)} data-bs-toggle="tooltip" title="Archiver"><i className="fal fa-archive fa-lg"></i></button>
                                      <button type="button" className="btn btn-link text-danger" onClick={() => this.deleteContact(this.state.detailId)} data-bs-toggle="tooltip" title="Supprimer"><i className="fas fa-trash-alt fa-lg"></i></button>
                                </p>
                                {`${this.state.isLoadingText}`}
                          </div>
                        </div>
                    </div>



              }

              {
                  this.state.isInternet == true &&
                  <div className="container">
                      <DataGrid id="gridContainer"
                          ref={(ref) => { this.dataGrid = ref; }}
                          dataSource={this.state.contacts}
                          keyExpr="id"
                          showBorders={true}
                          showColumnLines={true}
                          showRowLines={true}
                          rowAlternationEnabled={false}
                          hoverStateEnabled={true}
                          onSelectionChanged={this.onSelectionChanged}
                      >
                          <SearchPanel visible={true}
                              width={240}
                              placeholder={langui == 1 ? "Search..." : "Recherche..."} />
                          <Selection mode="single" />
                          <Scrolling rowRenderingMode='virtual'></Scrolling>
                          <Paging defaultPageSize={5} />
                          <Pager
                              visible={true}
                              allowedPageSizes={this.state.contacts.length >= 10 ? [5, 'all'] : ""}
                              displayMode="full"
                              showPageSizeSelector={true}
                              showNavigationButtons={true} />
                          <Column
                              dataField="photo"
                              cellRender={this.renderGridCell}
                              caption="Photo">
                          </Column>
                          <Column dataField="nom"
                              caption={langui == 1 ? "Last name" : "Nom"}>
                          </Column>
                          <Column dataField="prenoms"
                              alignment="right"
                              caption={langui == 1 ? "First name" : "Prénoms"}>
                          </Column>
                          <Column dataField="email"
                              alignment="right"
                              dataType="email"
                          />
                          <Column dataField="phone"
                              alignment="right"
                              caption={langui == 1 ? "Phone" : "Téléphone"}>
                          </Column>
                          <Column dataField="is_fav"
                              visible={false}
                              alignment="right">
                          </Column>
                          <Column dataField="is_arch"
                              visible={false}
                              alignment="right">
                          </Column>
                      </DataGrid>
                  </div>
              }

              {
                  this.state.isInternet == null &&
                  <div className="container d-flex justify-content-center ">
                        <div className="row">
              <div class="loadingio-spinner-ripple-6is1l54oda9"><div class="ldio-4ojwp7ajcv7">
               <div></div><div></div>
                              </div></div>
                          </div>
                          </div>

              }

              {     this.state.isInternet == false &&

                    <div className="container d-flex justify-content-center ">
                        <div className="row">
                            <div className="col-12 text-center">
                                        <img src={noInt} width="350" className="img-fluid rounded-top" alt="" />
                            </div><br />
                            <div className="col-12 text-center mt-2">
                                        <button type="button" className="btn" onClick={this.fetchData} style={{ background: "#F3C061" }}>Actualiser</button>
                            </div>
                        </div>

                    </div>
              }


      </div>
    );
  }
}

export default Home;
