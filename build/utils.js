var gitwrap, path, resin, _;

_ = require('lodash-contrib');

path = require('path');

resin = require('resin-sdk');

gitwrap = require('gitwrap');

exports.getRemoteApplicationName = function(url) {
  if (url == null) {
    throw new Error('Missing url argument');
  }
  if (!_.isString(url)) {
    throw new Error("Invalid url argument: " + url);
  }
  if (_.isEmpty(url)) {
    throw new Error('Invalid url argument: empty string');
  }
  return path.basename(url, '.git');
};

exports.getApplicationIdByName = function(name, callback) {
  var dataPrefix;
  if (name == null) {
    throw new Error('Missing name argument');
  }
  if (!_.isString(name)) {
    throw new Error("Invalid name argument: " + name);
  }
  dataPrefix = resin.settings.get('dataPrefix');
  return resin.data.prefix.set(dataPrefix, function(error) {
    if (error != null) {
      return callback(error);
    }
    return resin.models.application.getAll(function(error, applications) {
      var application;
      if (error != null) {
        return callback(error);
      }
      application = _.find(applications, function(application) {
        return application.app_name.toLowerCase() === name.toLowerCase();
      });
      if (application == null) {
        return callback(new Error("Application not found: " + name));
      }
      return callback(null, application.id);
    });
  });
};

exports.execute = function(directory, command, callback) {
  return gitwrap.create(directory).execute(command, callback);
};
