enum ListenTypeEnum {
  ///Subscribes to incoming block headers. This can be used as timer to check for changes on the blockchain.
  newBlockHeaders,

  ///Subscribes to incoming pending transactions.
  pendingTransactions,

  ///Subscribe to syncing events. This will return an object when the node is syncing and when it’s finished syncing will return FALSE.
  syncing,

  ///Subscribes to incoming logs, filtered by the given options. If a valid numerical fromBlock options property is set, Web3 will retrieve logs beginning from this point, backfilling the response as necessary.
  logs,
}
