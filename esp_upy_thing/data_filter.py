def scale_i(v):
    return v>>7

def scale_f(v):
    return v/128.0


class ListFilter:
    def __init__(self, fClass, *a):
        self.fc = fClass
        self.fa = a
        self.c = 0
        self.fs = None
    def __call__(self, data):
        if not self.c:
            self.c = len(data)
            self.fs = [self.fc(*self.fa) for _ in range(self.c)]
        return [self.fs[i](data[i]) for i in range(self.c)]

class ExponentialSmoother:
    def __init__(self, factor):
        self.m1 = 1-factor
        self.m2 = factor
        self.mem = None
        self.len = 0
    def __call__(self, d):
        if not self.mem:
            self.mem = d
        self.mem = self.m1*self.mem + self.m2*d
        return self.mem

class MovingAvg:
    def __init__(self, s):
        self.s = s
        self.mem = None
        self.i = 0
    def __call__(self, d):
        if not self.mem:
            self.mem = [d for _ in range(self.s)]
        self.mem[self.i] = d
        self.i += 1
        self.i %= self.s
        return sum(self.mem)/self.s
    
class MovingMax:
    def __init__(self, s):
        self.s = s
        self.mem = None
        self.i = 0
        self.mem = [0 for _ in range(self.s)]
    def __call__(self, d):
        self.mem[self.i] = d
        self.i += 1
        self.i %= self.s
        return max(self.mem)
    
class MomentumThing:
    """Purpose: report only acceleration, not sudden deleceration.
    Risk: twitch in opposite direction before proceeding?
    keep last value AND short-term MA of value? and of delta
    store value of last zero-crossing
    store value of highest (amplitude) peak since zero-crossing:
      if 0cross:
        peak=0
        if (delta is low or last peak is low): rising=1
      elif newVal < oldVal: rising=0
      elif not rising and newVal >= oldVal: rising=1
      Note: assumed to be falling until first opposite peak
    On update:
      Update MA mem with real val
      if rising: return prediction: valMA + deltaMAl
      else return 0
    
    Another alg: google sth to estimate speed, then decay that with time.
    """
    pass
