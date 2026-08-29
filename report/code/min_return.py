#!/usr/bin/env python3

import math as m

def unrolled1(n: int) -> int:
    assert n >= 0, "n must be nonnegative"
    assert n < 2**256, "must have 0 <= n < 2**256"

    nAux = n
    result = 1

    if (nAux >= 2**128):
        nAux >>= 128
        result = 2**64
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

    result = (result + n // result) >> 1
    result = (result + n // result) >> 1
    result = (result + n // result) >> 1
    result = (result + n // result) >> 1
    result = (result + n // result) >> 1
    result = (result + n // result) >> 1
    result = (result + n // result) >> 1
    print(result)

    #if (result * result <= n):
    #    return result
    #return result - 1
    return min(result, n//result)

values = [2**256 - 1]

for v in values:
    ret = unrolled1(v)
    t = m.isqrt(v)
    print(t)
    assert ret == t, "invalid result"
