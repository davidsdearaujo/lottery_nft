import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? managerId = '';
  int? numberOfParticipants = 0;
  int? totalAmount = 0;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Lottery Contract'),
        Text('This contract is managed by $managerId.'),
        Text(
            'There are currently $numberOfParticipants people entered, competing to win $totalAmount ether!'),
        const Divider(thickness: 2),
        const Text(
          'Want to try your luck?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Amount of ether to enter',
          ),
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Enter')),
        const Divider(thickness: 2),
        const Text(
          'Ready to pick a winner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Pick a winner!')),
      ],
    );
  }
}
