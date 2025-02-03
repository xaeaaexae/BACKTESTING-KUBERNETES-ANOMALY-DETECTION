#let v-skip-null = v(-0.05em, weak: true)
#let v-skip-xxs = v(1em, weak: true)
#let v-skip-xs = v(2em, weak: true)
#let v-skip-s = v(3em, weak: true)
#let v-skip-m = v(4em, weak: true)
#let v-skip-l= v(5em, weak: true)

= Implémentation

Dans ce chapitre, nous détaillons les différentes étapes d'implémentation du système de backtesting. Cette conception est structurée en sous-chapitres qui abordent la détection des anomalies et le développement du premier prototype, l'utilisation de Ray et MLflow pour le backtesting local, la génération de rapports de backtesting, l'intégration du backtesting au backend de LYSR, et enfin, la création d'une interface web pour le système de backtesting.

== Détection des anomalies : premier prototype

L'analyse et la conception ont permis de comprendre la détection des anomalies ainsi que les métriques associées, ce qui a permis d'implémenter un premier prototype de détection d'anomalies.

#v-skip-s

*Fonctionnement du prototype :*

#v-skip-xs

1. *Sélection et division des données* : Un jeu de données de séries temporelles contenant des anomalies est sélectionné et divisé en deux parties : 80 % pour l'entraînement et 20 % pour les tests.
2. *Préparation des données* : Le jeu de données est préparé (normalisation, sélection des caractéristiques, etc.).
3. *Entraînement du modèle* : Un modèle est entraîné à l'aide du jeu de données d'entraînement, générant en sortie un score, une probabilité ou une autre valeur en fonction du modèle.
4. *Inférence sur les données de test* : Le modèle est utilisé pour inférer sur le jeu de données de test.
5. *Détection des anomalies* : Des règles, telles que des seuils, sont appliquées aux résultats de l'inférence pour détecter les anomalies.
6. *Comparaison avec la vérité terrain* : Les résultats du modèle et des règles sont comparés à la vérité terrain.
7. *Évaluation et génération de rapport* : Des métriques (précision, rappel, F1-score, etc.) sont utilisées pour évaluer le modèle et les règles puis un rapport est généré.


#line(length: 100%)

L'efficacité du modèle n'est pas l'objectif principal de ce prototype. L'accent est mis sur le fonctionnement de la détection des anomalies et leur évaluation.

Un Jupyter Notebook, disponible sur GitLab dans le dossier /code/1-Prototype-Process-Miner, a permis d'implémenter les étapes décrites ci-dessus. Quatre modèles ont été entraînés, testés et évalués sur le même jeu de données "Paper Mill" provenant de l'industrie de la pâte et du papier, où les anomalies correspondent à des ruptures de papier. Voici le rapport Markdown généré à la fin du processus :

#figure(
  image("../images/Prototype/classification-report-1.png", width: 100%), 
)
#v-skip-null
#figure(
  image("../images/Prototype/classification-report-2.png", width: 100%), 
)
#v-skip-null
#figure(
  image("../images/Prototype/classification-report-3.png", width: 100%), 
)
#v-skip-null
#figure(
  image("../images/Prototype/classification-report-4.png", width: 100%), 
)
#v-skip-null
#figure(
  image("../images/Prototype/classification-report-5.png", width: 100%), 
)
#v-skip-null
#figure(
  image("../images/Prototype/classification-report-6.png", width: 100%), 
)
#v-skip-null
#figure(
  image("../images/Prototype/classification-report-7.png", width: 100%), caption: [Rapport de classification ] 
)

#v-skip-s

Le rapport ci-dessus compare quatre modèles de machine learning : deux modèles supervisés (SVM et K-NN) et deux modèles non supervisés (Isolation Forest et K-means), en utilisant plusieurs métriques telles que le F1-score, le rappel, la précision et l'AUC.

#pagebreak()


== Backtesting local avec Ray et MLflow

L'analyse et la conception ont permis de comprendre le backtesting, Ray et MLflow, conduisant à l'implémentation d'un script Python pour exécuter des tâches de backtesting sur un cluster Ray en local. Le code est disponible dans un Jupyter Notebook sur GitLab dans le dossier /code/2-Backtesting-Local.

#v-skip-s

*Fonctionnement et pseudo-code du script :*

#v-skip-xs


