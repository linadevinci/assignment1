# assignment1

[🇬🇧 English](#english) | [🇫🇷 Français](#français)

---

<a name="english"></a>
## 🇬🇧 English

# Taxed Token Program on Aleo

### Overview
This project implements a token program on Aleo with a transaction tax feature. Each transaction incurs a 0.15% tax that is sent to an admin address. The program supports both private and public token operations, with the taxation mechanism implemented across four different transaction types.

### Features
- **Token Functionality**: Basic token operations (mint and transfer)
- **Taxation**: 0.15% tax applied to all transfers
- **Privacy Support**: Both private and public state management
- **Cross-State Operations**: Support for private-to-public and public-to-private transfers

### Implementation Details

#### Tax Mechanism
The program implements a transaction tax of 0.15%, defined as `TAX: u16 = 15u16` (15/10000). For each transfer transaction, the program:
1. Calculates the tax amount as `(amount * TAX as u64) / 10000u64`
2. Deducts the tax from the transfer amount
3. Sends the tax to the ADMIN address
4. Sends the remaining amount to the recipient

#### Task Implementations

1. **Private Transfer with Taxation** (Task 1)
   - Consumes a private record
   - Calculates the tax
   - Outputs three records: change for sender, amount for recipient, and tax for ADMIN

2. **Public Transfer with Taxation** (Task 2)
   - Updates the public balance mapping
   - Deducts the full amount from sender
   - Adds the taxed amount to recipient
   - Adds the tax to ADMIN's balance

3. **Public-to-Private Transfer with Taxation** (Task 3)
   - Deducts from sender's public balance
   - Calculates the tax
   - Creates a private record for the recipient (minus tax)
   - Adds the tax to ADMIN's public balance

4. **Private-to-Public Transfer with Taxation** (Task 4)
   - Consumes a private record
   - Calculates the tax
   - Creates a change record for the sender
   - Adds the taxed amount to recipient's public balance
   - Adds the tax to ADMIN's public balance

### Deployment
The program has been successfully deployed to the Aleo testnet with transaction ID:
`at1eny0wr98zqttz9z2d97fetnxq98vakw8tu9gf69cpzupsyag5q8qpfdz2e`

### Technical Information
- **Program ID**: `assignment1.aleo`
- **Total Variables**: 233,951
- **Total Constraints**: 176,206
- **Deployment Cost**: 17.639925 credits

### Running the Program
To test the program functionality:

```bash
# Mint private tokens
leo execute mint_private aleo1yq3gpfghqt649luy6ak2wvh2crh424q83vm567mu37rhxksx75zqljdr4m 1000u64

# Test private transfer with taxation
leo execute transfer_private "{TOKEN_RECORD}" aleo1yq3gpfghqt649luy6ak2wvh2crh424q83vm567mu37rhxksx75zqljdr4m 200u64

# Mint public tokens
leo execute mint_public aleo1yq3gpfghqt649luy6ak2wvh2crh424q83vm567mu37rhxksx75zqljdr4m 1000u64

# Test public transfer
leo execute transfer_public aleo1yq3gpfghqt649luy6ak2wvh2crh424q83vm567mu37rhxksx75zqljdr4m 200u64
```

Replace {TOKEN_RECORD} with the actual token record from a previous mint or transfer operation.

---

<a name="français"></a>
## 🇫🇷 Français


# Programme de Token avec Taxation sur Aleo

### Aperçu
Ce projet implémente un programme de jetons sur Aleo avec une fonctionnalité de taxe sur les transactions. Chaque transaction entraîne une taxe de 0,15% qui est envoyée à une adresse administrateur. Le programme prend en charge les opérations de jetons privées et publiques, avec le mécanisme de taxation implémenté sur quatre types de transactions différents.

### Fonctionnalités
- **Fonctionnalité de jeton** : Opérations de base (création et transfert)
- **Taxation** : Taxe de 0,15% appliquée à tous les transferts
- **Support de confidentialité** : Gestion d'état privée et publique
- **Opérations inter-états** : Support pour les transferts privé-vers-public et public-vers-privé

### Détails d'implémentation

#### Mécanisme de taxation
Le programme implémente une taxe de transaction de 0,15%, définie comme `TAX: u16 = 15u16` (15/10000). Pour chaque transaction de transfert, le programme :
1. Calcule le montant de la taxe avec `(amount * TAX as u64) / 10000u64`
2. Déduit la taxe du montant du transfert
3. Envoie la taxe à l'adresse ADMIN
4. Envoie le montant restant au destinataire

#### Implémentation des tâches

1. **Transfert privé avec taxation** (Tâche 1)
   - Consomme un record privé
   - Calcule la taxe
   - Produit trois records : monnaie pour l'expéditeur, montant pour le destinataire, et taxe pour ADMIN

2. **Transfert public avec taxation** (Tâche 2)
   - Met à jour le mapping de solde public
   - Déduit le montant total de l'expéditeur
   - Ajoute le montant taxé au destinataire
   - Ajoute la taxe au solde d'ADMIN

3. **Transfert public-vers-privé avec taxation** (Tâche 3)
   - Déduit du solde public de l'expéditeur
   - Calcule la taxe
   - Crée un record privé pour le destinataire (moins la taxe)
   - Ajoute la taxe au solde public d'ADMIN

4. **Transfert privé-vers-public avec taxation** (Tâche 4)
   - Consomme un record privé
   - Calcule la taxe
   - Crée un record de monnaie pour l'expéditeur
   - Ajoute le montant taxé au solde public du destinataire
   - Ajoute la taxe au solde public d'ADMIN

### Déploiement
Le programme a été déployé avec succès sur le testnet Aleo avec l'ID de transaction :
`at1eny0wr98zqttz9z2d97fetnxq98vakw8tu9gf69cpzupsyag5q8qpfdz2e`

### Informations techniques
- **ID du programme** : `assignment1.aleo`
- **Variables totales** : 233 951
- **Contraintes totales** : 176 206
- **Coût de déploiement** : 17,639925 crédits

### Exécution du programme
Pour tester les fonctionnalités du programme :

```bash
# Créer des jetons privés
leo execute mint_private aleo1yq3gpfghqt649luy6ak2wvh2crh424q83vm567mu37rhxksx75zqljdr4m 1000u64

# Tester le transfert privé avec taxation
leo execute transfer_private "{RECORD_JETON}" aleo1yq3gpfghqt649luy6ak2wvh2crh424q83vm567mu37rhxksx75zqljdr4m 200u64

# Créer des jetons publics
leo execute mint_public aleo1yq3gpfghqt649luy6ak2wvh2crh424q83vm567mu37rhxksx75zqljdr4m 1000u64

# Tester le transfert public
leo execute transfer_public aleo1yq3gpfghqt649luy6ak2wvh2crh424q83vm567mu37rhxksx75zqljdr4m 200u64
```

Remplacez {RECORD_JETON} par le record de jeton réel d'une opération précédente de création ou de transfert.


