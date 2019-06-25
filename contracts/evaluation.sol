pragma solidity ^0.4.25;

contract evaluation {
    address public admin;
    //Studenten adresse (neu)
    address[] public students;
    Fragebogen[] fragebogen;

    //Wie ist das so?
    fragebogen.frage_fuenfer[0].frage_f = "TestFrage?";


    // Faecher
    struct Fach {
        string name;
        string dozent_name;
        int anzahl_teilnehmer;
    }

    struct Frage_fuenfer {
        string frage_f;
        int punkte_f;
    }
    struct Frage_dreier{
        string frage_d;
        int punkte_d;
    }
    struct Frage_bool{
        string frage_b;
        int punkte_b;
    }
    struct Anmerkung{
        string frage_a;
        string text;
    }
    // Bewertungsbogen
    struct Fragebogen {
       //1 Fach
       Fach fach;
       // eine Frage mit drei anwortmöglichkeiten
       Frage_dreier frage_dreier;
       // eine Anmerkung
       Anmerkung anmerkung;

        // eine Frage mit Ja/nein
       Frage_bool frage_bool;

       // dreiundzwanzig Fragen mit fünf antworten
       Frage_fuenfer[23] frage_fuenfer;

    }

    constructor()public{
        admin = msg.sender 
    }

    function setFragebogen(String namefach, String name_dozent, int anzahl_teilnehmer){
        require(msg.sender == admin, "Kann nur der Lehrer festlegen.");
 
    }





    function setNameFaecher(string newName) public {
        require(msg.sender == admin, "Kann nur der Lehrer festlegen.");
        
        faecherStruct.name = newName;
    }

    function getNameFaecher() public view returns (string) {
        return faecherStruct.name;
    }

    function setAnzahlTeilnehmer(int newAnzahlTeilnehmer) public {
        require(msg.sender == admin, "Kann nur der Lehrer festlegen.");
        faecherStruct.anzahl_teilnehmer = newAnzahlTeilnehmer;
    }

    function getAnzahlTeilnehmer() public view returns (int) {
        return faecherStruct.anzahl_teilnehmer;
    }

    

    // hier Fragen festlegen
    function setFrage(string newFrage) public {
        require(msg.sender == admin, "Kann nur der Lehrer festlegen.");
        alle_Bewertungen_mit_FragenStruct.str_frage = newFrage;
    }

    function getFrage() public view returns (string) {
        return alle_Bewertungen_mit_FragenStruct.str_frage;
    }

    function setBewertungsnummer(int newBewertungsnummer) public {
        require(newBewertungsnummer >= 1 && newBewertungsnummer <= 5, "Bewertung von 1 bis 5.");
            alle_Bewertungen_mit_FragenStruct.int_bewertungsnummer = newBewertungsnummer;
   }

    function getBewertungsnummer() public view returns (int) {
        return alle_Bewertungen_mit_FragenStruct.int_bewertungsnummer;
   }

 

    // hier Fächer festlegen
    function setFach(faecher[] newFach) public {
        alle_Bewertungsboegen_fuer_bestimmte_FaecherStruct.arr_faecher = newFach;
    }

    function getFach() public view returns (string) {
        return alle_Bewertungsboegen_fuer_bestimmte_FaecherStruct.arr_faecher;
    }

    function setBewertungen(alle_Bewertungen_mit_Fragen[10] newBewertungen) public {
        alle_Bewertungsboegen_fuer_bestimmte_FaecherStruct.arr_bewertungsbogen = newBewertungen;
   }

    function getBewertungen() public view returns (alle_Bewertungen_mit_Fragen[10]) {
        return alle_Bewertungsboegen_fuer_bestimmte_FaecherStruct.arr_bewertungsbogen;
   }



}