require('express')().use(require('express').static('docs')).listen(process.argv[2] || process.env.PORT || 3000);
