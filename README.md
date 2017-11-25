A Simple Insecure Website

This is designed to support the "Why learning a bit of crypto is good for you"
given at LPW 2017 (http://act.yapc.eu/lpw2017/).

Slides for the talk are here,

https://docs.google.com/presentation/d/1ZsLIhgyNRPmHc_g5_xQDSilZeL8c3Tqj3oRzRwRlxxQ/edit?usp=sharing

This is a simple Dancer2 app.

    cpanm --installdeps .
    plackup -I lib bin/app.psgi
