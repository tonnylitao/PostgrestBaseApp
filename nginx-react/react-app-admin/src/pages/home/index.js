import React from "react";
import { Row, Col, Table, message } from "antd";
import socketIOClient from "socket.io-client";

import api from "../../utils/api.js";

import config from "../../utils/config.js";

const socket = socketIOClient(config.nodeHost, {
  path: "/node/socket.io"
});

const columns = [
  {
    title: "Id",
    dataIndex: "id",
    render: text => <div>{text}</div>
  },
  {
    title: "Title",
    dataIndex: "title",
    render: text => <div>{text}</div>
  },
  {
    title: "Body",
    dataIndex: "body",
    render: text => <div>{text}</div>
  }
];

class Page extends React.Component {
  state = {
    data: []
  };

  async componentDidMount() {
    const response = await api.community.posts.get();

    this.setState({
      data: response.data
    });

    socket.on("new application", async msg => {
      const {
        data: { id }
      } = JSON.parse(msg);

      const response = await api.community.getById(id);

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
