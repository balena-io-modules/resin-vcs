# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [2.0.2] - 2015-12-04

### Changed

- Omit tests in NPM package.

## [2.0.1] - 2015-09-25

### Changed

- Throw an error if directory is not a git directory for some commands that rely on this assumption.

## [2.0.0] - 2015-06-25

### Added

- Promises support.

### Removed

- Remove `vcs.isRepository()`.
- Remove `vcs.getRemote()`.
- Remove `vcs.getApplicationId()`.

### Changed

- Rename `vcs.addRemote()` to `vcs.associate()`.
- Improve documentation.

## [1.2.0] - 2015-04-20

### Added

- Implement `vcs.getApplicationName()`.

## [1.1.0] - 2015-03-19

### Added

- Make use of [resin-errors](https://github.com/resin-io/resin-errors).

[2.0.2]: https://github.com/resin-io/resin-vcs/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/resin-io/resin-vcs/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/resin-io/resin-vcs/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/resin-io/resin-vcs/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/resin-io/resin-vcs/compare/v1.0.0...v1.1.0
