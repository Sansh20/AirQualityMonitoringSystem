var express = require('express');
var router = express.Router();
require('dotenv').config();

const {InfluxDB, Point} = require('@influxdata/influxdb-client')

const token = process.env.INFLUXDB_TOKEN
const url = process.env.URL

const client = new InfluxDB({url, token})
let org = "Demo";
let bucket = 'sampleSensorData';

let writeClient = client.getWriteApi(org, bucket);

router.post('/', function(req, res, next) {
    var statusCode = 200;
 
    let point = new Point('Readings')
        .tag("location", req.query['location'])
        .floatField("aqi", req.query['aqi'])
        .floatField("co", req.query['co'])
        .floatField("temp", req.query['temp'])
        .floatField("pressure", req.query['pressure'])
        .floatField("humidity", req.query['humidity']);
    try {
        writeClient.writePoint(point)
    }
    catch(err){
        next(err);
    };

    writeClient.close()
        .catch((err)=>{
            next(err);
        });

    res.sendStatus(statusCode);

});


module.exports = router;
