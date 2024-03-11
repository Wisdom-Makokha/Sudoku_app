import "dart:math";

class Sudoku {
  ///constructors
  Sudoku({required int difficulty, required int size})
      : _difficulty = difficulty,
        _size = size,
        _boxSize = sqrt(size) as num,
        _fullGrid = List.generate(
          size,
          (int index) => List.generate(
            size,
            (int index) => null,
            growable: false,
          ),
          growable: false,
        );

  ///properties
  //used to set the number of rows, columns and boxes
  final int _size;
  final num _boxSize;
  final int _difficulty;
  //The set
  final List<List<int?>> _fullGrid;

  ///getters
  List<List<int?>> get sudokuGrid => _fullGrid;

  ///setters

  ///methods
  //need methods to create the sudoku grid
  //for now stick to the previous tactic of filling squares diagonally
  //create the methods to check the row, column, a grid

  //method to check if a row already contains a number
  bool _checkRow({required int row, required int number}) {
    if (sudokuGrid[row].contains(number)) {
      //do not proceed with addition
      print("$number already exists in row:$row, $number cannot be added");
      return true;
    } else {
      //proceed with addition
      print("$number does not exist in row:$row, $number can be added");
      return false;
    }
  }

  //method to check if a number already exists in a column
  bool _checkColumn({required int column, required int number}) {
    for (int index = 0; index < _size; index++) {
      if (number == sudokuGrid[index][column]) {
        print(
            //do not proceed with addition
            "$number already exists in column $column, $number cannot be added");
        return true;
      }
    }

    //proceed with addition
    print("$number does not exist in column: $column, $number can be added");
    return false;
  }

  //method to check if a number is safe to add to a box
  bool _checkBox({required int row, required int column, required int number}) {
    int rowStart = row - (row % 3);
    int columnStart = column - (column % 3);

    for (int rowIndex = rowStart; rowIndex < _boxSize; rowIndex++) {
      for (int columnIndex = columnStart; columnIndex < _boxSize; columnIndex) {
        if (number == sudokuGrid[rowIndex][columnIndex]) {
          //do not proceed with addition
          print("$number already exists in box, $number cannot be added");
          return true;
        }
      }
    }

    //proceed with addition
    print("$number does not exist in box, $number can be added");
    return false;
  }

  //method to check if a number is safe to put in a row, column and box
  //it combines the above three methods
  bool _checkIfSafe(
      {required int row, required int column, required int number}) {
    if (!_checkRow(row: row, number: number) &&
        !_checkColumn(column: column, number: number) &&
        !_checkBox(row: row, column: column, number: number)) {
      //proceed with addition
      return true;
    } else {
      //do not proceed with addition
      return false;
    }
  }

  void _fillBox(rowStart, columnStart) {
    List<int> probabilityCheck = List<int>.generate(
      _size,
      (int index) => 1,
      growable: false,
    );
    int foundCount = 0;
    int number;
    bool isSafe;
    bool limitSelection = true;

    for (int rowIndex = 0; rowIndex < _boxSize; rowIndex++, foundCount++) {
      for (int columnIndex = 0; columnIndex < _boxSize; columnIndex++) {
        do {
          number = _randomNumber(
            probabilityCheck: probabilityCheck,
            limitSelection: limitSelection,
          );
          isSafe = _checkIfSafe(
            row: rowStart + rowIndex,
            column: columnStart + columnIndex,
            number: number,
          );
        } while (!isSafe && foundCount != 8);

        _fullGrid[rowStart + rowIndex][columnStart + columnIndex] = number;
      }
    }
  }

  //this method returns a random number between 1 and 9
  //it has the option to prevent previously selected numbers from being selected
  //again
  //the "limit" parameter does this
  int _randomNumber(
      {List<int>? probabilityCheck, required bool limitSelection}) {
    int selectedNumber = Random().nextInt(_size);
    int largestValue = 0;
    int randomMax = 100;

    List<int> offset = List.generate(
      _size,
      //a random value multiplied by an element in probabilityCheck to limit it
      (int index) {
        int check = 1;
        if(probabilityCheck != null) {
          check = probabilityCheck[index];
        }

        return Random().nextInt(randomMax) * check;
      },
      growable: false,
    );

    for (int index = 0; index < _size; index++) {
      if (offset[index] > largestValue) {
        largestValue = offset[index];
        selectedNumber = index;
      }
    }

    //this section is used to prevent previously selected values from being
    //returned by reducing their probability to zero in "probabilityCheck
    if (limitSelection && (probabilityCheck != null)) {
      probabilityCheck[selectedNumber] = 0;
    }

    return (selectedNumber + 1);
  }

  //this method removes digits from a solved grid to implement difficulty
  void removeDigits() {
    int toBeRemovedCount = _difficulty;
    bool limitSelection = false;

    while(toBeRemovedCount != 0) {
      final int row = _randomNumber(limitSelection: limitSelection);
      final int column = _randomNumber(limitSelection: limitSelection);

      if(sudokuGrid[row][column] != 0) {
        toBeRemovedCount--;
        _fullGrid[row][column] = null;
      }
    }
  }

  //method to solve the grid to have a complete grid
  bool solve({required int row, required int column}) {
    if(row == (_size - 1) && column == _size) {
      return true;
    }

    if(column == _size) {
      row++;
      column = 0;
    }

    if(sudokuGrid[row][column] != null) {
      return solve(row: row, column: column);
    }

    for(int number = 1; number <= _size; number++) {
      if(_checkIfSafe(row: row, column: column, number: number)) {
        _fullGrid[row][column] = number;

        if(solve(row: row, column: column + 1) == true) {
          return true;
        }

        _fullGrid[row][column] = null;
      }
    }

    return false;
  }

  @override
  String toString() {
    String grid = "";

    for(int rowIndex = 0; rowIndex < _size; rowIndex++){
      for(int columnIndex = 0; columnIndex < _size; columnIndex) {
        if(sudokuGrid[rowIndex][columnIndex] == null) {
          grid += " ";
        } else {
          grid += sudokuGrid[rowIndex][columnIndex].toString();
        }

        grid += ", ";
      }
      grid += "\n";
    }
    return grid;
  }
}

void main() {
  final myGrid = Sudoku(difficulty: 15, size: 9);
  print(myGrid);
}
