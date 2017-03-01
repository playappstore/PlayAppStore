var express = require('express')
var app = express()
var all_apps = require(__dirname + '/test_apps.json');
var all_versions = require(__dirname + '/test_versions.json');
var detail = require(__dirname + '/test_detail.json');




app.get('/', function (req, res) {
  res.send('Hello World!')
})

app.get('/apps/:platform', function (req, res) {
	

	res.json(all_apps);
  
})

app.get('/apps/:platform/:bundleID', function (req, res) {
	

	res.json(all_versions);
  
})

app.get('/apps/:platform/:bundleID/:id', function (req, res) {
	

	res.json(detail);
  
})

app.listen(3000, function () {
  console.log('Example app listening on port 3000!')
})