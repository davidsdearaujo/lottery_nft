import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:lottery_flutter/app/modules/core/core_module.dart';

import '../lottery_controller.dart';

class WinnerWidget extends StatelessWidget {
  WinnerWidget({Key? key}) : super(key: key);

  final LotteryController controller = Modular.get();

  bool get isSortingWinner => controller.lotteryPickWinnerStore.isLoading;
  AddressValue? get winnerAddress => controller.lotteryPickWinnerStore.state.winnerAddress;
  bool get hasWinner => winnerAddress != null;

  @override
  Widget build(BuildContext context) {
    return TripleBuilder(
      store: controller.lotteryPickWinnerStore,
      builder: (context, _) {
        if (isSortingWinner) {
          return Column(
            children: const [
              Text('Sorteando o vencedor, aguarde por favor...'),
              Text('(esse processo pode demorar em torno de 15 segundos)'),
            ],
          );
        }

        if (hasWinner) {
          final currentAccount = controller.selectAccountStore.state.selectedAccountAddress;
          final isCurrentAccountWinner = currentAccount == winnerAddress;
          final totalAmmount = controller.lotteryDataStore.state.totalAmount;
          return Column(
            children: [
              if (isCurrentAccountWinner) ...{
                Text('Parabéns, Você venceu a loteria!'),
                Text('Foram transferidos para sua conta $totalAmmount'),
              },
              if (isCurrentAccountWinner) ...{
                Text('Não foi dessa vez que você conseguiu...'),
                Text('Mas não desista, sua sorte pode brilhar a qualquer momento!'),
                SizedBox(height: 5),
                Text('O vencedor dessa loteria foi: ${winnerAddress!.toShortString()}'),
                Text('Que levou $totalAmmount para casa!'),
              },
            ],
          );
        }

        return Container();
      },
    );
  }
}
