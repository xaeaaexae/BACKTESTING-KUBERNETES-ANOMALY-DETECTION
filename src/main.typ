// #import "@preview/scholarly-epfl-thesis:0.1.0": template, front-matter, main-matter, back-matter

#import "lib.typ": template, front-matter, main-matter, back-matter

#show: template.with(author: "Adam Grossenbacher")

#set text(lang: "FR")

#set page(numbering: none)
#include "head/cover-page.typ"

// #show: front-matter
#show: main-matter

#include "head/acknowledgements.typ"

// #include "head/preface.typ"

#include "head/abstracts.typ"

#outline(title: "Table des matières", depth:2)
#outline(title: "Liste des figures", target: figure.where(kind: image))



//#outline(title: "List of Tables", target: figure.where(kind: table))
//#outline(title: "List of Listings", target: figure.where(kind: raw))


#include "main/ch1_introduction.typ"
#include "main/ch2_analyse.typ"
#include "main/ch3_conception.typ"
#include "main/ch4_implementation.typ"
#include "main/ch5_evaluation.typ"
#include "main/ch5_amelioration.typ"
#include "main/ch6_resultats.typ"
#include "main/ch7a_durabilite.typ"
#include "main/ch7_conclusion.typ"


#show: back-matter

#include "tail/glossaire.typ"
// #include "tail/appendix.typ"
#include "tail/biblio.typ"
#include "tail/ch_99_annexes.typ"
// #include "tail/cv/cv"


