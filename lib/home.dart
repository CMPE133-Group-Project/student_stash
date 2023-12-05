import 'package:flutter/material.dart';
import 'package:student_stash/current_session.dart';
import 'db_operations.dart';
import 'current_session.dart';

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
                  List<List> l = await DbOperations.retreiveUserListings(
                      CurrentSession.getCurrentName());
                  for (int i = 0; i < l.length; i++) {
                    List ll = l[i];
                    print(ll[0] + " " + ll[1] + " " + ll[2].toString());
                  }
                },
                child: Text('Print all'),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<List> l = await DbOperations.readMessages(
                      "1699847552664", CurrentSession.currentName);
                  for (int i = 0; i < l.length; i++) {
                    List ll = l[i];
                    print(ll[0] + " " + ll[1] + " " + ll[2] + " " + ll[3]);
                  }
                },
                child: const Text('Read Messages'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await DbOperations.sendMessage(
                      "1699847552664", "Hey boss", 'tyler');
                },
                child: const Text('Add Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
