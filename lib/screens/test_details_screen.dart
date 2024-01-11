import 'package:flutter/material.dart';

class TestDetailsScreen extends StatefulWidget {
  const TestDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TestDetailsScreen> createState() => _TestDetailsScreenState();
}

class _TestDetailsScreenState extends State<TestDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF3D737F),
        body: Padding(
          padding: const EdgeInsets.only(top: 80, bottom: 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'HATIRLATMA',
                      style: TextStyle(
                          color: Color(0xFFCEC7BF),
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 220,
                      decoration: BoxDecoration(
                          color: const Color(0xFFCEC7BF),
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle),
                      child: const Center(
                        child: Text(
                          '22:00',
                          style: TextStyle(
                              color: Color(0xFF07161B),
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '10 dakika kaldı',
                      style: TextStyle(
                        color: Color(0xFFCEC7BF),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 250,
                      width: 220,
                      decoration: BoxDecoration(
                          color: const Color(0xFFCEC7BF),
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle),
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Başlık',
                            style: TextStyle(
                              color: Color(0xFF07161B),
                              fontSize: 20,
                            ),
                          ),
                          const Spacer(flex: 10),
                          const Text(
                            'Görev 1',
                            style: TextStyle(
                              color: Color(0xFF07161B),
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            height: 1.0,
                            width: 180,
                            color: Color(0xFF07161B),
                          ),
                          const Spacer(flex: 9),
                          const Text(
                            'Görev 2',
                            style: TextStyle(
                              color: Color(0xFF07161B),
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            height: 1.0,
                            width: 180,
                            color: Color(0xFF07161B),
                          ),
                          const Spacer(flex: 9),
                          const Text(
                            'Görev 3',
                            style: TextStyle(
                              color: Color(0xFF07161B),
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            height: 1.0,
                            width: 180,
                            color: const Color(0xFF07161B),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF07161B),
                    minimumSize: const Size(150, 70),
                  ),
                  child: const Text('Tamam',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xFFCEC7BF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
