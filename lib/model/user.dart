class User {
  String email = "";
  String motDepasse = "";
  bool isAdmin = false;
  String image = "";
  void set_status(bool status) {
    isAdmin = status;
  }

  User({required this.email, required this.motDepasse, required this.image});
}
