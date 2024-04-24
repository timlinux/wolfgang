#!/usr/bin/env bash
echo "🪛 Running Jupyter using Venv:"
echo "Switch the kernel to 'virtualenv'"
echo "after opening in its own window"
echo "--------------------------------"
python -m ipykernel install --user --name=virtualenv
jupyter kernelspec list
IP=$(ip addr | grep inet | grep -v inet6 | tail -1 | grep -o "inet [0-9\.]*" | sed 's/inet //g')
jupyter-lab --ip=${IP}
