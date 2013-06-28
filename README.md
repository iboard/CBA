CBA - Community Base Application Template
=============================

Juni 28, 2013 - Extracted secret-token from
`config/initializers/application.rb` to the file
`config/inititalizers/_secret.token` which is not included in the
repository.

If you use this project after June 28th, 2013 please create the
token-file with your own secret.


* [At Github](http://github.com/iboard/CBA)

**Issues**

Known issues maintained in [Github-Issues](https://github.com/iboard/CBA/issues)

**Quickstart**

I highly recommend you use [RVM](https://rvm.beginrescueend.com/)!

Requirements for CBA:

  * A running MongoDB Server
  * A rvm gemset for Ruby 1.9.2-p290 with Rails 3.2.2
  
**This README is a bit outdated**

This README needs to be reviewed. If something will not work as documented here, don't hesitate to contact me at @nickendell or andreas@altendorfer.at


```sh
   curl -o install_cba.rb \
   https://raw.github.com/iboard/CBA/master/install.rb
   ruby install_cba.rb
```

This will install  a fully functional web-application, with user-authentication (incl. omniAuth) on a document oriented, non-SQL, MongoDB/MongoID database. Just ready to be extended by your 'real' application code. As a benefit, CBA will offer two MVCs `Page` and `Blog`.

*Note*: [Project's README](http://cba.iboard.cc/p/readme) *should be* identical to [README.textile on Github](http://github.com/iboard/CBA/blob/master/README.textile) -- I try hard to keep both versions in synchronized state, but check out the Github-version too.

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

Installation
---------

  * See: [Posting 'installation.rb'](http://cba.iboard.cc/blogs/4d456adae7798923b100000a/postings/4d53bb27e779893dd0000007)
  * CBA is in heavy development age, so please read [CBA Blog](http://cba.iboard.cc) from bottom to top. There are some latest news, not mentioned in this README.


Delayed Jobs
----------

There is a rake-task to start the background jobs

````sh
  rake delayed_jobs:work
```

Unfortunatley [DelayedJobs by 'tobi'](http://github.com/tobi/delayed_job) doesn't work with _MongoId_.
So I did this my own way. To define new background-workers follow this steps:

1 Define a worker in `app/workers` (See [new_sign_up_notifier.rb](http://github.com/iboard/CBA/tree/master/app/workers for example))
2 Enqueue new Jobs like shown in `app/model/user.rb`, method `async_notify_on_creation` ([Source](http://gist.github.com/841907))

Resource 'Page'
------------

Since nearly any website needs some kind of 'semi-static pages' and we need some kind of object to test the application, there is a resource Page with the following features

   * Consists of a title and a body
   * The body is rendered with _RedCloth_
   * The MongoId of `/page/MONGO_ID` in the browser-address will be replaced by `/p/title_of_the_page` with JS.

Testing with Spork
----------------

To run autotests you have to start the spork-server and then run autotest command

  1. `AUTOFEATURE=true bundle exec spark`
  2. `AUTOFEATURE=true bundle exec autotest`

To run your unit-tests using spork do

  1. `bundle exec spork TestUnit --port 8988`
  2. `testdrb -I test test/unit/*rb`

Start all at once with thor-task
--------------------------

You can use `thor application:run_autotests` to start the spork-server and autotest. The shortest way to jump into *continuos testing* 

Layout and Templates
-------------------

  * Edit application.css or 'your_name_given_at_install'.css
  * Edit views/layout/application.html or views/layout/'your_name_given_at_install'.html.erb
  * Read [Posting](http://cba.iboard.cc/postings/4dbebb9adaf9853b3000001a)
  * Visit [Demo Page](http://cba.iboard.cc/p/pagecomponent_and_pagetemplat$)


License
------

See: [Freedom](http://cba.iboard.cc/p/freedom)

Links
----

See: [Link-page](http://cba.iboard.cc/p/links)
