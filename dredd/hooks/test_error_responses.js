var hooks = require('hooks');
var Client = require('node-rest-client').Client;
var stash = {};

hooks.beforeAll(function (transation) {
  var client = new Client();
  var url = "https://dev.login.library.nyu.edu/oauth/token";
  var parameters = {
    data: {
      "grant_type": "client_credentials",
      "client_id": "id",
      "client_secret": "secreet",
      "scope": "admin"
    }
  };
  client.post(url, args, function (data, response) {
    // parsed response body as js object
    console.log(data);
    // raw response
    console.log(response);
  });
});

hooks.beforeEach(function (transaction) {
  // don't run GET /{id} tests
  if (transaction.id === 'GET /abc') {
    transaction.skip = true;
    return;
  }
  // add auth headers unless testing 401
  if (transaction.expected.statusCode !== '401') {
    transaction.request.headers['Authorization'] = "Bearer " + stash['token']
  }
  // replace with bad JSON for 400
  if (transaction.expected.statusCode === '400') {
    transaction.request.body = 'bad json';
  }
  transaction.skip = false;
});
