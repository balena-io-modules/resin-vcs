_ = require('lodash-contrib')
sinon = require('sinon')
chai = require('chai')
chai.use(require('sinon-chai'))
expect = chai.expect
resin = require('resin-sdk')
utils = require('../lib/utils')
vcs = require('../lib/vcs')

describe 'VCS:', ->

	describe '.initialize()', ->

		it 'should throw an error if no directory', ->
			expect ->
				vcs.initialize(null, _.noop)
			.to.throw('Missing directory')

		describe 'if directory is a git repository', ->

			beforeEach ->
				@vcsIsRepositoryStub = sinon.stub(vcs, 'isRepository')
				@vcsIsRepositoryStub.yields(true)

				@utilsExecuteStub = sinon.stub(utils, 'execute')
				@utilsExecuteStub.yields(null, '', '')

			afterEach ->
				@vcsIsRepositoryStub.restore()
				@utilsExecuteStub.restore()

			it 'should not call execute', (done) ->
				vcs.initialize 'foo/bar', (error) =>
					expect(error).to.not.exist
					expect(@utilsExecuteStub).to.not.have.been.called
					done()

		describe 'if directory is not a git repository', ->

			beforeEach ->
				@vcsIsRepositoryStub = sinon.stub(vcs, 'isRepository')
				@vcsIsRepositoryStub.yields(false)

				@utilsExecuteStub = sinon.stub(utils, 'execute')
				@utilsExecuteStub.yields(null, '', '')

			afterEach ->
				@vcsIsRepositoryStub.restore()
				@utilsExecuteStub.restore()

			it 'should call execute with init', (done) ->
				vcs.initialize 'foo/bar', (error) =>
					expect(error).to.not.exist
					expect(@utilsExecuteStub).to.have.been.calledOnce
					expect(@utilsExecuteStub).to.have.been.calledWith('foo/bar', 'init')
					done()

	describe '.getRemote()', ->

		describe 'if execute returns an error', ->

			beforeEach ->
				@utilsExecuteStub = sinon.stub(utils, 'execute')
				@utilsExecuteStub.yields(new Error('execute error'))

			afterEach ->
				@utilsExecuteStub.restore()

			it 'should return a descriptive error', (done) ->
				vcs.getRemote 'foo/bar', (error, remoteUrl) ->
					expect(error).to.be.an.instanceof(Error)
					expect(error.message).to.equal('Couldn\'t get remote from: foo/bar')
					expect(remoteUrl).to.not.exist
					done()

		describe 'if it logs to stderr', ->

			beforeEach ->
				@utilsExecuteStub = sinon.stub(utils, 'execute')
				@utilsExecuteStub.yields(null, null, 'stderr')

			afterEach ->
				@utilsExecuteStub.restore()

			it 'should return an error with stderr contents', (done) ->
				vcs.getRemote 'foo/bar', (error, remoteUrl) ->
					expect(error).to.be.an.instanceof(Error)
					expect(error.message).to.equal('stderr')
					expect(remoteUrl).to.not.exist
					done()

		describe 'if it logs the url to stdout', ->

			beforeEach ->
				@utilsExecuteStub = sinon.stub(utils, 'execute')
				@utilsExecuteStub.yields(null, 'git@git.resin.io:jviotti/foobar.git', null)

			afterEach ->
				@utilsExecuteStub.restore()

			it 'should return the remote url', (done) ->
				vcs.getRemote 'foo/bar', (error, remoteUrl) ->
					expect(error).to.not.exist
					expect(remoteUrl).to.equal('git@git.resin.io:jviotti/foobar.git')
					done()

		describe 'if it logs the url to stdout with extra whitespace', ->

			beforeEach ->
				@utilsExecuteStub = sinon.stub(utils, 'execute')
				@utilsExecuteStub.yields(null, '    git@git.resin.io:jviotti/foobar.git ', null)

			afterEach ->
				@utilsExecuteStub.restore()

			it 'should trim the url', (done) ->
				vcs.getRemote 'foo/bar', (error, remoteUrl) ->
					expect(error).to.not.exist
					expect(remoteUrl).to.equal('git@git.resin.io:jviotti/foobar.git')
					done()

	describe '.clone()', ->

		beforeEach ->
			@utilsExecuteStub = sinon.stub(utils, 'execute')
			@utilsExecuteStub.yields(null, '', '')

		afterEach ->
			@utilsExecuteStub.restore()

		it 'should throw an error if no directory', ->
			expect ->
				vcs.clone('git@git.resin.io:jviotti/foobar.git', null, _.noop)
			.to.throw('Missing directory argument')

		it 'should throw an error if no url', ->
			expect ->
				vcs.clone(null, 'foo/bar', _.noop)
			.to.throw('Missing url argument')

		it 'should call execute with the url', (done) ->
			vcs.clone 'git@git.resin.io:jviotti/foobar.git', 'foo/bar', (error, stdout, stderr) =>
				expect(error).to.not.exist
				expect(@utilsExecuteStub).to.have.been.calledOnce
				expect(@utilsExecuteStub).to.have.been.calledWith('foo/bar', 'clone git@git.resin.io:jviotti/foobar.git . --quiet')
				done()

	describe '.addRemote()', ->

		beforeEach ->
			@utilsExecuteStub = sinon.stub(utils, 'execute')
			@utilsExecuteStub.yields(null, '', '')

		afterEach ->
			@utilsExecuteStub.restore()

		it 'should throw an error if no directory', ->
			expect ->
				vcs.addRemote(null, 'git@git.resin.io:jviotti/foobar.git', _.noop)
			.to.throw('Missing directory argument')

		it 'should throw an error if no url', ->
			expect ->
				vcs.addRemote('foo/bar', null, _.noop)
			.to.throw('Missing url argument')

		it 'should call execute with the url', (done) ->
			vcs.addRemote 'foo/bar', 'git@git.resin.io:jviotti/foobar.git', (error, remote) =>
				expect(error).to.not.exist
				expect(@utilsExecuteStub).to.have.been.calledOnce
				expect(@utilsExecuteStub).to.have.been.calledWith('foo/bar', 'remote add resin git@git.resin.io:jviotti/foobar.git')
				done()

		it 'should return the remote', (done) ->
			vcs.addRemote 'foo/bar', 'git@git.resin.io:jviotti/foobar.git', (error, remote) ->
				expect(error).to.not.exist
				expect(remote).to.equal('git@git.resin.io:jviotti/foobar.git')
				done()

	describe '.getApplicationId()', ->

		it 'should throw an error if no directory', ->
			expect ->
				vcs.getApplicationId(null, _.noop)
			.to.throw('Missing directory')

		describe 'if the remote was found', ->

			beforeEach ->
				@vcsGetRemoteStub = sinon.stub(vcs, 'getRemote')
				@vcsGetRemoteStub.yields(null, 'git@git.resin.io:jviotti/foobar.git')
				@utilsGetApplicationIdByNameStub = sinon.stub(utils, 'getApplicationIdByName')
				@utilsGetApplicationIdByNameStub.yields(null, 3)

			afterEach ->
				@vcsGetRemoteStub.restore()
				@utilsGetApplicationIdByNameStub.restore()

			it 'should return the correct it', (done) ->
				vcs.getApplicationId 'foo/bar', (error, id) ->
					expect(error).to.not.exist
					expect(id).to.equal(3)
					done()

			it 'should call getApplicationIdByName() with the app name', (done) ->
				vcs.getApplicationId 'foo/bar', (error, id) =>
					expect(@utilsGetApplicationIdByNameStub).to.have.been.calledOnce
					expect(@utilsGetApplicationIdByNameStub).to.have.been.calledWith('foobar')
					done()

		describe 'if the remote was not found', ->

			beforeEach ->
				@vcsGetRemoteStub = sinon.stub(vcs, 'getRemote')
				@vcsGetRemoteStub.yields(null, '')

			afterEach ->
				@vcsGetRemoteStub.restore()

			it 'should return an error', (done) ->
				vcs.getApplicationId 'foo/bar', (error, id) ->
					expect(error).to.be.an.instanceof(Error)
					expect(error.message).to.equal('Not a resin application: foo/bar')
					expect(id).to.not.exist
					done()
