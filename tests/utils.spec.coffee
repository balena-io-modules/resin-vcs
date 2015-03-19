_ = require('lodash-contrib')
sinon = require('sinon')
chai = require('chai')
chai.use(require('sinon-chai'))
expect = chai.expect
resin = require('resin-sdk')
utils = require('../lib/utils')

describe 'Utils:', ->

	describe '.getRemoteApplicationName()', ->

		it 'should throw an error if no url', ->
			expect ->
				utils.getRemoteApplicationName()
			.to.throw('Missing parameter: url')

		it 'should throw an error if url is not a string', ->
			expect ->
				utils.getRemoteApplicationName(123)
			.to.throw('Invalid parameter url: 123. not a string')

		it 'should throw an error if url is an empty string', ->
			expect ->
				utils.getRemoteApplicationName('')
			.to.throw('Invalid parameter url: . empty string')

		it 'should get the application name from a remote', ->
			url = 'git@git.resin.io:jviotti/foobar.git'
			expect(utils.getRemoteApplicationName(url)).to.equal('foobar')

	describe '.getApplicationIdByName()', ->

		beforeEach ->
			@resinApplicationGetAllStub = sinon.stub(resin.models.application, 'getAll')
			@resinApplicationGetAllStub.yields null, [
				{ id: 1, app_name: 'foo' }
				{ id: 2, app_name: 'bar' }
				{ id: 3, app_name: 'baz' }
				{ id: 4, app_name: 'qux' }
			]

		afterEach ->
			@resinApplicationGetAllStub.restore()

		it 'should throw an error if no name', ->
			expect ->
				utils.getApplicationIdByName(null, _.noop)
			.to.throw('Missing parameter: name')

		it 'should throw an error if name is not a string', ->
			expect ->
				utils.getApplicationIdByName(123, _.noop)
			.to.throw('Invalid parameter name: 123. not a string')

		describe 'given the user has the application with other case setting', ->

			it 'should return the correct id', (done) ->
				utils.getApplicationIdByName 'BAZ', (error, id) ->
					expect(error).to.not.exist
					expect(id).to.equal(3)
					done()

		describe 'given the user has the application', ->

			it 'should return the correct id', (done) ->
				utils.getApplicationIdByName 'bar', (error, id) ->
					expect(error).to.not.exist
					expect(id).to.equal(2)
					done()

		describe 'given the user does not have the application', ->

			it 'should return an error', (done) ->
				utils.getApplicationIdByName 'hello', (error, id) ->
					expect(error).to.be.an.instanceof(Error)
					expect(error.message).to.equal('Application not found: hello')
					expect(id).to.not.exist
					done()
