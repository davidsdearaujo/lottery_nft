web3 = undefined;

function configureWeb3() {
    if (!window.ethereum) {
        console.log("Non-Ethereum browser detected. You should consider installing MetaMask.")
    } else {
        window.ethereum.request({ method: "eth_requestAccounts" });
        web3 = new Web3(window.ethereum);
    }
}

function subscribeUpdates(type, responseCallback, errorCallback, disposerCallback) {
    let subscription = web3.eth.subscribe(type, (err, response) => {
        if (err) {
            console.log(err);
            errorCallback(err);
        } else {
            responseCallback();
        }
    })

    disposerCallback(() => {
        subscription.unsubscribe(function (error, success) {
            if (success) console.log('Subscription canceled');
            else {
                console.log('Subscription NOT canceled.\n');
                console.log(error);
            }
        });
    })
}


function getAccountBalance(account, responseCallback, errorCallback) {
    web3.eth.getBalance(account)
        .then((weiBalance) => {
            let etherBalance = web3.utils.fromWei(weiBalance);
            responseCallback(etherBalance)
        })
        .catch((error) => errorCallback(error));
}

function getAccounts(responseCallback, errorCallback) {
    web3.eth.getAccounts()
        .then((accounts) => responseCallback(accounts))
        .catch((error) => errorCallback(error))
}


window.addEventListener('load', () => configureWeb3());