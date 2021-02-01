# Note: ECFA 2021

This theme supports ECFA 2021 as of Feb 1! Use ECFA mode to enter the event. For any bugs or discrepancies with the official score spreadsheet, please open an issue in this repo or ping Sereni.

# Simply Love Vertical (StepMania 5)

![Arrow Logo](https://i.imgur.com/oZmxyGo.png)
======================

Simply Love Vertical is a Stepmania theme designed for single-player setups with monitors in portrait mode. Turning the monitor sideways increases the arrow scrolling space by 1.7x, meaning that a 23" monitor gains as much vertical play area as a 39" monitor.

![main-screen](https://user-images.githubusercontent.com/4284741/80278102-83821b80-86eb-11ea-81f6-b64b177926d9.jpg)
![gameplay screens](https://user-images.githubusercontent.com/4284741/90311356-fe1cb400-def1-11ea-918b-03b21fab77c0.png)

## Setup

This theme is based on [quietly-turning's Simply-Love-SM5](https://github.com/quietly-turning/Simply-Love-SM5) and the readme assumes you are familiar with it. If not, check out the original repo.

To install:
1. Download/clone the repository
1. Add the contents to your Themes/ folder
1. Switch to the theme in Stepmania options
1. In Graphics/Sound options, select the correct aspect ratio and display resolution. Stepmania may need to be restarted for changes to take effect.
1. If there is no correct option, open your Preferences.ini file, find the following lines and set them to your monitor specs (example values for 1080p below). If you skip this step, Stepmania will not recognize the portrait orientation of the monitor, and everything will look off.
    * `DisplayAspectRatio=0.562500`
    * `DisplayHeight=1920`
    * There's also a `DisplayWidth` setting, but it will be ignored


## Limitations compared to Simply Love

- Only single player is supported
- Casual mode is not available
- Edit mode is not functional
- Data visualizations and target score graph are not available
- Other features are up to Simply Love 4.9

## Additional features

- Custom Score support for intergration with Simply Training, from the Simply Love beta branch
- NPS graph is always displayed during music selection
- Ability to change global offset for the duration of a single set (via player options)
- Do Not Judge Me: a mode where most result-related things are hidden (via player options)
- Song Search: Use Down + Start on the song wheel to search for a song by name

## Known issues

See the Issues tab. Most things should work. Bug reports and fixes are welcome!

## Thanks
- Pluto for "what if we turned it sideways?"
- Fieoner for relentless feature work and code reviews
- Roujo for handling World's Biggest Merge, testing, and feedback
- hurtpiggypig, quietly-turning, and all contributors to Simply Love
