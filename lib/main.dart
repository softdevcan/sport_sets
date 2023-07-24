import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  List<String> sportMoves = [
    'JumpingJacks',
    'Push-ups',
    'Squats',
    'Burpees',
    'Lunges',
    'Plank',
    'High Knees',
    'Sit-ups',
    'Mountain Climbers',
  ];

  final List<int> setNumbers = [1, 2, 3, 4, 5];

  String? selectedSportMove;
  int? selectedSetCount;

  List<String> backgroundImages = [
    'assets/sports.jpg',
    'assets/sports2.jpg',
    'assets/sports4.jpg',
    'assets/sports3.jpg',
    'assets/sports5.jpg',
    'assets/sports6.jpg',
    'assets/sports7.jpg',
    'assets/sports8.jpg',
  ];

  Timer? _backgroundImageTimer;

  @override
  void initState() {
    super.initState();
    imageCache.clear();
    imageCache.maximumSize = 100;
    selectedSportMove = sportMoves[0];
    selectedSetCount = setNumbers[0];

    // Timer kullanarak her 15 saniyede bir arka plan resimlerini güncelle
    _backgroundImageTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        backgroundImages = [
          'assets/sports.jpg',
          'assets/sports2.jpg',
          'assets/sports4.jpg',
          'assets/sports3.jpg',
          'assets/sports5.jpg',
          'assets/sports6.jpg',
          'assets/sports7.jpg',
          'assets/sports8.jpg',
        ];
      });
    });
  }

  @override
  void dispose() {
    _backgroundImageTimer?.cancel();
    super.dispose();
  }

  // Rastgele bir resim döndüren fonksiyon
  String getRandomBackgroundImage() {
    final random = Random();
    return backgroundImages[random.nextInt(backgroundImages.length)];
  }

  @override
  Widget build(BuildContext context) {
    // backgroundImages listesini güncelleyin
    backgroundImages = [
      getRandomBackgroundImage(),
    ];
    var image = getRandomBackgroundImage();
    return Scaffold(
      //backgroundColor: _isGreen ? Colors.green : Colors.red, // Arka plan rengini güncelleyin
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Set Timer'),
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: [
          // Arka plan resimlerini Stack içinde kullanın
          for (var image in backgroundImages)
            Positioned.fill(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    color: Colors.white,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sport Move:     ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<String>(
                            icon: const Icon(Icons.arrow_downward,
                                color: Colors.white),
                            value: selectedSportMove,
                            onChanged: (newValue) {
                              setState(() {
                                selectedSportMove = newValue;
                              });
                            },
                            items: sportMoves
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Set Number:     ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<int>(
                            icon: const Icon(Icons.arrow_downward,
                                color: Colors.white),
                            value: selectedSetCount,
                            onChanged: (newValue) {
                              setState(() {
                                selectedSetCount = newValue;
                              });
                            },
                            items: setNumbers
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                alignment: Alignment.center,
                                value: value,
                                child: Text(
                                  "$value                            ",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            elevation: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedStartButton(
                  selectedSportMove: selectedSportMove,
                  selectedSetCount: selectedSetCount,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedStartButton extends StatefulWidget {
  final String? selectedSportMove;
  final int? selectedSetCount;

  AnimatedStartButton(
      {required this.selectedSportMove, required this.selectedSetCount});

  @override
  _AnimatedStartButtonState createState() => _AnimatedStartButtonState();
}

class _AnimatedStartButtonState extends State<AnimatedStartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final bool _isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _playAnimation() {
    if (_isButtonEnabled) {
      _animationController.forward().then((value) {
        _animationController.reverse();
        _navigateToColorChangePage();
      });
    }
  }

  void _navigateToColorChangePage() {
    if (widget.selectedSetCount! > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnimatedColorChangePage(
            sportMoveName: widget.selectedSportMove,
            setCount: widget.selectedSetCount,
          ),
        ),
      );
    } else {
      // Handle invalid set count input
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _playAnimation();
      },
      onTapUp: (_) {
        // onTapUp ve onTapCancel olaylarında herhangi bir şey yapmamıza gerek yok
      },
      onTapCancel: () {
        // onTapUp ve onTapCancel olaylarında herhangi bir şey yapmamıza gerek yok
      },
      onTap: () {
        _playAnimation();
      },
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.directions_run,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedColorChangePage extends StatefulWidget {
  final String? sportMoveName;
  final int? setCount;

  AnimatedColorChangePage(
      {required this.sportMoveName, required this.setCount});

  @override
  _AnimatedColorChangePageState createState() =>
      _AnimatedColorChangePageState();
}
class _AnimatedColorChangePageState extends State<AnimatedColorChangePage> {
  bool _isGreen = true;
  late Timer _timer;
  int _countdown = 40;
  int _currentSet = 1;


  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer.cancel();
          _isGreen = !_isGreen;
          if (_isGreen) {
            _currentSet++;
            if (_currentSet == widget.setCount! + 1) {
              Navigator.of(context).pop();
              _showAlertDialog();
            }
          }
          _resetCountdown();
        }
      });
    });
  }
  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Sets are over!"),
          content: Text("Click the 'ok' to start a new set."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  void _resetCountdown() {
    setState(() {
      _countdown = _isGreen ? 40 : 15; // Yeşil ise 5 saniye, kırmızı ise 3 saniye
    });
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: _isGreen ? Colors.greenAccent : Colors.redAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCountdownContainer(),
              const SizedBox(height: 250),
              AnimatedStopButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownContainer() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 38),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            _isGreen ? Colors.greenAccent : Colors.redAccent,
            _isGreen ? Colors.black : Colors.black
          ],
          radius: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _isGreen ? Colors.green[200]! : Colors.red[200]!,
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.sportMoveName ?? '',
            style: GoogleFonts.akayaTelivigala(
              fontSize: 32,
              color: Colors.white,
              shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Set $_currentSet/${widget.setCount}',
            style: GoogleFonts.akayaTelivigala(
              fontSize: 32,
              color: Colors.white,
              shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Countdown: $_countdown',
            style: GoogleFonts.akayaTelivigala(
              fontSize: 32,
              color: Colors.white,
              shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
            ),
          ),
          const SizedBox(height: 20),
          // Geri sayım animasyonu
          Container(
            width: double.infinity,
            height: 15, // Çizgi kalınlığını buradan ayarlayabilirsiniz
            child: LinearProgressIndicator(
              value: (_countdown / (_isGreen ? 40 : 15)), // Geri sayımın ilerleme değeri
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple), // İlerleme çubuğunun rengi
              backgroundColor: Colors.white, // İlerleme çubuğunun arka plan rengi
            ),
          )
        ],
      ),
    );
  }
}
// class _AnimatedColorChangePageState extends State<AnimatedColorChangePage> {
//   bool _isGreen = true;
//   late Timer _timer;
//   int _countdown = 5;
//   int _currentSet = 1;
//
//   @override
//   void initState() {
//     super.initState();
//     _resetCountdown();
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   void _startCountdown() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_countdown > 0) {
//           _countdown--;
//         } else {
//           _timer.cancel();
//           _isGreen = !_isGreen;
//           if (_currentSet-1 < widget.setCount!) {
//             _currentSet++;
//             _resetCountdown();
//           }
//         }
//       });
//     });
//   }
//
//   void _resetCountdown() {
//     setState(() {
//       _countdown = _isGreen ? 5 : 3; // Yeşil ise 40 saniye, kırmızı ise 15 saniye
//       _startCountdown();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: _isGreen ? Colors.greenAccent : Colors.redAccent,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               _buildCountdownContainer(),
//               const SizedBox(height: 250),
//               AnimatedStopButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCountdownContainer() {
//     return Container(
//       alignment: Alignment.center,
//       margin: const EdgeInsets.symmetric(horizontal: 38),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           colors: [
//             _isGreen ? Colors.greenAccent : Colors.redAccent,
//             _isGreen ? Colors.black : Colors.black
//           ],
//           radius: 1.5,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: _isGreen ? Colors.green[200]! : Colors.red[200]!,
//             blurRadius: 10,
//             spreadRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             widget.sportMoveName ?? '',
//             style: GoogleFonts.akayaTelivigala(
//               fontSize: 32,
//               color: Colors.white,
//               shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'Set $_currentSet/${widget.setCount}',
//             style: GoogleFonts.akayaTelivigala(
//               fontSize: 32,
//               color: Colors.white,
//               shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'Countdown: $_countdown',
//             style: GoogleFonts.akayaTelivigala(
//               fontSize: 32,
//               color: Colors.white,
//               shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
//             ),
//           ),
//           // const SizedBox(height: 20),
//           // GestureDetector(
//           //   onTapDown: (_) {
//           //     setState(() {
//           //       _isGreen = !_isGreen;
//           //     });
//           //   },
//           //   onTapUp: (_) {
//           //     setState(() {
//           //       _isGreen = !_isGreen;
//           //     });
//           //   },
//           //   onTapCancel: () {
//           //     setState(() {
//           //       _isGreen = !_isGreen;
//           //     });
//           //   },
//           //   onTap: () {},
//           //   child: Text(
//           //     widget.sportMoveName ?? '',
//           //     style: GoogleFonts.akayaTelivigala(
//           //       fontSize: 32,
//           //       color: Colors.white,
//           //       shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
//           //     ),
//           //   ),
//           // ),
//           const SizedBox(height: 20),
//           // Geri sayım animasyonu
//           LinearProgressIndicator(
//             value: (_countdown / (_isGreen ? 5 : 3)), // Geri sayımın ilerleme değeri
//             valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple), // İlerleme çubuğunun rengi
//             backgroundColor: Colors.white, // İlerleme çubuğunun arka plan rengi
//           ),
//         ],
//       ),
//     );
//   }
//   // Widget _buildCountdownContainer() {
//   //   return Container(
//   //     alignment: Alignment.center,
//   //     margin: const EdgeInsets.symmetric(horizontal: 40),
//   //     padding: const EdgeInsets.all(30),
//   //     decoration: BoxDecoration(
//   //       gradient: RadialGradient(
//   //         colors: [_isGreen ? Colors.greenAccent : Colors.redAccent, _isGreen ? Colors.black : Colors.black],
//   //         radius: 1.5,
//   //       ),
//   //       borderRadius: BorderRadius.circular(20),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: _isGreen ? Colors.green[200]! : Colors.red[200]!,
//   //           blurRadius: 10,
//   //           spreadRadius: 5,
//   //           offset: Offset(0, 3),
//   //         ),
//   //       ],
//   //     ),
//   //     child: Column(
//   //       mainAxisAlignment: MainAxisAlignment.center,
//   //       children: [
//   //         Text(
//   //           'Set $_currentSet/${widget.setCount}',
//   //           style: GoogleFonts.akayaTelivigala(
//   //             fontSize: 32,
//   //             color: Colors.white,
//   //             shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
//   //           ),
//   //         ),
//   //         const SizedBox(height: 20),
//   //         Text(
//   //           'Countdown: $_countdown',
//   //           style: GoogleFonts.akayaTelivigala(
//   //             fontSize: 32,
//   //             color: Colors.white,
//   //             shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
//   //           ),
//   //         ),
//   //         const SizedBox(height: 20),
//   //         GestureDetector(
//   //           onTapDown: (_) {
//   //             setState(() {
//   //               _isGreen = !_isGreen;
//   //             });
//   //           },
//   //           onTapUp: (_) {
//   //             setState(() {
//   //               _isGreen = !_isGreen;
//   //             });
//   //           },
//   //           onTapCancel: () {
//   //             setState(() {
//   //               _isGreen = !_isGreen;
//   //             });
//   //           },
//   //           onTap: () {},
//   //           child: Text(
//   //             widget.sportMoveName ?? '',
//   //             style: GoogleFonts.akayaTelivigala(
//   //               fontSize: 32,
//   //               color: Colors.white,
//   //               shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
//   //             ),
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
// }

class AnimatedStopButton extends StatefulWidget {
  final VoidCallback onPressed;

  AnimatedStopButton({required this.onPressed});

  @override
  _AnimatedStopButtonState createState() => _AnimatedStopButtonState();
}

class _AnimatedStopButtonState extends State<AnimatedStopButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _animationController.fling();
      },
      onTapUp: (_) {
        _animationController.lastElapsedDuration ==
                _animationController.duration
            ? _animationController.reverse()
            : _animationController.forward();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.stop_circle,
              color: Colors.white,
              size: 70,
            ),
          ),
        ),
      ),
    );
  }
}
