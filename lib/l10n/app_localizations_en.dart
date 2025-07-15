import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get login => 'Login';

  @override
  String get usernamePlaceHoldar => 'Enter your Username';

  @override
  String get passwordPlaceHoldar => 'Enter your Password';

  @override
  String get fullnamePlaceHoldar => 'Enter your Fullname';

  @override
  String get emailPlaceHoldar => 'Enter your Email';

  @override
  String get regester => 'Dont have an acount ? sign up ';

  @override
  String get username => 'Username';

  @override
  String get email => 'Email';

  @override
  String get fullname => 'Full Name';

  @override
  String get password => 'Password';

  @override
  String get regester2 => 'sign up';

  @override
  String get sucsessRegesterMsg => 'Sing up worked! go ahed for sign in';

  @override
  String get loginSucessMsg => 'Welcome! Login successful';

  @override
  String get loginFailedMsg => 'Login failed. Please try again.';

  @override
  String get phoneNumberPlaceHoldar => 'Enter your Phone Number';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get ok => 'OK';

  @override
  String get vildot => 'plz enter data';

  @override
  String get usernameAlreadyExists => 'This username is already taken.';
}
