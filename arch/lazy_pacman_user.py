import os


try:
    from clint.textui import colored
except ModuleNotFoundError:
    print("\nDependency missing! Installing...\n")
    os.system("sudo -S pacman -S --needed --noconfirm python-pip")
    os.system("pip install clint")
    from clint.textui import colored


def orphan_pkg_remove_choice_input_handler() -> bool:
    while True:
        input_choice = input(
            "Do you want to uninstall orphan packages? (y/n): "
        ).lower()
        if input_choice not in ("y", "n"):
            print(colored.red("Invalid input. Try again."))
        else:
            return True if input_choice == "y" else False


def list_menu_input_handler() -> int:
    while True:
        try:
            choice = int(input("Enter your choice: "))
        except ValueError:
            print(colored.red("Invalid input. Try again"))
        else:
            return choice


def pkg_installer() -> None:
    pkg_name = input("enter package name: ")
    os.system(f"sudo -S pacman -S --needed {pkg_name}")
    print(colored.blue("DONE..."))


def pkg_uninstaller() -> None:
    pkg_name = input("enter package name: ")
    os.system(f"sudo -S pacman -R {pkg_name}")
    orphan_pkg_view()


def orphan_pkg_view() -> None:
    result = os.popen("pacman -Qdt").read()
    if result == "":
        print(colored.blue("No orphan package found"))
        print(colored.blue("DONE..."))
    else:
        uninstall_choice = orphan_pkg_remove_choice_input_handler()
        if uninstall_choice:
            orphan_pkg_remove()


def orphan_pkg_remove() -> None:
    os.system("sudo -S pacman -R --noconfirm $(pacman -Qdtq)")
    print(colored.blue("DONE..."))


def pkg_search() -> None:
    pkg_keyword = input("enter search keyword: ")
    os.system(f"pacman -Ss {pkg_keyword}")


def full_system_upgrade() -> None:
    os.system(f"sudo -S pacman -Syu")
    print(colored.blue("DONE..."))


def list_menu() -> int:
    print("\n")
    print(colored.green("1. Package Installer"))
    print(colored.green("2. Package Un-installer"))
    print(colored.green("3. Package Search"))
    print(colored.green("4. Full system upgrade"))
    print(colored.green("5. Manage Orphan packages"))
    print(colored.red("0. Exit"))
    choice = list_menu_input_handler()
    return choice


def navigation() -> None:
    try:
        while True:
            choice_input = list_menu()
            match choice_input:
                case 1:
                    pkg_installer()
                case 2:
                    pkg_uninstaller()
                case 3:
                    pkg_search()
                case 4:
                    full_system_upgrade()
                case 5:
                    orphan_pkg_view()
                case 0:
                    print(colored.blue("\nBYE..."))
                    break
    except KeyboardInterrupt:
        print(colored.blue("\nBYE..."))


if __name__ == "__main__":
    navigation()
