import 'package:flutter/material.dart';
import 'package:teachar_app/l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../shared/text-field.dart';
import '../view_models/authentication_view_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.change, required this.cruuntLang});
  Function change;
  var cruuntLang;

  @override
  State<LoginPage> createState() =>
      _LoginPageState(change: change, cruuntLang: cruuntLang);
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController fullnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  final storage = FlutterSecureStorage();
  Function change;
  var cruuntLang;

  _LoginPageState({required this.change, required this.cruuntLang});

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    fullnameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthenticationViewModel>(context);
    bool isRegisterMode = authViewModel.isRegisterMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
        leading: IconButton(
          onPressed: () => change(),
          icon: Icon(Icons.language),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.88,
                child: Container(
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/logo-dark.png',
                            width: 150,
                            height: 150,
                          ),

                          Text(
                            AppLocalizations.of(context)!.loginWelcomeMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          if (isRegisterMode)
                            buildField(
                              AppLocalizations.of(context)!.fullname,
                              fullnameController,
                              'fullname',
                            ),
                          if (isRegisterMode)
                            buildField(
                              AppLocalizations.of(context)!.email,
                              emailController,
                              'email',
                            ),
                          if (isRegisterMode)
                            buildField(
                              AppLocalizations.of(context)!.phoneNumber,
                              phoneController,
                              'phoneNumber',
                            ),
                          buildField(
                            AppLocalizations.of(context)!.username,
                            usernameController,
                            'username',
                          ),
                          buildField(
                            AppLocalizations.of(context)!.password,
                            passwordController,
                            'password',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape:
                                      WidgetStateProperty.all<
                                        RoundedRectangleBorder
                                      >(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18.0,
                                          ),
                                        ),
                                      ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    authViewModel.user.username =
                                        usernameController.text;
                                    authViewModel.user.password =
                                        passwordController.text;
                                    authViewModel.user.fullname =
                                        fullnameController.text;
                                    authViewModel.user.email =
                                        emailController.text;
                                    authViewModel.user.phoneNumber =
                                        phoneController.text;

                                    await authViewModel.loginOrRegister(
                                      context,
                                    );

                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                            authViewModel.resultMsg,
                                          ),
                                          actions: [
                                            Center(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  if (!isRegisterMode &&
                                                      authViewModel.resultMsg ==
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.loginSucessMsg) {
                                                    Navigator.pushReplacementNamed(
                                                      context,
                                                      '/main',
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.ok,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Text(
                                  isRegisterMode
                                      ? AppLocalizations.of(context)!.regester2
                                      : AppLocalizations.of(context)!.login,
                                ),
                              ),
                              if (!isRegisterMode)
                                IconButton(
                                  icon: Icon(Icons.fingerprint, size: 36),
                                  tooltip: AppLocalizations.of(context)!.login,
                                  onPressed: () async {
                                    bool isAuthenticated = await authViewModel
                                        .biometricLogin(context);
                                    if (isAuthenticated) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/main',
                                      );
                                    } else {
                                      print("Biometric login failed");
                                    }
                                  },
                                ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              authViewModel.clearUser();
                              authViewModel.toggleMode();
                            },
                            child: Text(
                              isRegisterMode
                                  ? AppLocalizations.of(context)!.backToLogin
                                  : AppLocalizations.of(context)!.regester,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller,
    String fieldName,
  ) {
    final authViewModel = Provider.of<AuthenticationViewModel>(
      context,
      listen: false,
    );
    return Column(
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFieldShared(
            controller: controller,
            user: authViewModel.user,
            fieldName: fieldName,
          ),
        ),
      ],
    );
  }
}
