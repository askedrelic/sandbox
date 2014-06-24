#!/usr/bin/env python
# -*- coding: utf-8 -*-

class Base(object):
    def __init__(self):
        print "Base init"

class ChildA(Base):
    def __init__(self):
        print 'pre a init'
        super(ChildA, self).__init__()
        print 'post a init'

class ChildB(ChildA):
    def __init__(self):
        print 'pre b init'
        super(ChildB, self).__init__()
        print 'post b init'

print ChildA()
print
print ChildB()
