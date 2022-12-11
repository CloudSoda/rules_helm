load("//helpers:helpers.bzl", "write_sh", "get_make_value_or_default")
load("@aspect_bazel_lib//lib:stamping.bzl", "STAMP_ATTRS", "maybe_stamp")

def runfile(ctx, f):
  """Return the runfiles relative path of f."""
  if ctx.workspace_name:
    return ctx.workspace_name + "/" + f.short_path
  else:
    return f.short_path

def _gcs_upload_impl(ctx):
    """Push an artifact to Google Cloud Storage
    Args:
        name: A unique name for this rule.
        src: Source file to upload.
        destination: Destination. Example: gs://my-bucket/file
    """

    src_file = ctx.file.src

    # get chart museum basic auth credentials
    destination = ctx.attr.destination

    exec_file = ctx.actions.declare_file(ctx.label.name + "_gcs_upload_bash")

    stamp = maybe_stamp(ctx)
    stamp_files = [stamp.volatile_status_file, stamp.stable_status_file] if stamp else []

    # Generates the exec bash file with the provided substitutions
    ctx.actions.expand_template(
        template = ctx.file._script_template,
        output = exec_file,
        is_executable = True,
        substitutions = {
            "{SRC_FILE}": src_file.short_path,
            "{DESTINATION}": destination,
            "%{stamp_statements}": "\n".join([
              "read_variables %s" % runfile(ctx, f)
              for f in stamp_files]),
        }
    )




    runfiles = ctx.runfiles(
        files = stamp_files + [src_file]
    )

    return [DefaultInfo(
      executable = exec_file,
      runfiles = runfiles,
    )]

gcs_upload = rule(
    implementation = _gcs_upload_impl,
    attrs = dict({
      "src": attr.label(allow_single_file = True, mandatory = True),
      "destination": attr.string(mandatory = True),
      "_script_template": attr.label(allow_single_file = True, default = ":gcs-upload.sh.tpl"),
    }, **STAMP_ATTRS),
    doc = "Upload a file to a Google Cloud Storage Bucket",
    toolchains = [],
    executable = True,
)
