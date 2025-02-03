#let v-skip-xxs = v(1em, weak: true)
#let v-skip-xs = v(2em, weak: true)
#let v-skip-s = v(3em, weak: true)
#let v-skip-xl = v(4em, weak: true)

= Conception

Dans ce chapitre, nous détaillons la conception des différentes composantes nécessaires à l'élaboration du système de backtesting. Cette conception est structurée en sous-chapitres qui abordent le fonctionnement de la détection d'anomalies, le backtesting avec Ray, la structure du rapport de backtesting, ainsi que l'intégration du backtesting au backend et au frontend de LYSR.


== Détection d’anomalies

La détection d'anomalies en temps réel via IA se fait en deux étapes distinctes. La première est l'entraînement du modèle et la seconde, la détection d'anomalies à l'aide du modèle. Ces deux étapes sont détaillées dans les sections suivantes.

*Entraînement du modèle*

La première étape de la détection d'anomalies par IA dans les séries temporelles consiste à entraîner un modèle avec un jeu de données historiques ou fictif si aucune donnée n'est disponible. Les deux parties principales, comme le montre la figure 3.11, sont le traitement des données et l'entraînement du modèle. Une fois validé, le modèle peut être déployé dans un registre de modèles (p. ex. MLflow Model Registry).

#figure(
  image("../images/model-prep-&-training.png", width: 90%), caption: [Processus de préparation et d'entraînement des modèles]
)

#v-skip-xs

Le traitement des données comprend la collecte, la préparation (par exemple, le nettoyage, la normalisation) et la sélection des features pertinentes pour le modèle. L'entraînement du modèle inclut le choix de l'algorithme (par exemple, isolation forest, autoencodeurs), l'entraînement avec les données et l'évaluation à l'aide de métriques telles que la précision, le rappel et le F1-score.

#v-skip-s
*Détection des anomalies*

La deuxième étape, après le développement du modèle, consiste à détecter les anomalies potentielles. Comme illustré à la figure 3.12, cette étape inclut la génération de séries temporelles à partir des capteurs, l'analyse des données par inférence, et l'application de règles pour identifier les anomalies.

#figure(
  image("../images/anomaly-detection-process.png", width: 59%), caption: [Processus d'inférence pour la détection des anomalies]
)

== Backtesting avec Ray

Le système de backtesting à implémenter dans ce trvail doit fonctionner avec Ray. Cela permet de distribuer les processus de backtesting sur plusieurs nœuds, améliorant ainsi les performances et optimisant l'utilisation des ressources. Le schéma ci-dessous (Figure 3.13) illustre les étapes du système de backtesting fonctionnant avec Ray.

#v-skip-s

#figure(
  image("../images/backtesting-with-ray-2.png", width: 120%), caption: [Backtesting avec Ray]
)

#v-skip-xs

Les étapes sont les suivantes :

(1) *Initialiser du cluster Ray* : Démarrer un cluster Ray ou se connecter à un cluster existant pour permettre la parallélisation des tâches avec _ray.init_.

(2) *Récupérer le modèle et les règles* : Importer le modèle et les règles via l'API de LYSR. Les modèles sont au format MLflow. Les règles sont des chaînes de caractères qui, une fois appliquées, retournent un booléen. 

(3) *Récupérer les données *:  Importer les données au format CSV ou Parquet via l'API de LYSR. Ces données sont ensuite converties en Ray Dataset avec _ray.data_. Cela permet un traitement parallèle._ Ray.data_ prend en charge la planification des ressources CPU et GPU.

(4) *Inférence* :  Réaliser l'inférence en parallèle si le modèle est stateless, sinon en séquence si stateful, sur les partitions des données avec ds.map_batches(). Cette méthode permet de configurer le traitement en parallèle via le paramètre concurrency (le nombre de workers Ray à utiliser simultanément). Elle offre également d'autres paramètres de configuration tels que batch_size (le nombre de lignes par batch) et gpus (le nombre de GPUs à réserver pour chaque worker parallèle).

(5) *Appliquer les règles* : Appliquer les règles sur les résultats d'inférence collectés. Cette étape peut également être effectuée en parallèle de manière similaire à l'inférence, en utilisant _ds.map_batches()_.

(6) *Afficher + stocker les résultats* : Présenter et enregistrer les résultats collectés. L'enregistrement se fait sous forme d'objet storage au format Parquet.

