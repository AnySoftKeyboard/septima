load("@aspect_rules_lint//lint:buildifier.bzl", "lint_buildifier_aspect")
load("@aspect_rules_lint//lint:eslint.bzl", "lint_eslint_aspect")
load("@aspect_rules_lint//lint:ktlint.bzl", "lint_ktlint_aspect")
load("@aspect_rules_lint//lint:lint_test.bzl", "lint_test")

ktlint = lint_ktlint_aspect(
    binary = Label("@com_github_pinterest_ktlint//file"),
    editorconfig = "@@//:.editorconfig",
    baseline_file = "@@//tools/lint:baseline.xml",
)

ktlint_test = lint_test(aspect = ktlint)

eslint = lint_eslint_aspect(
    binary = "@@//tools:eslint",
    configs = ["@@//:eslint_config_bin"],
)

buildifier = lint_buildifier_aspect(
    binary = Label("@buildifier_prebuilt//:buildifier"),
)

buildifier_test = lint_test(aspect = buildifier)
