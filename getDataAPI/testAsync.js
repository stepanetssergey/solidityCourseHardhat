
function timeout(ms) {
    return new Promise(resolve => {
        console.log('Timeout')
        setTimeout(resolve, ms)
    });
}

const withTimeout =  async () => {
    await timeout(5000)
    console.log('TEST 2000')
}

const main = async () => {
    withTimeout()
    console.log('TEST ASYNC');
}

main()