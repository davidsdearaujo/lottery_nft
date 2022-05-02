import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:lottery_flutter/app/modules/core/core_module.dart';
import 'package:lottery_flutter/app/modules/web3/web3_module.dart';

class SelectAccountStore extends StreamStore<Failure, SelectAccountState> with Disposable {
  final Web3Api _web3Api;
  SelectAccountStore(this._web3Api) : super(SelectAccountState.empty);

  Future<void> init() async {
    await loadAccounts();
    validateSelectedAccountAddress();
  }

  @override
  void dispose() {
    destroy();
  }

  Future<void> loadAccounts() async {
    try {
      setLoading(true);
      final accounts = await _web3Api.getAccounts();
      final accountsAddress = accounts.map((account) => AddressValue(account)).toList();
      update(state.copyWith(accounts: accountsAddress));
    } on Failure catch (failure) {
      setError(failure);
    } finally {
      setLoading(false);
    }
  }

  void selectAccount(AddressValue accountAddress) {
    update(state.copyWith(selectedAccountAddress: accountAddress));
    validateSelectedAccountAddress();
  }

  void validateSelectedAccountAddress() {
    var selectedAccountAddress = _getFirstAccountIfNotSelected();
    selectedAccountAddress ??= _getFirstAccountIfCurrentSelectedNotExists();
    selectedAccountAddress ??= state.selectedAccountAddress;
    update(state.copyWith(selectedAccountAddress: selectedAccountAddress));
  }

  AddressValue? _getFirstAccountIfNotSelected() {
    if (state.selectedAccountAddress == null) return state.accounts.first;
    return null;
  }

  AddressValue? _getFirstAccountIfCurrentSelectedNotExists() {
    if (!state.accounts.contains(state.selectedAccountAddress)) return state.accounts.first;
    return null;
  }
}

class SelectAccountState {
  final List<AddressValue> accounts;
  final AddressValue? selectedAccountAddress;

  SelectAccountState({
    required this.accounts,
    required this.selectedAccountAddress,
  });

  static SelectAccountState empty = SelectAccountState(
    accounts: [],
    selectedAccountAddress: null,
  );

  SelectAccountState copyWith({
    List<AddressValue>? accounts,
    AddressValue? selectedAccountAddress,
  }) {
    return SelectAccountState(
      accounts: accounts ?? this.accounts,
      selectedAccountAddress: selectedAccountAddress ?? this.selectedAccountAddress,
    );
  }
}
