import 'package:flutter/material.dart';

import 'api/lottery_api.dart';
import 'api/models/js_error.dart';
import 'home_controller.dart';
import 'value_objects/hash_value.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomeController {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<LotteryApi>(
        future: lotteryApiCompleter.future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('${snapshot.error}'));

          final lotteryApi = snapshot.data!;
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (managerHash != null) ...{
                        Text('This contract is managed by ${managerHash!.toShortString()}.'),
                      },
                      if (numberOfParticipants != null && totalAmount != null) ...{
                        Text.rich(TextSpan(children: [
                          TextSpan(text: 'There are currently '),
                          TextSpan(text: '$numberOfParticipants people entered', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ', competing to '),
                          TextSpan(text: 'win $totalAmount ether', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: '!'),
                        ])),
                      },
                      SizedBox(height: 25),
                      Card(
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
                                      if (accountsList.isNotEmpty) ...{
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Theme.of(context).unselectedWidgetColor,
                                            ),
                                          ),
                                          child: DropdownButton<HashValue>(
                                            isDense: true,
                                            underline: Container(),
                                            value: selectedAccountHash,
                                            items: List.from(accountsList.map(
                                              (accountHash) => DropdownMenuItem(
                                                value: accountHash,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    'Account: ${accountHash.toShortString()}',
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            )),
                                            onChanged: (newValue) {
                                              setState(() => selectedAccountHash = newValue);
                                              loadAccountBalance();
                                            },
                                          ),
                                        ),
                                      },
                                      if (accountBalance != null) ...{
                                        SizedBox(height: 5),
                                        Text('Balance: ${accountBalance?.toStringAsFixed(4)} ETH'),
                                      },
                                    ],
                                  ),
                                  SizedBox(width: 15),
                                  SizedBox(
                                    height: 25,
                                    width: 160,
                                    child: TextFormField(
                                      controller: controller,
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
                                        suffixIcon: TextButton(
                                          child: const Text('Enter'),
                                          onPressed: () async {
                                            try {
                                              final etherAmount = controller.text;
                                              final accounts = await web3Api.getAccounts();
                                              await lotteryApi.enter(accounts[0], double.parse(etherAmount));
                                              showDialog(
                                                context: context,
                                                builder: (context) => const AlertDialog(
                                                  title: Text('Sucesso'),
                                                  content: Text('Agora você está participando, boa sorte!'),
                                                ),
                                              );
                                              loadPlayers();
                                            } catch (ex) {
                                              String message = '';
                                              final errors = {4001: 'Participação Cancelada!'};
                                              if (ex is JsError) {
                                                message =
                                                    errors[ex.code] ?? 'Deu xabu, você NÃO está participando!!\n[${ex.code}] ${ex.message}';
                                              }
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(content: Text(message)),
                                              );
                                              loadPlayers();
                                            }
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
                      ),
                      if (isCurrentAccountManager) ...{
                        const Divider(thickness: 2),
                        const Text(
                          'Ready to pick a winner',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            //TODO: Implements Pick a Winner
                            // lotteryApi.pickWinner();
                          },
                          child: const Text('Pick a winner!'),
                        ),
                      },
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
