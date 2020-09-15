![TabAhead](https://raw.github.com/janraasch/tab-ahead/master/app/images/icon-128.png)
Tab Ahead [![Pay me][paypal-svg]][paypal-dot-me] [![Sponsor me][github-sponsors-svg]][github-sponsors]
==============================
[![Build Status](https://travis-ci.org/janraasch/tab-ahead.svg?branch=master)](https://travis-ci.org/janraasch/tab-ahead) [![Coverage Status](https://img.shields.io/coveralls/janraasch/tab-ahead.svg)](https://coveralls.io/r/janraasch/tab-ahead?branch=master)

Lightweight [Chrome Extension](https://chrome.google.com/webstore/detail/tab-ahead/naoajjeoiblmpegfelhkapanmmaaghmi) that helps you to quickly find open tabs by title and url.

*Bringing Visual Studio Code's `Goto Anything...` to your Browser Tabs.*

Installation
------------

Go to the [Tab Ahead](https://chrome.google.com/webstore/detail/tab-ahead/naoajjeoiblmpegfelhkapanmmaaghmi) page on the [Chrome Web Store](https://chrome.google.com/webstore/) and click `Add To Chrome`.


Keyboard Shortcut
-------------------
* Press `Alt+T` to quickly open the search dialog.
* Go to [chrome://extensions](chrome://extensions) and click `Keyboard shortcuts`/`Configure Commands` to change or remove the default shortcut.

Options
---------
Choose whether to search in the context of the current window or over all (non-incognito) windows. Go to [chrome://extensions](chrome://extensions) and click the `Options` link next to the extension.

Sponsor 💟
----------

Support my work on this piece of open-source software via [GitHub Sponsors][github-sponsors] (recurring) or [PayPal][paypal-dot-me] (one-time).

[![GitHub Stats](https://github-readme-stats.vercel.app/api/?username=janraasch)][github-sponsors]


Version History
------------
* v1.3.1 - Initial release for FireFox. Previously this extension was only available on the Chrome browser. - **This is currently under review by the FireFox Team.**
* v1.3.0 - Improve fuzzy filter ([Fuse.js](http://kiro.me/projects/fuse.html)) and disable autocomplete on search input.
* v1.2.2 - Equal margins for search input field.
* v1.2.1 - Even faster popup response time.
* v1.2.0 - Faster popup opening by reducing css asset size by two thirds.
* v1.1.0 - Add option to search through all open windows.
* v1.0.9 - Update icons to match the popup's color scheme.
* v1.0.8 - New logo and popup icon. Fix #1.
* v1.0.7 - Fix bug where popup was not closed after selection.
* v1.0.6 - Improve build.
* v1.0.5 - Fix issue with popup sometimes not closing as expected.
* v1.0.4 - Fix UI glitch.
* v1.0.3 - Improve UI.
* v1.0.2 - Small improvements.
* v1.0.1 - Add [fuzzy](http://mattyork.github.io/fuzzy/) search.
* v1.0.0 - Initial release.


Special Thanks 🎁
------------
* [Fuse.js](http://kiro.me/projects/fuse.html) for the `fuzzy` filter.
* [Bootstrap](http://twitter.github.io/bootstrap/) for the `<input id="typeahead">` field.
* [Flatstrap](http://littlesparkvt.com/flatstrap/) for the lack of rounded corners and gradients.
* [Font Awesome](http://fortawesome.github.io/Font-Awesome/) for the logo, i.e. `icon-folder-close (&#xf07b;)` + `icon-terminal (&#xf120;)`.
* [Sublime Text](http://www.sublimetext.com/) for the inspiration i.e. `command+T/P` on OSX, `ctrl+P` on Linux and Windows.
* [Christian](http://ckapke.de/) for helping me out with the popup icon.

Alternatives
-------------
* [Quick Tabs](https://chrome.google.com/webstore/detail/quick-tabs/jnjfeinjfmenlddahdjdmgpbokiacbbb) *Feature-complete version of this. :)*
* [Tabbr](https://chrome.google.com/webstore/detail/tabbr/pnlmkddpdkjapnghefahkniilfnodcol) *They really took this idea and ran with it. Looks great! Loads more background processes going on though. :)*
* [Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb/) *If you're nerd enough, you're probably already running this anyway.*
* [TabJuggler](https://chrome.google.com/webstore/detail/tabjuggler/jgiplclhploodgnkcljjgddajfbmafmp/)
* [Tab Manager Plus](https://chrome.google.com/webstore/detail/tab-manager-plus-for-chro/cnkdjjdmfiffagllbiiilooaoofcoeff/)

Contributing
--------------
Pull requests and constructive issues are very welcome. In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [grunt](http://gruntjs.com/).

### Available Grunt Commands
* `grunt test` for linting and running tests.
* `grunt build` for building the extension and generating the dist `.zip`.
* `grunt` to get your development going. This will start a `watch` task running tests, whenever files are changed.

License
---------
Copyright (c) 2016 Jan Raasch

This project and its contents are open source under the MIT license.

[paypal-dot-me]: https://www.paypal.me/janraasch/14,00
[github-sponsors]: https://github.com/sponsors/janraasch
[paypal-svg]: https://img.shields.io/badge/onetime-donation-11dde2.svg?logo=paypal
[github-sponsors-svg]: https://img.shields.io/badge/recurring-sponsorship-ee4aaa.svg?logo=github
