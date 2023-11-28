import 'package:student_stash/user.dart';

class Item {
  final User seller;
  final String title;
  final double price;
  final String imgLocation;
  final String desc;

  Item(this.seller, this.title, this.price, this.imgLocation, this.desc);
}