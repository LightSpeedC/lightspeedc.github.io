var path = require('path');
var port = process.argv[2] || process.env.PORT || 3000;
console.log('port:', port);
var express = require('express'), app = express();
app.use('/js',     express.static('js'));
app.use('/css',    express.static('css'));
app.use('/test',   express.static('test'));
app.use('/public', express.static('public'));
app.get('/*', function (req, res) {
  if (req.url === '/' || req.url === '/index.html')
    res.sendFile(path.resolve('index.html'));
  else
    res.status(404).send('file not found');
});
app.listen(port);
