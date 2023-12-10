import 'package:student_stash/user.dart';

class Item {
  final User seller;
  final String title;
  final double price;
  final String imgURL;
  final String desc;
  final String id;

  Item(this.seller, this.title, this.price, this.imgURL, this.desc, this.id);
}
