pragma solidity ^0.4.25;

contract bewertungen{
    int int_bewertungsnummer;
    string str_frage;

    constructor(int initialBewertungsnummer, string initialFrage)public{
        if(initialBewertungsnummer >= 1 && initialBewertungsnummer <=5){
            int_bewertungsnummer = initialBewertungsnummer;
        }

        str_frage = initialFrage;
        }

      function setFrage(string newFrage) public {
        str_frage = newFrage;
    }

    function getFrage() public view returns (string) {
        return str_frage;
    }



    function getBewertungsnummer() public view returns (int){

        return int_bewertungsnummer;
   }

   function setBewertungsnummer(int newBewertungsnummer) public {
         if(newBewertungsnummer >= 1 && newBewertungsnummer <=5){
            int_bewertungsnummer = newBewertungsnummer;
        }
   }


}



contract bewertungsbogen {
    string public fach;
    bewertungen[10] arr_bewertungen;
    
    

    constructor (string initialFach) public {
        fach = initialFach;
    }


    function setFach(string newFach) public {
        fach = newFach;
    }

    function getFach() public view returns (string) {
        return fach;
    }



    function getBewertungen() public view returns (bewertungen[10]){
        return arr_bewertungen;
   }

   function setBewertungen(bewertungen[10] newBewertungen) public {
        arr_bewertungen = newBewertungen;
   }



}

contract evaluation {
    bewertungsbogen[] public boegen;

    constructor (bewertungsbogen[] initialBewertung) public {
        boegen = initialBewertung;
    }

    function setBewertungsboegen(bewertungsbogen[] newBewertungsbogen) public {
        boegen = newBewertungsbogen;
    }

    function getBewertungsboegen() public view returns (bewertungsbogen[]) {
        return boegen;
    }
}