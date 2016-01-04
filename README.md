resin-vcs
---------

[![npm version](https://badge.fury.io/js/resin-vcs.svg)](http://badge.fury.io/js/resin-vcs)
[![dependencies](https://david-dm.org/resin-io/resin-vcs.png)](https://david-dm.org/resin-io/resin-vcs.png)
[![Build Status](https://travis-ci.org/resin-io/resin-vcs.svg?branch=master)](https://travis-ci.org/resin-io/resin-vcs)
[![Build status](https://ci.appveyor.com/api/projects/status/o7lf4il899x1iib2?svg=true)](https://ci.appveyor.com/project/jviotti/resin-vcs)

A layer between Resin.io and VCS.

Role
----

The intention of this module is to provide an extensible layer between Resin.io and version control systems, such as [git](http://git-scm.com).

Systems
-------

Currently this module only supports [git](http://git-scm.com), but will be extended in the future.

Installation
------------

Install `resin-vcs` by running:

```sh
$ npm install --save resin-vcs
```

Documentation
-------------


* [vcs](#module_vcs)
  * [.initialize(directory)](#module_vcs.initialize) ⇒ <code>Promise</code>
  * [.clone(url, directory)](#module_vcs.clone) ⇒ <code>Promise</code>
  * [.associate(directory, url)](#module_vcs.associate) ⇒ <code>Promise</code>
  * [.getApplicationName(directory)](#module_vcs.getApplicationName) ⇒ <code>Promise.&lt;(String\|undefined)&gt;</code>

<a name="module_vcs.initialize"></a>
### vcs.initialize(directory) ⇒ <code>Promise</code>
**Kind**: static method of <code>[vcs](#module_vcs)</code>  
**Summary**: Initialize a directory with git  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| directory | <code>String</code> | directory |

**Example**  
```js
vcs.initialize('foo/bar')
```
<a name="module_vcs.clone"></a>
### vcs.clone(url, directory) ⇒ <code>Promise</code>
**Kind**: static method of <code>[vcs](#module_vcs)</code>  
**Summary**: Clone a git repository to a directory  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| url | <code>String</code> | repository url |
| directory | <code>String</code> | directory |

**Example**  
```js
vcs.clone('https://github.com/resin-io/resin-vcs.git', 'foo/bar')
```
<a name="module_vcs.associate"></a>
### vcs.associate(directory, url) ⇒ <code>Promise</code>
**Kind**: static method of <code>[vcs](#module_vcs)</code>  
**Summary**: Add a resin remote to a git repository  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| directory | <code>String</code> | directory |
| url | <code>String</code> | repository url |

**Example**  
```js
vcs.associate('foo/bar', 'jviotti@git.resin.io:jviotti/foobar.git')
```
<a name="module_vcs.getApplicationName"></a>
### vcs.getApplicationName(directory) ⇒ <code>Promise.&lt;(String\|undefined)&gt;</code>
**Kind**: static method of <code>[vcs](#module_vcs)</code>  
**Summary**: Get the associated application name from a repository  
**Returns**: <code>Promise.&lt;(String\|undefined)&gt;</code> - application name  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| directory | <code>String</code> | directory |

**Example**  
```js
vcs.getApplicationName('foo/bar').then (applicationName) ->
	if applicationName?
		console.log(applicationName)
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/resin-vcs/issues/new) on GitHub and the Resin.io team will be happy to help.

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

License
-------

The project is licensed under the Apache 2.0 license.
