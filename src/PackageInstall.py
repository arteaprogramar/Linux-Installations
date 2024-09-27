import json
from src import Menu
from src.util import Printing, Command, Download, Temporal

def init(pkg, manager: str):
    Printing.title(pkg['name'])

    process = json.load(open(pkg['actions']))
    apply(process, manager)
    Temporal.folder_delete(Temporal.FOLDER_TEMP)


def apply(instructions, manager: str):
    version = ''

    for instruction in instructions:
        Printing.title(instruction['action'], False)

        output = None
        command = None
        captured_output = instruction['required_output']
        extra = instruction['extra']
        warning = instruction['warning']

        # Mostrar mensaje de advertencia
        if warning is not None:
            Printing.warning(warning, True)

        # Comando
        if instruction['command'] is not None and instruction['command_alternative'] is None:
            command = instruction['command']

        # Comando alternativo
        if instruction['command'] is None and instruction['command_alternative'] is not None:
            command = instruction['command_alternative'][manager]

        # Ejecutar el comando cuando sea necesario
        if command is not None:
            # Si se trata de un comando para manipular versiones
            if "{version}" in command:
                command = command.format(version=version)

            output = Command.execute(command, captured_output)

        # Acciones extras
        if extra is not None:

            # Permite descargar archivos
            if extra['name'] == '--download':

                if "{version}" in extra['param']:
                    Download.for_wget(extra['param'].format(version=version))
                else:
                    Download.for_wget(extra['param'])

            # Permite validar si existe un paquete
            elif extra['name'] == '--pkg-exists':

                if not isinstance(output, list):
                    Printing.warning("Se requiere una dependencia que no existe en su Sistema")
                    exit()

            # Muestra un un menu de opciones
            else:
                version = Menu.show(extra['name'], output)

        print()
