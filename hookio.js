var request = require('request-promise');

function payload(token, os) {
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
  var token = hook.env["TRAVIS_TOKEN"];

  var commits = hook.params.commits
    .map(function(commit) { return commit.message })
    .filter(RegExp.prototype.test.bind(/^Upgrade (linux)|(osx) to v[0-9]\.[0-9]\.[0-9]$/));

  Promise.all(commits.map(function(message) {
    var os = message.split(" ")[1];
    return request.post(payload(token, os));
  })).then(function() { return hook.res.end() }, function(err) {
    console.log(err);
    return hook.res.end();
  });
}

module.exports = triggerTravisCI;

module.exports.schema = {
  commits: [{
    message: "string"
  }]
};
