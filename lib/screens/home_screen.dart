import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/card_item_model.dart';
import '../providers/todo_provider.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/today_info.dart';
import '../widgets/welcome_part_widget.dart';
import 'card_item_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final appColors = [
    const Color.fromRGBO(231, 129, 109, 1.0),
    const Color.fromRGBO(99, 138, 223, 1.0),
    const Color.fromRGBO(111, 194, 173, 1.0)
  ];
  int cardIndex = 0;
  final ScrollController scrollController = ScrollController();
  var currentColor = const Color.fromRGBO(231, 129, 109, 1.0);

  final cardsList = [
    CardItemModel("Personal", Icons.account_circle),
    CardItemModel("Work", Icons.work),
    CardItemModel("Home", Icons.home)
  ];

  late AnimationController animationController;
  late ColorTween colorTween;
  late CurvedAnimation curvedAnimation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoProvider.notifier);
    return Scaffold(
      backgroundColor: currentColor,
      appBar: AppBarWidget(currentColor: currentColor),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomePart(),
            const TodayInfo(),
            SizedBox(
              height: 350.0,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    int unCompletedTodo =
                        todos.unCompletedTodo(cardsList[index].cardTitle);
                    int completedTodo =
                        todos.completedTodo(cardsList[index].cardTitle);
                    double perc =
                        completedTodo / (completedTodo + unCompletedTodo);

                    return GestureDetector(
                      onHorizontalDragEnd: _onCardSwipe,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CardItemDetailScreen(
                              cardItem: cardsList[index],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Hero(
                          tag:
                              cardsList[index].cardTitle, // Unique tag for Hero
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: SizedBox(
                              width: 250.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(cardsList[index].icon,
                                            color: appColors[index]),
                                        const Icon(Icons.more_vert,
                                            color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("$unCompletedTodo Tasks",
                                            style: const TextStyle(
                                                color: Colors.grey)),
                                        Text(cardsList[index].cardTitle,
                                            style: const TextStyle(
                                                fontSize: 28.0)),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: LinearProgressIndicator(
                                                  backgroundColor: Colors.grey
                                                      .withOpacity(0.1),
                                                  color: appColors[index],
                                                  value: (perc.isNaN ||
                                                          perc.isInfinite)
                                                      ? 0
                                                      : perc),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                '${((perc.isNaN || perc.isInfinite) ? 0 : perc * 100).toStringAsFixed(0)} %')
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      drawer: const Drawer(),
    );
  }

  void _onCardSwipe(DragEndDetails details) {
    int newCardIndex = cardIndex;

    if (details.velocity.pixelsPerSecond.dx > 0 && cardIndex > 0) {
      newCardIndex--;
    } else if (details.velocity.pixelsPerSecond.dx < 0 && cardIndex < 2) {
      newCardIndex++;
    }

    if (newCardIndex != cardIndex) {
      cardIndex = newCardIndex;
      _startColorAnimation(appColors[cardIndex]);
      scrollController.animateTo(
        (cardIndex) * 256.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void _startColorAnimation(Color endColor) {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );

    colorTween = ColorTween(begin: currentColor, end: endColor);

    animationController.addListener(() {
      setState(() {
        currentColor = colorTween.evaluate(curvedAnimation)!;
      });
    });

    colorTween.animate(curvedAnimation);
    animationController.forward();
  }
}
