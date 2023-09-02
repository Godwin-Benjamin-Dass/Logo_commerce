import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logo_commerce/View_Model/User_provider.dart';
import 'package:logo_commerce/screens/LoginFlow/RegisterPage.dart';
import 'package:logo_commerce/screens/pages/OrderFlow/Orders.dart';
import 'package:logo_commerce/screens/pages/profileFlow/Profile.dart';
import 'package:logo_commerce/screens/pages/uploadLogoFlow/UploadLogo.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _pageIndex = 0;
  final pages = [LogoUploadPage(), Orders(), Profile()];
  @override
  void initState() {
    fetchAndSetData();

    // TODO: implement initState
    super.initState();
  }

  fetchAndSetData() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    var User = Provider.of<UserProvider>(context);

    return User.userData.isEmpty
        ? RegisterPage(title: "Enter Your Details")
        : Scaffold(
            body: pages[_pageIndex],
            bottomNavigationBar: CurvedNavigationBar(
              items: const <Widget>[
                Icon(CupertinoIcons.add, size: 30, color: Colors.red),
                Icon(CupertinoIcons.bag, size: 30, color: Colors.red),
                Icon(CupertinoIcons.person_alt, size: 30, color: Colors.red),
              ],
              color: Colors.white,
              buttonBackgroundColor: Colors.white,
              backgroundColor: Colors.red,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 400),
              onTap: (index) {
                setState(() {
                  _pageIndex = index;
                });
              },
              letIndexChange: (index) => true,
            ));
  }
}
