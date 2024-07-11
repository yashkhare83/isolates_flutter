import 'dart:isolate';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 104, 168, 240),
          title: Center(child: const Text('Isolates',style: TextStyle(fontSize: 13,color: Colors.white),)),
        ),
        body: Center(
          child: Column(
            children: [
              Image.asset('assets/bouncing_ball.gif'),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await complexTask1();
                  print(result);
                },
                child: const Text('using async await to perform complex task'),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () async {
                  final recievPort = ReceivePort();
                  await Isolate.spawn(complexTask2, recievPort.sendPort);
                  recievPort.listen((message) {
                    print('result is $message');
                  });
                },
                child: const Text('using isolates to perform complex task'),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Task 3'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<double> complexTask1() async {
    var total = 0.0;
    for (var i = 0; i < 100000000; i++) {
      total += i;
    }
    return total;
  }
}

// implenting sendport using isolates outside of class
void complexTask2(SendPort message) {
  var total = 0.0;
  for (var i = 0; i < 100000000; i++) {
    total += i;
  }
  message.send(total);
}
