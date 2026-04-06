
# **Swala7 dirhom khatra lowla:**
### **Calculer le vecteur centroïde V du corpus:**

tejma3 les poids ta3 un terme ou ta9semhom 3la nombre de documents (horizental)
> [!abstract] Vecteur centroide
> $$p_j = \frac{\sum_{i=1}^N p_{ij}}{N}$$
> - $N$ = Nombre document
> - $p_i$ = poids du terme

### **Calculer l’uniformité initiale:**

> [!abstract] MaxS
> $$\text{MaxS} = M \times \left( \max_{1 \leq i \leq N,\; 1 \leq j \leq M} d_{ij} \right)^2$$
> - $M$ = Nombre de termes
> - $Maxd_{ij}$ = poids du terme lekbir kamel f document (chouf verticalment)

> [!abstract] Similitude
> $$\operatorname{Sim}(d_i, V) = 1 - \sqrt{\frac{\sum_{j=1}^{M} |d_{ij} - V_j|^2}{\text{MaxS}}}$$
> - $d_{ij}$ = poids du terme par document (chouf verticalment)
> - $V$ = vecteur centroide

> [!abstract] Uniformité corpus
> $$U = \frac{1}{N} \sum_{i=1}^{N} \operatorname{Sim}(d_i, V)$$
> - Hiya semato U1 bsa7 khaltatni tesmiya mala semito U bark


# **Swala7 yet3awdo:**

- tebda bel $t_1$ ou trod ga3 les poids ta3o 0
- to7sob ${U_1}$ b nafs tari9a ta3 gbilat bsa7 les poids ta3 gbilat bsa7 les poids ta3 $t_1$ rahom 0
- dir $U_1 - U$ 
- t3awed el 3amaliya b $t_2, t_3...$  7ata tkemel ga3 les termes
