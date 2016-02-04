# Sublime-SassC

This package provides the `sassc` binary for Sublime Text (2 and 3) packages. The path of the binary is Python-importable.

## Usage

```python
import sass
from subprocess import PIPE, Popen

p = Popen([sass.path, "--help"], stdout=PIPE, stderr=PIPE)
print(p.communicate()[0])
```

## Building

Linux/Darwin builds require git, gcc, and perl. Cross-compile to 32-bit by passing the `-m32` flag. The latest release is automatically computed.

Windows builds require VS2013+ and git. For Windows, manually update the version in `build.bat`. The checked-in version works with the newest MSYS2/git installed from the official site. Older versions or versions installed with VS may require some fiddling with the path, but please leave the batch file changes uncommitted.

I will try my best to update the binaries at the start of each month. However, feel free to send PRs at any time. I will merge and update the tag.

To build, please use a recent release of glibc. If you are stuck on an old system (RHL/CentOS <7), I'd be happy to receive a PR with a `loader.py` file that chooses between multiple `sassc`s.
