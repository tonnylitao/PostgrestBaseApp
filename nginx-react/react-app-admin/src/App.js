import React from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";

import "antd/dist/antd.min.css";
import "./App.css";

import Home from "./pages/home";

const AppRouter = () => (
  <Router>
    <div>
      <Route path="/" exact component={Home} />
    </div>
  </Router>
);

export default AppRouter;
