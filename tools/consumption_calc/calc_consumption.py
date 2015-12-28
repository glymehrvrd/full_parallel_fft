import json

with open('data.json') as f:
    data=json.load(f)

def memo(func):
    cache={}
    def _dec(item,data):
        if not cache.has_key(item):
            cache[item]=func(item, data)
        return cache[item]
    return _dec

@memo
def calc(item,data):
    total_gates=0
    for k,v in data[item].iteritems():
        if k=='gate':
            total_gates+=v
        else:
            g=calc(k, data)
            total_gates+=g*v
    print '%s: %d'%(item,total_gates)
    return total_gates

calc('total', data)