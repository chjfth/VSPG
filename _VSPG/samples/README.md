## Summary

In this directory, we have some sample .bat files that will be invoked by VSPG framework 
at some points, and we call such a bat file "triggering bat (file)".

For example, if `VSPU-CopyOrClean.bat` exists in the directory of a .vcxproj, then 
`VSPU-CopyOrClean.bat` will be called,

- in **Postbuild** stage of the project-build(typically, after the EXE file is generated), and
- in **Clean** stage (when we tell VSIDE to clean our project).

That filename implies that VSPG framework expects "copy" and/or "clean" behavior in `VSPU-CopyOrClean.bat`. 
If you try to write batch statements to achieve these goals reliably, you'll find it harder than first imagined.

Luckily, in this "copy-or-clean" case, we don't have to write those batch statements ourselves, 
VSPG framework has most code for doing this. Just grab a copy of `VSPU-CopyOrClean.bat.sample`, 
put it into our own vcxproj directory, and rename it to `VSPU-CopyOrClean.bat`, then edit the 
.bat to meet our actually directory, filename list, filepath list etc.

`VSPU-CopyOrClean.bat.sample` has a `.sample` suffix, because it wants to imply that, 
its user needs to make some modification to its content before it can be put into actual use. 

[VSPU-CopyOrClean.bat.md](VSPU-CopyOrClean.bat.md) talks about how we should modify it.

The above rules apply to other `.sample` files in this directory.

## Where to place these sample files(after deleting `.sample` extension)

There are several directories(folders) VSPG framework will search for(revealed in `VSPG-StartBat.bat`, 
batch var `SubbatSearchDirsNarrowToWide`):

| .bat code | meaning |
| --------- | ------- |
| %vspg_USER_BAT_SEARCH_DIRS% | User-defined directory listing. User can define it in `VSPU-StartEnv.bat` triggering file. |
| %ProjectDir%              | The .vcxproj directory. |
| %ProjectDir%\\_VSPG        | The `_VSPG` subdir in the .vcxproj directory. |
| %VSPG_StartDir%           | VSPG framework's directory, precisely, the parent dir of `_VSPG.props`. |

The above search order is considered narrow-to-wide, it is used for `VSPU-Postbuild.bat` and copy-phase of `VSPU-CopyOrClean.bat`.

The reverse of the above is considered wide-to-narrow, it is used for `VSPU-PreBuild.bat` and clean-phase of `VSPU-CopyOrClean.bat`.


## Sample list

| Sample file | Used for ... |
| ----------- | ------------ |
| VSPU-StartEnv.bat.sample | VSPU-StartEnv.bat |
| [VSPU-CopyOrClean.bat.sample](VSPU-CopyOrClean.bat.md) | VSPU-CopyOrClean.bat |
| [VSPU-Postbuild.bat.sample](VSPU-Postbuild.bat.md) | VSPU-Prebuild.bat <br/>VSPU-Postbuild.bat |
| vspg_functions.bat.sample |  Some useful functions for batch script, not to be used as a standalone .bat . |

