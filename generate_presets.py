#!/usr/bin/python3
import json
import os

if __name__ == '__main__':
    # generate globals file
    parent_folder = './ya-provider/'
    globals_path = './ya-provider/globals.json'
    hardware_path = './ya-provider/hardware.json'
    presets_path = './ya-provider/presets.json'

    if not os.path.exists(parent_folder):
        os.mkdir(parent_folder)

    with open(globals_path, 'w') as f:
        data = {
            'node_name': os.environ.get('NODE_NAME', 'node-name'),
            'subnet': os.environ.get('NODE_SUBNET', 'public-beta'),
            'account': os.environ.get('YA_ACCOUNT', 'null')
        }
        json.dump(data, f, indent=4)

    with open(hardware_path, 'w') as f:
        data = {
            'active': 'default',
            'profiles': {
                'default': {
                    'cpu_threads': int(os.environ.get('NODE_CPU_THREADS', 'null')),
                    'mem_gib': float(os.environ.get('NODE_MEM_GIB', 'null')),
                    'storage_gib': float(os.environ.get('NODE_STORAGE_GIB', 'null')),
                }
            }
        }
        json.dump(data, f, indent=4)

    # seems like lots of copy and paste but I want to keep it flexible
    with open(presets_path, 'w') as f:
        data = {
            'active': [
                'wasmtime',
                'vm'
            ],
            'presets': [
                {
                    'name': 'default',
                    'exeunit-name': 'wasmtime',
                    'pricing-model': 'linear',
                    'usage-coeffs': {
                        'initial': float(os.environ.get('NODE_COSTS_START', 0)),
                        'duration': float(os.environ.get('NODE_COSTS_HOUR', 0.02)) / 3600,
                        'cpu': float(os.environ.get('NODE_COSTS_CPU_HOUR', 0.1)) / 3600
                    }
                },
                {
                    'name': 'vm',
                    'exeunit-name': 'vm',
                    'pricing-model': 'linear',
                    'usage-coeffs': {
                        'initial': float(os.environ.get('NODE_COSTS_START', 0)),
                        'duration': float(os.environ.get('NODE_COSTS_HOUR', 0.02)) / 3600,
                        'cpu': float(os.environ.get('NODE_COSTS_CPU_HOUR', 0.1)) / 3600
                    }
                },
                {
                    'name': 'wasmtime',
                    'exeunit-name': 'wasmtime',
                    'pricing-model': 'linear',
                    'usage-coeffs': {
                        'initial': float(os.environ.get('NODE_COSTS_START', 0)),
                        'duration': float(os.environ.get('NODE_COSTS_HOUR', 0.02)) / 3600,
                        'cpu': float(os.environ.get('NODE_COSTS_CPU_HOUR', 0.1)) / 3600
                    }
                }
            ]
        }
        json.dump(data, f, indent=4)

        print('Node settings generated!')


