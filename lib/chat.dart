import 'package:flutter/material.dart';
import 'package:student_stash/chat_page.dart';
import 'package:student_stash/current_session.dart';
import 'main.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  Future<void> loadMessage(String listingID, String userID) async {
    await fetchMessageOrder(listingID, userID);
  }

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      body: _buildUserList(),
    );
  }

  // build a list of users except for the current login user
  Widget _buildUserList() {
    final children = <Widget>[];

    for (List listingMessageInfo in listingIDsAsBuyer) { // loop through listing messages as a buyer to display chat tabs
      String listingID = listingMessageInfo[0];
      String listingName = listingMessageInfo[1];
      String receiverName = listingMessageInfo[2];

      if (receiverName == CurrentSession.getCurrentName()) { // Do not display chat tabs that contains conversation of themselves (This should not happen, but is here as a precaution)
        continue;
      }

      String listingImage = "";

      for (int i = 0; i < listingIDs.length; i++) { // Find the image that belong to this listing
        if (listingIDs[i][0] == listingID) {
          listingImage = listingIDs[i][4];
        }
      }

      children.add(_buildUserListItem(
        context,
        listingID, // listingId
        receiverName, // receiverName
        listingImage, // listingImage
        false, // isSeller
        //lastRecentMessage
        listingName // listing name
      ));
    }

    for (List listingMessageInfo in listingIDsAsSeller) { // loop through listing messages as a seller to display chat tabs
      String listingID = listingMessageInfo[0];
      String listingName = listingMessageInfo[1];
      String receiverName = listingMessageInfo[2];

      if (receiverName == CurrentSession.getCurrentName()) { // Do not display chat tabs that contains conversation of themselves (This should not happen, but is here as a precaution)
        continue;
      }

      String listingImage = "";

      for (int i = 0; i < listingIDs.length; i++) { // Find the image that belong to this listing
        if (listingIDs[i][0] == listingID) {
          listingImage = listingIDs[i][4];
        }
      }

      children.add(_buildUserListItem(
        context,
        listingID, // listingId
        receiverName, // receiverName
        listingImage, // listingImage
        true, // isSeller
        //lastRecentMessage
        listingName // listing name
      ));
    }

    return ListView(
      children: children
    );
  }

  // build individual user list items
  Widget _buildUserListItem(BuildContext context, String listingID, String receiverName, String listingImage, bool isSeller, String lastMessage) {
    return Card(
      child: ListTile(
        leading: SizedBox(
          height: 100, 
          width: 100, 
          child: Image.network(listingImage)
        ),
        title: Text(receiverName),
        subtitle: Text(lastMessage),
        trailing: const Icon(Icons.more_vert),
        onTap: () async => {
          if (isSeller == true) { // check if the current person is the seller
            await const Chat().loadMessage(listingID, receiverName)
          } else {
            await const Chat().loadMessage(listingID, CurrentSession.getCurrentName())
          },

          // ignore: use_build_context_synchronously
          Navigator.push( // go to chat page
            context, 
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverName: receiverName,
                listingID: listingID,
                isSeller: isSeller,
              ),
            ),
          )
        } 
      ),
    );
  }
}