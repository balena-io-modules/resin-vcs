
/*
The MIT License

Copyright (c) 2015 Resin.io, Inc. https://resin.io.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
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
