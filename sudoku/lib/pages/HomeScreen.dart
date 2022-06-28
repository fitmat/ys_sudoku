import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sudoku/main.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xfffff9f1),
            bottomNavigationBar: buildBottomNavigationBar(),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Sudoku',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff004A62),
                        fontSize: 43.0,
                        fontFamily: 'Gugi',
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 390,
                height: MediaQuery.of(context).size.height * 0.78,
                child: Stack(children: <Widget>[
                  Positioned(
                      top: 275.7897033691406,
                      left: 90.8812484741211,
                      child: Transform.rotate(
                          angle: -1.13,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              height: MediaQuery.of(context).size.width * 0.65,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/sudoku_blocks.png"),
                                    fit: BoxFit.fitWidth),
                              )))),
                  Positioned(
                      top: 100,
                      left: 170.8812484741211,
                      child: Transform.rotate(
                        angle: -16,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            height: MediaQuery.of(context).size.width * 0.65,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/sudoku_blocks.png"),
                                  fit: BoxFit.fitWidth),
                            )),
                      )),
                  Positioned(
                      top: 54.6435241699219,
                      left: -16,
                      child: Transform.rotate(
                          angle: 0.24,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              height: MediaQuery.of(context).size.width * 0.65,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/sudoku_blocks.png"),
                                    fit: BoxFit.fitWidth),
                              )))),
                ]),
              ),
            ])));
  }

  Widget buildBottomNavigationBar() {
    return Container(
      child: BottomNavigationBar(
        selectedFontSize: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // currentIndex: _selectedPage,
        unselectedItemColor: Colors.white.withOpacity(0.9),
        backgroundColor: Color(0xff004A62),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        // onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 30,
                      width: 30,
                      child: Icon(
                        FontAwesomeIcons.cog,
                      )),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/settings_screen');
              },
            ),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              child: Column(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    child: Icon(
                      FontAwesomeIcons.play,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/home_page');
              },
            ),
            label: ('Play'),
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              child: Column(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: GestureDetector(
                        child: Icon(
                          Icons.help_rounded,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onTap:(){
                Navigator.of(context).pushNamed('/rules_page');
              },
              
            ),
            label: ('Rules'),
          ),
        ],
      ),
    );
  }
}
