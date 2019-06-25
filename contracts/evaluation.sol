pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

contract evaluation {
    address public admin;
    address[] public students;
    faecher faecherStruct;
    alle_Bewertungen_mit_Fragen alle_Bewertungen_mit_Fragen_Struct;
    alle_Bewertungsboegen_fuer_bestimmte_Faecher alle_Bewertungsboegen_fuer_bestimmte_Faecher_Struct;

    // Faecher
    struct faecher {
        string name;
        int anzahl_teilnehmer;
    }

    function setNameFaecher(string newName, int anzahl_teilnehmer) public {
        require(msg.sender == admin, "Kann nur der Lehrer festlegen.");
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

    // Bewertungsbogen
    struct alle_Bewertungen_mit_Fragen {
        string str_frage;
        int int_bewertungsnummer;
    }

    // hier Fragen festlegen
    function setFrage(string newFrage) public {
        require(msg.sender == admin, "Kann nur der Lehrer festlegen.");
        alle_Bewertungen_mit_Fragen_Struct.str_frage = newFrage;
    }

    function getFrage() public view returns (string) {
        return alle_Bewertungen_mit_Fragen_Struct.str_frage;
    }

    function setBewertungsnummer(int newBewertungsnummer) public {
        require(newBewertungsnummer >= 1 && newBewertungsnummer <= 5, "Bewertung von 1 bis 5.");
            alle_Bewertungen_mit_Fragen_Struct.int_bewertungsnummer = newBewertungsnummer;
   }

    function getBewertungsnummer() public view returns (int) {
        return alle_Bewertungen_mit_Fragen_Struct.int_bewertungsnummer;
   }

    // Bewertungsbogen für Faecher
    struct alle_Bewertungsboegen_fuer_bestimmte_Faecher {
        // Anzahl der gesetzten Faecher
        faecher[5] arr_faecher;
        // Anzahl der gesetzten Teilnehmer
        alle_Bewertungen_mit_Fragen[10] arr_bewertungsbogen;
    }

    // hier Fächer festlegen
    function setFach(string newFach) public {
        alle_Bewertungsboegen_fuer_bestimmte_Faecher_Struct.arr_faecher = newFach;
    }

    function getFach() public view returns (string) {
        return alle_Bewertungsboegen_fuer_bestimmte_Faecher_Struct.arr_faecher;
    }

    function setBewertungen(alle_Bewertungen_mit_Fragen[] newBewertungen) public {
        alle_Bewertungsboegen_fuer_bestimmte_Faecher_Struct.arr_bewertungsbogen = newBewertungen;
   }

    function getBewertungen() public view returns (alle_Bewertungen_mit_Fragen[]) {
        return alle_Bewertungsboegen_fuer_bestimmte_Faecher.arr_bewertungsbogen;
   }

    // für Lehrer und Studenten
    constructor(string initialNameFaecher, int initialAnzahlTeilnehmer, string initialFrage, int initialBewertungsnummer) public {
        require(initialBewertungsnummer >= 1 && initialBewertungsnummer <= 5, "Bewertung von 1 bis 5.");
        alle_Bewertungen_mit_Fragen.int_bewertungsnummer = initialBewertungsnummer;
        require(msg.sender == admin, "Kann nur der Lehrer festlegen.");
        faecherStruct.name = initialNameFaecher;
        faecherStruct.anzahl_teilnehmer = initialAnzahlTeilnehmer;
        alle_Bewertungsboegen_fuer_bestimmte_Faecher_Struct.str_frage = initialFrage;
    }

}