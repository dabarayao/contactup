import React, {Component} from 'react';
import ReactDOM from 'react-dom';
import 'bootstrap/dist/css/bootstrap.css';

import DataGrid, {
  Column, SearchPanel,
} from 'devextreme-react/data-grid';
import SelectBox from 'devextreme-react/select-box';
import CheckBox from 'devextreme-react/check-box';

import service from './data.js';

const saleAmountEditorOptions = { format: 'currency', showClearButton: true };



class Main extends Component {
  constructor(props) {
      super(props);
    this.orders = service.getOrders();
    this.dataGrid = null;
    this.state = {
      context: props.context
    };
  }

  render() {
    return (
      <div className="contactUp">

            <nav className="navbar navbar-expand-sm navbar-light bg-light">
                  <div className="container">
                    <a className="navbar-brand" href="#"><img src="assets\images\contact_up.png" className="img-fluid rounded-top" width="60" height="60" alt="" /></a>
                    <button className="navbar-toggler d-lg-none" type="button" data-bs-toggle="collapse" data-bs-target="#collapsibleNavId" aria-controls="collapsibleNavId"
                        aria-expanded="false" aria-label="Toggle navigation">
                        <span className="navbar-toggler-icon"></span>
                    </button>
                    <div className="collapse navbar-collapse" id="collapsibleNavId">
                        <ul className="navbar-nav me-auto mt-2 mt-lg-0">
                            <li className="nav-item">
                                <a className="nav-link active" href="#" aria-current="page"><i className="fad fa-home"></i> Accueil <span className="visually-hidden">(current)</span></a>
                            </li>
                            <li className="nav-item">
                                <a className="nav-link" href="#"><i className="fad fa-stars"></i> Mes favoris</a>
                            </li>
                            <li className="nav-item">
                                <a className="nav-link" href="#"><i className="fad fa-archive"></i> Archive</a>
                            </li>
                            <li className="nav-item">
                                <a className="nav-link" href="#"><i className="fad fa-info-circle"></i> A propos</a>
                            </li>
                            <li className="nav-item">
                                <a className="nav-link" href="#"><i className="fad fa-cog"></i> Paramètres</a>
                            </li>
                        </ul>
                        <form className="d-flex my-2 my-lg-0">
                            <input className="form-control me-sm-2" type="text" placeholder="Search" />
                            <button className="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
                        </form>
                    </div>
              </div>
            </nav>

            <div className="container">
                <DataGrid id="gridContainer"
                ref={(ref) => { this.dataGrid = ref; }}
                dataSource={this.orders}
                keyExpr="ID"
                showBorders={true}>
                <SearchPanel visible={true}
                    width={240}
                    placeholder="Recherche..." />
                <Column dataField="OrderNumber"
                    caption="Invoice Number">
                </Column>
                <Column dataField="OrderDate"
                    alignment="right"
                    dataType="date">
                </Column>
                <Column dataField="DeliveryDate"
                    alignment="right"
                    dataType="datetime"
                    format="M/d/yyyy, HH:mm"/>
                <Column dataField="SaleAmount"
                    alignment="right"
                    dataType="number"
                    format="currency"
                    editorOptions={saleAmountEditorOptions}>
                </Column>
                <Column dataField="Employee" />
                <Column dataField="CustomerStoreCity"
                    caption="City">
                </Column>
                </DataGrid>
            </div>
      </div>
    );
  }
}

export default Main;

if (document.getElementById('main')) {
    ReactDOM.render(<Main />, document.getElementById('main'));
}
