import os


def pkg_installer() -> None:
    pkg_name = input("enter package name: ")
    os.system(f"sudo -S pacman -S --needed {pkg_name}")
    print("Done...")


def pkg_uninstaller() -> None:
    pkg_name = input("enter package name: ")
    os.system(f"sudo -S pacman -R {pkg_name}")
    os.system("sudo -S pacman -R --noconfirm $(pacman -Qdtq)")
    print("Done...")


def pkg_search() -> None:
    pkg_keyword = input("enter search keyword: ")
    os.system(f"sudo -S pacman -Ss {pkg_keyword}")


def full_system_upgrade() -> None:
    os.system(f"sudo -S pacman -Syu")
    print("Done...")


def input_error_handler() -> int:
    while True:
        try:
            choice = int(input("Enter your choice: "))
        except ValueError:
            print("Invalid input. Try again")
        else:
            return choice


def list_menu() -> int:
    print("\n")
    print("1. Package Installer")
    print("2. Package Un-installer")
    print("3. Package Search")
    print("4. Full system upgrade")
    print("0. Exit")
    choice = input_error_handler()
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
                case 0:
                    print("Bye...")
                    break
    except KeyboardInterrupt:
        print("\nBye...")


if __name__ == "__main__":
    navigation()
