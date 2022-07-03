void Verlet_init(char);
typedef struct VSR {
  double p1x;
  double p1y;
  double p2x;
  double p2y;
  char rm;
} Verlet_SolveResult;
Verlet_SolveResult Verlet_solve(double p1x, double p1y, double p2x, double p2y,
                      double tear_sensitivity, double resting_distance,
                      double scalar_p1, double scalar_p2);