#v-skip-xs

Comme mentionné précédemment, le backtesting ne réalise pas l'inférence de la même manière pour les modèles stateless et stateful, car les modèles stateful maintiennent un état interne dépendant des entrées précédentes. Pour garantir la cohérence et l'actualité de cet état, il est essentiel de ne pas effectuer les inférences en parallèle, ce qui pourrait sinon entraîner des résultats incohérents ou non pertinents. Dans ce travail, il est souhaité que les deux cas soient pris en compte. Pour ce faire, l'information indiquant si un modèle est stateful ou stateless se trouve dans les métadonnées du modèle. Les étapes présentées précédemment seront implémentées en Python pour assurer la compatibilité avec Ray.

== Rapport de backtesting

Le backtesting, présenté dans le chapitre précédent, génère des résultats bruts tels que les prédictions et les résultats des règles appliquées. Ces données sont utilisées pour créer un rapport facilitant la compréhension et l'interprétation des résultats du backtesting. Le contenu du rapport est le suivant :

- *Matrice de confusion *: 0 à N matrices de confusion proportionnelles au nombre de règles (uniquement si les données sont étiquetées).
- *Métriques* : 0 à N métriques (précision, rappel, f1-score) proportionnelles au nombre de règles (uniquement si les données sont étiquetées).
- *Graphiques des séries temporelles*, comprenant différentes sous-parties :
  - Les données initiales (input)
  - Les anomalies réelles (uniquement si les données sont étiquetées)
  - Les résultats des règles (uniquement si des règles sont définies)
  - Les résultats des règles combinées avec l'opérateur OR (uniquement s'il y a au moins deux règles)

Ce rapport permet de visualiser les données temporelles initiales ainsi que les emplacements des anomalies réelles et potentielles. Il évalue également la performance des modèles et des règles combinées lorsque les données sont étiquetées. Le rapport sera au format HTML pour permettre des graphiques dynamiques et interactifs, ce qui est utile, par exemple, pour sélectionner uniquement les valeurs intéressantes, zoomer sur une période spécifique et exporter ces vues sous forme d'image. De plus, le format HTML du rapport facilitera son intégration au frontend de la plateforme LYSR. La bibliothèque Plotly sera utilisée car elle répond parfaitement à ces besoins. Le rapport sera généré par un script Python.

== Intégration du backtesting au backend de LYSR

LYSR propose de nombreux services, notamment pour leur plateforme (alerte, ingester, etc.), le stockage (MLflow, MinIO, etc.), et le cluster Ray. Pour intégrer le script de backtesting à LYSR et ses services, de nouveaux services spécifiques au backtesting doivent être implémentés.

Les schémas ci-dessous (Figures 3.14 et 3.15) illustrent les nouveaux services (en bleu) à implémenter et leur interaction avec les services existants de LYSR (en gris). Le premier diagramme de séquence (Figure 3.14) montre le processus de lancement d'un job de backtesting.

#v-skip-s

#figure(
  image("../images/backtesting-lysr-3.png", width: 130%), caption: [Diagramme de séquence - Lancement du backtesting]
)

#v-skip-xs

*Description des interactions du diagramme de séquence précédent :*

*1: Run backtesting* - Un utilisateur envoie une requête POST à l'API REST du backtesting avec les informations nécessaires : identifiant du dataset (exportId), nom et version du modèle (ModelName & ModelID), liste de règles (rules) et identifiant MLflow de l'utilisateur (mlflowId). L'acess token de LYSR doit être renseigné dans le header. L'API, développée en Java avec Spring Boot, assure la compatibilité avec les autres services de LYSR.

*1.1: Retrieve Kubernetes secrets* - L'API backtesting récupère les secrets Kubernetes pour accéder aux services LYSR, MLflow et MinIO.

*1.2: Submit a job* - L'API backtesting envoie une requête POST au cluster Ray pour lancer le job avec les détails nécessaires : commande à exécuter (entrypoint), dépendances (pip), répertoire de travail (working_dir) et variables d'environnement (env_vars). Le cluster Ray est accessible uniquement au sein du cluster Kubernetes.

*1.3: Response* - Le cluster Ray retourne une réponse HTTP à l'API backtesting avec un status code et un message JSON.

