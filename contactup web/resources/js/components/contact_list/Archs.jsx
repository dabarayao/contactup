// This is the page of the archived contact

import React, { Component } from 'react';

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


var langui = localStorage.getItem("language");

class Archs extends Component {
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
        isLoading: ""
    };

    this.fetchArchData = this.fetchArchData.bind(this); // function to fecth the Archives' contacts on the server
    this.onSelectionChanged = this.onSelectionChanged.bind(this); // function to chnage the displayed contact by clicking on another row
    this.renderGridCell = this.renderGridCell.bind(this);
  }


    fetchArchData = async () => {
        try {
            const response = await axios.get("/contact/list/archs", {
                headers: {"Access-Control-Allow-Origin": "*"}
            })
            var resPattern = response.data;

            resPattern.forEach((items) => {
                if (items.photo == null) {
                    items.photo = "https://placehold.co/300x300/f2b538/000000.png?text=" + items.nom[0] + items.prenoms[0];
                }
            });

            this.setState({ contacts: resPattern })
            this.setState({ isInternet: true });
        } catch {
            this.setState({ isInternet: false });
        }
    }

    updateArch = async (contactId, is_arch) => {
        this.setState({
            isLoading: langui == 1 ? "...Unarchiving" : "...Désarchivage en cours"
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
                        title: '<span style="color: white; font-weight: bold;">Contact restauré avec succès</span>',
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
                isLoading: ""
            });
            this.setState({ detailArch: !is_arch });
            this.fetchArchData();
        } catch {
            this.setState({
                isLoading: ""
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
            isLoading: langui == 1 ? "...Deleting" : "...Suppresion en cours"
        });
        try {
            const response = await axios.get(`/delcontact/${contactId}`, {
                headers: {"Access-Control-Allow-Origin": "*"}
            },
                { timeout: 15000 }
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
                    return true;
                }
            });
            this.setState({
                isLoading: ""
            });
            this.fetchArchData();
        } catch {
            this.setState({
                isLoading: ""
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
        document.title = "Contact up - Archive"; // editing the title of page
        this.fetchArchData();
   }


  render() {
      return (
      <div className="contactUp">

            <div className="container">
                <br />
                <nav className="breadcrumb">
                    <a className="breadcrumb-item" style={{textDecoration: "none"}} href="#"><i className="fas fa-home"></i>{ langui == 1 ? " Home" :  " Accueil"}</a>
                    <span className="breadcrumb-item active" aria-current="page">Liste des archives</span>
                </nav>
            </div>

            <div className="container">
                <h1>Liste des archives</h1>
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
                                    <button type="button" className="btn btn-link" style={{color: "#337ab7"}} onClick={() => this.updateArch(this.state.detailId, true)} data-bs-toggle="tooltip" title="Restaurer"><i className="fal fa-box-open fa-2x"></i></button>
                                    <button type="button" className="btn btn-link text-danger" onClick={() => this.deleteContact(this.state.detailId)}  data-bs-toggle="tooltip" title="Supprimer"><i className="fas fa-trash-alt fa-lg"></i></button>

                                </p>
                                {`${this.state.isLoading}`}
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
                            placeholder={ langui == 1 ? "Search..." :  "Recherche..."} />
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
                        caption={ langui == 1 ? "Last name" :  "Nom"}>
                        </Column>
                        <Column dataField="prenoms"
                            alignment="right"
                            caption={ langui == 1 ? "First name" :  "Prénoms"}>
                        </Column>
                        <Column dataField="email"
                            alignment="right"
                            dataType="email"
                            />
                        <Column dataField="phone"
                            alignment="right"
                            caption={ langui == 1 ? "Phone" :  "Téléphone"}>
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

              {
                  this.state.isInternet == false &&
                    <div className="container d-flex justify-content-center ">
                        <div className="row">
                            <div className="col-12 text-center">
                                        <img src={noInt} width="350" className="img-fluid rounded-top" alt="" />
                            </div><br />
                            <div className="col-12 text-center mt-2">
                                        <button type="button" className="btn" onClick={this.fetchArchData} style={{ background: "#F3C061" }}>Actualiser</button>
                            </div>
                        </div>

                    </div>
              }

      </div>
    );
  }
}

export default Archs;
