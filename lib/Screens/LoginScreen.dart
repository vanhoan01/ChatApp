import 'dart:convert';

import 'package:chatapp/NewScreen/LoginPage.dart';
import 'package:chatapp/Screens/Homescreen.dart';
import 'package:chatapp/Services/metwork_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final storage = new FlutterSecureStorage();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 100, bottom: 20),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'ChatApp',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
              ),
            ),
            Form(
              key: _globalkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Số điện thoại không được để trống";
                            return null;
                          },
                          decoration: InputDecoration(
                            // errorText: validate ? null : errorText,
                            hintText: "Số điện thoại hoặc tài khoản",
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal), //<-- SEE HERE
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Mật khẩu không được trống";
                            if (value.length < 8)
                              return "Mật khẩu phải có ít nhất 8 kí tự";
                            return null;
                          },
                          // obscureText: vis,
                          decoration: InputDecoration(
                            hintText: "Mật khẩu",
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal), //<-- SEE HERE
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Quên mật khẩu?',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 10.0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () async {
                          if (_globalkey.currentState!.validate()) {
                            Map<String, String> data = {
                              "userName": _usernameController.text,
                              "password": _passwordController.text,
                            };
                            var response =
                                await networkHandler.post2("/user/login", data);

                            if (response.statusCode == 200 ||
                                response.statusCode == 201) {
                              Map<String, dynamic> output =
                                  json.decode(response.body);
                              print(output["token"]);
                              await storage.write(
                                  key: "token", value: output["token"]);
                              // setState(() {
                              //   validate = true;
                              //   circular = false;
                              // });
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Homescreen(),
                                ),
                                (route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Netwok Error")));
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Bạn chưa có tài khoản?'),
                TextButton(
                  child: const Text(
                    'Đăng ký',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
