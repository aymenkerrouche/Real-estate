// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_print, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unrelated_type_equality_checks, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:memoire/Services/Api.dart';
import 'package:memoire/Services/user.dart';
import 'package:memoire/screens/root_app.dart';
import 'package:memoire/utils/data.dart';
import 'package:memoire/widgets/background_in.dart';
import 'package:memoire/widgets/input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sign_up_ag.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _visible = true;
  var email;
  var password;
  var name;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double tol = size.height / 4;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Background(
        titre: 'Sign up',
        child: SingleChildScrollView(
          child: Container(
            height: size.height * 0.7,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(top: size.height * 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //icon
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, size: 30.0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      //titre
                      Expanded(
                        child: Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: size.height / 25,
                            color: const Color(0xff252427),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //input
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Textfield(
                        'User name',
                        child: TextFormField(
                          onChanged: (value) {
                            name = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Textfield(
                        'Email',
                        child: TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'example@example.com',
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      mdps(
                        headerText: "Password",
                        child: TextFormField(
                          obscureText: _visible,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: InputDecoration(
                              hintText: '********',
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                  padding: EdgeInsets.only(bottom: 5),
                                  icon: Icon(
                                    _visible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _visible = !_visible;
                                    });
                                  })),
                        ),
                      )
                    ],
                  ),
                ),
                //switchButton
                ToggleButton(
                  title: 'accountType',
                ),

                //sign up button
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width / 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(size.width, size.height / 13),
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                    ),
                    onPressed: () {
                      usertype = ToggleButton.togglevalue;
                      if (usertype == 1) {
                        _registerUser();
                      } else if (usertype == 0) {
                        profile["name"] = name;
                        profile["email"] = email;
                        pswrd = password;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Agency(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('please enter your infos')));
                      }
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
  }

  void _registerUser() async {
    ApiResponse response =
        await register(name, email, password, usertype.toString());
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
      user = response.data as User;
      profile["name"] = user!.name!;
      profile["email"] = user!.email!;
      if (usertype != 2) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => RootApp(usertype: usertype)),
            (route) => false);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      print(response.error);
    }
  }
}
