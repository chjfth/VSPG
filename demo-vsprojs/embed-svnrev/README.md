This demo project shows how we can use Subversion's bundled program `SubWCRev.exe` to embed 
svn revision number into an C++ source file, of course, in VSPG way.

It runs like this:

![vs2019-build-and-run.png](doc/vs2019-build-and-run.png)

On compile success, we see that `svnrev.cpp` has a single line of code:

```
int g_svnrev=8;
```

Although `svnrev.cpp` is added to vcxproj to be compiled into final EXE, `svnrev.cpp` is actually 
not in the svn-repo. In other word, when a user first checks out this project, `svnrev.cpp` does NOT exist.

Then how does VSIDE compile `svnrev.cpp`? The answer is, it is created on the fly when we hit F7 hotkey(Build). 

We have `VSPU-Prebuild.bat`, and this .bat is executed before VSIDE(MSBuild) does any .cpp -> .obj compiling.

In `VSPU-Prebuild.bat`, it in turn calls `PreBuild-SubWCRev.bat`, which does the actual work, 
executing the following command.

```
SubWCRev.exe "D:\gitw\VSPG\demo-vsprojs\embed-svnrev" "D:\gitw\VSPG\demo-vsprojs\embed-svnrev\svnrev.cpp.template" "D:\gitw\VSPG\demo-vsprojs\embed-svnrev\svnrev.cpp"
```
(The actual file path on your machine may vary, but you should get the idea.)

That is, svn related macro references in `svnrev.cpp.template` is replaced with actual values, and the result is a newly created file `svnrev.cpp`.

To be concrete, `svnrev.cpp.template` has content:

```
int g_svnrev=$WCREV$;
```

So the resulting `svnrev.cpp` is something like:

```
int g_svnrev=8;
```

The \<SrcVersionFile\> and \<DstVersionFile\> passed to `SubWCRev.exe` is not hardcoded in 
`PreBuild-SubWCRev.bat`, instead, they are recorded in `SubWCRev.csv` to ease adding/modifying 
new file pairs, one pair per line, so `PreBuild-SubWCRev.bat` becomes generic.

Q: In this example, `VSPU-Prebuild.bat` does nothing but merely calls `PreBuild-SubWCRev.bat`, then why 
don't we move all content of `PreBuild-SubWCRev.bat` into `VSPU-Prebuild.bat` thus maintain 
one less file?

A: Yes, you can do that. But, keeping a standalone `PreBuild-SubWCRev.bat` give us flexibility.
Suppose we have many Subversion sandbox directories and all of them needs calling SubWCRev.exe,
then, we can maintain a single `PreBuild-SubWCRev.bat` and have many `VSPU-Prebuild.bat` calls 
it. Once we need to improve `PreBuild-SubWCRev.bat`(fixing bug etc), we need to modify only one file.
