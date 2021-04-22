
class ImuOutTxt:
    def __init__(self, var_count):
        self.fmt_str = ",".join("{:5.3f}" for _ in range(var_count))
        
    def update(self, data):
        print(self.fmt_str.format(*data))

class ImuOutStatsTxt:
    def __init__(self, data_len):
        self.data_len = data_len
        self.stats_len = data_len * 2
        self.stats = [0 for _ in range(self.stats_len)]
        self.fmt_str = ",".join("{:4.3f}" for _ in range(self.stats_len))
        
    def update(self, data):
        self.stats[:self.data_len] = [min(self.stats[i], data[i]) for i in range(self.data_len)]
        self.stats[self.data_len:] = [max(self.stats[i+self.data_len], data[i]) for i in range(self.data_len)]
        print(self.fmt_str.format(*self.stats))
