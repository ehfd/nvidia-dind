# NVIDIA DinD (Docker in Docker) Container

Based on https://github.com/cruizba/ubuntu-dind

Isolated DinD (Docker in Docker) container for developing and deploying Docker containers using NVIDIA GPUs and the NVIDIA container toolkit. Useful for deploying the Docker engine with NVIDIA in Kubernetes.

Host is required to have the NVIDIA container toolkit installed and set up. Privileged mode or [Sysbox](https://github.com/nestybox/sysbox) configured with NVIDIA GPUs are required like any other DinD container with root requirement.

```bash
docker run --gpus 1 -it --privileged ghcr.io/ehfd/nvidia-dind:latest
```
