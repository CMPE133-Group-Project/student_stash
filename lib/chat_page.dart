import 'package:flutter/material.dart';
import 'package:student_stash/components/chat_bubble.dart';
import 'package:student_stash/current_session.dart';
import 'package:student_stash/main.dart';
import 'db_operations.dart';

//create parameter passed in by chat.dart
class ChatPage extends StatefulWidget {
  final String receiverName;
  final String listingID;
  final bool isSeller;
  const ChatPage({
    super.key,
    required this.receiverName, // The person the user is talking to
    required this.listingID, // The listing the chat is under
    required this.isSeller, // Is the user the seller of this listing?
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{
  final TextEditingController _messageController = TextEditingController(); // create user input for textfield

  Future<void> sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.trim().isNotEmpty) {
      String message = _messageController.text;
      _messageController.text = "sending...";

      if (widget.isSeller == true){ // if current user is the owner of the listing of the conversation
        await DbOperations.sendMessage(widget.listingID,  message, widget.receiverName);
        await fetchMessageOrder(widget.listingID, widget.receiverName);
      } else { // current user is not the owner of the listing of the conversation
        await DbOperations.sendMessage(widget.listingID,  message, CurrentSession.getCurrentName());
        await fetchMessageOrder(widget.listingID, CurrentSession.getCurrentName());
      }

      setState(() {}); // refresh chat page
      _messageController.clear(); // clear textfield
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverName)),
      body: Column(
        children: [

          // messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildMessageInput(),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    final children = <Widget>[];

    // loops through series of messages under listing and display them accordingly
    for (int i = messages.length - 1; i >= 0; i--) {
      List messageInfos = messages[i];

      String messageOwner = messageInfos[0];
      String messageContent = messageInfos[1];
      String messageTimestamp = messageInfos[2];
  
      if (messageOwner == CurrentSession.getCurrentName()) { // If the message belong to current user, the name will be displayed as "You"
        messageOwner = "You";
      }

      children.add(_buildMessageItem(messageOwner, messageContent, messageTimestamp));
    }
  
    return ListView(
      shrinkWrap: true,
      reverse: true, // This helps make the message pop up from the bottom so the user does not have to scroll to the bottom when sending a new message
      children: children,
    );
  }

  // build message item
  Widget _buildMessageItem(String owner, String content, String timestamp) {
    // align the messages to the right if the sender is the current user, otherwise to the left
    var alignment = (owner == CurrentSession.currentName || owner == "You")
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (owner == CurrentSession.currentName || owner == "You") 
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (owner == CurrentSession.currentName || owner == "You")
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(owner),
            const SizedBox(height: 5),
            ChatBubble(owner: owner, message: content),
            Text(timestamp),
          ]
        ),
      ),
    );
  }

  // build message input
  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          // textfield
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Enter Message'),
              obscureText: false,
            ),
          ),

          // send button
          IconButton(
            onPressed: () async {sendMessage();},
            icon: const Icon(
              Icons.send,
              size: 40,
            ), 
          )
        ],
      ),
    );
  }
}

