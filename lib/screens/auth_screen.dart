import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    var _isLoading = false;

    void _submitAuthForm(String email, String password, String username,
        bool isLogin, BuildContext ctx) async {
      // ignore: unused_local_variable
      UserCredential authResult;

      try {
        setState(() {
          _isLoading = true;
        });
        if (isLogin) {
          authResult = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
        } else {
          authResult = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text("User Created Successfully"),
              backgroundColor: Colors.green,
            ),
          );
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set(
            {
              'email': email,
              'username': username,
            },
          );
        }
      } on PlatformException catch (e) {
        var message = "An Error Occured, Check your Credentials";

        if (e.message != null) {
          message = e.message!.toString();
        }

        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }

    ;
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
              LoginForm(
                  deviceSize: deviceSize,
                  submitfn: _submitAuthForm,
                  isLoading: _isLoading),
            ],
          ),
        ),
      ),
    ));
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({
    required this.deviceSize,
    required this.submitfn,
    required this.isLoading,
  });
  bool isLoading = false;

  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) submitfn;

  final Size deviceSize;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  String? _email;
  String? _userName = "";
  bool isLogin = true;
  String? _pass;

  void _trySubmit() {
    final isValid = _loginKey.currentState!.validate();
    widget.isLoading = true;
    FocusScope.of(context).unfocus();

    if (isValid) {
      _loginKey.currentState!.save();
      widget.submitfn(
        _email!,
        _pass!,
        _userName!,
        isLogin,
        context,
      );
    }

    widget.isLoading = false;
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
              key: ValueKey('email'),
              decoration: InputDecoration(hintText: "Email"),
              onSaved: (value) {
                _email = value;
              },
              validator: (value) {
                if (value!.isEmpty ||
                    !value.contains("@") ||
                    !value.contains(".com")) {
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
                key: ValueKey('username'),
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
              key: ValueKey('password'),
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
                    child: widget.isLoading
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
            if (!widget.isLoading)
              SizedBox(
                height: 20,
              ),
            if (!widget.isLoading)
              InkWell(
                child: Text(
                  isLogin ? "Create New Account" : "I Already Have An Account",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
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
