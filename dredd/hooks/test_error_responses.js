const hooks = require('hooks');
const caseless = require('caseless');
const request = require('sync-request');
let stash = {};

// Get a valid test token to pass to API calls
hooks.beforeAll((transactions, done) => {
  let res = request('POST', 'https://dev.login.library.nyu.edu/oauth/token', {
    json: {
      "grant_type": "client_credentials",
      "client_id": process.env.TEST_CLIENT_ID,
      "client_secret": process.env.TEST_CLIENT_SECRET,
      "scope": "admin"
    }
  });
  stash["token"] = JSON.parse(res.getBody('utf8'))["access_token"];
  done();
});

hooks.beforeEach((transaction, done) => {
  // don't run GET /{id} tests
  if (transaction.request.uri === '/abc' && transaction.request.method == 'GET') {
    transaction.skip = true;
    return done();
  }

  // add auth headers unless testing 401
  if (transaction.expected.statusCode !== '401') {
    transaction.request.headers['Authorization'] = "Bearer " + stash['token'];
  }

  // replace with bad JSON for 400
  if (transaction.expected.statusCode === '400') {
    transaction.request.body = 'bad json';
  }

  // replace with resource missing URL for 422
  if (transaction.expected.statusCode === '422') {
    // if already an array, replace with array; otherwise use object
    if (transaction.request.body[0] === '[') {
      transaction.request.body = "[{\"id\":\"abcd\"}]";
    } else {
      transaction.request.body = "{\"id\":\"abcd\"}";
    }
  }

  transaction.skip = false;
  done();
});

// Scrub the access token from the public logs
hooks.afterEach((transaction, done) => {
  let headers = transaction.request.headers;
  let name = caseless(headers).has('Authorization');
  headers[name] = "Bearer t0ken";
  transaction.request.headers = headers;
  done();
});
