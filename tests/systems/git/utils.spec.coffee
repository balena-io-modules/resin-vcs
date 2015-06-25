m = require('mochainon')
gitwrap = require('gitwrap')
utils = require('../../../lib/systems/git/utils')

describe 'Utils:', ->

	describe '.execute()', ->

		describe 'given the command outputs to stdout', ->

			beforeEach ->
				@gitwrapCreateStub = m.sinon.stub(gitwrap, 'create')
				@gitwrapCreateStub.returns
					execute: (command, callback) ->
						return callback(null, 'stdout output', '')

			afterEach ->
				@gitwrapCreateStub.restore()

			it 'should eventually equal stdout', ->
				promise = utils.execute('foo/bar', 'command')
				m.chai.expect(promise).to.eventually.equal('stdout output')

		describe 'given the command outputs to stdout with extra spaces', ->

			beforeEach ->
				@gitwrapCreateStub = m.sinon.stub(gitwrap, 'create')
				@gitwrapCreateStub.returns
					execute: (command, callback) ->
						return callback(null, '  stdout output  ', '')

			afterEach ->
				@gitwrapCreateStub.restore()

			it 'should eventually equal stdout with the spaces trimmed', ->
				promise = utils.execute('foo/bar', 'command')
				m.chai.expect(promise).to.eventually.match(/^stdout output$/)

		describe 'given the command outputs to stderr', ->

			beforeEach ->
				@gitwrapCreateStub = m.sinon.stub(gitwrap, 'create')
				@gitwrapCreateStub.returns
					execute: (command, callback) ->
						return callback(null, '', 'stderr output')

			afterEach ->
				@gitwrapCreateStub.restore()

			it 'should reject with stderr', ->
				promise = utils.execute('foo/bar', 'command')
				m.chai.expect(promise).to.be.rejectedWith('stderr output')

		describe 'given the command outputs to stderr with extra spaces', ->

			beforeEach ->
				@gitwrapCreateStub = m.sinon.stub(gitwrap, 'create')
				@gitwrapCreateStub.returns
					execute: (command, callback) ->
						return callback(null, '', '  stderr output  ')

			afterEach ->
				@gitwrapCreateStub.restore()

			it 'should reject with stderr with the spaces trimmed', ->
				promise = utils.execute('foo/bar', 'command')
				m.chai.expect(promise).to.be.rejectedWith(/^stderr output$/)

		describe 'given the command outputs nothing', ->

			beforeEach ->
				@gitwrapCreateStub = m.sinon.stub(gitwrap, 'create')
				@gitwrapCreateStub.returns
					execute: (command, callback) ->
						return callback(null, '', '')

			afterEach ->
				@gitwrapCreateStub.restore()

			it 'should eventually be undefined', ->
				promise = utils.execute('foo/bar', 'command')
				m.chai.expect(promise).to.eventually.be.undefined

		describe 'given the command returns an error', ->

			beforeEach ->
				@gitwrapCreateStub = m.sinon.stub(gitwrap, 'create')
				@gitwrapCreateStub.returns
					execute: (command, callback) ->
						return callback(new Error('git error'))

			afterEach ->
				@gitwrapCreateStub.restore()

			it 'should be rejected with the error message', ->
				promise = utils.execute('foo/bar', 'command')
				m.chai.expect(promise).to.be.rejectedWith('git error')
