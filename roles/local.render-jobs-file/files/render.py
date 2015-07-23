import jinja2
import yaml

with open('build.yaml', 'r') as f:
    cfg = yaml.load(f)

    with open('jobs.groovy.j2', 'r') as j:
        template = jinja2.Template(j.read())

    output = template.render(cfg=cfg)

    with open('jobs.groovy', 'w') as out_file:
        out_file.write(output)
