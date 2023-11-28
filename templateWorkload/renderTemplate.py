import argparse
import os
import yaml
from jinja2 import Environment, FileSystemLoader

def render_template(template_file, context):
    env = Environment(loader=FileSystemLoader(os.path.dirname(template_file)), autoescape=True)
    template = env.get_template(os.path.basename(template_file))
    rendered_output = template.render(context)
    rendered_data = yaml.safe_load(rendered_output)
    return rendered_data

def save_rendered_yaml(rendered_data, output_file):
    with open(output_file, "w") as file:
        yaml.dump(rendered_data, file, default_flow_style=False)

def parse_arguments():
    parser = argparse.ArgumentParser(description='Render Jinja template and save as YAML. Example command with values:\n\n'
                                     'python3 renderTemplate.py \\\n'
                                     '  --hostnames "custom-hostname" \\\n'
                                     '  --kafkaHostnames "kafka-host-1,kafka-host-2,kafka-host-3" \\\n'
                                     '  --userCount "5000000" \\\n'
                                     '  --tpMs "100" \\\n'
                                     '  --durationSeconds "3600" \\\n'
                                     '  --missingRatio "1000000" \\\n'
                                     '  --dupRatio "500000" \\\n'
                                     '  --lateRatio "200000" \\\n'
                                     '  --dateis1970Ratio "100000" \\\n'
                                     '  --offset "300000" \\\n'
                                     '  --userkafkaflag "0" \\\n'
                                     '  --kafkaPort "9092" \\\n'
                                     '  --maxActiveSessions "300"',
                                     formatter_class=argparse.RawTextHelpFormatter)
    # Add all variables from configMap with default=None
    parser.add_argument('--hostnames', default=None, help='Specify hostnames value')
    parser.add_argument('--kafkaHostnames', default=None, help='Specify kafkaHostnames value')
    parser.add_argument('--userCount', default=None, help='Specify userCount value')
    parser.add_argument('--tpMs', default=None, help='Specify tpMs value')
    parser.add_argument('--durationSeconds', default=None, help='Specify durationSeconds value')
    parser.add_argument('--missingRatio', default=None, help='Specify missingRatio value')
    parser.add_argument('--dupRatio', default=None, help='Specify dupRatio value')
    parser.add_argument('--lateRatio', default=None, help='Specify lateRatio value')
    parser.add_argument('--dateis1970Ratio', default=None, help='Specify dateis1970Ratio value')
    parser.add_argument('--offset', default=None, help='Specify offset value')
    parser.add_argument('--userkafkaflag', default=None, help='Specify userkafkaflag value')
    parser.add_argument('--kafkaPort', default=None, help='Specify kafkaPort value')
    parser.add_argument('--maxActiveSessions', default=None, help='Specify maxActiveSessions value')

    return parser.parse_args()

if __name__ == "__main__":
    args = parse_arguments()

    # Assuming the template file is in the same directory as the script
    template_file_path = "configMap.j2"
    output_file_path = "rendered_configMap.yaml"

    template_context = vars(args)

    rendered_data = render_template(template_file_path, template_context)
    save_rendered_yaml(rendered_data, output_file_path)

    print(f"Rendered YAML saved to {output_file_path}")
