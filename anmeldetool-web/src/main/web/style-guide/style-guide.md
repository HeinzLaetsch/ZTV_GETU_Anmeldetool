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

- Use `var(--ztv-blue)` backgrounds with `var(--ztv-white)` text selected states.
- Use `var(--ztv-dark-blue)` backgrounds with `var(--ztv-light-gray)` text hover states.
- Use `var(--ztv-lighter-blue)` for the background and `var(--ztv-gray)` for the text disabled states.
- Use `var(--ztv-lighter-gray)` for the background and `--ztv-dark-gray` for the text for all other states.

### Should do

- Be consistent
- KISS (Keep It Short & Simple)
- Prefer small, clear duplication over premature abstraction. Don't force abstraction in every case.

## Component Styling

### Shared Rules

- Use shared design tokens such as `--ztv-*` for colors instead of defining raw colors in component styles.
- Keep application-wide theme defaults and shared tokens in global styles; keep component-specific layout and state styles in the component stylesheet.
- Define each visual state once. Avoid duplicate selectors and conflicting declarations; use `!important` only when a library's specificity requires it.
- Keep foreground, background, icon, and overlay colors coherent across hover, focus, selected, and disabled states.
- Preserve visible keyboard focus. Do not remove focus indicators or neutralize focus layers as a side effect of changing hover styling.
- When a library component adds a state-layer overlay, use its supported CSS custom property at the narrowest scope needed.

### Buttons

- Style all Buttons within the application the same way
- Use a consistent `0.6rem` border radius for buttons, matching the navigation list items.
- In the default state (enabled, unselected, and not hovered), buttons should match a Material list item: use its container and label color tokens.
- Use the shared button theme and styles for a given button variant. Add an explicit variant when a button has a distinct semantic purpose instead of introducing ad hoc overrides.
- Apply state colors to the full button surface, including its label and icons, so hover or selected styles do not leave contrasting edges.
- Keep hover, focus, active, disabled, and selected behavior intentional and consistent across buttons of the same variant.

### Compound Components

- Give the owning interactive surface responsibility for its selected state; nested controls should inherit that state when they represent the same action.
- Avoid competing background, text, or state-layer rules between a container and its nested button or icon.
- Scope library overrides to the affected component and state rather than changing library behavior globally.

### Navigation

- When a navigation button is inside an active list item, let the button inherit the active item's colors rather than repeating the same declarations.
- For Material list-item hover states, set `--mat-list-list-item-hover-state-layer-color` to `transparent` on the hovered item when the default overlay creates a contrasting edge. Keep keyboard-focus styling distinct and visible.
- Keep navigation-specific responsive overrides in the established 900px and 560px breakpoints, and change only the properties needed at each breakpoint.

## Don't

- Don't commit AI slop. Always review and edit AI-generated code before committing it!

## Resources

- [Prettier](https://prettier.io/)

## ToDos

- @ToDo Add style guide for unit (Vitest), e2e (Playwright) tests and maybe Storybook.
- @ToDo Add detailed accessibility checklist for AXE, WCAG AA, focus management, color contrast, labels, ARIA, and dialogs.
