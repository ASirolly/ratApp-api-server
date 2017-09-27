# ratApp-api-server
API Server for GT-CS2340 Fall 2017's NY Rat Tracking App

## Before Diving into the code...
### Setup
Ruby is the programming language I chose to use for our api. I'm currently using version 2.3.5, make sure you install this version or later.

To install ruby, I recommend using RVM, or ruby version manager. It makes updating, changing versions, and reinstalling super easily. RVM, however, is a pain to setup on windows machines (or it was the last time I had to do it).

---------------------------------------
Install instructions can be found [HERE](https://rvm.io/rvm/install "RVM install guide")

`note: The last time I installed rvm was a LONG time ago, these are just guides that looked promising - I have not personally followed through any of them`
---------------------------------------
After installing RVM
- restart your terminal
- enter the following commands:
```rvm install 2.3.5
rvm --default use 2.3.5```
- Verify you are actually using the right version with
```ruby --version```
- Now we will install 'Bundler' a very useful gem for managing dependencies
```gem install bundler```
- And now you should be able to install all of the dependencies for this application
```bundle install```

## Running the app
Now that you have the setup out of the way, you should be able to run the command below to start up your application server

```rackup```

If you haven't gotten any errors in the command line, you should be able to go to your browser and navigate to: `http://localhost:9292/api/hello_world` and see a hello world response!

Congrats, you've setup a pretty standard development environment and project for a ruby programmer


### What's actually happening
I would recommend reading up on this stuff on your own, as I am fallable and paraphrasing for the sake of time... but heres a quick explination to get you started

1. A client will make a request to our server. In our case the client is our android app and our server will be hosted in the cloud somewhere (in a virtual machine on someone else's computer). 

2. Some irrelevent magic that speeds up request speed happens, the request gets formatted by the web server we're using and then hits our application server (our class that inherits from Grape::API)

3.  Our application server routes things to there appropriate controllers.

4. Our controllers interact with our models (We are using mongoid to interface with our database) and then give a response

5. The client (android) recieves the response


for more detail about rack applications, check out [this article](https://www.rubyraptor.org/how-we-made-raptor-up-to-4x-faster-than-unicorn-and-up-to-2x-faster-than-puma-torquebox/).
