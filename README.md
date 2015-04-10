# bash_blog
A simple blogging software mainly based on git/bash/sed/awk

This is my very own version of a blogging platform. With the exception
of the markdown parser it only uses bash/sed/awk. What you are reading
is the full documentation... But if you dare to use a bash/sed/awk blogging
plattform you will figure it out.

./local is a git cloned from remote

./remote is supposed to be stored somewhere remote (as a bare repo);)
- the configuration is in: remote/hooks/post-receive
- the magic is in: ./remote/bin
- ./remote/data/templates is a clone of ./remote (NEVER commit or push anything in here!)
- the templates are in: ./remote/data/templates
- the html output is in: ./remote/html

in ./remote/bin is file called "markdown" this is a binary file build
from ./markdown/markdown.go. You will probably need to re-compile
it for the platform remote lives on. Currently it is a Mac OS binary.
Do not hesitate to replace it with a bash/sed/awk only version of a
mardown parser. I simply do not have the time to implement one...

## Installation
1) create a remote bare repo and put all files from remote into the right place
2) set up the configuration in ./remote/hook/post-receive
3) clone ./remote into ./remote/data
4) clone ./remote to where ever you like to add content
5) somehow move the generated html to your webserver...
