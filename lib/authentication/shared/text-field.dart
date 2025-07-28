import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../models/user.dart';

class TextFieldShared extends StatelessWidget {
  const TextFieldShared({
    super.key,
    required this.controller,
    required this.user,
    required this.fieldName,
  });

  final TextEditingController controller;
  final Users user;
  final String fieldName;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppLocalizations.of(context)!.vildot;
        }
        return null;
      },
      controller: controller,
      onChanged: (value) {
        _updateUser(value, fieldName);
      },
      onSaved: (value) {
        _updateUser(value!, fieldName);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: _getHintText(context, fieldName),
      ),
    );
  }

  void _updateUser(String value, String fieldName) {
    switch (fieldName) {
      case 'username':
        user.username = value;
        break;
      case 'password':
        user.password = value;
        break;
      case 'fullname':
        user.fullname = value;
        break;
      case 'email':
        user.email = value;
        break;
      case 'phone':
        user.phoneNumber = value;
        break;
    }
  }

  String _getHintText(BuildContext context, String fieldName) {
    switch (fieldName) {
      case 'username':
        return AppLocalizations.of(context)!.usernamePlaceHoldar;
      case 'password':
        return AppLocalizations.of(context)!.passwordPlaceHoldar;
      case 'fullname':
        return AppLocalizations.of(context)!.fullnamePlaceHoldar;
      case 'email':
        return AppLocalizations.of(context)!.emailPlaceHoldar;
      case 'phone':
        return AppLocalizations.of(context)!.phoneNumberPlaceHoldar;
      default:
        return '';
    }
  }
}
