#import "@preview/scholarly-epfl-thesis:0.1.0": flex-caption
#let v-skip-xxs = v(1em, weak: true)
#let v-skip-xs = v(2em, weak: true)
#let v-skip-s = v(3em, weak: true)
#let v-skip-xl = v(4em, weak: true)
#let v-skip-xxl = v(5em, weak: true)

= Analyse

Dans ce chapitre, nous explorons diverses technologies et concepts cruciaux pour l'analyse de données et la détection d'anomalies dans des séries temporelles. Cette analyse est structurée en sous-chapitres dédiés aux anomalies, à la détection d'anomalies, au backtesting, à Kubernetes, à Ray, à MLflow et à la plateforme LYSR.


== Anomalie

D'après le dictionnaire Le Robert, une anomalie est un écart par rapport à la normale ou à la valeur théorique @LeRobert. Dans ce travail de bachelor, nous nous intéressons aux anomalies présentes dans des séquences de données mesurées à intervalles de temps réguliers (séries temporelles). Ces données peuvent représenter, par exemple, la température d'un moteur, les ventes d'une entreprise ou le nombre de visites sur un site web. Il existe de nombreux types d'anomalies tels que :

*Anomalies ponctuelles (Point Anomaly)* :
- *Définition* : Une seule observation qui dévie de manière significative des autres observations.
- *Exemple* : Dans une série de températures journalières, un jour avec une température extrêmement haute par rapport aux autres jours.

#v-skip-xs
#figure(
  image("../images/anomalie-ponctuelle.jpeg", width: 85%), caption: [Anomalie ponctuelle]
)

#v-skip-xl


*Anomalie collective (Collective Anomaly)* : 
- *Définition* : Un groupe d’observations qui, ensemble, dévient du comportement attendu, même si les observations individuelles peuvent ne pas être des anomalies.
- *Exemple* : Un groupe de transactions bancaires consécutives de petits montants transférés en peu de temps, ce qui pourrait indiquer une activité frauduleuse.

#v-skip-xs
#figure(
  image("../images/anomalie-collective.jpeg", width: 83%), caption: [Anomalie collective]
)

#v-skip-xl

*Anomalie contextuelle (Contextual Anomaly)* :
- *Définition* : Une observation qui est considérée comme une anomalie dans un certain contexte mais qui peut être normale dans un autre.
- *Exemple* : Une température de 30°C pourrait être normale en été mais serait une anomalie en hiver.

#v-skip-xs
#figure(
  image("../images/anomalie-contextuelle.jpeg", width: 83%), caption: [Anomalies contextuelles]
)

#v-skip-xl

*Anomalie de changement de niveau (Level Shift Anomaly)* :
- *Définition* : Un changement brusque et significatif dans le niveau moyen des observations.
- *Exemple* : Une série chronologique de ventes mensuelles où il y a soudainement une augmentation ou une diminution permanente des ventes à partir d’un certain point.

#v-skip-xs
#figure(
  image("../images/anomalie-niveau.jpeg", width: 90%), caption: [Anomalie de changement de niveau]
)

#v-skip-xl

#pagebreak()

*Anomalie de tendance (Trend Anomaly)* :
- *Définition* : Un changement dans la tendance sous-jacente des données.
- *Exemple* : Une série chronologique des prix d'actions côté en bourse qui stagne pendant plusieurs mois puis commence soudainement à augmenter de manière continue.

#v-skip-xs
#figure(
  image("../images/anomalie-tendance.jpeg", width: 90%), caption: [Anomalie de tendance]
)

#v-skip-xl

*Anomalie de variance (Variance Anomaly)* :
- *Définition* : Un changement significatif dans la variabilité des données.
- *Exemple* : Une série de données de capteurs où la variance des mesures passe soudainement d’une valeur basse à une valeur élevée, indiquant une possible défaillance du capteur.

#v-skip-xs
#figure(
  image("../images/anomalie-variance.jpeg", width: 90%), caption: [Anomalie de variance]
)

#v-skip-xl

En conclusion, il existe de nombreux types d’anomalies dans les séries temporelles, chacune étant identifiée de manière différente. Leur détection est souvent un travail minutieux dont la complexité peut varier considérablement en fonction des données. Le chapitre suivant explique comment ces anomalies peuvent être détectées.

