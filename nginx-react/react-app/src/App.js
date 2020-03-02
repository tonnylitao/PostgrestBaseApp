import React from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";

import "antd/dist/antd.min.css";
import "./App.css";

import Home from "./pages/home";

const AppRouter = () => (
  <Router>
    <div>
      <Route path="/" exact component={Home} />
      {/*
        <Route path="/me" component={Application} />
        <Route path="/user/:id" component={Vote} />
        <Route path="/group/:id" component={Vote} />
        <Route path="/store" component={Vote} />
        <Route path="/product/:id" component={Vote} />
        */}
    </div>
  </Router>
);

export default AppRouter;
