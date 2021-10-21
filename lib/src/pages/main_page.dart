import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickgui/src/widgets/home_page_buttons.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    Directory.current = '/home/yannick';
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 250,
            child: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.pink,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: HomePageButtons(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Working directory : ${Directory.current.absolute.path}",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
