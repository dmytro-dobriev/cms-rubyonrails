# CMS™

__An open source content management system for Rails 5.1+__


You can chat with us using Gitter:


You can deploy an example app to Heroku:

## Requirements

* [Bundler](http://gembundler.com)
* [ImageMagick](http://www.imagemagick.org/script/install-source.php)
  * :warning: Warning: ImageMagick currently has a serious security vulnerability, CVE-2016–3714. After installing, you must disable certain features in ImageMagick's policy configuration. Please see the following for details:
    * https://imagetragick.com/
  * Mac OS X users should use [homebrew's](https://github.com/mxcl/homebrew/wiki/installation) `brew install imagemagick` or the [magick-installer](https://github.com/maddox/magick-installer).

## How to

* [Contribute to CMS™](readme.md#contributing)

## Getting Started

You can also install the `edge` version for the latest code using this template:


## What's it good at?

__Refinery is great for sites where the client needs to be able to update their website themselves__ without being bombarded with anything too complicated.

Unlike other content managers, Refinery is truly __aimed at the end user__ making it easy for them to pick up and make changes themselves.

### For developers

* Easily customise the look to suit the business.
* __Extend with custom extensions__ to do anything Refinery doesn't do out of the box.
* Sticks to __"the Rails way"__ as much as possible; we don't force you to learn new templating languages.
* Uses [jQuery](http://jquery.com/) for fast and concise Javascript.

## Help and Documentation


## Features

### Pages

* Easily edit and manage pages with a visual editor.
* Manage your site's structure.

### Images & Files

* Easily upload and insert images.
* Upload and link to resources such as PDF documents.
* Uses the popular [Dragonfly](https://github.com/markevans/dragonfly).
* Supports storage on Amazon S3.

### Authentication & Users

* Manage who can access Refinery.
* Control which extensions each user has access to.
* Uses the popular [Devise](https://github.com/plataformatec/devise).

### Custom Extensions

Extend Refinery easily by running the Refinery extension generator.
For help run the command without any options:

    rails generate refinery:engine

### Popular Extensions


### Example Site Showcase


## Contributing

See [contributing.md](contributing.md)
guide for details about contributing and running test.

## License

Refinery CMS™ is released under the MIT license. See the [license.md file](license.md#readme) for details.

### Credits

Many of the icons used in Refinery CMS™ are from the wonderful [Silk library by Mark James](http://www.famfamfam.com/lab/icons/silk/).
