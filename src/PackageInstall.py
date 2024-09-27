import json
from src import Menu
from src.util import Printing, Command


def apply(instructions, manager: str):
    version = ''

    for instruction in instructions:
        Printing.title(instruction['action'], False)

        command = ''
        captured_output = instruction['required_output']
        require_menu = instruction['menu']

        if instruction['command'] is not None and instruction['command_alternative'] is None:
            command = instruction['command']

        if instruction['command'] is None and instruction['command_alternative'] is not None:
            command = instruction['command_alternative'][manager]

            if "{version}" in command:
                command = command.format(version=version)

        output = Command.execute(command, captured_output)

        if require_menu is not None:
            version = Menu.show(require_menu['name'], output)

        print()


def init(pkg, manager: str):
    Printing.title(pkg['name'])

    process = json.load(open(pkg['actions']))
    apply(process, manager)