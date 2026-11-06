# csc-core-containers

Core container images for Roihu: Rocky 9 base plus the CSC Spack core stack (compilers, MPI, CUDA) copied from `/appl`.

Layout: `roihu/<arch>/rocky9/oci/` (buildah, pushed to satama), `roihu/<arch>/rocky9/sif/` (apptainer), `roihu/<arch>/test/` (OSU and NCCL benchmarks, native and in-container).

Build on a Roihu node of the matching arch. Build the `*-deps` image first, because the others start from it:

```bash
cd roihu/x86_64/rocky9/oci
make core-cpu-deps
make core-cpu-gcc-15.2.0
```

Push (log in first, see below):

```bash
buildah push satama.csc.fi/r_installation_spack/core-cpu-gcc-15.2.0:v2026_03
```

## Notes

OS type

```bash
cat /etc/os-release
```

Query packages:

```bash
rpm -qa > rpm-$(hostname).txt
```

Query repositories:

```bash
dnf repolist --all
```

```bash
ls /etc/yum.repos.d
```

```bash
jq -r '.secret' "$CREDS" | podman login --password-stdin -u $(jq -r '.name' "$CREDS") satama.csc.fi
```
