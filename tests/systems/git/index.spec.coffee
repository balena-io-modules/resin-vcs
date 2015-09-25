m = require('mochainon')
Promise = require('bluebird')
git = require('../../../lib/systems/git')
utils = require('../../../lib/systems/git/utils')

describe 'Git:', ->

	describe '.associate()', ->

		describe 'given the directory is not a git repository', ->

			beforeEach ->
				@utilsIsGitRepository = m.sinon.stub(utils, 'isGitRepository')
				@utilsIsGitRepository.returns(Promise.resolve(false))

			afterEach ->
				@utilsIsGitRepository.restore()

			it 'should be rejected with an error', ->
				promise = git.associate('foo/bar', 'jviotti@git.resin.io:jviotti/foobar.git')
				m.chai.expect(promise).to.be.rejectedWith('Not a git repository: foo/bar')

	describe '.getApplicationName()', ->

		describe 'given the directory is not a git repository', ->

			beforeEach ->
				@utilsIsGitRepository = m.sinon.stub(utils, 'isGitRepository')
				@utilsIsGitRepository.returns(Promise.resolve(false))

			afterEach ->
				@utilsIsGitRepository.restore()

			it 'should be rejected with an error', ->
				promise = git.getApplicationName('foo/bar')
				m.chai.expect(promise).to.be.rejectedWith('Not a git repository: foo/bar')

		describe 'given the directory is a git repository', ->

			beforeEach ->
				@utilsIsGitRepository = m.sinon.stub(utils, 'isGitRepository')
				@utilsIsGitRepository.returns(Promise.resolve(true))

			afterEach ->
				@utilsIsGitRepository.restore()

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