#pagebreak()

== Détection d'anomalies

D'après le dictionnaire Le Robert, la détection est définie comme l’action de détecter, c’est-à-dire de découvrir l’existence de quelque chose @LeRobert. La détection d’anomalies consiste donc à identifier des événements qui dévient des normes établies. Elle est employée dans des secteurs très divers comme, par exemple, en finance pour détecter des fraudes, en fabrication pour repérer des défauts ou des pannes d’équipement, en cybersécurité pour surveiller des activités réseau inhabituelles ou encore, en santé pour identifier des conditions anormales chez les patients.

LYSR, le mandataire de ce travail de bachelor, se spécialise dans la détection d’anomalies pour l’industrie 4.0. Le processus de détection d’anomalies mis en place par LYSR se déroule en trois étapes :

1.	*Collecte des données* : Les données sont collectées en temps réel à partir des machines via des capteurs connectés ou non (Edge Computing).
2.	*Traitement et analyse* : Les données sont traitées et analysées en temps réel à l’aide de l’intelligence artificielle (IA), avec des résultats variables selon les modèles utilisés.
3.	*Identification des anomalies* : Des anomalies sont détectées en appliquant des règles prédéfinies aux résultats obtenus. Un exemple de règle serait un seuil qui ne doit pas être dépassé pendant trois secondes.

Ce processus permet de réduire les coûts et les temps d’arrêt en prédisant ou en signalant lorsque qu’une machine a besoin de maintenance ou de remplacement.

=== Méthodes de détection sans IA

Comment analyser les flux de données continus pour détecter des anomalies ? Cela peut nécessiter l'utilisation de modèles d'intelligence artificielle (IA) ou d'autres méthodes non basées sur l'IA. La détection des anomalies sans recours à l'IA inclut des méthodes telles que la détection manuelle, l'analyse de données, l'examen de graphiques et l'application de tests statistiques. Ces approches sont généralement efficaces pour des volumes de données limités, mais elles nécessitent souvent l'intervention de spécialistes, tels que des analystes de données ou des statisticiens. Cependant, ces méthodes ne sont pas utilisées par LYSR, car LYSR traite de grandes quantités de données en continu et en temps réel, rendant ces méthodes inefficaces comparées à celles basées sur l'IA.

=== Méthodes de détection par IA

La détection par intelligence artificielle (IA) est plus rapide que le travail manuel et plus efficace pour traiter de grandes quantités de données. Cependant, elle nécessite l’intervention d’ingénieurs ou de data scientists pour entraîner les modèles. Cette méthode est employée par LYSR et constitue l’un des principaux thèmes de ce travail de bachelor.

Un bon modèle d'IA nécessite des données pour l'entraîner. Ces données se divisent en trois types : les données supervisées, les données non supervisées et les données semi-supervisées. Chaque type de données joue un rôle crucial dans l'approche utilisée pour entraîner le modèle, comme comme indiqué ci-dessous.

- *Données supervisées* : Les techniques de détection d’anomalies supervisées reposent sur des modèles entraînés avec des données étiquetées, incluant des cas normaux et anormaux. En raison de la rareté des données étiquetées et du déséquilibre des classes, ces techniques sont rarement utilisées. Les Support Vector Machines (SVM) et les k-NN sont deux exemples de ces approches.
 - *Approches basées sur la distance (K-NN)* : Les points normaux sont proches de leurs voisins, tandis que les anomalies sont éloignées. L’algorithme k-NN utilise la distance pour classer les données en fonction des k voisins les plus proches.
 - *Approches basées sur les SVM* : Les SVM (Support Vector Machines) tracent une frontière séparant les données normales des anomalies, avec les anomalies situées en dehors de cette frontière.

