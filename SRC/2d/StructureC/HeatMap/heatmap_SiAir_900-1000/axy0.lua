--------------cyq---------------
zz = 3/11  --6/11
xx = {0.1,0.4,0.7,1,1.5,2,4,6,8,10}
yy = {1,1.4,1.8,2.2,4,6,8,10,12,14}
for m = 1,10 do
    for n = 1,10 do
----------------------------------------

L = 1
period = 0.9/3
G = 300
N = 6

a1 = (xx[m]/(xx[m]+1))*period
a2 = period - a1
h1 = zz*period
h2 = h1/yy[n]   -- h<=1

if (h1 <= h2)
then
    h = h1
    h1 = h2
    h2 = h
    a = a1
    a1 = a2
    a2 = a
end
L1 = h2
L2 = h1 - h2  --require h1 > h2
L3 = L - h1  --require h1 < L

S = S4.NewSimulation()
S:SetLattice({period,0},{0,0})  --1D Lattice
S:SetNumG(G)

S:AddMaterial('Vacuum', {1,0})
S:AddMaterial('Silicon', {12,0})
--S:AddMaterial('SiO2', {2.1025,0})  -- n_SiO2 = 1.45

N1 = N/2
d1 = L1/N1
S:AddLayer('AirAbove',0,'Vacuum')
--S:AddLayer('AirAbove',0,'SiO2')
for i = 1,N1 do
    S:AddLayer('Layer1'..i, d1, 'Silicon')
    x1 = 1/2 * a1
    y1 = 1/2 * d1 + (i-1) * d1
    halfwidth1 = 1/2 * a1 * ( h1-(i-1)*d1 )/h1
    S:SetLayerPatternRectangle('Layer1'..i,
    'Vacuum',
                                {x1,y1},
                                0,
                                {halfwidth1,0})
    x2 = a1 + 1/2 * a2
    y2 = 1/2 * d1 + (i-1) * d1
    halfwidth2 = 1/2 * a2 * ( h2-(i-1)*d1 )/h2
    S:SetLayerPatternRectangle('Layer1'..i,
    'Vacuum',
                                {x2,y2},
                                0,
                                {halfwidth2,0})
end

if (h1>h2)  --L2>0
then
    N2 = N/2
    d2 = L2/N2
    for i = 1,N2 do
        S:AddLayer('Layer2'..i, d2, 'Silicon')
        x = 1/2 * a1
        y = h2 + 1/2 * d2 + (i-1) * d2
        halfwidth = 1/2 * a1 * ( h1-h2-(i-1)*d2 )/h1
        S:SetLayerPatternRectangle('Layer2'..i,
        'Vacuum',
                                    {x,y},
                                    0,
                                    {halfwidth,0})
    end
end
S:AddLayer('si', L3, 'Silicon')
S:AddLayerCopy('AirBelow', 0, 'AirAbove')

--[[
-- Dump the epsilon reconstruction in real space to stderr
for x= 0,2,0.02 do
	for z=-0.5,1.5,0.02 do
		er,ei = S:GetEpsilon({x,0,z}) -- returns real and imag parts
		print(x .. '\t' .. z .. '\t' .. er .. '\t' .. ei .. '\n')
	end
	print('\n')
end
--]]

S:SetExcitationPlanewave({0,0}, {0,0}, {1,0})  --TM p-polarized

