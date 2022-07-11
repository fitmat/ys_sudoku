import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sudoku/Styles.dart';
import 'package:sudoku/main.dart';

class RulesPage extends StatefulWidget {
  static const String routeName = "/rules_page";
  const RulesPage({key}) : super(key: key);

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  int _currentIndex = 0;
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //       child: Scaffold(
  //           backgroundColor: HomePageState.currentTheme == "light"
  //               ? Color(0xfffff9f1)
  //               : Color(0xff292929),
  //           appBar: PreferredSize(
  //             preferredSize: Size.fromHeight(50.0),
  //             child: AppBar(
  //               // automaticallyImplyLeading: false,
  //               centerTitle: true,
  //               title: Text('Rules',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                       color: Colors.black,
  //                       fontFamily: 'Gugi',
  //                       fontSize: 24,
  //                       fontWeight: FontWeight.w500)
  //                   // GoogleFonts.getFont('Gugi',
  //                   //     color: Color(0xff004A62),
  //                   //     fontSize: 24,
  //                   //     fontWeight: FontWeight.w500)
  //                   ),
  //               backgroundColor: Color(0xfffff9f1),
  //               elevation: 0.0,
  //               iconTheme: IconThemeData(color: Colors.black),
  //             ),
  //           ),
  //           body: Column(
  //             children: [
  //               CarouselSlider(
  //                 items: [
  //                   Card(
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         Container(
  //                             width: MediaQuery.of(context).size.width * 0.8,
  //                             height: MediaQuery.of(context).size.height * 0.5,
  //                             decoration: BoxDecoration(
  //                               image: DecorationImage(
  //                                   image: AssetImage(
  //                                       "assets/images/sudoku_rules_img1.png"),
  //                                   fit: BoxFit.fitWidth),
  //                             )),
  //                         Flexible(
  //                           child: Text(
  //                               'A Sudoku puzzle begins with grid in which some of the numbers are already in place depending on the game difficulty level.\nA completed puzzle is one where each number from 1 to 9 appears only once in each of the 9 rows, columns and blocks.Study the grid to find the numbers that might fit into each cell.\nSelect a cell then tap a number to fill in the cell.',
  //                               style: TextStyle(
  //                                 color: HomePageState.currentTheme == "light"
  //                                     ? Styles.lightThemeprimaryColor
  //                                     : Styles.darkThemeprimaryColor,
  //                               )),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Card(
  //                     child: Container(
  //                       height: MediaQuery.of(context).size.height,
  //                       margin: EdgeInsets.all(6.0),
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(8.0),
  //                         image: DecorationImage(
  //                           image: AssetImage(
  //                               "assets/images/sudoku_rules_img2.png"),
  //                           fit: BoxFit.fitWidth,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //                 options: CarouselOptions(
  //                   enlargeCenterPage: true,
  //                   autoPlay: true,
  //                   aspectRatio: MediaQuery.of(context).size.aspectRatio,
  //                   autoPlayCurve: Curves.fastOutSlowIn,
  //                   enableInfiniteScroll: true,
  //                   autoPlayAnimationDuration: Duration(milliseconds: 800),
  //                   onPageChanged: (index, reason) {
  //                     setState(() {
  //                       _currentIndex = index;
  //                     });
  //                   },
  //                 ),
  //               ),
  //               DotsIndicator(
  //                 dotsCount: 3,
  //                 position: _currentIndex.toDouble(),
  //                 decorator: DotsDecorator(
  //                   color: Colors.amber,
  //                   activeColor: Colors.pink,
  //                 ),
  //               ),
  //             ],
  //           )));
  // }

  List<String> listPaths = [
    "assets/images/sudoku_rules_img1.png",
    "assets/images/sudoku_rules_img2.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CarouselSlider.builder(
          itemCount: listPaths.length,
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.6,
              viewportFraction: 1.0,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              }),
          itemBuilder: (context, index, _currentIndex) {
            return MyImageView(listPaths[index]);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: listPaths.map((url) {
            int index = listPaths.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ])),
    );
  }
}

class MyImageView extends StatelessWidget {
  String imgPath;

  MyImageView(this.imgPath);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Image.asset(imgPath),
        ));
  }
}
