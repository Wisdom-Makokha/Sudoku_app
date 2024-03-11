import 'package:flutter/material.dart';
import 'package:sudoku_flutter/Screens/main_screen.dart';

void main()
{
  runApp(const SudokuApp()) ;
}

class SudokuApp extends StatelessWidget{
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Sudoku',
      theme: ThemeData(
        primaryColor:Colors.blueAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}