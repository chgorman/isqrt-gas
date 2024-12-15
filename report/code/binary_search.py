#!/usr/bin/env python3

import math as m

def sqrt_binary_search(n: int) -> int:
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
    high = (low << 1)
    assert low**2 <= n
    assert n < high**2

    iterations = 0
    while (low <= high):
        iterations += 1
        print("Iters:", iterations)
        middle = (high + low) >> 1
        if (n//middle < middle):
            high = middle - 1
        else:
            low = middle + 1
    return low-1

values = [
          2**3,
          2**5,
          2**7,
          2**9,
          2**13,
          2**15,
         ]

for v in values:
    print("Value:", v)
    t = m.isqrt(v)
    print(t)
    print()
    ret = sqrt_binary_search(v)
    print()
    print("ret: ", ret)
    print("true:", t)
    print()
    print()
    assert ret == t, "invalid result"
