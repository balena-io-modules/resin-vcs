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

###*
# @module vcs
###

path = require('path')
utils = require('./utils')

###*
# @summary Initialize a directory with git
# @function
# @public
#
# @param {String} directory - directory
# @returns {Promise}
#
# @example
# vcs.initialize('foo/bar')
###
exports.initialize = (directory) ->
	utils.execute(directory, 'init')

###*
# @summary Clone a git repository to a directory
# @function
# @public
#
# @param {String} url - repository url
# @param {String} directory - directory
# @returns {Promise}
#
# @example
# vcs.clone('https://github.com/resin-io/resin-vcs.git', 'foo/bar')
###
exports.clone = (url, directory) ->
	utils.execute(directory, "clone #{url} . --quiet")

###*
# @summary Add a resin remote to a git repository
# @function
# @public
#
# @param {String} directory - directory
# @param {String} url - repository url
# @returns {Promise}
#
# @example
# vcs.associate('foo/bar', 'jviotti@git.resin.io:jviotti/foobar.git')
###
exports.associate = (directory, url) ->
	utils.isGitRepository(directory).then (isGitRepository) ->
		if not isGitRepository
			throw new Error("Not a git repository: #{directory}")

		utils.execute(directory, "remote add resin #{url}")

###*
# @summary Get the associated application name from a repository
# @function
# @public
#
# @param {String} directory - directory
# @returns {Promise<String|undefined>} application name
#
# @example
# vcs.getApplicationName('foo/bar').then (applicationName) ->
# 	if applicationName?
# 		console.log(applicationName)
###
exports.getApplicationName = (directory) ->
	utils.isGitRepository(directory).then (isGitRepository) ->
		if not isGitRepository
			throw new Error("Not a git repository: #{directory}")

		utils.getRemote(directory).then (remoteUrl) ->
			return if not remoteUrl?
			return path.basename(remoteUrl, '.git')
