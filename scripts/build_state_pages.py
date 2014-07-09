from jinja import Environment, FileSystemLoader


env = Environment(loader=FileSystemLoader('templates'))
template = env.get_template('state.html')
print template.render(states=[])