*1.4: Response* -  L'API backtesting renvoie une réponse HTTP, au format JSON, à l'utilisateur incluant le submission ID nécéssaire au suivi des logs et du statut du job.

*2: Install Python dependencies* - Le cluster Ray installe les dépendances nécessaires sur les workers utilisés pour le backtesting.

*3: Get the working dir zip* - Le script de backtesting est téléchargé depuis le serveur de fichiers, servant de répertoire de travail.

*4: Execute the entry point in the working dir* - La commande de lancement du script de backtesting est exécutée dans le répertoire de travail.

*5: Get the model* - Le modèle sélectionné est téléchargé depuis le registre de modèles de MLflow.

*6: Get the data* - Les données de l'utilisateur, issues d'un export(=dataset) depuis la plateforme LYSR, sont téléchargées.

*7: Inference* - Le modèle réalise l'inférence sur les données, retournant une prédiction.

*8. Apply the rules* - Les règles sont appliquées aux résultats.

*9. Store results* - Les données (input et résultats) sont enregistrées au format Parquet et uploadées sur MinIO.

#pagebreak()

Le diagramme de séquence (Figure 3.15) montre le processus de récupération du statut et des logs d'un job de backtesting en cours ou terminé sur le cluster Ray.

#figure(
  image("../images/backtesting-lysr-4.png", width: 90%), caption: [Diagramme de séquence - Statut et logs du backtesting]
)


Le processus de récupération du statut ou des logs est presque identique, comme suit :

*n: Retrieve the status or logs for a specific submission ID* - L'utilisateur envoie une requête GET à l'API backtesting avec le submission ID du job de backtesting.

*n.1: Retrieve the status or logs for a specific submission ID* - L'API backtesting interroge le cluster Ray.

*n.2 Response* - Le cluster Ray retourne une réponse HTTP à l'API, au format JSON.

*n.3: Response* - L'API renvoie une réponse HTTP à l'utilisateur avec le statut ou les logs actuels du job, au format JSON.

*Note* : L'API de backtesting permet également de récupérer les résultats au format Parquet ainsi que le rapport HTML. Leur fonctionnement est identique à celui des logs et du statut, à l'exception du format de réponse qui diffère.

== Intégration du backtesting au frontend de LYSR

Le backend présenté dans le chapitre précédent permet de lancer entre autres le backtesting et de récupérer le rapport correspondant. Une interface utilisateur intuitive est préférable à des requêtes manuelles. Le frontend doit donc répondre aux besoins des utilisateurs tout en s'intégrant harmonieusement à la plateforme LYSR.

Pour rappel, sur la plateforme LYSR, un utilisateur peut disposer d'un ou plusieurs espaces de travail (workspaces) contenant toutes les ressources liées au processus de surveillance, y compris les exports, les modèles et les règles. Les éléments de l'interface sont les suivants :

- Une liste pour sélectionner les exports (=datasets) du workspace de l'utilisateur.
- Une liste pour sélectionner les modèles du workspace de l'utilisateur.
- Une liste pour sélectionner les règles du workspace de l'utilisateur.
- Un ou plusieurs champs pour ajouter de nouvelles règles.
- Un bouton pour lancer le backtesting.
- Une section pour afficher le statut du backtesting en temps réel.
- Un bouton pour afficher les logs une fois le backtesting terminé.
- Une section pour afficher le rapport une fois le backtesting terminé.


La figure 3.16 présente une esquisse minimaliste du contenu du frontend et de ses interactions avec les autres services de LYSR.

#figure(
  image("../images/frontend-1.png", width: 70%), caption: [Frontend du backtesting]
)

Le frontend interagit avec l'API de LYSR pour récupérer les données de l'utilisateur et avec l'API de backtesting pour effectuer les actions relatives à ce dernier. Elle devra également respecter la charte graphique de la plateforme LYSR.


== Conclusion

Ce chapitre a présenté la conception des diverses composantes nécessaires à l'élaboration du système de backtesting. Il a abordé le fonctionnement de la détection d'anomalies via l'intelligence artificielle, l'implémentation du backtesting avec Ray, la structure du rapport de backtesting, ainsi que l'intégration de ces fonctionnalités aux backends et frontends de la plateforme LYSR. L'approche modulaire micro-service permet d'offrir une bonne flexibilité et l'interface devrait répondre aux besoins des utilisateurs qui utilisent le backtesting.