- *Données non supervisées* : Les techniques de détection d’anomalies non supervisées construisent un modèle à partir de données non étiquetées pour identifier de manière autonome des motifs ou des anomalies. Elles sont largement utilisées en raison de leur applicabilité étendue, bien qu'elles nécessitent souvent de grands ensembles de données et une puissance de calcul significative. Les méthodes courantes incluent le clustering, les arbres de décision et les réseaux de neurones.
  - *Approches basées sur le clustering (K-means)* : Le clustering regroupe les données similaires en clusters, les anomalies étant les points en dehors de ces clusters.
  - *Approches basées sur les arbres de décision (ex. Isolation Forest)* :  L'Isolation Forest divise les observations en sous-ensembles, les anomalies étant plus facilement isolées que les points normaux.
  - *Approches basées sur les réseaux de neurones (ex. auto-encodeurs)* : Les auto-encodeurs apprennent à reconstruire les données normales, détectant les anomalies par une erreur de reconstruction élevée.

- *Données semi-supervisées* :  Les techniques de détection d’anomalies semi-supervisées combinent les avantages des approches supervisées et non supervisées, améliorant l’efficacité et la précision des modèles d’apprentissage automatique avec une quantité limitée de données étiquetées. La propagation des labels est un exemple de cette approche.
  - *Propagation des labels* : La propagation des labels utilise des données étiquetées pour attribuer des étiquettes aux données non étiquetées en fonction de leur similarité, puis affine l’algorithme avec ces nouvelles étiquettes.


=== Métriques d'évaluation

Une fois le modèle développé à partir des données d'entraînement, il est essentiel d'évaluer ses performances et son efficacité pour la détection des anomalies. Pour cela, plusieurs métriques clés sont utilisées. Les principales sont décrites ci-dessous :

*Taux de faux positifs : La proportion d’instances normales incorrectement classées comme anomalies.* Réduire ce taux est crucial pour éviter les fausses alertes.
  
$ "Taux de faux positifs"  = frac("Faux positifs", "Faux positifs" + "Vrais négatifs") $

#v-skip-xl

*Taux de faux négatifs  : La proportion d’anomalies non détectées.* Réduire ce taux est important pour s’assurer que les véritables anomalies ne passent pas inaperçues.

$ "Taux de faux négatifs"  = frac("Faux négatifs", "Faux négatifs" + "Vrais positifs") $

#v-skip-xl

*Précision globale (Accuracy) : La proportion de prédictions correctes parmi l’ensemble des prédictions.* Cette métrique peut être trompeuse dans le contexte de la détection des anomalies en raison du déséquilibre des classes (les anomalies sont rares).

$ "Précision globale"  = frac("Vrais positifs" + "Vrais négatifs", "Total des prédictions") $

#v-skip-xl

*Précision (Precision) : La proportion de véritables anomalies parmi les instances identifiées comme anomalies.* Cette métrique est cruciale lorsque le coût des fausses alertes est élevé.

$ "Précision"  = frac("Vrais positifs", "Vrais positifs" + "Faux positifs") $

Une précision optimale de 1.0 signifie que toutes les instances détectées comme anomalies sont effectivement des anomalies, sans aucun faux positif.


#v-skip-xl

*Rappel (Recall) : La proportion de véritables anomalies détectées parmi toutes les anomalies présentes.* Un rappel élevé est important pour minimiser les cas non détectées.

$ "Rappel"  = frac("Vrais positifs", "Vrais positifs" + "Faux négatifs") $

Un rappel optimal de 1.0 signifie que toutes les anomalies présentes dans le jeu de données (global) ont été détectées, sans aucun faux négatif.

#v-skip-xl

*Score F1 : La moyenne harmonique de la précision et du rappel, offrant un équilibre entre les deux.* Cette métrique est particulièrement utile lorsque les classes sont déséquilibrées.

$ "Score F1"  =  2 dot frac("Précision" dot "Rappel", "Précision" + "Rappel") $

Un F1-score optimal de 1.0 indique un équilibre parfait entre précision et rappel, tandis qu'un F1-score de 0.5 signifie que pour chaque prédiction correcte, le modèle commet deux erreurs (faux négatifs ou faux positifs).

#v-skip-xl
#pagebreak()

*ROC AUC : La courbe ROC (Receiver Operating Characteristic) illustre le compromis entre le taux de vrais positifs et le taux de faux positifs. L’AUC (Area Under the Curve) mesure l’aire sous cette courbe et fournit une indication générale de la performance du modèle.*

$ "Aire sous ROC"  =  integral_0^1 "ROC"(x) dot "dx" $

Une AUC optimale de 1.0 signifie que le modèle distingue parfaitement les anomalies des instances normales, tandis qu'une AUC de 0.5 indique une performance équivalente au hasard.

