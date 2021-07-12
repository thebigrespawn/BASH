#!/bin/bash
#this script automatically installs VSFTPD server
# main(){
#     while true 
#     do
#         menu_vsftpd
#     done
# }

SETTINGS_LO="/home/x/Desktop/BASH/"
SETTINGS_FILE="testconfig.txt"
SETTINGS_LOC=${SETTINGS_LO}${SETTINGS_FILE}


backup_manager(){
BACKUP_FOLDER="BACKconf/"
BACKLOG_FILE="BACKlog.txt"
    case $1 in 
    create)
        while read -p " Do you want to make a backup of current settings? [y/n] 
>" DEF
        do
            case $DEF in 
                y)  
                    read -p "insert name for your backup file" N
                    echo "your settings are backed up as ----${N}BACK${SETTINGS_FILE}----"
                    [ -d "${SETTINGS_LO}${BACKUP_FOLDER}" ] || sudo mkdir "${SETTINGS_LO}${BACKUP_FOLDER}"
                    echo "${SETTINGS_LO}${N}BACK${SETTINGS_FILE}" >> "${SETTINGS_LO}${BACKUP_FOLDER}${BACKLOG_FILE}"
                    cp ${SETTINGS_LOC} "${SETTINGS_LO}${BACKUP_FOLDER}${N}BACK${SETTINGS_FILE}"
                    ;;
                n)
                    echo "Okay, no backup"
                    ;;
                *)
                    echo "insert valid settings"
                    continue
                    ;;
            esac
        break
        done
    delete)
        while cat "${SETTINGS_LO}${BACKUP_FOLDER}${BACKLOG_FILE}" & read -p "insert name of backup you want to delete 
> " DEL
        do
            if [ -e "${SETTINGS_LO}${BACKUP_FOLDER}${DEL}BACK${SETTINGS_FILE}"]
            then
                rm "${SETTINGS_LO}${BACKUP_FOLDER}${DEL}BACK${SETTINGS_FILE}"
                sed -i /"${DEL}BACK${SETTINGS_FILE}"/d "${SETTINGS_LO}${BACKUP_FOLDER}${BACKLOG_FILE}"
            else 
                echo "there is no such backup"
                continue
            fi
        break
        done
        ;;


    esac    
}


settings_backup(){
    while read -p " Do you want to make a backup of current settings? [y/n] 
>" DEF
    do
        case $DEF in 
            y)  
                read -p "insert name for your backup file" N
                echo "your settings are backed up as ---${N}BACK.vsftpd.config----"
                manage_backups $N
                cp $SETTINGS_LOC $SETTINGS_LO"BACKconf/"${N}"BACK"${SETTINGS_FILE}
                ;;
            n)
                echo "Okay, no backup"
                ;;
            *)
                echo "insert valid settings"
                continue
                ;;
        esac
    break
    done


}


menu_vsftpd(){ #menu for vsftpd installation
        echo "
        Welcome to the vsftpd installer!
        
        "
    while true
    do
        echo "PLEASE CHOOSE WHAT YOU WANT TO DO"
        echo "1 - install default vsftpd without configuration"
        echo "2 - install with manual configuration"
        echo "3 - install express with common settings"
        echo "4 - apply config file from path or backup"
        echo "5 - open vsftpd CONFIG"
        echo "6 - check vsftpd STATUS"
        echo "7 - turn vsftpd ON"
        echo "8 - turn vsftpd OFF"
        echo "clean - delete all backups"
        echo "reset - RESET vsftpd config file"
        echo "delete - delete vsftpd from machine"
        echo "q - quit installer
        "
        read -p "> " MENU
        echo "
        
        "

        case $MENU in
            1)
                vsftpd_manager "check"
                ;;
            2)
                vsftpd_manager "check"
                manual_settings ${SETTINGS_LOC}
                vsftpd_manager "turnon"
                vsftpd_manager "status"
                echo "Going back to menu"
                sleep 1
                ;;

            3)
                vsftpd_manager "check"
                default_settings ${SETTINGS_LOC}
                vsftpd_manager "turnon"
                vsftpd_manager "status"
                echo "Going back to menu"
                sleep 1
                ;;
            4)  settings_manager
                ;;
            5)
                manual_settings ${SETTINGS_LOC}
                echo "Going back to menu"
                sleep 1
                ;;
            6)
                vsftpd_manager "status"
                echo "Going back to menu"
                sleep 1
                ;;
            
            7)
                vsftpd_manager "turnon"
                echo "Going back to menu"
                sleep 1
                ;;
            8)
                vsftpd_manager "turnoff"
                echo "Going back to menu"
                sleep 1
                ;;
            q)
                break
                ;;
            reset)
                reset_settings ${SETTINGS_LOC}
                echo "Going back to menu"
                sleep 1
                ;;
            *)
                echo "
                PROVIDE VALID OPTION !
                "
                continue
                ;;


        esac
    done 
}


