import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/View/Screens/Homescreen.dart';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class EnterInformation extends StatefulWidget {
  const EnterInformation({Key? key, this.number, this.countryCode});
  final String? number;
  final String? countryCode;

  @override
  State<EnterInformation> createState() => _EnterInformationState();
}

class _EnterInformationState extends State<EnterInformation> {
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final storage = new FlutterSecureStorage();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Thông tin hồ sơ",
          style: TextStyle(
            color: Colors.teal[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        child: Form(
          key: _globalkey,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Vui lòng cung cấp các thông tin sau",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: Colors.blueGrey[500],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.teal,
                        width: 1.6,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Password can't be empty";
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      hintText: "Nhập tài khoản",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.teal,
                        width: 1.6,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Password can't be empty";
                      if (value.length < 8)
                        return "Password lenght must have >=8";
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      hintText: "Nhập mật khẩu",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.teal,
                        width: 1.6,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordController1,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Password can't be empty";
                      if (value.length < 8)
                        return "Password lenght must have >=8";
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      hintText: "Nhập lại mật khẩu",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.teal,
                        width: 1.6,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    controller: _displayNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Password can't be empty";
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      hintText: "Nhập họ và tên",
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // setState(() {
                    //   circular = true;
                    // });
                    // await checkUser(); && validate
                    if (_globalkey.currentState!.validate()) {
                      // we will send the data to rest server
                      Map<String, String> data = {
                        "userName": _usernameController.text,
                        "password": _passwordController.text,
                        "displayName": _displayNameController.text,
                        "phoneNumber": widget.countryCode.toString() +
                            widget.number.toString(),
                      };
                      print(data);
                      var responseRegister =
                          await networkHandler.post2("/user/register", data);

                      var responseRegisterChatter =
                          await networkHandler.post2("/chatter/register", data);

                      //Login Logic added here
                      if ((responseRegister.statusCode == 200 ||
                              responseRegister.statusCode == 201) &&
                          (responseRegisterChatter.statusCode == 200 ||
                              responseRegisterChatter.statusCode == 201)) {
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
                              (route) => false);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Netwok Error")));
                        }
                      }
                    }
                  },
                  child: Text(
                    "TIẾP",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.teal),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                  ),
                ),
              ],
            ),
          ),
        ),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      ),
    );
  }
}
