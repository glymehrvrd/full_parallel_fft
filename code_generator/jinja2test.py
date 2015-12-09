from jinja2 import Template, DictLoader, Environment

def testfilter(name,num):
    return 'this is '+name+" is yjs. num is "+str(num)

source="""
{{'5'+'6'|testfilter(3)}}
"""
env = Environment(
    loader=DictLoader({'index':source}), trim_blocks=True, lstrip_blocks=True)
env.filters['testfilter']=testfilter
print env.get_template('index').render()
