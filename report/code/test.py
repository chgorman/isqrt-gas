#!/usr/bin/env python3

import math as m

def sqrt_oz(n: int) -> int:
    assert n >= 0, "n must be nonnegative"
    assert n < 2**256, "must have 0 <= n < 2**256"

    if (n <= 1):
        return n
    #if (n >= (2**128 - 1)**2):
    #    return (2**128 - 1)

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

    #result = (3 * result) >> 1

    result = (result + n // result) >> 1
    result = (result + n // result) >> 1
    result = (result + n // result) >> 1
    result = (result + n // result) >> 1
    result = (result + n // result) >> 1
    result = (result + n // result) >> 1
    result = (result + n // result) >> 1

    #if (result * result <= n):
    #    return result
    #return result - 1
    return min(result, n//result)

values = [0, 1, 2**255,
        115792089237316195423570985008687907852249137564877748649067460185617825005569,
        115792089237316195423570985008687907852249137564877748649067460185617825005568,
        115792089237316195423570985008687907852249137564877748649067460185617825005567,
        115792089237316195423570985008687907852249137564877748649067460185617825005566,
        115792089237316195423570985008687907852249137564877748649067460185617825005565,
        115792089237316195423570985008687907852249137564877748649067460185617825005564,
        115792089237316195423570985008687907852929702298719625575994209400481361428479]

for v in values:
    ret = sqrt_oz(v)
    t = m.isqrt(v)
    assert ret == t, "invalid result"
