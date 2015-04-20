gitwrap = require('gitwrap')
_ = require('lodash-contrib')
errors = require('resin-errors')
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

		if error?
			return callback(new errors.ResinInvalidApplication(directory))

		return callback(new Error(stderr)) if stderr? and not _.isEmpty(stderr)
		return callback(null, stdout.trim())

exports.clone = (url, directory, callback) ->

	if not directory?
		throw new errors.ResinMissingParameter('directory')

	if not url?
		throw new errors.ResinMissingParameter('url')

	utils.execute(directory, "clone #{url} . --quiet", callback)

exports.addRemote = (directory, url, callback) ->

	if not directory?
		throw new errors.ResinMissingParameter('directory')

	if not url?
		throw new errors.ResinMissingParameter('url')

	utils.execute directory, "remote add resin #{url}", (error) ->
		return callback(error) if error?
		return callback(null, url)

exports.getApplicationName = (directory, callback) ->
	exports.getRemote directory, (error, remoteUrl) ->
		return callback(error) if error?

		if _.isEmpty(remoteUrl)
			return callback(new errors.ResinInvalidApplication(directory))

		return callback(null, utils.getRemoteApplicationName(remoteUrl))

exports.getApplicationId = (directory, callback) ->
	exports.getApplicationName directory, (error, name) ->
		return callback(error) if error?
		utils.getApplicationIdByName(name, callback)
