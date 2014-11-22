docker-gerrit
=============

Build a Docker container with the gerrit code review system. This version
is currenty configured with no security (aka: auth.type=DEVELOPMENT_BECOME_ANY_ACCOUNT)
for intial testing purposes.

Built on top of Ubuntu Trusty (14.04) and gerrit 2.9.1

    $ docker pull jcibe/docker-gerrit
    $ docker run --name gerrit -p 0.0.0.0:8080:8080 -p 0.0.0.0:29418:29418 -d jcibe/docker-gerrit

