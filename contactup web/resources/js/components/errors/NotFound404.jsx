import React from 'react';
import { NavLink } from 'react-router-dom'; // importing the nav link package
import './notFound404.css';

var langui = localStorage.getItem("language"); // get the language write on local file

function NotFound() {
    return (
        <section className="page_404">
            <div className="container d-flex justify-content-center">
                <div className="row">
                    <div className="col-sm-12 ">
                        <div className="col-sm-10 col-sm-offset-1  text-center">
                            <div className="four_zero_four_bg">
                                <h1 className="text-center ">404</h1>


                                        </div>
                                        <br />

                            <div className="contant_box_404">
                                <NavLink to="/" className="link_404">{ langui == 1 ? "Go to Home" : "Retouner à l'accueil"}</NavLink>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
      );
}

export default NotFound;
