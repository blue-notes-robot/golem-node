## :information_source: Fork notes
This repo is a fork from [golem-node](https://github.com/alexandre-abrioux/golem-node), inspired by [scaleable-golem-provider](https://github.com/cryptobench/scaleable-golem-provider)

Why forked?
- I liked the convenience of the Makefile of [golem-node](https://github.com/alexandre-abrioux/golem-node) as well as their healthchecks but I also wanted the scalability introduced by [scaleable-golem-provider](https://github.com/cryptobench/scaleable-golem-provider)
- I like the idea of using preset files instead of a manual `golemsp settings` run from [scaleable-golem-provider](https://github.com/cryptobench/scaleable-golem-provider), but I wanted to leverable settings via environment variables
- I wanted the ability to test pre-release versions
- aiming to add more features in the future

Caveats?
- Currently only existing ETH addresses are allowed as the scalability makes managing local volumes (in which local wallets are stored) a bit tricky
- Also, stats are not persistent


#  Golem Provider Node :whale: Docker Image  
  
I recommend checking out the parent repos mentioned above for more general information.
  
## :information_source: Prerequisites (important)  
  
You need to have Docker as well as docker-compose installed.
Tested on Docker version 20.10.5 and docker-compose version 1.28.5.
Currently only works on Linux machines.
  
## :arrow_forward: Usage  
  
You can clone this repository or use the provided `docker-compose.yml` as a base template for your own setup.  
  
A `Makefile` is included for convenience and I highly recommend using it, as it also takes care if environment variable imports.
  
I recommend to use `make` or `make help` to list the available shortcuts.  
  
### 1. Environment Set Up  
  
Copy the `.env.presets` file to `.env` and edit to your preferences:

|Variable| Description |
|--|--|
| YA_PAYMENT_NETWORK 	    | mainnet or rinkeby                                                                       |
| NODE_SUBNET 			    | Which subnet to use                                                                      |
| NODE_NAME				    | Name you want to give your node                                                          |
| YA_ACCOUNT 			    | Your Ethereum wallet address you want to be paid to                                      |
| NODE_CPU_THREADS 		    | Number of cores you want to dedicate per node                                            |
| NODE_MEM_GIB 			    | Gigabytes of memory you want to allocate per node                                        |
| NODE_STORAGE_GIB 		    | Gigabytes of storage you want to allocate per node                                       |
| NODE_COSTS_START 		    | Set job starting cost, default: 0.0                                                      |
| NODE_COSTS_HOUR 		    | Set job running cost per hour, default: 0.02                                             |
| NODE_COSTS_CPU_HOUR 	    | Set job running cost per CPU hour, default: 0.1                                          |
| NODE_NUM 				    | Number of nodes/providers to run                                                         |
| NICENESS 				    | Set the providers nice-ness, see notes below, default: 0                                 |
| AUTOHEAL_CONTAINER_LABEL  | Which containers to autoheal, default: all                                               |
| AUTOHEAL_START_PERIOD     | Delay for autoheal. Should be same as the healthcheck interval. default: 300             |
| AUTOHEAL_INTERVAL         | Interval for autoheal. Default: 5                                                        |
| COMPOSE_PROJECT_NAME      | Changes the default docker-compose prefix for nicer container names, default: golem      |

What is niceness?
Niceness really is the niceness of a task. The nicer a task, the less important is makes itself, giving higher priority to other threads. This comes in handy if you run your provider on a computer you actually still want to be usable. In that case I recommend setting this to maximum niceness of 20.

:information_source: Note: Make sure your machine has enough resources to start your scaled server! That means your server should have at least:
- NODE_NUM x NODE_CPU_THREADS cores
- NODE_NUM x NODE_MEM_GIB memory
- NODE_NUM x NODE_STORAGE_GIB storage

### 2. Run the Node  

Run `make presets` on first start and whenever you have changed any of the settings in the .env file. 
If you don't you will be either running old settings, or the build will fail.

There is three ways you can start your node:
- `make upd` to start the node in a detached mode. No logs will be shown.
- `make upl` to additionally directly display the logs. Your node will continue working if you close your terminal.
- `make upt` to start your node in terminal mode. CTRL+C will stop your node.

Display the last logs at any time by running `make logs`.

Use
- `make shell` to enter the shell of a node.
- `make status` to get your node address and health.
- `make settings` to display your current node parameters. 
- `make clean` to clean the node's cache. 

By default, these commands will give results for the first node. 
If you are running more than one node you can add index=NUM to your command to address a different index.
Example: `make status index=2`


Get shell access to your first running container with `make shell`.  Here also this gives you only the shell of your first node. 
If you want the shell of a different node, use: `docker-compose exec --index=INDEX_NUM node bash` with the `INDEX_NUM` number of your choice.

To stop your node, run `make stop`.
