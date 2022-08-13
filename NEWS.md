# valid 0.0.0.9010 (2022-08-13)

Storage

- Added `valid_storage_local()`
- Modified `valid_remote_storage()`: renamed to `valid_storage_remote()`
- Added `valid_storage()`

----------

# valid 0.0.0.9009 (2022-08-13)

Remote storage

- Added `valid_remote_storage()`

----------

# valid 0.0.0.9008 (2022-08-09)

Reset

- Added `valid_keep_reset()`
- Added `valid_keep_reset_again_exit()`

----------
# valid 0.0.0.9008 (2022-05-02)

Better messages for invalid choices

- Added `handle_message()`
- `handle_message()` is used in `valid()` in case of invalid choices

----------

# valid 0.0.0.9007 (2022-04-30)

is_valid

- Added `is_valid()`

----------

# valid 0.0.0.9006 (2022-04-21)

valid2

- Added `valid2()`
- Refactored internal case logic in `valid()`. Might hurt performance a bit but I feel more comfortable with "less guessing"
- New Case logic handling depends on two new functions:
    - `handle_choice_type()`
    - `handle_valid_invalid()`

----------

# valid 0.0.0.9005 (2022-04-19)

Unname

- Added argument to `valid()`: `unname` 
- Cleaned up roygen code
- Updated `README.Rmd`

----------

# valid 0.0.0.9004

DevOps environments, reverse, README

- Added `valid_devops_envs()`

----------

# valid 0.0.0.9003

Updated README and new built-in functions

----------

# valid 0.0.0.9002

Changes not recorded

----------

# valid 0.0.0.9001

Renaming

- Renamed `valid_generic_()` to `valid()`
- Added `test-flip.R`
- Refactored `README`

----------

# valid 0.0.0.9000

Initial commit

- Added a `NEWS.md` file to track changes to the package.
- Added `valid_generic_()`
- Added unit tests
- Fleshed out initial state of `README`
