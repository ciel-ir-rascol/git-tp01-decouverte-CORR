# Corrigé — TP01 Découverte de Git et GitHub

**1CIEL-IR — Corrigé commenté du TP [`git-tp01-decouverte`](https://github.com/ciel-ir-rascol/git-tp01-decouverte).**

Ce corrigé ne sert pas seulement à vérifier vos réponses : il explique **pourquoi** Git se comporte comme il le fait à chaque étape. Si vous comprenez les explications de ce document, vous avez compris le TP.

![La chaîne Git](https://raw.githubusercontent.com/ciel-ir-rascol/git-tp01-decouverte/main/figures/chaine-git.svg)

---

## Comment utiliser ce corrigé

1. **Faites d'abord le TP vous-même**, jusqu'au bout. Lire la réponse avant d'avoir cherché ne vous apprend presque rien : c'est en se trompant qu'on retient.
2. **Comparez** ensuite votre `COMPTE-RENDU.md` avec [CORRECTION.md](CORRECTION.md), question par question.
3. Pour chaque écart, **relisez l'explication** (encadrés 💡 *Pour comprendre*) et, si besoin, **refaites la manipulation** dans votre dépôt `~/tp-git/tp01-git`.
4. Terminez par la section **[À retenir](CORRECTION.md#-à-retenir)** : c'est le résumé de ce que vous devez savoir faire pour les TP suivants.

## Contenu

| Fichier | Ce que vous y trouvez |
| --- | --- |
| [CORRECTION.md](CORRECTION.md) | Réponses commentées, exemples de sorties, erreurs fréquentes, ce qui est évalué, résumé final |

## Vos sorties ne sont pas identiques ? C'est normal

Les exemples de ce corrigé ont été obtenus par une étudiante fictive, **Léa Martin** (pseudo `lea-martin`). Chez vous, changent forcément :

- les **hashs** des commits (`8fd6812…`) : ils dépendent du contenu, de l'auteur **et de la date** de chaque commit ;
- les **dates**, votre **nom**, votre **e-mail**, votre **pseudo** ;
- la **langue** des messages : les exemples sont en anglais, votre poste peut les afficher en français. La correspondance est donnée au début de [CORRECTION.md](CORRECTION.md#messages-de-git-en-anglais-et-en-français).

Ce qui doit être identique : **les commandes**, **l'ordre des étapes** et **la structure des messages** de Git.

## Refaire le TP chez soi

Sous Windows ou macOS, refaites le TP dans la VM Ubuntu Server des TPs : [`UbuntuServer_TP_2026-10-12.ova`](https://drive.google.com/file/d/1YFFg--7t9_iR0x6Gb9NXu8n01Hx3OSQy/view?usp=sharing) sur Google Drive (compte rascol.net). La procédure d'import et de connexion est dans l'encadré **Faire le TP chez soi** du [sujet](https://github.com/ciel-ir-rascol/git-tp01-decouverte#environnement-de-travail). Seule différence avec le poste du lycée : Git n'est pas installé dans la VM (voir la [partie 0](CORRECTION.md#partie-0--préparer-son-poste) du corrigé).

---

*Licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr) — BTS CIEL option IR, Lycée Louis Rascol, Albi.*
