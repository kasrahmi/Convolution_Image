def main():
    filename = "convolution_test.txt"
    output_filename = "pythonConv_output.txt"

    with open(filename, 'r') as file:
        lines = file.readlines()

        n = int(lines[0].strip())

        matrix_lines = lines[1:n+1]
        matrix = [list(map(float, line.strip().split())) for line in matrix_lines]

        kernel_lines = lines[n+1:n+4]
        kernel = [list(map(float, line.strip().split())) for line in kernel_lines]

    padded_matrix = pad_matrix(matrix, n)
    result = perform_convolution(padded_matrix, kernel, n)

    write_matrix_to_file(output_filename, result)

# Function for creating the padded matrix
def pad_matrix(matrix, n):
    padded_matrix = [[0.0] * (n + 2) for _ in range(n + 2)]

    # Copy original matrix into the center of padded matrix
    for i in range(n):
        for j in range(n):
            padded_matrix[i + 1][j + 1] = matrix[i][j]

    # Pad the edges using the described pattern
    for i in range(n):
        padded_matrix[0][i+1] = padded_matrix[1][i+1]
        padded_matrix[i + 1][0] = padded_matrix[i + 1][1]
        padded_matrix[n + 1][i + 1] = padded_matrix[n][i + 1]
        padded_matrix[i+1][n + 1] = padded_matrix[i+1][n]

    # Fill the corners
    padded_matrix[0][0] = padded_matrix[1][1]
    padded_matrix[0][n + 1] = padded_matrix[1][n]
    padded_matrix[n + 1][0] = padded_matrix[n][1]
    padded_matrix[n + 1][n + 1] = padded_matrix[n][n]

    return padded_matrix

# Function to do the convolution
def perform_convolution(matrix, kernel, n):
    result = [[0.0] * n for _ in range(n)]

    for i in range(1, n + 1):
        for j in range(1, n + 1):
            result[i - 1][j - 1] = convolve(matrix, kernel, i, j)

    return result

# Function for calculating the convolution of two matrices
def convolve(matrix, kernel, row, col):
    sum_val = 0.0

    for i in range(3):
        for j in range(3):
            sum_val += matrix[row + i - 1][col + j - 1] * kernel[i][j]

    return sum_val

# Function to write the result matrix to a file
def write_matrix_to_file(filename, matrix):
    with open(filename, 'w') as file:
        for row in matrix:
            file.write(" ".join(map(str, row)) + "\n")

if __name__ == "__main__":
    main()
