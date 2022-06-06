import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:lottery_flutter/app/modules/account/account_module.dart';

import '../lottery_controller.dart';

class UserInteractionCard extends StatelessWidget {
  UserInteractionCard({Key? key}) : super(key: key);

  final LotteryController controller = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            const Text(
              'Want to try your luck?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AccountDropdown(),
                    ScopedBuilder(
                      store: controller.accountBalanceStore,
                      onState: (context, AccountBalanceState state) {
                        if (state.accountBalance == null) return Container();
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text('Balance: ${state.accountBalance.toString()}'),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(width: 15),
                SizedBox(
                  height: 25,
                  width: 160,
                  child: TextFormField(
                    onChanged: controller.onAmountToEnterChanged,
                    textAlignVertical: TextAlignVertical.center,
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Amount of ether',
                      hintStyle: TextStyle(fontSize: 12),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(width: 1, color: Theme.of(context).unselectedWidgetColor),
                      ),
                      suffixIcon: TripleBuilder(
                        store: controller.lotteryEnterStore,
                        builder: (context, _) {
                          if (controller.lotteryEnterStore.isLoading) {
                            return SizedBox(
                              width: 15,
                              height: 15,
                              child: Center(
                                child: SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          }
                          return TextButton(
                            child: const Text('Enter'),
                            onPressed: () => controller.onEnterButtonPressed(context),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
