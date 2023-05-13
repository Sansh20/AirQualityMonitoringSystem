var express = require('express');
var router = express.Router();
var moment = require('moment');
var http = require('http');
const { markAsUntransferable } = require('worker_threads');

quantList = ["aqi", "co", "temp", "humidity", "ppm", "pressure"]

function generateValues(){
    valJSON = []
    for(let i=1; i<=10; i++){
        let date = moment().subtract(i, 'day');
        re = {}
        re["_time"] = date

        for(let i of quantList){
            re[i] = Math.floor(Math.random() * (300 - 30) + 30);
        }

        re["location"] = "Rudraram";
        valJSON.push(re);
    }
    return valJSON;
}

router.get('/', function(req, res, next) {
        res.json(generateValues());
    });



module.exports = router;