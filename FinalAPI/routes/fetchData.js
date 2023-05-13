const {InfluxDB, FluxTableMetaData, FluxTableColumn} = require('@influxdata/influxdb-client');
const { parse } = require('dotenv');
const express = require('express');
var router = express.Router();
require('dotenv').config();

const token = process.env.INFLUXDB_TOKEN
const url = process.env.URL

const client = new InfluxDB({url, token})
let bucket = 'sensorData';
let org = "Demo";

let queryClient = client.getQueryApi(org)
let fluxQuery = `from(bucket: "${bucket}")
 |> range(start: -10d)
 |> filter(fn: (r) => r._measurement == "Readings")
 |> last()
 |> pivot(rowKey:["_time"], columnKey: ["_field"], valueColumn: "_value")
 `

let quantList = ["aqi", "co", "temp", "humidity", "ppm", "pressure", "altitude"]

router.get('/', function(req, res, err) {

  resJson = {};   

  queryClient.queryRows(fluxQuery, {
      next(row, tableMeta) {
          const values = Object.values(row);
          const columns = tableMeta.columns.map((column) => column.label);  

          for(let i=0; i<columns.length; i++){
            if(values[i]=='') continue;
            resJson[columns[i]] = values[i];
          }

          for(let i of quantList){
            resJson[i] = parseFloat(resJson[i]);
          }

      },
      error(error) {
        console.error(error);
      },
      complete() {
        console.log('\nFinished SUCCESS');
        res.json(resJson)
      },
  });

});

module.exports = router;