import 'package:flutter/material.dart';
import 'package:student_stash/components/chat_bubble.dart';
import 'package:student_stash/current_session.dart';
import 'package:student_stash/main.dart';
import 'db_operations.dart';

class ChatPage extends StatefulWidget {
  final String receiverName;
  final String listingID;
  final bool isSeller;
  const ChatPage({
    super.key,
    required this.receiverName,
    required this.listingID,
    required this.isSeller,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{
  final TextEditingController _messageController = TextEditingController();
  //final ChatService _chatService = ChatService();
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //final ScrollController _controller = ScrollController();

  // void _scrollDown() {
  //   _controller.jumpTo(_controller.position.maxScrollExtent);
  // }
  
  Future<void> sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
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

    for (int i = messages.length - 1; i >= 0; i--) {
      List messageInfos = messages[i];

      String messageOwner = messageInfos[0];
      String messageContent = messageInfos[1];
      String messageTimestamp = messageInfos[2];
  
      if (messageOwner == CurrentSession.getCurrentName()) {
        messageOwner = "You";
      }

      children.add(_buildMessageItem(messageOwner, messageContent, messageTimestamp));
    }
  
    return ListView(
      shrinkWrap: true,
      reverse: true,
      children: children,
    );
  }

  // build message item
  Widget _buildMessageItem(String owner, String content, String timestamp) {
    //Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align the messages to the right if the sender is the current user, otherwise to the left
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
            // Original Below: Text(data['senderEmail']),
            Text(owner),
            const SizedBox(height: 5),
            // Original Below: ChatBubble(message: data['message']),
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

