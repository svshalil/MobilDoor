// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:widget_utils/widget_utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

import 'model.dart';
import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WidgetUtilsBuilder(
        responsiveParams: ResponsiveParams(allowTextScale: false),
        localizationParams: LocalizationParams(
            defLang: const Locale("en", "US"),
            langAssets: ["assets/lang/en.json", "assets/lang/tr.json"]),
        builder: (_) {
          return const LoginPage();
        },
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  //final url = Uri.parse('http://78.188.229.240/doorAPI/Register');
  final url = Uri.parse('http://mobilapi.ucgteknoloji.com/Register');

  Future callToken() async {
    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'UserName': _usernameTextEditingController.text,
        'Password': _passwordTextEditingController.text,
        'grant_type': 'password'
      });
      if (response.statusCode == 200) {
        var result = tokenFromJson(response.body);
        //this.createSuccessToast(context, result.accessToken);
        await FlutterSession().set("token", result.accessToken);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePageApp()));
      } else {
        // ignore: use_build_context_synchronously
        createErrorToast(
            context, l("login_error_message") + response.statusCode.toString());
      }
    } catch (e) {
      createErrorToast(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          _LoginPageTopSection(context),
          _LoginPageBottomSection(context)
        ],
      ),
    ));
  }

  Widget _LoginPageTopSection(BuildContext context) {
    return Container(
      width: getWidth(context, percent: 1),
      padding: EdgeInsets.only(top: convertSize(20), bottom: convertSize(20)),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(convertSize(35)),
          bottomRight: Radius.circular(convertSize(35)),
        ),
      ),
      child: Image.asset(
        "assets/image/logo.png",
        width: convertSize(200),
        height: convertSize(200),
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _LoginPageBottomSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: convertSize(24), vertical: convertSize(37)),
      child: Column(
        children: [
          _LoginPageTitle(),
          SizedBox(
            height: convertSize(24),
          ),
          _LoginPageTextField("login_page_username_hint",
              _usernameTextEditingController, Icons.person),
          SizedBox(
            height: convertSize(15),
          ),
          _LoginPageTextField("login_page_password_hint",
              _passwordTextEditingController, Icons.vpn_key,
              obscureText: true),
          SizedBox(
            height: convertSize(25),
          ),
          _LoginPageButton(context)
        ],
      ),
    );
  }

  Widget _LoginPageTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock,
          size: getIconSize(SizeType.Ultra),
        ),
        SizedBox(
          height: convertSize(5),
        ),
        Text(
          l("login_page_title"),
          style: TextStyle(fontSize: getFontSize(SizeType.Ultra)),
        )
      ],
    );
  }

  Widget _LoginPageTextField(
      String hintText, TextEditingController controller, IconData iconData,
      {bool obscureText = false}) {
    return Material(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(convertSize(12)),
          side: BorderSide(
              color: Colors.grey.shade200,
              width: convertSize(1.2),
              style: BorderStyle.solid),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: convertSize(8), vertical: convertSize(32)),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(fontSize: getFontSize(SizeType.Middle)),
            decoration: InputDecoration(
                icon: Icon(
                  iconData,
                  color: Colors.black,
                  size: getFontSize(SizeType.Middle),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
                hintText: l(hintText)),
          ),
        ));
  }

  Widget _LoginPageButton(BuildContext context) {
    return Material(
      color: Colors.blue,
      elevation: 5.0,
      shadowColor: Colors.blue,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(convertSize(12))),
      child: InkWell(
        onTap: () {
          callToken();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: convertSize(8)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.lock_open,
              color: Colors.white,
              size: getIconSize(SizeType.Middle),
            ),
            SizedBox(
              width: convertSize(5),
            ),
            Text(
              l("login_page_button"),
              style: TextStyle(
                  color: Colors.white, fontSize: getFontSize(SizeType.Middle)),
            )
          ]),
        ),
      ),
    );
  }
}
