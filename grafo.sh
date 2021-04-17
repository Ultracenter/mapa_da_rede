#!/bin/bash

. ./util.sh

_cabecalho()
{

    echo "digraph g {" 

    echo "graph [ 
                  splines=true; 
                  rankdir=RL; 
                ];" 

    echo "node  [ 
                  shape=\"record\"; 
                  fillcolor=\"lightblue\"; 
                  style=\"rounded,filled\"; 
                  textcolor=black; 
                  fontname=\"Sans\"; 
                  fontsize=13; 
                ];" 

    echo "edge  [ 
                  penwidth=1; 
                  color=\"#bc5e00\"; 
                ] ;" 
}


_corpo()
{

    local arp="/tmp/$RANDOM"
    arp -a > $arp

    #local db="/tmp/$RANDOM"
    #$WGET http://standards-oui.ieee.org/oui/oui.txt --output-document=$db

    local db="oui.txt"

    local i
    local a

    local id
    local ip
    local hostname
    local mac
    local prefixo_mac
    local marca

    local x=1
    
    for i in `cat $arp | tr ' ' '^'`;
    do

        a=`echo $i | tr '^' ' '`
        #echo $a
    
        hostname=`echo $a | cut -d ' ' -f 1`
        #echo $hostname

        ip=`echo $a | cut -d '(' -f 2 | cut -d ')' -f 1`
        #echo $ip

        mac=`echo $a | cut -d ' ' -f 4`
        #echo $mac

        interface=`echo $a | cut -d ' ' -f 6`
        #echo $interface

        prefixo_mac=`echo $mac | tr ':' '-' | cut -c 1-8`
        #echo $prefixo_mac

        marca=`cat $db | grep "(hex)" | grep -i $prefixo_mac | tr ' ' '^' | tr '\t' '@' | cut -d '@' -f 3 | tr '^' ' '`
        #echo $marca 

        id=`_md5 $marca`
        
        echo "$id [ label=\"$marca\" shape=\"box\" color=\"black\" fillcolor=\"#FFF097\" ]" 

        echo "$x  [ label=\" $hostname | $ip | $mac\"]" 

        echo "\"$interface\" -> $id -> $x [ dir=back] " 

        ((x++))

    done

    #rm -f $db

}


_rodape()
{
    echo "}" 
}


