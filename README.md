# Sublime-SassC

This package provides the `sassc` binary for Sublime Text (2 and 3) packages. The path of the binary is Python-importable.

## Usage

```python
import sass
from subprocess import PIPE, Popen

p = Popen([sass.path, "--help"], stdout=PIPE, stderr=PIPE)
print(p.communicate()[0]) # possible race condition, but eh...
```

## Building

Build scripts will eventually be added for all systems. I will try my best to update the 64-bit binaries at the start of each month. However, feel free to send PRs at any time. I will merge and update the tag.

To build, please use a recent release of glibc. If you are stuck on an old system (RHL/CentOS <7), I'd be happy to receive a PR with a `loader.py` file that chooses between multiple `sassc`s.
