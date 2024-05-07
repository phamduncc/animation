import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final AnimationController heart1AnimationController =
      AnimationController(vsync: this);
  late final AnimationController heart2AnimationController =
      AnimationController(vsync: this);
  late final AnimationController cardAnimationController =
      AnimationController(vsync: this);
  final GlobalKey endKey = GlobalKey();
  late final manager = FavouriteAnimationManager(
      heart1AnimationController, heart2AnimationController);
  var count = ValueNotifier(4);
  var click = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    // manager.animationController1.forward();
    // manager.animationController2.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  count.value = 4;
                  click.value = true;

                  ///Get possition
                  var endPoint =
                      (endKey.currentContext!.findRenderObject() as RenderBox)
                          .localToGlobal(Offset.zero);
                  var endPointBottomRight =
                      endKey.currentContext!.size!.bottomRight(endPoint);
                  manager.favouritePosition1.value =
                      (manager.favouriteKey1.currentContext!.findRenderObject()
                              as RenderBox)
                          .localToGlobal(Offset.zero);
                  manager.path1 = Path()
                    ..moveTo(manager.favouritePosition1.value.dx,
                        manager.favouritePosition1.value.dy)
                    ..relativeLineTo(-25, -25)
                    ..lineTo(endPointBottomRight.dx - 50,
                        endPointBottomRight.dy - 50);
                  manager.favouritePosition2.value =
                      (manager.favouriteKey2.currentContext!.findRenderObject()
                              as RenderBox)
                          .localToGlobal(Offset.zero);
                  manager.path2 = Path()
                    ..moveTo(manager.favouritePosition2.value.dx,
                        manager.favouritePosition2.value.dy)
                    ..relativeLineTo(-25, -25)
                    ..lineTo(endPointBottomRight.dx - 50,
                        endPointBottomRight.dy - 50);
                  manager.animationController1.forward();
                  manager.animationController2.forward();
                },
                child: Container(
                  padding: const EdgeInsets.all(30),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(13)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Icon(
                            key: manager.favouriteKey1,
                            Icons.favorite_border,
                            color: Colors.indigo.shade400,
                            size: 50,
                          ).animate(),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Icon(
                            key: manager.favouriteKey2,
                            Icons.favorite_border,
                            color: Colors.indigo.shade400,
                            size: 50,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Icon(
                            Icons.favorite_border,
                            color: Colors.indigo.shade400,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(13)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Next Mines Stone"),
                              ListenableBuilder(
                                  listenable: count,
                                  builder: (context, _) {
                                    return Row(
                                      children: [
                                        Icon(
                                          key: endKey,
                                          Icons.favorite,
                                          color: Colors.indigo.shade400,
                                          size: 30,
                                        )
                                            .animate(
                                                controller:
                                                    cardAnimationController,
                                                autoPlay: false,
                                                onComplete:
                                                    (cardAnimationController) {
                                                  cardAnimationController
                                                      .reset();
                                                })
                                            .shake(),
                                        Text("${count.value}/10"),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                          ListenableBuilder(
                              listenable: count,
                              builder: (context, _) {
                                return Slider(
                                    value: count.value.toDouble(),
                                    max: 10.0,
                                    divisions: 10,
                                    activeColor: Colors.indigo.shade400,
                                    label: "",
                                    onChanged: (double value) {});
                              })
                        ],
                      ),
                    ),
                    Center(
                      child: Center(
                        child: Icon(
                          Icons.generating_tokens,
                          color: Colors.indigo.shade400,
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate(
                    controller: cardAnimationController,
                    autoPlay: false,
                  )
                  .shake(),
            ],
          ),
          ListenableBuilder(
              listenable: manager.favouritePosition1,
              builder: (context, _) {
                return SizedBox(
                  child: Icon(
                    Icons.favorite,
                    color: click.value
                        ? Colors.indigo.shade400
                        : Colors.transparent,
                    size: 50,
                  )
                      .animate(
                        autoPlay: false,
                        controller: heart1AnimationController,
                      )
                      .scale(
                          delay: 500.milliseconds,
                          duration: 2.seconds,
                          begin: const Offset(1, 1),
                          end: Offset.zero,
                          alignment: Alignment.bottomRight),
                )
                    .animate(
                        autoPlay: false,
                        controller: heart1AnimationController,
                        onComplete: (heart1AnimationController) {
                          heart1AnimationController.reset();
                          manager.reset();
                          count.value++;
                          cardAnimationController.forward();
                        })
                    .followPath(
                      delay: 500.ms,
                      duration: 2.seconds,
                      path: manager.path1,
                      // curve: Curves.easeInOutCubic,
                    );
              }),
          ListenableBuilder(
              listenable: manager.favouritePosition2,
              builder: (context, _) {
                return SizedBox(
                  child: Icon(
                    Icons.favorite,
                    color: click.value
                        ? Colors.indigo.shade400
                        : Colors.transparent,
                    size: 50,
                  )
                      .animate(
                        autoPlay: false,
                        controller: heart2AnimationController,
                      )
                      .scale(
                          delay: 600.milliseconds,
                          duration: 2.seconds,
                          begin: const Offset(1, 1),
                          end: Offset.zero,
                          alignment: Alignment.bottomRight),
                )
                    .animate(
                        autoPlay: false,
                        controller: heart2AnimationController,
                        onComplete: (heart2AnimationController) {
                          heart2AnimationController.reset();
                          manager.reset();
                          count.value++;
                          cardAnimationController.forward();
                        })
                    .followPath(
                      delay: 100.milliseconds,
                      duration: 2.seconds,
                      path: manager.path2,
                      // curve: Curves.easeInOutCubic,
                    );
              }),
          ListenableBuilder(
              listenable: count,
              builder: (context, _) {
                return Positioned(
                    bottom: 30,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: AnimatedOpacity(
                        opacity: count.value >= 6 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 30),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(23),
                                      border:
                                          Border.all(color: Colors.pinkAccent)),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.rotate_left,
                                        color: Colors.pinkAccent,
                                      ),
                                      Text(
                                        "Redesign",
                                        style:
                                            TextStyle(color: Colors.pinkAccent),
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () {}),
                            MaterialButton(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 30),
                                  decoration: BoxDecoration(
                                      color: Colors.pinkAccent,
                                      borderRadius: BorderRadius.circular(23),
                                      border:
                                          Border.all(color: Colors.pinkAccent)),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.rotate_left,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Continue",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () {}),
                          ],
                        ),
                      ),
                    ));
              })
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    heart1AnimationController.dispose();
    heart2AnimationController.dispose();
  }
}

class FavouriteAnimationManager {
  FavouriteAnimationManager(
      this.animationController1, this.animationController2);

  final AnimationController animationController1;
  final AnimationController animationController2;
  final favouriteKey1 = GlobalKey();
  final favouriteKey2 = GlobalKey();
  var favouritePosition1 = ValueNotifier(Offset.zero);
  var favouritePosition2 = ValueNotifier(Offset.zero);
  var path1 = Path();
  var path2 = Path();

  void reset() {
    favouritePosition1 = ValueNotifier(Offset.zero);
    favouritePosition2 = ValueNotifier(Offset.zero);
    path1 = Path();
    path2 = Path();
  }
}