#set align(center)
*Courbes ROC*
#set align(left)

#v-skip-xs
#figure(
  image("../images/auroc.jpeg", width: 70%), caption: [Courbes ROC]
)
#v-skip-xs

*Interprétations des métriques*

L'interprétation des métriques est une étape cruciale dans le développement d'un modèle. Il est essentiel de les comprendre pour évaluer et améliorer le modèle. Ci-dessous, un exemple fictif de tableau présente différentes métriques pour divers modèles hypothétiques.

#pagebreak()

#let my-table = "figure(
  table(
    columns: 5,
    align: center,
    table.hline(),
    table.header(
      [ ], [Précision], [Rappel], [F1], [AUC],
    ),
    table.hline(stroke: 0.5pt),
    [modèle n°1], [0.640], [1], [0.780], [0.0],
    [modèle n°2], [0.107], [0.5], [0.177], [0.106],
    [modèle n°3], [0.470], [0.462], [0.462], [0.205],
    table.hline(),
  ),
)"

#eval(my-table) <tab:esempio>

#v-skip-xs

L’interprétation des métriques du tableau est la suivante :

*Modèle n°1* : Il est le plus performant en termes de rappel et de F1 score, mais l’AUC de 0.0 est suspecte et nécessite une vérification.\
*Modèle n°2* : Il présente la plus faible performance globale, avec des scores de précision, rappel, F1 et AUC très bas.\
*Modèle n°3* : Il offre des performances intermédiaires sur toutes les métriques.


=== Défis

La détection des valeurs aberrantes dans les séries temporelles est complexe en raison de plusieurs facteurs :

- *Définition des anomalies* : La définition des anomalies varie selon le contexte, nécessitant une contextualisation approfondie.
- *Déséquilibre des classes* : Les anomalies sont rares par rapport aux instances normales, biaisant les modèles vers les instances majoritaires.
- *Variabilité des anomalies* : Les anomalies se manifestent de diverses manières, rendant difficile la création d’un modèle universel.
- *Évolution des données* : Les données changent avec le temps, nécessitant des mises à jour constantes des modèles.
- *Qualité des données* : Le bruit, les données incorrectes ou manquantes peuvent masquer les anomalies, compliquant le prétraitement.
- *Élaboration du modèle IA* : Features engineering, éviter le surapprentissage (overfitting) et garantir la robustesse.

Ces défis nécessitent des approches sophistiquées et adaptatives pour être surmontés, exigeant vigilance et adaptation continue des méthodes.

=== Feature Engineering

Le Feature Engineering est crucial pour transformer les données brutes en features plus représentatives et exploitables par les modèles d’IA, améliorant ainsi la détection des anomalies et la performance des modèles prédictifs. Cela inclut la sélection de features pertinentes, la transformation des features, la création de nouvelles features dérivées et l’ajout d’interactions entre variables.

- *Sélection des features  \ * La sélection des features identifie et conserve les variables les plus pertinentes pour le modèle.
 - *Pourquoi sélectionner les features ? \ * Réduire le nombre de variables simplifie les modèles et améliore la performance.

 - *Exemples de méthodes de sélection des features :*
  - Méthodes statistiques : Utilisation de statistiques pour évaluer l’importance des features.
  - Algorithmes de sélection : Utilisation d'algorithmes de ML pour sélectionner les features (par ex., recursive feature elimination).
  
- *Extraction des features \ * L’extraction des features crée de nouvelles variables à partir des données existantes, permettant de capturer des informations importantes.
 - *Pourquoi extraire des features ? \ * Cela réduit la complexité des données, révèle des structures sous-jacentes, et améliore la performance des modèles.
 - *Exemples de techniques d’extraction des features :*
  - Analyse en composantes principales (PCA) : Réduction de la dimensionnalité.
  - Analyse discriminante linéaire (LDA) : Axes maximisant la séparation entre les classes.

- *Transformation des features \ * La transformation des features modifie les variables existantes pour les rendre plus adaptées aux modèles prédictifs.
 - *Pourquoi transformer les features ? \ * Les transformations stabilisent la variance, rendent les données plus normales ou améliorent la convergence des algorithmes.
 - *Exemple de transformations de features : \  *
  - Normalisation : Redimensionnement des valeurs de sorte qu'elles tombent dans une gamme spécifiée,  généralement [0, 1] ou [-1, 1].
  - Logarithmique : Réduction de la skewness d’une distribution.

