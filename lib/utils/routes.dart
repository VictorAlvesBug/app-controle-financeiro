class Routes{
  static const _apiKey = 'AIzaSyC7Lz6iFtgokQM7wYOh1DEgWGYEqolmXBw';

  static const urlRegister = 
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKey';
  
  static const urlLogin = 
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey';
}