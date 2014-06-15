# BundleCache on Dropbox

Utility for caching bundled gems on your Dropbox. Useful for speeding up Travis builds - 
it doesn't need to wait for `bundle install` to download/install all gems.

## Installation

Adding this to your Gemfile defeats the purpose. Instead, run

    $ gem install bundle_cache

## Usage

You'll need to set some environment variables to make this work.

```
DROPBOX_ACCESSTOKEN_=<your access token here>
BUNDLE_ARCHIVE=<the filename to use for your cache>
```

## Dropbox Accesstoken
Easy:
1. Login to your Dropbox Account
2. Go to https://www.dropbox.com/developers/apps
3. Create new App
4. Generate ACCESS_TOKEN
5. Notice for upcoming tasks.

## Travis configuration

Add these to your Travis configuration:
```
bundler_args: --without development --path=~/.bundle
before_install:
- "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
- git clone https://github.com/sprestel/bundle_cache.git
- cd bundle_cache && git checkout dropbox_sdk && gem build bundle_cache.gemspec
- gem install bundler bundle_cache*.gem
- bundle_cache_install
- cd ..
after_script:
- bundle_cache
env:
  global:
  - BUNDLE_ARCHIVE="your_project_bundle"
  - AWS_S3_BUCKET="your_bucket"
  - RAILS_ENV=test
```

You'll also want to add your DROPBOX accesstoken to a secure section in there:

1. Install the travis gem with gem install travis
2. Log into Travis with travis login --auto (from inside your project respository directory)
3. Encrypt your dropbox accesstoken with: travis encrypt DROPBOX_ACCESSTOKEN_="<<>YOUR TOKEN HERE>" --add (be sure to add your actual credentials inside the double quotes)


[Dropbox Docu](https://www.dropbox.com/developers/reference/devguide)

## Credits

Original code based on the [bundle_cache](https://github.com/data-axle/bundle_cache) gem,
originally by [DATA AXLE](https://github.com/data-axle)

Thank you to Data Axel and all of bundle_cache contributors!

## License
It is MIT licensed.
