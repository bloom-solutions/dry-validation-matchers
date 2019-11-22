# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.2.1] - 2019-11-22
### Fixed
- Deprecation messages re BigDecimal()

## [1.2.0] - 2019-11-17
### Added
- Add support for checking that the macro is used through the method `macro_use?`
- Updated gem dependency `"dry-validation", "~> 1.3"`

## [1.1.1] - 2019-04-10
### Fixed
- when `min_size` is set to 1 (and 0 in tests)

## [1.1.0] - 2019-04-10
### Added
- `min_size` validation

## [1.0.0] - 2019-04-04
### Added
- Remove (I know, under "added") activesupport requirement
- Add `max_size` validation

## [0.4.2] - 2018-08-23
### Fixed
- [Fix false positive on value(included_in:) matcher](https://github.com/bloom-solutions/dry-validation-matchers/pull/10)

## [0.4.1] - 2018-06-01
### Fixed
- [Fix date_time type error message](https://github.com/bloom-solutions/dry-validation-matchers/pull/9)
- [Fix false positive checks missmatch between type check and other checks](https://github.com/bloom-solutions/dry-validation-matchers/pull/9)
- [Fix gemspec dependencies context](https://github.com/bloom-solutions/dry-validation-matchers/pull/8)
- [Fix warning on `@check_filled`](https://github.com/bloom-solutions/dry-validation-matchers/pull/7)
- Description messages for pass and fail do not leave artifacts if there are no details
- Make messages consistent with "Subject predicate noun"

## [0.4.0] - 2016-11-10
### Added
- Add support for checking that the value is included_in

## [0.3.0] - 2016-11-09
### Added
- Add support for float, decimal, bool, date, time, date_time, array, hash

## [0.2.0] - 2016-11-08
### Added
- failure_message

### Fixed
- Updated description

## [0.1.0] - 2016-11-08
### Added
- Initial working version
