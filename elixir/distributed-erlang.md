# Distributed Erlang

> Good for control plane, not so good for data plane.

- Sending large data can cause busy distribution ports and head-of-line blocking.
- Use TCP, UDP, etc. directly for data plane traffic.
- Don't mix control plane and data plane traffic.

See: [Implementing Riak in Erlang: Benefits and Challenges](http://gotocon.com/dl/goto-chicago-2014/Web/vinoski-impl-riak-erlang.pdf)
