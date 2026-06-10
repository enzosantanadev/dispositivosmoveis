# 🔥 Como configurar o Firebase no projeto

## Pré-requisitos
- Conta Google (institucional @souunit.com.br ou pessoal para gerenciar o projeto)
- Flutter instalado e funcionando

---

## Passo 1 — Criar projeto no Firebase Console
1. Acesse https://console.firebase.google.com
2. Clique em **"Criar um projeto"**
3. Nome sugerido: `MemoryBox`
4. Ative o Google Analytics (opcional)

---

## Passo 2 — Adicionar app Android
1. No console, clique no ícone Android (🤖)
2. **Package name:** `com.example.memorybox`
   (verifique em `android/app/build.gradle` → `applicationId`)
3. Clique em **"Registrar app"**
4. Baixe o arquivo **`google-services.json`**
5. Cole dentro da pasta: `android/app/google-services.json`

---

## Passo 3 — Ativar autenticação
1. No Firebase Console → **Authentication** → **Sign-in method**
2. Ative **E-mail/Senha**
3. Ative **Google**
   - Para Google Sign-In, você precisará do SHA-1 do seu computador:
   ```
   cd android
   ./gradlew signingReport
   ```
   Copie o SHA-1 e cole em: Firebase Console → Configurações do projeto → Seus apps Android → Adicionar impressão digital

---

## Passo 4 — Criar banco Firestore
1. No Firebase Console → **Firestore Database** → **Criar banco de dados**
2. Escolha **Modo de produção**
3. Selecione localização: `southamerica-east1` (São Paulo)

### Regras de segurança do Firestore
Cole isso em **Regras** do Firestore:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Cada usuário só acessa seus próprios dados
    match /users/{userEmail}/{document=**} {
      allow read, write: if request.auth != null
        && request.auth.token.email == userEmail
        && request.auth.token.email.matches('.*@souunit\\.com\\.br');
    }
  }
}
```

---

## Passo 5 — Configurar android/build.gradle
Verifique se o arquivo `android/build.gradle` tem:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.2'
    }
}
```

E `android/app/build.gradle` tem no final:
```gradle
apply plugin: 'com.google.gms.google-services'
```

---

## Passo 6 — Rodar o projeto
```bash
flutter pub get
flutter run
```

---

## Estrutura dos dados no Firestore
```
users/
  {email_do_usuario}/
    categories/
      {id}/
        name: "Família"
        color: 4294932640
        icon: "favorite"
        criado_por: "aluno@souunit.com.br"
        atualizado_em: Timestamp
    memories/
      {id}/
        title: "Viagem ao nordeste"
        description: "..."
        date: Timestamp
        category_ids: ["id1", "id2"]
        criado_por: "aluno@souunit.com.br"
        criado_em: Timestamp
```
