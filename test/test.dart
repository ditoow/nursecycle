bool isEmailValid(String email) {
  if (email.trim().isEmpty) {
    return false;
  }
  if (!email.trim().contains("@")) {
    return false;
  }
}
