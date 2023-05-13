var express = require('express');
var router = express.Router();

quantList = ["aqi", "co", "temp", "humidity", "ppm", "pressure"]

function generateValues(){
    var newDate = new Date();
    dateNow = newDate.toISOString();
    valJSON = {}
    valJSON["_time"] = dateNow

    for(let i of quantList){
        valJSON[i] = Math.floor(Math.random() * (300 - 30) + 30);
    }

    valJSON["location"] = "Rudraram";
    return valJSON;
}
/* GET home page. */
router.get('/', function(req, res, next) {
    res.json(generateValues());
});

module.exports = router;