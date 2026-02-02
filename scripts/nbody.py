import math
import random
import time


def compute_forces(ax, ay, az, x, y, z, m, G=1.0):
    N = len(m)
    for i in range(N):
        axi, ayi, azi = 0.0, 0.0, 0.0
        xi, yi, zi = x[i], y[i], z[i]

        for j in range(N):
            if i != j:
                rx = xi - x[j]
                ry = yi - y[j]
                rz = zi - z[j]
                d = math.sqrt(rx * rx + ry * ry + rz * rz)
                c = G * m[j] / (d * d * d)
                axi -= c * rx
                ayi -= c * ry
                azi -= c * rz

        ax[i] = axi
        ay[i] = ayi
        az[i] = azi


# Test case: 4 particles at corners of a unit square
x4 = [0.0, 1.0, 0.0, 1.0]
y4 = [0.0, 0.0, 1.0, 1.0]
z4 = [0.0, 0.0, 0.0, 0.0]
m4 = [1.0, 1.0, 1.0, 1.0]
ax4, ay4, az4 = [0.0] * 4, [0.0] * 4, [0.0] * 4

compute_forces(ax4, ay4, az4, x4, y4, z4, m4)
checksum = sum(math.sqrt(ax4[i] ** 2 + ay4[i] **
               2 + az4[i] ** 2) for i in range(4))
print(f"Checksum: {checksum}")

# Benchmark
N = 10_000
random.seed(42)
x = [random.random() for _ in range(N)]
y = [random.random() for _ in range(N)]
z = [random.random() for _ in range(N)]
m = [1.0] * N
ax, ay, az = [0.0] * N, [0.0] * N, [0.0] * N

start = time.time()
compute_forces(ax, ay, az, x, y, z, m)
elapsed = time.time() - start
print(f"Time: {elapsed:.4f} s")

# Checksum to prevent compiler from optimizing away the computation
bench_checksum = sum(ax) + sum(ay) + sum(az)
print(f"Bench checksum: {bench_checksum}")
