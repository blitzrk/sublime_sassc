var request = require('request-promise');
var crypto = require('crypto');

function hmacCreate(data, secret) {
  const hmac = crypto.createHmac('sha1', secret);
  hmac.update(data);
  return "sha1="+hmac.digest('hex');
}

function response(token, os) {
  return {
    method: "POST",
    uri: "https://api.travis-ci.org/repo/blitzrk%2Fsublime_sassc/requests",
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Travis-API-Version": 3,
      "Authorization": "token "+token
    },
    body: {
      request: {
        branch: "build",
        config: { os: os }
      }
    },
    json: true
  }
}

function triggerTravisCI(hook) {
  delete hook.params.owner;
  delete hook.params.gist;
  delete hook.params.hook;
  
  var hmac = hook.req.headers["x-hub-signature"];
  var token = hook.env["TRAVIS_TOKEN"];
  var secret = hook.env["GITHUB_SECRET"];
  var payload = JSON.stringify(hook.params);

  if(hmac !== hmacCreate(payload, secret)) {
    console.log("GitHub not authenticated as sender");
    return hook.res.end();
  }

  var commits = hook.params.commits || [];
  var messages = commits.map(function(commit) { return commit.message });
  var valid = messages.filter(RegExp.prototype.test, /^Upgrade (linux)|(osx) to v[0-9]\.[0-9]\.[0-9]$/);
  var invalid = messages.filter(function(msg) { return valid.indexOf(msg) < 0 });
  
  for(var msg of invalid) {
    console.log("Skipping commit msg:", msg);
  }

  Promise.all(valid.map(function(message) {
    console.log(message);
    var os = message.split(" ")[1];
    return request(response(token, os));
  })).then(function() { return hook.res.end() }, function(err) {
    console.log(err);
    return hook.res.end();
  });
}

module.exports = triggerTravisCI;
