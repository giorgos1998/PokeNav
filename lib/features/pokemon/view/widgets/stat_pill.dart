import 'package:flutter/material.dart';
import 'package:pokenav/features/pokemon/data/constants.dart';

class StatPill extends StatelessWidget {
  final StatTypes stat;
  final int? value;

  const StatPill({super.key, required this.stat, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white.withAlpha(150),
      ),
      child: Row(
        // spacing: 4,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: switch (stat) {
              StatTypes.hp => Image.asset('icons/heart.png', height: 25),
              StatTypes.attack => Image.asset('icons/sword.png', height: 25),
              StatTypes.defense => Image.asset('icons/shield.png', height: 25),
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                value != null ? value.toString() : '???',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
