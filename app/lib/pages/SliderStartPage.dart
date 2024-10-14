import 'package:flutter/material.dart';
import 'package:app/components/button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderStartPage extends StatefulWidget {
  @override
  _SliderStartPageState createState() => _SliderStartPageState();
}

class _SliderStartPageState extends State<SliderStartPage> {
  final PageController _pageController = PageController();
  final List<Column> sliderItems = [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/slider1.png'),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.all(18.0),
          child: Text(
            "Confiez vos joyaux verts \nà d'autres passionnés \nde plantes",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0, color: Colors.white),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/slider2.png'),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.all(18.0),
          child: Text(
            "Consultez les suggestions \nexpertes des botanistes",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0, color: Colors.white),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/slider3.png'),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 60.0),
          child: Text(
            "Prenez soin des plantes \nd'autres membres",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0, color: Colors.white),
          ),
        ),
      ],
    ),
  ];

  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_pageListener);
  }

  void _pageListener() {
    setState(() {
      _currentPageIndex = _pageController.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: sliderItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                child: Container(
                                  color: Colors.grey[300],
                                  child: sliderItems[index].children[0],
                                ),
                              ),
                              Positioned(
                                bottom: 90.0,
                                left: 16.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 170,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: sliderItems[index].children[1],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 45.0,
                  right: 20.0,
                  child: _currentPageIndex != sliderItems.length - 1
                      ? TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/inscription');
                          },
                          child: Text(
                            'Passer',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: AnimatedSmoothIndicator(
                            activeIndex: _currentPageIndex,
                            count: sliderItems.length,
                            effect: ScrollingDotsEffect(
                              dotHeight: 10,
                              dotWidth: 10,
                              activeDotColor: Color(0xFF3B9678),
                              dotColor: Color(0xFF3B9678).withOpacity(0.3),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        CustomButton(
                          text: _currentPageIndex == sliderItems.length - 1
                              ? 'Commencer'
                              : 'Suivant',
                          onPressed: () {
                            if (_currentPageIndex == sliderItems.length - 1) {
                              Navigator.pushNamed(context, '/inscription');
                            } else {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}