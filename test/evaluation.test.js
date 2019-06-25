const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const provider = ganache.provider();
const web3 = new Web3(provider);

// zum deployment
const {interface, bytecode} = require('../compile');

let accounts;
let evaluation;
let key = "das_ist_ein_testkey";
var abstimmung = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
var anmerkung = 'Das ist eine TestAnmerkung';
var bogenhash = 'testhash';


beforeEach( async () => {
    accounts = await web3.eth.getAccounts();

    evaluation = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode })
    .send({ from: accounts[0], gas: '1000000' });

    evaluation.setProvider(provider);
});


describe("Evaluation Contract", () => {

    it('deploys', () => {
        //console.log(accounts);
        //console.log(msgBox);
        assert.ok(evaluation.options.address);
    });

    it('allows admin to set key', async () => {
        await evaluation.methods.setKey(key).send({
          from: accounts[0], //admin
          value: web3.utils.toWei('0.02', 'ether')
        });
    
        const key_ = await evaluation.methods.getKey().call({
          from: accounts[0]
        });
    
        assert.equal(key, _key);
      });
    
      it('allows to addStudent themselves to List', async () => {
        await evaluation.methods.addMeToList(key).send({
          from: accounts[1],
          value: web3.utils.toWei('0.02', 'ether')
        });
        await evaluation.methods.addMeToList(key).send({
          from: accounts[2],
          value: web3.utils.toWei('0.02', 'ether')
        });
        await evaluation.methods.addMeToList(key).send({
          from: accounts[3],
          value: web3.utils.toWei('0.02', 'ether')
        });
    
        const studenten = await evaluation.methods.getPlayers().call({
          from: accounts[0]
        });
    
        assert.equal(accounts[1], studenten[0]);
        assert.equal(accounts[2], studenten[1]);
        assert.equal(accounts[3], studenten[2]);
        assert.equal(3, studenten.length);
      });
    


      it('allows to evaluate', async () => {
        await evaluation.methods.evaluieren(abstimmung, anmerkung, bogenhash).send({
          from: accounts[1],
          value: web3.utils.toWei('0.02', 'ether')
        });
        await lottery.methods.evaluieren(abstimmung, anmerkung, bogenhash).send({
          from: accounts[2],
          value: web3.utils.toWei('0.02', 'ether')
        });
        await lottery.methods.evaluieren(abstimmung, anmerkung, bogenhash).send({
          from: accounts[3],
          value: web3.utils.toWei('0.02', 'ether')
        });
    
        /**const players = await lottery.methods.getPlayers().call({
          from: accounts[0]
        });
    
        assert.equal(accounts[0], players[0]);
        assert.equal(accounts[1], players[1]);
        assert.equal(accounts[2], players[2]);
        assert.equal(3, players.length);*/
      });
  /**  
      it('requires a minimum amount of ether to enter', async () => {
        try {
          await lottery.methods.enter().send({
            from: accounts[0],
            value: 0
          });
          assert(false);
        } catch (err) {
          assert(err);
        }
      });
    
      it('only admin can call pickWinner', async () => {
        try {
          await lottery.methods.pickWinner().send({
            from: accounts[1]
          });
          assert(false);
        } catch (err) {
          assert(err);
        }
      });
    
      it('sends money to the winner and resets the players array', async () => {
        await lottery.methods.enter().send({
          from: accounts[0],
          value: web3.utils.toWei('2', 'ether')
        });
    
        const initialBalance = await web3.eth.getBalance(accounts[0]);
        await lottery.methods.pickWinner().send({ from: accounts[0] });
        const finalBalance = await web3.eth.getBalance(accounts[0]);
        const difference = finalBalance - initialBalance;
    
        assert(difference > web3.utils.toWei('1.8', 'ether'));
      });
    */
});