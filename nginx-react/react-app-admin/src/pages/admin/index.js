import React from "react";
import { Row, Col, Table, message } from "antd";
import socketIOClient from "socket.io-client";
import axios from "axios";

import api from "../../utils/api.js";

import config from "../../utils/config.js";

const socket = socketIOClient(config.nodeHost, {
  path: "/node/socket.io"
});

const columns = [
  {
    title: "Name",
    dataIndex: "name",
    key: "name",
    render: text => <div>{text}</div>
  }
];

class Page extends React.Component {
  state = {
    data: []
  };

  async componentDidMount() {
    const url = new URL(window.location.href);
    const token = url.searchParams.get("token");
    if (token) {
      axios.defaults.headers.common["Authorization"] = `Bearer ${token}`;
    }

    const response = await api.post.get(token);

    this.setState({
      data: response.data
    });

    socket.on("new application", async msg => {
      const {
        data: { id }
      } = JSON.parse(msg);

      const response = await api.post.getById(id);

      if (response.data && response.data.length === 1) {
        const { data } = this.state;

        this.setState({
          data: [...response.data, ...data]
        });

        message.success("New Notification");
      }
    });
  }

  render() {
    const { data } = this.state;

    return (
      <Row>
        <Col offset={1} span={22}>
          <Table rowKey="id" columns={columns} dataSource={data} />
        </Col>
      </Row>
    );
  }
}

export default Page;
