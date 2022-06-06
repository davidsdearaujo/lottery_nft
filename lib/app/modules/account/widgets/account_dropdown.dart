import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:lottery_flutter/app/modules/core/core_module.dart';

import '../stores/select_account_store.dart';

class AccountDropdown extends StatelessWidget {
  final void Function(AddressValue)? onAccountChanged;
  AccountDropdown({Key? key, this.onAccountChanged}) : super(key: key);

  final SelectAccountStore selectAccountStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder(
      store: selectAccountStore,
      onState: (context, SelectAccountState state) {
        if (state.accounts.isEmpty) return Container();
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).unselectedWidgetColor,
            ),
          ),
          child: DropdownButton<AddressValue>(
            isDense: true,
            underline: Container(),
            value: state.selectedAccountAddress,
            items: List.from(state.accounts.map(
              (accountAddress) => DropdownMenuItem(
                value: accountAddress,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    'Account: ${accountAddress.toShortString()}',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            )),
            onChanged: (newValue) {
              if (newValue != null) {
                selectAccountStore.selectAccount(newValue);
                onAccountChanged?.call(newValue);
              }
            },
          ),
        );
      },
    );
  }
}
