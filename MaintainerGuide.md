# Maintainer Guide

## Adding new distributions

* In `build.sh`, edit all areas marked `# ADD NEW CODENAMES HERE`
* In `generate-files.sh`, edit all areas marked `# ADD NEW CODENAMES HERE`
* Remove everything in `README.md` after
  ```
  | Distribution | 2021may | 2023jan | stable | trunk |
  | ------------ | ------- | ------- | ------ | ----- |
  ```
* Run `ci-tests/generate-files.sh`
* 