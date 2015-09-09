#define LANGUAGE_DIR SOURCE_ROOT + '..\bin\innosetup\Languages';

[Languages]
Name: en;    MessagesFile: compiler:Default.isl
Name: af;    MessagesFile: {#LANGUAGE_DIR}\Afrikaans.isl
Name: al;    MessagesFile: {#LANGUAGE_DIR}\Albanian.isl
Name: am;    MessagesFile: {#LANGUAGE_DIR}\Armenian.islu
Name: ar;    MessagesFile: {#LANGUAGE_DIR}\Arabic.isl
Name: be;    MessagesFile: {#LANGUAGE_DIR}\Bengali.islu
Name: bo;    MessagesFile: {#LANGUAGE_DIR}\Bosnian.isl
Name: br_pt; MessagesFile: {#LANGUAGE_DIR}\BrazilianPortuguese.isl
Name: cns;   MessagesFile: {#LANGUAGE_DIR}\ChineseSimplified.isl
Name: cr;    MessagesFile: {#LANGUAGE_DIR}\Corsican.isl
Name: cro;   MessagesFile: {#LANGUAGE_DIR}\Croatian.isl
Name: cz;    MessagesFile: {#LANGUAGE_DIR}\Czech.isl
Name: da;    MessagesFile: {#LANGUAGE_DIR}\Danish.isl
Name: de;    MessagesFile: {#LANGUAGE_DIR}\German.isl
Name: es;    MessagesFile: {#LANGUAGE_DIR}\Spanish.isl
;Name: es_as; MessagesFile: {#LANGUAGE_DIR}\Asturian.isl
;Name: es_ca; MessagesFile: {#LANGUAGE_DIR}\Catalan.isl
;Name: es_eus; MessagesFile: {#LANGUAGE_DIR}\Basque.isl
;Name: es_va; MessagesFile: {#LANGUAGE_DIR}\Valencian.isl
Name: fi;    MessagesFile: {#LANGUAGE_DIR}\Finnish.isl
Name: fr;    MessagesFile: {#LANGUAGE_DIR}\French.isl
Name: gr;    MessagesFile: {#LANGUAGE_DIR}\Greek.isl
Name: he;    MessagesFile: {#LANGUAGE_DIR}\Hebrew.isl
Name: hi;    MessagesFile: {#LANGUAGE_DIR}\Hindi.islu
Name: hu;    MessagesFile: {#LANGUAGE_DIR}\Hungarian.isl
Name: in;    MessagesFile: {#LANGUAGE_DIR}\Indonesian.isl
Name: it;    MessagesFile: {#LANGUAGE_DIR}\Italian.isl
Name: ja;    MessagesFile: {#LANGUAGE_DIR}\Japanese.isl
Name: kor;   MessagesFile: {#LANGUAGE_DIR}\Korean.isl
Name: nl;    MessagesFile: {#LANGUAGE_DIR}\Dutch.isl
Name: nr;    MessagesFile: {#LANGUAGE_DIR}\Norwegian.isl
Name: pl;    MessagesFile: {#LANGUAGE_DIR}\Polish.isl
Name: pt;    MessagesFile: {#LANGUAGE_DIR}\Portuguese.isl
Name: ru;    MessagesFile: {#LANGUAGE_DIR}\Russian.isl
Name: sbc;   MessagesFile: {#LANGUAGE_DIR}\SerbianCyrillic.isl
Name: sbl;   MessagesFile: {#LANGUAGE_DIR}\SerbianLatin.isl
Name: sk;    MessagesFile: {#LANGUAGE_DIR}\Slovak.isl
Name: sl;    MessagesFile: {#LANGUAGE_DIR}\Slovenian.isl
Name: sw;    MessagesFile: {#LANGUAGE_DIR}\Swedish.isl
Name: th;    MessagesFile: {#LANGUAGE_DIR}\Thai.isl
Name: tr;    MessagesFile: {#LANGUAGE_DIR}\Turkish.isl
Name: ukr;   MessagesFile: {#LANGUAGE_DIR}\Ukrainian.isl
Name: ukr;   MessagesFile: {#LANGUAGE_DIR}\Uzbek.isl
Name: vt;    MessagesFile: {#LANGUAGE_DIR}\Vietnamese.isl

[Messages]
; Define the wizard title and the tray status message.
; We are overwriting these values. They are defined in "/bin/innosetup/default.isl".

SetupAppTitle=Setup WPN-XM {#APP_VERSION}
SetupWindowTitle=Setup - {#APP_NAME} {#APP_VERSION}

[CustomMessages]
; Define custom message values for {cm:...} constants.
; The first language is the default language.

; english
en.HelpButton=Help
en.RemoveApp=Uninstall WPN-XM Server Stack
en.ReportBug=Report Bug

; german
de.HelpButton=Hilfe
de.RemoveApp=WPN-XM Server Stack deinstallieren
de.ReportBug=Fehler melden

; no language
WebsiteButton=wpn-xm.org
