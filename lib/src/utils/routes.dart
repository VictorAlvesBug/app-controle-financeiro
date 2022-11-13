class Routes {
  static const _apiUrl = 'https://identitytoolkit.googleapis.com/v1';
  static const _apiKey = 'AIzaSyC7Lz6iFtgokQM7wYOh1DEgWGYEqolmXBw';

  static const urlRegister = '$_apiUrl/accounts:signUp?key=$_apiKey';

  static const urlLogin = '$_apiUrl/accounts:signInWithPassword?key=$_apiKey';
}