package(default_visibility = ["//visibility:public"])

load("//helm:helm.bzl", "helm_chart", "helm_lint_test")

helm_chart(
  name = "nginx_chart",
  srcs = glob(["**"]),
  image_tag  = "latest",
  image_repository  = "nginx",
  helm_chart_version = "1.0.0",
  package_name = "nginx",
  values_tag_yaml_path = "image.tag",
  values_repo_yaml_path = "image.repository"
)

helm_lint_test(
  name = "nginx_lint",
  chart = "nginx_chart",
  package_name = "nginx",
)
