#include <iostream>
#include "coin/ClpSimplex.hpp"
#include "coin/CoinPackedMatrix.hpp"

int main() {
    ClpSimplex model;
    
    // Configuração do problema
    const int numCols = 3;
    double objective[] = {2.16, 1.26, 0.812};  // Coeficientes da FO
    
    // Matriz de restrições (row-ordered)
    CoinPackedMatrix matrix(false, 0, 0);
    matrix.setDimensions(0, numCols);

    // Restrições (formato CSR)
    {
        int idx1[] = {0}; double val1[] = {1.0};  // x1 ≥ 400
        int idx2[] = {1}; double val2[] = {1.0};  // x2 ≥ 800
        int idx3[] = {2}; double val3[] = {1.0};  // x3 ≥ 10000
        int idx4[] = {0,1,2}; double val4[] = {1.0,1.0,1.0};  // x1+x2+x3 ≤ 200000
        int idx5[] = {0,1,2}; double val5[] = {0.2,0.3,0.4};  // 0.2x1+0.3x2+0.4x3 ≤ 60000
        
        matrix.appendRow(1, idx1, val1);
        matrix.appendRow(1, idx2, val2);
        matrix.appendRow(1, idx3, val3);
        matrix.appendRow(3, idx4, val4);
        matrix.appendRow(3, idx5, val5);
    }

    // Limites
    double rowLower[] = {400, 800, 10000, -COIN_DBL_MAX, -COIN_DBL_MAX};
    double rowUpper[] = {COIN_DBL_MAX, COIN_DBL_MAX, COIN_DBL_MAX, 200000, 60000};
    double colLower[] = {0.0, 0.0, 0.0};
    double colUpper[] = {COIN_DBL_MAX, COIN_DBL_MAX, COIN_DBL_MAX};

    // Resolução
    model.loadProblem(matrix, colLower, colUpper, objective, rowLower, rowUpper);
    model.setOptimizationDirection(-1);  // Maximização
    model.primal();

    // Output
    std::cout << "Valor ótimo: " << model.objectiveValue() << "\n";
    const double* sol = model.primalColumnSolution();
    std::cout << "Solução:\n"
              << "x1 = " << sol[0] << "\n"
              << "x2 = " << sol[1] << "\n" 
              << "x3 = " << sol[2] << std::endl;

    return 0;
}