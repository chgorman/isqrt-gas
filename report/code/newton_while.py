#!/usr/bin/env python3

import math as m

def sqrt_newton_while_2(n: int) -> int:
    assert n >= 0, "n must be nonnegative"
    assert n < 2**256, "must have 0 <= n < 2**256"

    if (n <= 1):
        return n

    nAux = n
    result = 2
    
    if (nAux >= 2**128):
        nAux >>= 128
        result = 2**65
    if (nAux >= 2**64):
        nAux >>= 64
        result <<= 32
    if (nAux >= 2**32):
        nAux >>= 32
        result <<= 16
    if (nAux >= 2**16):
        nAux >>= 16
        result <<= 8
    if (nAux >= 2**8):
        nAux >>= 8
        result <<= 4
    if (nAux >= 2**4):
        nAux >>= 4
        result <<= 2
    if (nAux >= 2**2):
        result <<= 1

    nAux = (result + n // result) >> 1
    iterations = 0
    while nAux < result:
        iterations += 1
        result = nAux
        nAux = (result + n // result) >> 1
    print("Iters:", iterations)
    return result

values = [
          2**256 - 2**128,
          2**256 - 2**224,
          2**256 - 2**240,
          2**256 - 2**248,
          2**256 - 2**252,
          2**256 - 2**254,
         ]

for v in values:
    print("Value:", v)
    ret = sqrt_newton_while_2(v)
    t = m.isqrt(v)
    print()
    assert ret == t, "invalid result"
