#let v-skip-null = v(-0.05em, weak: true)
#let v-skip-xxs = v(1em, weak: true)
#let v-skip-xs = v(2em, weak: true)
#let v-skip-s = v(3em, weak: true)
#let v-skip-m = v(4em, weak: true)
#let v-skip-l= v(5em, weak: true)
#let v-skip-null = v(-0.07em, weak: true)

= Résultats

Dans ce chapitre, nous décrivons les résultats du système de backtesting, incluant le script de backtesting, l'API de backtesting, l'interface de backtesting, ainsi que leur intégration et déploiement continu.

#set heading(outlined:false)

== Backtesting script

Le script fonctionne parfaitement sur un cluster Ray local ainsi que sur celui de LYSR. Il s'intègre également avec Mlflow, MinIO et les autres services de LYSR, facilitant ainsi la récupération des modèles, règles et données. Le script de backtesting prend en charge plusieurs fonctionnalités, y compris les modèles stateful et stateless, les données étiquetées et non étiquetées, ainsi que de 0 à N règles appliquées aux prédictions des modèles. À la fin de son exécution, un rapport de backtesting est généré. Ce rapport s'adapte aux données, par exemple, selon qu'elles soient étiquetées ou non, ou qu'il y ait zéro ou plusieurs règles. Le format HTML du rapport permet d'interagir avec les données pour une meilleure compréhension et facilite son intégration à la plateforme LYSR. Grâce à cette flexibilité, le système peut répondre à divers besoins de backtesting et permet d'interpréter efficacement les résultats.

#pagebreak()

== Backtesting API

Cette section présente chaque endpoint de l'API avec une capture d'écran qui décrit la requête effectuée via Postman, ainsi que la réponse correspondante. La documentation Swagger est disponible à l'adresse suivante : https://2024-tb-k8s-backtesting.kube.isc.heia-fr.ch/swagger-ui/index.html.

#v-skip-m

*Vérification du fonctionnement de l'API* (Figure 7.24)
#figure(
  image("../images/Results/r1.png", width: 120%), caption: [Requête HTTP : Vérification du fonctionnement de l'API] 
)
#v-skip-xs
*Description* : La requête GET vérifie l'état de l'API de backtesting, avec une réponse JSON confirmant que l'API est en cours d'exécution (RUNNING).

#pagebreak()

#v-skip-l
*Lancement d'un job de backtesting* (Figure 7.25)

#figure(
  image("../images/Results/r2.png", width: 120%), caption: [Requête HTTP : Lancement d'un job de backtesting] 
)

#v-skip-xs
*Description* : La requête POST lance un job de backtesting, avec un body JSON incluant des règles, un ID d'export (=dataset), le nom et la version d'un modèle, ainsi qu'un ID Mlflow. Le token d'accès LYSR est inclus dans le header "Authorization". La réponse JSON confirme la soumission réussie du job et retourne le submission ID.

#pagebreak()

#v-skip-l
*Récupération du statut d’un job* (Figure 7.26)

#figure(
  image("../images/Results/r3.png", width: 120%), caption: [Requête HTTP : Récupération du statut d’un job] 
)
#v-skip-xs
*Description* : La requête GET vérifie le statut d'un job de backtesting avec une réponse JSON indiquant le statut (SUCCEEDED). Les différents statuts possibles sont "PENDING", "RUNNING", "FAILED", "STOPPED" et "SUCCEEDED".

#pagebreak()

#v-skip-l
*Récupération des logs d’un job* (Figure 7.27)

#figure(
  image("../images/Results/r4.jpg", width: 120%), caption: [Requête HTTP : Récupération des logs d’un job] 
)

#v-skip-xs
*Description* : La requête GET permet de récupérer les logs d'un job de backtesting, avec une réponse JSON contenant les logs des différentes étapes du processus.

#pagebreak()

#v-skip-l
*Récupération des résultats d’un job* (Figure 7.28)

#figure(
  image("../images/Results/r5.png", width: 120%), caption: [Requête HTTP : Récupération des résultats d’un job] 
)

#v-skip-xs
*Description* : La requête GET permet de récupérer les résultats d'un job de backtesting, sous forme d'un fichier Parquet. Enregistrer et ouvrir ce fichier avec un outil compatible permet d'afficher tous les résultats du backtesting.

#pagebreak()

#v-skip-l
*Récupération du rapport d’un job* (Figure 7.29)

#figure(
  image("../images/Results/r6.png", width: 120%), caption: [Requête HTTP : Récupération du rapport d’un job] 
)

#v-skip-xs
*Description* : La requête GET permet de récupérer le rapport HTML d'un job de backtesting.

#pagebreak()

== Backteting interface

