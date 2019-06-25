pragma solidity ^0.4.25;

contract evaluation {
    //Admin
    address public admin;
    string private key;
    
    //Studenten Array
    address[] public studenten;
    
    //Boolean abfrage student abgestimmt?
    bool[] public abgestimmt;
    
    //Bewertungsbogen
    uint[] public fragen;
    string[] public anmerkungen;
    string public bogenHash;


    constructor(){
        admin = msg.sender;
    }

    function setBogenHash(string _bogenHash) public{
        require(admin == msg.sender,"Nur der Admin darf den Hash setzen");
        bogenHash = _bogenHash;
    }

    function setKey(string _key) public{
        require(admin == msg.sender,"Nur der Admin kann den Key setzen");
        key = _key;
    }

    function addMeToList(string _key) public{
        require(compareStrings(key,_key),"Key ist falsch");
        require(!(studentInListe(msg.sender)),"Student bereits in der Liste");
        studenten.push(msg.sender);
        //fragen.push(studenten.lenght);
    }

    function studentAbgestimmt(address sender) private returns (bool){
        for(uint i = 0; i < abgestimmt.length;i++){
            if(studenten[i] == sender){
                if(abgestimmt[i]){
                    //wenn bereits abgestimmt
                    return false;
                }
                else{
                    //wenn noch nicht abgestimmt
                    abgestimmt[i] = true;
                    return true;
                }
            }
        }
    }

    function studentInListe(address sender) private returns (bool){
        for(uint i = 0; i < studenten.length;i++){
            if(studenten[i] == sender){
                return true;
            }
        }
        return false;
    }

    function isAbstimmungValid(uint[] abstimmung) private returns(bool){
        for(uint i = 0; i < abstimmung.length;i++){
            if(i<=17){
                if(!(abstimmung[i]<=4)){
                    return false;
                }
            }
            if(i==18){
                if(!(abstimmung[i]<=2)){
                    return false;
                }
            }
            if(i==19){
                if(!(abstimmung[i]<=4)){
                    return false;
                }
            }
            if(i==20){
                if(!(abstimmung[i]<=1)){
                    return false;
                }
            }
            if(i<=23){
                if(!(abstimmung[i]<=4)){
                    return false;
                }
            }
        }
    }

    function isHashCorrect(string _bogenHash) private returns(bool){
        if(compareStrings(bogenHash,_bogenHash)){
            return true;
        }
        else{
            return false;
        }
    }

    function evaluieren(uint[] _abstimmung,string _anmerkung,string _bogenHash) public {
        require(studentInListe(msg.sender),"Student nicht in der Liste");
        require(studentAbgestimmt(msg.sender),"Student bereits abgestimmt");
        require(isHashCorrect(_bogenHash),"Falschen Bogen ausgewählt");
        require(isAbstimmungValid(_abstimmung),"Falsche Werte eingetragen");
        for(uint i = 0;i < _abstimmung.length;i++){
            fragen.push(_abstimmung[i]);
        }
        anmerkungen.push(_anmerkung);
    }


/**
    function auswertung() public returns(uint[24]){
        require(admin == msg.sender,"Nur der Admin darf auswerten");
        uint[24] memory _auswertung;
        for(uint i = 0;i<_auswertung.length;i++){
            _auswertung[i] = 0;
        }
        for(uint j=0;j < fragen.length;i++){
            _auswertung[j%24] += fragen[j];
        }
        for(uint k=0;k<_auswertung.length;k++){
            _auswertung[k] = percent(auswertung[k],studenten.length,1);
        }
        return _auswertung;
    }
*/
    function percent(uint numerator, uint denominator, uint precision) public constant returns(uint quotient) {

         // caution, check safe-to-multiply here
        uint _numerator  = numerator * 10 ** (precision+1);
        // with rounding of last digit
        uint _quotient =  ((_numerator / denominator) + 5) / 10;
        return (_quotient);
    }

    function compareStrings (string memory a, string memory b) public view returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }
}