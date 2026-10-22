# Angular Coding Style Guide

Version 1.0.2, last updated on 2026-05-19.

This document contains a general style guide for Angular projects.

It can be used by human developers as well as AI agents.

There are specific style guides for:

- [Git Commits](style-guide.git.md)
- [HTML View Templates](style-guide.html.md)
- [NPM Packages](style-guide.npm.md)
- [SCSS Styling Files](style-guide.scss.md)
- [TypeScript (Angular) Files](style-guide.ts.md)

## Do

### Must do

- run [**Prettier**](https://prettier.io/) on save and before committing
  - use config from /.prettierrc
  - use for these endings: {css,html,js,json,md,scss,ts}
- use **LF endings**
- use **UTF-8** (no BOM)

#### all Components

- Use `apps/at-app/src/assets/theme/ztv-gen-theme.scss` as the authoritative source for Angular Material styling.

### Should do

- Be consistent
- KISS (Keep It Short & Simple)
- Prefer small, clear duplication over premature abstraction. Don't force abstraction in every case.

## Component Styling

### Shared Rules

- Use shared design tokens such as `--ztv-*` for colors instead of defining raw colors in component styles.
- Keep Material colors, typography, shapes, and state styling in `ztv-gen-theme.scss`; do not redefine them in component or app-global styles.
- Use component stylesheets for layout and non-Material details, referencing theme tokens where visual styling is needed.
- If a Material style needs changing, update the generated theme using its Sass override API rather than adding a local selector or custom property override.
- Define each visual state once. Avoid duplicate selectors and conflicting declarations; use `!important` only when a library's specificity requires it.
- Keep foreground, background, icon, and overlay colors coherent across hover, focus, selected, and disabled states.
- Preserve visible keyboard focus. Do not remove focus indicators or neutralize focus layers as a side effect of changing hover styling.
- When a library component adds a state-layer overlay, use its supported CSS custom property at the narrowest scope needed.

### Buttons

- Style all Buttons within the application the same way
- Use the button shape and state colors supplied by `ztv-gen-theme.scss`; do not set button colors, radii, or Material tokens in component SCSS.
- Use the shared button theme and styles for a given button variant. Add an explicit variant when a button has a distinct semantic purpose instead of adding local overrides.
- Apply state colors to the full button surface, including its label and icons, so hover or selected styles do not leave contrasting edges.
- Keep hover, focus, active, disabled, and selected behavior intentional and consistent across buttons of the same variant.

### Compound Components

- Give the owning interactive surface responsibility for its selected state; nested controls should inherit that state when they represent the same action.
- Avoid competing background, text, or state-layer rules between a container and its nested button or icon.
- Scope library overrides to the affected component and state rather than changing library behavior globally.

### Navigation

- Represent the selected route with Material's `activated` state and let `ztv-gen-theme.scss` provide its appearance.
- Define Material list-item hover and focus colors in `ztv-gen-theme.scss`, not in the navigation component stylesheet.
- Keep navigation-specific responsive overrides in the established 900px and 560px breakpoints, and change only the properties needed at each breakpoint.

## Don't

- Don't override or redeclare Angular Material tokens or state colors in component stylesheets or app-global styles.
- Don't commit AI slop. Always review and edit AI-generated code before committing it!

## Resources

- [Prettier](https://prettier.io/)

## ToDos

- @ToDo Add style guide for unit (Vitest), e2e (Playwright) tests and maybe Storybook.
- @ToDo Add detailed accessibility checklist for AXE, WCAG AA, focus management, color contrast, labels, ARIA, and dialogs.
