import 'package:flutter/material.dart';
import 'package:student_stash/current_session.dart';
import 'db_operations.dart';


class Chat extends StatelessWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: const FlutterLogo(size: 50.0),
              title: const Text("Person's first and last name here"),
              subtitle: const Text("Most Recent Message"),
              trailing: const Icon(Icons.more_vert),
              onTap: (){

              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const FlutterLogo(size: 50.0),
              title: const Text('Andy Nguyen'),
              subtitle: const Text("You: Dude, it has been 3 weeks. Are you going to buy or not?"),
              trailing: const Icon(Icons.more_vert),
              onTap: (){

              },
            ),
          ),
          
          Card(
            child: ListTile(
              leading: const FlutterLogo(size: 50.0),
              title: const Text('Valorant Players'),
              subtitle: const Text("Jayce: I will meet you at student union."),
              trailing: const Icon(Icons.more_vert),

              onTap: (){
                
              },
            ),
          ),
        ],
      ),
    );
  }
}