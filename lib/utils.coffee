_ = require('lodash-contrib')
path = require('path')
resin = require('resin-sdk')
gitwrap = require('gitwrap')

exports.getRemoteApplicationName = (url) ->

	if not url?
		throw new Error('Missing url argument')

	if not _.isString(url)
		throw new Error("Invalid url argument: #{url}")

	if _.isEmpty(url)
		throw new Error('Invalid url argument: empty string')

	return path.basename(url, '.git')

# TODO: This should be probably be moved to the SDK
exports.getApplicationIdByName = (name, callback) ->

	if not name?
		throw new Error('Missing name argument')

	if not _.isString(name)
		throw new Error("Invalid name argument: #{name}")

	resin.models.application.getAll (error, applications) ->
		return callback(error) if error?

		application = _.find applications, (application) ->
			return application.app_name.toLowerCase() is name.toLowerCase()

		if not application?
			return callback(new Error("Application not found: #{name}"))

		return callback(null, application.id)

# TODO: Should we test this?
exports.execute = (directory, command, callback) ->
	gitwrap.create(directory).execute(command, callback)
