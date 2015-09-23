def prod(scale):
    return reduce(lambda x, y: x * y, scale)


def f(total, scale):
    if not mul.has_key(total):
        if not scale.has_key(total):
            raise Exception('Error: argument not match')
        else:
            x, y = scale[total]
            mul[total]=y * f(x, scale) + (x - 1) * (y - 1) + x * f(y, scale)
    return mul[total]

mul = {4: 0}
scale = {2048: (256, 4), 256: (16, 16), 16: (4, 4)}

print f(2048, scale=scale)
print mul
