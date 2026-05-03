# Achya2at momila fel debut ta3 el cours
## **Definition:**
#### Deadlocks:
ki les processus y9ar3o un evenement jamais ghadi yewsal

---
# Achaya2at mofida

```mermaid  
graph BT
	
	subgraph "A 3andha R" 
	R[R] --> A((&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)) 
	end 
	subgraph "B demandi S" 
	B((&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;B&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)) --> S[S] 
	end 
	subgraph "Deadlock" 
	C((&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;C&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)) --> T[T] 
	T --> D((&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)) 
	D --> U[U] 
	U --> C 
	end 
	style A fill:none,stroke:#000
	style R fill:none,stroke:#000
	style B fill:none,stroke:#000 
	style S fill:none,stroke:#000 
	style D fill:none,stroke:#000 
	style U fill:none,stroke:#000 
	style C fill:none,stroke:#000 
	style T fill:none,stroke:#000
```
Ki ykon kayen cicle ma3netha kayen deadlock
# Fichiers Utiles
- [[SEXPCOURS5.pdf|Cours]]
- [[Sexp2DeadlockExercice|Exercices]]