reset_settings(){ #resets vsftpd settings SPECIFY CONFIG PATH

settings_backup

echo "# Example config file /etc/vsftpd.conf
#
# The default compiled in settings are fairly paranoid. This sample file
# loosens things up a bit, to make the ftp daemon more usable.
# Please see vsftpd.conf.5 for all compiled in defaults.
#
# READ THIS: This example file is NOT an exhaustive list of vsftpd options.
# Please read the vsftpd.conf.5 manual page to get a full idea of vsftpd's
# capabilities.
#
# Allow anonymous FTP? (Beware - allowed by default if you comment this out).
anonymous_enable=YES
#
# Uncomment this to allow local users to log in.
#local_enable=YES
#
# Uncomment this to enable any form of FTP write command.
#write_enable=YES
#
# Default umask for local users is 077. You may wish to change this to 022,
# if your users expect that (022 is used by most other ftpd's)
#local_umask=022
#
# Uncomment this to allow the anonymous FTP user to upload files. This only
# has an effect if the above global write enable is activated. Also, you will
# obviously need to create a directory writable by the FTP user.
#anon_upload_enable=YES
#
# Uncomment this if you want the anonymous FTP user to be able to create
# new directories.
#anon_mkdir_write_enable=YES
#
# Activate directory messages - messages given to remote users when they
# go into a certain directory.
dirmessage_enable=YES
#
# Activate logging of uploads/downloads.
xferlog_enable=YES
#
# Make sure PORT transfer connections originate from port 20 (ftp-data).
connect_from_port_20=YES
#
# If you want, you can arrange for uploaded anonymous files to be owned by
# a different user. Note! Using 'root' for uploaded files is not
# recommended!
#chown_uploads=YES
#chown_username=whoever
#
# You may override where the log file goes if you like. The default is shown
# below.
#xferlog_file=/var/log/vsftpd.log
#
# If you want, you can have your log file in standard ftpd xferlog format.
# Note that the default log file location is /var/log/xferlog in this case.
#xferlog_std_format=YES
#
# You may change the default value for timing out an idle session.
#idle_session_timeout=600
#
# You may change the default value for timing out a data connection.
#data_connection_timeout=120
#
# It is recommended that you define on your system a unique user which the
# ftp server can use as a totally isolated and unprivileged user.
#nopriv_user=ftpsecure
#
# Enable this and the server will recognise asynchronous ABOR requests. Not
# recommended for security (the code is non-trivial). Not enabling it,
# however, may confuse older FTP clients.
#async_abor_enable=YES
#
# By default the server will pretend to allow ASCII mode but in fact ignore
# the request. Turn on the below options to have the server actually do ASCII
# mangling on files when in ASCII mode.
# Beware that on some FTP servers, ASCII support allows a denial of service
# attack (DoS) via the command 'SIZE /big/file' in ASCII mode. vsftpd
# predicted this attack and has always been safe, reporting the size of the
# raw file.
# ASCII mangling is a horrible feature of the protocol.
#ascii_upload_enable=YES
#ascii_download_enable=YES
#
# You may fully customise the login banner string:
#ftpd_banner=Welcome to blah FTP service.
#
# You may specify a file of disallowed anonymous e-mail addresses. Apparently
# useful for combatting certain DoS attacks.
#deny_email_enable=YES
# (default follows)
#banned_email_file=/etc/vsftpd.banned_emails
#
# You may specify an explicit list of local users to chroot() to their home
# directory. If chroot_local_user is YES, then this list becomes a list of
# users to NOT chroot().
# (Warning! chroot'ing can be very dangerous. If using chroot, make sure that
# the user does not have write access to the top level directory within the
# chroot)
#chroot_local_user=YES
#chroot_list_enable=YES
# (default follows)
#chroot_list_file=/etc/vsftpd.chroot_list
#
# You may activate the '-R' option to the builtin ls. This is disabled by
# default to avoid remote users being able to cause excessive I/O on large
# sites. However, some broken FTP clients such as 'ncftp' and 'mirror' assume
# the presence of the '-R' option, so there is a strong case for enabling it.
#ls_recurse_enable=YES
#
# When 'listen' directive is enabled, vsftpd runs in standalone mode and
# listens on IPv4 sockets. This directive cannot be used in conjunction
# with the listen_ipv6 directive.
listen=YES
#
# This directive enables listening on IPv6 sockets. To listen on IPv4 and IPv6
# sockets, you must run two copies of vsftpd with two configuration files.
# Make sure, that one of the listen options is commented !!
#listen_ipv6=YES" > ${1}
echo "
SETTINGS ARE RESETED
"
}


