class Routes {
  static const _firebaseUrl = 'https://identitytoolkit.googleapis.com/v1';
  static const _apiKey = 'AIzaSyC7Lz6iFtgokQM7wYOh1DEgWGYEqolmXBw';

  static const urlRegister = '$_firebaseUrl/accounts:signUp?key=$_apiKey';
  static const urlLogin = '$_firebaseUrl/accounts:signInWithPassword?key=$_apiKey';
}