```text
#******************************#
#  Initialize the Ray cluster  #
#******************************#
- Initialize Ray cluster

#******************************#
#      Retrieve the model      #
#******************************#
- Set MLFlow tracking URI
- Define model name and version
- Load the model from MLFlow
- Retrieve and install model dependencies
- Check if the model is stateful from its metadata

#******************************#
#      Retrieve the rules      #
#******************************#
- Load a predefined list of rules

#******************************#
#      Retrieve the data       #
#******************************#
- Define export ID, workspace ID, and bearer token
- Make a GET request to download data
- Load data using Ray (Ray Dataset)
- Check for existence of "anomaly" column (labels), store values in a Dataframe, drop the column from Ray Dataset
- Check for existence of "timestamp" column, store values in a Dataframe, drop the column from Ray Dataset

#******************************#
#          Inference           #
#******************************#
- Define Inference class with a model and a callable method for inference
- Set concurrency level based on whether the model is stateful or if data is labeled
- Apply inference to the data using Ray, with specific batch size and concurrency settings

#******************************#
#       Apply the rules        #
#******************************#
- Define function to dynamically apply rules to a batch of data
- Apply rules to data using Ray, with specific batch size and concurrency settings

#******************************#
#        Store results         #
#******************************#
- Initialize Minio client
- Write Ray Dataset to Parquet file
- Upload Parquet file to Minio bucket
```

#v-skip-s

*Description détaillée des étapes :*

#v-skip-xs

