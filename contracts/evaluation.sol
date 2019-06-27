pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

contract evaluation {
    //Admin
    address private admin;
    string private key;
    
    //Studenten Array
    address[] private studenten;
    
    //Boolean abfrage student abgestimmt?
    bool[] private abgestimmt;
    
    //Bewertungsbogen
    uint[] private fragen;
    string[] public anmerkungen;
    string private bogenHash;

    //auswertung
    uint[24] private auswertung;


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
        require(!(admin == msg.sender),"Admin darf nicht abstimmen");
        require(compareStrings(key,_key),"Key ist falsch");
        require(!(studentInListe(msg.sender)),"Student bereits in der Liste");
        studenten.push(msg.sender);
        abgestimmt.push(false);
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
        uint tmp = 0;
        uint countfalse = 0;
        if(abstimmung.length == 24){
            for(uint i = 0; i < abstimmung.length;i++){
                tmp = abstimmung[i];
                if(i<=17){
                    if(tmp > 4){
                        countfalse++;
                    }
                }
                else if(i==18){
                    if(tmp > 2){
                        countfalse++;
                    }
                }else if(i==19){
                    if(tmp > 4){
                        countfalse++;
                    }
                }else if(i==20){
                    if(tmp > 1){
                        countfalse++;
                    }
                }else if(i<=24){
                    if(tmp > 4){
                        countfalse++;
                    }
                }
            }
            if(countfalse == 0){
                return true;
            }
            else{
                return false;
            }
        }else{
            return false;
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

    function auswertungAusgabe() public {
        require(admin == msg.sender,"Nur der Admin darf auswerten");
        for(uint i = 0;i < auswertung.length;i++){
            auswertung[i] = 0;
        }
        for(uint j = 0;j < fragen.length;j++){
            auswertung[j%24] = auswertung[j%24] + fragen[j];
        }
    }

    function compareStrings (string memory a, string memory b) private view returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }

    //Funktionen die für die tests benötigt werden
    
    function getKey() public view returns (string){
        require(admin == msg.sender,"Nur der Admin kann den key einsehen");
        return key;
    }

    function getBogenhash() public view returns (string){
        require(admin == msg.sender,"Nur der Admin kann den Bogenhash einsehen");
        return bogenHash;
    }

    function getStudenten() public view returns (address[]){
        require(admin == msg.sender,"Nur der Admin darf die teilnehmer sehen");
        return studenten;
    }

    function getAuswertung() public view returns(uint[24]){
        require(admin == msg.sender,"Nur der Admin darf die Auswertung sehen");
        return auswertung;
    }

    function getAnmerkungen() public view returns(string){
        require(admin == msg.sender,"Nur der admin darf das");
        string memory rueckgabe;
        for(uint i = 0; i < anmerkungen.length;i++){
            bytes memory tmp = bytes(rueckgabe);
            if(tmp.length != 0){
                rueckgabe = string(abi.encodePacked(rueckgabe,", ",anmerkungen[i]));
            }
            else{
                rueckgabe = string(abi.encodePacked(anmerkungen[i]));
            }
        }
        return rueckgabe;
    }
}