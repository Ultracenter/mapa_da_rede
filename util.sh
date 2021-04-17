#!/bin/bash


if [ `uname` == "FreeBSD" ]
then
    DMIDECODE="/usr/local/sbin/dmidecode" 		
    MD5="/sbin/md5"
    WGET="/usr/local/bin/wget"
    LINKS="/usr/local/bin/links"
    DOT="/usr/local/bin/dot"
else
    DMIDECODE="/usr/sbin/dmidecode"
    MD5="/usr/bin/md5sum"
    WGET="/usr/bin/wget"
    LINKS="/usr/bin/links"
    DOT="/usr/bin/dot"
fi


_requisito()
{
	if [ ! -e $1 ]
	then
		echo "Este programa requer $1"
		exit
	fi
}


_requisito $MD5
_requisito $WGET
_requisito $DOT


_md5()
{

    local texto=$1

    local tmp="/tmp/$RANDOM"

    echo "$texto" > $tmp
    
    local tmp2=`$MD5 $tmp | tr [a-z 1-9]`

    rm -f $tmp

    local retorno=""

    if [ `uname` == "Linux" ]
    then
        retorno=`echo $tmp2 | cut -d ' ' -f 1`
    else
        retorno=`echo $tmp2 | cut -d ' ' -f 4`
    fi

    echo $retorno
}



