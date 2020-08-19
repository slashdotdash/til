# External resource module attribute

The [`@external_resource`](https://hexdocs.pm/elixir/Module.html#module-external_resource) module attribute is useful when a module depends on an external file. By setting this attribute any changes to the external file will cause the referencing module to be recompiled by Elixir.

> Sometimes a module embeds information from an external file. This attribute allows the module to annotate which external resources have been used.
>
> Tools like Mix may use this information to ensure the module is recompiled in case any of the external resources change.

An example usage might be if you do some compile-time processing on an external file.
