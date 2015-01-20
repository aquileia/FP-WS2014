a = 2e-6 * 2*pi*5000;
yf = filter(a, [1 a-1], y);