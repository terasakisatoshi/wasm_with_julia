from wasmer import Instance

def run_wasm(*args):
    wasm_bytes = open("twice.wasm", 'rb').read()
    instance = Instance(wasm_bytes)
    res = instance.exports.twice(*args)
    return res
