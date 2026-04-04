load("@aspect_rules_lint//lint:ktlint.bzl", "lint_ktlint_aspect")
# load("@aspect_rules_lint//lint:eslint.bzl", "lint_eslint_aspect")

ktlint = lint_ktlint_aspect(
    binary = Label("//tools/lint:ktlint_sh_binary"),
    editorconfig = Label("//:.editorconfig"),
    baseline_file = Label("//tools/lint:baseline.xml"),
    ruleset_jar = Label("//:ktlint_jar_alias"),
)

# eslint = lint_eslint_aspect(
#     binary = Label("//tools/lint:eslint"),
#     configs = [
#         Label("//:eslint.config.mjs"),
#         Label("//:package.json"),
#     ],
# )
