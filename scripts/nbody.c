#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

void compute_forces(double* ax, double* ay, double* az, const double* x, const double* y,
                    const double* z, const double* m, int N, double G) {
    for (int i = 0; i < N; i++) {
        double axi = 0.0, ayi = 0.0, azi = 0.0;
        double xi = x[i], yi = y[i], zi = z[i];

        for (int j = 0; j < N; j++) {
            if (i != j) {
                double rx = xi - x[j];
                double ry = yi - y[j];
                double rz = zi - z[j];
                double d = sqrt(rx * rx + ry * ry + rz * rz);
                double c = G * m[j] / (d * d * d);
                axi -= c * rx;
                ayi -= c * ry;
                azi -= c * rz;
            }
        }

        ax[i] = axi;
        ay[i] = ayi;
        az[i] = azi;
    }
}

int main() {
    // Test case: 4 particles at corners of a unit square
    double x4[] = {0.0, 1.0, 0.0, 1.0};
    double y4[] = {0.0, 0.0, 1.0, 1.0};
    double z4[] = {0.0, 0.0, 0.0, 0.0};
    double m4[] = {1.0, 1.0, 1.0, 1.0};
    double ax4[4], ay4[4], az4[4];

    compute_forces(ax4, ay4, az4, x4, y4, z4, m4, 4, 1.0);
    double checksum = 0.0;
    for (int i = 0; i < 4; i++)
        checksum += sqrt(ax4[i] * ax4[i] + ay4[i] * ay4[i] + az4[i] * az4[i]);
    printf("Checksum: %g\n", checksum);

    // Benchmark
    int N = 10000;
    double* x = malloc(N * sizeof(double));
    double* y = malloc(N * sizeof(double));
    double* z = malloc(N * sizeof(double));
    double* m = malloc(N * sizeof(double));
    double* ax = malloc(N * sizeof(double));
    double* ay = malloc(N * sizeof(double));
    double* az = malloc(N * sizeof(double));

    srand(42);
    for (int i = 0; i < N; i++) {
        x[i] = (double)rand() / RAND_MAX;
        y[i] = (double)rand() / RAND_MAX;
        z[i] = (double)rand() / RAND_MAX;
        m[i] = 1.0;
    }

    struct timeval start, end;
    gettimeofday(&start, NULL);
    compute_forces(ax, ay, az, x, y, z, m, N, 1.0);
    gettimeofday(&end, NULL);

    double elapsed = (end.tv_sec - start.tv_sec) + (end.tv_usec - start.tv_usec) / 1e6;
    printf("Time: %.4f s\n", elapsed);

    // Checksum to prevent compiler from optimizing away the computation
    double bench_checksum = 0.0;
    for (int i = 0; i < N; i++)
        bench_checksum += ax[i] + ay[i] + az[i];
    printf("Bench checksum: %g\n", bench_checksum);

    free(x);
    free(y);
    free(z);
    free(m);
    free(ax);
    free(ay);
    free(az);
    return 0;
}
