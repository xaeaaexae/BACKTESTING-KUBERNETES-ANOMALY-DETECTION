= Introduction

Ce travail de bachelor est réalisé dans le cadre de la formation « Bachelor of Science HES-SO en Informatique et systèmes de communication », à la Haute école d’ingénierie et d’architecture de Fribourg (_HEIA-FR_). Il est mandaté par l'institut iCoSys, spécialisé dans l'intelligence artificielle et les systèmes complexes, ainsi que par la startup LYSR, qui propose un système continu et performant de surveillance des processus pour les entreprises, basé sur l'intelligence artificielle (_IA_).

== Contexte et motivations

La startup LYSR est spécialisée dans la détection d'anomalies et la maintenance prédictive des données de séries temporelles pour l'industrie 4.0. LYSR propose une plateforme fiable, facile à utiliser et évolutive pour stocker, visualiser et analyser ces données. La plateforme utilise des technologies telles que Kubernetes, Kafka et Ray, intégrées dans une architecture de microservices évolutive, capable de fonctionner sur des clouds publics ou privés.

Actuellement, la plateforme permet l'intégration de modèles d'intelligence artificielle (IA) prêts à l'emploi ainsi que de modèles personnalisés. Ces modèles analysent des flux de données continus (streams) et détectent des anomalies en fonction d'un ensemble de règles. Cependant, les nouveaux modèles sont souvent testés avec des données historiques dans des Jupyter Notebooks (souvent en local) ou ne sont pas testés du tout. L'objectif de ce travail de bachelor est de résoudre ce problème en développant un système de backtesting pour évaluer les modèles et les ensembles de règles sur des données historiques, garantissant ainsi leur efficacité dans la détection d'anomalies. Ce système sera déployé sur Kubernetes et pourra être intégré en tant que microservice dans la plateforme LYSR.

== Objectifs principaux

Les objectifs principaux de ce projet sont les suivants :

#let v-skip-xxs = v(1em, weak: true)

1. *Détection des anomalies : premier prototype* \ Le premier objectif de ce projet est de comprendre ce qu'est une anomalie et d'explorer les différentes méthodes de détection, qu'elles utilisent ou non l'intelligence artificielle (IA). Il est également essentiel de se familiariser avec les métriques employées pour évaluer la performance de ces techniques. \ #v-skip-xxs Ensuite, l'objectif est de concevoir et d'implémenter un prototype en utilisant un dataset de séries temporelles contenant des anomalies pour tester diverses méthodes de détection. Les étapes clés du prototype incluent l'entraînement d'un modèle sur ces séries temporelles pour générer un score. Des règles sont ensuite appliquées à ce score pour détecter les anomalies. Enfin, les résultats sont comparés à la vérité terrain pour évaluer l'efficacité du modèle à l'aide des métriques appropriées.

2. *Backtesting local avec Ray et MLflow*\ Le deuxième objectif est de comprendre les technologies Ray et MLflow, utilisées par LYSR, ainsi que les concepts de backtesting. Il s’agit ensuite de concevoir et d’implémenter un système de backtesting local dans un Jupyter Notebook en utilisant ces technologies. \ #v-skip-xxs Ce système permettra de tester l’efficacité des modèles et des règles en les appliquant à des données. L’objectif est d’identifier la combinaison modèle + règles la plus performante. Les résultats du backtesting, présentés sous forme de valeurs et de scores, seront utilisés dans un prochain objectif pour la création d'un rapport (objectif secondaire n°1).

3. *Intégration du backtesting au backend de LYSR* \ Le troisième objectif consiste à intégrer le système de backtesting développé localement au backend de la plateforme LYSR. Cela nécessite d'abord de comprendre le fonctionnement de la plateforme LYSR, y compris son API pour récupérer les données, les modèles et les règles. \ #v-skip-xxs L'intégration comprendra la lecture des données, des modèles et des règles via l'API de LYSR, ainsi que l'exécution des jobs dans le cluster Ray de LYSR. 

== Objectifs secondaires

Les objectifs secondaires de ce projet, réalisables en fonction du temps restant après l’accomplissement des objectifs principaux, sont :

1. *Génération de rapports de backtesting* \ Comprendre les éléments clés d’un rapport de backtesting et en générer un (en JSON ou autre format) à la fin du processus, permettant d'observer et de comparer les résultats.

2. *Intégration du backtesting au frontend de LYSR* \ Intégrer le système de backtesting au frontend de LYSR. Ainsi, via une interface web, l’utilisateur pourra sélectionner des modèles, des règles et des données pour effectuer du backtesting.

== Méthodologie

La méthodologie agile est utilisée pour ce travail de bachelor (_TB_), adoptant une approche flexible et itérative de gestion de projet, centrée sur la collaboration et l'adaptation rapide aux changements. Ce choix s'explique par les nombreuses inconnues associées à ce TB. En optant pour cette méthodologie, il est possible de livrer rapidement des produits fonctionnels tout en progressant par étapes.

Chaque objectif primaire et secondaire, présenté précédemment, correspond à un sprint (itération) d'une durée d'une à deux semaines. Chaque sprint inclut le développement et les tests d'une partie du travail de bachelor, assurant une progression structurée et méthodique.

Cette structure garantit que chaque itération produit des résultats concrets et évaluables, facilitant ainsi l'ajustement continu et l'amélioration du travail de bachelor. L'approche agile permet de répondre efficacement aux défis imprévus et d'intégrer les retours de manière proactive. Cette méthodologie favorise également une communication ouverte entre toutes les parties prenantes, assurant que les objectifs sont constamment alignés avec les attentes des superviseurs et les besoins évolutifs du TB.

== Structure

Ce travail de bachelor est organisé en neuf chapitres.

Le premier 1 « Introduction » présente le contexte, les motivations et les objectifs.

Le chapitre 2 « Analyse » introduit des concepts clés tels que les anomalies, la détection d'anomalies, le backtesting, ainsi que les outils utilisés comme Kubernetes, Ray, MLflow et LYSR.

Le chapitre 3 « Conception » décrit l’architecture et le design du système de backtesting. 

Le chapitre 4 « Implémentation » couvre le développement du projet, détaillant le script de backtesting, l'API de backtesting et le frontend du backtesting. 

Le chapitre 5 « Évaluation » décrit les tests effectués et les résultats obtenus.

Le chapitre 6 « Améliorations » constitue une réflexion sur de potentielles futures améliorations.
 
Le chapitre 7 « Résultats » représente une synthèse du travail effectué.

Le chapitre 8 « Durabilité » présente la durabilité du projet vis-à-vis des dix-sept objectifs du développement durable.

Le chapitre 9 « Conclusion » résume les points-clés de ce travail de bachelor, incluant une conclusion personnelle, la déclaration d'honneur et l'utilisation des outils d'intelligence artificielle.

L'ordre des chapitres ne correspond pas nécessairement à l'ordre des tâches réalisées durant le projet.

Les termes professionnels anglo-saxons d’usage courants, en Suisse romande comme dans les pays francophones, sont retranscrits à l’identique.

Les termes en italique sont définis dans le glossaire.

Les références sont identifiées par un numéro et détaillées dans la bibliographie.

Le code source ainsi que tous les documents relatifs au travail de bachelor sont accessibles sur le dépôt GitLab à l'adresse suivante :
https://gitlab.forge.hefr.ch/adam.grossenb/tb_backtesting_kubernetes_anomaly_detection. Plusieurs fichiers README sont présents dans ce dépôt, fournissant des explications sur le contenu, le code et le fonctionnement.