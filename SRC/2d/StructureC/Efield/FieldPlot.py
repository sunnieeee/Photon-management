import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib import cm
from scipy import interpolate 


edata = np.loadtxt('efield_700nm_1_1_0.54.txt')

x = np.array(edata[:,0])
z = np.array(edata[:,1])

aE = np.zeros((100, 300))
e = np.zeros(len(x))

aex = np.array([x[2]for x in edata])
aey = np.array([x[3]for x in edata])
aez = np.array([x[4]for x in edata])

for i in range(len(x)) :
#    e[i] = np.power(np.exp(np.sqrt(aex[i]**2+aey[i]**2+aez[i]**2)),2)
    e[i] = np.exp(np.sqrt(aex[i]**2+aey[i]**2+aez[i]**2))

t = 0
for j in range(100):
    for i in range(300):
        t = j * 300
        aE[j,i] = e[t+i]

sns.set()
# Define figure
f, ax = plt.subplots(figsize = (9,6))

'''
xx = np.arange(0,2,0.01)
zz = np.arange(-1,2,0.01)
xx, zz = np.meshgrid(xx, zz)
'''

ax = sns.heatmap(aE,vmin = 0, vmax = 5.5, cmap = cm.seismic)
plt.show()