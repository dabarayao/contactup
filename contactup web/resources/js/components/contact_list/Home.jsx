// This is the main page

import React, { Component } from 'react';
import { Link } from "react-router-dom";

import 'bootstrap/dist/css/bootstrap.css';


import DataGrid, {
  Column, SearchPanel,
    Scrolling, Pager, Paging, Selection
} from 'devextreme-react/data-grid';
import Swal from 'sweetalert2';


import service from '../data.js';

import Navbar from '../layout/Navbar';



class Home extends Component {
    constructor(props) {
        super(props);
        this.orders = service.getOrders();
        this.dataGrid = null;
        this.state = {
            contacts: "",
            showContactInfo: false,
            detailId: "",
            detailImage: "",
            detailNom: "",
            detailPrenoms: "",
            detailEmail: "",
            detailPhone: "",
            detailArch: false,
            detailFav: false
        };

        this.fetchData = this.fetchData.bind(this);
        this.onSelectionChanged = this.onSelectionChanged.bind(this);
        this.renderGridCell = this.renderGridCell.bind(this);
        this.updateFav = this.updateFav.bind(this);
        this.updateArch = this.updateArch.bind(this);
    }


    fetchData = async () => {
        const response = await axios.get("http://localhost:8000/contact/list");
        var resPattern = response.data;

        resPattern.forEach((items) => {
            if (items.photo == null) {
                items.photo = "https://placehold.co/300x300/f2b538/000000.png?text=" + items.nom[0] + items.prenoms[0];
            }
        });

        this.setState({ contacts: resPattern});
    }

    updateFav = async (contactId, is_fav) => {

        try {
            const favContact = await axios.get(`http://localhost:8000/contact/show/${contactId}`);

            const response = await axios.post(`http://localhost:8000/contact/edit/fav/${contactId}`,
                {
                    isFav: is_fav
                },
                { timeout: 1000 }
            );

            this.setState({ detailFav: !is_fav});
        } catch  {
            Swal.fire({
                title: 'Server error !',
                text: 'Vérifier votre connexion internet.',
                icon: 'error',
                confirmButtonText: 'Ok'
            });
        }


    }

    updateArch = async (contactId, is_arch) => {

        try {
            const response = await axios.post(`http://localhost:8000/contact/edit/arch/${contactId}`,
                {
                    isArch: is_arch
                },
                { timeout: 1000 }
            ).then(function (response) {
                if (response.status == 200 || response.status == 201) {
                    Swal.fire({
                        title: '<span style="color: white; font-weight: bold;">Contact archivé avec succès</span>',
                        icon: "success",
                        iconColor: 'white',
                        toast: true,
                        timer: 4000,
                        position: 'top-right',
                        background: '#4BB543',
                       showConfirmButton: false
                    });
                }
            });

            this.fetchData();
        } catch  {
            Swal.fire({
                title: 'Server error !',
                text: 'Vérifier votre connexion internet.',
                icon: 'error',
                confirmButtonText: 'Ok'
            });
        }


    }

    deleteContact = async (contactId) => {

        try {
            const response = await axios.get(`http://localhost:8000/delcontact/${contactId}`,
                { timeout: 1000 }
            ).then(function (response) {
                if (response.status == 200 || response.status == 201) {
                    Swal.fire({
                        title: '<span style="color: white; font-weight: bold;">Contact supprimé avec succès</span>',
                        icon: "success",
                        iconColor: 'white',
                        toast: true,
                        timer: 4000,
                        position: 'top-right',
                        background: '#4BB543',
                       showConfirmButton: false
                    });
                }
            });

            this.fetchData();
        } catch  {
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
        this.fetchData();

        if (localStorage.getItem("contact_add") == "ok") {

            Swal.fire({
                title: '<span style="color: white; font-weight: bold;">Contact ajouté avec succès</span>',
                icon: "success",
                iconColor: 'white',
                toast: true,
                timer: 4000,
                position: 'top-right',
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
                position: 'top-right',
                background: '#4BB543',
                showConfirmButton: false
            });

           localStorage.removeItem("contact_edit");
        }
    }



  render() {
      return (
      <div className="contactUp">
            <Navbar />

            <div className="container">
                <br />
                <nav className="breadcrumb">
                    <a className="breadcrumb-item" href="#"><i className="fas fa-home"></i> Accueil</a>
                    <span className="breadcrumb-item active" aria-current="page">List des contacts</span>
                </nav>
            </div>

            <div className="container">
                <h1>Liste des contacts</h1>
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
                                      {this.state.detailFav == true ? <button type="button" className="btn btn-light" onClick={() => this.updateFav(this.state.detailId, true)} data-bs-toggle="tooltip" title="Retirer des favoris"><i className="fas fa-star fa-lg" style={{ color: "#f2b538", }}></i></button> : <button type="button" className="btn btn-light" onClick={() => this.updateFav(this.state.detailId, false)}  data-bs-toggle="tooltip" title="Ajouter au favoris"><i className="fal fa-star fa-lg"></i></button>}
                                        <Link to={"/edit/" + this.state.detailId} >
                                            <button role="button" className="btn btn-light" data-bs-toggle="tooltip" title="Modifier le contact"><i className="fal fa-pen fa-lg"></i></button>
                                        </Link>
                                     </p>
                                <p>
                                    <button type="button" className="btn btn-light" onClick={() => this.updateArch(this.state.detailId, false)} data-bs-toggle="tooltip" title="Archiver"><i className="fal fa-archive fa-lg"></i></button>
                                      <button type="button" className="btn btn-light text-danger" onClick={() => this.deleteContact(this.state.detailId)} data-bs-toggle="tooltip" title="Supprimer"><i className="fas fa-trash-alt fa-lg"></i></button>
                                </p>

                          </div>
                        </div>
                    </div>



            }

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
                        placeholder="Recherche..." />
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
                caption="Nom">
                </Column>
                <Column dataField="prenoms"
                    alignment="right">
                </Column>
                <Column dataField="email"
                    alignment="right"
                    dataType="email"/>
                <Column dataField="phone"
                    alignment="right">
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

      </div>
    );
  }
}

export default Home;
