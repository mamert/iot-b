import machine


class MPU6050():
    def __init__(self, i2c, addr=0x68):
        self.iic = i2c
        self.addr = addr
        self.iic.start()
        self.iic.writeto(self.addr, bytearray([107, 0]))
        self.iic.stop()

    def get_raw_values(self):
        self.iic.start()
        a = self.iic.readfrom_mem(self.addr, 0x3B, 14)
        self.iic.stop()
        return a

    def get_ints(self):
        b = self.get_raw_values()
        c = []
        for i in b:
            c.append(i)
        return c

    def bytes_toint(self, firstbyte, secondbyte):
        if not firstbyte & 0x80:
            return firstbyte << 8 | secondbyte
        return - (((firstbyte ^ 255) << 8) | (secondbyte ^ 255) + 1)

    def get_values(self):
        raw_ints = self.get_raw_values()
        return (
            self.bytes_toint(raw_ints[0], raw_ints[1]),
            self.bytes_toint(raw_ints[2], raw_ints[3]),
            self.bytes_toint(raw_ints[4], raw_ints[5]),
            #self.bytes_toint(raw_ints[6], raw_ints[7]) / 340.00 + 36.53,
            self.bytes_toint(raw_ints[8], raw_ints[9]),
            self.bytes_toint(raw_ints[10], raw_ints[11]),
            self.bytes_toint(raw_ints[12], raw_ints[13]),
        )
        # -32768 to 32767
