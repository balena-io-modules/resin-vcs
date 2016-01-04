
/*
Copyright 2016 Resin.io

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */
var Promise, gitwrap, _;

_ = require('lodash');

Promise = require('bluebird');

gitwrap = require('gitwrap');


/**
 * @summary Execute a git command
 * @function
 * @protected
 *
 * @param {String} directory - directory
 * @param {String} command - git command, omitting "git"
 *
 * @returns {Promise<String|undefined>} output
 *
 * @example
 * utils.execute('foo/bar', 'log --pretty=oneline -1').then (output) ->
 * 	if output?
 * 		console.log(output)
 */

exports.execute = function(directory, command) {
  return Promise.fromNode(function(callback) {
    return gitwrap.create(directory).execute(command, function(error, stdout, stderr) {
      if (error != null) {
        return callback(error);
      }
      if (!_.isEmpty(stderr)) {
        return callback(new Error(stderr.trim()));
      }
      return callback(null, stdout.trim() || void 0);
    });
  });
};


/**
 * @summary Check if a directory is a git repository
 * @function
 * @protected
 *
 * @param {String} directory - directory
 * @returns {Promise<Boolean>} is a git repository
 *
 * @example
 * utils.isGitRepository('foo/bar').then (isGitRepository) ->
 * 	if isGitRepository
 * 		console.log('Is is a git repository')
 */

exports.isGitRepository = function(directory) {
  return Promise.fromNode(function(callback) {
    return gitwrap.create(directory).isGitRepository(function(isGitRepository) {
      return callback(null, isGitRepository);
    });
  });
};


/**
 * @summary Get git resin remote from a repository
 * @function
 * @protected
 *
 * @param {String} directory - directory
 * @returns {Promise<String|undefined>} resin remote
 *
 * @example
 * utils.getRemote('foo/bar').then (remote) ->
 * 	if remote?
 * 		console.log(remote)
 */

exports.getRemote = function(directory) {
  return exports.execute(directory, 'config --get remote.resin.url');
};
