#let v-skip-null = v(-0.05em, weak: true)
#let v-skip-xxs = v(1em, weak: true)
#let v-skip-xs = v(2em, weak: true)
#let v-skip-s = v(3em, weak: true)
#let v-skip-m = v(4em, weak: true)
#let v-skip-l= v(5em, weak: true)

= Durabilité

#set heading(outlined:false)

"_L’impact des TIC est particulièrement important en termes d’émissions globales de gaz à effet de serre (GES), de consommation d’électricité et d’épuisement de ressources et métaux rares. Au niveau mondial, le numérique représente 3 à 4% des émissions de gaz à effet de serre, lesquelles pourraient doubler voire tripler d’ici 2030 , entrant ainsi en contradiction avec les objectifs climatiques de réduction des émissions de gaz à effet de serre._" @durabilite 

Une constation de l'OFS (mai 2024) qui va à l'encontre des dix-sept Objectifs de Développement Durable (ODD) que les États membres de l'ONU doivent atteindre d'ici 2030. @ODD.

#v-skip-m

#figure(
 image("../images/odd.png", width: 90%), caption: [Objectifs de développement durable @ODD] 
)

== Impact des TIC sur le développement durable

La fabrication des infrastructures de détection d'anomalies nécessite des matériaux rares et polluants causant des dommages environnementaux et des violations des droits humains lors de leur extraction @durabilite, comme l'or souvent exploité dans des conditions sociales et écologiques déplorables selon WWF @durabilite3. De plus, la gestion et le recyclage des déchets électroniques ne sont pas toujours adéquats. Les systèmes de détection d'anomalies, fonctionnant avec des modèles d'IA, consomment beaucoup d'énergie, augmentant ainsi l'empreinte carbone.


== Durabilité dans le contexte de la détection d'anomalies

La détection d'anomalies peut contribuer aux industries, à la santé, aux villes et à l'environnement en se rapportant aux objectifs de développement durable suivants :

*Consommation et production responsables (ODD 12)*

La détection d’anomalies dans les données industrielles, comme le fait LYSR, permet une maintenance prédictive efficace, réduisant ainsi le gaspillage de ressources et améliorant l'efficacité des processus industriels. Réduire le gaspillage permet de diminuer l'extraction de matériaux potentiellement rares et nuisibles ainsi que la production et le transport nécessitant beaucoup d'énergie et de matières premières.

*Bonne santé et bien-être (ODD 3)*

La détection d'anomalies dans les données médicales permet l'identification précoce de maladies grâce à l'analyse de signaux vitaux, de tests de laboratoire et d'imageries médicales. En améliorant les capacités de diagnostic et de traitement rapide, cette technologie contribue significativement à la santé et au bien-être des patients.

*Villes et communautés durables (ODD 11)*

La surveillance des infrastructures urbaines par détection d'anomalies peut prévenir les pannes dans les systèmes de transport, l'approvisionnement en eau et les réseaux électriques. En optimisant l'utilisation des ressources et en assurant la continuité des services essentiels, cette technologie soutient le développement durable des communautés urbaines.

#pagebreak()
*Lutte contre le changement climatique (ODD 13)*

En analysant les données climatiques et environnementales, la détection d'anomalies aide à repérer les signes avant-coureurs de phénomènes météorologiques extrêmes ou de catastrophes naturelles. Cette capacité renforce les systèmes d'alerte précoce, permettant des réponses rapides et efficaces pour contrer la nature.

#v-skip-m

En résumé, bien que la détection d'anomalies ait de nombreuses indications, elle ne constitue pas, à ce jour, une solution pour résoudre tous les objectifs de développement durable. Il est cependant certain que, dans un proche avenir, ses domaines d'application ne vont cesser de croître.

== Durabilité du système de backtesting développé

Comme mentionné précédemment, l'infrastructure informatique pose des défis en matière de développement durable, bien qu'il existe des solutions pour rendre les TIC plus durables. Par exemple, la nouvelle puce M3 d'Apple offre des performances comparables à la puce M1 tout en réduisant la consommation d'énergie de moitié @apple.

Dans ce travail de bachelor, le système de backtesting développé minimise son impact grâce aux technologies utilisées, telles que Kubernetes, qui contribue à une meilleure gestion de la consommation d'énergie des serveurs grâce à ses fonctionnalités d'équilibrage de charge, de gestion des ressources et d'évolutivité automatique @kube-eco. Le script de backtesting a été conçu pour optimiser les calculs et éviter les opérations inutiles, réduisant ainsi la consommation d'énergie. Cependant, l'infrastructure utilisée est celle de la HEIA-FR, sur laquelle je n'ai pas d'impact direct en termes de matériel et de fonctionnement. Il serait intéressant, dans une future itération, d'évaluer la consommation du système ainsi que son empreinte carbone.