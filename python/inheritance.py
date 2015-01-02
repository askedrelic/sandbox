#!/usr/bin/env python
# -*- coding: utf-8 -*-

class Base(object):
    def __init__(self):
        print "Base init"

class ChildA(Base):
    def __init__(self):
        print 'pre ChildA init'
        super(ChildA, self).__init__()
        print 'post ChildA init'

class ChildB(ChildA):
    def __init__(self):
        print 'pre ChildB init'
        super(ChildB, self).__init__()
        print 'post ChildB init'

print 'start'
print ChildA()
print
print ChildB()
print 'finish'

class BasePrivate(object):
    def __init__(self):
        print "Base init"

    def _private(self):
        print 'Base private'

class ChildA(BasePrivate):
    def __init__(self):
        print 'pre ChildA init'
        super(ChildA, self).__init__()
        print 'post ChildA init'

    def _private(self):
        print 'pre ChildA private'
        super(ChildA, self)._private()
        print 'post ChildA private'

class ChildB(BasePrivate):
    pass

class ChildC(BasePrivate):
    pass

print
print 'start 2'
print ChildA()._private()
print 'finish 2'
