// The 'assignment1' program.
program assignment1.aleo {
   // Mon adresse qui va recupérer la taxe
   const ADMIN: address = aleo1yq3gpfghqt649luy6ak2wvh2crh424q83vm567mu37rhxksx75zqljdr4m;
   
   // La taxe est de 0.15%, donc 15 / 10000
   const TAX: u16 = 15u16;
   
   // Pour stocker les balances publiques
   mapping balance: address => u64;
   
   // Pour les tokens privés
   record Token {
       owner: address,
       amount: u64
   }
   
   // Mint privé - pas taxé
   transition mint_private(private receiver: address, private amount: u64) -> Token {
       assert_eq(self.caller, ADMIN);
       
       let token: Token = Token {
           owner: receiver,
           amount: amount
       };
       
       return token;
   }
   
   // Mint public - pas taxé
   async transition mint_public(public receiver: address, public amount: u64) -> Future {
       assert_eq(self.caller, ADMIN);
       
       return finalize_mint(receiver, amount);
   }
   
   async function finalize_mint(receiver: address, amount: u64) {
       let old_balance: u64 = balance.get_or_use(receiver, 0u64);
       let new_balance: u64 = old_balance + amount;
       
       balance.set(receiver, new_balance);
   }
   
   // =============== TACHE 1 ===============
   // Transfer privé avec taxe qui va dans les tokens privés de ADMIN
   transition transfer_private(
       old_token: Token,
       private receiver: address,
       private amount: u64
   ) -> (Token, Token, Token) {
       // Calcul taxe
       let tax_amount: u64 = (amount * TAX as u64) / 10000u64;
       
       // Pour le destinataire, montant - taxe
       let real_amount: u64 = amount - tax_amount;
       
       // Ce qui reste après avoir pris le montant total
       let change_amount: u64 = old_token.amount - amount;
       
       // Token pour moi (ce qui reste)
       let change_token: Token = Token {
           owner: old_token.owner,
           amount: change_amount
       };
       
       // Token pour le destinataire (montant - taxe)
       let receiver_token: Token = Token {
           owner: receiver,
           amount: real_amount
       };
       
       // La taxe va vers ADMIN
       let tax_token: Token = Token {
           owner: ADMIN,
           amount: tax_amount
       };
       
       return (change_token, receiver_token, tax_token);
   }
   
   // =============== TACHE 2 ===============
   // Transfer public avec taxe qui va dans la balance publique de ADMIN
   async transition transfer_public(public receiver: address, public amount: u64) -> Future {
       return finalize_transfer(self.caller, receiver, amount);
   }
   
   async function finalize_transfer(sender: address, receiver: address, amount: u64) {
       // Calcul taxe
       let tax_amount: u64 = (amount * TAX as u64) / 10000u64;
       
       // Pour le destinataire, montant - taxe
       let transfer_amount: u64 = amount - tax_amount;
       
       // Ajouter au destinataire
       let receiver_old_balance: u64 = balance.get_or_use(receiver, 0u64);
       let receiver_new_balance: u64 = receiver_old_balance + transfer_amount;
       balance.set(receiver, receiver_new_balance);
       
       // Retirer au sender
       let sender_old_balance: u64 = balance.get_or_use(sender, 0u64);
       let sender_new_balance: u64 = sender_old_balance - amount;
       balance.set(sender, sender_new_balance);
       
       // Ajouter la taxe à ADMIN
       let admin_old_balance: u64 = balance.get_or_use(ADMIN, 0u64);
       let admin_new_balance: u64 = admin_old_balance + tax_amount;
       balance.set(ADMIN, admin_new_balance);
   }
   
   // =============== TACHE 3 ===============
   // Transfert public -> privé avec taxe qui va dans la balance publique de ADMIN
   async transition transfer_public_to_private(
       private receiver: address,
       private amount: u64
   ) -> (Token, Future) {
       // Calcul taxe
       let tax_amount: u64 = (amount * TAX as u64) / 10000u64;
       
       // Le destinataire reçoit le montant - taxe
       let transfer_amount: u64 = amount - tax_amount;
       
       // Créer un token pour le destinataire
       let receiver_token: Token = Token {
           owner: receiver,
           amount: transfer_amount
       };
       
       // Mettre à jour les balances (enlever au sender, taxe à ADMIN)
       let transfer_future: Future = finalize_public_to_private(self.caller, amount, tax_amount);
       
       return (receiver_token, transfer_future);
   }
   
   async function finalize_public_to_private(sender: address, amount: u64, tax_amount: u64) {
       // Enlever au sender
       let sender_old_balance: u64 = balance.get_or_use(sender, 0u64);
       let sender_new_balance: u64 = sender_old_balance - amount;
       balance.set(sender, sender_new_balance);
       
       // Donner la taxe à ADMIN
       let admin_old_balance: u64 = balance.get_or_use(ADMIN, 0u64);
       let admin_new_balance: u64 = admin_old_balance + tax_amount;
       balance.set(ADMIN, admin_new_balance);
   }
   
   // =============== TACHE 4 ===============
   // Transfert privé -> public avec taxe qui va dans la balance publique de ADMIN
   async transition transfer_private_to_public(
       old_token: Token,
       private receiver: address,
       private amount: u64
   ) -> (Token, Future) {
       // Calcul taxe
       let tax_amount: u64 = (amount * TAX as u64) / 10000u64;
       
       // Le destinataire reçoit le montant - taxe
       let transfer_amount: u64 = amount - tax_amount;
       
       // Ce qui reste au sender
       let change_amount: u64 = old_token.amount - amount;
       
       // Token pour le sender
       let change_token: Token = Token {
           owner: old_token.owner,
           amount: change_amount
       };
       
       // Mettre à jour les balances publiques
       let transfer_future: Future = finalize_private_to_public(receiver, transfer_amount, tax_amount);
       
       return (change_token, transfer_future);
   }
   
   async function finalize_private_to_public(receiver: address, amount: u64, tax_amount: u64) {
       // Ajouter au destinataire
       let receiver_old_balance: u64 = balance.get_or_use(receiver, 0u64);
       let receiver_new_balance: u64 = receiver_old_balance + amount;
       balance.set(receiver, receiver_new_balance);
       
       // Donner la taxe à ADMIN
       let admin_old_balance: u64 = balance.get_or_use(ADMIN, 0u64);
       let admin_new_balance: u64 = admin_old_balance + tax_amount;
       balance.set(ADMIN, admin_new_balance);
   }
}