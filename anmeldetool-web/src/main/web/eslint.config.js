// @ts-check
const eslint = require("@eslint/js");
const tseslint = require("typescript-eslint");
const angular = require("@angular-eslint/eslint-plugin");
const angularTemplate = require("@angular-eslint/eslint-plugin-template");
const eslintConfigPrettier = require("eslint-config-prettier");
const { FlatCompat } = require("@eslint/eslintrc");
const path = require("path");

const compat = new FlatCompat({
	baseDirectory: __dirname,
	recommendedConfig: eslint.configs.recommended,
});

module.exports = tseslint.config(
	{
		ignores: [".angular/**", ".nx/**", "coverage/**", "dist/**"],
	},
	{
		files: ["**/*.ts"],
		extends: [
			eslint.configs.recommended,
			...tseslint.configs.recommended,
			...tseslint.configs.stylistic,
			eslintConfigPrettier,
		],
		languageOptions: {
			parser: tseslint.parser,
			parserOptions: {
				project: true,
			},
		},
		plugins: {
			"@angular-eslint": angular,
			"@typescript-eslint": tseslint.plugin,
		},
		rules: {
			"@angular-eslint/directive-selector": [
				"error",
				{
					type: "attribute",
					prefix: "lxt",
					style: "camelCase",
				},
			],
			"@angular-eslint/component-selector": [
				"error",
				{
					type: ["attribute", "element"],
					prefix: "lxt",
					style: "kebab-case",
				},
			],
			// Angular best practices
			"@angular-eslint/no-empty-lifecycle-method": "warn",
			"@angular-eslint/prefer-on-push-component-change-detection": "off", // should be turned on, off for learning!
			// TypeScript best practices
			"@typescript-eslint/array-type": ["warn"],
			"@typescript-eslint/consistent-indexed-object-style": "off",
			"@typescript-eslint/consistent-type-assertions": "warn",
			"@typescript-eslint/consistent-type-definitions": ["warn", "type"],
			"@typescript-eslint/explicit-function-return-type": "error",
			"@typescript-eslint/explicit-member-accessibility": [
				"error",
				{
					accessibility: "no-public",
				},
			],
			"@typescript-eslint/naming-convention": [
				"warn",
				{
					selector: "variable",
					format: ["camelCase", "UPPER_CASE", "PascalCase"],
				},
			],
			"@typescript-eslint/no-empty-function": "warn",
			"@typescript-eslint/no-empty-interface": "error",
			"@typescript-eslint/no-explicit-any": "warn",
			"@typescript-eslint/no-inferrable-types": "warn",
			"@typescript-eslint/no-shadow": "warn",
			"@typescript-eslint/no-unused-vars": "warn",
			// JavaScript best practices
			eqeqeq: "error",
			complexity: ["error", 20],
			curly: "error",
			"guard-for-in": "error",
			"max-classes-per-file": ["error", 1],
			"max-len": [
				"warn",
				{
					code: 120,
					comments: 160,
				},
			],
			"max-lines": ["error", 1200], //ToDo: set to 400 after!
			"no-bitwise": "error",
			"no-console": "off", // should be turned on, off for debugging!
			"no-new-wrappers": "error",
			"no-useless-concat": "error",
			"no-var": "error",
			"no-restricted-syntax": "off",
			"no-shadow": "error",
			"one-var": ["error", "never"],
			"prefer-arrow-callback": "error",
			"prefer-const": "error",
			"sort-imports": [
				"error",
				{
					ignoreCase: true,
					ignoreDeclarationSort: true,
					allowSeparatedGroups: true,
				},
			],
			// Security
			"no-eval": "error",
			"no-implied-eval": "error",
		},
	},
);
