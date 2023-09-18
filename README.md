[What is VSPG and how to use it?](_VSPG/VSPG-how-to-use.md)

Demo projects:

| Project name | Brief |
| ------------ | ----- |
| [simprint](demo-vsprojs/simprint/) | How to copy generated EXE to another directory. |
| [use-mc](demo-vsprojs/use-mc/) | Call mc.exe to compile multi-lang resources at start of project build. |
| [embed-svnrev](demo-vsprojs/embed-svnrev/) | Use `VSPU-Prebuild.bat` and `PreBuild-SubWCRev1.bat` to embed svn current revision number in C++ source code. |
| [TeamProps](demo-vsprojs/TeamProps/) | Use `VSPU.props` to export project property(MSBuild Property) so that they are available in .bat files. |

[Triggering files used by VSPG user.](_VSPG/samples/)

History:
* In 2023.09, VSPG version 600 introduces some backward-incompatible changes, and the demo projects are updated to use new v600 features.
* Since 2022.10, VSPG(version 512 and later) becomes a standalone git-repo hosted here.

Older historical changes is recorder in [another repo](https://github.com/chjfth/dailytools/tree/master/cmd-batch/vsproj-VSPG).
