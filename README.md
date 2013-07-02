# BundleCache

Utility for caching bundled gems on S3. Useful for speeding up Travis builds - 
it doesn't need to wait for `bundle install` to download/install all gems.

## Installation

Adding this to your Gemfile defeats the purpose. Instead, run

    $ gem install bundle_cache

## Usage

You'll need to set some environment variables to make this work.

AWS_S3_KEY=<your aws access key>
AWS_S3_SECRET=<your aws secret>
AWS_S3_BUCKET=<your bucket name>
BUNDLE_ARCHIVE=<the filename to use for your cache>

## License

This code was originally written by Matias Korhonen and is available at 
http://randomerrata.com/post/45827813818/travis-s3. It is MIT licensed.