Cette section présente l'interface web du backtesting accessible à l'adresse suivante : https://2024-tb-k8s-backtesting-app.kube.isc.heia-fr.ch/. 

#v-skip-l
*Accès à l'interface web* (Figure 7.30)

#figure(
 image("../images/Results/rr1.png", width: 100%), caption: [Interface web : Accueil] 
)

*Description* : L'interface permet de sélectionner les paramètres du backtesting. Cependant, avant d'accéder à la liste de ses exports, modèles et règles de son workspace LYSR, l'utilisateur doit saisir son access token et son ID MLflow dans les deux champs en bas de la page. Ces champs sont temporaires car si cette interface était intégrée à la plateforme LYSR, l'utilisateur serait déjà authentifié et ces valeurs seraient connues du frontend.

#pagebreak()

#v-skip-l
*Saisie des informations de backtesting et lancement* (Figure 7.31)

#figure(
 image("../images/Results/rr3.png", width: 100%), caption: [Interface web : Saisie des informations] 
)

*Description* : Une fois l'access token et l'ID MLflow saisis, l'utilisateur peut sélectionner les paramètres du backtesting, dont l'export, le modèles et 0 à N règles prédéfinies ou personnalisées. Après avoir sélectionné un export, les noms de ses colonnes sont affichés sous le champ, ce qui peut être utile pour appliquer une règle à l'une d'elles. Une fois tous les paramètres définis, l'utilisateur peut lancer le backtesting et attendre la fin du job. Le statut permet de suivre la progression en direct.

#pagebreak()

#v-skip-l
*Visualisation du rapport* (Figure 7.35)

#figure(
 image("../images/Results/rr4.png", width: 100%)
)
#v-skip-null
#figure(
 image("../images/Results/rr5.png", width: 100%)
)
#v-skip-null
#figure(
 image("../images/Results/rr6.png", width: 100%)
)
#v-skip-null
#figure(
 image("../images/Results/rr7.png", width: 100%), caption: [Interface web : Visualisation du rapport] 
)

*Description* : Si le job de backtesting s'est correctement déroulé, le rapport est affiché à l'utilisateur, qui peut interagir avec pour une meilleure compréhension et visualisation. Dans cet exemple, le rapport contient tous les éléments possibles, car les données sont étiquetées et il y a plus de deux règles. Dans le cas contraire, seul le graphique affichant les inputs serait présenté.

#v-skip-l
*Visualisation des logs * (Figure 7.36)

#figure(
 image("../images/Results/rr9.png", width: 100%), caption: [Interface web : Visualisation des logs ] 
)

*Description* : Que le job de backtesting ait réussi ou non, l'utilisateur peut afficher les logs.

#pagebreak()

== Déploiement de backtesting et autres services

L'API de backtesting et le frontend sont déployés sur le cluster Kubernetes de la HEIA-FR. Pour garantir leur bon fonctionnement, un système de stockage MinIO a été mis en place pour enregistrer les résultats de backtesting, simulant celui de LYSR. En outre, un serveur de fichiers a été configuré pour permettre l'accès au script de backtesting depuis n'importe quel worker de Ray.

La capture d'écran ci-dessous (Figure 7.37) présente les pods déployés sur Kubernetes.

#figure(
 image("../images/Results/rrr1.png", width: 120%), caption: [Pods Kubernetes] 
)

*Description* : Les quatre pods visibles sur l'image correspondent à l'API (backtesting), au serveur de fichiers (backtesting-dependencies), au frontend (backtesting-frontend) et au système de stockage MinIO (minio). Les images sont obtenues depuis le container registry de la HEIA-FR, à l'exception de MinIO qui utilise une image publique. En suivant les pratiques DevOps, les containers sont automatiquement build et déployés à chaque modification du code sur le dépôt GitLab, assurant ainsi une intégration continue et un déploiement continu (CI/CD).

#pagebreak()

La seule configuration manuelle requise concerne les secrets suivants (Figure 7.38) nécessaires au bon fonctionnement du backtesting.

#figure(
 image("../images/Results/rrr2.png", width: 100%), caption: [Secrets Kubernetes] 
)

*Description* : Les identifiants permettant d'accéder au script de backtesting, à l'API de LYSR, à MinIO, à MLflow et au cluster Ray sont définis dans un secret de type Opaque. Ces valeurs sont ensuite lues par l'API qui les transmet comme variables d'environnement au job Ray.
 
== Conclusion

Ce chapitre a décrit les résultats du système de backtesting, en couvrant le script, l'API, l'interface utilisateur, ainsi que leur intégration et déploiement continu. Ces résultats démontrent le bon fonctionnement du système et sa capacité à s'intégrer harmonieusement dans l'écosystème de LYSR.