class User {
  late String email ;
  late String motDepasse;
  late bool isAdmin = false;
  late image = "";
  void set_status(bool status) {
    isAdmin = status;
  }

  User({required this.email, required this.motDepasse, required this.image});
}
