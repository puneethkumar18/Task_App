import 'package:flutter/material.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/home/widgets/task_card.dart';

class HomePage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (_) => const HomePage(),
      );
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Tasks",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                size: 30,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: TaskCard(
                    color: Color.fromRGBO(246, 222, 194, 1),
                    headerText: "This is MY Card",
                    descriptionText:
                        "this is the description my card i need to do by the end of this month this is the description my card i need to do by the end of this month",
                  ),
                ),
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: strengthnColor(
                      const Color.fromRGBO(246, 222, 194, 1),
                      0.69,
                    ),
                  ),
                ),
                const Text(
                  "10:00 PM",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )
              ],
            )
          ],
        ));
  }
}
