#!/usr/bin/env python3

import math as m

def sqrt_interp_search(n: int) -> int:
    assert n >= 0, "n must be nonnegative"
    assert n < 2**256, "must have 0 <= n < 2**256"

    if (n <= 1):
        return n

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

    low = result
    high = (low << 1) + 1
    assert low**2 <= n
    assert n < high**2

    iterations = 0
    while (low**2 <= n) and (n < high**2):
    #while (low + 1 < high):
        iterations += 1
        print("Iters:", iterations)
        if iterations > 256:
            print("exit")
            return low

        # get interpolated value
        middle = low + (n - low**2)//(high + low)
        #print("low:  ", low)
        #print("high: ", high)
        #print("mid:  ", middle)
        #print()
        if (n//middle < middle):
            high = middle
        else:
            low = middle + 1
    return low-1

values = [
          #2**255,
          2**256 - 2**128,
          2**256 - 2**180,
          2**256 - 2**196,
          2**256 - 2**224,
          2**256 - 2**230,
          2**256 - 2**236,
         ]

for v in values:
    print("Value:", v)
    t = m.isqrt(v)
    print(t)
    ret = sqrt_interp_search(v)
    print()
    print("ret: ", ret)
    print("true:", t)
    print()
    print()
    assert ret == t, "invalid result"