- *Création de features dérivées \ * Les features dérivées sont de nouvelles variables créées à partir des variables existantes pour capturer des informations supplémentaires ou des patterns non apparents dans les données d’origine.
 - *Pourquoi ajouter des features dérivées ? \  * Elles peuvent améliorer la performance des modèles de prédiction en capturant des tendances ou des changements subtils que les variables d’origine ne révèlent pas. Par exemple, la variation de la température (première dérivée) ou l’accélération de cette variation (deuxième dérivée) peuvent être plus indicatives qu’une simple mesure de température.
 - *Exemples de features dérivées :*
  - Première dérivée : Calcul du taux de changement d’une variable, comme la vitesse de changement de la température (dx/dt)
  - Deuxième dérivée :  Calcul de l’accélération du changement d’une variable (d²x/dt²).
  - Transformations statistiques : Moyennes, écarts-types, quantiles et autres statistiques pour résumer et décrire la distribution des données.
  - Transformations catégoriques : Fréquence d’apparition.
- *Interactions entre features \ * Les interactions entre features capturent l’effet combiné de deux ou plusieurs variables, révélant des relations complexes non visibles dans les variables individuelles.
 - *Pourquoi ajouter des interactions entre features ? \ * Elles permettent aux modèles d'IA de capturer des relations non linéaires et des effets combinés entre variables. Par exemple, la combinaison de la température et de l’humidité peut avoir un impact différent par rapport à ces variables prises séparément.
 - *Exemples d’interactions entre features : \ *
  - Produit de variables : Interaction représentée par le produit de deux features (x1 \* x2).
  - Ratios : Capturer les effets relatifs entre variables.
  - Fonctions non linéaires : Appliquer des fonctions combinées, comme sin(x1) \* cos(x2).

En résumé, la détection d’anomalies est essentielle dans des secteurs comme la finance, la fabrication, la cybersécurité et la santé. LYSR se spécialise dans ce domaine pour l’industrie 4.0 en utilisant l’IA pour analyser des flux de données en temps réel.

Les méthodes de détection peuvent être manuelles ou automatisées. Les techniques manuelles conviennent aux petites quantités de données, tandis que l’IA est plus efficace pour les grands volumes. Les données d’entraînement peuvent être supervisées, non supervisées ou semi-supervisées,  influençant ainsi l'algorithme utilisé.

Les métriques telles que la précision, le rappel, le score F1 et l’AUC sont essentielles pour évaluer les modèles mais doivent être interprétées avec soin. Les défis principaux incluent la définition des anomalies, le déséquilibre des classes, la variabilité des données et leur qualité. Le Feature Engineering est crucial pour maximiser la performance des modèles et améliorer la détection des anomalies.

En conclusion, bien que complexe, la détection d’anomalies est indispensable. Elle améliore notamment les performances des services, la qualité des produits et l’expérience utilisateur. Les avancées en intelligence artificielle et en traitement des données permettent d'affiner les méthodes de détection, les rendant toujours plus précises.

#pagebreak()

== Backtesting

Le backtesting vise à simuler les performances d’un modèle en l’appliquant à des données historiques pour évaluer sa précision et sa fiabilité.

Actuellement, LYSR ne dispose pas de système de backtesting. Lorsqu’un nouveau modèle d’IA est développé, il est généralement testé localement avec des données historiques dans un Jupyter Notebook, et parfois même pas du tout. L’objectif de ce travail de bachelor est de remédier à ce problème en développant un système de backtesting distribué, directement intégré à la plateforme LYSR. Ce système permettra d'évaluer les modèles ainsi que les règles associées pour identifier la meilleure combinaison afin de détecter les anomalies avec la plus grande précision.


=== Étapes

Les étapes du backtesting sont les suivantes :

1.	*Sélection des données historiques* : Choisir des données représentatives et s’assurer que la période sélectionnée couvre différents scénarios de marché pour obtenir une évaluation exhaustive.

