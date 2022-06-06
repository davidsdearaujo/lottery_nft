import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:lottery_flutter/app/modules/core/core_module.dart';

import 'lottery_controller.dart';
import 'widgets/user_interaction_card.dart';
import 'widgets/winner_widget.dart';

class LotteryPage extends StatefulWidget {
  const LotteryPage({Key? key}) : super(key: key);

  @override
  State<LotteryPage> createState() => _LotteryPageState();
}

class _LotteryPageState extends State<LotteryPage> with ErrorListMixin {
  final LotteryController controller = Modular.get();

  @override
  late List<Store> shouldListenError = [
    controller.lotteryDataStore,
    controller.lotteryEnterStore,
    controller.lotteryPickWinnerStore,
    controller.selectAccountStore,
    controller.accountBalanceStore,
  ];

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.init().then((_) => setState(() => isLoaded = true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Builder(
        builder: (context) {
          if (!isLoaded) return Center(child: CircularProgressIndicator());
          return Center(
            child: Column(
              children: [
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text('Lottery Contract', style: Theme.of(context).textTheme.headline2),
                ),
                SizedBox(height: 10),
                Container(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Column(
                    children: [
                      ScopedBuilder(
                        store: controller.lotteryDataStore,
                        onState: (context, LotteryDataState lotteryState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (lotteryState.managerAddress != null) ...{
                                Text('This contract is managed by ${lotteryState.managerAddress!.toShortString()}.'),
                              },
                              if (lotteryState.totalAmount != null) ...{
                                Text.rich(TextSpan(children: [
                                  TextSpan(text: 'There are currently '),
                                  TextSpan(
                                    text: '${lotteryState.numberOfParticipants} people entered',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: ', competing to '),
                                  TextSpan(
                                    text: 'win ${lotteryState.totalAmount}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: '!'),
                                ])),
                              },
                              SizedBox(height: 25),
                              UserInteractionCard(),
                              if (controller.isCurrentAccountManager) ...{
                                const Divider(thickness: 2),
                                const Text(
                                  'Ready to pick a winner',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                ElevatedButton(
                                  child: const Text('Pick a winner!'),
                                  onPressed: () => controller.onPickWinnerButtonPressed(context),
                                ),
                                Divider(thickness: 2),
                              },
                              TripleBuilder(
                                store: controller.lotteryEnterStore,
                                builder: (context, _) {
                                  if (!controller.lotteryEnterStore.isLoading) return Container();
                                  return Column(
                                    children: const [
                                      Text('Placing a bet, please wait...'),
                                      Text('(this process can take around 15 seconds)'),
                                    ],
                                  );
                                },
                              ),
                              WinnerWidget(),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
