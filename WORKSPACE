workspace(name = "com_github_masmovil_bazel_rules")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "aspect_bazel_lib",
    sha256 = "79623d656aa23ad3fd4692ab99786c613cd36e49f5566469ed97bc9b4c655f03",
    strip_prefix = "bazel-lib-1.23.3",
    url = "https://github.com/aspect-build/bazel-lib/archive/refs/tags/v1.23.3.tar.gz",
)

load("@aspect_bazel_lib//lib:repositories.bzl", "aspect_bazel_lib_dependencies")

aspect_bazel_lib_dependencies()

# Download the rules_docker repository at release v0.9.0
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "b1e80761a8a8243d03ebca8845e9cc1ba6c82ce7c5179ce2b295cd36f7e394bf",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.25.0/rules_docker-v0.25.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)
container_repositories()

# This is NOT needed when going through the language lang_image
# "repositories" function(s).
load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

load("//repositories:repositories.bzl", "repositories")

repositories()

load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)

container_pull(
  name = "nginx",
  registry = "eu.gcr.io",
  repository = "mm-cloudbuild/mysim/tomcat",
  digest = "sha256:b72b782acb1069b5ac5eda64251faa4879bd4a17e9364d8688ec0570f06ae3ff"
)
