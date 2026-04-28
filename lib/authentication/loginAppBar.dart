import 'package:flutter/material.dart';

PreferredSizeWidget myAppBar() {
  return AppBar(
    title: Text("Book Store",
      style: TextStyle(fontWeight: .bold),),
    backgroundColor: Colors.greenAccent,
    automaticallyImplyLeading: false,
    centerTitle: true,
  );
}