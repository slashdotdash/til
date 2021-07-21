# Getting started with Julia

Install Julia with asdf:

```shell
asdf plugin-add julia https://github.com/rkyleg/asdf-julia.git
asdf list-all julia
asdf install julia <version>
asdf global julia <version>
```

## Jupyter notebook

Install Jupyter lab and notebook with `pip`:

```shell
pip install jupyterlab
pip install notebook
```

### Add Julia to Jupyter

```
$ julia
julia> import Pkg

julia> Pkg.add("IJulia")
```

Start Jupyter lab:

```shell
jupyter-lab
```

Start Jupyter notebook:

```shell
jupyter notebook
```
