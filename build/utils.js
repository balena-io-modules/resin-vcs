var errors, gitwrap, path, resin, _;

_ = require('lodash-contrib');

path = require('path');

resin = require('resin-sdk');

errors = require('resin-errors');

gitwrap = require('gitwrap');

exports.getRemoteApplicationName = function(url) {
  if (url == null) {
    throw new errors.ResinMissingParameter('url');
  }
  if (!_.isString(url)) {
    throw new errors.ResinInvalidParameter('url', url, 'not a string');
  }
  if (_.isEmpty(url)) {
    throw new errors.ResinInvalidParameter('url', url, 'empty string');
  }
  return path.basename(url, '.git');
};

exports.getApplicationIdByName = function(name, callback) {
  if (name == null) {
    throw new errors.ResinMissingParameter('name');
  }
  if (!_.isString(name)) {
    throw new errors.ResinInvalidParameter('name', name, 'not a string');
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
      return callback(new errors.ResinApplicationNotFound(name));
    }
    return callback(null, application.id);
  });
};

exports.execute = function(directory, command, callback) {
  return gitwrap.create(directory).execute(command, callback);
};
