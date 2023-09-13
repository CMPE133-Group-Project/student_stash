import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(

        appBar: AppBar(

          centerTitle: true,
          backgroundColor: Colors.indigo,
          title: const Text('STUDENT STASH'),

          leading: GestureDetector(
            onTap: () {},
            child: Icon(Icons.menu,),
          ),

          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon( Icons.person, ),
              )
            )
          ]

        ),

        bottomNavigationBar: BottomNavigationBar(

          items: const <BottomNavigationBarItem>[

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              label: 'Shop',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.sell),
              label: 'Sell',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),

          ],

          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.indigo,
        ),

        body: Column(
          children: [
            const Center(
              child: Padding(
                child: Text('Hello'),
                padding: EdgeInsets.all(10),
              )

            )
          ]
        ),
      ),
    );
  }
}
