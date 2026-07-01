# PROJECT KNOWLEDGE BASE

**Generated:** 2026-05-22
**Commit:** 01d5b60
**Branch:** main

## OVERVIEW

ZTV_GETU_Anmeldetool — registration tool for gymnastics competitions (Geraeteturn-Wettkampfe) of the Zuercher Turnverband. Spring Boot 3.5.9 backend (Java 21) + Angular 14 frontend (Nx 16, NgRx). Multi-module Maven project with monolithic packaging (frontend baked into backend JAR).

## STRUCTURE

```
./
├── anmeldetool-server/   # Spring Boot backend (see anmeldetool-server/AGENTS.md)
├── anmeldetool-web/      # Angular frontend Maven wrapper
│   └── src/main/web/     # Actual Nx workspace root (run npm/nx here)
│       └── src/app/      # Angular app (see src/app/AGENTS.md)
├── docker/               # Dev docker-compose (v3.9) + Dockerfiles
├── docker-prod/          # Prod docker-compose (v2) + Dockerfiles
├── helm/                 # Kubernetes Helm chart (templates/)
├── db_backup/            # SQL dump backups (contains sensitive data)
├── bedienung/            # User manual / documentation images
├── pom.xml               # Parent POM (modules: anmeldetool-web, anmeldetool-server)
├── CLAUDE.md             # Additional agent context
└── AGENTS.md             # This file
```

## WHERE TO LOOK

| Task                 | Location                               | Notes                                                    |
| -------------------- | -------------------------------------- | -------------------------------------------------------- |
| Add REST endpoint    | `anmeldetool-server/.../controller/`   | Check `ZTVSecurityConfig` for auth                       |
| Add business logic   | `anmeldetool-server/.../service/`      | `@RequiredArgsConstructor` + `private final`             |
| Add/modify entity    | `anmeldetool-server/.../models/`       | Extend `Base`, add Flyway migration, update mapper       |
| Add DTO field        | `anmeldetool-server/.../transfer/`     | Update MapStruct mapper in `util/`                       |
| Add Flyway migration | `anmeldetool-server/.../db/migration/` | Format: `V<TIMESTAMP>__<description>.sql`                |
| Add frontend feature | `anmeldetool-web/.../src/app/`         | Feature dirs: `verein/`, `events/`, `event-admin/`       |
| Add NgRx state       | `anmeldetool-web/.../core/redux/`      | Per-feature: actions, reducer, effects, selectors, state |
| Add frontend service | `anmeldetool-web/.../core/service/`    | Extend `ServiceHelper`, use `catchError`                 |
| Modify security/auth | `.../config/ZTVSecurityConfig.java`    | + `LoginService`, `ZtvUserDetailService`                 |
| Docker dev           | `docker/docker-compose.yml`            | backend:8088, app:80, pgadmin:5050                       |
| Docker prod          | `docker-prod/docker-compose.yml`       | Different compose version and image refs                 |
| K8s deploy           | `helm/`                                | Helm chart with HTTPRoute (Gateway API)                  |

## COMMANDS

```bash
# Full build (backend + frontend)
mvn clean install

# Backend only
cd anmeldetool-server && mvn spring-boot:run
cd anmeldetool-server && mvn test
cd anmeldetool-server && mvn test -Dtest=ClassName

# Frontend (MUST run from Nx workspace root)
cd anmeldetool-web/src/main/web
nx serve at-app --configuration=development
nx test at-app
nx lint at-app
nx build at-app
nx run at-app:build:halle          # Halle profile

# Maven frontend profiles (from repo root)
mvn clean package -Denv=halle       # Build with halle environment
mvn clean package -Denv=development # Build with dev environment

# Docker (dev)
docker-compose -f docker/docker-compose.yml up --build
```

## CONVENTIONS

### General

- **Indentation:** 2 spaces everywhere (Java, TS, HTML, CSS, XML, JSON)
- **Line Endings:** LF. **Charset:** UTF-8
- **EditorConfig:** `anmeldetool-web/src/main/web/.editorconfig`

