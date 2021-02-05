load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_VERSION_SHAS = {
    "2.17.0": {
        "linux": "f3bec3c7c55f6a9eb9e6586b8c503f370af92fe987fcbf741f37707606d70296",
        "darwin": "104dcda352985306d04d5d23aaf5252d00a85c083f3667fd013991d82f57ae83",
    },
    "2.16.12": {
        "linux": "756ab375314329b66b452c0f9d569f74b0760141670217c07b79890ad314c214",
        "darwin": "cd36888b5c89e0fb7f9f336e1e286773ad15e9a8fa16e3b8ef34b10347341cf4",
    },
    "2.14.1": {
        "linux": "804f745e6884435ef1343f4de8940f9db64f935cd9a55ad3d9153d064b7f5896",
        "darwin": "392ec847ecc5870a48a39cb0b8d13c8aa72aaf4365e0315c4d7a2553019a451c",
    },
}

def helm_repositories(version = "2.17.0"):
    if version not in _VERSION_SHAS:
        fail("unknown helm repository version {}, acceptable versions are {}".format(version, _VERSION_SHAS.keys()))

    if "bazel_skylib" not in native.existing_rules():
        skylib_version = "0.8.0"
        http_archive(
            name = "bazel_skylib",
            type = "tar.gz",
            url = "https://github.com/bazelbuild/bazel-skylib/releases/download/{}/bazel-skylib.{}.tar.gz".format(skylib_version, skylib_version),
            sha256 = "2ef429f5d7ce7111263289644d233707dba35e39696377ebab8b0bc701f7818e",
        )

    if "helm_linux" not in native.existing_rules():
        http_archive(
            name = "helm_linux",
            sha256 = _VERSION_SHAS[version]["linux"],
            urls = ["https://storage.googleapis.com/kubernetes-helm/helm-v{}-linux-amd64.tar.gz".format(version)],
            build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
        )

    if "helm_darwin" not in native.existing_rules():
        http_archive(
            name = "helm_darwin",
            sha256 = _VERSION_SHAS[version]["darwin"],
            urls = ["https://storage.googleapis.com/kubernetes-helm/helm-v{}-darwin-amd64.tar.gz".format(version)],
            build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
        )

    if "helm_tiller" not in native.existing_rules():
        http_archive(
            name = "helm_tiller",
            sha256 = "4eedad0433c6693ec83c282b459150d160c2d4ef9bd609d931449010afffd3e7",
            strip_prefix = "helm-tiller-0.8.1",
            urls = ["https://github.com/rimusz/helm-tiller/archive/v0.8.1.tar.gz"],
            build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
        )
