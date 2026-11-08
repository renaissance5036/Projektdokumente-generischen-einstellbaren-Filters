Vorabklärungen serielle Schnittstelle - Erstellt durch Stefan Foltrauer 

Dieser Ordner enthält die Zip-Datei "Register_Vorabklärung.zip" mit VHDL-Dateien und den Stärken- und Schwächen Analyse der Konfigurationsschnittstellen ("Stärken und Schwächen Analyse für die serielle Schnittstelle.pdf").
Im Zuge der Vorabklärungen für das Projekt: Design eines generischen, einstellbaren Filters für die digitale Verarbeitung biologischer Signale im Modul 5512 Projektarbeit wurden analysiert, welche Konfigurationsschnittstelle für das Projekt am geeignetsten ist und wie man die empfangenen Filterkoeffizienten in ein Register einlesen kann. 

In der Stärken- und Schwächen Analyse wurden verschiedene serielle Schnittstellen miteinander Verglichen und so zu bestimmen, welche Schnittstelle für das Projekt am geeignetsten ist. Die Wahl ist auf UART gefallen, vor JTAG und UART. Falls es im Zuge der Umsetzungen zu unerwarteten Problemen kommt, kann eine andere serielle Schnittstelle gewählt werden.

Das Ziel der Register_Vorabklärung war es nicht einen Prototypen für die Schnittstelle zu erstellen, sondern abzuklären wie man die übermittelten Filterkoeffizienten in ein Register einlesen kann. Im Sinne dieser Abklärung war es egal, ob die Schnittstelle eine SPI, UART oder JTAG geworden wäre. 
Der Prototyp wurde Anhand des SPI-Slave Beispiels[1] mit der Hilfe von ChatGPT erstellt. Die TB wurde selber erstellt und deren Grundstruktur wurde aus einem anderen Projekt (5524-Digitalprojekt von Stefan Foltrauer ohne Referenz) übernommen. Es wurden Dateiköpfe eingefügt, jedoch sind nicht viele Kommentare vorhanden, da diese Dateien nicht zum Endprodukt des Projektes gehören. In diesem Sinne wurde ebenfalls keine Versionsbezeichnung eingefügt, da es sich dabei nach meinem Verständnis um kein offizielles Dokument handelt. 

Die Zeit für die Register_Vorabklärung wird nicht zum Projekt dazugezählt, da dies als kleinere Vorabklärung angesehen wird. Die Zeit für die Stärken- und Schwächen Analyse der Konfigurationsschnittstellen wird zur Planung gezählt, da es sich dabei um eine Vorarbeit für das Pflichtenheft handelt. Beide Vorabklärungen werden aus übersichtsgründen im gleichen Ordner zusammengefasst, da sie beide im Zusammenhang mit der seriellen Schnittstelle stehen. 

Referenz:
[1] S. Larson, „SPI Slave (VHDL),“ DigiKey TechForum, 16. März 2021 [Online]. Zugriff: https://forum.digikey.com/t/spi-slave-vhdl/12721, 17. Okt. 2026.

Anhang: 
ChatGPt von OpenAI wurde zum recherchieren und zum erstellen des Literaturverzeichnis für die Stärken- und Schwächen Analyse der Konfigurationsschnittstellen verwendet. Dieser Hinweis befindet sich ebenfalls im Dokument "Stärken und Schwächen Analyse für die serielle Schnittstelle_V1.0.0.pdf". 
Für den SPI-Slave Prototyp wurde ChatGPT von OpenAI zum bearbeiten und erstellen des SPI-Slaves, der Top-Level und des Registers verwendet. Es wurde ebenfalls für allgemeine Fragen verwendet.
