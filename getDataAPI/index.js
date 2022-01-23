var express = require('express');
var Web3 = require('web3');
var contractAbi = require('./contract.json').abi;

const app = express();

// Middlewares
app.use(express.json());
app.use(express.urlencoded({
  extended: true
}));




app.get('/total', async (req, res) => {
   const providerAddress = 'http://127.0.0.1:8545'
   const contractAddress = "0xc6e7DF5E7b4f2A278906862b61205850344D4e7d"
   const web3 = new Web3(providerAddress);
   var contract = new  web3.eth.Contract(contractAbi, contractAddress);
   var totalContract = await contract.methods.totalContractDeposit().call();
   return res.status(200).send({test: totalContract.toString()})
})

const port = process.env.PORT || 8000;

app.listen(port, () =>
	console.log(`Express app listening on localhost:${port}`)
);