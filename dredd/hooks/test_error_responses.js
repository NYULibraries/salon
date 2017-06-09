var hooks = require('hooks');

hooks.beforeEach(function (transaction) {
  transaction.skip = false;
  // don't run GET /{id} tests
  if (transaction.id === 'GET /abc') {
    transaction.skip = true;
    return;
  }
  // add auth headers unless testing 401
  if (transaction.expected.statusCode !== '401') {
    transaction.request.headers.Auth = 'test_auth_key';
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
});
