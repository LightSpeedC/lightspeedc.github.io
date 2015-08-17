var path = require('path');
var port = process.argv[2] || process.env.PORT || 3000;
console.log('port:', port);
var express = require('express'), app = express();
['js', 'css', 'mui', 'mdl', 'mithril', 'public'].forEach(
  function (dir) {
    app.use('/' + dir, express.static(dir));
  });
app.get('/*', function (req, res) {
  if (req.url === '/' || req.url === '/index.html')
    res.sendFile(path.resolve('index.html'));
  else if (req.url === '/index.json')
    res.sendFile(path.resolve('index.json'));
  else
    res.status(404).send('file not found');
});
app.listen(port);
