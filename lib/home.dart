import 'package:flutter/material.dart';
import 'db_operations.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sell Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  List<List> l = await DbOperations.retreiveListings();
                  for (int i = 0; i < l.length; i++) {
                    List ll = l[i];
                    print(ll[0] + " " + ll[1] + " " + ll[2].toString());
                  }
                },
                child: Text('Print all'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
