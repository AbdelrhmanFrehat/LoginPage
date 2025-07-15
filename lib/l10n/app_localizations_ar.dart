import 'app_localizations.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get helloWorld => 'مرحبا بالعالم!';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get usernamePlaceHoldar => 'ادخل اسم المستخدم';

  @override
  String get passwordPlaceHoldar => 'ادخل كلمة المرور';

  @override
  String get fullnamePlaceHoldar => 'ادخل اسمك الكامل';

  @override
  String get emailPlaceHoldar => 'ادخل البريد الاكتروني';

  @override
  String get regester => 'ليس لديك حساب ؟ سجل الان';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get email => 'البريد الالكتروني';

  @override
  String get fullname => 'الاسم الكامل';

  @override
  String get password => 'كلمة السر';

  @override
  String get regester2 => 'انشاء حساب';

  @override
  String get sucsessRegesterMsg => 'نجح التسجيل ! انطلق الى تسجيل الدخول';

  @override
  String get loginSucessMsg => 'Welcome! Login successful';

  @override
  String get loginFailedMsg => 'Login failed. Please try again.';

  @override
  String get phoneNumberPlaceHoldar => 'ادخل رقم الهاتف';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get ok => 'حسنا';

  @override
  String get vildot => 'الرجاء ادخال المعلومات  ';

  @override
  String get usernameAlreadyExists => 'اسم المستخدم مستخدم بالفعل.';
}
