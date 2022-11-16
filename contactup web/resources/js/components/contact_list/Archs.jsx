// This is the page of the archived contact

import React, { Component } from 'react';

import 'bootstrap/dist/css/bootstrap.css';


import DataGrid, {
  Column, SearchPanel,
    Scrolling, Pager, Paging, Selection
} from 'devextreme-react/data-grid';


import axios from 'axios';

import service from '../data.js';

import Navbar from '../layout/Navbar';




class Archs extends Component {
  constructor(props) {
      super(props);
    this.orders = service.getOrders();
    this.dataGrid = null;
    this.state = {
        contacts: "",
        showContactInfo: false,
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
  }


    fetchData = async () => {
    const response = await axios.get("http://localhost:8000/contact/list/archs")

         this.setState({ contacts: response.data})
    }

    renderGridCell(cellData) {
        return (<div><img className="thumbnail" width={80} src={cellData.value}></img></div>);
    }

    onSelectionChanged({ selectedRowsData }) {
    const data = selectedRowsData[0];

    this.setState({
      showContactInfo: !!data,
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
   }


  render() {
      return (
      <div className="contactUp">
            <Navbar />

            <div className="container">
                <br />
                <nav className="breadcrumb">
                    <a className="breadcrumb-item" href="#"><i className="fas fa-home"></i>Archive</a>
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

                        <div class="d-flex">
                            <div class="flex-shrink-0">
                                <img src={this.state.detailImage} alt="" width="200" />
                            </div>
                            <div class="flex-grow-1 ms-3">
                                <h5 class="mt-0">{this.state.detailNom} {this.state.detailPrenoms}</h5>
                                <p>Email: {this.state.detailEmail}</p>
                                <p>Téléphone: {this.state.detailPhone}</p>
                                <p>
                                    <button type="button" class="btn btn-light" data-bs-toggle="tooltip" title="Restaurer"><i class="fal fa-box-open fa-2x"></i></button>

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

export default Archs;
