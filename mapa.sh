#!/bin/bash

tmp="/tmp/$RANDOM"
saida="/tmp/$RANDOM"
imagem="saida.png"

_cabecalho()
{
    
    echo "digraph g {" > $saida

    echo "graph [ 
                  splines=true; 
                  rankdir=RL; 
                ];" >> $saida

    echo "node  [ 
                  shape=\"record\"; 
                  fillcolor=\"lightblue\"; 
                  style=\"rounded,filled\"; 
                  textcolor=black; 
                  fontname=\"Sans\"; 
                  fontsize=13; 
                ];" >> $saida

    echo "edge  [ 
                  penwidth=1; 
                  color=\"#bc5e00\"; 
                ] ;" >> $saida
}

_rodape()
{
    echo "}" >> $saida
}

# Gera MD5 de uma string

_md5()
{
    local texto=$1
    local prog="md5"

    u=`uname`
    
    if [ "$u" == "Linux" ]
    then
        prog="md5sum"
    fi

    local tmp="/tmp/$RANDOM"

    echo "$texto" > $tmp
    
    local saida=`$prog $tmp | tr [a-z 1-9]`

    rm -f $tmp

    local retorno=""

    if [ "$u" == "Linux" ]
    then
        retorno=`echo $saida | cut -d ' ' -f 1`
    else
        retorno=`echo $saida | cut -d ' ' -f 4`
    fi

    echo $retorno
}


_corpo()
{
    arp -a > $tmp

    local al
    local ip
    local hostname
    local mac
    local prefixo_mac
    local marca
    local md5_marca

    x=1

    for i in `cat $tmp | tr ' ' '^'`;
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

        marca=`cat maclist.txt | grep "(hex)" | grep -i $prefixo_mac | tr ' ' '^' | tr '\t' '@' | cut -d '@' -f 3 | tr '^' ' '`
        #echo $marca 

        md5_marca=`_md5 $marca`
        
        echo "$md5_marca [ label=\"$marca\" shape=\"box\" color=\"black\" fillcolor=\"#FFF097\" ]"  >> $saida

        echo "$x [ label=\" $hostname | $ip | $mac\"]"  >> $saida

        echo "$interface -> $md5_marca -> $x [ dir=back] " >> $saida

        ((x++))

    done

    rm -f $tmp
}


_cabecalho
    _corpo
_rodape

cat $saida | dot -Tpng > $imagem

rm -f $saida



