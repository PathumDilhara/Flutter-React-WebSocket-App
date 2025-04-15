import express from "express";
import http from "http";
import cors from "cors";
import dotenv from "dotenv";
import { WebSocket, WebSocketServer } from "ws";

// https://docs.google.com/document/d/1QDMlE6Sg7mQj7TssFGd51cn9UwdZAqqfJCw9ALZAjqM/edit?usp=sharing

// For websocket testing we use hoppscotch

// config dotenv for port, db connection urls adding
dotenv.config();

// Create express app
const app = express();

// Create a server using our express app
const server = http.createServer(app); //  a http server

// Create websocket server using above http server
const wss = new WebSocketServer({ server });

// middlewares
// for creating cross orogins to create connection between client & server 
app.use(cors());
app.use(express.json());

// Create a new websocket connecions
wss.on("connection", (ws: WebSocket) => {
    console.log("New client connected");

    ws.on("message", (data) => {
        console.log("Received message from the client : " + data);
        wss.clients.forEach((client) => {
            // check client has websocket && client is connncted or not
            if (client !== ws && client.readyState == WebSocket.OPEN) {
                client.send(data); // send the frame to clients
            }
        });
    });

    ws.on("close", () => {
        console.log("Client disconnected");
    });
});

const PORT = process.env.PORT;

server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
