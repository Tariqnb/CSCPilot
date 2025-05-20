import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  final Color customColor = Color.fromARGB(255, 233, 222, 255); 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        primaryColor: customColor,
        appBarTheme: AppBarTheme(
          backgroundColor: customColor,
          foregroundColor: Colors.black,  
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: customColor,
          foregroundColor: Colors.black,  
        ),
      ),
      home: DashboardHome(),
    );
  }
}
class DashboardHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Visualization Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Interactive Data Visualization Dashboard',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Pressed!');
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
