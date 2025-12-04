#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"


install_required_software() {
    echo "$(eval_gettext "🔍 Vérification des logiciels requis...")"

    # List of required software (command:package)
    # If command == package, you can just repeat the name
    REQUIRED_SOFTWARE=(
        "lvm: lvm2"
        "quota: quota"
        "mkfs.ext4: e2fsprogs"   # mkfs.ext4 is in the e2fsprogs package
        "lsattr: libext2fs2"     # example: command in another package
    )

    # Function to check and install
    check_and_install() {
        local command_name="$1"
        local package_name="$2"

        if ! danger sudo which $command_name >/dev/null 2>&1; then
            echo -e "$(eval_gettext "\n❌ \$command_name (package: \$package_name) is not installed.")"
            echo -n "$(eval_gettext "Do you want to install \$package_name? [y/N]: ")"
            read choice < /dev/tty

            case "$choice" in
                y|Y )
                    if command -v apt-get >/dev/null 2>&1; then
                        danger sudo apt-get update && danger sudo apt-get install -y "$package_name"
                    elif command -v dnf >/dev/null 2>&1; then
                        danger sudo dnf install -y "$package_name"
                    elif command -v yum >/dev/null 2>&1; then
                        danger sudo yum install -y "$package_name"
                    elif command -v pacman >/dev/null 2>&1; then
                        danger sudo pacman -Sy --noconfirm "$package_name"
                    else
                        echo "$(eval_gettext "⚠️  Could not detect a supported package manager. Please install \$package_name manually.")"
                    fi
                    ;;
                * )
                    echo "$(eval_gettext "Skipping \$package_name.")"
                    return 1
                    ;;
            esac
        else
            echo "$(eval_gettext "✅ \$command_name is already installed.")"
        fi
    }

    # Loop through required software
    for entry in "${REQUIRED_SOFTWARE[@]}"; do
        command_name="${entry%%:*}"   # text before the colon
        package_name="${entry##*:}"   # text after the colon
        # Trim spaces if present
        command_name="$(echo "$command_name" | xargs)"
        package_name="$(echo "$package_name" | xargs)"
        check_and_install "$command_name" "$package_name"
    done
}


install_required_software

_mission_init() (

  lvm_init "01"
  return $?

)

_mission_init