2.	*Application du modèle aux données* : Fournir les données historiques au modèle, qui génère des sorties via l'inférence, pouvant être des scores ou des classifications.

3.	*Application des règles aux outputs du modèle* : Appliquer les règles aux sorties du modèle pour déterminer si elles constituent une anomalie.

4.	*Analyse des résultats obtenus* : Mesurer les performances du modèle et des règles en utilisant des métriques appropriées, telles que celles présentées au chapitre précédent (2.2.3 métriques d’évaluation).

5.	*Rapport* : Générer un rapport de backtesting et enregistrer les résultats.


=== Avantages

Le backtesting offre de nombreux avantages, notamment :

- *Validation du modèle* : Permet de vérifier l’efficacité d’un modèle avant de l’appliquer dans des conditions réelles.
- *Validation des règles* : Permet de s’assurer que les règles sont correctement définies et adaptées au modèle.
-	*Identification des points faibles* : Aide à repérer les faiblesses et les risques potentiels associés au modèle.
-	*Optimisation* : Facilite l’ajustement et l’amélioration du modèle pour maximiser ses performances.

=== Limites

Cependant, le backtesting présente plusieurs limites :

-	*Disponibilité des données* : Les données disponibles peuvent être insuffisantes pour certaines applications.
-	*Dépendance aux données historiques* : Les modèles peuvent être trop optimisés pour les données passées, ce qui ne garantit pas leur performance future.
-	*Sur-optimisation (overfitting)* : L’ajustement excessif des modèles aux données historiques peut conduire à des performances trompeuses sur de nouvelles données.
-	*Faux positifs* :  Il est crucial d’éviter les faux positifs, qui peuvent donner une fausse impression de la performance du modèle, ainsi que les faux négatifs.
-	*Hypothèses simplifiées* : Le backtesting peut simplifier certaines hypothèses, bien qu'elles soient souvent beaucoup plus complexes en réalité.

=== Conclusion

Un backtesting rigoureux permet d’identifier les forces et les faiblesses d’un modèle ainsi que les meilleures règles à lui appliquer, facilitant les ajustements avant son déploiement en production. Cependant, les performances passées ne garantissent pas les performances futures. Ce pourquoi les modèles doivent être mis à jour régulièrement pour rester efficaces. En résumé, le backtesting est essentiel dans le développement et l’évaluation des modèles.

#pagebreak()

== Rapport de backtesting
L'analyse de la littérature pour trouver des exemples de rapports de backtesting dans le cadre de la détection d'anomalies s'est avérée difficile. En effet, la majorité des résultats concernent le backtesting dans les domaines de la finance et des marchés boursiers qui utilisent des rapports très différents, avec des métriques spécifiques telles que le rendement et le bénéfice. Ces éléments sont peu pertinents pour la détection d'anomalies. Les seules informations pertinentes trouvées sont des conseils @rapport pour évaluer la détection d'anomalies. Parmi ces conseils, on retrouve les métriques présentées au chapitre 2.2.3 pour évaluer les résultats, telles que la précision, le rappel et le f1-score. Il y est également recommandé de visualiser les données afin de communiquer clairement les résultats. Enfin, il est rappelé d'interpréter les résultats avec prudence, car les performances passées ne garantissent pas les performances futures.

== Kubernetes

Kubernetes (_K8s_) est un système open-source qui automatise le déploiement, la mise à l'échelle et la gestion des applications conteneurisées. Il est essentiel à ce projet car le système de backtesting développé repose sur Ray, qui lui-même utilise Kubernetes. De plus, Kubernetes offre des fonctionnalités avancées telles que la découverte de services, la gestion des configurations et des secrets, ainsi que la mise à jour continue des applications, ce qui améliore la fiabilité et la maintenabilité du système de backtesting.

#pagebreak()

== Ray

Ray est un framework de calcul unifié open-source qui facilite la mise à l'échelle des charges de travail en IA et en Python @ray. Il permet ainsi de passer de plusieurs systèmes distribués distincts (Figure 2.8), chacun correspondant à une partie spécifique du ML, à un seul système distribué qui englobe toutes les parties du ML (Figure 2.9).

#v-skip-xl
#set align(center)
_Système ML distribué sans Ray_
#set align(left)

