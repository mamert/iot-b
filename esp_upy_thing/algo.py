
def approx_len(*args):
    """a cheaper Pythagoras
    Alpha max plus beta min, but for 3 dimensions
    https://math.stackexchange.com/a/3182291
    """
    assert len(args) == 3
    s = sorted(abs(x) for x in args)
    return 0.9398086351723256*s[2] + 0.38928148272372454*s[1] + 0.2987061876143797*s[0]