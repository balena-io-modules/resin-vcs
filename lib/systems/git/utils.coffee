###
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
###

_ = require('lodash')
Promise = require('bluebird')
gitwrap = require('gitwrap')

###*
# @summary Execute a git command
# @function
# @protected
#
# @param {String} directory - directory
# @param {String} command - git command, omitting "git"
#
# @returns {Promise<String|undefined>} output
#
# @example
# utils.execute('foo/bar', 'log --pretty=oneline -1').then (output) ->
# 	if output?
# 		console.log(output)
###
exports.execute = (directory, command) ->
	Promise.fromNode (callback) ->
		gitwrap.create(directory).execute command, (error, stdout, stderr) ->
			return callback(error) if error?
			return callback(new Error(stderr.trim())) if not _.isEmpty(stderr)
			return callback(null, stdout.trim() or undefined)

###*
# @summary Check if a directory is a git repository
# @function
# @protected
#
# @param {String} directory - directory
# @returns {Promise<Boolean>} is a git repository
#
# @example
# utils.isGitRepository('foo/bar').then (isGitRepository) ->
# 	if isGitRepository
# 		console.log('Is is a git repository')
###
exports.isGitRepository = (directory) ->
	Promise.fromNode (callback) ->
		gitwrap.create(directory).isGitRepository (isGitRepository) ->
			return callback(null, isGitRepository)

###*
# @summary Get git resin remote from a repository
# @function
# @protected
#
# @param {String} directory - directory
# @returns {Promise<String|undefined>} resin remote
#
# @example
# utils.getRemote('foo/bar').then (remote) ->
# 	if remote?
# 		console.log(remote)
###
exports.getRemote = (directory) ->
	exports.execute(directory, 'config --get remote.resin.url')
