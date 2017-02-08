# ExParsingBenchmark

Benchmark testing between various Elixir parsing libraries

## Installation

Clone this repository. :-)

## Running

Run:

```sh
mix deps.get
mix bench
```

Example output of the bench:

```elixir
##### With input parse_datetime #####
Name                ips        average  deviation         median
ex_spirit      197.95 K        5.05 μs    ±14.40%        4.70 μs
combine         74.02 K       13.51 μs    ±45.34%       16.00 μs

Comparison:
ex_spirit      197.95 K
combine         74.02 K - 2.67x slower

##### With input parse_int_10 #####
Name                ips        average  deviation         median
ex_spirit      636.60 K        1.57 μs    ±24.06%        1.60 μs
combine        162.52 K        6.15 μs   ±124.15%     0.00000 μs

Comparison:
ex_spirit      636.60 K
combine        162.52 K - 3.92x slower
```
