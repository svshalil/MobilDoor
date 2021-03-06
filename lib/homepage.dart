// ignore_for_file: non_constant_identifier_names, unused_element, import_of_legacy_library_into_null_safe, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:widget_utils/widget_utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

import 'menubutton.dart';
import 'menu.dart';

class HomePageApp extends StatelessWidget {
  const HomePageApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomePage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WidgetUtilsBuilder(
        responsiveParams: ResponsiveParams(allowTextScale: false),
        localizationParams: LocalizationParams(
            defLang: const Locale("en", "US"),
            langAssets: ["assets/lang/en.json", "assets/lang/tr.json"]),
        builder: (_) {
          return const HomePage();
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool click = true;
  String tokentext = "";
  var result = "";
  final url = Uri.parse(
      'http://mobilapi.ucgteknoloji.com/api/MobilApi/SetDoorProcessService');

  Future callDoor() async {
    try {
      final token = await FlutterSession().get("token");
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token'
      });
      if (response.statusCode == 200) {
        result = response.body;
        if (result == "0") {
          createSuccessToast(context, l("door_success_message"));
        } else {
          createErrorToast(
              context, l("door_error_message") + " ErrorCode: $result");
        }
      } else {
        createErrorToast(
            context,
            l("door_error_message") +
                " StatusCode: " +
                response.statusCode.toString());
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
          _HomePageTopSection(context),
          _HomePageBottomSection(context)
        ],
      ),
    ));
  }

  Widget _HomePageTopSection(BuildContext context) {
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
      child: Column(children: [
        TopBarFb4(
          onTapMenu: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => DrawerFb1()));
          },
        ),
        Image.asset(
          "assets/image/door.png",
          width: convertSize(200),
          height: convertSize(200),
          fit: BoxFit.contain,
        )
      ]),
    );
  }

  Widget _HomePageBottomSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: convertSize(24), vertical: convertSize(37)),
      child: Column(
        children: [
          _HomePageTitle(),
          SizedBox(
            height: convertSize(24),
          ),
          _HomePageButton(context)
        ],
      ),
    );
  }

  Widget _HomePageTitle() {
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
          l("home_page_title"),
          style: TextStyle(fontSize: getFontSize(SizeType.Ultra)),
        )
      ],
    );
  }

  Widget _HomePageTextField(
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
                contentPadding: const EdgeInsets.all(0),
                hintText: l(hintText)),
          ),
        ));
  }

  Widget _HomePageButton(BuildContext context) {
    return Material(
      color: (result != "0") ? Colors.red : Colors.greenAccent,
      elevation: 5.0,
      shadowColor: Colors.blue,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(convertSize(24))),
      child: InkWell(
        onTap: result != "0"
            ? () {
                callDoor();
              }
            : null,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: convertSize(50)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.door_back_door,
              color: Colors.white,
              size: getIconSize(SizeType.Middle),
            ),
            SizedBox(
              width: convertSize(5),
            ),
            Text(
              l("door_page_button"),
              style: TextStyle(
                  color: Colors.white, fontSize: getFontSize(SizeType.Middle)),
            )
          ]),
        ),
      ),
    );
  }
}
