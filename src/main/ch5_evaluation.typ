= Évaluation

Dans ce chapitre, nous évaluons les différentes composantes du projet, à savoir le script de backtesting, l'API de backtesting et l'interface de backtesting. Chaque section aborde les tests effectués et les résultats obtenus. L'objectif est de s'assurer de leur bon fonctionnement et de leur intégration harmonieuse dans l'ensemble du système.

#set heading(outlined:false)
== Backtesting script 

Le tableau ci-dessous présente les tests effectués et leurs résultats pour le script de backtesting. Ce script, développé en Python, permet d'évaluer un ensemble de règles et de modèles sur des données temporelles, le tout étant parallélisé avec Ray. Un rapport est généré à la fin du processus.

#let my-table = "figure(
  table(
    columns: 3,
    align: left,
    table.hline(),
    table.header(
      [*ID*], [*Description*], [*Résultats*],
    ),
    table.hline(stroke: 0.5pt),
    [1], [Backtesting avec données étiquetées + 0 à N règle sur la prédiction (résultat de l'inférence)], [Réussie],
    [2], [Backtesting avec données étiquetées + 0 à N règle sur une colonne de l'export (données initiales)], [Échoué],
    table.hline(stroke: 0.5pt),
    [3], [Backtesting avec données non étiquetées + 0 à N règles sur la prédiction (résultat de l'inférence)], [Réussie],
    [4], [Backtesting avec données non étiquetées + 0 à N règle sur une colonne de l'export (données initiales)], [Échoué],
    table.hline(),
    table.hline(stroke: 0.5pt),
    
  ),
)"

#eval(my-table) <tab:esempio>

Les tests ont été réalisés uniquement avec un modèle stateless. Cependant, les modèles stateful devraient également fonctionner, car ils sont pris en compte dans le script de backtesting. Les données étiquetées contiennent une colonne indiquant s'il s'agit d'une anomalie ou non.

Les tests 2 et 4 échouent parce que les noms des colonnes des exports contiennent des points (par exemple, engine.temperature). Seuls les noms de colonnes simples sont correctement interprétés par le script de backtesting. Néanmoins, l'application de règles sur les résultats de l'inférence, qui était l'objectif principal, fonctionne correctement.

== Backtesting API

Le tableau suivant présente les tests effectués et leurs résultats pour l'API de backtesting. Cette API, développée en Java (Spring Boot), permet d'initier le backtesting et d'autres actions telles que la récupération des résultats ou du rapport.

#let my-table = "figure(
  table(
    columns: 3,
    align: left,
    table.hline(),
    table.header(
      [*ID*], [*Description*], [*Résultats*],
    ),
    table.hline(stroke: 0.5pt),
    [1], [Accéder à un endpoint inexistant], [404 Not Found],
    table.hline(stroke: 0.5pt),
    [2], [Récupérer le statut de l'API], [200 OK {status: RUNNING}],
    table.hline(),
    table.hline(stroke: 0.5pt),
    [3], [Démarrer un job de backtesting avec un body valide\*], [200 OK],
    [3.1], [Récupérer le statut du job après 0 seconde], [200 OK {status: PENDING}],
    [3.2], [Récupérer le statut du job après 10 secondes], [200 OK {status: RUNNING}],
    [3.3], [Récupérer le statut du job après 30 secondes], [200 OK {status: SUCCEEDED}],
    [3.4], [Récupérer les logs du job], [200 OK],
    [3.5], [Récupérer les résultats du job], [200 OK],
    [3.6], [Récupérer le rapport du job], [200 OK],
    table.hline(),
    [4], [Démarrer un job de backtesting avec body invalide\*\*], [200 OK],
    [4.1], [Récupérer le statut du job après 0 seconde], [200 OK {status: PENDING}],
    [4.2], [Récupérer le statut du job après 10 secondes], [200 OK {status: FAILED}],
    [4.3], [Récupérer les logs du job], [200 Ok],
    [4.4], [Récupérer les résultats du job], [404 Not Found],
    [4.5], [Récupérer le rapport du job], [404 Not Found],
    table.hline(),
  ),
)"

#eval(my-table) <tab:esempio>

\* Un body valide comprend une structure correcte et un contenu approprié, c'est-à-dire un exportId, un modèle et des règles existants.

\*\* Un body invalide comprend une structure incorrecte ou un contenu incorrect, comme un exportId inexistant, un modèle inexistant ou des règles inexistantes.

Les tests de l'API sont positifs, les résultats obtenus sont conformes aux attentes.

== Backtesting interface

Le tableau suivant présente les tests effectués et leurs résultats pour l'interface du backtesting. Ce frontend, développé avec Vue.js, permet d'initier le backtesting via une interface graphique, ainsi que de visualiser les résultats et les logs.

#let my-table = "figure(
  table(
    columns: 3,
    align: left,
    table.hline(),
    table.header(
      [*ID*], [*Description*], [*Résultats*],
    ),
    table.hline(stroke: 0.5pt),
    [1], [Afficher la liste des exports d'un workspace], [Réussi],
    [2], [Afficher la liste des modèles d'un workspace], [Réussi],
    [3], [Afficher la liste des règles d'un workspace], [Réussi],
    [4], [Ajouter manuellement 1 à N règles], [Réussi],
    [5], [Lancer le backtesting avec les options sélectionnées], [Réussi],
    [6], [Afficher le statut du backtesting en direct], [Réussi],
    [7], [Afficher les logs du backtesting], [Réussi],
    [8], [Afficher le rapport du backtesting], [Réussi],
    [9], [Relancer un nouveau backtesting], [Réussi],
    table.hline(stroke: 0.5pt),
  ),
)"

#eval(my-table) <tab:esempio>

Les tests de l'interface sont positifs, sans problèmes à signaler.

== Conclusion

L'évaluation des différentes composantes du projet révèle que le script de backtesting, l'API de backtesting et l'interface de backtesting fonctionnent globalement bien. Les tests effectués ont montré que, malgré quelques échecs liés à des détails techniques comme le format des noms de colonnes, les objectifs ont été atteints.

Tous ces tests ont été effectués manuellement. Pour respecter la philosophie DevOps, et plus précisément DevSecOps, il serait nécessaire d'automatiser ces tests. Bien que cela n'ait pas été possible durant la durée du projet, il est important de noter que des tests unitaires devraient être réalisés pour s'assurer du bon fonctionnement du code en isolant et en examinant des sections spécifiques. De plus, des tests d'intégration pourraient vérifier l'interaction entre les différents services, tels que l'API, le frontend et le cluster Ray. Enfin, des tests de sécurité sont essentiels, incluant la surveillance et la mise à jour des dépendances.








