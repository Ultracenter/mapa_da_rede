#!/bin/bash

. ./grafo.sh

_main()
{

        local tmp="/tmp/$RANDOM"

	_cabecalho >  $tmp
	    _corpo >> $tmp
	_rodape    >> $tmp

        local saida="$0.png"

	cat $tmp | $DOT -Tpng > $saida

	rm -f $tmp

        echo "Saida gerada em $saida"
}

_main



