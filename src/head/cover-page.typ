#page(
  numbering: none, margin: (y: 6cm), {
    set text(font: "Latin Modern Sans")

    align(
      center, [
        #let v-skip = v(1em, weak: true)
        #let v-space = v(2em, weak: true)
        #let v-space-xl = v(4em, weak: true)

        #image("../images/heia-fr-logo.jpg", width: 12cm)
        
        #text(size: 18pt)[
          SYSTÈME DE BACKTESTING HÉBERGÉ SUR \
          KUBERNETES POUR LA DÉTECTION D'ANOMALIES
        ]

        #v-space-xl

        #text(size: 15pt, fill: rgb("#000"))[
          RAPPORT
        ]

        #text(size: 13pt, fill: rgb("#000"))[
          Adam Grossenbacher
        ]

        #v-space

        #v(1fr)

        #grid(
          columns: (1fr, 57%), align(horizon, image("../images/icosys-lysr-hessofr-logo.png", width: 70%)), align(left)[
            *Travail de Bachelor*\
            Filière ISC, orientation Ingénierie des Données\
            Haute école d'ingénierie et d'architecture de Fribourg\
            ID : B24ISC30\
            #v-skip
            *Superviseurs*\
            Jean Hennebert\
            Jonathan Rial\
            Jonathan Donzallaz\
            Beat Wolf \
            #v-skip
            *Mandants*\
            iCoSys \
            LYSR sàrl\
            #v-skip
            *Experts*\
            Gérôme Bovet\
            Geoffrey Papaux\
            #v-space
            Fribourg, juillet 2024
          ],
        )
      ],
    )
  },
)
#pagebreak()
#set page(numbering: none)