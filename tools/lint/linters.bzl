load("@aspect_rules_lint//lint:eslint.bzl", "lint_eslint_aspect")
load("@aspect_rules_lint//lint:ktlint.bzl", "lint_ktlint_aspect")

ktlint = lint_ktlint_aspect(
    binary = "@@//tools/format:ktlint",
    editorconfig = "@@//:editorconfig_bin",
)

eslint = lint_eslint_aspect(
    binary = "@@//tools/lint:eslint",
    configs = ["@@//:eslint_config"],
)
