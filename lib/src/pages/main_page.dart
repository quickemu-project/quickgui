import 'package:flutter/material.dart';
import 'package:quickgui/src/pages/operating_system_page.dart';
import 'package:quickgui/src/widgets/home_page_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 250,
            child: Flex(
              direction: Axis.vertical,
              children: const [
                Expanded(
                  child: Center(
                    child: Text("QuickGui"),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.pink,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      HomePageButton(
                        text: "Operating system",
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OperatingSystemPpage()));
                        },
                      ),
                      const HomePageButton(
                        text: "Version",
                        onPressed: null,
                      ),
                      const HomePageButton(
                        text: "Download",
                        onPressed: null,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
