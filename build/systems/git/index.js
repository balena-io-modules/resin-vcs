
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

/**
 * @module vcs
 */
var path, utils;

path = require('path');

utils = require('./utils');


/**
 * @summary Initialize a directory with git
 * @function
 * @public
 *
 * @param {String} directory - directory
 * @returns {Promise}
 *
 * @example
 * vcs.initialize('foo/bar')
 */

exports.initialize = function(directory) {
  return utils.execute(directory, 'init');
};


/**
 * @summary Clone a git repository to a directory
 * @function
 * @public
 *
 * @param {String} url - repository url
 * @param {String} directory - directory
 * @returns {Promise}
 *
 * @example
 * vcs.clone('https://github.com/resin-io/resin-vcs.git', 'foo/bar')
 */

exports.clone = function(url, directory) {
  return utils.execute(directory, "clone " + url + " . --quiet");
};


/**
 * @summary Add a resin remote to a git repository
 * @function
 * @public
 *
 * @param {String} directory - directory
 * @param {String} url - repository url
 * @returns {Promise}
 *
 * @example
 * vcs.associate('foo/bar', 'jviotti@git.resin.io:jviotti/foobar.git')
 */

exports.associate = function(directory, url) {
  return utils.execute(directory, "remote add resin " + url);
};


/**
 * @summary Get the associated application name from a repository
 * @function
 * @public
 *
 * @param {String} directory - directory
 * @returns {Promise<String|undefined>} application name
 *
 * @example
 * vcs.getApplicationName('foo/bar').then (applicationName) ->
 * 	if applicationName?
 * 		console.log(applicationName)
 */

exports.getApplicationName = function(directory) {
  return utils.getRemote(directory).then(function(remoteUrl) {
    if (remoteUrl == null) {
      return;
    }
    return path.basename(remoteUrl, '.git');
  });
};
