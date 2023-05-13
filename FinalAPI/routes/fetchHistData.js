const {InfluxDB, FluxTableMetaData, FluxTableColumn} = require('@influxdata/influxdb-client');
const { parse } = require('dotenv');
const express = require('express');
var router = express.Router();
require('dotenv').config();

const token = process.env.INFLUXDB_TOKEN
const url = process.env.URL

const client = new InfluxDB({url, token})
let org = "Demo";
let bucket = 'sensorData';

let queryClient = client.getQueryApi(org)
let fluxQuery = `from(bucket: "${bucket}")
|> range(start: -30d, stop: -12h)
|> filter(fn: (r) => r._measurement=="Readings")
|> aggregateWindow(every: 1d, fn: mean, createEmpty: false)
|> pivot(rowKey:["_time"], columnKey: ["_field"], valueColumn: "_value")
|> drop(columns: ["altitude"])
 `

let quantList = ["aqi", "co", "temp", "humidity", "ppm", "pressure"]

router.get('/', function(req, res, err) {
  enteries = [];
  queryClient.queryRows(fluxQuery, {
    next(row, tableMeta) {
      const values = Object.values(row);
      const columns = tableMeta.columns.map((column) => column.label);  
      let resJson = {};    

      for(let i in columns){
        if(values[i] == "") values[i] = 0;
        resJson[columns[i]] = values[i] 
      }

      for(let i in quantList){
        resJson[quantList[i]] = parseFloat(resJson[quantList[i]]);
    }

      enteries.push(resJson)

    },
    error(error) {
      console.error(error);
    },
    complete() {
      // console.log(enteries);
      res.json(enteries);
      console.log('\nFinished SUCCESS');
    },
  });
});

module.exports = router;