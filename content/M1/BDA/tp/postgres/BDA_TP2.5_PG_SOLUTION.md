# Partie 1

## Exo 1

### Question 1 qst

```sql
SELECT d.nom,p.nom,p.prenom,(adresse).ville AS ville   FROM public.employe p join departement d ON p.id_departement=d.id_departement  ORDER BY d.nom, p.nom;
```
