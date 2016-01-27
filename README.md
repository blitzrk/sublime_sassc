# Sublime-SassC

This package provides the `sassc` binary for Sublime Text (2 and 3) packages. [PackageControl](https://packagecontrol.io/) will automatically put the directory containing the binary in Python's `sys.path`.

## Building

Build scripts will eventually be added for all systems. I will try my best to update the binaries at the start of each month. However, feel free to send PRs at any time. I will merge and update the tag.

To build, please use a recent release of glibc. If you are stuck on an old system (RHL/CentOS <7), I'd be happy to receive a PR with a `loader.code` file that chooses between multiple `sassc`s.

### Dependencies

The helper build script requires `perl`.
