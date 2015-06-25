m = require('mochainon')
Promise = require('bluebird')
git = require('../../../lib/systems/git')
utils = require('../../../lib/systems/git/utils')

describe 'Git:', ->

	describe '.getApplicationName()', ->

		describe 'given a valid resin git remote', ->

			beforeEach ->
				@utilsGetRemote = m.sinon.stub(utils, 'getRemote')
				@utilsGetRemote.returns(Promise.resolve('jviotti@git.resin.io:jviotti/foobar.git'))

			afterEach ->
				@utilsGetRemote.restore()

			it 'should eventually equal the application name', ->
				promise = git.getApplicationName('foo/bar')
				m.chai.expect(promise).to.eventually.equal('foobar')

		describe 'given no resin git remote', ->

			beforeEach ->
				@utilsGetRemote = m.sinon.stub(utils, 'getRemote')
				@utilsGetRemote.returns(Promise.resolve(undefined))

			afterEach ->
				@utilsGetRemote.restore()

			it 'should eventually be undefined', ->
				promise = git.getApplicationName('foo/bar')
				m.chai.expect(promise).to.eventually.be.undefined

		describe 'given an error getting the remote', ->

			beforeEach ->
				@utilsGetRemote = m.sinon.stub(utils, 'getRemote')
				@utilsGetRemote.returns(Promise.reject(new Error('git error')))

			afterEach ->
				@utilsGetRemote.restore()

			it 'should be rejected with the error', ->
				promise = git.getApplicationName('foo/bar')
				m.chai.expect(promise).to.be.rejectedWith('git error')
