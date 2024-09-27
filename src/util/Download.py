from src.util import Command, Temporal, Printing


def for_wget(url : str):
    make = Temporal.folder_exists(Temporal.FOLDER_TEMP)

    if make:
        Command.execute(f'wget {url} -P {Temporal.FOLDER_TEMP}')
        # Command.execute(f'curl -O --output-dir {Temporal.FOLDER_TEMP} {url}')

    if not make:
        Printing.warning("Se ha producido un error al crear la carpeta temporal")
        exit()