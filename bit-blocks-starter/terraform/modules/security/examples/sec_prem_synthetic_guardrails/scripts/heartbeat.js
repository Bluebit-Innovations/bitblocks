const http = require('http');

// heartbeat.js
// This script checks the heartbeat of a service by sending a simple HTTP GET request.


const serviceUrl = 'http://example.com/heartbeat'; // Replace with your service's heartbeat endpoint

function checkHeartbeat() {
    http.get(serviceUrl, (res) => {
        if (res.statusCode === 200) {
            console.log('Service is alive and responding.');
        } else {
            console.log(`Service responded with status code: ${res.statusCode}`);
        }
    }).on('error', (err) => {
        console.error('Error checking heartbeat:', err.message);
    });
}

// Check heartbeat every 10 seconds
setInterval(checkHeartbeat, 10000);