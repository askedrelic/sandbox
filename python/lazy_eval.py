#! /usr/bin/env python

def lazy(fn):
    def new(*args):
        ret = lambda *blargs : fn(*args)
        ret.__name__ = "lazy-" + fn.__name__
        return ret
    return new


def hello(x,y):
    print "hello"
    return x + y

@lazy
def hello_lazy(x,y):
    print "hello lazy"
    return x + y

