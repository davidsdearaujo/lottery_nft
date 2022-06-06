lottery = undefined;

function lotteryConfigure(callback, errorCallback) {
  if (lottery) {
    callback();
  } else if (!window.ethereum) {
    errorCallback({
      code: 404,
      message: "Non-Ethereum browser detected. You should consider installing MetaMask.",
      stack: null,
    })
  } else if (!web3) {
    errorCallback({
      code: 404,
      message: "Web3 isn't configured. Try include this script file: 'contract/web3.js'",
      stack: null,
    })
  } else {
    const address = '0xFA4202c84D16E629a6EF3664044E63e78b718Ef1';
    const abi = [{ "inputs": [], "stateMutability": "nonpayable", "type": "constructor", "signature": "constructor" }, { "inputs": [], "name": "enter", "outputs": [], "stateMutability": "payable", "type": "function", "payable": true, "signature": "0xe97dcb62" }, { "inputs": [], "name": "getPlayers", "outputs": [{ "internalType": "address payable[]", "name": "", "type": "address[]" }], "stateMutability": "view", "type": "function", "constant": true, "signature": "0x8b5b9ccc" }, { "inputs": [], "name": "manager", "outputs": [{ "internalType": "address", "name": "", "type": "address" }], "stateMutability": "view", "type": "function", "constant": true, "signature": "0x481c6a75" }, { "inputs": [], "name": "pickWinner", "outputs": [], "stateMutability": "nonpayable", "type": "function", "signature": "0x5d495aea" }, { "inputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }], "name": "players", "outputs": [{ "internalType": "address payable", "name": "", "type": "address" }], "stateMutability": "view", "type": "function", "constant": true, "signature": "0xf71d96cb" }];

    lottery = new web3.eth.Contract(abi, address);
    callback()
  }
}

function lotteryGetManagerAddress(callback, errorCallback) {
  lottery.methods.manager().call()
    .then((response) => callback(response))
    .catch((error) => errorCallback(error))
}


function lotteryGetAccountAddress(responseCallback) {
  responseCallback(lottery.options.address)
}

function lotteryGetPlayers(callback, errorCallback) {
  lottery.methods.getPlayers().call()
    .then((players) => callback(players))
    .catch((error) => errorCallback(error))
}

function lotteryEnter(accountAddress, etherAmmount, callback, errorCallback) {
  lottery.methods.enter().send({
    from: accountAddress,
    value: web3.utils.toWei(etherAmmount, 'ether'),
  }).then(() => callback())
    .catch(
      function (error) {
        console.log(error)
        errorCallback({
          code: error.code,
          message: error.message,
          stack: error.stack
        })
      }
    )
}

function lotteryPickWinner(accountAddress, callback, errorCallback) {
  lottery.methods.pickWinner().send({
    from: accountAddress,
  }).then(() => callback())
    .catch(
      function (error) {
        console.log(error)
        errorCallback({
          code: error.code,
          message: error.message,
          stack: error.stack
        })
      }
    )
}