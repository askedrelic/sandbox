#!/usr/bin/env python
# coding=utf8
# Code from http://eli.thegreenplace.net/2013/06/25/regex-based-lexical-analysis-in-python-and-javascript/

text = """
For our time off together around Christmas, my siblings, their children and I recently began plotting an excursion to the Six Flags amusement park in the Los Angeles area. The discussion turned quickly from roller coasters to perks. To status. To just how high we’re prepared to fly in this service-obsessed, luxury-laden, class-fractured era of ours.
 
Do we occupy the dizziest heights of privilege? Or is ours a humbler altitude, and by how much? Six Flags doesn’t use that language, but it might as well, because it offers some half-dozen gradations of access and coddling, from a high-priced position near the front of every line to a much less expensive ticket and much longer waits. There are levels — regular, gold, platinum — and they suggest that the experience is more than just a sprawling day of dips, whirls and happy shrieks. It’s a referendum on your very station in society. I don’t recall anything quite like it from the amusement parks of my youth. Back then our lives as consumers, and as Americans, didn’t seem so relentlessly tiered.

Much has been made of commercial flights these days, with all those divisions between first class and coach. For various supplements or with various deals, you can get a few more inches of legroom or, shy of that, a prime aisle seat. You can get to board earlier or later, and thus hoard or miss out on the overhead bins. Will it be long before there’s a ranked queue for the bathroom? I’m not even sure I’m kidding.

It’s not that pecking orders or badges of affluence are anything new. Our homes, cars, clubs and clothes have long been advertisements of our economic clout, used and perceived that way.

But lately, the places and ways in which Americans are economically segregated and stratified have multiplied, with microclimates of exclusivity popping up everywhere. The plane mirrors the sports arena, the theater, the gym. Is it any wonder that class tensions simmer? In a country of rising income inequality and an economy that’s moved from manufacturing to services, one thing we definitely make in abundance is distinctions.

When I grew up, school essentially came in two sizes: public or private. Now, private is a starting point, with many costly but broadly employed add-on’s: the tutor for specific subjects; the tutor for SATs; the individual sports coach; the college-admissions consultant, whose fee can exceed $5,000.

With taxis as with Boeings, there are degrees of pampering. Uber, a relatively new car service in dozens of American cities, allows you to specify, just minutes before your vehicle’s arrival, precisely how regal and roomy it should be. If you see yourself in an S.U.V., then an S.U.V. is the chariot in which others will see you, too.

Broadway theaters have premium seating, which is so expensive that a high roller can often get the best real estate at the last minute. It’s as if scalping has come out of the closet, louder and prouder in an age of unapologetic elitism. Luxury boxes now take up more space in stadiums than ever; elsewhere in some ballparks, the differences between sections involve not just better views but finer food and a more solicitous staff.

No sooner does a fitness trend appear than it spawns strata, so that you can spin in candlelight at SoulCycle, in less gilded trappings at Crunch, or in bare-bones fashion at the Y.M.C.A. There’s an accordant price scale. Even the fanciest gyms have rungs of enhanced fanciness, such as executive locker rooms. At Equinox, trainers are designated by numbers — Tiers 1, 2 and 3 — that signal their experience and hourly rate, and there are deluxe inner sanctums within certain Equinox clubs. They use eye-scanning technology to figure out who belongs.

Bronze, silver, gold, platinum: a vocabulary once associated with jewelry or Olympic medals is now attached to your Hertz status, your Delta level, your Obamacare plan, establishing how far forward or back in the pack you belong, herding you into categories that sound suspiciously like evaluations of worth. This is how precious you are.
"""

import re

class Token(object):
    """ A simple Token structure. Token type, value and position.
    """
    def __init__(self, type, val, pos):
        self.type = type
        self.val = val
        self.pos = pos

    def __str__(self):
        return '%s(%s) at %s' % (self.type, self.val, self.pos)


class LexerError(Exception):
    def __init__(self, pos):
        self.pos = pos


class Lexer(object):
    """ A simple regex-based lexer/tokenizer.
    """
    def __init__(self, rules, skip_whitespace=True):
        """ Create a lexer.

            rules:
                A list of rules. Each rule is a regex, type
                pair, where regex is the regular expression used
                to recognize the token and type is the type
                of the token to return when it's recognized.

            skip_whitespace:
                If True, whitespace (\s+) will be skipped and not
                reported by the lexer. Otherwise, you have to
                specify your rules for whitespace, or it will be
                flagged as an error.
        """
        self.rules = []
        for regex, type in rules:
            self.rules.append((re.compile(regex), type))
        self.skip_whitespace = skip_whitespace
        self.re_ws_skip = re.compile('\S')

    def input(self, buf):
        """ Initialize the lexer with a buffer as input.
        """
        self.buf = buf
        self.pos = 0

    def token(self):
        """ Return the next token (a Token object) found in the
            input buffer. None is returned if the end of the
            buffer was reached.
            In case of a lexing error (the current chunk of the
            buffer matches no rule), a LexerError is raised with
            the position of the error.
        """
        if self.pos >= len(self.buf):
            return None
        if self.skip_whitespace:
            m = self.re_ws_skip.search(self.buf, self.pos)
            if m:
                self.pos = m.start()
            else:
                return None

        for regex, type in self.rules:
            m = regex.match(self.buf, self.pos)
            if m:
                tok = Token(type, m.group(), self.pos)
                self.pos = m.end()
                return tok

        # if we're here, no rule matched
        raise LexerError(self.pos)

    def tokens(self):
        """ Returns an iterator to the tokens found in the buffer.
        """
        while 1:
            tok = self.token()
            if tok is None: break
            yield tok

rules1 = [
    ('\d+',          'NUMBER'),
    ('[a-zA-Z_]\w*', 'IDENTIFIER'),
    ('\+',           'PLUS'),
    ('\-',           'MINUS'),
    ('\*',           'MULTIPLY'),
    ('\/',           'DIVIDE'),
    ('\(',           'LP'),
    ('\)',           'RP'),
    ('\[',           'LB'),
    ('\]',           'RB'),
    ('=',            'EQUALS'),
]
text1 = 'erw = _abc + 12*(R4-623902) #comment lol '

rules2 = [
    ('[a-zA-Z_,()]\w*', 'SENTENCE'),
    ('\.',           'PERIOD'),
]
text1 = 'erw = _abc + 12*(R4-623902) #comment lol '


lx = Lexer(rules2, skip_whitespace=True)
lx.input(text)

try:
    print text
    for tok in lx.tokens():
        print(tok)
        print
except LexerError as err:
    print('LexerError at position %s' % err.pos)
