import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'db_operations.dart';

// Pages
import 'login.dart';

// Views
import 'shop.dart';
import 'sell.dart';
import 'chat.dart';

// Widgets
import 'appbar.dart';

List<List> messages = [];
Future<List<List>> fetchMessageOrder(String listingID, userId) async {
  messages = [];

  messages = await DbOperations.readMessages(listingID, userId);
  return messages;
}

List<List> listingIDs = [];
Future<void> fetchListingOrder() async {
  listingIDs = [];

  listingIDs = await DbOperations.retreiveListings();
}

List listingIDsAsBuyer = [];
List listingIDsAsSeller = [];
Future<void> fetchListingMessages() async {
  listingIDsAsBuyer = [];
  listingIDsAsSeller = [];

  listingIDsAsBuyer = await DbOperations.getMessagesAsBuyer();
  listingIDsAsSeller = await DbOperations.getMessagesAsSeller();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
  await fetchListingOrder();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
      },
      theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          // ···
          brightness: Brightness.light,
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.righteous(
            fontSize: 30,
          ),
          bodyMedium: GoogleFonts.righteous(),
          displaySmall: GoogleFonts.righteous(),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  //static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    const Shop(),
    const Sell(),
    const Chat(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.indigo,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shop',
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
