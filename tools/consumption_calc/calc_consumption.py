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
    total_dff=0
    for k,v in data[item].iteritems():
        if k=='gate':
            total_gates+=v
        elif k=='dff':
            total_dff+=v
        else:
            g,d=calc(k, data)
            total_gates+=g*v
            total_dff+=d*v
    print '%s: %d,%d'%(item,total_gates,total_dff)
    return total_gates,total_dff

print calc('fft2048', data)