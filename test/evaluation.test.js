const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const provider = ganache.provider();
const web3 = new Web3(provider);

// zum deployment
const {interface, bytecode} = require('../compile');

let accounts;
let evaluation;
var key = "das_ist_ein_testkey";
var abstimmung = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
var anmerkung = "Das ist eine TestAnmerkung";
var bogenhash = 'testhash';
var _key = "das_ist_ein_testkey";


beforeEach( async () => {
    accounts = await web3.eth.getAccounts();

    evaluation = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode })
    .send({ from: accounts[0], gas :'2100000'});
    evaluation.setProvider(provider);

    assert.ok(evaluation.options.address);
});


describe("Evaluation Contract", () => {

  it('Deployment only ', () => {
    assert.ok(evaluation.options.address);
  });

  it('Admin setzt einen key', async () => {
    await evaluation.methods.setKey(key).send({from: accounts[0], gas: '2100000'});
    const key_ = await evaluation.methods.getKey().call({from: accounts[0]});
    assert.equal(key, key_);
  });

  it('Admin setzt einen Bogen hash', async () => {
    await evaluation.methods.setBogenHash(bogenhash).send({from: accounts[0], gas: '2100000'});
    const bogenhash_ = await evaluation.methods.getBogenhash().call({from: accounts[0]});
    assert.equal(bogenhash,bogenhash_)
  });
  

  it('Admin setzt einen key und einen Bogen hash', async () =>{
    await evaluation.methods.setKey(key).send({from: accounts[0], gas: '2100000'});
    const key_ = await evaluation.methods.getKey().call({from: accounts[0]});
    assert.equal(key, key_);

    await evaluation.methods.setBogenHash(bogenhash).send({from: accounts[0], gas: '2100000'});
    const bogenhash_ = await evaluation.methods.getBogenhash().call({from: accounts[0]});
    assert.equal(bogenhash,bogenhash_)
  });
    
  it('Studenten Tragen sich in die liste ein mit bogenhash und key', async () => {
    //key setzen
    await evaluation.methods.setKey(key).send({from: accounts[0], gas: '2100000'});
    //bogen hash setzen
    await evaluation.methods.setBogenHash(bogenhash).send({from: accounts[0], gas: '2100000'});
    //Studenten eintragen
    await evaluation.methods.addMeToList(key).send({from: accounts[1], gas: '2100000'});
    await evaluation.methods.addMeToList(key).send({from: accounts[2], gas: '2100000'});
    await evaluation.methods.addMeToList(key).send({from: accounts[3], gas: '2100000'});
    
    const studenten = await evaluation.methods.getStudenten().call({from: accounts[0]});
    
    assert.equal(accounts[1], studenten[0]);
    assert.equal(accounts[2], studenten[1]);
    assert.equal(accounts[3], studenten[2]);
    assert.equal(3, studenten.length);
  });
    
  it('Studenten stimmen ab', async () => {
    //key setzen
    await evaluation.methods.setKey(key).send({from: accounts[0], gas: '2100000'});
    //bogen hash setzen
    await evaluation.methods.setBogenHash(bogenhash).send({from: accounts[0], gas: '2100000'});
    //Studenten eintragen
    await evaluation.methods.addMeToList(key).send({from: accounts[1], gas: '2100000'});
    await evaluation.methods.addMeToList(key).send({from: accounts[2], gas: '2100000'});
    await evaluation.methods.addMeToList(key).send({from: accounts[3], gas: '2100000'});
    //Studenten Stimmen ab
    await evaluation.methods.evaluieren(abstimmung, anmerkung, bogenhash).send({from: accounts[1], gas: '2100000'});
    await evaluation.methods.evaluieren(abstimmung, anmerkung, bogenhash).send({from: accounts[2], gas: '2100000'});
    await evaluation.methods.evaluieren(abstimmung, anmerkung, bogenhash).send({from: accounts[3], gas: '2100000'});
  });

  it('Auswertung einer Wahl',async () => {
    //key setzen
    await evaluation.methods.setKey(key).send({from: accounts[0], gas: '2100000'});
    //bogen hash setzen
    await evaluation.methods.setBogenHash(bogenhash).send({from: accounts[0], gas: '2100000'});
    //Studenten eintragen
    await evaluation.methods.addMeToList(key).send({from: accounts[1], gas: '2100000'});
    await evaluation.methods.addMeToList(key).send({from: accounts[2], gas: '2100000'});
    await evaluation.methods.addMeToList(key).send({from: accounts[3], gas: '2100000'});
    //Studenten Stimmen ab
    await evaluation.methods.evaluieren(abstimmung, anmerkung, bogenhash).send({from: accounts[1], gas: '2100000'});
    await evaluation.methods.evaluieren(abstimmung, anmerkung, bogenhash).send({from: accounts[2], gas: '2100000'});
    await evaluation.methods.evaluieren(abstimmung, anmerkung, bogenhash).send({from: accounts[3], gas: '2100000'});
    //Admin wertet aus
    await evaluation.methods.auswertungAusgabe().send({from: accounts[0], gas: '2100000'});
    const Auswertung = await evaluation.methods.getAuswertung().send({from: accounts[0], gas: '2100000'});
    for(var i = 0; i < Auswertung.length;i++){
      assert.equal(Auswertung[i],3);
    }
    /*
    *Es ist nicht möglich die Anmerkungen auszugeben weil der Compiler diese Anweisung nicht benötig werden nicht unterstützt
    *im Browser Test funktioniert die Ausgabe der Anmerkungen
    * 
    const anmerkungen1 = await evaluation.methods.getAnmerkungen(1).send({from: accounts[0], gas: '2100000'});
    console.log(anmerkungen1);
    */
  });

});