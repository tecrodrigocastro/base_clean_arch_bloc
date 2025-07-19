# Base Clean Architecture + BLoC

Um projeto base Flutter implementando Clean Architecture com BLoC para gerenciamento de estado, seguindo os princípios de SOLID e separação de responsabilidades.

## 🏗️ Arquitetura

Este projeto segue a **Clean Architecture** de Robert C. Martin, organizando o código em camadas bem definidas que promovem testabilidade, manutenibilidade e independência de frameworks.

> 🤖 **AI-Ready Documentation**: Para desenvolvimento assistido por IA (Claude, Cursor), consulte o [**Guia de Arquitetura AI-Ready**](docs/ARCHITECTURE.md) que contém instruções detalhadas, templates e padrões para implementação de features seguindo a arquitetura estabelecida.

### 📁 Estrutura do Projeto

```
lib/
├── src/
│   ├── app/
│   │   └── features/           # Módulos/Features da aplicação
│   │       └── auth/           # Feature de autenticação
│   │           ├── data/       # Camada de dados
│   │           │   ├── datasources/
│   │           │   ├── models/
│   │           │   └── repositories/
│   │           ├── domain/     # Camada de domínio (regras de negócio)
│   │           │   ├── entities/
│   │           │   ├── repositories/
│   │           │   └── usecases/
│   │           ├── infrastructure/  # Infraestrutura específica
│   │           └── presentation/    # Camada de apresentação
│   │               ├── bloc/   # Gerenciamento de estado com BLoC
│   │               ├── pages/  # Telas
│   │               └── widgets/ # Widgets reutilizáveis
│   └── core/                   # Funcionalidades compartilhadas
│       ├── DI/                 # Injeção de dependência
│       ├── cache/              # Sistema de cache
│       ├── client_http/        # Cliente HTTP com interceptors
│       ├── errors/             # Tratamento de erros
│       ├── extensions/         # Extensões
│       ├── interfaces/         # Contratos/Interfaces
│       ├── services/           # Serviços globais
│       └── utils/              # Utilitários
├── app_widget.dart             # Widget principal da aplicação
├── main.dart                   # Ponto de entrada
└── routes.dart                 # Configuração de rotas
```

### 🎯 Camadas da Clean Architecture

#### 1. **Domain Layer (Domínio)**
- **Entities**: Objetos de negócio fundamentais
- **Use Cases**: Casos de uso que implementam regras de negócio
- **Repository Interfaces**: Contratos para acesso a dados
- **Não depende de nenhuma outra camada**

#### 2. **Data Layer (Dados)**
- **Models**: Implementações das entidades para serialização
- **Repositories**: Implementações concretas dos contratos do domínio
- **Data Sources**: Fontes de dados (API, local storage, etc.)
- **Depende apenas da camada de domínio**

#### 3. **Presentation Layer (Apresentação)**
- **BLoC**: Gerenciamento de estado e lógica de apresentação
- **Pages**: Telas da aplicação
- **Widgets**: Componentes de UI reutilizáveis
- **Depende da camada de domínio para use cases**

#### 4. **Infrastructure Layer (Infraestrutura)**
- **Interceptors**: Middleware para requisições HTTP
- **External Services**: Integrações com serviços externos
- **Framework-specific implementations**

### 🔄 Fluxo de Dados

```
UI → BLoC → Use Case → Repository → Data Source → External API/Local Storage
```

## 📦 Dependências Principais

### **Estado e Arquitetura**
- `flutter_bloc: ^9.1.1` - Gerenciamento de estado reativo
- `get_it: ^8.0.3` - Injeção de dependência e service locator
- `equatable: ^2.0.7` - Comparação de objetos para BLoC

### **Navegação**
- `go_router: ^15.1.2` - Roteamento declarativo e type-safe

### **Networking**
- `dio: ^5.8.0+1` - Cliente HTTP com interceptors
- `logger: ^2.6.0` - Sistema de logs estruturado

### **Cache e Persistência**
- `shared_preferences: ^2.5.3` - Armazenamento local de preferências

### **Utilitários**
- `result_dart: ^2.1.1` - Handling de resultados com Either/Result pattern
- `lucid_validation: ^1.3.1` - Validação de dados
- `intl: ^0.20.2` - Internacionalização e formatação

### **UI/UX**
- `gap: ^3.0.1` - Espaçamento responsivo
- `shimmer: ^3.0.0` - Efeitos de loading

## 🚀 Principais Funcionalidades

### **Sistema de Cache**
- Interface abstraída para diferentes tipos de cache
- Implementação com SharedPreferences
- Tratamento de exceções específicas
- Parâmetros configuráveis para TTL

### **Cliente HTTP Robusto**
- Baseado em Dio com interceptors customizáveis
- Logging automático de requisições/respostas
- Tratamento centralizado de erros HTTP
- Suporte a multipart/form-data
- Interceptor de autenticação integrado

### **Gerenciamento de Estado**
- BLoC pattern para estado reativo
- Events e States tipados
- Separação clara entre lógica de negócio e UI

### **Injeção de Dependência**
- Service Locator pattern com GetIt
- Registro centralizado de dependências
- Facilita testes unitários e de integração

### **Tratamento de Erros**
- Hierarquia de exceções customizadas
- Mapeamento de erros HTTP para exceções de domínio
- Propagação controlada de erros entre camadas

### **Serviços Core**
- **SessionService**: Gerenciamento de sessão de usuário
- **Cache System**: Abstração para diferentes tipos de cache
- **HTTP Client**: Cliente configurado com interceptors

## 🧪 Testes

O projeto possui **cobertura abrangente de testes** com **114+ testes implementados**:

### **Implementados ✅**
- **Unit Tests**: Entidades, DTOs, Use Cases, Repositories, DataSources
- **Widget Tests**: Páginas e componentes de UI com interações
- **BLoC Tests**: Verificação completa de estados, events e transições
- **Integration Tests**: Fluxos de dados entre camadas

### **Features Testadas**
- 🔐 **Auth Feature**: Cobertura completa com testes em todas as camadas
- ✅ **114 testes passando** com alta qualidade e robustez
- 🎯 **Testes de igualdade** implementados com Equatable
- 🧪 **Mocks e simulações** para isolamento de dependências

### **Executar Testes**
```bash
# Executar todos os testes
flutter test

# Executar testes específicos
flutter test test/unit/
flutter test test/widget/
flutter test test/integration/
```

## 🔧 Configuração e Execução

### Pré-requisitos
- Flutter SDK ^3.5.1
- Dart SDK compatível

### Instalação
```bash
# Clone o repositório
git clone https://github.com/tecrodrigocastro/base_clean_arch_bloc.git

# Instale as dependências
flutter pub get

# Execute o projeto
flutter run
```

### Build
```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

## 📋 Próximos Passos

- [x] Implementar documentação AI-ready para desenvolvimento assistido
- [x] Implementar testes abrangentes (unit, widget, integration)
- [x] Estrutura completa de Clean Architecture com BLoC
- [ ] Configurar CI/CD pipeline
- [ ] Documentação de APIs
- [ ] Implementar cache com estratégias avançadas
- [ ] Adicionar suporte offline

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Add: nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
