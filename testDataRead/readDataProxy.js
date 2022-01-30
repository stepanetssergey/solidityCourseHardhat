var { tronWeb } = require('./initTronWeb');
var proxyContractABI = require('./proxyContractABI.json').abi;
var customerContractABI = require('./customerContractABI.json').abi;
var ethers = require('ethers');



const AbiCoder = ethers.utils.AbiCoder;
// const ADDRESS_PREFIX_REGEX = /^(41)/;
const ADDRESS_PREFIX = '41';

async function decodeParams(
    types,
    output,
    // ignoreMethodHash: boolean | string,
  ) {
    const abiCoder = new AbiCoder();
  
    // if (output.replace(/^0x/, '').length % 64)
    //     throw new Error('The encoded string is not valid. Its length must be a multiple of 64.');
    return abiCoder.decode(types, output).reduce((obj, arg, index) => {
      if (types[index] === 'address')
        arg = ADDRESS_PREFIX + arg.substr(2).toLowerCase();
      obj.push(arg);
      return obj;
    }, []);
  }


async function readDataFromProxy() {
    const TronWeb = await tronWeb();
    var proxyAddress = "TJ7uthW9ehad2eXFfT5pCXKtcKvqZ7iuGC";
    var proxycontract = await TronWeb.contract(proxyContractABI, proxyAddress);
    var result = await proxycontract.CustomerContractByAddress("TPHqBVndynYcwFXYu7DywdhhWo7nVTQJzs").call();
    console.log(TronWeb.address.fromHex(result))

    var addDeposit = await TronWeb.transactionBuilder.triggerSmartContract(
        TronWeb.address.fromHex(result),
        'addCustomerData(address,uint256)',
        {},
        [
          { type: 'address', value: 'TPHqBVndynYcwFXYu7DywdhhWo7nVTQJzs' },
          {
            type: 'uint256',
            value: 100000000
          },
        ],
        'TPHqBVndynYcwFXYu7DywdhhWo7nVTQJzs',
      );
    const signedTransaction = await TronWeb.trx.sign(
        addDeposit.transaction,
    );
    const broadcast = await TronWeb.trx.sendRawTransaction(signedTransaction);

    deposit =
            await TronWeb.transactionBuilder.triggerConstantContract(
               TronWeb.address.fromHex(result),
              'CustomersDeposit(address)',
              {},
              [
                { type: 'address', value: 'TPHqBVndynYcwFXYu7DywdhhWo7nVTQJzs' },
              ],
            );
    
    console.log(deposit.constant_result[0])
    customerDeposit = await decodeParams(
        ['uint256'],
        '0x' + deposit.constant_result[0],
      );
    console.log(customerDeposit.toString());
}

readDataFromProxy();