#figure(
  image("../images/ML-without-ray.png", width: 98%), caption: [Système ML distribué sans Ray]
) 

#v-skip-xxl
#set align(center)
_Système ML distribué avec Ray_
#set align(left)

#figure(
  image("../images/ML-with-ray.png", width: 98%), caption: [Système ML distribué avec Ray]
)

#pagebreak()

Ray simplifie la création de plateformes de machine learning évolutives et robustes en offrant des outils de calcul, une API ML unifiée, et en facilitant la transition du développement à la production. Ray automatise également la gestion des composants, la planification des tâches et la mise à l’échelle automatique. Ainsi, Ray simplifie le développement, le déploiement et la gestion des systèmes de ML distribués. Ce framework est crucial pour ce travail, car le système de backtesting doit fonctionner sur le cluster Ray de LYSR. La Figure 2.10 présente un schéma des composants essentiels de Ray

#figure(
  image("../images/ray-layers.png", width: 100%), caption: [Composants de Ray]
)

#v-skip-xs

L’image ci-dessus montre que Ray se compose de trois couches : Ray AI Runtime, Ray Core et K8s (Ray Cluster). Chacune de ces couches contient des composants distincts. Voici une brève description de ces couches et de leurs composants.

*Ray AI Runtime* : Bibliothèques Python open-source pour des outils ML.
- Data : Chargement et prétraitement de données.
- Train : Entraînement de modèles distribué.
- RLlib : Apprentissage par renforcement distribué.
- Tune : Ajustement des hyperparamètres.
- Serve : Mise en service pour déployer des modèles en ligne.

*Ray Core* : Bibliothèque Python open-source pour le calcul distribué et le scalling des applications ML.
- Tasks : Ray exécute de manière asynchrone des fonctions sur des workers Python séparés, appelés tasks. Les tasks peuvent spécifier leurs besoins en termes de CPU, GPU et ressources personnalisées, ce qui permet au planificateur de cluster d’optimiser l’exécution parallélisée.
- Actors : Les actors sont des workers avec état (stateful workers). Lorsqu’un actor est instancié, un nouveau woker est créé. Les méthodes de cet actor peuvent accéder et modifier l’état du worker. Les actors peuvent également spécifier leurs besoins en CPU, GPU et ressources personnalisées.

- Objects : Les tasks et les actors créent des objects distants, stockés n’importe où dans le cluster. Ces objects sont mis en cache dans un object store en mémoire partagée. Il peut y avoir un seul store dédié par nœud, mais un object distant peut résider sur plusieurs nœuds. Les objects distants peuvent être partagés et récupérés à travers le cluster sans qu’une task ou un acteur spécifique maintienne une référence continue à ces object.

*K8s (Ray Cluster)* : Ensemble de nœuds worker. K8s ajuste automatiquement le nombre de nœuds du cluster Ray en fonction de la demande.

Pour plus d’informations, la documentation de Ray @ray-doc explique en détail tous ses composants et bien plus encore.

#pagebreak()

== MLflow

MLflow est une plateforme conçue pour simplifier le développement de projets en machine learning. Elle facilite le suivi des expériences, l’emballage du code dans des environnements reproductibles, ainsi que le partage et le déploiement des modèles. LYSR utilise MLflow pour héberger ses modèles dans le registre de modèles MLflow.

Un des principaux avantages de MLflow est ses modèles standardisés, qui s’intègrent avec une variété d'outils, permettant ainsi une meilleure reproductibilité et un déploiement facile. Par exemple, un modèle peut être développé avec l'une des nombreuses bibliothèques compatibles avec MLflow, telles que PyTorch, Scikit-learn, Hugging Face, Keras, et TensorFlow, pour n'en citer que quelques-unes. Ensuite, ce modèle peut être enregistré au format MLflow standard, le rendant facilement utilisable tous de la même manière.


== LYSR

LYSR est une plateforme d'Intelligence Artificielle (IA) dédiée à la surveillance des processus industriels. Ses principales fonctionnalités sont les suivantes :

1. *Traitement évolutif* : Permet aux entreprises de surveiller simultanément des milliers de flux de données.
2. *Algorithmes avancés et IA plug-and-play* : Envoie des alertes en temps réel pour la maintenance prédictive.

