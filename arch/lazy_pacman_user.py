import os


def input_error_handler() -> int:
    while True:
        try:
            choice = int(input("Enter your choice: "))
        except ValueError:
            print("Invalid input. Try again")
        else:
            return choice


def entry_menu() -> int:
    print("\n")
    print("1. Package Installer")
    print("2. Package Un-installer")
    print("0. Exit")
    choice = input_error_handler()
    return choice


def pkg_installer() -> None:
    pkg_name = input("enter package name: ")
    os.system(f"sudo -S pacman -S --needed {pkg_name}")


def pkg_uninstaller() -> None:
    pkg_name = input("enter package name: ")
    os.system(f"sudo -S pacman -Rdd {pkg_name}")
    os.system("sudo -S pacman -R $(pacman -Qdtq)")


while True:
    choice_input = entry_menu()
    match choice_input:
        case 1:
            pkg_installer()
        case 2:
            pkg_uninstaller()
        case 0:
            print("Bye...")
            break
