const https = require('https');

const options = {
    hostname: 'example.com', // Replace with your endpoint
    port: 443,
    path: '/ping', // Replace with the specific API path
    method: 'GET',
};

const req = https.request(options, (res) => {
    console.log(`Status Code: ${res.statusCode}`);

    res.on('data', (d) => {
        process.stdout.write(d);
    });
});

req.on('error', (error) => {
    console.error(`Error: ${error.message}`);
});

req.end();