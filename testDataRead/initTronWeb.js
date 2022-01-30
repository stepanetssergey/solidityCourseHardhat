const TronWeb = require('tronweb')

const tronWeb = () => {
    const fullNode = 'https://api.shasta.trongrid.io';
    const solidityNode = 'https://api.shasta.trongrid.io';
    const eventServer = 'https://api.shasta.trongrid.io';
    const privateKey = '82f25866eed736697e004ab2bb15b48323eb1f90326d24084b6664afe1995b61';
    // const fullNode = 'https://api.trongrid.io';
    // const solidityNode = 'https://api.trongrid.io';
    // const eventServer = 'https://api.trongrid.io';
    // const privateKey = '4c9e3cc79e2ca287f6694e1892083d7c0697724edf4e443a6fb5c89c25a8a1e5';
    return new TronWeb(fullNode,solidityNode,eventServer,privateKey);
}

 module.exports.tronWeb = tronWeb;

