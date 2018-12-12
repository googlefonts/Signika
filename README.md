# Signika
Making a variable version of Signika, from Google Fonts

![Signika VF](https://github.com/thundernixon/Signika/blob/f3ae1a5bee3735feb7f69db54833175cbb658134/dist/Signika-MM-VF-2018-10-16-16_01/signika-VF%202018-10-16%20at%2015.41.36.gif)


# Build Process

The sources can be built with FontMake, but I've put together some specific build scripts to pass the fonts through some steps that fix metadata issues.

## Step 1: Install Requirements

To operate the scripts within this repo, install requirements with:

```
pip install -r sources/scripts/requirements.txt
```

(Caveat: this installs all Python 3 dependencies I've installed for Google Fonts work. I know this is messy – next time, I'll set up a virtual environment for each project. I hope to circle back in the future and make this requirements file cleaner. If you wish to install fewer requirements, you could alternatively install requirements when/if you run into errors.)

## Step 2: Give permissions to build scripts

The first time you run the build, you will need to give run permissions to the build scripts.

On the command line, navigate to the project folder (`cd Encode-Sans`), and then give permissions to the shell scripts with:

```
chmod -R +x sources/scripts
```

The `-R` applies your permission to each of the shell scripts in the directory, and the `+x` adds execute permissions. Before you do this for shell scripts, you should probably take a look through their contents, to be sure they aren't doing anything bad. The ones in this repo simply build from the Encode Sans GlyphsApp sources.

## Step 3: Run the build scripts!

You can then build sources by running shell scripts in `sources/scripts/`.

Build the full variable font (Weight + "Negative" axes) with:

```
sources/scripts/build-full.sh
```

Build the split variable font with (just Weight axis for "normal" version):

```
sources/scripts/build-split.sh
```

Build all static instances with:

```
sources/scripts/build-statics.sh
```

# Variable font upgrade project documentation

Notes were taken throughout the variable font upgrade project and added to the [docs](/docs) directory. I tend to take notes while working anyway, in order to think through problems and record solutions for later reference. In this project, I have included these in the repo so that others might find references to solve similar problems, especially because variable font-making processes are relatively new, and there is a general scarcity of online knowledge on font mastering. Because they were often made alongside work, the notes can at times be a bit disjointed. Hopefully they are still helpful to others! 

If you have any questions about the project or the notes, feel free to [file an issue](/issues) or to reach out to Stephen Nixon via Twitter ([@thundernixon](https://twitter.com/thundernixon)) or other social media (typically also @thundernixon).