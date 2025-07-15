import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_4/l10n/app_localizations.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'database/database.dart';
import 'services/user.service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.change, required this.cruuntLang});
  Function change;
  var cruuntLang;
  @override
  State<LoginPage> createState() =>
      _LoginPageState(change: change, cruuntLang: cruuntLang);
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState({required this.change, required this.cruuntLang});
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController fullnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  Function change;
  var cruuntLang;
  Users user = new Users(
      username: '', password: '', fullname: '', email: '', phoneNumber: '');
  bool isRegesterMode = false;
  String resultMsg = "";

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    fullnameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  void clear() {
    usernameController.clear();
    passwordController.clear();
    fullnameController.clear();
    emailController.clear();
    phoneController.clear();
    user = new Users(
        username: '', password: '', fullname: '', email: '', phoneNumber: '');
  }

  Future<String> loginRegester(user, BuildContext context) async {
    if (!isRegesterMode) {
      bool x =
          await DatabaseHelper.instance.checkUser(user.username, user.password);
      if (x) {
        Users? user6= await DatabaseHelper.instance.getUserByUsername(user.username);
        if(user6!=null)
        print(user6.fullname.toString());
        else print("no user found");
        return resultMsg =
            AppLocalizations.of(context as BuildContext)!.loginSucessMsg;
      } else {
        return resultMsg =
            AppLocalizations.of(context as BuildContext)!.loginFailedMsg;
      }
    } else {
      try {
        bool exists =
            await DatabaseHelper.instance.isUsernameExit(user.username);
        if (exists) {
          return resultMsg = AppLocalizations.of(context)!.usernameAlreadyExists;
        }
        await DatabaseHelper.instance.addUser(user);

        setState(() {
          this.clear();
          isRegesterMode = false;
        });
        return resultMsg =
            AppLocalizations.of(context as BuildContext)!.sucsessRegesterMsg;
      } catch (e) {
        print(e);
        return resultMsg =
            AppLocalizations.of(context as BuildContext)!.loginFailedMsg;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.login),
          leading: IconButton(
            onPressed: () => {change()},
            icon: Icon(Icons.language),
          )),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
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
                          child: TextFormField(
                            controller: fullnameController,
                            onSaved: (value) {
                              user.fullname = value!;
                            },
                            onChanged: (value) {
                              user.fullname = value!;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              hintText: AppLocalizations.of(context)!
                                  .fullnamePlaceHoldar,
                            ),
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
                          child: TextFormField(
                            controller: emailController,
                            onSaved: (value) {
                              user.email = value!;
                            },
                            onChanged: (value) {
                              user.email = value!;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              hintText: AppLocalizations.of(context)!
                                  .emailPlaceHoldar,
                            ),
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
                          AppLocalizations.of(context)!.phoneNumber,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: phoneController,
                            onSaved: (value) {
                              user.phoneNumber = value!;
                            },
                            onChanged: (value) {
                              user.phoneNumber = value!;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              hintText: AppLocalizations.of(context)!
                                  .phoneNumberPlaceHoldar,
                            ),
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
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.vildot;
                        }
                        return null;
                      },
                      controller: usernameController,
                      onSaved: (value) {
                        user.username = value!;
                      },
                      onChanged: (value) {
                        user.username = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText:
                            AppLocalizations.of(context)!.usernamePlaceHoldar,
                      ),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.password,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.vildot;
                        }
                        return null;
                      },
                      controller: passwordController,
                      onChanged: (value) {
                        user.password = value!;
                      },
                      onSaved: (value) {
                        user.password = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText:
                            AppLocalizations.of(context)!.passwordPlaceHoldar,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.purple),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  content: FutureBuilder(
                                    future: loginRegester(user, context),
                                    builder: (context, snapshot) {
                                      return Text(resultMsg);
                                    },
                                  ),
                                  actions: [
                                    Center(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .ok)),
                                    ),
                                  ]);
                            },
                          );
                        }
                      },
                      child: Text(!isRegesterMode
                          ? AppLocalizations.of(context)!.login
                          : AppLocalizations.of(context)!.regester2),
                    ),
                  ),
                  Visibility(
                    visible: !isRegesterMode,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: TextButton(
                          onPressed: () async {
                            setState(() {
                              isRegesterMode = true;
                            });
                            // await DatabaseHelper.instance.addUser(user);
                          },
                          child: Text(AppLocalizations.of(context)!.regester)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
