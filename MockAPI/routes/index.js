var express = require('express');
var router = express.Router();

quantList = ["aqi", "co", "temp", "humidity", "ppm", "pressure"]

function generateValues(){
  valJSON = {}

  for(let i of quantList){
    valJSON[i] = Math.floor(Math.random() * (300 - 30) + 30);
  }

  console.log(valJSON);
}
/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
  generateValues();
});

module.exports = router;
