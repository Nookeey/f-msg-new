import 'package:flutter/material.dart';

import '../models/user.dart';

class AuthScreen extends StatefulWidget {
  static final routeName = 'auth';

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _passwordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _user = User(
    id: null,
    email: '',
    password: '',
    avatar: '',
    nick: ''
  );

  void _saveForm() {
    _form.currentState.save();
    print(_user.email);
    print(_user.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                onSaved: (value) {
                  _user = User(
                    email: value,
                    password: _user.password
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                focusNode: _passwordFocusNode,
                obscureText: true,
                onSaved: (value) {
                  _user = User(
                    email: _user.email,
                    password: value
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
