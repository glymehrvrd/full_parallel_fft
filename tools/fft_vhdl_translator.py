# translate a math formula have the form of 'Re(X[1])=Re(x[0])-Re(x[1])' into VHDL code.

from functools import update_wrapper
from string import split
import re

def grammar(description, whitespace=r'\s*'):
    """Convert a description to a grammar.  Each line is a rule for a
    non-terminal symbol; it looks like this:
        Symbol =>  A1 A2 ... | B1 B2 ... | C1 C2 ...
    where the right-hand side is one or more alternatives, separated by
    the '|' sign.  Each alternative is a sequence of atoms, separated by
    spaces.  An atom is either a symbol on some left-hand side, or it is
    a regular expression that will be passed to re.match to match a token.
    
    Notation for *, +, or ? not allowed in a rule alternative (but ok
    within a token). Use '\' to continue long lines.  You must include spaces
    or tabs around '=>' and '|'. That's within the grammar description itself.
    The grammar that gets defined allows whitespace between tokens by default;
    specify '' as the second argument to grammar() to disallow this (or supply
    any regular expression to describe allowable whitespace between tokens)."""
    G = {' ': whitespace}
    description = description.replace('\t', ' ') # no tabs!
    for line in split(description, '\n'):
        if not line:
            continue
        lhs, rhs = split(line, '=>', 1)
        lhs=lhs.strip()
        rhs=rhs.strip()
        alternatives = split(rhs, ' | ')
        G[lhs] = tuple(map(split, alternatives))
    return G

def decorator(d):
    "Make function d a decorator: d wraps a function fn."
    def _d(fn):
        return update_wrapper(d(fn), fn)
    update_wrapper(_d, d)
    return _d

@decorator
def memo(f):
    """Decorator that caches the return value for each call to f(args).
    Then when called again with same args, we can just look it up."""
    cache = {}
    def _f(*args):
        try:
            return cache[args]
        except KeyError:
            cache[args] = result = f(*args)
            return result
        except TypeError:
            # some element of args can't be a dict key
            return f(args)
    return _f

def parse(start_symbol, text, grammar):
    """Example call: parse('Exp', '3*x + b', G).
    Returns a (tree, remainder) pair. If remainder is '', it parsed the whole
    string. Failure iff remainder is None. This is a deterministic PEG parser,
    so rule order (left-to-right) matters. Do 'E => T op E | T', putting the
    longest parse first; don't do 'E => T | T op E'
    Also, no left recursion allowed: don't do 'E => E op T'"""

    tokenizer = grammar[' '] + '(%s)'

    def parse_sequence(sequence, text):
        result = []
        for atom in sequence:
            tree, text = parse_atom(atom, text)
            if text is None: return Fail
            result.append(tree)
        return result, text

    @memo
    def parse_atom(atom, text):
        if atom in grammar:  # Non-Terminal: tuple of alternatives
            for alternative in grammar[atom]:
                tree, rem = parse_sequence(alternative, text)
                if rem is not None: return [atom]+tree, rem  
            return Fail
        else:  # Terminal: match characters against start of text
            m = re.match(tokenizer % atom, text)
            return Fail if (not m) else (m.group(1), text[m.end():])
    
    # Body of parse:
    return parse_atom(start_symbol, text)

Fail = (None, None)

eq = 'Re(X[2])=-Re(x[0])+Re(x[1])-Re(x[2])+Re(x[3])'

EQUATION = grammar(r"""
equation => term = exp
exp      => term [+-] exp | term
term     => [+-]?(Re|Im)\(\w+\[\d+\]\)
""", whitespace='\s*')

def equation_parser(text):
    return parse('equation', text, EQUATION)

VHDL='''C_BUFF{{ data_index }}_{{ 'RE' if part=='re' else 'IM'}} : Dff_preload_reg1{{ '_init_1' if operator=='-' else '' }} port map(
    D=>c({{ i }}),
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff({{ i }}));

ADDER{{ data_index }}_IM : adder_bit1 port map (
    d1_in=>data_0_im_in,
    d2_in=>data_1_im_in,
    c_in=>c_buff(1),
    sum_out=>data_0_im_out,
    c_out=>c(1));'''

def exp_translator(exp):
    lhs = exp[1]
    operator = exp[2]
    rhs = exp[3]
    print lhs,operator,rhs

eq = equation_parser(eq)[0]
from pprint import pprint

lhs = eq[1][1]

rhs = eq[3]
exp_translator(rhs)