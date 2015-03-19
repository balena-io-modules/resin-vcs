_ = require('lodash-contrib')
path = require('path')
resin = require('resin-sdk')
errors = require('resin-errors')
gitwrap = require('gitwrap')

exports.getRemoteApplicationName = (url) ->

	if not url?
		throw new errors.ResinMissingParameter('url')

	if not _.isString(url)
		throw new errors.ResinInvalidParameter('url', url, 'not a string')

	if _.isEmpty(url)
		throw new errors.ResinInvalidParameter('url', url, 'empty string')

	return path.basename(url, '.git')

# TODO: This should be probably be moved to the SDK
exports.getApplicationIdByName = (name, callback) ->

	if not name?
		throw new errors.ResinMissingParameter('name')

	if not _.isString(name)
		throw new errors.ResinInvalidParameter('name', name, 'not a string')

	resin.models.application.getAll (error, applications) ->
		return callback(error) if error?

		application = _.find applications, (application) ->
			return application.app_name.toLowerCase() is name.toLowerCase()

		if not application?
			return callback(new errors.ResinApplicationNotFound(name))

		return callback(null, application.id)

# TODO: Should we test this?
exports.execute = (directory, command, callback) ->
	gitwrap.create(directory).execute(command, callback)
