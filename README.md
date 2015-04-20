resin-vcs
---------

[![npm version](https://badge.fury.io/js/resin-vcs.svg)](http://badge.fury.io/js/resin-vcs)
[![dependencies](https://david-dm.org/resin-io/resin-vcs.png)](https://david-dm.org/resin-io/resin-vcs.png)
[![Build Status](https://travis-ci.org/resin-io/resin-vcs.svg?branch=master)](https://travis-ci.org/resin-io/resin-vcs)

A layer between Resin.io and VCS.

It provides functionality to interact with versioning control resin applications repositories.

It supports only Git for now, but it might support other technologies in the future as well.

Installation
------------

Install `resin-vcs` by running:

```sh
$ npm install --save resin-vcs
```

Documentation
-------------

#### vcs.isRepository(String path, Function callback)

Check that a certain directory is a repository.

The callback gets passed `(Boolean isRepository)`.

#### vcs.initialize(String path, Function callback)

Initialize a directory as a repository. If the directory is already a repository, this function doesn't do anything.

The callback gets passed `(Error error)`.

#### vcs.getRemote(String path, Function callback)

Get the resin remote of a certain directory.

#### vcs.addRemote(String path, String remote, Function callback)

Add a resin remote to a directory.

The callback gets passed `(Error error, String remote)`.

#### vcs.clone(String remote, String path, Function callback)

Clone a remote to a certain directory.

#### vcs.getApplicationName(String path, Function callback)

If the directory is a resin application, get the application name associated to that application.

#### vcs.getApplicationId(String path, Function callback)

If the directory is a resin application, get the id associated to that application.

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io/resin-vcs/issues](https://github.com/resin-io/resin-vcs/issues)
- Source Code: [github.com/resin-io/resin-vcs](https://github.com/resin-io/resin-vcs)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/resin-vcs/issues/new) on GitHub.

ChangeLog
---------

### v1.1.0

- Make use of [resin-errors](https://github.com/resin-io/resin-errors).

License
-------

The project is licensed under the MIT license.
