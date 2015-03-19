var errors, gitwrap, utils, _;

gitwrap = require('gitwrap');

_ = require('lodash-contrib');

errors = require('resin-errors');

utils = require('./utils');

exports.isRepository = function(directory, callback) {
  return gitwrap.create(directory).isGitRepository(callback);
};

exports.initialize = function(directory, callback) {
  return exports.isRepository(directory, function(isRepository) {
    if (isRepository) {
      return callback();
    }
    return utils.execute(directory, 'init', _.unary(callback));
  });
};

exports.getRemote = function(directory, callback) {
  var command;
  command = 'config --get remote.resin.url';
  return utils.execute(directory, command, function(error, stdout, stderr) {
    if (error != null) {
      return callback(new errors.ResinInvalidApplication(directory));
    }
    if ((stderr != null) && !_.isEmpty(stderr)) {
      return callback(new Error(stderr));
    }
    return callback(null, stdout.trim());
  });
};

exports.clone = function(url, directory, callback) {
  if (directory == null) {
    throw new errors.ResinMissingParameter('directory');
  }
  if (url == null) {
    throw new errors.ResinMissingParameter('url');
  }
  return utils.execute(directory, "clone " + url + " . --quiet", callback);
};

exports.addRemote = function(directory, url, callback) {
  if (directory == null) {
    throw new errors.ResinMissingParameter('directory');
  }
  if (url == null) {
    throw new errors.ResinMissingParameter('url');
  }
  return utils.execute(directory, "remote add resin " + url, function(error) {
    if (error != null) {
      return callback(error);
    }
    return callback(null, url);
  });
};

exports.getApplicationId = function(directory, callback) {
  return exports.getRemote(directory, function(error, remoteUrl) {
    var applicationName;
    if (error != null) {
      return callback(error);
    }
    if (_.isEmpty(remoteUrl)) {
      return callback(new errors.ResinInvalidApplication(directory));
    }
    applicationName = utils.getRemoteApplicationName(remoteUrl);
    return utils.getApplicationIdByName(applicationName, callback);
  });
};
