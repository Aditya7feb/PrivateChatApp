import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HelloText(deviceSize: deviceSize),
              LoginForm(deviceSize: deviceSize),
            ],
          ),
        ),
      ),
    ));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.deviceSize,
  }) : super(key: key);

  final Size deviceSize;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  String? _email;
  String? _userName;
  bool isLogin = true;
  String? _pass;

  bool isLoading = false;

  void _trySubmit() {
    final isValid = _loginKey.currentState!.validate();
    isLoading = true;
    FocusScope.of(context).unfocus();

    if (isValid) {
      _loginKey.currentState!.save();
    }

    print(_email);
    print(_userName);
    print(_pass);
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.deviceSize.height * 0.075),
      child: Form(
        key: _loginKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: "Email"),
              onSaved: (value) {
                _email = value;
              },
              validator: (value) {
                if (value!.isEmpty || !value.contains("@")) {
                  return "Invalid Email Address";
                } else {
                  return null;
                }
              },
            ),
            if (!isLogin)
              SizedBox(
                height: widget.deviceSize.height * 0.02,
              ),
            if (!isLogin)
              TextFormField(
                decoration: InputDecoration(hintText: "Username"),
                onSaved: (value) {
                  _userName = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Username must be filled";
                  } else if (value.length < 8) {
                    return "Username must be 8 characters long";
                  } else {
                    return null;
                  }
                },
              ),
            SizedBox(
              height: widget.deviceSize.height * 0.02,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Password"),
              obscureText: true,
              obscuringCharacter: "*",
              onSaved: (value) {
                _pass = value;
              },
              validator: (value) {
                if (value!.isEmpty || value.length < 7) {
                  return "Password too short, must be atleast 7 characters long";
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: widget.deviceSize.height * 0.05,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: widget.deviceSize.width * 0.9,
                height: widget.deviceSize.width * 0.13,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green),
                child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            isLogin ? "Login" : "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
              ),
              onTap: () {
                _trySubmit();
              },
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              child: Text(
                "Create New Account",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HelloText extends StatelessWidget {
  const HelloText({
    Key? key,
    required this.deviceSize,
  }) : super(key: key);

  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: deviceSize.height * 0.075,
        ),
        Text(
          "Hello",
          style: TextStyle(
              fontSize: deviceSize.width * 0.2, fontWeight: FontWeight.bold),
        ),
        RichText(
          text: TextSpan(
            text: 'There',
            style: TextStyle(
                color: Colors.black,
                fontSize: deviceSize.width * 0.2,
                fontWeight: FontWeight.bold),
            children: const <TextSpan>[
              TextSpan(text: '.', style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
      ],
    );
  }
}
