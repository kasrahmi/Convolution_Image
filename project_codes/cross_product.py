def read_matrix_from_file(filename):
    with open(filename, "r") as f:
        n = int(f.readline())
        matrix1 = []
        matrix2 = []
        for _ in range(n):
            matrix1.append(list(map(int, f.readline().split())))
        for _ in range(n):
            matrix2.append(list(map(int, f.readline().split())))
    return matrix1, matrix2

def cross_product(matrix1, matrix2):
    n = len(matrix1)
    result = [[0] * n for _ in range(n)]
    for i in range(n):
        for j in range(n):
            for k in range(n):
                result[i][j] += matrix1[i][k] * matrix2[k][j]
    return result

def write_to_file(matrix):
    with open("cross_product.txt", "w") as f:
        for row in matrix:
            f.write(' '.join(map(str, row)) + '\n')

def main():
    filename = "matrix.txt"  # Specify the filename here

    matrix1, matrix2 = read_matrix_from_file(filename)

    if matrix1 is None or matrix2 is None:
        print("Error: Failed to read input matrices.")
        return
    
    if len(matrix1) != len(matrix2) or any(len(row) != len(matrix1) for row in matrix1) or any(len(row) != len(matrix2) for row in matrix2):
        print("Error: Matrices must be of the same size.")
        return

    result = cross_product(matrix1, matrix2)
    write_to_file(result)
    print("Cross product written to 'cross_product.txt'.")

if __name__ == "__main__":
    main()
