INSTALLATION_TYPE=$1
EMAIL_DE=$2
EMAIL_US=$3


# DE
echo "Signin into GERMAN app store..."
mas signout
mas signin $EMAIL_DE --dialog

if [ "$INSTALLATION_TYPE" != "BASIC" ]; then
    echo ""
    echo "Installing DEFAULT apps for DE..."
    echo ""
    mas install 539883307 # LINE
    mas install 715768417 # Microsoft Remote Desktop
    mas install 409203825 # Numbers
    mas install 1116599239 # NordVPN
    mas install 409201541 # Pages
    mas install 425424353 # The Unarchiver
    mas install 497799835 # Xcode
fi

if [ "$INSTALLATION_TYPE" == "FULL" ]; then
    echo ""
    echo "Installing FULL apps for DE..."
    echo ""
    mas install 409183694 # Keynote
    mas install 928871589 # Noizio
    mas install 405399194 # Kindle
    mas install 1094255754 # Outbank
fi

# US
echo "Signin into US app store..."
mas signout
mas signin $EMAIL_US --dialog

mas install 443987910 # 1Password
if [ "$INSTALLATION_TYPE" != "BASIC" ]; then
    echo ""
    echo "Installing DEFAULT apps for US..."
    echo ""
    mas install 736189492 # Notability
fi

if [ "$INSTALLATION_TYPE" == "FULL" ]; then
    echo ""
    echo "Installing FULL apps for US..."
    echo ""
    mas install 1055511498 # Day One
fi
