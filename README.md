# HyperWeb init

A quick, simple way to start an Express project with fancy language support


Init ✨
-------

```js
var hw = require('hyperweb-init');
app = hw.init();
```

Usage 🐙
---------

use `app` like you would in [express](http://expressjs.com/en/starter/basic-routing.html)

```js
app.get("/", function (request, response) {
  response.render('index.html', {
    title: "The Solar System"
  });
});
```
and so on.

Fancy Languages Supported 🐕
---------------

- CoffeeScript
- LESS
- Stylus
- Jade
- Nunjucks (html)
- Handlebars (hbs)
- CSON

<br>
<br>

🌹X🌹O🌹X🌹O🌹

[HyperWeb](http://hyperweb.space/)
