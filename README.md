Pollamatia
==========

This is a very simple Sinatra app to track who has reviewed some code on Github.
All it does is copy a git commit log into a database and allow you to '+1' a commit.

Your colleagues can then avoid reviewing the same code.


Setup
-----

First create and edit your config:

$ cp config/config.rb.example config/config.rb
$ nano config/config.rb

Create users:

$ irb
$ > require './models/boot.rb'
$ > User.create(name: 'bob')
$ > User.create(name: 'jim')
$ > User.create(name: 'jiminybob')


Get needed libraries:

$ gem install bundler
$ bundle


Syncing 
-------

You need to run the git log copier regularly, to update the commit list:

$ bundle exec ./git.rb

Before that is run, you'll need to have a git repo checked out and possibly also synced with a remote repo:
(WARNING, this will remove any local changes in this repo)

$ cd repo/to/watch
$ git fetch origin && git reset --hard origin/master && git clean -f -d

You could run those command every 5 minutes using crontab. We have Jenkins syncing the repo,
so we just run the ./git.rb.


Usage
-----

1. Load up the page in your browser:
> http://localhost:4567

2. Choose your name in the select list

3. Click on a commit and review it

4. Come back and '+1' the commit


Planned improvements
--------------------

1. I'd like to have a comments box in Pollamatia, and email those comments to the committer. I think that's 
better than having the comment go to all subscribers, like what happens on Github right now.


Finally
-------

Comments/Suggestions/Improvements welcome!

Leslie Viljoen, 7 March 2014

