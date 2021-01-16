#! python3
import numpy as np

data = np.loadtxt('./flatSiAir{}.txt')

# 获取所需波长对应的吸收率

i = 606
for flatAir in data:
    print(data[i])
    if i >= 706:
        break
    else:
        i += 20