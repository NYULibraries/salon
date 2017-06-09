var hooks = require('hooks');

hooks.beforeEach(function (transaction) {
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
    if (transaction.id === 'POST /') {
      transaction.request.body = "{\"id\":\"abcd\"}";
    } else if (transaction.id === 'POST /create_with_array') {
      transaction.request.body = "[{\"id\":\"abcd\"}]";
    }
  }
  transaction.skip = false;
});
