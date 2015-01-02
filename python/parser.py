#!/usr/bin/env python2
from string import digits

def number(s, start):
    token = ''
    for i, c in enumerate(s[start:]):
        if c not in digits:
            break
        else:
            token += c
    return int(token), start + i

def string(s, start):
    token = '"'
    start += 1
    for i, c in enumerate(s[start:]):
        previous = s[start + i - 1]
        if previous == '\\':
            token += c
        elif c == '\\':
            continue
        elif c == '"':
            break
        else:
            token += c
    return token + '"', start + i

def symbol(s, start):
    token = ''
    for i, c in enumerate(s[start:]):
        previous = s[start + i - 1]
        if previous == '\\':
            token += c
        elif c == '\\':
            continue
        elif c == '.':
            break
        else:
            token += c
    return token, start + i

def parse(s):
    T, i = [], 0
    while i < len(s):
        if s[i] in digits:
            token, i = number(s, i)
        elif s[i] == '"':
            token, i = string(s, i)
        else:
            token, i = symbol(s, i)
        T.append(token)
        i += 1
    return [token for token in T if token]

print parse('foo."\\"bar.qweqwez\\"".baz.5.4."7"..baz.file\.txt."asff')
