import React from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";

import "antd/dist/antd.min.css";
import "./App.css";

import Admin from "./pages/admin";

const AppRouter = () => (
  <Router>
    <div>
      <Route path="/" exact component={Admin} />
      <Route path="/admin" exact component={Admin} />
    </div>
  </Router>
);

export default AppRouter;
