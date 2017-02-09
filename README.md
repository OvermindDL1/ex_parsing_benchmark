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
ex_spirit      195.62 K        5.11 μs    ±15.99%        4.70 μs
combine         62.02 K       16.12 μs    ±41.23%       16.00 μs

Comparison:
ex_spirit      195.62 K
combine         62.02 K - 3.15x slower

##### With input parse_int_10 #####
Name                ips        average  deviation         median
ex_spirit      633.29 K        1.58 μs    ±25.00%        1.60 μs
combine        164.10 K        6.09 μs    ±12.04%        6.20 μs

Comparison:
ex_spirit      633.29 K
combine        164.10 K - 3.86x slower
```