### Backend (Java 21, Spring Boot 3.5.9)

- **DI:** `@RequiredArgsConstructor` + `private final` fields. Avoid `@Autowired` (exception: MapStruct abstract mappers)
- **Logging:** `@Slf4j` (Lombok)
- **DTOs:** suffix `DTO` (e.g., `PersonDTO`)
- **Mapping:** MapStruct `componentModel = SPRING`. Mappers in `util/`. FromId mappers in `util/idmapper/` use `@ObjectFactory` + repo lookup
- **Entities:** extend `Base` (UUID id, auditing). N:M with extra fields use link entities (e.g., `OrganisationPersonLink`)
- **Errors:** `NotFoundException` (404), `ServiceException` (400). Global: `RestExceptionHandler` (`@ControllerAdvice`)
- **API:** `@RestController` + `@RequestMapping`. Return `ResponseEntity`

### Frontend (Angular 14, TypeScript 4.7, Nx 16)

- **Interfaces:** prefix `I` (e.g., `IAnlass`, `IVerein`)
- **Files:** `kebab-case.component.ts`
- **Services:** extend `ServiceHelper` for centralized error handling
- **State:** NgRx with per-feature stores under `core/redux/`. Uses `createActionGroup`, `createFeature`, `EntityAdapter`
- **Action naming:** `"Load All Anlaesse INVOKED"` / `SUCCESS` / `ERROR`
- **Lint:** TSLint (legacy `tslint.json`). No ESLint config present in repo.
- **Styling:** Bootstrap 5 + Angular Material
- **Imports:** relative within module, absolute (`src/app/...`) for core/shared

## ANTI-PATTERNS (THIS PROJECT)

- **DO NOT** suppress types with `as any`, `@ts-ignore`, `@ts-expect-error`
- **DO NOT** use `@Autowired` on non-abstract classes — use `@RequiredArgsConstructor`
- **DO NOT** commit secrets — `docker/docker_secrets.properties` and `db_backup/` contain sensitive data
- **DO NOT** add endpoints without checking `ZTVSecurityConfig`
- **NEVER** delete Flyway migrations — only add new ones
- **ALWAYS** run `mvn test` or `nx test` after modifications
- **ALWAYS** update MapStruct mapper in `util/` when adding fields to Entity/DTO
- **ALWAYS** add Flyway migration when changing entities

## NOTES

- Frontend workspace nested at `anmeldetool-web/src/main/web/` — all nx/npm commands must run there
- Frontend dist copied into backend JAR via `maven-resources-plugin` (monolithic packaging)
- Maven profiles activated via property (`-Denv=halle`) not flag (`-P`)
- Context path `/`, management endpoints at `/admin`
- `application.yml` defaults to `prod` profile — override with `--spring.profiles.active=local` for dev
- PostgreSQL for all environments (test uses PostgreSQL mode in H2 container for compatibility)
- No CI pipeline in repo — builds done externally
- Docker dev: `docker/docker-compose.yml` (v3.9); prod: `docker-prod/docker-compose.yml` (v2)
- `nx.json` contains an `accessToken` field — treat as secret
- BCrypt encoder configured; `ZTVSecurityConfig` defines public endpoints (`/timetable/**`, `/health`, `/actuator/**`)
- Actuator health at `/admin/health` (management.server.base-path: /admin)
- Many TODOs: incomplete Redux migration, missing tests, JSESSIONID logging in interceptor

**Generated:** 2026-05-22
**Commit:** 01d5b60
**Branch:** main

## HIERARCHY

```
./AGENTS.md                                         # This file (root)
├── anmeldetool-server/AGENTS.md                    # Backend: domain model, services, controllers
└── anmeldetool-web/src/main/web/src/app/AGENTS.md  # Frontend: modules, components, NgRx stores
    └── core/AGENTS.md                              # Core: NgRx store, services, interceptors
```
