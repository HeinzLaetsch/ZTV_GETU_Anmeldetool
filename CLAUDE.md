# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ZTV_GETU_Anmeldetool is a registration tool for gymnastics competitions (Geräteturn-Wettkämpfe) of the ZTV (Zürcher Turnverband). It's a multi-module Maven project with a Spring Boot backend and Angular frontend.

**Modules:**
- `anmeldetool-server`: Spring Boot 3.5.9 backend (Java 21, JPA, Security)
- `anmeldetool-web`: Angular 14 frontend built with Nx monorepo

## Build & Run Commands

**Full build (backend + frontend):**
```bash
mvn clean install
```

**Run backend:**
```bash
cd anmeldetool-server
mvn spring-boot:run
```

**Run frontend dev server:**
```bash
cd anmeldetool-web/src/main/web
nx serve at-app --configuration=development --live-reload
```

**Build frontend only (alternative profiles):**
```bash
nx build                    # Default production
nx run at-app:build:halle  # Halle profile
```

**Run tests:**
```bash
mvn test                           # Backend tests
cd anmeldetool-web/src/main/web && nx test  # Frontend tests
```

**Run single backend test:**
```bash
cd anmeldetool-server
mvn test -Dtest=ClassName
```

## Architecture

### Backend (Spring Boot)

**Package Structure:**
- `config/` - Spring Security (ZTVSecurityConfig), Mail, Scheduler configuration
- `controller/` - REST endpoints (AdminController, AnlassAdminController, etc.)
- `service/` - Business logic (PersonService, TeilnehmerService, WertungsrichterService, etc.)
- `repositories/` - Spring Data JPA repositories
- `models/` - JPA entities (Base, Person, Organisation, Anlass, Teilnehmer, etc.)
- `transfer/` - DTOs (PersonDTO, OrganisationDTO, etc.)
- `util/` - MapStruct mappers for Entity ↔ DTO conversion
- `security/` - Custom security components

**Request Flow:**
```
Controller → Service → Repository → JPA Entity
              ↓
         Mapper (Entity → DTO)
```

**Key Domain Entities:**
- `Base`: Abstract base class with ID and auditing fields
- `Person`: User account with username, password, email
- `Organisation`: Club/organization linked to Person via `OrganisationPersonLink`
- `Verband`: Parent association for organizations
- `Anlass`: Competition/event with metadata
- `Teilnehmer`, `TeilnehmerAnlassLink`: Participants and their event registrations
- `Wertungsrichter`: Judges with availability and scheduling
- Link entities (`OrganisationPersonLink`, `OrganisationAnlassLink`) model n:m relationships with additional fields

**Security:**
- BCrypt password encoding
- Stateless sessions, CSRF disabled
- Public endpoints: `/timetable/**`, `/health`, `/actuator/**`
- All other endpoints require authentication
- LoginService validates domain rules (person exists, organization exists, person is member) and sets SecurityContext

**Database:**
- PostgreSQL with Flyway migrations in `src/main/resources/db/migration/`
- Active profile defaults to `prod` in `application.yml`

### Frontend (Angular + Nx)

**App Structure (`src/main/web/src/app/`):**
- `core/` - Core services, models, Redux (@ngrx/store)
- `shared/` - Shared components
- `verein/` - Club/organization views
- `events/` - Event management
- `event-admin/` - Event administration
- `rechnungsbuero/` - Billing office
- `smquali/` - SM qualification views

**State Management:** NgRx with effects for async operations

## Development Profiles

The web module supports build profiles:
- Default: `nx build`
- `halle`: `nx run at-app:build:halle` (sets environment-specific config)
- `development`: `nx run at-app:build:development`

## Key Patterns & Notes

**MapStruct with Lombok:**
When adding new mappers, include both `mapstruct-processor` and `lombok-mapstruct-binding` in annotationProcessorPaths (see server pom.xml).

**Security Context:**
LoginService currently builds Authentication tokens but AuthenticationManager usage is commented out. When modifying authentication, be aware of this pattern.

**Many-to-Many with Additional Fields:**
Use link entities (e.g., `OrganisationPersonLink`) instead of direct `@ManyToMany` when the relationship needs extra fields like roles.

**CSV/PDF Export:**
Specialized mappers in `util/` package handle CSV import/export (e.g., `TeilnehmerAnlassLinkExportImportMapper`).