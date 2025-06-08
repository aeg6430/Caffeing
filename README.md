# Caffeing

Explore cafes with Caffeing

---

## 🏗️ Projects

### 📱 Mobile App (Flutter)
- Located at: `apps/mobile`
- Built with Flutter
- Features:
  - Firebase Authentication (Google Sign-In)
  - Google Maps integration with clustering
  - Authenticated users can save favorite stores remotely
  - Launch navigation to selected store in Google Maps
  - Persistent bottom navigation
  - Multi-language support (EN, ZH, JP, KO)
  - Theming (dark/light)
  - Firebase Cloud Functions and GitHub integration for submitting bug reports directly

- Architecture:
  - MVVM pattern with ChangeNotifier
  - Clean code practices and modular design

### 🌐 Frontend (Nuxt)
- Located at: `apps/frontend`
- Built with Nuxt + Tailwind CSS
- Features:
  - Public-facing website
  - Coffee store recommendation form
  - Multi-language support (EN, ZH, JP, KO) with i18n-based SEO optimization
  - Protected using **Cloudflare Turnstile**

### ⚙️ Backend (ASP.NET Core)
- Located at: `apps/backend`
- Built with ASP.NET Core (.NET 8)
- Features:
  - RESTful APIs
  - Firebase Admin SDK for auth
  - Dapper-based database access
  - Supports **PostgreSQL**, **SQL Server**, and **MySQL** (configurable)
  - Serilog logging
  - Swagger UI for API docs
  - Encapsulated database transactions via [`TransactionContext`](https://github.com/aeg6430/Caffeing/blob/main/apps/backend/Caffeing.Infrastructure/Contexts/TransactionContext.cs)
- Provides an intake service for:
  - Collecting form submissions
  - Sending data to the Keystone public API (can be modified to use other endpoints)

- Architecture:
  - Layered structure: WebAPI, Application, Infrastructure, and Domain
  - Repository pattern for data access abstraction

### ☁️ Infrastructure / Deployment

- Uses Google Cloud Platform (GCP) for hosting and services:
  - Firebase for Authentication, Cloud Functions, and Firestore (bug reports)
  - Cloud Run for backend deployment
  - Cloud SQL for relational database (PostgreSQL / MySQL / SQL Server)
  - Cloud Load Balancer for routing to services

---

## 🛠️ Setup

### ✅ Prerequisites
- Flutter SDK
- .NET 8 SDK
- PostgreSQL / SQL Server / MySQL
- Firebase project & credentials
- Google Maps API key (for mobile map features)
- Cloudflare Turnstile site key (for frontend form protection)

> **Note**: Some critical configuration files (e.g., Firebase credentials, API keys, full `appsettings.json`, `.env` files) are intentionally excluded via `.gitignore`.  
> Copy from the provided example files (`appsettings.example.json`, `.env.example`, etc.) and fill in your own values to run the project locally.

> **Security Note**: This project integrates with Firebase and Google Maps. Always keep your API keys and service credentials secure. Never commit real credentials or secrets to version control.

---

## 🚀 Roadmap

* **Deep Linking Support for Store Pages:** Enable sharable links (`https://caffeing.com/store/{storeId}`) that directly open specific coffee store pages within the app. Upon opening, the app will display the store's details, including its location on the integrated map, just as if it were selected from a search result.
    * *Status: In progress, pending backend API endpoint implementation for retrieving store details by ID.*
* **Advanced Search with Full i18n Support:** Enhance the search functionality to include more advanced filtering options, with all search parameters and results fully localized for all supported languages (EN, ZH, JP, KO).
* **Store Details with Full i18n Support:** Ensure all store details (e.g., name, description, address, amenities) are fully localized and displayed correctly in all supported languages (EN, ZH, JP, KO).

---

## ⚖️ Licenses

This project is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International License](https://creativecommons.org/licenses/by-nc/4.0/).

> You are free to use, share, or adapt this work **for non-commercial purposes only**, with proper attribution.
>
> See the full terms in the [LICENSE](./LICENSE.md).

---

### 🤝 Third-Party Licenses

This project uses third-party dependencies. For licensing details of these components, see [THIRD_PARTY_LICENSES](./THIRD_PARTY_LICENSES.md).