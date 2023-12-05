class User {
  final String first;
  final String last;
  final String email;
  final String encryptedPass;
  final double rating = 5.0;

  User(this.first, this.last, this.email, this.encryptedPass);
}