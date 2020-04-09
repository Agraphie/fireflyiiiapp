import 'package:flutter/material.dart';

Gradient themeGradient(BuildContext context) => LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Theme.of(context).accentColor, Theme.of(context).primaryColor]);