manual_settings(){ #encapsulated manual settings
echo "Manual settings are going to be applied"
    settings_backup
    sleep 1
    sudo gedit $1
while read -p "Are you done your manual settings? 
> " CONFIRMATION
do
    case $CONFIRMATION in 
    y) 
        echo "
        Okay let's continue"
        ;;
    n)  
        echo "
        Going back to gedit"
        sleep 1
        sudo gedit $1
        continue
        ;;

    *) 
        echo "
        please insert 'y' or 'n'"
        continue
        ;;
    esac
    break
done 
}



default_settings(){ #use common settings with vsftpd
echo "Default settings are going to be applied"
settings_backup
sleep 2
echo "Your default settings are applied to the file $1

"

while read -p "Please specify port range for this server
> " LOW HIGH
do
    if [ $HIGH -gt $LOW ] && [ $HIGH -lt 65535 ]
    then 
    echo "Bounds are ${LOW}, to ${HIGH}"
    else 
    echo "invalid values, please retry"
    continue
    fi
    break
done  

echo "listen=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=Yes
pasv_enable=Yes
pasv_min_port=${LOW}
pasv_max_port=${HIGH}
allow_writeable_chroot=YES
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO" > ${1} #-----------------Edit it to the real path at the end of testing-----------------    
sudo ufw allow 20/tcp
sudo ufw allow 21/tcp
# sudo ufw allow $LOW:$HIGH/tcp #here is firewall port regarding rules

echo "

Your default settings are applied to the file $1

"
}


vsftpd_manager(){
    case $1 in 
    check)
        echo "Lets check whether you have VSFTPD"
        [ -e /etc/vsftpd.conf ] && echo "vsftpd is alredy here" || ( echo "installing vsftpd" & sudo apt install vsftpd)
        ;;
    status)
        sudo systemctl status vsftpd.service
        ;;
    turnon)
        sudo systemctl enable vsftpd.service
        sudo systemctl start vsftpd.service
        sudo systemctl restart vsftpd.service
        ;;
    turnoff)
        sudo systemctl stop vsftpd.service
        sudo systemctl disable vsftpd.service
        ;;
    esac
}

#-------------------------------------------------------------MAIN-----------------------------------------------------------
menu_vsftpd
