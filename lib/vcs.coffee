gitwrap = require('gitwrap')
_ = require('lodash-contrib')
utils = require('./utils')

exports.isRepository = (directory, callback) ->
	gitwrap.create(directory).isGitRepository(callback)

exports.initialize = (directory, callback) ->
	exports.isRepository directory, (isRepository) ->
		return callback() if isRepository
		utils.execute(directory, 'init', _.unary(callback))

exports.getRemote = (directory, callback) ->
	command = 'config --get remote.resin.url'
	utils.execute directory, command, (error, stdout, stderr) ->
		return callback(error) if error?
		return callback(new Error(stderr)) if stderr?
		return callback(null, stdout.trim())

exports.clone = (url, directory, callback) ->

	if not directory?
		throw new Error('Missing directory argument')

	if not url?
		throw new Error('Missing url argument')

	utils.execute(directory, "clone #{url} . --quiet", callback)

exports.addRemote = (directory, url, callback) ->

	if not directory?
		throw new Error('Missing directory argument')

	if not url?
		throw new Error('Missing url argument')

	utils.execute(directory, "remote add resin #{url}", callback)

exports.getApplicationId = (directory, callback) ->
	exports.getRemote directory, (error, remoteUrl) ->
		return callback(error) if error?

		if _.isEmpty(remoteUrl)
			error = new Error("Not a resin application: #{directory}")
			return callback(error)

		applicationName = utils.getRemoteApplicationName(remoteUrl)
		utils.getApplicationIdByName(applicationName, callback)