1. *Initialisation du cluster Ray* : Un cluster Ray est initialisé pour le traitement distribué des données.
2. *Récupération du modèle* : Le modèle ML est récupéré à partir du serveur de suivi MLflow de LYSR. Le processus vérifie également si le modèle est stateful (conserve l'état entre les prédictions) et installe les dépendances nécessaires.
3. *Récupération des règles* : Des règles simples sont chargées pour évaluer les prédictions du modèle (de 0 à N règles). Chaque règle est une chaîne de caractères, par exemple, "prediction >= 1".
4. *Récupération des données* : Les données (=export) sont téléchargées via l'API de LYSR et converties en Ray Dataset pour un traitement ultérieur. Une vérification est également effectuée pour déterminer si les données sont étiquetées, c'est-à-dire si elles contiennent une colonne "[...].anomaly" ainsi qu'une colonne de timestamps.
5. *Inférence* : Une classe d'inférence est définie pour effectuer des prédictions sur les données. Ray applique cette classe sur des batchs, ajustant ainsi la parallélisation en fonction de l'état du modèle et des données. L'inférence est réalisée en parallèle si le modèle est stateless et que les données ne sont pas étiquetées. En revanche, si le modèle est stateful ou que les données sont étiquetées, l'inférence se fait séquentiellement pour maintenir la cohérence et l'intégrité des résultats. 
6. *Application des règles* : Une fonction est définie pour appliquer les règles aux inputs ou outputs (prédictions) du modèle afin de détecter des anomalies. Cette exécution est également gérée par Ray. Les règles actuellement évaluées sont simples (par exemple, "prediction >= 1"). Si aucune règle n'est définie, cette étape est omise lors du backtesting.

8. *Stockage des résultats* : Les résultats des prédictions et des règles sont stockés dans un fichier Parquet, puis uploadés sur un serveur MinIO pour un stockage à long terme. Ces données sont utilisées ultérieurement pour générer un rapport de backtesting.

#v-skip-s



#v-skip-s

Cette partie de l'implémentation a rencontré trois problèmes distincts :

1. *Installation de Ray *: Je recommande d'installer Ray directement avec Pip plutôt qu'avec Conda. L'installation via Conda générait de nombreuses erreurs peu explicites. De plus les versions n'étaient pas les les mêmes.
2. *Version de Pandas* : J'ai dû rétrograder la version de Pandas à 2.1.4, car les versions plus récentes ne possèdent plus une fonction utilisée par Ray 2.23.0. Plus de détails sont disponibles sur l'issue suivante : https://github.com/ray-project/ray/issues/42842.
3. *Problème avec tqdm* : Je recommande de ne pas installer le package tqdm, une barre de progression. Bien que parfois suggéré par des messages d'information, il s'avère plus gênant qu'utile avec Ray, car il masque les informations, avertissements et erreurs de Ray ainsi que certains print.

#pagebreak()

== Rapport de backtesting

L'analyse et la conception ont conduit à la création d'un rapport de backtesting, avec l'implémentation d'un script permettant de le générer à partir des résultats du script de backtesting décrit précédemment. Le code est disponible dans un Jupyter Notebook sur GitLab, dans le dossier /code/4-Backtesting-Report.


#v-skip-s

*Fonctionnement et pseudo-code du script :*

#v-skip-xs

```text
#******************************#
#    Generate and store        #
#    the backtesting report    #
#******************************#

Function plot_timeseries:
    Create subplots based on number of rules and truths
    Plot input data on the first subplot
    If there are truths, plot them on the second subplot
    Plot each rule on subsequent subplots
    If multiple rules, plot their combined values
    Return the figure

Function plot_confusion_matrix:
    Calculate and plot confusion matrix
    Return the figure

Function plot_classification_report:
    Calculate and plot classification report
    Return the figure

Function save_combined_html:
    Open output HTML file
    Write all figures to the file
    Close the file

Main:
    Filter DataFrame to get inputs, rules, truths, and timestamps
    Initialize list for figures

    If truths exist:
        For each rule:
            Generate and store confusion matrix and classification report

    Generate and store timeseries plot
    
    Save all plots into a single HTML file
    
    Upload the HTML file to Minio bucket
```

#v-skip-s

*Description des étapes clés :*

#v-skip-xs

1. *Génération d'un graphique avec les séries temporelles* : Inclure les données initiales, les anomalies réelles, les résultats des règles et la combinaison des règles si ces données existent.
2. *Matrice de confusion par règle* : Création de matrices de confusion si des règles et des données étiquetées existent.
3. *Calcul des métriques par règle* : Génération des métriques si des règles et des données étiquetées existent.
4. *Enregistrement des résultats* : Sauvegarde les graphiques, matrices et métriques dans un fichier HTML.
5. *Upload des résultats sur MinIO* : Upload le fichier HTML dans un bucket MinIO.

#v-skip-xs

Les graphiques et les matrices de confusion sont générés à l'aide de la bibliothèque Plotly. Ce script a été intégré à la fin du script de backtesting afin que celui-ci génère désormais un rapport à la fin du processus.

#pagebreak()

== Intégration du backtesting au backend de LYSR

L'analyse et la conception ont permis de comprendre le fonctionnement de LYSR et de concevoir de nouveaux services pour intégrer le script de backtesting présenté dans les chapitres précédents. Le code correspondant à cette partie du travail est disponible dans le dossier /code/3-Backtesting-LYSR.

#v-skip-s

*Étapes de l'intégration :*

#v-skip-xs

1. *Adaptation du script de backtesting* : Adapter le code de backtesting local pour qu'il soit exécuté comme un job sur le cluster Ray de LYSR.
2. *Développement d'une API REST* : Développer une API REST pour initier le processus de backtesting et la déployer sur Kubernetes.
3. *Déploiement d'un object storage (MinIO)* : Déployer MinIO sur Kubernetes pour stocker les résultats du backtesting, simulant ainsi celui de LYSR.
4. *Déploiement d'un serveur de fichiers* : Déployer un serveur de fichiers sur Kubernetes pour que tout worker Ray puisse accéder au script de backtesting.
5. *CI/CD* : Automatiser l'intégration et le déploiement des nouveaux services décrits ci-dessus (2 à 4).

Ces cinq points sont détaillés dans les sections suivantes.

=== Adaptation du script de backtesting

Le backtesting, initialement développé localement sous forme de Jupyter Notebook, a été converti en script Python pour être exécuté comme un job sur le cluster Ray. Ce script accepte plusieurs arguments pour identifier un modèle, des règles et des données se trouvant sur différents services de LYSR. La commande pour lancer le script est la suivante :\
`python backtesting-script.py`\ 
#h(1cm)`--rule "prediction >= 1" "prediction < 1"`\
#h(1cm)`--export_id 46`\
#h(1cm)`--model_name "175-iso_forest_model"`\ 
#h(1cm)`--model_version 23`\

#pagebreak()

Deux problèmes ont été rencontrés lorsque le script a été exécuté sur le cluster Ray de LYSR, et non plus en local :

1. *Accessibilité des données* :  Les données enregistrées dans un fichier CSV n'étaient pas accessibles par les workers Ray, car le fichier n'était pas correctement enregistré dans l'object store de Ray. La solution a été de stocker directement les données dans la mémoire partagée des workers, évitant ainsi une opération de lecture/écriture supplémentaire.

2. *Incompatibilité des versions de Python* : La version de Python utilisée pour sauvegarder le modèle (Python 3.9.19) différait de celle utilisée par le cluster Ray (Python 3.11.9), empêchant ainsi le chargement correct du modèle. Ce problème, initialement masqué par un avertissement plutôt que par une erreur, a pris du temps à être identifié mais a été résolu en harmonisant les versions de Python. #underline[Il est crucial d'utiliser la même version de Python pour enregistrer les modèles que celle utilisée par le cluster Ray.]

=== *Développement d'une API REST*

Une API a été développée pour initier les jobs de backtesting sur le cluster Ray qui accessible uniquement depuis l'intérieur du cluster Kubernetes. Cette API, développée en Java avec Spring Boot, offre six endpoints :

- *GET /{workspaceId}/backtesting* - Vérifie le fonctionnement du service.
- *POST /{workspaceId}/backtesting* - Lance un job de backtesting.
- *GET /{workspaceId}/backtesting/{submissionId}/status* - Récupère le statut d'un job de backtesting.
- *GET /{workspaceId}/backtesting/{submissionId}/logs* - Récupère les logs d'un job de backtesting.
- *GET /{workspaceId}/backtesting/{submissionId}/results* - Récupère les résultats d'un job de backtesting.
- *GET /{workspaceId}/backtesting/{submissionId}/report* - Récupère le rapport d'un job de backtesting

L'API a été conteneurisée et déployée sur Kubernetes.

#pagebreak()

Quatre classes Java ont été implémentées :

1. *BacktestingServiceApplication.java* : Classe principale de l'application Spring Boot, exposant les endpoints pour gérer les jobs de backtesting.
2. *BacktestingRequest.java* : Modèle de requête utilisée pour initier le backtesting avec des attributs comme rules, exportId, modelName et modelVersion.
3. *KubernetesSecretsReader.java* : Lit des secrets Kubernetes.
4. *UniqueIdentifierGenerator.java* : Génère des identifiants uniques pour les jobs de backtesting.

Un problème a été rencontré concernant l'accès aux secrets Kubernetes depuis les pods. Localement, l'accès via le fichier ~/.kube/config fonctionnait bien. Cependant, dans un pod Kubernetes, des rôles spécifiques doivent être configurés, ce qui nécessitait des autorisations particulières. Finalement, il a été recommandé de passer les secrets par volume aux pods.

=== Déploiement d'un object storage (MinIO)
 
Un système de stockage MinIO a été déployé sur Kubernetes pour stocker les résultats et les rapports du backtesting, évitant ainsi d'utiliser celui de LYSR tout en le simulant.

=== Déploiement d'un serveur de fichiers

Un serveur de fichiers simple avec Nginx a été déployé sur Kubernetes pour récupérer le script de backtesting par tous les workers Ray. Ray nécessite l'utilisation de HTTPS pour accéder au script utilisé comme working dir, ce qui a exigé la création d'un ingress avec un certificat SSL.


== Intégration du backtesting au frontend de LYSR

La conception succincte a permis de développer une interface web pour le système de backtesting. Le code correspondant à cette partie du projet est disponible dans le dossier /code/5-Backtesting-Frontend.

L'interface implémente tous les endpoints de l'API, à l'exception de celui permettant de récupérer les résultats. Elle permet d'initier un job de backtesting, de suivre son état en temps réel, puis d'afficher son rapport et ses logs. L'interface est conteneurisée et déployée sur Kubernetes.

Pour des raisons de rapidité et étant donné que c'était un objectif secondaire, l'interface a été développée en VueJS, le framework que je maîtrise le mieux, contrairement à Angular utilisé par LYSR pour son frontend. Il me semblait néanmoins pertinent de créer cette interface pour regrouper et visualiser les résultats obtenus, ne serait-ce que pour une démonstration. Cela permet également de montrer comment implémenter l'API de backtesting et de proposer à LYSR une conception d'interface respectant leur charte graphique.


== Conclusion

Ce chapitre a présenté l'implémentation du système de backtesting en détaillant chaque étape clé. La détection des anomalies et le développement du premier prototype ont été abordés en premier, puis le backtesting local avec Ray et MLflow a été implémenté, suivi de la génération de rapports de backtesting et de l'intégration du système de backtesting au backend de LYSR. Enfin, la création d'une interface web a été réalisée. Chaque section a mis en avant les défis rencontrés et les solutions apportées.