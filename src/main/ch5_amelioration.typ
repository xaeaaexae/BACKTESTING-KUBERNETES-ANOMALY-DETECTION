= Améliorations

Dans ce chapitre, nous décrivons les améliorations suggérées pour le système de backtesting implémenté. Bien que de nombreuses fonctionnalités aient déjà été développées, de nouvelles fonctionnalités et améliorations pourraient être ajoutées si le temps le permettait. Nous détaillons ces suggestions pour chaque composant : le script de backtesting, l'API de backtesting et l'interface utilisateur, avec une estimation du temps et du niveau de difficulté.

#set heading(outlined:false)

== Backtesting script

Le système de backtesting fonctionne actuellement avec des règles simples, telles que "prediction >= 1". Bien que cela soit suffisant pour ce travail de bachelor, il serait intéressant, dans une future itération, d'améliorer le script pour évaluer des règles plus complexes, telles que "engine.temperature < 80" ou "prediction >= 1 & lux > 10000". La difficulté de cette tâche peut augmenter en fonction de la complexité des règles à évaluer. Il serait utile d'analyser si des outils existent pour faciliter ce processus.

Une autre amélioration consisterait à exécuter l'inférence et l'application des règles en parallèle pour les données étiquetées (+modèle stateless), ce qui n'est pas le cas actuellement. Pour ce faire, il faudrait utiliser une référence permettant de retrouver quelle donnée correspond à quelle vérité, même si l'ordre des résultats change. Cela pourrait être réalisé relativement facilement lors du chargement et traitement des données.

== Backtesting API

L'API fonctionne bien, mais certains aspects négligés en raison du temps limité pourraient être améliorés. Voici les améliorations à effectuer avant la mise en production :

- *Validation des endpoints* : Les données fournies à l'API ne subissent actuellement pas de contrôle strict. Il faudrait vérifier la conformité des données en paramètres, dans l'en-tête ou le corps des requêtes (schéma, types, longueur, etc.). Cette validation garantit l'intégrité des données, prévient les erreurs et renforce la sécurité.
- *Gestion des erreurs* : Les exceptions sont actuellement attrapées (catch) de manière générale, ce qui rend les messages retournés assez génériques. Il serait nécessaire d'améliorer ce processus pour fournir des messages plus précis et utiles à l'utilisateur.
- *Gestion des secrets* : Les données confidentielles utilisées par le script de backtesting sont actuellement stockées dans des secrets Kubernetes. Il serait pertinent d'évaluer si ce stockage est la meilleure solution ou s'il existe des options plus efficaces.
- *Surveillance du statut des jobs Ray* : Actuellement, il faut effectuer du polling pour récupérer le statut d'un job Ray. Il serait utile d'explorer des alternatives comme les WebSockets, le long polling ou les Server-Sent Events (SSE) pour obtenir le statut des jobs de manière plus efficace.
- *Nouveau endpoint *: Un endpoint pourrait être implémenté pour récupérer la liste de tous les backtestings d'un utilisateur/workspace LYSR.

Ces améliorations ne sont pas très complexes, mais nécessitent du temps pour être bien réalisées, en particulier pour assurer la sécurité, ce qui est primordial pour une API en production.

== Backtesting interface

Le frontend du backtesting fonctionne bien et simplifie les actions relatives au backtesting via une interface graphique, mais certaines fonctionnalités pourraient être ajoutées :

- *Téléchargement des résultats bruts* : Actuellement, les résultats bruts du backtesting sont enregistrés sur MinIO. Il serait intéressant d'ajouter une section permettant de télécharger ces fichiers, d'autant plus que l'endpoint pour ce téléchargement fonctionne déjà.
- *Liste de tous les backtestings *: Actuellement, il n'est pas possible d'accéder aux anciens backtestings lancés depuis l'interface. Une nouvelle section pourrait permettre de visualiser tous les backtesting et de consulter leurs résultats.
- *Comparaison des résultats* : Actuellement, le frontend permet de visualiser uniquement les résultats d'un seul backtesting. Il serait intéressant d'ajouter une section permettant de sélectionner plusieurs backtesting et de comparer leurs résultats à travers de nouvelles visualisations.

Ces tâches sont d'une difficulté modérée mais demandent du temps, surtout pour la conception des visualisations permettant de comparer les résultats du backtesting.

== Conclusion

Ce chapitre a présenté les améliorations suggérées pour le système de backtesting, couvrant le script, l'API et l'interface utilisateur. Bien que le système soit déjà fonctionnel, ces améliorations visent à optimiser son efficacité et à enrichir ses fonctionnalités, assurant ainsi une meilleure expérience utilisateur et une intégration plus robuste.