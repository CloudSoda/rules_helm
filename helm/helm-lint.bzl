load("//helpers:helpers.bzl", "write_sh")

def _helm_lint_test_impl(ctx):
    """Lint a helm chart"""

    helm3_binary = ctx.toolchains["@com_github_masmovil_bazel_rules//toolchains/helm-3:toolchain_type"].helminfo.tool.files.to_list()
    helm3_path = helm3_binary[0].path
    chart = ctx.file.chart
    chart_path = ctx.file.chart.short_path
    package_name = ctx.attr.package_name

    # Generates the exec bash file with the provided substitutions
    exec_file = write_sh(
      ctx,
      "helm_lint_test",
      """
        tar --touch -xf {CHART_PATH}
        {HELM3_PATH} lint {PACKAGE_NAME}
      """,
      {
        "{CHART_PATH}": chart_path,
        "{HELM3_PATH}": helm3_path,
        "{PACKAGE_NAME}": package_name,
      }
    )

    runfiles = ctx.runfiles(files = [chart] + helm3_binary )

    return [DefaultInfo(
      executable = exec_file,
      runfiles = runfiles,
    )]

helm_lint_test = rule(
    implementation = _helm_lint_test_impl,
    attrs = {
      "chart": attr.label(allow_single_file = True, mandatory = True),
      "package_name": attr.string(mandatory = True),
    },
    doc = "Lint helm chart",
    test = True,
    toolchains = [
      "@com_github_masmovil_bazel_rules//toolchains/helm-3:toolchain_type",
    ],
)
