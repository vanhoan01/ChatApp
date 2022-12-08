import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:chatapp/NewScreen/EnterInformation.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, this.number, this.countryCode}) : super(key: key);
  final String? number;
  final String? countryCode;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpFieldController otpController = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Verify ${widget.countryCode} ${widget.number}",
          style: TextStyle(
            color: Colors.teal[800],
            fontSize: 16.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Chúng tôi đã gửi một tin nhắn SMS có mã đến ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.5,
                    ),
                  ),
                  TextSpan(
                    text: "${widget.countryCode} ${widget.number}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " Sai số?",
                    style: TextStyle(
                      color: Colors.cyan[800],
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            OTPTextField(
              controller: otpController,
              length: 6,
              width: MediaQuery.of(context).size.width,
              fieldWidth: 30,
              style: TextStyle(fontSize: 17),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onChanged: (pin) {
                print("Changed: " + pin);
              },
              onCompleted: (pin) {
                //EnterInformation
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => EnterInformation(
                        countryCode: widget.countryCode, number: widget.number),
                  ),
                );
              },
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Nhập mã 6 chữ số",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            bottomButton("Gửi lại tin nhắn SMS", Icons.message),
            SizedBox(
              height: 12,
            ),
            Divider(
              thickness: 1.5,
            ),
            SizedBox(
              height: 12,
            ),
            bottomButton("Gọi cho tôi", Icons.call),
          ],
        ),
      ),
    );
  }

  Widget bottomButton(String text, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.teal,
          size: 24,
        ),
        SizedBox(
          width: 25,
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.cyan[800],
            fontSize: 14.5,
          ),
        ),
      ],
    );
  }
}
