// ignore_for_file: prefer_const_constructors, avoid_print, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:memoire/Services/Api.dart';
import 'package:memoire/Services/userController.dart';
import 'package:memoire/models/user.dart';
import 'package:memoire/utils/constant.dart';
import 'package:memoire/utils/data.dart';
import 'package:memoire/widgets/background_in.dart';
import 'package:memoire/widgets/input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../root_app.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email;
  var password;
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Background(
        titre: 'Login',
        child: SingleChildScrollView(
          child: Container(
            height: size.height * 0.6,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(top: size.height * 0.4),
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
                    ],
                  ),
                ),
                //titre
                Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.height / 25,
                    color: const Color(0xff252427),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                //input
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                      ),
                    ],
                  ),
                ),
                //sign in button
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
                      _loginUser();
                    },
                    child: Text(
                      'Sign in',
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

  void _saveUserToken(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
  }

  void _loginUser() async {
    ApiResponse response = await login(email, password);
    if (response.error == null) {
      _saveUserToken(response.data as User);
      getUser();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // get user detail
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      user = response.data as User;
      profile["name"] = user!.name!;
      profile["email"] = user!.email!;
      print(user!.name);
      print(user!.email);
      imageURL = '$urlImages/first/storage/app/${user!.image!}';
      usertype = user!.usertype!;
      if (usertype != 2) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => RootApp(usertype: usertype)),
            (route) => false);
      }
    } else if (response.error == unauthorized) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(unauthorized)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
}