Ces caractéristiques font de LYSR un outil prometteur pour optimiser la gestion et la maintenance des infrastructures industrielles.


=== Stack technologique
La plateforme LYSR utilise principalement Python et Java pour exécuter ses modèles et microservices, en s'appuyant sur MLflow et Ray. Elle fonctionne sur un cluster Kubernetes, qui gère également un cluster Ray pour l'orchestration des tâches de machine learning. MLflow est utilisé pour héberger les modèles de machine learning. Kafka gère les flux de données en temps réel, Minio assure le stockage permanent des données compatible avec S3, et Grafana Mimir sert de base de données temporelle pour le stockage et l'indexation des données chronologiques. Bien qu'il existe d'autres technologies utilisées, elles sont de moindre importance pour ce travail. Ces technologies constituent donc les contraintes de ce travail de bachelor, étant donné que le système de backtesting devra pouvoir s'intégrer à la plateforme LYSR.

=== Workflow

Le workflow de la plateforme LYSR est le suivant (adapté de la documentation LYSR @LYSR).

1. *Workspace definition* : Un workspace est un environnement dédié où l'utilisateur organise les ressources liées à un processus de surveillance. Il comprend des endpoints, des streams, des processeurs, des modèles, des règles et des dashboards.

2. *Endpoint definition* : Un endpoint est un point d'accès lié à un workspace, utilisé pour insérer de nouvelles données dans la plateforme. LYSR génère automatiquement une API REST permettant aux gateway ou systèmes embarqués d'envoyer leurs données.

3. *Sending data streams* : Un stream est une série chronologique de valeurs stockées par LYSR, créée lorsque des systèmes embarqués ou des gateway transmettent des données collectées via des capteurs.

4. *Exploring values* : L'outil Explorer de LYSR permet de visualiser et d'inspecter les valeurs des streams. Des graphiques et tableaux peuvent être générés pour faciliter la navigation dans les données.

5. *Defining dashboards* : Un dashboard est composé de graphiques basés sur les données des streams. Sa configuration est flexible et peut être sauvegardée. Les valeurs sont mises à jour approximativement chaque seconde pour une surveillance en temps réel.

6. *Defining models* : Un modèle peut être un réseau neuronal profond (deep neural network), un arbre de décision (decision tree) ou des algorithmes plus simples. Une fois définis, les modèles peuvent être instanciés et connectés pour traiter et analyser les streams.

7. *Instanciating processor* : Un processeur est une instance de modèle appliquée à un stream, générant un output, souvent un score d'anomalie. Les streams sont associés aux inputs du processeur, qui se déclenche selon différentes stratégies : à l'arrivée de nouvelles données ou lorsque les fenêtres de traitement sont remplies. L'output du processeur crée un nouveau stream dans LYSR.

8. *Defining rules* :  Une règle permet d'envoyer des alertes lorsque certaines conditions sont remplies. LYSR permet de définir des règles flexibles basées sur les valeurs et timestamps des streams. Lorsqu'une condition est remplie, une alerte est déclenchée et envoyée à l'utilisateur. Le système d'alerte inclut différents paramètres pour une flexibilité maximale (patience, auto-close, remind).

== Conclusion

Ce chapitre a présenté une analyse succinte des concepts et technologies essentiels à la détection d'anomalies dans les séries temporelles. Nous avons défini les anomalies, exploré les princiaples méthodes de détection manuelles et automatisées, et présenté des métriques d'évaluation pour mesurer la performance des modèles d'IA.

Le backtesting a été abordé comme un outil crucial pour valider les modèles sur des données historiques, garantissant leur fiabilité avant leur déploiement. Kubernetes et Ray ont été introduits comme des solutions clés pour la gestion des applications distribuées, permettant une mise à l'échelle efficace et un déploiement robuste dans les applications de machine learning.

MLflow a été mis en avant pour sa capacité à suivre et à déployer des modèles de machine learning de manière reproductible. Enfin, la plateforme LYSR a été brièvement décrite, illustrant son efficacité dans la surveillance et l'analyse des flux de données en temps réel.

En résumé, ce chapitre démontre l'importance d'intégrer des technologies avancées à des méthodologies rigoureuses pour améliorer la détection d'anomalies et optimiser les processus dans tous les secteurs concernés.









