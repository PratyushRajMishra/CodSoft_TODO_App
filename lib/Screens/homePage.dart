import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listify/Screens/navBar.dart';
import 'package:listify/Screens/notificationBar.dart';
import 'package:listify/Screens/welcome.dart';

import '../model/UserModel.dart';
import '../tabs/daily.dart';
import '../tabs/monthly.dart';
import '../tabs/weekly.dart';
import '../tabs/yearly.dart';

class HomeController extends GetxController {
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}

class HomePage extends StatelessWidget {
  final UserModel userModel;
  final HomeController homeController = Get.put(HomeController());

 HomePage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: homeController.tabIndex.value,
      child: Scaffold(
        drawer: NavbarPage(userModel: userModel,),
        endDrawer: NotificationBar(), // Define your end drawer
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          title: Text(
            'Listify',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
                icon: Icon(Icons.menu, color: Colors.white),
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Builder(
                builder: (context) {
                  return InkWell(
                    onTap: () {
                      // Use ScaffoldMessenger to open the end drawer
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: Icon(Icons.notifications, color: Colors.white),
                  );
                },
              ),
            ),
          ],


          bottom: TabBar(
            isScrollable: true,
            indicator: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelColor: Colors.deepPurpleAccent,
            labelStyle: TextStyle(fontSize: 15, letterSpacing: 1.0, fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.white,
            onTap: (index) {
              homeController.changeTabIndex(index);
            },
            tabs: const [
              Tab(text: '     Daily     '),
              Tab(text: '     Weekly     '),
              Tab(text: '     Monthly     '),
              Tab(text: '     Yearly     '),
            ],
          ),
        ),
        body: Obx(() {
          final tabIndex = homeController.tabIndex.value;
          return TabBarView(
            children: [
              DailyPage(),
              WeeklyPage(),
              MonthlyPage(),
              YearlyPage(),
            ],
          );
        }),
      ),
    );
  }
}