--wavelength = {0.2952,0.296,0.2966,0.298,0.299,0.2995,0.3009,0.3024,0.303,0.3039,0.3054,0.306,0.3069,0.3084,0.309,0.31,0.311,0.3115,0.3131,0.314,0.3147,0.3163,0.317,0.3179,0.319,0.3195,0.3212,0.322,0.3229,0.324,0.3246,0.3263,0.327,0.328,0.329,0.3297,0.331,0.3315,0.3333,0.334,0.3351,0.336,0.3369,0.338,0.3388,0.34,0.3406,0.342,0.3425,0.3444,0.345,0.3463,0.347,0.3483,0.349,0.3502,0.351,0.3522,0.353,0.3542,0.355,0.3563,0.357,0.3583,0.359,0.3604,0.361,0.362,0.3625,0.364,0.3647,0.366,0.3668,0.368,0.369,0.37,0.3712,0.372,0.3734,0.374,0.375,0.3757,0.377,0.378,0.379,0.3803,0.381,0.382,0.3827,0.384,0.385,0.386,0.387,0.3875,0.389,0.3899,0.391,0.3924,0.393,0.394,0.3949,0.396,0.3974,0.398,0.399,0.4,0.401,0.402,0.4025,0.404,0.4052,0.406,0.407,0.4078,0.409,0.41,0.4105,0.412,0.4133,0.414,0.415,0.4161,0.417,0.418,0.4189,0.42,0.421,0.4217,0.423,0.424,0.4246,0.426,0.427,0.4275,0.429,0.43,0.4305,0.432,0.433,0.4335,0.435,0.436,0.4366,0.438,0.439,0.4397,0.441,0.442,0.4428,0.444,0.445,0.446,0.447,0.448,0.4492,0.45,0.451,0.452,0.4525,0.454,0.455,0.4558,0.457,0.458,0.4592,0.46,0.461,0.462,0.4626,0.464,0.465,0.4661,0.467,0.468,0.469,0.4696,0.471,0.472,0.4732,0.474,0.475,0.476,0.4769,0.478,0.479,0.48,0.4806,0.482,0.483,0.4843,0.485,0.486,0.487,0.4881,0.489,0.49,0.491,0.492,0.493,0.494,0.495,0.4959,0.497,0.498,0.499,0.4999,0.501,0.502,0.503,0.504,0.505,0.506,0.507,0.5081,0.509,0.51,0.511,0.5123,0.513,0.514,0.515,0.516,0.5166,0.518,0.519,0.52,0.5209,0.522,0.523,0.524,0.5254,0.526,0.527,0.528,0.529,0.5299,0.531,0.532,0.533,0.5344,0.535,0.536,0.537,0.538,0.5391,0.54,0.541,0.542,0.543,0.5438,0.545,0.546,0.547,0.548,0.5486,0.55,0.551,0.552,0.553,0.5535,0.555,0.556,0.557,0.558,0.5585,0.56,0.561,0.562,0.563,0.5636,0.565,0.566,0.567,0.568,0.5687,0.57,0.571,0.572,0.573,0.574,0.575,0.576,0.577,0.578,0.5794,0.58,0.581,0.582,0.583,0.584,0.5848,0.586,0.587,0.588,0.589,0.5904,0.591,0.592,0.593,0.594,0.595,0.5961,0.597,0.598,0.599,0.6,0.601,0.6019,0.603,0.604,0.605,0.606,0.607,0.6078,0.609,0.61,0.611,0.612,0.613,0.6138,0.615,0.616,0.617,0.618,0.619,0.6199,0.621,0.622,0.623,0.624,0.625,0.6262,0.627,0.628,0.629,0.63,0.631,0.632,0.6326,0.634,0.635,0.636,0.637,0.638,0.6391,0.64,0.641,0.642,0.643,0.644,0.645,0.6458,0.647,0.648,0.649,0.65,0.651,0.652,0.6526,0.654,0.655,0.656,0.657,0.658,0.659,0.6595,0.661,0.662,0.663,0.664,0.665,0.666,0.6666,0.668,0.669,0.67,0.671,0.672,0.673,0.6738,0.675,0.676,0.677,0.678,0.679,0.68,0.6812,0.682,0.683,0.684,0.685,0.686,0.687,0.688,0.6888,0.69,0.691,0.692,0.693,0.694,0.695,0.696,0.6965,0.698,0.699,0.7,0.701,0.702,0.703,0.704,0.7045,0.706,0.707,0.708,0.709,0.71,0.711,0.712,0.7126,0.714,0.715,0.716,0.717,0.718,0.719,0.72,0.7208,0.722,0.723,0.724,0.725,0.726,0.727,0.728,0.7293,0.73,0.731,0.732,0.733,0.734,0.735,0.736,0.737,0.738,0.739,0.74,0.741,0.742,0.743,0.744,0.745,0.746,0.7469,0.748,0.749,0.75,0.751,0.752,0.753,0.754,0.755,0.756,0.757,0.758,0.759,0.76,0.761,0.762,0.763,0.764,0.7653,0.766,0.767,0.768,0.769,0.77,0.771,0.772,0.773,0.774,0.7749,0.776,0.777,0.778,0.779,0.78,0.781,0.782,0.783,0.784,0.7847,0.786,0.787,0.788,0.789,0.79,0.791,0.792,0.793,0.794,0.7948,0.796,0.797,0.798,0.799,0.8,0.801,0.802,0.803,0.804,0.8051,0.806,0.807,0.808,0.809,0.81,0.811,0.812,0.813,0.814,0.815,0.8157,0.817,0.818,0.819,0.82,0.821,0.822,0.823,0.824,0.825,0.826,0.8266,0.828,0.829,0.83,0.831,0.832,0.833,0.834,0.835,0.836,0.837,0.838,0.839,0.84,0.841,0.842,0.843,0.844,0.845,0.846,0.847,0.848,0.849,0.85,0.851,0.852,0.853,0.854,0.855,0.856,0.857,0.858,0.859,0.86,0.861,0.862,0.863,0.864,0.865,0.866,0.867,0.868,0.869,0.87,0.871,0.872,0.873,0.874,0.875,0.876,0.877,0.878,0.879,0.88,0.881,0.882,0.883,0.884,0.885,0.886,0.887,0.888,0.889,0.89,0.891,0.892,0.893,0.894,0.895,0.896,0.897,0.898,0.899,0.9,0.901,0.902,0.903,0.904,0.905,0.906,0.907,0.908,0.909,0.91,0.911,0.912,0.913,0.914,0.915,0.916,0.917,0.918,0.919,0.92,0.921,0.922,0.923,0.924,0.925,0.926,0.927,0.928,0.929,0.93,0.931,0.932,0.933,0.934,0.935,0.936,0.937,0.938,0.939,0.94,0.941,0.942,0.943,0.944,0.945,0.946,0.947,0.948,0.949,0.95,0.951,0.952,0.953,0.954,0.955,0.956,0.957,0.958,0.959,0.96,0.961,0.962,0.963,0.964,0.965,0.966,0.967,0.968,0.969,0.97,0.971,0.972,0.973,0.974,0.975,0.976,0.977,0.978,0.979,0.98,0.981,0.982,0.983,0.984,0.985,0.986,0.987,0.988,0.989,0.99,0.991,0.992,0.993,0.994,0.995,0.996,0.997,0.998,0.999,1,1.001,1.002,1.003,1.004,1.005,1.006,1.007,1.008,1.009,1.01,1.011,1.012,1.013,1.014,1.015,1.016,1.017,1.018,1.019,1.02,1.021,1.022,1.023,1.024,1.025,1.026,1.027,1.028,1.029,1.03,1.031,1.032,1.033,1.034,1.035,1.036,1.037,1.038,1.039,1.04,1.041,1.042,1.043,1.044,1.045,1.046,1.047,1.048,1.049,1.05,1.051,1.052,1.053,1.054,1.055,1.056,1.057,1.058,1.059,1.06,1.061,1.062,1.063,1.064,1.065,1.066,1.067,1.068,1.069,1.07,1.071,1.072,1.073,1.074,1.075,1.076,1.077,1.078,1.079,1.08,1.081,1.082,1.083,1.084,1.085,1.086,1.087,1.088,1.089,1.09,1.091,1.092,1.093,1.094,1.095,1.096,1.097,1.098,1.099,1.1,1.101,1.102,1.103,1.104,1.105,1.106,1.107,1.108,1.109,1.11,1.111,1.112,1.113,1.114,1.115,1.116,1.117,1.118,1.119,1.12,1.121,1.122,1.123,1.124,1.125,1.126,1.127,1.128,1.129,1.13,1.131,1.132,1.133,1.134,1.135,1.136,1.137,1.138,1.139,1.14,1.141,1.142,1.143,1.144,1.145,1.146,1.147,1.148,1.149,1.15,1.151,1.152,1.153,1.154,1.155,1.156,1.157,1.158,1.159,1.16,1.161,1.162,1.163,1.164,1.165,1.166,1.167,1.168,1.169,1.17,1.171,1.172,1.173,1.174,1.175,1.176,1.177,1.178,1.179,1.18,1.181,1.182,1.183,1.184,1.185,1.186,1.187,1.188,1.189,1.19}
--eps_r = {2.3722,3.5039,4.3431,5.9783,6.8741,7.3164,8.4247,9.368,9.6698,10.117,10.776,11.004,11.342,11.828,11.981,12.234,12.503,12.636,13.011,13.192,13.332,13.655,13.791,13.965,14.164,14.254,14.565,14.719,14.891,15.099,15.212,15.529,15.661,15.849,16.04,16.175,16.435,16.535,16.878,17.016,17.233,17.41,17.587,17.8,17.955,18.199,18.321,18.606,18.708,19.125,19.267,19.575,19.748,20.072,20.296,20.681,20.976,21.421,21.806,22.388,22.888,23.711,24.366,25.601,26.454,28.184,29.121,30.696,31.491,34.03,35.219,37.438,38.791,40.276,41.481,42.256,43.138,43.377,43.739,43.627,43.422,43.266,42.631,42.13,41.526,40.735,40.295,39.667,39.228,38.388,37.744,37.185,36.628,36.351,35.545,35.064,34.538,33.874,33.611,33.176,32.786,32.348,31.795,31.581,31.227,30.875,30.543,30.212,30.047,29.613,29.268,29.035,28.745,28.514,28.212,27.961,27.836,27.493,27.197,27.048,26.835,26.602,26.421,26.222,26.042,25.841,25.659,25.531,25.313,25.146,25.046,24.816,24.652,24.57,24.349,24.203,24.129,23.915,23.773,23.702,23.509,23.381,23.304,23.133,23.01,22.925,22.773,22.657,22.564,22.442,22.339,22.237,22.131,22.026,21.899,21.823,21.728,21.633,21.586,21.447,21.355,21.281,21.177,21.091,20.987,20.922,20.842,20.761,20.713,20.6,20.519,20.431,20.369,20.3,20.232,20.191,20.089,20.017,19.931,19.886,19.83,19.774,19.723,19.654,19.592,19.53,19.492,19.41,19.351,19.274,19.235,19.18,19.125,19.064,19.016,18.963,18.909,18.856,18.805,18.754,18.703,18.657,18.605,18.557,18.51,18.467,18.419,18.376,18.332,18.288,18.242,18.196,18.15,18.1,18.064,18.024,17.984,17.932,17.904,17.865,17.825,17.786,17.763,17.711,17.674,17.637,17.603,17.564,17.529,17.494,17.445,17.425,17.391,17.358,17.325,17.295,17.257,17.222,17.187,17.138,17.12,17.09,17.06,17.03,16.997,16.97,16.94,16.911,16.881,16.857,16.822,16.793,16.764,16.735,16.718,16.681,16.654,16.628,16.602,16.588,16.549,16.523,16.497,16.471,16.458,16.422,16.398,16.375,16.351,16.337,16.301,16.276,16.251,16.225,16.208,16.18,16.159,16.138,16.116,16.095,16.073,16.051,16.029,16.006,15.975,15.963,15.942,15.921,15.901,15.88,15.863,15.839,15.82,15.8,15.78,15.752,15.741,15.723,15.705,15.687,15.669,15.649,15.633,15.616,15.598,15.58,15.563,15.547,15.529,15.513,15.497,15.481,15.465,15.452,15.432,15.415,15.398,15.381,15.364,15.35,15.332,15.316,15.301,15.286,15.27,15.256,15.239,15.223,15.206,15.19,15.174,15.155,15.144,15.131,15.118,15.104,15.091,15.078,15.07,15.05,15.035,15.021,15.007,14.992,14.977,14.964,14.95,14.936,14.923,14.909,14.895,14.884,14.869,14.856,14.844,14.832,14.819,14.807,14.799,14.784,14.772,14.761,14.75,14.739,14.728,14.722,14.704,14.693,14.681,14.669,14.657,14.645,14.638,14.622,14.61,14.598,14.587,14.575,14.563,14.554,14.542,14.531,14.521,14.511,14.5,14.49,14.478,14.471,14.462,14.453,14.444,14.435,14.426,14.417,14.409,14.399,14.39,14.381,14.372,14.363,14.354,14.346,14.341,14.328,14.32,14.311,14.303,14.294,14.286,14.277,14.273,14.259,14.25,14.241,14.231,14.222,14.213,14.203,14.198,14.189,14.182,14.176,14.169,14.163,14.157,14.15,14.145,14.135,14.127,14.12,14.112,14.104,14.096,14.088,14.077,14.073,14.067,14.061,14.055,14.049,14.043,14.037,14.031,14.025,14.017,14.01,14.002,13.995,13.987,13.98,13.972,13.964,13.958,13.95,13.944,13.937,13.931,13.924,13.918,13.911,13.904,13.898,13.892,13.887,13.881,13.875,13.87,13.864,13.859,13.853,13.846,13.842,13.837,13.831,13.826,13.82,13.815,13.809,13.804,13.799,13.794,13.786,13.779,13.773,13.766,13.759,13.752,13.745,13.739,13.732,13.727,13.719,13.713,13.708,13.702,13.696,13.69,13.684,13.678,13.672,13.668,13.66,13.654,13.647,13.641,13.634,13.628,13.621,13.615,13.608,13.601,13.597,13.592,13.587,13.582,13.577,13.573,13.568,13.563,13.558,13.553,13.55,13.543,13.537,13.532,13.527,13.521,13.516,13.51,13.505,13.5,13.494,13.491,13.458,13.434,13.41,13.406,13.401,13.397,13.393,13.388,13.384,13.379,13.375,13.371,13.366,13.362,13.358,13.353,13.349,13.344,13.34,13.336,13.331,13.327,13.322,13.318,13.314,13.309,13.305,13.301,13.296,13.292,13.287,13.283,13.279,13.274,13.27,13.266,13.261,13.257,13.253,13.248,13.244,13.239,13.235,13.231,13.226,13.222,13.218,13.213,13.209,13.204,13.2,13.196,13.191,13.187,13.183,13.178,13.174,13.17,13.165,13.161,13.157,13.152,13.148,13.144,13.139,13.135,13.13,13.126,13.122,13.117,13.113,13.109,13.104,13.1,13.096,13.091,13.087,13.083,13.078,13.074,13.07,13.065,13.061,13.057,13.052,13.048,13.044,13.039,13.035,13.031,13.026,13.022,13.018,13.013,13.009,13.005,13,12.996,12.992,12.987,12.983,12.979,12.974,12.971,12.967,12.964,12.96,12.956,12.953,12.949,12.946,12.942,12.938,12.935,12.931,12.928,12.924,12.92,12.917,12.913,12.91,12.906,12.902,12.899,12.895,12.892,12.888,12.885,12.881,12.877,12.874,12.87,12.867,12.863,12.859,12.856,12.852,12.849,12.845,12.841,12.838,12.834,12.831,12.828,12.825,12.822,12.819,12.816,12.814,12.811,12.808,12.805,12.802,12.799,12.796,12.793,12.791,12.788,12.785,12.782,12.779,12.776,12.773,12.771,12.768,12.765,12.762,12.759,12.756,12.753,12.751,12.748,12.745,12.742,12.739,12.736,12.733,12.731,12.728,12.725,12.722,12.719,12.716,12.714,12.712,12.71,12.708,12.706,12.704,12.701,12.699,12.697,12.695,12.693,12.691,12.689,12.686,12.684,12.682,12.68,12.678,12.676,12.674,12.671,12.669,12.667,12.665,12.663,12.661,12.659,12.657,12.654,12.652,12.65,12.648,12.646,12.644,12.642,12.639,12.637,12.635,12.633,12.631,12.629,12.627,12.625,12.622,12.62,12.618,12.616,12.614,12.612,12.61,12.607,12.605,12.603,12.601,12.599,12.597,12.595,12.593,12.59,12.588,12.587,12.585,12.584,12.583,12.581,12.58,12.578,12.577,12.576,12.574,12.573,12.571,12.57,12.568,12.567,12.566,12.564,12.563,12.561,12.56,12.558,12.556,12.554,12.551,12.549,12.547,12.545,12.543,12.541,12.539,12.537,12.536,12.534,12.533,12.532,12.53,12.529,12.527,12.526,12.525,12.523,12.522,12.52,12.519,12.517,12.516,12.515,12.513,12.512,12.51,12.508,12.506,12.504,12.502,12.5,12.498,12.496,12.493,12.491,12.489,12.488,12.486,12.485,12.484,12.482,12.481,12.479,12.478,12.476,12.475,12.474,12.472,12.471,12.469,12.468,12.467,12.465,12.464,12.462,12.461,12.459,12.458,12.457,12.455,12.454,12.452,12.451,12.45,12.448,12.447,12.445,12.444,12.443,12.441,12.44,12.438,12.437,12.435,12.434,12.433,12.431,12.43,12.428,12.427,12.426,12.424,12.423,12.421,12.42,12.419,12.417,12.416,12.414,12.413,12.412,12.41,12.409,12.407,12.406,12.404}
--eps_i = {45.351,44.738,44.271,43.151,42.406,42.032,40.958,39.949,39.575,39.013,38.132,37.813,37.334,36.609,36.359,35.942,35.55,35.354,34.84,34.565,34.352,33.941,33.778,33.567,33.342,33.239,32.94,32.818,32.679,32.527,32.444,32.234,32.153,32.038,31.942,31.874,31.78,31.744,31.615,31.584,31.534,31.506,31.478,31.458,31.443,31.454,31.459,31.499,31.513,31.638,31.7,31.835,31.936,32.126,32.275,32.532,32.751,33.079,33.374,33.817,34.151,34.696,35.025,35.635,35.865,36.315,36.333,36.347,36.347,35.638,35.284,33.82,32.886,31.043,29.481,27.695,25.54,24.047,21.444,20.465,18.847,17.725,15.956,14.619,13.554,12.194,11.633,10.842,10.295,9.4617,8.8322,8.3496,7.8736,7.6381,7.0316,6.6737,6.3305,5.9004,5.7398,5.4746,5.2385,5.0016,4.7041,4.6126,4.4612,4.3112,4.1455,3.9815,3.9,3.7137,3.5664,3.4988,3.415,3.3485,3.2264,3.1254,3.0753,2.9322,2.8094,2.7652,2.7023,2.6336,2.5882,2.5381,2.4932,2.4194,2.3528,2.3064,2.2197,2.1534,2.1138,2.0655,2.0312,2.0142,1.9606,1.9251,1.9074,1.8548,1.82,1.8026,1.7953,1.7904,1.7875,1.7156,1.6645,1.6289,1.5955,1.5699,1.5495,1.4954,1.4506,1.406,1.4026,1.3993,1.3952,1.3565,1.3083,1.2603,1.2364,1.224,1.2157,1.2091,1.2029,1.1978,1.1916,1.1919,1.1923,1.1927,1.1929,1.2005,1.206,1.2119,1.1775,1.1395,1.1015,1.0788,1.0761,1.0742,1.0718,1.0127,0.93902,0.86553,0.79956,0.80872,0.81701,0.82527,0.83021,0.79175,0.76437,0.72891,0.72171,0.71145,0.70121,0.68999,0.68508,0.67965,0.67423,0.66882,0.65902,0.64924,0.63948,0.63072,0.62984,0.62903,0.62823,0.62751,0.61056,0.59519,0.57986,0.56456,0.57636,0.58812,0.59985,0.61272,0.59024,0.56532,0.54045,0.5082,0.50781,0.50725,0.50669,0.50613,0.5058,0.4941,0.48575,0.47743,0.46995,0.46328,0.45723,0.4512,0.44276,0.43138,0.41243,0.39351,0.37463,0.35767,0.36134,0.36466,0.36797,0.3726,0.37557,0.38052,0.38546,0.39039,0.39581,0.38918,0.38184,0.3745,0.36718,0.36133,0.36095,0.36064,0.36033,0.36002,0.35983,0.33142,0.31117,0.29095,0.27076,0.26067,0.27501,0.28455,0.29407,0.30358,0.30833,0.29369,0.28395,0.27422,0.26451,0.25869,0.26284,0.2658,0.26876,0.27171,0.27377,0.26564,0.2594,0.25316,0.24694,0.24072,0.2361,0.23148,0.22687,0.22227,0.21584,0.21842,0.22271,0.227,0.23128,0.23556,0.23898,0.2388,0.23865,0.2385,0.23835,0.23814,0.23555,0.23124,0.22694,0.22264,0.21834,0.21362,0.21106,0.20822,0.20537,0.20254,0.1997,0.19715,0.19704,0.19694,0.19683,0.19673,0.19663,0.19655,0.19485,0.19343,0.19202,0.1906,0.18919,0.18806,0.18487,0.18221,0.17955,0.1769,0.17425,0.17186,0.17176,0.17167,0.17158,0.17149,0.1714,0.17129,0.16831,0.16459,0.16087,0.15716,0.15345,0.14974,0.14752,0.14575,0.14448,0.14322,0.14196,0.1407,0.13932,0.13822,0.137,0.13579,0.13457,0.13336,0.13214,0.13117,0.12975,0.12856,0.12737,0.12618,0.125,0.12381,0.1231,0.12304,0.12299,0.12295,0.1229,0.12285,0.12281,0.12278,0.12109,0.11996,0.11883,0.11771,0.11658,0.11545,0.11478,0.11323,0.11212,0.11102,0.10991,0.10881,0.1077,0.10682,0.10554,0.10447,0.1034,0.10234,0.10127,0.10021,0.09893,0.098905,0.098875,0.098844,0.098813,0.098782,0.098751,0.098721,0.098696,0.09866,0.098629,0.098599,0.098568,0.098538,0.098508,0.098477,0.098462,0.096999,0.096024,0.095049,0.094076,0.093103,0.09213,0.091158,0.090672,0.089229,0.088268,0.087307,0.086347,0.085388,0.084429,0.083471,0.082896,0.08287,0.082851,0.082832,0.082813,0.082795,0.082776,0.082757,0.082742,0.081652,0.080745,0.079838,0.078932,0.078026,0.077121,0.076216,0.07504,0.075029,0.075013,0.074997,0.07498,0.074964,0.074948,0.074932,0.074916,0.0749,0.074038,0.073177,0.072317,0.071456,0.070597,0.069737,0.068879,0.06802,0.067248,0.067231,0.067215,0.067199,0.067183,0.067167,0.067151,0.067136,0.06712,0.067104,0.066289,0.065474,0.06466,0.063846,0.063032,0.062218,0.061405,0.060592,0.059536,0.059528,0.059516,0.059505,0.059493,0.059481,0.05947,0.059458,0.059446,0.059435,0.059424,0.058574,0.057802,0.057031,0.056259,0.055488,0.054718,0.053948,0.053178,0.052408,0.05187,0.051856,0.051844,0.051833,0.051822,0.051811,0.0518,0.051789,0.051778,0.051767,0.051758,0.050882,0.050153,0.049423,0.048695,0.047966,0.047238,0.04651,0.045783,0.045055,0.044256,0.044249,0.044241,0.044233,0.044225,0.044217,0.044209,0.044201,0.044193,0.044185,0.044178,0.044172,0.043283,0.042599,0.041916,0.041232,0.040549,0.039867,0.039184,0.038502,0.03782,0.037139,0.03673,0.03449,0.032893,0.031298,0.031057,0.030815,0.030574,0.030333,0.030091,0.02985,0.029609,0.029368,0.029127,0.028886,0.028639,0.028392,0.028145,0.027898,0.027651,0.027404,0.027157,0.02691,0.026664,0.026417,0.026169,0.025921,0.025674,0.025426,0.025178,0.024931,0.024683,0.024436,0.024188,0.023941,0.023723,0.023505,0.023286,0.023068,0.02285,0.022632,0.022414,0.022196,0.021979,0.021761,0.021533,0.021305,0.021077,0.020849,0.020621,0.020393,0.020165,0.019938,0.01971,0.019483,0.019296,0.019109,0.018922,0.018736,0.018549,0.018363,0.018176,0.01799,0.017804,0.017617,0.017442,0.017267,0.017092,0.016917,0.016742,0.016567,0.016392,0.016217,0.016042,0.015867,0.015704,0.015541,0.015378,0.015214,0.015051,0.014888,0.014725,0.014563,0.0144,0.014237,0.014081,0.013925,0.013769,0.013613,0.013457,0.013302,0.013146,0.01299,0.012835,0.012679,0.012531,0.012382,0.012234,0.012085,0.011937,0.011789,0.01164,0.011492,0.011344,0.011196,0.011061,0.010926,0.010791,0.010656,0.010521,0.010387,0.010252,0.010117,0.0099825,0.0098479,0.0097156,0.0095833,0.0094511,0.009319,0.0091868,0.0090547,0.0089227,0.0087906,0.0086586,0.0085267,0.0084083,0.0082899,0.0081715,0.0080532,0.0079349,0.0078167,0.0076985,0.0075803,0.0074621,0.007344,0.0072399,0.0071358,0.0070317,0.0069277,0.0068237,0.0067197,0.0066158,0.0065119,0.006408,0.0063041,0.0062088,0.0061135,0.0060182,0.0059229,0.0058277,0.0057325,0.0056373,0.0055421,0.005447,0.0053518,0.0052626,0.0051733,0.0050841,0.0049949,0.0049057,0.0048165,0.0047273,0.0046382,0.0045491,0.00446,0.0043776,0.0042951,0.0042127,0.0041303,0.004048,0.0039656,0.0038833,0.003801,0.0037187,0.0036364,0.0035656,0.0034948,0.0034241,0.0033533,0.0032826,0.0032119,0.0031412,0.0030705,0.0029998,0.0029292,0.002867,0.0028048,0.0027427,0.0026805,0.0026184,0.0025562,0.0024941,0.002432,0.0023699,0.0023078,0.0022532,0.0021987,0.0021441,0.0020896,0.002035,0.0019805,0.0019259,0.0018714,0.0018169,0.0017624,0.0017192,0.001676,0.0016328,0.0015896,0.0015464,0.0015032,0.0014601,0.0014169,0.0013738,0.0013306,0.0012943,0.0012581,0.0012218,0.0011855,0.0011493,0.001113,0.0010768,0.0010406,0.0010043,0.00096811,0.00093777,0.00090744,0.00087711,0.00084679,0.00081647,0.00078616,0.00075586,0.00072555,0.00069526,0.00066497,0.00064679,0.00062862,0.00061045,0.00059229,0.00057413,0.00055597,0.00053781,0.00051966,0.00050151,0.00048337,0.00047281,0.00046226,0.00045171,0.00044116,0.00043062,0.00042007,0.00040953,0.00039898,0.00038844,0.0003779,0.000369,0.0003601,0.00035121,0.00034231,0.00033342,0.00032453,0.00031563,0.00030674,0.00029785,0.00028896,0.00028176,0.00027456,0.00026735,0.00026015,0.00025295,0.00024575,0.00023856,0.00023136,0.00022416,0.00021697,0.00021215,0.00020733,0.00020252,0.0001977,0.00019288,0.00018806,0.00018325,0.00017843,0.00017362,0.0001688,0.00016453,0.00016026,0.00015599,0.00015171,0.00014744,0.00014317,0.0001389,0.00013463,0.00013036,0.00012609,0.00012302,0.00011994,0.00011686,0.00011378,0.00011071,0.00010763,0.00010456,0.00010148,9.8407e-005,9.5333e-005,9.2207e-005,8.908e-005,8.5954e-005,8.2829e-005,7.9704e-005,7.6579e-005,7.3454e-005,7.033e-005,6.7207e-005,6.4083e-005,6.2067e-005,6.0052e-005,5.8036e-005,5.6021e-005,5.4006e-005,5.1991e-005,4.9977e-005,4.7962e-005,4.5948e-005,4.3934e-005,4.2276e-005,4.0617e-005,3.8959e-005,3.7301e-005,3.5643e-005,3.3985e-005,3.2328e-005,3.067e-005,2.9013e-005,2.7356e-005,2.6064e-005,2.4773e-005,2.3481e-005,2.219e-005,2.0899e-005,1.9607e-005,1.8317e-005,1.7026e-005,1.5735e-005,1.4445e-005,1.343e-005,1.2415e-005,1.1401e-005,1.0386e-005,9.3718e-006,8.3576e-006,7.3434e-006,6.3295e-006,5.3156e-006,4.3018e-006,4.1117e-006,3.9216e-006,3.7315e-006,3.5414e-006,3.3513e-006,3.1613e-006,2.9713e-006,2.7813e-006,2.5913e-006,2.4014e-006}
wavelength = {0.90,0.92,0.94,0.96,0.98,1.00}
eps_r = {13.104,13.018,12.938,12.867,12.802,12.745}
eps_i = {0.015867,0.012679,0.0098479,0.007344,0.0053518,0.0036364}
flat = {0.054577541202369,
0.026257344211035,
0.010614038168868,
0.0068966898884498,
0.0067493599084283,
0.0084436558337586
}

sum = 0
-----------------initialize-----------------
FOM = {}
maxRows= 10
maxColumns = 10
for row = 1,maxRows do
    FOM[row] = {}
    for col = 1,maxColumns do
        FOM[row][col] = 0
    end
end

for k = 1,6 do  -- 700nm,720nm,740nm,760nm,780nm,800nm
    freq = 1/wavelength[k]
    S:SetFrequency(freq)
    S:SetMaterial('Silicon', {eps_r[k], eps_i[k]})
    inc, backward = S:GetPoyntingFlux('AirAbove', 0)
    forward = S:GetPoyntingFlux('AirBelow', 0)
    abspn = (inc - forward + backward) / inc
   
    if ( abspn < 0 )
    then
        print("Abnormal absorption!!!"..'\t'..(wavelength[k]*1000))
    end
    print(wavelength[k]*1000, abspn)
    sum = sum + abspn/flat[k]
end
FOM[m][n] = sum/6
-----------------------------------------------------------------------
--------------heat map print----------------
        print(xx[m]..'\t'..yy[n]..'\t'..FOM[m][n])
    end
end

