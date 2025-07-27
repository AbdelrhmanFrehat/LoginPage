import 'package:flutter/material.dart';
import 'package:flutter_application_4/l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../database/database.dart';
import '../models/user.dart';

import 'package:local_auth/local_auth.dart';
import '../shared/text-field.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
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
  final storage = FlutterSecureStorage();
  _LoginPageState({required this.change, required this.cruuntLang});
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController fullnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  Function change;
    bool _isButtonDisabled =false;

  var cruuntLang;
  Users user = new Users(
      username: '', password: '', fullname: '', email: '', phoneNumber: '');
  bool isRegesterMode = false;
  String resultMsg = "";
  final LocalAuthentication _localAuth = LocalAuthentication();
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

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

    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.login),
          leading: IconButton(
            onPressed: () => {change()},
            icon: Icon(Icons.language),
          )),
      body: LayoutBuilder(
        builder: (Context, Constraints) {
          return Center(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.88,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/image.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Form(
                          key: _formKey,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Visibility(
                                  visible: isRegesterMode,
                                  child: Column(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.fullname,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: TextFieldShared(
                                          controller: fullnameController,
                                          user: user,
                                          fieldName: 'fullname',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: isRegesterMode,
                                  child: Column(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.email,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: TextFieldShared(
                                          controller: emailController,
                                          user: user,
                                          fieldName: "email",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: isRegesterMode,
                                  child: Column(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .phoneNumber,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: TextFieldShared(
                                          controller: phoneController,
                                          user: user,
                                          fieldName: 'phoneNumber',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.username,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextFieldShared(
                                    controller: usernameController,
                                    user: user,
                                    fieldName: 'username',
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.password,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextFieldShared(
                                    controller: passwordController,
                                    user: user,
                                    fieldName: 'password',
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.purple),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
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

                                            await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: FutureBuilder(
                                                    future: authViewModel
                                                        .loginOrRegister(
                                                            context),
                                                    builder:
                                                        (context, snapshot) {
                                                      return Text(resultMsg);
                                                    },
                                                  ),
                                                  actions: [
                                                    Center(
                                                      child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .ok)),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Text(!isRegesterMode
                                            ? AppLocalizations.of(context)!
                                                .login
                                            : AppLocalizations.of(context)!
                                                .regester2),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !isRegesterMode,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: IconButton(
                                          icon:
                                              Icon(Icons.fingerprint, size: 36),
                                          tooltip: AppLocalizations.of(context)!
                                              .login,
                                          onPressed: () async {
                                            bool isAuthenticated =
                                                await authViewModel
                                                    .biometricLogin(Context);
                                            if (isAuthenticated) {
                                              Navigator.pushNamed(
                                                  context, '/profile');

                                              Users? user6 =
                                                  await DatabaseHelper.instance
                                                      .getUserByUsername(
                                                          usernameController
                                                              .text);
                                              if (user6 != null) {
                                                print(
                                                    "Welcome ${user6.fullname}");
                                                // ignore: use_build_context_synchronously
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .loginSucessMsg),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .ok),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                print("User not found");
                                              }
                                            } else {
                                              print(
                                                  "Biometric authentication failed");
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                               Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            authViewModel.clearUser;
                                
                                            isRegesterMode =
                                                isRegesterMode ? false : true;
                                          });
                                          // await DatabaseHelper.instance.addUser(user);
                                        },
                                        child: Text(isRegesterMode
                                            ? AppLocalizations.of(context)!
                                                .backToLogin
                                            : AppLocalizations.of(context)!
                                                .regester)),
                                  ),
                                
                              ],
                            ),
                          ),
                        ),
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
}
