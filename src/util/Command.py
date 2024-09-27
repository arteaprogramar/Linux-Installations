import subprocess

from src.util import Printing


def execute(args: str, capture_output: bool = False, hidden_log : bool = False):
    """
    Este metodo nos permitira executar un comando en unix mediante python y obtener el resultado
    de la ejecución de ese comando
    :param capture_output:
    :param hidden_log:
    :param args:
    :return:
    """
    try:
        command = None

        if not hidden_log:
            Printing.title("Comando a ejecutar : ", False)
            Printing.subtitle(args)

        if capture_output:
            command = subprocess.run(
                args,
                shell=True,
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE
            )

        if not capture_output:
            subprocess.run(
                args,
                shell=True,
                check=True
            )

        if not hidden_log:
            if capture_output:
                Printing.title("Logs: ", False)
                print(command.stdout.decode("utf-8"))

        print("")

        if capture_output:
            return command.stdout.decode("utf-8").strip().split("\n")
        else:
            return "Ok"
    except Exception as exception:
        if not hidden_log:
            print(f"Se ha producido un error : ${exception}")
        return False