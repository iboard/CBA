VERSION NOTE
============

**ATTENTION!** CBA's master branche (you are here) is for Rails 3.0.9 but development
moved on to branch [Rails3.1](https://github.com/iboard/CBA/tree/rails31)

CBA is running well on 3.1 but we have to adjust the installation-thor-task for 3.1.
Once this is done (should be within one or two weeks) CBA for 3.0.9 will be moved
into an extra branch and 'master' will become the Rails 3.1 branch.

For now, if you want to start a new CBA-Installation for 3.1 you should install from the master-branch first
and then checkout branch rails31.


CBA - Community Base Application Template
=========================================

* [Github](http://github.com/iboard/CBA)


Quickstart
-----------

```sh
   curl -o install_cba.rb https://github.com/iboard/CBA/raw/master/install.rb
   ruby install_cba.rb
```

This will install  a fully functional web-application, with user-authentication (incl. omniAuth) on a document oriented, non-SQL, MongoDB/MongoID database. Just ready to be extended by your 'real' application code. As a benefit, CBA will offer two MVCs `Page` and `Blog`.

*Note*: [Project's README](http://cba.iboard.cc/p/readme) *should be* identical to [README.md on Github](http://github.com/iboard/CBA/blob/master/README.md) -- I try hard to keep both versions in synchronized state, but check out the Github-version too.

What it is
----------
*CBA* is forked from [Rails3-Mongoid-Devise by fortuity](http://github.com/fortuity/rails3-mongoid-devise), extended by Andi Altendorfer with

* OmniAuth
* Paperclip
* CanCan
* jQuery

CBA's own implementations

* Models/MVC
  * User
  * Blog
  * Posting
  * Page
* Features: 
  * Comments and Attachments for all models
  * i18n enabled (en/de)
  * installation.rb (See: [Posting](http://cba.iboard.cc/blogs/4d456adae7798923b100000a/postings/4d64c604e779892bbf00001d))
  * Configuration in application.yml

More about installation
-----------------------

  * See: [Posting 'installation.rb'](http://cba.iboard.cc/blogs/4d456adae7798923b100000a/postings/4d53bb27e779893dd0000007)
  * CBA is in heavy development age, so please read [CBA Blog](http://cba.iboard.cc) from bottom to top. There are some latest news, not mentioned in this README.

Layout and Templates
--------------------

  * Edit cba.css or 'your_name_given_at_install'.css
  * Edit views/layout/application.html or views/layout/'your_name_given_at_install'.html.erb
  * Read [Posting](http://cba.iboard.cc/blogs/4d456adae7798923b100000a/postings/4dbebb9adaf9853b3000001a)
  * Visit [Demo Page](http://cba.iboard.cc/p/pagecomponent_and_pagetemplat$)


Tasks
=====

Delayed Jobs
------------

There is a rake-task to start the background jobs

````sh
  rake delayed_jobs:work
```

Unfortunatley [DelayedJobs by 'tobi'](http://github.com/tobi/delayed_job) doesn't work with _MongoId_.
So I did this my own way. To define new background-workers follow this steps:

1 Define a worker in `app/workers` (See [new_sign_up_notifier.rb](http://github.com/iboard/CBA/tree/master/app/workers for example))
2 Enqueue new Jobs like shown in `app/model/user.rb`, method `async_notify_on_creation` ([Source](http://gist.github.com/841907))

Resources
=========

'Page'
------

Since nearly any website needs some kind of 'semi-static pages' and we need some kind of object to test the application, there is a resource Page with the following features

   * Consists of a title and a body
   * The body is rendered with _RedCloth_
   * The MongoId of `/page/MONGO_ID` in the browser-address will be replaced by `/p/title_of_the_page` with JS.

Testing
=======

Spork
-----

To run autotests you have to start the spork-server and then run autotest command

  1. `AUTOFEATURE=true bundle exec spark`
  2. `AUTOFEATURE=true bundle exec autotest`

To run your unit-tests using spork do

  1. `bundle exec spork TestUnit --port 8988`
  2. `testdrb -I test test/unit/*rb`

Start all at once with thor-task
--------------------------

You can use `thor application:run_autotests` to start the spork-server and autotest. The shortest way to jump into *continuos testing* 



License
=======

See: [Freedom](http://cba.iboard.cc/p/freedom)

Links
=====

See: [Link-page](http://cba.iboard.cc/p/links)

