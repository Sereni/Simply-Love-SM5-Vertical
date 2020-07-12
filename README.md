# Simply Love Vertical (StepMania 5)

![Arrow Logo](https://i.imgur.com/oZmxyGo.png)
======================

Simply Love Vertical is a Stepmania theme designed for single-player setups with monitors in portrait mode. Turning the monitor sideways increases the arrow scrolling space by 1.7x, meaning that a 23" monitor gains as much vertical play area as a 39" monitor.

![main-screen](https://user-images.githubusercontent.com/4284741/80278102-83821b80-86eb-11ea-81f6-b64b177926d9.jpg)

## Setup

This theme is based on [quietly-turning's Simply-Love-SM5](https://github.com/quietly-turning/Simply-Love-SM5) and the readme assumes you are familiar with it. If not, check out the original repo.

The theme is currently in alpha, and does not have released versions. To install:
1. Download/clone the repository
1. Add the contents to your Themes/ folder
1. In your Preferences.ini file, find the following lines and set them to your monitor specs (example values for 1080p below). If you skip this step, Stepmania will not recognize the portrait orientation of the monitor, and everything will look off.
    * `DisplayAspectRatio=0.562500`
    * `DisplayHeight=1920`
    * There's also a `DisplayWidth` setting, but it will be ignored
1. Switch to the theme in Stepmania options

## Limitations compared to Simply Love

- Only single player is supported
- Only ITG/FA+ modes are available
- Edit mode is not functional
- Data visualizations and target score graph are not avialable
- Other features are up to Simply Love 4.8.7

## Additional features

- NPS graph is always displayed during music selection
- Ability to change global offset for the duration of a single set (via player options)
- Do Not Judge Me: a mode where most result-related things are hidden (via player options)

## Known issues

We are actively developing this very much unfinished theme. Check the Issues tab for known issues. New issue reports and PRs are welcome!

## Thanks
- Pluto for "what if we turned it sideways?"
- Fieoner for relentless feature work and code reviews
- Roujo for handling World's Biggest Merge, testing, and feedback
- hurtpiggypig, quietly-turning, and all contributors to Simply Love
